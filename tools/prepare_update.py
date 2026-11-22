"""Verify a staged package candidate and report changes against a reference install."""

import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import sys
from tempfile import TemporaryDirectory

from distribution import DELETED_DESCRIPTORS, EXECUTE_TARGETS, OS_ORIGINS, RELEASE_HELP, disk_inventory
from package import REPO, load_manifest, load_package, literal_operation_path, parents, relative_path, verified_sources


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


def reference_entries(baseline, installed):
    entries = {}
    for key, (kind, entry) in baseline.items():
        expected = snapshot(kind, entry)
        actual = installed.get(key)
        if "sha256" in entry:
            expected["sha256"] = entry["sha256"]
        if actual is None or any(actual.get(field) != value for field, value in expected.items()):
            raise ValueError(f"Reference entry differs from the catalogue: {entry['path']}")
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


def case_rename(change):
    return change["before"]["path"].rsplit("/", 1)[-1] != change["after"]["path"].rsplit("/", 1)[-1]


def review_guarded_changes(changes, checked_bcwb, declarations, *, removed=()):
    if not isinstance(declarations, list):
        raise ValueError("intentionalChanges must be a list of path-specific declarations.")
    declared = {}
    seen = set()
    for entry in declarations:
        if (
            not isinstance(entry, dict) or entry.keys() != {"path", "before", "after", "reason"}
            or not isinstance(entry["path"], str)
            or not isinstance(entry["before"], dict) or not isinstance(entry["after"], dict)
            or not isinstance(entry["reason"], str) or not entry["reason"].strip()
        ):
            raise ValueError("Each intentional change needs a path, before and after objects, and a reason.")
        path = relative_path(entry["path"]).as_posix()
        if path.lower() in seen:
            raise ValueError(f"Duplicate intentional change: {path}")
        seen.add(path.lower())
        declared[path] = entry

    required = {}
    for entry in removed:
        fields = ("type", "protection", "comment", "sha256")
        required[entry["path"]] = {
            "before": {field: entry[field] for field in fields if field in entry},
            "after": {},
        }
    for change in changes:
        path = change["before"]["path"]
        guarded_fields = {"protection", "comment"}
        if path in checked_bcwb or path.lower().endswith(".info"):
            guarded_fields.add("sha256")
        if case_rename(change):
            guarded_fields.add("path")
        fields = [field for field in change["fields"] if field in guarded_fields]
        if "type" in change["fields"]:
            fields = ["type", "protection", "comment", "sha256"]
            if "path" in change["fields"]:
                fields.append("path")
        if not fields:
            continue
        required[path] = {
            side: {field: change[side][field] for field in fields if field in change[side]}
            for side in ("before", "after")
        }

    reviews = []
    for path, actual in sorted(required.items()):
        review = {"path": path, **actual, "status": "undeclared"}
        declaration = declared.pop(path, None)
        if declaration is not None:
            values = {side: declaration[side] for side in actual}
            if json.dumps(values, sort_keys=True) == json.dumps(actual, sort_keys=True):
                review.update(status="declared", reason=declaration["reason"])
            else:
                review.update(status="differs", declaration=declaration)
        reviews.append(review)
    reviews.extend(
        {"path": path, "status": "no_matching_change", "declaration": declaration}
        for path, declaration in sorted(declared.items())
    )
    return reviews


