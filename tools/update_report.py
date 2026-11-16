"""Check pinned archives and discover upstream updates without editing the catalogue."""

import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys
from tempfile import TemporaryDirectory


REPO = Path(__file__).resolve().parents[1]


def content(url):
    # Windows curl uses the system trust store for HTTPS.
    result = subprocess.run(
        ["curl.exe", "--fail", "--silent", "--show-error", "--location",
         "--proto", "=https", "--proto-redir", "=https", "--connect-timeout", "10",
         "--max-time", "25", "--user-agent", "BestClassicWB-catalogue", url],
        capture_output=True,
    )
    if result.returncode:
        error = result.stderr.decode("utf-8", errors="replace").strip()
        raise OSError(f"{url}: {error}")
    return result.stdout


def checksum(data):
    return hashlib.sha256(data).hexdigest()


def catalogue():
    return {
        path.stem: json.loads(path.read_text(encoding="utf-8"))
        for path in sorted((REPO / "packages").glob("*.json"))
    }


def save_archive(directory, filename, data, expected):
    if Path(filename).name != filename or filename in ("", ".", ".."):
        raise ValueError(f"Invalid archive name: {filename}")
    if checksum(data) != expected:
        raise ValueError(f"Checksum mismatch: {filename}")
    directory.mkdir(parents=True, exist_ok=True)
    destination = directory / filename
    if destination.exists():
        if checksum(destination.read_bytes()) != expected:
            raise FileExistsError(f"A different local archive already exists: {destination}")
        return
    with TemporaryDirectory(dir=directory) as stage:
        temporary = Path(stage) / filename
        temporary.write_bytes(data)
        temporary.rename(destination)


def fetch_pinned(packages, directory):
    for package in packages.values():
        for filename, source in package["archives"].items():
            destination = directory / filename
            data = destination.read_bytes() if destination.exists() else content(source["url"])
            save_archive(directory, filename, data, source["sha256"])
            print(f"Verified {filename}")


def version_tuple(text):
    normalized = text.removeprefix("v")
    if not re.fullmatch(r"[0-9]+(?:\.[0-9]+)+", normalized):
        return None
    return tuple(int(part) for part in normalized.split("."))


def github_update(package, candidates):
    source = package["updates"]
    url = f"https://api.github.com/repos/{source['repository']}/releases/latest"
    release = json.loads(content(url))
    tag = release["tag_name"]
    pinned, observed = version_tuple(package["version"]), version_tuple(tag)
    result = {
        "source": url, "release": release.get("html_url"), "observedVersion": tag,
        "status": "version_unverified",
    }
    if pinned is None or observed is None:
        return result
    result["status"] = "newer_release" if observed > pinned else "same_version" if observed == pinned else "older_release"
    if result["status"] != "newer_release":
        return result
    assets = [entry for entry in release["assets"] if re.fullmatch(source["assetPattern"], entry["name"])]
    if len(assets) != 1:
        result["status"] = "candidate_asset_ambiguous"
        return result
    asset = assets[0]
    digest = asset.get("digest")
    result["candidate"] = {
        "filename": asset["name"], "url": asset["browser_download_url"],
        "publisherDigest": digest,
    }
    if candidates is not None:
        data = content(asset["browser_download_url"])
        if len(data) != asset["size"]:
            raise ValueError(f"Unexpected download size: {asset['name']}")
        local_sha = checksum(data)
        if digest is not None and digest != "sha256:" + local_sha:
            raise ValueError(f"Publisher digest mismatch: {asset['name']}")
        save_archive(candidates, asset["name"], data, local_sha)
        result["candidate"]["downloadedSha256"] = local_sha
        result["candidate"]["validation"] = (
            "publisher_digest_matched" if digest else "checksum_calculated_locally"
        )
    return result


def audit_package(package, candidates):
    report = {"pinnedVersion": package["version"], "pinnedArchives": {}}
    for filename, source in package["archives"].items():
        entry = {"url": source["url"], "pinnedSha256": source["sha256"]}
        try:
            current = checksum(content(source["url"]))
            entry["observedSha256"] = current
            entry["status"] = "same_archive" if current == source["sha256"] else "archive_changed"
        except OSError as error:
            entry.update(status="source_unavailable", detail=str(error))
        report["pinnedArchives"][filename] = entry
    if "updates" in package:
        try:
            report["discovery"] = github_update(package, candidates)
        except (OSError, ValueError, KeyError) as error:
            report["discovery"] = {"status": "check_failed", "detail": str(error)}
    else:
        report["discovery"] = {"status": "pinned_archive_check_only"}
    return report


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    fetch = commands.add_parser("fetch-pinned")
    fetch.add_argument("--archives", type=Path, required=True)
    report = commands.add_parser("report")
    report.add_argument("--output", type=Path)
    report.add_argument("--candidates", type=Path)
    args = parser.parse_args()
    packages = catalogue()
    try:
        if args.command == "fetch-pinned":
            fetch_pinned(packages, args.archives)
        else:
            result = {key: audit_package(package, args.candidates) for key, package in packages.items()}
            text = json.dumps(result, indent=2) + "\n"
            if args.output is None:
                print(text, end="")
            else:
                args.output.parent.mkdir(parents=True, exist_ok=True)
                args.output.write_text(text, encoding="utf-8")
                print(f"Update report: {args.output}")
    except (OSError, ValueError, KeyError) as error:
        print(error, file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
