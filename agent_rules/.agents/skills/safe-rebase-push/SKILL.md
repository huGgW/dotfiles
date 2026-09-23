---
name: safe-rebase-push
description: >
  Use when a user explicitly asks to rebase the current branch and then update a
  specific remote branch with force-with-lease, including practical requests such
  as "rebase and force-with-lease push", "rebase my branch onto origin/main and
  update origin/feature", "리베이스 후 --force-with-lease로 푸시해줘",
  "현재 브랜치를 main에 리베이스하고 원격 브랜치를 안전하게 강제 푸시해줘", or
  "lease를 걸고 리베이스된 브랜치를 원격에 반영해줘". Do not use this skill for
  rebase-only requests or ordinary push requests, and never expand either into a
  force-push operation.
---

# Safe Rebase and Force-With-Lease Push

## Scope and Authorization

This workflow is intentionally narrow: it operates on the currently checked-out
branch, rebases it onto one resolved local or remote target, and updates one exact
remote destination ref. It does not switch branches, update additional refs, or
provide a bundled execution script.

An explicit request to rebase and force-with-lease push against exact, unchanged
targets authorizes those two exact actions. Do not ask again immediately before the
push solely because it is a force-with-lease push. Ask and stop when the rebase
target or push destination is ambiguous, the operation would create a remote branch,
the remote tip has not been incorporated into the original local history, a Git
operation's semantics are unclear, validation fails, or either checked ref moves.

Never infer `origin`. Never substitute `--force`, silently refresh a lease,
auto-retry an unknown push outcome, bypass hooks, use `reset`, `clean`, `stash`, or
autostash, or mutate another ref.

## Required Workflow

Record the exact commands, full ref names, and object IDs used at every checkpoint.
Treat a failed command as a stop condition unless this workflow explicitly says how
to investigate it.

### 1. Inspect Before Mutating

1. Identify the repository, current branch, `HEAD`, configured remotes, and upstream
   information. The current branch must be a branch, not detached `HEAD`.
2. Inspect tracked changes with `git status --porcelain=v1 --untracked-files=no`.
   Require no staged or unstaged tracked changes; do not hide them with stash or
   autostash. Untracked files are allowed. Inventory them separately with
   `git status --porcelain=v1 --untracked-files=all`, preserve them, and never clean,
   move, overwrite, stage, or commit them as part of this workflow. If Git reports
   that an untracked path would be overwritten, stop and ask the user to resolve it.
3. Detect an in-progress rebase, merge, cherry-pick, revert, or other operation.
   Stop and ask rather than layering a new operation over it.
4. Resolve one exact rebase target and one exact push remote plus destination full
   ref. Inputs such as `main`, `feature`, or an omitted remote are ambiguous when
   more than one interpretation is possible; ask instead of guessing.
5. Resolve the remote's actual push URL with `git remote get-url --push --all`.
   Require exactly one push URL and reject mirror remotes; redact embedded
   credentials from every record or report.

For a remote rebase target, resolve its remote and full remote branch ref, fetch that
specific target before snapshotting, and use the fetched commit as a fixed target.
For a local target, resolve the supplied local ref to its commit. Do not fetch an
unrelated remote or branch.

### 2. Establish a Safe Snapshot

After the required fetch, record:

- `original_oid`: the current branch `HEAD` before rebase;
- `target_oid`: the exact commit object to rebase onto;
- `expected_destination_oid`: the destination full ref's current OID read from the
  named push remote; and
- the resolved source for each value, including remote and full ref names.

Use full ref names (for example, `refs/heads/feature`) for remote checks and an
exact-object command such as `git rev-parse <ref>^{commit}` for local values. Obtain
the expected destination OID from the remote itself, for example with
`git ls-remote --refs <push-remote> <destination-full-ref>`. If it does not exist,
the push would create a branch: ask for explicit authorization and stop. Do not use
an abbreviated ref or a tracking ref as the lease name.

