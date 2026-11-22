"""Build a local Amiga package hardfile or verify an installed hardfile."""

import argparse
from graphlib import TopologicalSorter
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import shutil
import subprocess
import sys
from tempfile import TemporaryDirectory

from amitools.fs.ADFSVolume import ADFSVolume
from amitools.fs.blkdev.BlkDevFactory import BlkDevFactory
from amitools.fs.FSString import FSString
from amitools.fs.MetaInfo import MetaInfo


REPO = Path(__file__).resolve().parents[1]
VOLUME = "BCWB-Package"


def digest(data):
    return hashlib.sha256(data).hexdigest()


def relative_path(text):
    path = PurePosixPath(text)
    if (
        not path.parts or path.is_absolute() or ".." in path.parts
        or path.as_posix() != text or any(char in text for char in ':\\*"\r\n')
    ):
        raise ValueError(f"Invalid package path: {text!r}")
    return path


def load_package(package):
    if relative_path(package).name != package:
        raise ValueError("Use a package ID from the packages directory.")
    return load_manifest(REPO / "packages" / f"{package}.json")


def load_manifest(path):
    data = json.loads(path.read_text(encoding="utf-8"))
    paths = set()
    for entry in data["files"] + data["directories"]:
        key = relative_path(entry["path"]).as_posix().lower()
        if key == "install" or key in paths:
            raise ValueError(f"Reserved or duplicate install path: {entry['path']}")
        paths.add(key)
    return data


def extract_archive(source, directory, archive):
    data = source.read_bytes()
    if digest(data) != archive["sha256"]:
        raise ValueError(f"Archive checksum mismatch: {source}")

    if "payloadOffset" in archive:
        offset = archive["payloadOffset"]
        if type(offset) is not int or not 0 < offset < len(data):
            raise ValueError(f"Invalid archive payload offset: {source}")
        with TemporaryDirectory() as scratch:
            payload = Path(scratch) / source.name
            payload.write_bytes(data[offset:])
            extract_payload(payload, directory, archive)
    else:
        extract_payload(source, directory, archive)
    return directory


def extract_payload(source, directory, archive):
    directory.mkdir()
    extractor = archive.get("extractor", "tar")
    if extractor == "amiga-adf":
        device = BlkDevFactory().open(str(source), read_only=True)
        try:
            volume = ADFSVolume(device)
            volume.open()
            for name, node in walk(volume.get_root_dir()):
                destination = directory / relative_path(name)
                if node.is_dir():
                    destination.mkdir()
                elif node.is_file():
                    with destination.open("xb") as stream:
                        stream.write(node.get_file_data())
                    node.flush()
        finally:
            device.close()
        return
    if extractor == "7zip":
        seven_zip = shutil.which("7z.exe") or (
            Path(os.environ.get("ProgramFiles", "C:/Program Files")) / "7-Zip" / "7z.exe"
        )
        command = [str(seven_zip), "x", "-y", "-bso0", "-bsp0", f"-o{directory}", str(source)]
    elif extractor == "tar":
        command = [
            "tar.exe", "--options", "lha:hdrcharset=ISO-8859-1", "-xf",
            str(source), "-C", str(directory),
            "--", *(relative_path(name).as_posix() for name in archive.get("members", [])),
        ]
    elif extractor == "lzx":
        lzx = shutil.which("lzx.exe")
        if lzx is None:
            raise FileNotFoundError("Install the Amiga LZX CLI (lzx.exe) and add it to PATH.")
        command = [lzx, "x", str(source), str(directory)]
    else:
        raise ValueError(f"Unknown archive extractor: {extractor}")
    subprocess.run(command, check=True)


