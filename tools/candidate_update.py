"""Build a reviewed update package or verify its complete installed inventory."""

import argparse
import json
from pathlib import Path
import subprocess
import sys

from package import build, digest, load_manifest
from prepare_update import candidate_proposal, compare, installed_inventory


def require_overlay(changes):
    unsupported = [f"Removal: {entry['path']}" for entry in changes["removed"]]
    for change in changes["changed"]:
        before, after = change["before"], change["after"]
        if "path" in change["fields"]:
            unsupported.append(f"Case-only rename: {before['path']} -> {after['path']}")
        if "type" in change["fields"]:
            unsupported.append(f"Entry type conversion: {before['path']}")
    if unsupported:
        raise ValueError("The package installer cannot apply these proposed changes:\n"
                         + "\n".join(unsupported))


def verify_install(proposal, proposal_hash, reference, expected, hardfile, output):
    label, installed = installed_inventory(hardfile)
    expected_label = proposal["stockImage"]["volume"]
    differences = compare(expected, installed)
    matched = label == expected_label and not any(differences.values())
    report = {
        "package": proposal["package"],
        "baseline": proposal["baseline"],
        "candidateVersion": proposal["candidateVersion"],
        "proposalSha256": proposal_hash,
        "stockImage": proposal["stockImage"],
        "expectedVolume": expected_label,
        "installedVolume": label,
        "expectedEntries": len(expected),
        "installedEntries": len(installed),
        "status": "matched" if matched else "mismatch",
        "stockToInstalled": compare(reference, installed),
        "expectedToInstalled": differences,
    }
    output.parent.mkdir(parents=True, exist_ok=True)
    with output.open("x", encoding="utf-8", newline="\n") as stream:
        stream.write(json.dumps(report, indent=2, ensure_ascii=False) + "\n")
    if not matched:
        raise ValueError(f"The installed inventory or volume differs from the proposal. See {output}.")
    print(f"Verified the volume label and all {len(installed)} installed entries. See {output}.")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    build_args = commands.add_parser("build", help="build a package hardfile with the guest installer")
    verify_args = commands.add_parser("verify", help="compare a closed installed hardfile with the proposal")
    for command in (build_args, verify_args):
        command.add_argument("package", help="catalogue package ID")
        command.add_argument("--manifest", type=Path, required=True, help="staged candidate manifest")
        command.add_argument("--archives", type=Path, required=True, help="staged candidate archive directory")
        command.add_argument("--reference", "--stock", type=Path, required=True,
                             help="closed stock or development reference hardfile")
        command.add_argument("--proposal", type=Path, required=True, help="reviewed expected changes JSON")
    build_args.add_argument("--output", type=Path, required=True, help="new candidate hardfile")
    verify_args.add_argument("--installed", type=Path, required=True, help="closed candidate-installed hardfile")
    verify_args.add_argument("--output", type=Path, required=True, help="new verification JSON")
    args = parser.parse_args()
    try:
        candidate = load_manifest(args.manifest)
        proposal_bytes = args.proposal.read_bytes()
        reviewed = json.loads(proposal_bytes)
        archives = args.archives.resolve()
        proposal, reference, expected = candidate_proposal(args.package, candidate, archives, args.reference)
        if isinstance(reviewed, dict) and proposal["stockImage"] != reviewed.get("stockImage"):
            raise ValueError("The reference hardfile SHA-256 or volume differs from the reviewed proposal.")
        if json.dumps(proposal, sort_keys=True) != json.dumps(reviewed, sort_keys=True):
            raise ValueError("The staged inputs do not reproduce the reviewed proposal.")
        changes = proposal["changes"]
        require_overlay(changes)
        if proposal["status"] != "ready_for_review":
            raise ValueError("The reviewed proposal is blocked by ownership or dependency checks.")
        if args.command == "build":
            paths = {entry["path"] for entry in changes["added"]}
            paths.update(change["after"]["path"] for change in changes["changed"])
            overlay = candidate | {
                kind: [entry for entry in candidate[kind] if entry["path"] in paths]
                for kind in ("files", "directories")
            }
            build(overlay, archives, args.output.resolve())
        else:
            verify_install(proposal, digest(proposal_bytes), reference, expected, args.installed, args.output)
    except (OSError, ValueError, KeyError, subprocess.CalledProcessError) as error:
        print(error, file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
