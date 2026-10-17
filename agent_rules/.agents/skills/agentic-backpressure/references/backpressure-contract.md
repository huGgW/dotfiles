# Active Contract And Identity

Use one `BACKPRESSURE.md` as the manager-owned current summary. A Lite rendered
contract normally needs 40–60 lines; Standard 60–100. These are editing targets,
not limits on meaningful safety context. Omit unused sections, placeholder rows,
empty tables, and duplicated state/evidence/counters. Never omit a relevant
superseded constraint or unresolved external outcome merely to hit a target.

## Minimal Template

Replace every placeholder with facts; omit inapplicable optional material.

```markdown
# Backpressure Contract

## Run
- ID / request: <ID; new|extend|continue; user source; mode reason>
- Profile: <Lite|Standard|Critical>
- Root: <repository path>
- Protected work: <existing staged/unstaged/untracked paths and boundaries>

<!-- validation-spec:start -->
## Goal And Scope
- Goal: <observable result>
- Scope / forbidden changes: <exact boundaries>
- Base: <immutable ref or snapshot; rationale exposing all in-scope changes>

## Accepted Plan And Constraints
- Authority: <user source or accepted artifact reference>
- P-1: <faithful step with accepted sequence and conditions>
- Constraints: <ownership, public API, non-goals, safeguards when applicable>

## Criteria And Checks
- AC-1: <observable criterion>
- CK-1: <command; cwd; targeted/final stage; required; content/commit identity;
  read_only or declared sandboxed_local side effects>
- Reviews: final whole-changeset required; <conditional plan/early gate reason>
- Lenses: correctness/tests; <applicable simplicity/risk lenses and triggers>
<!-- validation-spec:end -->

## Identity
- Validation hash: <raw LF-normalized block SHA-256>
- State: <opaque state_id; shared implementation and untracked scope>
- HEAD: <commit SHA recorded separately>

## Control
- Phase / stop_after: <current phase; contract|plan|implementation|correctness|
  publication|handoff|exact action ID>
- Calls: <used/limit; initial allowance plus unique grants>
- Repairs: <gate: used/limit>
- Final reserve: <actual remaining required calls and route>
- Blockers: <current IDs, missing evidence/decision and owner, or none>

## Latest Evidence And Coverage
- <evidence ID: child ID/role, fresh|resumed and reason, hash/state, result, reference>
- AC-1 / <applicable decision IDs>: <current evidence IDs or explicit blocker>
```

Check stage overlap may map one actual command to multiple check IDs. Required
unknown checks block the applicable phase. Source-changing or external-write
commands are work/actions, not verifier checks. Record commit-dependent checks
explicitly; a HEAD-only change cannot stand in for checking candidate equivalence.

## Conditional Sections

Add these only when applicable, without creating parallel ledgers:

- **Decisions:** source -> active decision -> normative target IDs. Keep normative
  wording at its target, not repeated in a second table. Add concise superseded
  meaning/source/replacement when needed to prevent reintroduction. Put unresolved
  semantics and focused questions with current blockers.
- **Grants:** extension ID/request/delta, added calls/repairs, plan allowance,
  reconciliation status. Lifecycle owns deduplication/accounting.
- **Plan review usage:** allowance ID and used/4, when plan review is required.
- **Publication:** marked `publication-spec` block listing artifact/check rules,
  requiredness, content/commit identity, and prerequisite action; judgment reviewer
  only when judgment is required. Outside the block record hash and item evidence.
- **Actions:** ordered manifest and current results per `boundary-actions.md`.
  Keep attempt count with action evidence once, not in several tables.
- **Specialized validation:** browser, benchmark, migration, runtime owner and
  required evidence when applicable. Unavailable required validation is a blocker.

## Specification Hashes

Hash exact bytes **between** unique `<!-- validation-spec:start -->` and
`<!-- validation-spec:end -->` markers, excluding marker bytes, after converting
CRLF and CR to LF. Hash the publication block the same way when present.
Use SHA-256; no semantic canonicalization. Whitespace edits conservatively stale
evidence. Correctness-affecting goal/scope/base/plan/constraints/criteria/checks/
reviews/active decision bindings belong inside validation markers.
Avoid cosmetic edits to a frozen validation block: raw-byte hashing invalidates
evidence even when meaning is unchanged. Put result/delta updates outside it.

Control, counters, source excerpts, superseded context, and action authority are
outside. Editing source meaning/authority is a new decision, not wording cleanup.
Update active decision, superseded meaning, linked normative targets, plan, and
hash together before work. Conflicting linked fields or an unresolved material
structural axis block work; removing a blocker row alone does not resolve it.

Changed validation coverage stales affected evidence; final semantic review always
stales after correctness changes. Carry an unaffected check forward only with an
explicit dependency-based reason. Publication-only changes stale publication
evidence, not unaffected correctness. Authorization-only changes require immediate
action-policy recheck, not repeated correctness checks.

## Candidate State

Use `scripts/state_identity.py` for Git runs, or a declared deterministic read-only
manifest of an immutable base snapshot for non-Git work. No trustworthy base means
whole-changeset correctness is unresolved. Use one implementation throughout.

The Git helper hashes base tree entries and two candidate layers: index and
effective worktree (tracked union of base/index/HEAD plus relevant untracked).
Each layer includes path, Git mode, and content digest or symlink target digest.
Deleted paths are absent from that layer. Thus staged content differing from
worktree is detected, as are mode changes and dangling symlinks. Gitlinks are
rejected: require a declared submodule-aware identity implementation instead of
pretending dirty nested state is covered. Files that change during collection
require recollection after quiescence; this is not an atomic filesystem snapshot.

Exclude root `BACKPRESSURE.md` and root `.backpressure/**` in every layer.
Default untracked scope is all Git-visible, nonignored untracked paths; repeat
`--untracked PATH` to choose exact relevant paths, including ignored files.
Record that scope once and keep it stable. Explicit paths must be repository-
relative files/symlinks, never directories or traversal. Ignored outputs are not
included unless explicitly selected. Protected tracked work participates in
identity without becoming authorized editing scope.

Record HEAD separately. Hash base **content**, not base/HEAD commit object IDs:
equivalent base trees and candidate layers retain identity across commits. A
commit retains content evidence only when its tree equals the frozen candidate;
index-only/worktree-only differences cannot be silently discarded by committing.
Commit-dependent checks must name exact before/after HEAD and rerun when it changes.

```sh
python3 <skill>/scripts/state_identity.py state --root <repo> --base <immutable-ref>
python3 <skill>/scripts/state_identity.py blocks <repo>/BACKPRESSURE.md
```

The helper only reports hashes, HEAD, and untracked scope as JSON. It does not
write contracts, cache evidence, store a database, or decide gates.

Recompute state after each patch and before/after each authoritative check set,
review, or action that could touch content, not around every check command.
Confirm fresh state at invocation and gate synthesis; investigate detected drift,
never reuse a remembered identity in place of read-back. A candidate change stales
content evidence and reopens final correctness. History is context only; archive one compact final
summary on replacement with relevant evidence references, never copied logs.
