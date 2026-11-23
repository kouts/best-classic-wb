"""Verify that a release build matches the ZIP and filesystem tested in WinUAE."""

import argparse
import hashlib
import json
from pathlib import Path
import sys

from distribution import changes, disk_inventory


def sha256(path):
    with path.open("rb") as stream:
        return hashlib.file_digest(stream, "sha256").hexdigest()


def verify_release(candidate_zip, tested_zip, reference, installed, runtime_evidence, output):
    archive_hash = sha256(candidate_zip)
    if sha256(tested_zip) != archive_hash:
        raise ValueError("The package-built ZIP differs from the ZIP tested in WinUAE.")
    if reference.samefile(installed):
        raise ValueError("Use separate expected and fresh WinUAE hardfiles.")
    if not runtime_evidence.read_text(encoding="utf-8").strip():
        raise ValueError("Record the WinUAE smoke results before release.")

    expected_label, expected = disk_inventory(reference)
    installed_label, actual = disk_inventory(installed)
    differences = changes(expected, actual)
    matched = expected_label == installed_label and not any(differences.values())
    report = {
        "status": "matched" if matched else "mismatch",
        "zipSha256": archive_hash,
        "referenceSha256": sha256(reference),
        "installedSha256": sha256(installed),
        "runtimeEvidenceSha256": sha256(runtime_evidence),
        "expectedVolume": expected_label,
        "installedVolume": installed_label,
        "expectedEntries": len(expected),
        "installedEntries": len(actual),
        "differences": differences,
    }
    output.parent.mkdir(parents=True, exist_ok=True)
    with output.open("x", encoding="utf-8", newline="\n") as stream:
        json.dump(report, stream, indent=2, ensure_ascii=False)
        stream.write("\n")
    if not matched:
        raise ValueError(f"The fresh WinUAE install differs from the expected filesystem. See {output}.")
    print(f"Verified the tested ZIP and all {len(actual)} installed entries. See {output}.")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--zip", type=Path, required=True, help="ZIP just built from the package catalogue")
    parser.add_argument("--tested-zip", type=Path, required=True, help="exact ZIP installed during WinUAE review")
    parser.add_argument("--reference", type=Path, required=True, help="closed hardfile containing the expected install")
    parser.add_argument("--installed", type=Path, required=True, help="closed hardfile from the fresh ZIP install")
    parser.add_argument("--runtime-evidence", type=Path, required=True, help="reviewed WinUAE smoke results")
    parser.add_argument("--output", type=Path, required=True, help="new verification report path")
    args = parser.parse_args()
    try:
        verify_release(args.zip, args.tested_zip, args.reference, args.installed, args.runtime_evidence, args.output)
    except (OSError, ValueError) as error:
        print(error, file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
