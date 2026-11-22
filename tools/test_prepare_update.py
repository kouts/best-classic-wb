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

    def test_removed_entries_require_an_exact_declaration(self):
        entry = {"path": "Tools/Old", "type": "file", "protection": 2, "comment": "", "sha256": "old"}
        reviews = review_guarded_changes([], set(), [], removed=[entry])
        self.assertEqual(reviews[0]["status"], "undeclared")
        self.assertEqual(reviews[0]["after"], {})
        self.assertEqual(reviews[0]["before"]["sha256"], "old")
        declaration = {**{field: reviews[0][field] for field in ("path", "before", "after")},
                       "reason": "Remove the obsolete fixture executable."}
        self.assertEqual(review_guarded_changes([], set(), [declaration], removed=[entry])[0]["status"], "declared")

    def test_installer_copies_before_literal_removals_and_deletes_children_first(self):
        candidate = {"directories": [], "files": [{"path": "Tools/Moved"}]}
        script = package.installer(
            candidate, [], removals=["Tools/Old", "Tools/Old/File"],
            renames=[("Tools/OldCase", "Tools/oldcase")],
        ).decode("latin-1").splitlines()
        self.assertEqual(script, [
            "FAILAT 5",
            'Rename "SYS:Tools/OldCase" TO "SYS:Tools/oldcase"',
            'Copy "BCWB-Package:Tools/Moved" TO "SYS:Tools/Moved" CLONE',
            'IF EXISTS "SYS:Tools/Old/File"',
            '  Delete "SYS:Tools/Old/File"',
            "ENDIF",
            'IF EXISTS "SYS:Tools/Old"',
            '  Delete "SYS:Tools/Old"',
            "ENDIF",
            'Echo "Package installation complete."',
        ])

    def test_shared_nonempty_and_pattern_targets_are_blocked(self):
        shared = {"path": "Tools/Shared", "type": "directory", "protection": 0}
        wildcard = {"path": "Tools/Old#?", "type": "file", "protection": 2}
        protected = {"path": "Tools/Protected", "type": "file", "protection": 3}
        external = {"path": "Tools/Shared/External", "type": "file", "protection": 0}
        before = {entry["path"].lower(): entry for entry in (shared, wildcard, protected)}
        final = {external["path"].lower(): external}
        conflicts = prepare_update.ownership_conflicts("fixture", before, {}, before | final, final, {"tools/shared"})
        self.assertEqual({conflict["kind"] for conflict in conflicts}, {
            "shared_path_operation", "drawer_has_retained_children", "unsafe_path_operation", "delete_protected",
        })

    def test_type_conversion_requires_the_complete_before_and_after_metadata(self):
        path = "Tools/Old"
        file_entry = {"type": "file", "protection": 2, "comment": "old", "sha256": "hash"}
        drawer = {"type": "directory", "protection": 2, "comment": "new"}
        change = replacement(path, file_entry, drawer)
        review, = review_guarded_changes([change], set(), [])
        self.assertEqual(review, {"path": path, "before": file_entry, "after": drawer, "status": "undeclared"})
        declaration = {"path": path, "before": file_entry, "after": drawer, "reason": "Replace the fixture."}
        self.assertEqual(review_guarded_changes([change], set(), [declaration])[0]["status"], "declared")

    def test_conversion_rejects_external_children_and_delete_protection(self):
        path = "Tools/Old"
        drawer = {"path": path, "type": "directory", "protection": 1}
        file_entry = {"path": path, "type": "file", "protection": 0}
        parent = {"path": "Tools", "type": "directory", "protection": 0}
        external = {"path": "Tools/Old/External", "type": "file", "protection": 0}
        before = {"tools/old": drawer}
        after = {"tools/old": file_entry}
        installed = before | {"tools": parent, "tools/old/external": external}
        final = installed | after
        conflicts = prepare_update.ownership_conflicts("fixture", before, after, installed, final, set())
        self.assertEqual({conflict["kind"] for conflict in conflicts}, {
            "drawer_has_retained_children", "delete_protected",
        })


if __name__ == "__main__":
    unittest.main()