Confirm that `expected_destination_oid` is an ancestor of `original_oid`, such as
with `git merge-base --is-ancestor <expected-destination-oid> <original-oid>`. This
proves the force-with-lease update will not discard a remote tip absent from the
original local history. If it is not an ancestor, stop and explain the divergence;
do not proceed merely because the lease would technically protect the ref.

### 3. Rebase Onto the Fixed Target

Rebase the current branch onto `target_oid`, preserving the tracked-clean rule and
disabling autostash explicitly when available:

```sh
git rebase --no-autostash <target_oid>
```

Do not re-resolve the symbolic target during the rebase. A conflict is a decision
point, not an invitation to select a blanket merge strategy. Follow
[`references/conflict-policy.md`](references/conflict-policy.md). For migration
identity, ordering, or history concerns, apply the general conservative rule and
the specific Flyway guidance in [`references/flyway-policy.md`](references/flyway-policy.md).

### 4. Validate the Rebasing Result

Before any push, confirm that no Git operation remains in progress, the index and
tracked worktree are clean, the pre-existing untracked files remain preserved,
`HEAD` is the intended rebased commit, and the result descends from the fixed
`target_oid`. Run the user-requested or repository-required focused validation. If
validation fails, report it and stop; do not push an unvalidated result. Report any
new untracked files created by validation rather than deleting or staging them.

After validation succeeds, record the exact commit as `result_oid`. Use this fixed
OID as the push source rather than resolving `HEAD` again during the push.

### 5. Re-check Immediately Before Push

Re-read the rebase target and destination from their authoritative sources immediately
before pushing. For a remote target, query its named remote/full ref; for a local
target, re-resolve its exact supplied ref. Query the destination from the named push
remote's recorded push URL and full ref. Confirm that the current branch still points
to `result_oid`. The target and destination values must still equal `target_oid` and
`expected_destination_oid` respectively. If any value moved, stop and report the old
and new OIDs; do not refresh the snapshot or lease in place.

### 6. Push One Explicit Ref and Verify It

Push exactly one source-to-destination ref with the recorded full-ref lease:

```sh
git push --porcelain --verify --no-follow-tags --recurse-submodules=check \
  --force-with-lease=<destination-full-ref>:<expected-destination-oid> \
  <push-remote> <result-oid>:<destination-full-ref>
```

Do not use `--force`, a bare `--force-with-lease`, an implicit destination, `--all`,
or a matching push refspec. Respect hooks; do not pass a hook-bypass option.

After a successful command, read the destination ref back from the recorded push URL
and verify it equals `result_oid`. Record the redacted endpoint, full ref, and
observed OID.

## Conflicts, Abort, and Uncertain Outcomes

During a conflict, determine whether the resolution is mechanically provable before
editing. Otherwise stop for a bounded user decision as described in the conflict
policy. Do not use `git rebase --skip` unless the user has explicitly decided that
the particular commit should be omitted.

Before `git rebase --abort`, inspect whether the user has made conflict-resolution
work that aborting would discard. Explain that loss and ask before aborting when such
work exists. Prefer creating a non-destructive recovery ref or branch that records
the current commit state when it can preserve useful work; never use reset as a
shortcut.

If the push command times out, disconnects, or has another uncertain outcome, do not
claim that it failed and do not retry. Read the exact destination ref back from the
actual push endpoint first:

- If it equals `result_oid`, report success.
- If it remains `expected_destination_oid`, report that no update was observed and
  ask whether to issue a new, explicitly authorized attempt.
- If it is another OID or cannot be read, report the unknown/conflicting state and
  stop.

## Completion Record

Report the current branch, resolved rebase target and its fixed OID, push remote and
full destination ref, original/expected/final OIDs, validation performed, conflict
decisions if any, and remote read-back result. Clearly distinguish a completed push
from an unverified or unknown outcome.
