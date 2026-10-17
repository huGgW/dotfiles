"""Focused stdlib tests using disposable Git repositories."""

import hashlib
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

from state_identity import blob_digests, block_hashes, state_identity


class StateIdentityTests(unittest.TestCase):
    def setUp(self):
        self.workspace = tempfile.TemporaryDirectory()
        self.addCleanup(self.workspace.cleanup)
        self.root = Path(self.workspace.name)
        self.git("init", "-q")
        self.git("config", "user.name", "Test")
        self.git("config", "user.email", "test@example.invalid")
        self.file = self.root / "file.txt"
        self.file.write_bytes(b"base\n")
        self.git("add", ".")
        self.git("commit", "-qm", "base")
        self.base = self.git("rev-parse", "HEAD").strip().decode()

    def git(self, *args):
        return subprocess.check_output(["git", "-C", str(self.root), *args])

    def identity(self, base=None, untracked=None):
        return state_identity(self.root, base or self.base, untracked)["state_id"]

    def test_staged_and_unstaged_bytes_are_both_bound(self):
        original = self.identity()
        self.file.write_bytes(b"staged\n")
        self.git("add", "file.txt")
        self.file.write_bytes(b"base\n")
        staged_only = self.identity()
        self.assertNotEqual(original, staged_only)
        self.file.write_bytes(b"working\n")
        self.assertNotEqual(staged_only, self.identity())

    def test_commit_and_equivalent_base_are_object_independent(self):
        self.file.write_bytes(b"candidate\n")
        self.git("add", "file.txt")
        frozen = self.identity()
        self.git("commit", "-qm", "candidate")
        self.assertEqual(frozen, self.identity())
        alternate = self.git("commit-tree", f"{self.base}^{{tree}}", "-m", "same tree").strip().decode()
        self.assertEqual(frozen, self.identity(base=alternate))

    def test_untracked_modes_symlinks_and_deletion(self):
        original = self.identity()
        extra = self.root / "extra"
        extra.write_bytes(b"extra")
        added = self.identity()
        self.assertNotEqual(original, added)
        extra.chmod(0o755)
        executable = self.identity()
        self.assertNotEqual(added, executable)
        extra.unlink()
        extra.symlink_to("missing-one")
        linked = self.identity()
        extra.unlink()
        extra.symlink_to("missing-two")
        self.assertNotEqual(linked, self.identity())
        extra.unlink()
        self.file.unlink()
        self.assertNotEqual(original, self.identity())

    def test_protocol_paths_excluded_in_all_layers(self):
        original = self.identity()
        (self.root / "BACKPRESSURE.md").write_text("mutable")
        archive = self.root / ".backpressure"
        archive.mkdir()
        (archive / "run.md").write_text("history")
        self.git("add", ".")
        self.assertEqual(original, self.identity())
        self.git("commit", "-qm", "protocol only")
        self.assertEqual(original, self.identity())
        self.assertEqual(original, self.identity(base="HEAD"))

    def test_explicit_ignored_paths_and_path_safety(self):
        (self.root / ".git" / "info" / "exclude").write_text("ignored\n")
        ignored = self.root / "ignored"
        ignored.write_bytes(b"first")
        default = self.identity()
        explicit = self.identity(untracked=["ignored"])
        ignored.write_bytes(b"second")
        self.assertEqual(default, self.identity())
        self.assertNotEqual(explicit, self.identity(untracked=["ignored"]))

        for path in ("../outside", "/absolute", ".", "missing"):
            with self.subTest(path=path), self.assertRaises(ValueError):
                self.identity(untracked=[path])

    def test_submodule_mode_rejected(self):
        self.git("update-index", "--add", "--cacheinfo", f"160000,{self.base},nested")

        with self.assertRaises(ValueError):
            self.identity()

    def test_tracked_mode_and_symlink_target_changes(self):
        original = self.identity()
        self.file.chmod(0o755)
        self.assertNotEqual(original, self.identity())
        self.file.unlink()
        self.file.symlink_to("dangling")
        working = self.identity()
        self.git("add", "file.txt")
        self.assertNotEqual(working, self.identity())

    def test_symlink_parent_rejected(self):
        (self.root / "link").symlink_to(self.root, target_is_directory=True)

        with self.assertRaises(ValueError):
            self.identity(untracked=["link/file.txt"])

    def test_tracked_file_replaced_by_directory(self):
        original = self.identity()
        self.file.unlink()
        self.file.mkdir()
        (self.file / "child").write_bytes(b"new leaf")
        self.assertNotEqual(original, self.identity())
        self.git("add", "-A")
        staged = self.identity()
        self.git("commit", "-qm", "file to directory")
        self.assertEqual(staged, self.identity())

        with self.assertRaises(ValueError):
            self.identity(untracked=["file.txt"])

    def test_tracked_directory_replaced_by_file(self):
        directory = self.root / "directory"
        directory.mkdir()
        child = directory / "child"
        child.write_bytes(b"old leaf")
        self.git("add", ".")
        self.git("commit", "-qm", "directory base")
        self.base = self.git("rev-parse", "HEAD").strip().decode()
        original = self.identity()
        child.unlink()
        directory.rmdir()
        directory.write_bytes(b"new file")
        self.assertNotEqual(original, self.identity())
        self.git("add", "-A")
        staged = self.identity()
        self.git("commit", "-qm", "directory to file")
        self.assertEqual(staged, self.identity())

    def test_state_read_is_deterministic_and_preserves_index(self):
        index = self.root / ".git" / "index"
        before = index.read_bytes()
        self.assertEqual(self.identity(), self.identity())
        self.assertEqual(before, index.read_bytes())

    def test_batch_binary_shared_objects_and_bounded_processes(self):
        # Step 1: Create repeated objects with arbitrary binary/newline content.
        content = bytes(range(256)) * 1024 + b"\nheader blob 123\n\x00\xff"

        for number in range(100):
            (self.root / f"fixture-{number}").write_bytes(content)

        self.git("add", ".")
        self.git("commit", "-qm", "shared binary")
        self.base = self.git("rev-parse", "HEAD").strip().decode()
        (self.root / "fixture-0").write_bytes(b"staged\n\x00\xff")
        self.git("add", "fixture-0")
        (self.root / "fixture-0").write_bytes(b"working\n\xff")
        index = self.root / ".git" / "index"
        original_index = index.read_bytes()

        # Step 2: Compare batching with the prior per-object digest semantics.
        def legacy_digests(root, objects):
            return {
                object_id: hashlib.sha256(self.git("cat-file", "blob", object_id)).hexdigest()
                for object_id in set(objects)
            }

        with patch("state_identity.blob_digests", side_effect=legacy_digests):
            expected = self.identity()

        # Step 3: Assert fixed process count, shared requests, and no index writes.
        with patch("subprocess.Popen", wraps=subprocess.Popen) as processes:
            with patch("subprocess.run", wraps=subprocess.run) as batches_run:
                self.assertEqual(expected, self.identity())

        self.assertEqual(7, processes.call_count)
        batches = [call for call in processes.call_args_list if "--batch" in call.args[0]]
        self.assertEqual(1, len(batches))
        batch_call = next(call for call in batches_run.call_args_list if "--batch" in call.args[0])
        requests = batch_call.kwargs["input"].splitlines()
        self.assertEqual(3, len(requests))
        self.assertEqual(len(requests), len(set(requests)))
        self.assertEqual(original_index, index.read_bytes())

    def test_batch_rejects_missing_and_nonblob_objects(self):
        missing = b"0" * 40

        for object_id in (missing, self.base.encode()):
            with self.subTest(object_id=object_id), self.assertRaises(ValueError):
                blob_digests(self.root, [object_id])


