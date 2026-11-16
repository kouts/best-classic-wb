"""Build a local Amiga package hardfile or verify an installed hardfile."""

import argparse
import hashlib
import json
from pathlib import Path, PurePosixPath
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
    data = json.loads((REPO / "packages" / f"{package}.json").read_text(encoding="utf-8"))
    paths = set()
    for entry in data["files"] + data["directories"]:
        key = relative_path(entry["path"]).as_posix().lower()
        if key == "install" or key in paths:
            raise ValueError(f"Reserved or duplicate install path: {entry['path']}")
        paths.add(key)
    return data


def unpack_archives(data, archive_dir, scratch):
    extracted = {}
    for filename, archive in data["archives"].items():
        if relative_path(filename).name != filename:
            raise ValueError(f"Expected an archive filename: {filename}")
        source = archive_dir / filename
        if digest(source.read_bytes()) != archive["sha256"]:
            raise ValueError(f"Archive checksum mismatch: {source}")
        directory = scratch / filename
        directory.mkdir()
        subprocess.run(
            ["tar.exe", "--options", "lha:hdrcharset=ISO-8859-1", "-xf",
             str(source), "-C", str(directory)],
            check=True,
        )
        extracted[filename] = directory
    return extracted


def parents(path):
    return [parent for parent in path.parents if parent != PurePosixPath(".")]


def installer(data, ordered_dirs):
    owned = {PurePosixPath(entry["path"]) for entry in data["directories"]}
    roots = {path for path in owned if owned.isdisjoint(parents(path))}
    commands = ["FAILAT 10"]
    for path in ordered_dirs:
        if path not in roots and roots.isdisjoint(parents(path)):
            commands.extend([f'IF NOT EXISTS "SYS:{path}"', f'  MakeDir "SYS:{path}"', "ENDIF"])
    for path in sorted(roots):
        commands.append(f'Copy "{VOLUME}:{path}" TO "SYS:{path}" ALL CLONE')
    for entry in data["files"]:
        path = PurePosixPath(entry["path"])
        if roots.isdisjoint(parents(path)):
            commands.append(f'Copy "{VOLUME}:{path}" TO "SYS:{path}" CLONE')
    commands.append('Echo "Package installation complete."')
    return ("\n".join(commands) + "\n").encode("latin-1")


def metadata(entry):
    return MetaInfo(protect=entry["protection"], comment=FSString(entry["comment"]))


def build(data, archive_dir, output):
    if output.suffix.lower() != ".hdf":
        raise ValueError("The output filename must end in .hdf.")
    if output.exists():
        raise FileExistsError(output)
    output.parent.mkdir(parents=True, exist_ok=True)
    owned = {PurePosixPath(entry["path"]): entry for entry in data["directories"]}
    directories = set(owned)
    for text in [entry["path"] for entry in data["files"]] + [str(path) for path in owned]:
        directories.update(parents(PurePosixPath(text)))
    ordered_dirs = sorted(directories, key=lambda path: (len(path.parts), path))
    with TemporaryDirectory(dir=output.parent) as folder:
        scratch = Path(folder)
        extracted = unpack_archives(data, archive_dir, scratch)
        file_data = []
        for entry in data["files"]:
            archive = entry.get("archive")
            root = REPO if archive is None else extracted[archive]
            path = root / relative_path(entry["source"])
            content = path.read_bytes()
            if digest(content) != entry["sha256"]:
                raise ValueError(f"File checksum mismatch: {path}")
            file_data.append((entry, content))

        # Leave room for the data blocks, file headers, directories and bitmap.
        blocks = sum((len(content) + 511) // 512 for _, content in file_data)
        overhead = (blocks + 59) // 60 + 4 * len(file_data) + len(directories)
        cylinders = max(512, (blocks + overhead + 255) // 32)
        stage = scratch / "package.hdf"
        device = BlkDevFactory().create(str(stage), force=False, options={"chs": f"{cylinders},1,32"})
        try:
            volume = ADFSVolume(device)
            volume.create(FSString(VOLUME), is_ffs=True)
            nodes = {PurePosixPath("."): volume.get_root_dir()}
            for path in ordered_dirs:
                info = metadata(owned[path]) if path in owned else None
                nodes[path] = nodes[path.parent].create_dir(FSString(path.name), info)
            for entry, content in file_data:
                path = PurePosixPath(entry["path"])
                nodes[path.parent].create_file(FSString(path.name), content, metadata(entry)).flush()
            volume.write_file(installer(data, ordered_dirs), FSString("Install"))
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
    owned = tuple(entry["path"] + "/" for entry in data["directories"])
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
