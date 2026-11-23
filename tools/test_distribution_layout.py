from contextlib import redirect_stdout
from io import StringIO
import json
from pathlib import Path
from tempfile import TemporaryDirectory
import unittest
from unittest.mock import patch
from zipfile import ZipFile, ZipInfo

import distribution
import package


class DistributionLayoutTests(unittest.TestCase):
    def test_build_templates_new_drawers_and_both_types_of_replacement(self):
        with TemporaryDirectory() as folder:
            root = Path(folder)
            (root / "packages").mkdir()
            stock_path = root / "stock.zip"
            output = root / "release.zip"
            payload = distribution.PAYLOAD
            installer_path = distribution.RELEASE_ROOT + "BCWB"
            installer = b'COPY "BCWB_Files" TO SYS: ALL BUF 10\nEcho Done\n'
            with ZipFile(stock_path, "w") as archive:
                archive.writestr(installer_path, installer)
                archive.writestr(payload + "Tools/", b"")
                donor = ZipInfo(payload + "Tools/Template/")
                donor.external_attr = 0x41ED0010
                archive.writestr(donor, b"")
                archive.writestr(payload + "Tools/Before", b"old file")
                archive.writestr(payload + "Tools/ToFile/", b"")

            file_paths = ["Tools/Before/Nested/marker", "Tools/ToFile"]
            for name in [installer_path, *(payload + path for path in file_paths)]:
                target = root / name
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_bytes(installer if name == installer_path else b"fixture")
            package_data = {
                "baseline": distribution.BASELINE, "archives": {},
                "developmentZipRemovals": ["Tools/Before", "Tools/ToFile"],
                "directories": [{
                    "path": path, "developmentZipTemplate": "Tools/Template",
                    "protection": 4, "comment": "Review drawer",
                } for path in ("Tools/Before", "Tools/Before/Nested", "Tools/Before/Empty")],
                "files": [{
                    "path": path, "source": payload + path, "developmentZipTemplate": "Tools/Before",
                    "protection": 2, "comment": "Review file", "sha256": package.digest(b"fixture"),
                } for path in file_paths],
            }
            (root / "packages/test.json").write_text(json.dumps(package_data), encoding="utf-8")
            checkout_files = {installer_path, *(payload + path for path in file_paths)}
            with (
                patch.object(distribution, "REPO", root), patch.object(package, "REPO", root),
                patch.object(distribution, "STOCK_SHA256", package.digest(stock_path.read_bytes())),
                patch.object(distribution, "tracked_sources", return_value=checkout_files),
                redirect_stdout(StringIO()),
            ):
                distribution.build(stock_path, root, output, development=True)

            with ZipFile(output) as release:
                self.assertNotIn(payload + "Tools/Before", release.namelist())
                self.assertNotIn(payload + "Tools/ToFile/", release.namelist())
                self.assertEqual(release.read(payload + "Tools/ToFile"), b"fixture")
                self.assertTrue(release.getinfo(payload + "Tools/Before/Empty/").is_dir())
                self.assertEqual(release.getinfo(payload + "Tools/Before/").external_attr, donor.external_attr)
                self.assertIn(b'FileNote "SYS:Tools/Before" "Review drawer"', release.read(installer_path))
            ledger = json.loads(output.with_suffix(".sources.json").read_text(encoding="utf-8"))
            self.assertEqual(ledger["directoryAdditions"][payload + "Tools/Before/"]["package"], "test")
            self.assertIn(payload + "Tools/Before/Empty/", ledger["files"][installer_path]["metadataEntries"])

    def test_missing_parent_drawer_rejects_build_layout(self):
        drawer = {"path": "Tools/Missing/New", "developmentZipTemplate": "Tools/Template",
                  "protection": 0, "comment": ""}
        with self.assertRaisesRegex(ValueError, "No declared parent drawer"):
            distribution.directory_additions(
                {"test": {"directories": [drawer]}}, {distribution.PAYLOAD + "Tools/Template/"}, {},
            )


if __name__ == "__main__":
    unittest.main()