class BlockHashTests(unittest.TestCase):
    def test_publication_block_is_independent(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "contract.md"
            validation = "<!-- validation-spec:start -->goal<!-- validation-spec:end -->"
            publication = "<!-- publication-spec:start -->ship<!-- publication-spec:end -->"
            path.write_text(validation + publication)
            original = block_hashes(path)
            path.write_text(validation + publication.replace("ship", "changed"))
            changed = block_hashes(path)
            self.assertEqual(original["validation-spec"], changed["validation-spec"])
            self.assertNotEqual(original["publication-spec"], changed["publication-spec"])

    def test_raw_lf_normalization_and_optional_publication(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "contract.md"
            path.write_bytes(b"outside\r\n<!-- validation-spec:start -->\r\nraw  \r\n<!-- validation-spec:end -->\r\n")
            result = block_hashes(path)
            self.assertEqual(result, {"validation-spec": hashlib.sha256(b"\nraw  \n").hexdigest()})
            path.write_bytes(path.read_bytes().replace(b"\r\n", b"\n"))
            self.assertEqual(result, block_hashes(path))

    def test_missing_duplicate_reversed_markers_rejected(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "contract.md"
            start = "<!-- validation-spec:start -->"
            end = "<!-- validation-spec:end -->"

            for content in ("", start, start + start + end, end + start):
                path.write_text(content)

                with self.subTest(content=content), self.assertRaises(ValueError):
                    block_hashes(path)


if __name__ == "__main__":
    unittest.main()
