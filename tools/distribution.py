"""Rebuild and verify a local BestClassicWB 2.1.12 installation."""

import argparse
from copy import copy
import hashlib
import json
from pathlib import Path
import subprocess
import sys
from tempfile import TemporaryDirectory
from zipfile import ZipFile

from package import (
    ADFSVolume, BlkDevFactory, REPO, digest, load_package, relative_path,
    verified_sources, walk,
)


BASELINE = "2.1.12"
STOCK_SHA256 = "e6bc79df8caf0c1fe559d34bc05a626f29b833e9aaa7e710e65514b56352e5d9"
RELEASE_ROOT = "src/BestClassicWB/"
PAYLOAD = RELEASE_ROOT + "BCWB_Files/"
README = "BCWB.readme.txt"

# Entries the stock installer derives from the clean AmigaOS disk.
OS_ORIGINS = {
    "S/Startup-Sequence.bak": "S/Startup-Sequence",
    "S/user-startup.bak": "S/User-Startup",
    "Libs/icon.library.bak": "Libs/icon.library",
    "Storage/DataTypes/ilbm.datatype": "Classes/DataTypes/ilbm.datatype",
    "Storage/DataTypes/jpeg.datatype": "Classes/DataTypes/jpeg.datatype",
    "Storage/DataTypes/ilbm.datatype.info": "Classes/DataTypes/ilbm.datatype.info",
    "Storage/DataTypes/jpeg.datatype.info": "Classes/DataTypes/jpeg.datatype.info",
    "Tools/Commodities/MenuTools": "WBStartup/MenuTools",
    "Tools/Commodities/MenuTools.info": "WBStartup/MenuTools.info",
    "WBStartup/ClickToFront": "Tools/Commodities/ClickToFront",
    "WBStartup/ClickToFront.info": "Tools/Commodities/ClickToFront.info",
    "C/Installer": "System/Installer",
}


def write_json(path, data):
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def print_json(data):
    print(json.dumps(data, ensure_ascii=True, indent=2))


def stock_layout(path):
    with path.open("rb") as archive:
        if hashlib.file_digest(archive, "sha256").hexdigest() != STOCK_SHA256:
            raise ValueError(f"Expected the published {BASELINE} ZIP: {path}")


def layout_files(zip_file):
    entries = {entry.filename: entry for entry in zip_file.infolist()}
    if len(entries) != len(zip_file.infolist()):
        raise ValueError("Duplicate shipment paths.")
    return {path: entry for path, entry in entries.items() if not entry.is_dir()}


def tracked_sources():
    result = subprocess.run(
        ["git", "-C", str(REPO), "ls-files", "-z", "--", "src/"], check=True,
        stdout=subprocess.PIPE,
    )
    return set(result.stdout.decode("utf-8").rstrip("\0").split("\0"))


def guest_name(path):
    # Stock Amiga UnZip retained UTF-8 filename bytes and discarded C1 controls.
    raw = path.encode("utf-8").decode("latin-1")
    return "".join(char for char in raw if not 0x80 <= ord(char) <= 0x9F)


def payload_members(paths):
    result = {}
    for member in paths:
        if not member.startswith(PAYLOAD):
            continue
        target = guest_name(member.removeprefix(PAYLOAD).rstrip("/")).lower()
        if target in result:
            raise ValueError(f"Duplicate Amiga payload path: {member}")
        result[target] = member
    return result


def catalogue_contents(archive_dir, temporary, members):
    replacements = {}
    for manifest in sorted((REPO / "packages").glob("*.json")):
        package = load_package(manifest.stem)
        if package["baseline"] != BASELINE:
            raise ValueError(f"{manifest.stem} targets a different baseline.")
        scratch = temporary / manifest.stem
        scratch.mkdir()
        for entry, content in verified_sources(package, archive_dir, scratch):
            target = entry["path"].lower()
            if target not in members:
                raise ValueError(f"No shipped payload member for SYS:{entry['path']}")
            member = members[target]
            if member in replacements:
                raise ValueError(f"Conflicting package ownership: {member}")
            source = {
                "kind": "package",
                "package": manifest.stem,
                "source": entry["source"],
                "archive": entry.get("archive"),
                "installedPath": entry["path"],
            }
            if "sourceTransform" in entry:
                source["sourceTransform"] = entry["sourceTransform"]
            replacements[member] = (content, source)
    return replacements


