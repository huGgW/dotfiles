#!/usr/bin/env python3
"""Read-only Git candidate identity and LF-normalized contract block hashes."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import stat
import subprocess


def digest(data):
    return hashlib.sha256(data).hexdigest()


def git(root, *args):
    return subprocess.check_output(
        ["git", "-C", str(root), *args],
        env={**os.environ, "GIT_OPTIONAL_LOCKS": "0"},
    )


def excluded(path):
    return path == b"BACKPRESSURE.md" or path == b".backpressure" or path.startswith(
        b".backpressure/"
    )


def object_entry(path, mode, object_id):
    if mode not in (b"100644", b"100755", b"120000"):
        raise ValueError("Unsupported Git mode (including submodules): " + repr(path))

    return [path.hex(), mode.decode(), object_id]


def blob_digests(root, object_ids):
    # Step 1: Request each shared object once, draining pipes synchronously.
    requested = sorted(set(object_ids))

    if not requested:
        return {}

    output = subprocess.run(
        ["git", "-C", str(root), "cat-file", "--batch"],
        input=b"\n".join(requested) + b"\n",
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=True,
        env={**os.environ, "GIT_OPTIONAL_LOCKS": "0"},
    ).stdout

    # Step 2: Parse headers by line, but binary bodies strictly by declared size.
    result = {}
    offset = 0

    for expected in requested:
        header_end = output.find(b"\n", offset)
        header = output[offset:header_end].split()

        if header_end < 0 or len(header) != 3 or header[:2] != [expected, b"blob"]:
            raise ValueError("Invalid or non-blob batch object: " + repr(expected))

        size = int(header[2])
        begin = header_end + 1
        end = begin + size

        if size < 0 or end >= len(output) or output[end:end + 1] != b"\n":
            raise ValueError("Truncated batch object: " + repr(expected))

        result[expected] = digest(output[begin:end])
        offset = end + 1

    if offset != len(output):
        raise ValueError("Unexpected trailing batch output")

    return result


def tree_entries(root, ref):
    entries = {}

    for record in git(root, "ls-tree", "-rz", "--full-tree", ref).split(b"\0"):
        if not record:
            continue

        metadata, path = record.split(b"\t", 1)
        mode, _, object_id = metadata.split()

        if not excluded(path):
            entries[path] = object_entry(path, mode, object_id)

    return entries


def index_entries(root):
    entries = {}

    for record in git(root, "ls-files", "--stage", "-z").split(b"\0"):
        if not record:
            continue

        metadata, path = record.split(b"\t", 1)
        mode, object_id, stage = metadata.split()

        if excluded(path):
            continue

        if stage != b"0":
            raise ValueError("Unmerged index: " + repr(path))

        entries[path] = object_entry(path, mode, object_id)

    return entries


def worktree_entry(root, path, tracked=False):
    # Step 1: Validate lexical scope and avoid following symlink parents.
    parts = path.split(b"/")

    if path.startswith(b"/") or any(part in (b"", b".", b"..") for part in parts):
        raise ValueError("Expected repository-relative file path: " + repr(path))

    current = os.fsencode(root)

    for part in parts[:-1]:
        current = os.path.join(current, part)

        if os.path.islink(current):
            raise ValueError("Symlink parent would escape candidate traversal: " + repr(path))

    # Step 2: Identify the entry without following its final symlink.
    filename = os.path.join(os.fsencode(root), path)

    try:
        mode = os.lstat(filename).st_mode
    except FileNotFoundError:
        return None
    except NotADirectoryError:
        if tracked:
            return None

        raise ValueError("Expected file or symlink: " + repr(path)) from None

    # Step 3: Bind raw link targets or regular bytes and executable mode.
    if stat.S_ISLNK(mode):
        return [path.hex(), "120000", digest(os.readlink(filename))]

    if not stat.S_ISREG(mode):
        if tracked and stat.S_ISDIR(mode):
            return None

        raise ValueError("Expected file or symlink: " + repr(path))

    with open(filename, "rb") as stream:
        content = stream.read()

    git_mode = "100755" if mode & 0o111 else "100644"
    return [path.hex(), git_mode, digest(content)]


def state_identity(root, base, untracked=None):
    # Step 1: Establish one repository root and content-based base/index layers.
    root = Path(root).resolve()
    actual_root = Path(os.fsdecode(git(root, "rev-parse", "--show-toplevel").rstrip(b"\n")))

    if actual_root.resolve() != root:
        raise ValueError("--root must name the Git repository root")

    head = git(root, "rev-parse", "HEAD").decode().strip()
    base_entries = tree_entries(root, base)
    staged = index_entries(root)
    head_entries = tree_entries(root, head)

    objects = blob_digests(
        root,
        (entry[2] for layer in (base_entries, staged) for entry in layer.values()),
    )

    for layer in (base_entries, staged):
        for entry in layer.values():
            entry[2] = objects[entry[2]]

    # Step 2: Include tracked deletions and declared relevant untracked paths.
    if untracked is None:
        paths = git(root, "ls-files", "--others", "--exclude-standard", "-z").split(b"\0")
        untracked_paths = {path for path in paths if path and not excluded(path)}
    else:
        untracked_paths = {os.fsencode(path) for path in untracked}

        for path in untracked_paths:
            if excluded(path) or worktree_entry(root, path) is None:
                raise ValueError("Explicit untracked path is excluded or missing: " + repr(path))

    working = []
    tracked_paths = set(base_entries) | set(staged) | set(head_entries)

    for path in sorted(tracked_paths | untracked_paths):
        entry = worktree_entry(root, path, tracked=path in tracked_paths)

        if entry is not None:
            working.append(entry)

    # Step 3: Hash ordered content layers, never commit IDs or root paths.
    payload = {
        "version": 1,
        "base": [base_entries[path] for path in sorted(base_entries)],
        "index": [staged[path] for path in sorted(staged)],
        "worktree": working,
    }
    encoded = json.dumps(payload, sort_keys=True, separators=(",", ":")).encode()
    return {
        "state_id": digest(encoded),
        "head": head,
        "untracked": [os.fsdecode(path) for path in sorted(untracked_paths)],
    }


def block_hashes(path):
    content = Path(path).read_bytes().replace(b"\r\n", b"\n").replace(b"\r", b"\n")
    result = {}

    for name in ("validation-spec", "publication-spec"):
        start = f"<!-- {name}:start -->".encode()
        end = f"<!-- {name}:end -->".encode()

        if name == "publication-spec" and start not in content and end not in content:
            continue

        if content.count(start) != 1 or content.count(end) != 1:
            raise ValueError("Expected unique matching markers: " + name)

        begin = content.index(start) + len(start)
        finish = content.index(end)

        if finish < begin:
            raise ValueError("Reversed markers: " + name)

        result[name] = digest(content[begin:finish])

    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    state = commands.add_parser("state")
    state.add_argument("--root", required=True)
    state.add_argument("--base", required=True)
    state.add_argument("--untracked", action="append", default=None)
    blocks = commands.add_parser("blocks")
    blocks.add_argument("path")
    args = parser.parse_args()

    if args.command == "state":
        result = state_identity(args.root, args.base, args.untracked)
    else:
        result = block_hashes(args.path)

    print(json.dumps(result, sort_keys=True))


if __name__ == "__main__":
    main()
