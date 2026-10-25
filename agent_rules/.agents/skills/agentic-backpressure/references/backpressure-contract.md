# Active Contract And Identity

Use one `BACKPRESSURE.md` as the manager-owned current summary, not an event log.
Omit unused sections, placeholder rows, empty tables, and duplicated state/evidence.
Never omit a relevant
superseded constraint or unresolved external outcome merely to hit a target.

## Minimal Template

Replace every placeholder with facts; omit inapplicable optional material.
The template below is for correctness work. An observation-only contract needs
only goal/scope/stop, thin recipe, required outcomes with current provenance,
active work/blocker/next action, and applicable unresolved external outcomes.
Use exact CI/PR revision identities rather than inventing local patch gates.

```markdown
# Backpressure Contract

## Run
- ID / request: <ID; new|extend|continue; user source; mode reason>
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
- Route / stop_after: <thin recipe; phase or exact action/snapshot occurrence>
- Required outcomes: <selected requirements; distinguish active from required>
- Active work / next: <child ID and host lifecycle when applicable; next action>
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
- **External observations:** exact CI/check/run/attempt/tested revision or PR
  snapshot/head provenance, current outcomes and gaps; active CI episode's one
  absolute deadline (default one hour). See `routing.md`.
- **Publication:** marked `publication-spec` block listing artifact/check rules,
  requiredness, content/commit identity, and prerequisite action; judgment reviewer
  only when judgment is required. Outside the block record hash and item evidence.
- **Actions:** ordered manifest and current results per `boundary-actions.md`.
  Retain successful parts, unresolved partial/unknown outcomes, and read-back
  references; do not maintain an attempt ledger.
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

Control, source excerpts, superseded context, and action authority are
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