def compare_zip(expected, rebuilt):
    with ZipFile(expected) as stock, ZipFile(rebuilt) as candidate:
        a, b = layout_files(stock), layout_files(candidate)
        if set(a) != set(b) or set(stock.namelist()) != set(candidate.namelist()):
            raise ValueError("Shipment paths differ from the stock layout.")
        for name in stock.namelist():
            before, after = stock.getinfo(name), candidate.getinfo(name)
            if (before.external_attr, before.create_system, before.extra, before.flag_bits & 0x800) != (
                after.external_attr, after.create_system, after.extra, after.flag_bits & 0x800
            ):
                raise ValueError(f"ZIP attributes differ: {name}")
            if name in a and stock.read(name) != candidate.read(name):
                raise ValueError(f"Shipment contents differ: {name}")
    return len(a)


def build(stock_path, archive_dir, output):
    stock_layout(stock_path)
    ledger_path = output.with_suffix(".sources.json")
    if output.suffix.lower() != ".zip":
        raise ValueError("The output filename must end in .zip.")
    if output.exists() or ledger_path.exists():
        raise FileExistsError("Choose an unused output name.")
    output.parent.mkdir(parents=True, exist_ok=True)
    with TemporaryDirectory(dir=output.parent) as scratch, ZipFile(stock_path) as stock:
        scratch = Path(scratch)
        members = layout_files(stock)
        files = tracked_sources()
        if files != set(members):
            raise ValueError(
                f"Checkout paths differ from stock. Extra: {sorted(files - set(members))}; "
                f"missing: {sorted(set(members) - files)}"
            )
        replacements = catalogue_contents(archive_dir, scratch, payload_members(members))
        staged = scratch / output.name
        ledger = {}
        with ZipFile(staged, "x") as rebuilt:
            rebuilt.comment = stock.comment
            for entry in stock.infolist():
                path = entry.filename
                if entry.is_dir():
                    rebuilt.writestr(copy(entry), b"")
                    continue
                if path in replacements:
                    content, source = replacements[path]
                else:
                    content = (REPO / relative_path(path)).read_bytes()
                    source = {
                        "kind": "pinned_release_payload" if path.startswith(PAYLOAD) else "stock_installer_assets",
                        "source": path,
                    }
                if content != stock.read(path):
                    raise ValueError(f"Reconstructed contents differ from {BASELINE}: {path}")
                ledger[path] = {**source, "sha256": digest(content)}
                rebuilt.writestr(copy(entry), content)
        count = compare_zip(stock_path, staged)
        staged_ledger = scratch / ledger_path.name
        write_json(staged_ledger, {
            "baseline": BASELINE, "referenceZipSha256": STOCK_SHA256,
            "packageFiles": len(replacements), "files": ledger,
            "directories": [item.filename for item in stock.infolist() if item.is_dir()],
        })
        staged.rename(output)
        staged_ledger.rename(ledger_path)
    print(f"Built {count} stock-matching files, including {len(replacements)} from the catalogue.")
    print(f"Source ledger: {ledger_path}")


def disk_inventory(hdf):
    device = BlkDevFactory().open(str(hdf), read_only=True)
    try:
        volume = ADFSVolume(device)
        volume.open()
        entries = {}
        for path, node in walk(volume.get_root_dir()):
            info = node.get_meta_info()
            metadata = {"protection": info.get_protect(), "comment": info.get_comment_unicode_str()}
            if node.is_file():
                data = node.get_file_data()
                entries[path] = dict(metadata, type="file", bytes=len(data), sha256=digest(data))
                node.flush()
            elif node.is_dir():
                entries[path] = dict(metadata, type="directory")
            else:
                raise ValueError(f"Unsupported entry: {path}")
        return volume.get_volume_name().get_unicode(), entries
    finally:
        device.close()