def unpack_archives(data, archive_dir, scratch):
    extracted = {}
    for filename, archive in data["archives"].items():
        if relative_path(filename).name != filename:
            raise ValueError(f"Expected an archive filename: {filename}")
        extracted[filename] = extract_archive(archive_dir / filename, scratch / filename, archive)
    nested = data.get("nestedArchives", {})
    if nested:
        nested_scratch = scratch / "nested-archives"
        nested_scratch.mkdir()
        for name, archive in nested.items():
            if relative_path(name).name != name or name in extracted:
                raise ValueError(f"Invalid or duplicate nested archive name: {name}")
            parent = archive["archive"]
            if parent not in extracted and parent not in nested:
                raise ValueError(f"Unknown outer archive for {name}: {parent}")
        dependencies = {name: [archive["archive"]] for name, archive in nested.items()}
        for name in TopologicalSorter(dependencies).static_order():
            if name in extracted:
                continue
            archive = nested[name]
            source = extracted[archive["archive"]] / relative_path(archive["source"])
            extracted[name] = extract_archive(source, nested_scratch / name, archive)
    return extracted


def verified_sources(data, archive_dir, scratch):
    extracted = unpack_archives(data, archive_dir, scratch)
    archives = data["archives"] | data.get("nestedArchives", {})
    for entry in data["files"]:
        archive = entry.get("archive")
        root = REPO if archive is None else extracted[archive]
        source = relative_path(entry["source"])
        archive_options = archives.get(archive, {})
        if archive_options.get("extractor") == "7zip" and "memberEncoding" in archive_options:
            # 7-Zip decodes LhA names with the Windows OEM code page.
            encoding = archive_options["memberEncoding"]
            source = relative_path(source.as_posix().encode(encoding).decode("oem", errors="replace"))
        path = root / source
        content = path.read_bytes()
        transform = entry.get("sourceTransform")
        if transform == "setvnc-decode":
            # Match the publisher's Decode utility for SetVNC.coded.
            content = bytes(byte ^ 0x54 for byte in content)
        elif transform is not None:
            raise ValueError(f"Unknown source transform for {path}: {transform}")
        if digest(content) != entry["sha256"]:
            raise ValueError(f"File checksum mismatch: {path}")
        yield entry, content


def parents(path):
    return [parent for parent in path.parents if parent != PurePosixPath(".")]


def installer(data, ordered_dirs, *, removals=(), renames=()):
    owned = {PurePosixPath(entry["path"]) for entry in data["directories"]}
    roots = {path for path in owned if owned.isdisjoint(parents(path))}
    commands = ["FAILAT 5" if removals or renames else "FAILAT 10"]
    for before, after in renames:
        commands.append(f'Rename "SYS:{before}" TO "SYS:{after}"')
    for path in ordered_dirs:
        if path not in roots and roots.isdisjoint(parents(path)):
            commands.extend([f'IF NOT EXISTS "SYS:{path}"', f'  MakeDir "SYS:{path}"', "ENDIF"])
    for path in sorted(roots):
        commands.append(f'Copy "{VOLUME}:{path}" TO "SYS:{path}" ALL CLONE')
    for entry in data["files"]:
        path = PurePosixPath(entry["path"])
        if roots.isdisjoint(parents(path)):
            commands.append(f'Copy "{VOLUME}:{path}" TO "SYS:{path}" CLONE')
    for path in sorted(removals, key=lambda path: (-path.count("/"), path)):
        commands.extend([f'IF EXISTS "SYS:{path}"', f'  Delete "SYS:{path}"', "ENDIF"])
    commands.append('Echo "Package installation complete."')
    return ("\n".join(commands) + "\n").encode("latin-1")


def metadata(entry):
    return MetaInfo(protect=entry["protection"], comment=FSString(entry["comment"]))


