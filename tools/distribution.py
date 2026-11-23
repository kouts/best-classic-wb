"""Build a local BestClassicWB ZIP or verify a 2.1.12 installation."""

import argparse
from collections import Counter
from copy import copy
import hashlib
import json
from pathlib import Path
import subprocess
import sys
from tempfile import TemporaryDirectory
from zipfile import ZipFile

from amitools.fs.ProtectFlags import ProtectFlags

from package import (
    ADFSVolume, BlkDevFactory, REPO, digest, literal_operation_path, load_package, relative_path,
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
    "Tools/Commodities/MenuTools": "WBStartup/MenuTools",
    "Tools/Commodities/MenuTools.info": "WBStartup/MenuTools.info",
    "WBStartup/ClickToFront": "Tools/Commodities/ClickToFront",
    "WBStartup/ClickToFront.info": "Tools/Commodities/ClickToFront.info",
    "C/Installer": "System/Installer",
}
RELOCATED_ICONS = {"Tools/Commodities/MenuTools.info", "WBStartup/ClickToFront.info"}
DELETED_DESCRIPTORS = ("Devs/DataTypes/JPEG", "Devs/DataTypes/JPEG.info")
EXECUTE_TARGETS = ("C/FBlit", "C/FText", "C/FPPrefs")
RELEASE_HELP = {
    "Locale/Help/" + README + suffix: RELEASE_ROOT + README + suffix
    for suffix in ("", ".info")
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


def directory_additions(catalogue, stock_dirs, additions):
    donors = payload_members(stock_dirs)
    created = {}
    for package_id, package in catalogue.items():
        for entry in package["directories"]:
            template = entry.get("developmentZipTemplate")
            if template is None:
                continue
            path = relative_path(entry["path"]).as_posix()
            member = PAYLOAD + path + "/"
            donor = donors.get(relative_path(template).as_posix().lower())
            if additions is None or donor is None or path.lower() in donors or member in created:
                raise ValueError(f"Invalid development ZIP drawer or template: {path}")
            if guest_name(path) != path:
                raise ValueError(f"New ZIP drawer spelling does not survive Amiga UnZip: {path}")
            additions[member] = donor
            created[member] = {
                "package": package_id, "installedPath": path, "zipTemplate": donor,
                "protection": entry["protection"], "comment": entry["comment"],
            }
    for member in created:
        parent = member.rstrip("/").rsplit("/", 1)[0] + "/"
        if parent not in stock_dirs and parent not in created:
            raise ValueError(f"No declared parent drawer for {member}")
    return created


def catalogue_contents(archive_dir, temporary, members, stock_dirs, *, additions=None, removals=None):
    catalogue = {path.stem: load_package(path.stem) for path in sorted((REPO / "packages").glob("*.json"))}
    stock_paths = members | payload_members(stock_dirs)
    for package_id, package in catalogue.items():
        if package["baseline"] != BASELINE:
            raise ValueError(f"{package_id} targets a different baseline.")
        for path in package.get("developmentZipRemovals", []):
            member = stock_paths.get(relative_path(path).as_posix().lower())
            if removals is None or member is None or member in removals:
                raise ValueError(f"Invalid development ZIP removal: {path}")
            removals.add(member)

    created = directory_additions(catalogue, stock_dirs, additions)
    replacements = {}
    metadata = dict(created)
    for package_id, package in catalogue.items():
        scratch = temporary / package_id
        scratch.mkdir()
        for entry, content in verified_sources(package, archive_dir, scratch):
            path = entry["path"]
            target = path.lower()
            rename_from = entry.get("developmentZipRenameFrom")
            if rename_from and (removals is None or target in members):
                raise ValueError(f"Invalid development ZIP rename: {path}")
            if target in members:
                member = members[target]
            else:
                template = rename_from or entry.get("developmentZipTemplate")
                if additions is None or not template:
                    raise ValueError(f"No shipped payload member for SYS:{path}")
                member = PAYLOAD + relative_path(path).as_posix()
                donor = members.get(relative_path(template).as_posix().lower())
                drawer = member.rsplit("/", 1)[0] + "/"
                old_member = stock_paths.get(target, "")
                converts_drawer = old_member.endswith("/") and old_member in removals
                needs_metadata = drawer in created or converts_drawer
                if (donor is None or (drawer not in stock_dirs and drawer not in created)
                        or (not needs_metadata and not rename_from and donor.rsplit("/", 1)[0] + "/" != drawer)
                        or not (REPO / member).is_file()
                        or (REPO / member).read_bytes() != content):
                    raise ValueError(f"Invalid development ZIP input or template: {member}")
                if needs_metadata:
                    if guest_name(path) != path:
                        raise ValueError(f"New ZIP file spelling does not survive Amiga UnZip: {path}")
                    metadata[member] = {field: entry[field] for field in ("protection", "comment")}
                    metadata[member]["installedPath"] = path
                additions[member] = donor
                if rename_from:
                    if donor in removals:
                        raise ValueError(f"Conflicting development ZIP rename: {donor}")
                    removals.add(donor)
            if member in replacements:
                raise ValueError(f"Conflicting package ownership: {member}")
            source = {
                "kind": "package", "package": package_id, "source": entry["source"],
                "archive": entry.get("archive"), "installedPath": path,
            }
            if "sourceTransform" in entry:
                source["sourceTransform"] = entry["sourceTransform"]
            replacements[member] = (content, source)
    if removals and replacements.keys() & removals:
        raise ValueError("Removed stock members cannot also be supplied by a package.")
    return replacements, created, metadata


def add_install_metadata(contents, metadata):
    anchor = b'COPY "BCWB_Files" TO SYS: ALL BUF 10'
    lines = contents.splitlines(keepends=True)
    copies = [index for index, line in enumerate(lines) if line.rstrip(b"\r\n") == anchor]
    if len(copies) != 1:
        raise ValueError("Expected one BCWB payload copy before setting development metadata.")
    insert_at = copies[0] + 1
    newline = b"\r\n" if lines[copies[0]].endswith(b"\r\n") else b"\n"
    commands = ["FAILAT 5"]
    for member, entry in sorted(metadata.items()):
        if member.endswith("/"):
            target = entry["installedPath"]
            commands.extend([f'IF NOT EXISTS "SYS:{target}"', f'  MakeDir "SYS:{target}"', "ENDIF"])
    for member, entry in sorted(metadata.items(), key=lambda item: (-item[0].rstrip("/").count("/"), item[0])):
        path = entry["installedPath"]
        mask, comment = entry["protection"], entry["comment"]
        if (not literal_operation_path(path) or type(mask) is not int or not 0 <= mask <= 255
                or not isinstance(comment, str) or any(char in comment for char in "\0\r\n")
                or len(comment.encode("latin-1")) > 79):
            raise ValueError(f"Invalid development ZIP metadata for SYS:{path}")
        comment = "".join("*" + char if char in '*"$`' else char for char in comment)
        commands.append(f'FileNote "SYS:{path}" "{comment}"')
        flags = ProtectFlags(mask).short_str()
        commands.append(f'Protect "SYS:{path}" FLAGS {flags or "d"}')
        if not flags:
            commands.append(f'Protect "SYS:{path}" FLAGS -d')
    commands.append("FAILAT 10")
    lines[copies[0]] = anchor + newline
    lines[insert_at:insert_at] = [command.encode("latin-1") + newline for command in commands]
    return b"".join(lines)


def compare_zip(expected, rebuilt, *, check_contents=True, additions=None, removals=()):
    with ZipFile(expected) as stock, ZipFile(rebuilt) as candidate:
        a, b = layout_files(stock), layout_files(candidate)
        additions = additions or {}
        removals = set(removals)
        stock_paths = set(stock.namelist())
        if (additions.keys() & stock_paths or not set(additions.values()) <= stock_paths
                or not removals <= stock_paths
                or any(name.endswith("/") != donor.endswith("/") for name, donor in additions.items())):
            raise ValueError("Invalid development ZIP template mapping.")
        if ((stock_paths - removals) | additions.keys()) != set(candidate.namelist()):
            raise ValueError("Shipment paths differ from the expected layout.")
        for name in candidate.namelist():
            before = stock.getinfo(additions.get(name, name))
            after = candidate.getinfo(name)
            if (before.external_attr, before.create_system, before.extra, before.flag_bits & 0x800) != (
                after.external_attr, after.create_system, after.extra, after.flag_bits & 0x800
            ):
                raise ValueError(f"ZIP attributes differ: {name}")
            if check_contents and name in a and stock.read(name) != candidate.read(name):
                raise ValueError(f"Shipment contents differ: {name}")
    return len(b)


def build(stock_path, archive_dir, output, *, development=False):
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
        additions = {}
        removals = set()
        stock_drawers = {entry.filename for entry in stock.infolist() if entry.is_dir()}
        replacements, created, metadata = catalogue_contents(
            archive_dir, scratch, payload_members(members), stock_drawers,
            additions=additions if development else None, removals=removals if development else None,
        )
        layout = (set(stock.namelist()) - removals) | additions.keys()
        for drawer in removals & stock_drawers:
            if any(member.startswith(drawer) for member in layout):
                raise ValueError(f"Removed drawer still has payload entries: {drawer}")
        expected = {path for path in layout if not path.endswith("/")}
        if files != expected:
            raise ValueError(
                f"Checkout paths differ from expected. Extra: {sorted(files - expected)}; "
                f"missing: {sorted(expected - files)}"
            )
        payload_members(layout)
        staged = scratch / output.name
        ledger = {}
        with ZipFile(staged, "x") as rebuilt:
            rebuilt.comment = stock.comment
            for entry in stock.infolist():
                path = entry.filename
                if path in removals:
                    continue
                if entry.is_dir():
                    rebuilt.writestr(copy(entry), b"")
                    continue
                if path in replacements:
                    content, source = replacements[path]
                else:
                    if path.startswith(PAYLOAD):
                        raise ValueError(f"No catalogue owner for payload member: {path}")
                    content = (REPO / relative_path(path)).read_bytes()
                    source = {"kind": "installer_assets" if development else "stock_installer_assets", "source": path}
                    if path == RELEASE_ROOT + "BCWB" and metadata:
                        content = add_install_metadata(content, metadata)
                        source["metadataEntries"] = sorted(metadata)
                if not development and content != stock.read(path):
                    raise ValueError(f"Reconstructed contents differ from {BASELINE}: {path}")
                ledger[path] = {**source, "sha256": digest(content)}
                rebuilt.writestr(copy(entry), content)
            for path, donor in sorted(additions.items()):
                if path in created:
                    content = b""
                else:
                    content, source = replacements[path]
                    ledger[path] = {**source, "sha256": digest(content), "zipTemplate": donor}
                entry = copy(stock.getinfo(donor))
                entry.filename = entry.orig_filename = path
                rebuilt.writestr(entry, content)
        count = compare_zip(
            stock_path, staged, check_contents=not development, additions=additions, removals=removals,
        )
        staged_ledger = scratch / ledger_path.name
        write_json(staged_ledger, {
            "baseline": BASELINE, "referenceZipSha256": STOCK_SHA256,
            **({"development": True} if development else {}),
            "packageFiles": len(replacements), "files": ledger,
            "directories": [item.filename for item in stock.infolist()
                            if item.is_dir() and item.filename not in removals] + sorted(created),
            **({"directoryAdditions": created} if created else {}),
        })
        staged.rename(output)
        staged_ledger.rename(ledger_path)
    kind = "development" if development else "stock-matching"
    print(f"Built {count} {kind} files, including {len(replacements)} from the catalogue.")
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
    for target, member in RELEASE_HELP.items():
        sources[target.lower()] = source_ledger[member]
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


def installer_operations(clean_label, clean, label, installed, trace):
    """Validate the terminal effects of the stock installer actions."""
    origins = trace["installedChanges"]
    removed = {}
    operations = [{"action": "relabel", "target": "SYS:", "before": clean_label, "after": label}]
    if label != "OS3.2":
        raise ValueError(f"The stock installer must leave the OS3.2 label: {label}")
    for target, origin in OS_ORIGINS.items():
        if target.endswith(".bak"):
            action = "rename_to_backup"
        elif target.startswith("Storage/"):
            action = "rename_to_storage"
        elif target == "C/Installer":
            action = "copy_clone"
        else:
            action = "copy_then_delete"
        before, after = clean[origin], installed[target]
        item = {"action": action, "source": origin, "target": target, "cleanEntry": before}
        if target in RELOCATED_ICONS:
            if origins[target]["kind"] != "package" or before["sha256"] == after["sha256"]:
                raise ValueError(f"Expected BCWB to replace the relocated OS icon: {target}")
            item["replacedAtDestinationBy"] = origins[target]
        elif before != after:
            raise ValueError(f"Clean OS content or metadata differs at {target}")
        if origin not in installed:
            removed[origin] = {"action": action, "target": target}
        elif target == "C/Installer":
            if installed[origin] != before:
                raise ValueError(f"Original Installer changed at {origin}")
        else:
            if origins[origin]["kind"] != "package" or installed[origin]["sha256"] == before["sha256"]:
                raise ValueError(f"Expected BCWB to replace the moved OS file: {origin}")
            item["replacedAtSourceBy"] = origins[origin]
        item["installedEntry"] = after
        operations.append(item)
    for path in DELETED_DESCRIPTORS:
        removed[path] = {"action": "delete_force"}
        operations.append({"action": "delete_force", "source": path, "cleanEntry": clean[path]})
    if set(removed) != set(trace["removedByStockInstaller"]):
        raise ValueError("Literal-path removals differ from the stock installer actions.")
    for path, member in RELEASE_HELP.items():
        if origins[path] != {
            "kind": "stock_installer_assets", "source": member, "sha256": installed[path]["sha256"],
        }:
            raise ValueError(f"Expected the installer to copy the release help asset to {path}")
        operations.append({"action": "copy_release_asset", "source": member, "target": path,
                           "installedEntry": installed[path]})
    for path in EXECUTE_TARGETS:
        if origins[path]["kind"] != "package" or installed[path]["protection"] != 0:
            raise ValueError(f"Expected mask 0 from the stock PROTECT +e at {path}")
        operations.append({"action": "protect_add_execute", "target": path,
                           "installedEntry": installed[path]})
    return operations, removed


def verify_ownership(installed, trace, removed):
    """Assign each material install change one final owner."""
    owners = {}
    namespaces = {}
    overlaps = {}

    def claim(path, owner):
        previous = namespaces.setdefault(path.lower(), path)
        if previous != path or path in owners:
            overlaps.setdefault(path, [owners[previous]]).append(owner)
        else:
            owners[path] = owner

    for manifest in sorted((REPO / "packages").glob("*.json")):
        package = load_package(manifest.stem)
        for key in ("files", "directories"):
            for entry in package[key]:
                path = entry["path"]
                expected_type = "file" if key == "files" else "directory"
                if installed[path]["type"] != expected_type or any(
                    installed[path].get(field) != entry.get(field)
                    for field in ("protection", "comment", "sha256")
                ):
                    raise ValueError(f"Catalogue metadata or contents differ at {path}")
                if key == "files":
                    source = trace["installedChanges"].get(path, {})
                    if source.get("kind") != "package" or source.get("package") != manifest.stem:
                        raise ValueError(f"Catalogue owner is missing from the installed source trace: {path}")
                claim(path, manifest.stem)

    for path, source in trace["installedChanges"].items():
        if source["kind"] in ("stock_installer_assets", "stock_installer_os_operation"):
            claim(path, "stock_installer")
    # A literal removal can share its AmigaDOS name with a final, differently cased entry.
    for path in removed:
        if path in owners:
            overlaps.setdefault(path, [owners[path]]).append("stock_installer")

    changed = trace["installedChanges"]
    unexplained = sorted(changed.keys() - owners.keys())
    counts = Counter((installed[path]["type"], owners[path] == "stock_installer")
                     for path in changed.keys() & owners.keys())
    return {
        "counts": {
            "cataloguedChangedFiles": counts["file", False],
            "cataloguedChangedDirectories": counts["directory", False],
            "installerOwnedFiles": counts["file", True],
            "installerOwnedDirectories": counts["directory", True],
            "literalRemovals": len(removed),
            "totalPaths": sum(counts.values()) + len(removed),
        },
        "unchangedCataloguePaths": sorted(owners.keys() - changed.keys()),
        "unexplainedPaths": unexplained,
        "ownershipOverlaps": overlaps,
    }


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
        "installedEntries": len(installed),
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
    unknown = [path for path, origin in trace["installedChanges"].items()
               if origin["kind"] == "unattributed"]
    details["unattributed"] = unknown
    if unknown:
        write_json(report, details)
        raise ValueError(f"Installed bytes match, but {len(unknown)} new or changed files lack provenance. See {report}.")
    legacy_payload = sorted(path for path, source in sources["files"].items()
                            if source["kind"] == "pinned_release_payload")
    if legacy_payload:
        # Earlier batch ledgers remain usable for parity and provenance checks.
        details["legacyPayloadWithoutCatalogue"] = legacy_payload
    else:
        try:
            operations, removed = installer_operations(clean_label, clean, label, installed, trace)
            details["installerOperations"] = operations
            details["literalRemovalOrigins"] = removed
            ownership = verify_ownership(installed, trace, removed)
            details["ownership"] = ownership
            if ownership["unexplainedPaths"] or ownership["ownershipOverlaps"]:
                raise ValueError(f"Installed ownership does not reconcile. See {report}.")
        except (KeyError, ValueError) as error:
            details["ownershipValidationError"] = str(error)
            write_json(report, details)
            raise
    write_json(report, details)
    print(f"Stock parity verified for all {len(installed)} installed entries; "
          f"traced {len(trace['installedChanges'])} added or changed paths.")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    build_args = commands.add_parser("build")
    build_args.add_argument("--stock-zip", type=Path, required=True)
    build_args.add_argument("--archives", type=Path, required=True)
    build_args.add_argument("--output", type=Path, required=True)
    build_args.add_argument(
        "--development", action="store_true",
        help="use the published ZIP layout and the current development package inputs",
    )
    verify_args = commands.add_parser("verify-install")
    for argument in ("clean", "stock", "installed", "ledger", "report"):
        verify_args.add_argument(f"--{argument}", type=Path, required=True)
    args = parser.parse_args()
    try:
        if args.command == "build":
            build(
                args.stock_zip.resolve(), args.archives.resolve(), args.output.resolve(),
                development=args.development,
            )
        else:
            verify_install(args.clean, args.stock, args.installed, args.ledger, args.report)
    except (OSError, ValueError, KeyError, subprocess.CalledProcessError) as error:
        print(error, file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