def changes(before, after):
    return {
        "added": sorted(after.keys() - before.keys()),
        "removed": sorted(before.keys() - after.keys()),
        "changed": sorted(path for path in before.keys() & after.keys() if before[path] != after[path]),
    }


def trace_installed(clean, installed, ledger):
    source_ledger = ledger["files"]
    sources = {target: source_ledger[member] for target, member in payload_members(source_ledger).items()}
    directories = payload_members(ledger.get("directories", []))
    for suffix in ("", ".info"):
        sources[("Locale/Help/" + README + suffix).lower()] = source_ledger[RELEASE_ROOT + README + suffix]
    paths = changes(clean, installed)
    result = {}
    for path in paths["added"] + paths["changed"]:
        target = installed[path]
        if target["type"] == "directory":
            directory = directories.get(path.lower())
            result[path] = (
                {"kind": "stock_payload_directory", "source": directory}
                if directory else {"kind": "stock_installer_directory"}
            )
            continue
        source = sources.get(path.lower())
        if source and source["sha256"] == target["sha256"]:
            result[path] = source
            continue
        origin = OS_ORIGINS.get(path)
        if origin in clean and clean[origin].get("sha256") == target["sha256"]:
            result[path] = {"kind": "stock_installer_os_operation", "source": origin}
            continue
        prior = clean.get(path)
        if prior and prior.get("sha256") == target["sha256"]:
            result[path] = {"kind": "stock_installer_metadata_change", "source": path}
            continue
        result[path] = {"kind": "unattributed", "sha256": target["sha256"]}
    return {"installedChanges": result, "removedByStockInstaller": paths["removed"]}


def verify_install(clean_hdf, stock_hdf, installed_hdf, ledger, report):
    clean_label, clean = disk_inventory(clean_hdf)
    stock_label, stock = disk_inventory(stock_hdf)
    label, installed = disk_inventory(installed_hdf)
    delta = changes(stock, installed)
    details = {
        "baseline": BASELINE,
        "cleanVolume": clean_label,
        "stockVolume": stock_label,
        "rebuiltVolume": label,
        "stockToRebuilt": delta,
    }
    if stock_label != label or any(delta.values()):
        write_json(report, details)
        raise ValueError(f"The installed system differs from stock. See {report}.")
    sources = json.loads(ledger.read_text(encoding="utf-8"))
    if sources["baseline"] != BASELINE or sources["referenceZipSha256"] != STOCK_SHA256:
        raise ValueError("The source ledger targets a different baseline.")
    trace = trace_installed(clean, installed, sources)
    details.update(trace)
    unknown = [path for path, origin in trace["installedChanges"].items() if origin["kind"] == "unattributed"]
    details["unattributed"] = unknown
    write_json(report, details)
    if unknown:
        raise ValueError(f"Installed bytes match, but {len(unknown)} new or changed files lack provenance. See {report}.")
    print(f"Stock parity verified for all {len(installed)} installed entries; "
          f"traced {len(trace['installedChanges'])} added or changed paths.")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    build_args = commands.add_parser("build")
    build_args.add_argument("--stock-zip", type=Path, required=True)
    build_args.add_argument("--archives", type=Path, required=True)
    build_args.add_argument("--output", type=Path, required=True)
    verify_args = commands.add_parser("verify-install")
    for argument in ("clean", "stock", "installed", "ledger", "report"):
        verify_args.add_argument(f"--{argument}", type=Path, required=True)
    args = parser.parse_args()
    try:
        if args.command == "build":
            build(args.stock_zip.resolve(), args.archives.resolve(), args.output.resolve())
        else:
            verify_install(args.clean, args.stock, args.installed, args.ledger, args.report)
    except (OSError, ValueError, KeyError, subprocess.CalledProcessError) as error:
        print(error, file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