def build(data, archive_dir, output, *, removals=(), renames=()):
    if output.suffix.lower() != ".hdf":
        raise ValueError("The output filename must end in .hdf.")
    if output.exists():
        raise FileExistsError(output)
    output.parent.mkdir(parents=True, exist_ok=True)
    owned = {PurePosixPath(entry["path"]): entry for entry in data["directories"]}
    directories = set(owned)
    paths = [PurePosixPath(entry["path"]) for entry in data["files"]] + list(owned)
    for path in paths:
        directories.update(parents(path))
    needs_long_names = any(len(part) > 30 for path in paths for part in path.parts)
    ordered_dirs = sorted(directories, key=lambda path: (len(path.parts), path))
    with TemporaryDirectory(dir=output.parent) as folder:
        scratch = Path(folder)
        file_data = list(verified_sources(data, archive_dir, scratch))

        # Leave room for the data blocks, file headers, directories and bitmap.
        blocks = sum((len(content) + 511) // 512 for _, content in file_data)
        overhead = (blocks + 59) // 60 + 4 * len(file_data) + len(directories)
        cylinders = max(512, (blocks + overhead + 255) // 32)
        stage = scratch / "package.hdf"
        device = BlkDevFactory().create(str(stage), force=False, options={"chs": f"{cylinders},1,32"})
        try:
            volume = ADFSVolume(device)
            volume.create(FSString(VOLUME), is_ffs=True, is_longname=needs_long_names)
            nodes = {PurePosixPath("."): volume.get_root_dir()}
            for path in ordered_dirs:
                info = metadata(owned[path]) if path in owned else None
                nodes[path] = nodes[path.parent].create_dir(FSString(path.name), info)
            for entry, content in file_data:
                path = PurePosixPath(entry["path"])
                nodes[path.parent].create_file(FSString(path.name), content, metadata(entry)).flush()
            script = installer(data, ordered_dirs, removals=removals, renames=renames)
            volume.write_file(script, FSString("Install"))
            volume.close()
        finally:
            device.close()
        stage.rename(output)
    print(f"Built {output} ({len(file_data)} files).")


def walk(directory, parent=""):
    for node in directory.get_entries():
        path = parent + node.get_file_name().get_unicode_name()
        yield path, node
        if node.is_dir():
            yield from walk(node, path + "/")


def verify(data, hdf):
    expected = {entry["path"]: entry for entry in data["files"] + data["directories"]}
    owned = tuple(
        entry["path"] + "/" for entry in data["directories"] if not entry.get("shared", False)
    )
    differences = []
    device = BlkDevFactory().open(str(hdf), read_only=True)
    try:
        volume = ADFSVolume(device)
        volume.open()
        for path, node in walk(volume.get_root_dir()):
            entry = expected.pop(path, None)
            if entry is None:
                if path.startswith(owned):
                    differences.append(f"Unexpected: {path}")
                continue
            actual = node.get_meta_info()
            if (actual.get_protect(), actual.get_comment_unicode_str()) != (entry["protection"], entry["comment"]):
                differences.append(f"Metadata differs: {path}")
            if node.is_file() != ("sha256" in entry):
                differences.append(f"Entry type differs: {path}")
            elif node.is_file():
                if digest(node.get_file_data()) != entry["sha256"]:
                    differences.append(f"Contents differ: {path}")
                node.flush()
    finally:
        device.close()
    differences.extend(f"Missing: {path}" for path in expected)
    if differences:
        raise ValueError("\n".join(differences))
    print(f"Verified {len(data['files'])} files and {len(data['directories'])} package directories in {hdf}.")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    build_args = commands.add_parser("build")
    build_args.add_argument("package")
    build_args.add_argument("--archives", type=Path, required=True)
    build_args.add_argument("--output", type=Path, required=True)
    verify_args = commands.add_parser("verify")
    verify_args.add_argument("package")
    verify_args.add_argument("--hardfile", type=Path, required=True)
    args = parser.parse_args()
    try:
        data = load_package(args.package)
        if args.command == "build":
            build(data, args.archives.resolve(), args.output.resolve())
        else:
            verify(data, args.hardfile.resolve())
    except (OSError, ValueError, KeyError, subprocess.CalledProcessError) as error:
        print(error, file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
