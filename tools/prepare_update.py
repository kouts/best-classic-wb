"""Verify a staged package candidate and report its expected 2.1.12 changes."""

import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import sys
from tempfile import TemporaryDirectory

from distribution import DELETED_DESCRIPTORS, EXECUTE_TARGETS, OS_ORIGINS, RELEASE_HELP, disk_inventory
from package import REPO, load_manifest, load_package, parents, relative_path, verified_sources


def package_entries(data):
    return {
        entry["path"].lower(): (kind, entry)
        for kind in ("files", "directories")
        for entry in data[kind]
    }


def snapshot(kind, entry):
    protection = entry["protection"]
    comment = entry["comment"]
    if type(protection) is not int or not 0 <= protection <= 255 or not isinstance(comment, str):
        raise ValueError(f"Invalid Amiga metadata: {entry['path']}")
    return {
        "path": entry["path"], "type": "file" if kind == "files" else "directory",
        "protection": protection, "comment": comment,
    }


def stock_entries(baseline, installed):
    entries = {}
    for key, (kind, entry) in baseline.items():
        expected = snapshot(kind, entry)
        actual = installed.get(key)
        if "sha256" in entry:
            expected["sha256"] = entry["sha256"]
        if actual is None or any(actual.get(field) != value for field, value in expected.items()):
            raise ValueError(f"Stock entry differs from the catalogue: {entry['path']}")
        entries[key] = actual
    return entries


def verified_candidate(data, archive_dir):
    for name, archive in data["archives"].items():
        publisher_digest = archive.get("publisherDigest")
        if publisher_digest is not None and publisher_digest != "sha256:" + archive["sha256"]:
            raise ValueError(f"Publisher digest differs from the archive pin: {name}")
    entries = {key: snapshot(kind, entry) for key, (kind, entry) in package_entries(data).items()}
    with TemporaryDirectory() as folder:
        for entry, contents in verified_sources(data, archive_dir, Path(folder)):
            entries[entry["path"].lower()].update(bytes=len(contents), sha256=entry["sha256"])
    return entries


def compare(before, after):
    delta = {
        "added": [after[key] for key in sorted(after.keys() - before.keys())],
        "removed": [before[key] for key in sorted(before.keys() - after.keys())],
        "changed": [],
    }
    for key in sorted(before.keys() & after.keys()):
        old, new = before[key], after[key]
        fields = sorted(field for field in old.keys() | new.keys() if old.get(field) != new.get(field))
        if fields:
            delta["changed"].append({"before": old, "after": new, "fields": fields})
    return delta


def ownership_conflicts(package, before, after, installed, final):
    others = {}
    for path in sorted((REPO / "packages").glob("*.json")):
        if path.stem != package:
            for key, (_, entry) in package_entries(load_package(path.stem)).items():
                others[key] = (path.stem, entry.get("shared", False))

    conflicts = []
    for key, entry in after.items():
        path = entry["path"]
        if key in others or (key in installed and key not in before):
            owner = others[key][0] if key in others else "existing stock installation"
            conflicts.append({"path": path, "kind": "owned_destination", "owner": owner})
        if key in before and entry["type"] != before[key]["type"]:
            conflicts.append({"path": path, "kind": "entry_type_changed"})
        for parent in parents(relative_path(path)):
            literal = parent.as_posix()
            parent_key = literal.lower()
            parent_entry = final.get(parent_key)
            if parent_entry is None or parent_entry["type"] != "directory":
                conflicts.append({"path": path, "kind": "missing_or_invalid_parent", "parent": literal})
            elif parent_entry["path"] != literal:
                conflicts.append({"path": path, "kind": "parent_case_differs", "parent": parent_entry["path"]})
            if key not in before and parent_key in others:
                owner, shared = others[parent_key]
                if not shared:
                    conflicts.append({"path": path, "kind": "exclusive_drawer", "parent": literal, "owner": owner})
    for key, entry in before.items():
        if entry["type"] != "directory":
            continue
        if key not in after and any(path.startswith(key + "/") for path in final):
            conflicts.append({"path": entry["path"], "kind": "drawer_has_retained_children"})
        elif key in after and entry["path"] != after[key]["path"] and any(
            path.startswith(key + "/") for path in installed.keys() - before.keys()
        ):
            conflicts.append({"path": entry["path"], "kind": "drawer_case_changes_external_paths"})
    return conflicts


