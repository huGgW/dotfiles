# Gate Checklist

Use this checklist to decide whether a run advances. It references the active
contract instead of repeating its budgets, identity algorithm, or prompt schema.

Gate outcomes are `PASS`, `SEND_BACK`, `BLOCKED`, `STALE`, and
`ESCALATE_HUMAN`. Only `PASS` advances successfully.

## Contract Gate

Pass when:

- One manager-owned decision record identifies concise sources, active decision
  bindings, superseded decisions and replacements, and unresolved decisions.
- Goal, scope, out-of-scope boundary, and acceptance criteria are actionable.
- Required ownership boundaries and public API shape are explicit or marked not
  constrained.
- The Agreed Plan preserves accepted terminology, sequence, conditions,
  boundaries, ownership, public API shape, and non-goals without copying the full
  transcript.
- An already user-approved plan is projected without duplicate approval, and any
  materially new plan remains unresolved until the user explicitly agrees.
- Required checks, review triggers, profile, budgets, and base are known or
  explicitly unresolved.
- The validation specification and current repository state have stable IDs.
- `stop_after` and action-specific authorization are separate.
- Every Boundary Action declares a unique ID, timing, requiredness, owner,
  prerequisites, exact target and operation, payload reference, explicit
  authorization state, and authorization source.
- An action-ID `stop_after` names exactly one reachable manifest entry.
- Required values for the next phase are resolved.

For structural requests such as split, move, extract, merge, unify, or separate,
ask one focused question before contract freeze only when plausible
interpretations materially change the diff, ownership boundary, or public API.
Do not pass while that material axis is unresolved, and do not force a question
when the outcomes are materially equivalent. Return `ESCALATE_HUMAN` with that
single focused question; do not use `BLOCKED` for a resolvable structural choice.

Return `BLOCKED` or `ESCALATE_HUMAN` rather than guessing a requirement, command,
base, credential source, or authority. The structural decision rule above fixes
its own outcome.

## Role Gate

Pass when:

- Workers produce plans or patches but do not approve them.
- Verifiers run authoritative checks without editing the candidate.
- Reviewers are independent and do not edit the candidate.
- Worker-run commands remain diagnostic.
- A child never changes between worker, verifier, reviewer, or specialist roles.
- Fresh launch or exceptional resume does not reset cumulative budget.

## Invocation Freshness Gate

Pass when every new action uses a fresh child with no inherited child transcript.
The action identity consists of the run, role, gate, requested action, applicable
specification hashes, current state, and declared check or review scope. Boundary
Action identity also includes every manifest field, including exact authorization
and payload.

Resume only when the original action is unfinished, every identity field is
unchanged, and transport or protocol interruption, required child-local runtime
state, or an explicit user continuity requirement makes it necessary. Record the
reason and consume another child call. Partial evidence from the same unfinished
action may remain valid when it still matches the current state.

Return `BLOCKED` or `ESCALATE_HUMAN` instead of weakening freshness when budget or
tool availability cannot support the required child. Familiarity, useful context,
token savings, ownership of a patch or finding, or membership in the same gate do
not justify resume.

Do not resume after a terminal result, action-identity change, decision or plan
change, candidate mutation, new work slice, role or gate change, repair,
changed-state recheck, or when independent or final judgment is required. A fork
that inherits an earlier child transcript is not fresh.

## Evidence Freshness Gate

Before consuming correctness evidence, require:

- The active run and validation specification match.
- The evidence `state_id` matches the current candidate.
- The evidence covers the intended gate and check or review scope.
- The manager can attribute the result to the tool-reported producer and role.

Return `STALE` when correctness-affecting contract fields or candidate `state_id`
differ. Reverify only what the change invalidated. Authorization-only and
publication-only specification changes do not invalidate correctness; recheck
them before the action.

A simplicity repair changes `state_id`, making its prior review and affected
mechanical evidence stale. Freshness requires a fresh verifier and fresh
simplicity reviewer for the changed state.

A correctness-affecting decision replacement updates its linked normative
targets and the validation hash. Evidence whose declared decision, plan,
criterion, check, or review coverage intersects that change becomes stale, and
final semantic review always becomes stale. Carry unaffected evidence forward
only with an explicit dependency-based reason. Wording-only source or superseded
history edits outside the validation specification do not affect freshness.

## Capability Review Mapping

`plan-reviewer` and `code-reviewer` return bounded capability reports, not gate
outcomes. Before mapping a report, require its `subject_identity`,
`reviewed_scope`, coverage, findings, unverified areas, and residual risks to
match the manager-constructed request and current evidence binding.

Map the report as follows:

| Capability report | Core outcome |
|---|---|
| `SUBJECT_MISMATCH` | `STALE` |
| `INCOMPLETE` because required repository or runtime evidence is unavailable | `BLOCKED` |
| `INCOMPLETE` because a requirement, authority, ownership, scope, or risk decision is unresolved | `ESCALATE_HUMAN` |
| `COMPLETE` with an unresolved in-scope `BLOCKER` or `SHOULD` that can be repaired within the agreed plan | `SEND_BACK` |
| `COMPLETE` with an unresolved finding that requires a plan, authority, ownership, public API, scope, or risk decision | `ESCALATE_HUMAN` |
| `COMPLETE` with no unresolved `BLOCKER` or `SHOULD` and complete required coverage | Review condition satisfied; the enclosing gate may pass only if its other conditions pass |

An invalid or materially incomplete report is unavailable evidence and remains
`BLOCKED`; do not infer approval from omitted fields. A `NIT` is non-blocking
unless the active contract explicitly requires its disposition. The manager, not
the reviewer skill, decides finding disposition, repair ownership, retry budget,
and the enclosing gate. Reviewer `COMPLETE` never authorizes implementation,
publication, or a whole-run approval.

## Plan Gate

When plan review is required, the fresh independent child loads `plan-reviewer`
with the exact manager-constructed subject, scope, authoritative context, lenses,
prior findings, and expected identity. Pass only when the mapped review condition
is satisfied and every SHOULD finding has a disposition. Use a fresh reviewer
after a revision. After the second review still has an unresolved `BLOCKER` or
`SHOULD`, return `ESCALATE_HUMAN`; do not start work or replace the reviewer to
reset the count.

The manager must write the exact plan under review into the validation
specification and recompute its hash before invoking the reviewer. Bind review
evidence to that hash and keep mutable review status outside the hash. Any plan
revision makes the prior review stale.

Required capability coverage includes concise user decision sources and the
Agreed Plan's meaning, forbidden scope, ownership, public API constraints,
repository fit, unresolved load-bearing decisions, and superseded decisions that
must not reappear. Generated acceptance criteria alone cannot satisfy this gate.
An unresolved material structural axis maps to `ESCALATE_HUMAN` with one focused
question.

Reviewer findings do not authorize broader scope. If a finding materially changes
the approved plan, stop before patching for renewed user agreement. Report
unrelated findings without fixing them.

## Mechanical Gate

Pass when:

- Every required check for the stage ran once on the current state and passed.
- Commands were read-only or limited to declared sandboxed-local paths.
- Actual command, cwd, exit status, and relevant output are recorded.
- Before and after state IDs match.
- Commit-dependent check evidence names the exact matching `HEAD`.

Mechanical `PASS` establishes only that declared commands passed on the current
state. It does not establish semantic correctness or authorize a production
scope, transaction, locking, or concurrency change.

Before routing a production patch or scope expansion, require conditional
root-cause evidence only when:

- One failing test is being used to justify wider production scope.
- A transaction boundary would change.
- Locking or concurrency behavior would change.
- Fixture-versus-production attribution remains unresolved.

For the applicable trigger, require where feasible an authoritative precondition,
a clean fixture reproduction, and a control case. Also require transaction
ownership and exception propagation for transaction changes, and the concrete
lock target and acquisition order for locking or concurrency changes. An
unverified cause remains a hypothesis.

Return:

| Condition | Outcome |
|---|---|
| Evidence supports a worker-, fixture-, or tooling-owned repair | `SEND_BACK` |
| Triggered root-cause evidence is incomplete, but an owner and investigable question exist | `SEND_BACK` for focused investigation |
| Baseline, environment, or unavailable evidence prevents progress | `BLOCKED` |
| Applicable specification hash or candidate state differs | `STALE` |
| A requirement, authority, or route is unresolved | `ESCALATE_HUMAN` |

Missing triggered evidence cannot result in `PASS` or a speculative production
repair. Use `SEND_BACK` for focused investigation when an owner exists, `BLOCKED`
when evidence is unavailable, and `ESCALATE_HUMAN` when intended behavior or
authority requires a user decision. Do not repeat an unchanged command without
new evidence.

A required failure that reproduces unchanged on an isolated base remains
`BLOCKED`. If it prevents an acceptance criterion and no authorized repair or
waiver route can establish the criterion, escalate the handoff for one focused
human decision while preserving the failed check as non-pass.

## Simplicity Review Gate

Create this gate only after targeted mechanical `PASS` when the candidate adds a
dependency, abstraction, wrapper, configuration option, unnecessary cross-layer
expansion, duplicated platform functionality, or the user explicitly requests
simplification. A trivial direct patch with none of these triggers does not
consume a simplicity-review call.

The fresh independent child loads `code-reviewer` and its simplicity lens. Map its
capability report to gate `PASS` only when it binds to the current validation
specification and `state_id`, covers the base-to-candidate diff plus relevant
symbols and callers, and has no unresolved `BLOCKER` or `SHOULD`. The
`code-reviewer` simplicity lens owns the finding method and preservation analysis;
the manager owns the trigger, subject, scope, evidence binding, and gate mapping.

