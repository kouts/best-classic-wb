from contextlib import redirect_stderr, redirect_stdout
from io import StringIO
import json
from pathlib import Path
from tempfile import TemporaryDirectory
import unittest
from unittest.mock import patch

import candidate_update
import package
import prepare_update
from prepare_update import compare, review_guarded_changes


IGAME = "Programs/iGame/iGame"


def replacement(path, before, after):
    return compare(
        {path.lower(): {"path": path, **before}},
        {path.lower(): {"path": path, **after}},
    )["changed"][0]


class GuardedChangeTests(unittest.TestCase):
    def test_staged_igame_blocks_prepare_and_build(self):
        with TemporaryDirectory() as folder:
            root = Path(folder)
            (root / "packages").mkdir()
            (root / "binary").write_bytes(b"fixture")
            package_file = {
                "path": IGAME, "source": "binary", "sha256": package.digest(b"fixture"),
                "protection": 0, "comment": "",
            }
            baseline = {
                "name": "iGame", "version": "2.4.6", "baseline": "2.1.12",
                "files": [package_file], "directories": [], "archives": {},
            }
            candidate = {**baseline, "version": "2.6.1", "files": [{**package_file, "protection": 2}]}
            reference = root / "reference.hdf"
            manifest = root / "candidate.json"
            proposal = root / "proposal.json"
            transport = root / "candidate.hdf"
            (root / "packages/igame.json").write_text(json.dumps(baseline), encoding="utf-8")
            manifest.write_text(json.dumps(candidate), encoding="utf-8")
            flags = [
                "igame", "--manifest", str(manifest), "--archives", str(root), "--reference", str(reference),
            ]
            with patch.object(package, "REPO", root), patch.object(prepare_update, "REPO", root):
                with redirect_stdout(StringIO()):
                    package.build(baseline, root, reference)
                    with patch("sys.argv", ["prepare_update.py", *flags, "--output", str(proposal)]):
                        self.assertEqual(prepare_update.main(), 1)
                report = json.loads(proposal.read_text(encoding="utf-8"))
                self.assertEqual(report["status"], "blocked")
                self.assertEqual(report["guardedChanges"], [{
                    "path": IGAME, "before": {"protection": 0}, "after": {"protection": 2}, "status": "undeclared",
                }])
                report["status"] = "ready_for_review"
                del report["guardedChanges"]
                proposal.write_text(json.dumps(report), encoding="utf-8")
                with redirect_stderr(StringIO()) as errors, patch("sys.argv", [
                    "candidate_update.py", "build", *flags, "--proposal", str(proposal),
                    "--output", str(transport),
                ]):
                    self.assertEqual(candidate_update.main(), 1)
                self.assertIn("staged candidate is blocked", errors.getvalue())
                self.assertFalse(transport.exists())

    def test_replacing_binary_with_unchanged_metadata_needs_no_declaration(self):
        change = replacement(IGAME, {"protection": 0, "sha256": "old"}, {"protection": 0, "sha256": "new"})

        self.assertEqual(review_guarded_changes([change], set(), []), [])

    def test_existing_icon_and_checked_settings_are_guarded(self):
        settings = "Programs/iGame/gameslist.csv"
        changes = [
            replacement(path, {"sha256": "old"}, {"sha256": "new"})
            for path in (settings, "Programs/iGame.info")
        ]

        reviews = review_guarded_changes(changes, {settings}, [])
        self.assertEqual([review["status"] for review in reviews], ["undeclared", "undeclared"])
        self.assertTrue(all(review["after"] == {"sha256": "new"} for review in reviews))

    def test_declaration_keys_and_values_must_match(self):
        directory = "Programs/iGame"
        change = replacement(directory, {"protection": 2, "comment": ""}, {"protection": 0, "comment": "new"})
        declaration = {
            "path": directory, "before": {"protection": 2, "comment": ""},
            "after": {"protection": 0, "comment": "new"}, "reason": "Record the fixture's intended metadata.",
        }

        for after in ({"protection": 0}, {"protection": False, "comment": "new"}):
            with self.subTest(after=after):
                reviews = review_guarded_changes([change], set(), [{**declaration, "after": after}])
                self.assertEqual(reviews[0]["status"], "differs")

        reviews = review_guarded_changes([change], set(), [declaration])
        self.assertEqual(reviews[0]["status"], "declared")
        self.assertEqual(reviews[0]["reason"], declaration["reason"])
        self.assertEqual(review_guarded_changes([], set(), [declaration])[0]["status"], "no_matching_change")

    def test_declaration_requires_a_reason_and_unique_literal_path(self):
        declaration = {
            "path": IGAME, "before": {"protection": 0}, "after": {"protection": 2}, "reason": "Fixture",
        }
        with self.assertRaisesRegex(ValueError, "a reason"):
            review_guarded_changes([], set(), [{**declaration, "reason": " "}])
        with self.assertRaisesRegex(ValueError, "Duplicate"):
            review_guarded_changes([], set(), [declaration, {**declaration, "path": IGAME.lower()}])


if __name__ == "__main__":
    unittest.main()