def dependency_checks(candidate, final):
    checks = []
    for dependency in candidate.get("dependencyChecks", []):
        path = relative_path(dependency["path"]).as_posix()
        required = dependency["required"]
        if type(required) is not bool:
            raise ValueError(f"Set required to true or false for dependency {path}")
        checks.append({
            "path": path, "required": required,
            "status": "present" if path.lower() in final else "missing",
        })
    return checks


def prepare(package, candidate, archive_dir, stock):
    baseline = load_package(package)
    if candidate["baseline"] != baseline["baseline"] or candidate["name"] != baseline["name"]:
        raise ValueError("Candidate name and baseline must match the selected package.")
    if candidate["version"] == baseline["version"]:
        raise ValueError("Specify the candidate version in the staged manifest.")

    with stock.open("rb") as stream:
        stock_hash = hashlib.file_digest(stream, "sha256").hexdigest()
    label, inventory = disk_inventory(stock)
    installed = {key.lower(): {"path": key, **entry} for key, entry in inventory.items()}
    baseline_paths = package_entries(baseline)
    before = stock_entries(baseline_paths, installed)
    after = verified_candidate(candidate, archive_dir)
    delta = compare(before, after)
    final = {key: entry for key, entry in installed.items() if key not in before} | after
    conflicts = ownership_conflicts(package, before, after, installed, final)
    checks = dependency_checks(candidate, final)
    missing_required = any(check["required"] and check["status"] == "missing" for check in checks)

    touched = {entry["path"] for kind in ("added", "removed") for entry in delta[kind]}
    for entry in delta["changed"]:
        touched.update((entry["before"]["path"], entry["after"]["path"]))
    checked_bcwb = {
        entry["path"] for kind, entry in baseline_paths.values()
        if kind == "files" and "archive" not in entry
    }
    installer_paths = {
        path.lower() for path in (*OS_ORIGINS, *OS_ORIGINS.values(), *EXECUTE_TARGETS,
                                  *DELETED_DESCRIPTORS, *RELEASE_HELP)
    }
    old_dependencies = set(baseline["runtimeDependencies"])
    new_dependencies = set(candidate["runtimeDependencies"])
    return {
        "package": package,
        "baseline": baseline["baseline"],
        "baselineVersion": baseline["version"],
        "candidateVersion": candidate["version"],
        "stockImage": {"sha256": stock_hash, "volume": label},
        "candidateArchives": candidate["archives"],
        "candidateNotes": candidate.get("notes", []),
        "status": "blocked" if conflicts or missing_required else "ready_for_review",
        "counts": {**{kind: len(entries) for kind, entries in delta.items()},
                   "unchanged": len(before.keys() & after.keys()) - len(delta["changed"])},
        "changes": delta,
        "ownershipConflicts": conflicts,
        "dependencyChanges": {
            "added": sorted(new_dependencies - old_dependencies),
            "removed": sorted(old_dependencies - new_dependencies),
        },
        "dependencyChecks": checks,
        "changedCheckedBCWBInputs": sorted(touched & checked_bcwb),
        "affectedStockInstallerPaths": sorted(path for path in touched if path.lower() in installer_paths),
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("package")
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--archives", type=Path, required=True)
    parser.add_argument("--stock", type=Path, required=True, help="closed stock-installed hardfile")
    parser.add_argument("--output", type=Path, required=True, help="new JSON report path")
    args = parser.parse_args()
    try:
        report = prepare(args.package, load_manifest(args.manifest), args.archives.resolve(), args.stock)
        args.output.parent.mkdir(parents=True, exist_ok=True)
        with args.output.open("x", encoding="utf-8", newline="\n") as stream:
            stream.write(json.dumps(report, indent=2, ensure_ascii=False) + "\n")
    except (OSError, ValueError, KeyError, subprocess.CalledProcessError) as error:
        print(error, file=sys.stderr)
        return 1
    print(f"Candidate report ({report['status']}): {args.output}")
    return int(report["status"] == "blocked")


if __name__ == "__main__":
    sys.exit(main())