Do not delete complexity required for safety, correctness, compatibility,
accessibility, migration, operational needs, ownership, or approved architecture. The
reviewer does not edit source. A mapped `SEND_BACK` routes an in-scope repair to a
fresh worker; candidate mutation requires a fresh trigger assessment, fresh
affected mechanical evidence, and fresh simplicity evidence when the prior or new
state is triggered. Map `INCOMPLETE` and `SUBJECT_MISMATCH` through the shared
table above. This focused gate never replaces Final Correctness.

## Focused Review Gate

Create this gate only for a triggered risk or repaired blocker. Pass when the
fresh independent child loads `code-reviewer`, the manager-supplied scope is
explicitly `risk_delta` or `blocker_delta`, stable finding IDs have evidence and
dispositions, the capability report has complete required coverage, and the
reviewed state remains current. Map the report through the shared table. A focused
review never substitutes for final whole-changeset review.

## Final Correctness Gate

Pass when:

- Repository-changing work has stopped and the candidate is frozen.
- All required final mechanical checks pass on the frozen state through a fresh
  verifier.
- A fresh independent child loads `code-reviewer` and returns a `COMPLETE`
  capability report for the whole changeset from base with no unresolved
  `BLOCKER` or `SHOULD`.
- The report covers active decisions and their concise source meaning,
  explicit forbidden and out-of-scope changes, required ownership boundaries,
  required public API shape, and superseded decisions that must not reappear.
- The diff is semantically aligned with user decision sources and the Agreed Plan,
  not only agent-generated acceptance criteria.
- Required risk lenses are covered.
- Any triggered simplicity review has a current-state capability report that the
  manager mapped to `PASS`.
- Every active correctness decision and acceptance criterion has current evidence.
- No correctness-specification or candidate-content change occurred during the
  gate.

Any content change returns correctness to pending. A blocked specialized check
is not a pass.

## Budget Gate

Pass when total child calls and repair rounds remain within the active contract.
Before another repair, require remaining child calls above the final-call floor,
which covers the fresh final verifier, fresh final reviewer, and any required
specialist, publication verifier, publication judgment reviewer, Boundary Action
specialist, and authoritative read-back.

Return `ESCALATE_HUMAN` when a limit is reached, another repair would cross the
final-call floor, or the same failure repeats without new evidence.

## Publication Gate

Skip this gate when publication is not in scope. Otherwise pass when required
artifacts and checks are current and the publication manifest matches the frozen
candidate. Correctness may pass while publication readiness is blocked.
Mechanical items require verifier evidence; judgment items require the reviewer
required by the publication specification. Publication evidence must match the
current `publication_spec_hash` and candidate `state_id`. Apply each item before
the Boundary Action named in its prerequisite column; do not require a post-commit
item before the commit that makes it evaluable. Gate an action only on items mapped
to that action; overall readiness is a handoff summary.

After commit, preserve content-bound evidence when the committed content equals
the frozen candidate. Reopen final correctness when content differs or required
checks depend on commit identity.

## Boundary Action Gate

Before any `before_work` or `after_final` action, require:

- The action is not beyond `stop_after`.
- Current authorization matches the exact target and operation mode.
- The payload reference, prerequisites, and prior required actions are current.
- A `before_work` action follows Contract and any required Plan Gate.
- An `after_final` action follows Final Correctness `PASS` and applicable
  publication readiness.
- The declared specialized workflow owns one action; a verifier or reviewer does
  not perform the mutation.
- A PR update lists the exact fields or state transition it may change.

Authorization for one action never implies another. Execute in manifest order and
read the authoritative result back before reporting success. A required
`before_work` non-pass blocks implementation. A required `after_final` non-pass
keeps correctness `PASS` only when candidate content is unchanged and blocks later
actions. An optional failure may continue only to independent actions and must
remain visible in the handoff. Discard stale prior-identity results before
evaluating the current action.

After timeout or partial success, read back before retrying and do not repeat a
successful or non-idempotent operation. Retry only a confirmed-incomplete,
idempotent operation after rechecking current prerequisites, stop point, budget,
and authorization, then read back again. When authoritative state is unavailable,
keep the result non-pass, preserve reported successes as tool-reported-only, and
do not repeat them.

Recompute repository state after an action that could touch the candidate. If
content changed, classify every changed path: lockfiles, changelogs, and generated
release artifacts are publication repair; every other path is a work slice. Mixed
changes follow both routes. Reopen Final Correctness before required or optional
failure routing. Preserve content-bound evidence after commit only when the
committed tree equals the frozen candidate.

## History And Handoff Gate

Historical contracts, skips, approvals, and evidence are context only. They do
not satisfy a current gate without current validation and authority.

The final handoff must report active, superseded, and unresolved decision IDs with
concise sources, active validation IDs, stop point, acceptance status, checks,
reviews, blockers, budget usage, publication status, action authorization and
results including partial state and read-back evidence, residual risk, and one
focused human decision when blocked.
