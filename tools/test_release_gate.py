from contextlib import redirect_stdout
from io import StringIO
import json
from pathlib import Path
from shutil import copyfile
from tempfile import TemporaryDirectory
import unittest
from zipfile import ZipFile

from package import build
from release_gate import verify_release


class ReleaseGateTests(unittest.TestCase):
    def test_requires_the_tested_zip_and_matching_metadata(self):
        with TemporaryDirectory() as folder:
            root = Path(folder)
            zip_path = root / "release.zip"
            with ZipFile(zip_path, "w") as archive:
                archive.writestr("payload", "verified bytes")
            tested = root / "tested.zip"
            copyfile(zip_path, tested)
            reference = root / "expected.hdf"
            installed = root / "installed.hdf"
            changed = root / "changed.hdf"
            evidence = root / "runtime.md"
            evidence.write_text("Tested the fixture in WinUAE.", encoding="utf-8")
            drawer = {"path": "Tools", "protection": 0, "comment": "expected"}
            data = {"files": [], "directories": [drawer], "archives": {}}
            with redirect_stdout(StringIO()):
                build(data, root, reference)
                build(data, root, installed)
                build({**data, "directories": [{**drawer, "comment": "changed"}]}, root, changed)

                report = root / "matched.json"
                verify_release(zip_path, tested, reference, installed, evidence, report)
                self.assertEqual(json.loads(report.read_text(encoding="utf-8"))["status"], "matched")

                mismatch = root / "mismatch.json"
                with self.assertRaisesRegex(ValueError, "differs from the expected filesystem"):
                    verify_release(zip_path, tested, reference, changed, evidence, mismatch)
                self.assertEqual(json.loads(mismatch.read_text(encoding="utf-8"))["differences"]["changed"], ["Tools"])

                tested.write_bytes(b"untested")
                rejected = root / "untested.json"
                with self.assertRaisesRegex(ValueError, "differs from the ZIP tested in WinUAE"):
                    verify_release(zip_path, tested, reference, installed, evidence, rejected)
                self.assertFalse(rejected.exists())


if __name__ == "__main__":
    unittest.main()
