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
- Required checks, review triggers, profile, budgets, and base are known or
  explicitly unresolved.
- The validation specification and current repository state have stable IDs.
- `stop_after` and action-specific authorization are separate.
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
- Session replacement does not reset cumulative budget.

## Freshness Gate

Before consuming correctness evidence, require:

- The active run and validation specification match.
- The evidence `state_id` matches the current candidate.
- The evidence covers the intended gate and check or review scope.
- The manager can attribute the result to the tool-reported producer and role.

Return `STALE` when correctness-affecting contract fields or candidate `state_id`
differ. Reverify only what the change invalidated. Authorization-only and
publication-only specification changes do not invalidate correctness; recheck
them before the action.

A correctness-affecting decision replacement updates its linked normative
targets and the validation hash. Evidence whose declared decision, plan,
criterion, check, or review coverage intersects that change becomes stale, and
final semantic review always becomes stale. Carry unaffected evidence forward
only with an explicit dependency-based reason. Wording-only source or superseded
history edits outside the validation specification do not affect freshness.

## Plan Gate

When plan review is required, pass when one independent reviewer finds no
blocker and every SHOULD finding has a disposition. Resume once after revision.
After the second blocked review, return `ESCALATE_HUMAN`; do not start work or
replace the reviewer to reset the count.

The manager must write the exact plan under review into the validation
specification and recompute its hash before invoking the reviewer. Bind review
evidence to that hash and keep mutable review status outside the hash. Any plan
revision makes the prior review stale.

The reviewer must also confirm that the plan preserves concise user decision
sources and the Agreed Plan's meaning, respects forbidden scope, ownership, and
public API constraints, and does not reintroduce a superseded decision. Generated
acceptance criteria alone cannot satisfy this gate. An unresolved material
structural axis returns `ESCALATE_HUMAN` with one focused question.

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

## Focused Review Gate

Create this gate only for a triggered risk or repaired blocker. Pass when the
reviewer is independent, the scope is explicitly `risk_delta` or
`blocker_delta`, stable finding IDs have evidence and dispositions, and the
reviewed state remains current. A focused review never substitutes for final
whole-changeset review.

## Final Correctness Gate

Pass when:

- Repository-changing work has stopped and the candidate is frozen.
- All required final mechanical checks pass on the frozen state.
- A fresh independent reviewer approves the whole changeset from base.
- The reviewer covers active decisions and their concise source meaning,
  explicit forbidden and out-of-scope changes, required ownership boundaries,
  required public API shape, and superseded decisions that must not reappear.
- The diff is semantically aligned with user decision sources and the Agreed Plan,
  not only agent-generated acceptance criteria.
- Required risk lenses are covered.
- Every active correctness decision and acceptance criterion has current evidence.
- No correctness-specification or candidate-content change occurred during the
  gate.

Any content change returns correctness to pending. A blocked specialized check
is not a pass.

## Budget Gate

Pass when total child calls and repair rounds remain within the active contract.
Before another repair, require remaining child calls above the final-call floor,
which covers the final verifier, fresh final reviewer, and any required
specialist, publication verifier, or publication judgment reviewer.

Return `ESCALATE_HUMAN` when a limit is reached, another repair would cross the
final-call floor, or the same failure repeats without new evidence.

## Publication Gate

Skip this gate when publication is not in scope. Otherwise pass when required
artifacts and checks are current and the publication manifest matches the frozen
candidate. Correctness may pass while publication readiness is blocked.
Mechanical items require verifier evidence; judgment items require the reviewer
required by the publication specification. Publication evidence must match the
current `publication_spec_hash` and candidate `state_id`.

After commit, preserve content-bound evidence when the committed content equals
the frozen candidate. Reopen final correctness when content differs or required
checks depend on commit identity.

## Action Gate

Before commit, push, or PR work, require:

- The action is not beyond `stop_after`.
- Current authorization matches the exact target and operation mode.
- A PR update lists the exact fields or state transition it may change.
- Correctness and required publication readiness pass.
- The appropriate Git or GitHub workflow owns the action.

Authorization for one action never implies another. Read the authoritative result
back before reporting success.

## History And Handoff Gate

Historical contracts, skips, approvals, and evidence are context only. They do
not satisfy a current gate without current validation and authority.

The final handoff must report active, superseded, and unresolved decision IDs with
concise sources, active validation IDs, stop point, acceptance status, checks,
reviews, blockers, budget usage, publication status, action authorization and
results, residual risk, and one focused human decision when blocked.