def ownership_conflicts(package, before, after, installed, final, shared_paths):
    others = {}
    for path in sorted((REPO / "packages").glob("*.json")):
        if path.stem != package:
            for key, (_, entry) in package_entries(load_package(path.stem)).items():
                others[key] = (path.stem, entry.get("shared", False))

    conflicts = []
    for key, entry in after.items():
        path = entry["path"]
        if key in others or (key in installed and key not in before):
            owner = others[key][0] if key in others else "existing reference installation"
            conflicts.append({"path": path, "kind": "owned_destination", "owner": owner})
        for parent in parents(relative_path(path)):
            literal = parent.as_posix()
            parent_key = literal.lower()
            parent_entry = final.get(parent_key)
            if parent_entry is None or parent_entry["type"] != "directory":
                conflicts.append({"path": path, "kind": "missing_or_invalid_parent", "parent": literal})
            elif parent_entry["path"] != literal:
                conflicts.append({"path": path, "kind": "parent_case_differs", "parent": parent_entry["path"]})
            if key not in before and parent_key in others:
                owner, parent_shared = others[parent_key]
                if not parent_shared:
                    conflicts.append({"path": path, "kind": "exclusive_drawer", "parent": literal, "owner": owner})
    for key, entry in before.items():
        path = entry["path"]
        replacement = after.get(key)
        converts_type = replacement is not None and replacement["type"] != entry["type"]
        removes_entry = replacement is None or converts_type
        if removes_entry or replacement["path"] != path:
            if key in shared_paths or key in others:
                conflicts.append({"path": path, "kind": "shared_path_operation"})
            if not literal_operation_path(path):
                conflicts.append({"path": path, "kind": "unsafe_path_operation"})
            if removes_entry and entry["protection"] & 1:
                conflicts.append({"path": path, "kind": "delete_protected"})
        if entry["type"] != "directory":
            continue
        if removes_entry and any(path.startswith(key + "/") for path in final):
            conflicts.append({"path": entry["path"], "kind": "drawer_has_retained_children"})
        elif not removes_entry and path != replacement["path"] and any(
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


def installed_inventory(hdf):
    label, inventory = disk_inventory(hdf)
    entries = {}
    for path, metadata in inventory.items():
        key = path.lower()
        if key in entries:
            raise ValueError(f"Conflicting installed path spelling in {hdf}: {path}")
        entries[key] = {"path": path, **metadata}
    return label, entries


def candidate_proposal(package, candidate, archive_dir, reference):
    baseline = load_package(package)
    if candidate["baseline"] != baseline["baseline"] or candidate["name"] != baseline["name"]:
        raise ValueError("Candidate name and baseline must match the selected package.")
    if candidate["version"] == baseline["version"]:
        raise ValueError("Specify the candidate version in the staged manifest.")

    with reference.open("rb") as stream:
        reference_hash = hashlib.file_digest(stream, "sha256").hexdigest()
    label, installed = installed_inventory(reference)
    baseline_paths = package_entries(baseline)
    before = reference_entries(baseline_paths, installed)
    after = verified_candidate(candidate, archive_dir)
    delta = compare(before, after)
    final = {key: entry for key, entry in installed.items() if key not in before} | after
    shared = {key for key, (_, entry) in baseline_paths.items() if entry.get("shared", False)}
    conflicts = ownership_conflicts(package, before, after, installed, final, shared)
    checks = dependency_checks(candidate, final)
    missing_required = any(check["required"] and check["status"] == "missing" for check in checks)

    touched = {entry["path"] for kind in ("added", "removed") for entry in delta[kind]}
    for entry in delta["changed"]:
        touched.update((entry["before"]["path"], entry["after"]["path"]))
    checked_bcwb = {
        entry["path"] for kind, entry in baseline_paths.values()
        if kind == "files" and "archive" not in entry
    }
    reviews = review_guarded_changes(
        delta["changed"], checked_bcwb, candidate.get("intentionalChanges", []), removed=delta["removed"],
    )
    has_unreviewed_changes = any(review["status"] != "declared" for review in reviews)
    installer_paths = {
        path.lower() for path in (*OS_ORIGINS, *OS_ORIGINS.values(), *EXECUTE_TARGETS,
                                  *DELETED_DESCRIPTORS, *RELEASE_HELP)
    }
    old_dependencies = set(baseline.get("runtimeDependencies", []))
    new_dependencies = set(candidate.get("runtimeDependencies", []))
    report = {
        "package": package,
        "baseline": baseline["baseline"],
        "baselineVersion": baseline["version"],
        "candidateVersion": candidate["version"],
        "stockImage": {"sha256": reference_hash, "volume": label},
        "candidateArchives": candidate["archives"],
        "candidateNotes": candidate.get("notes", []),
        "status": "blocked" if conflicts or missing_required or has_unreviewed_changes else "ready_for_review",
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
    if reviews:
        report["guardedChanges"] = reviews
    return report, installed, final


def prepare(package, candidate, archive_dir, reference):
    report, _, _ = candidate_proposal(package, candidate, archive_dir, reference)
    return report


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("package")
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--archives", type=Path, required=True)
    parser.add_argument("--reference", "--stock", type=Path, required=True,
                        help="closed stock or development reference hardfile")
    parser.add_argument("--output", type=Path, required=True, help="new JSON report path")
    args = parser.parse_args()
    try:
        report = prepare(args.package, load_manifest(args.manifest), args.archives.resolve(), args.reference)
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
