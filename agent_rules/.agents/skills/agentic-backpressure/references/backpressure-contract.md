# BACKPRESSURE.md Contract Template

`BACKPRESSURE.md` contains one active contract and concise current state. Keep
only decision context needed to validate the active run; archive broader history
outside the active file. Do not record secrets; record only their source and
required access.

## Template

```markdown
# Backpressure Contract

## Run

- Run ID: <stable ID>
- Profile: <lite | standard | critical>
- Activated at: <ISO-8601 timestamp>
- Owner: <user or approved authority>

## Decision Sources

| Source ID | Short excerpt or stable reference | Authority | Notes |
|---|---|---|---|
| SRC-1 | <concise user excerpt, message reference, issue, or document anchor> | <user | approved authority> | <why this source matters> |

Keep excerpts short and preserve their original meaning. Do not copy the full
transcript. A wording-only source correction is context; a change in meaning or
authority requires a replacement decision and specification update.

<!-- validation-spec:start -->
## Active Decisions

| Decision ID | Source ID | Normative targets | Supersedes |
|---|---|---|---|
| D-1 | SRC-1 | <GOAL, OOS-1, OWN-1, API-1, P-1, AC-1, check or review ID> | <decision ID | none> |

Only current decisions appear here. Normative wording lives in the linked
contract targets below; do not create a second decision ledger in child output.
The latest explicit user feedback outranks earlier plans, agent-authored
specifications, and reviewer assumptions.

## Repository

- Root: <canonical path>
- Base: <full commit SHA | immutable reference | unresolved>
- Candidate state ID implementation: <shared helper or exact read-only commands>
- Isolated base: <read-only path | immutable snapshot | unresolved>

Exclude `BACKPRESSURE.md` and `.backpressure/**` from state identity. Use the same
state implementation for the complete run.

## Goal

- Objective: <observable result>
- Scope: <files, modules, behavior, or issue links>
- Out of scope:
  - OOS-1: <explicit forbidden change or non-goal>

## Ownership And Public API

- OWN-1: <required ownership boundary | not constrained>
- API-1: <required public API shape | not constrained>

## Agreed Plan

- Source: <source IDs, approved plan reference, or reviewed plan reference>
- P-1: <faithful plan step>
- P-2: <faithful plan step>

Preserve the final agreed plan's terminology, sequence, conditions, boundaries,
ownership, public API shape, and non-goals as faithfully as practical. Normalize
formatting and add stable IDs, but do not broaden, narrow, generalize, or silently
replace its meaning. Omit rejected alternatives, intermediate drafts, and full
transcript history. Put a materially ambiguous axis in Unresolved Decisions
instead of choosing an interpretation. Project an already user-approved plan
without asking workers to approve it again. If the run creates a materially new
plan, record it as unresolved and obtain explicit user agreement before patching.

## Acceptance Criteria

- AC-1: <observable criterion>
- AC-2: <observable criterion>

## Mechanical Checks

| Check ID | Command | Stage | Required | Identity | Side effects |
|---|---|---|---:|---|---|
| targeted-tests | <command or unresolved> | implementation | yes | content | read_only |
| full-tests | <command or unresolved> | final | yes | content | read_only |
| project-check | <command or not required> | <implementation | final | post_commit> | <yes/no> | <content | commit> | <read_only | sandboxed_local> |

Required unresolved checks block the gate that needs them. Source-changing or
external-side-effect commands are work, not mechanical verification.

## Review Requirements

- Plan review: <required | conditional | not required>
- Final whole-changeset review: required
- Simplicity review: <triggered: concrete trigger | not triggered>
- Conditional lenses: <security, type design, performance, integration, none>
- Required specialist: <role | none>

## Specialized Validation

- Browser: <owner | not required | unresolved>
- Benchmark: <owner | not required | unresolved>
- Migration dry-run: <owner | not required | unresolved>
- Runtime integration: <owner | not required | unresolved>

<!-- validation-spec:end -->

## Superseded Decisions

| Decision ID | Historical decision summary | Source ID | Replaced by |
|---|---|---|---|
| <D-old> | <concise former meaning> | <SRC-ID> | <active decision ID> |

These rows are context for detecting accidental reintroduction, not active
requirements. Keep only the concise history needed by the current run.

## Unresolved Decisions

| Decision ID | Focused question | Material effect | Source or status |
|---|---|---|---|
| <UD-1> | <one decision needed> | <diff | ownership | public API | other> | <source ID | awaiting user> |

If plausible interpretations materially change the diff, ownership boundary, or
public API, ask one focused question before contract freeze. Do not begin planning
or implementation while that axis remains unresolved. Use Open Items for missing
commands, environments, or authority that are not decision semantics.

<!-- publication-spec:start -->
## Publication Requirements

- Required: <true | false>
- Judgment review: <required | not required>

| Item | Command or artifact rule | Required | Before action | Identity | Side effects |
|---|---|---:|---|---|---|
| <lockfile, generated artifact, changelog, migration package, check> | <rule or command> | <yes/no> | <action ID> | <content | commit> | <read_only | sandboxed_local> |
<!-- publication-spec:end -->

## Validation Identity

- Validation spec hash: <sha256 of the exact UTF-8 bytes between validation-spec markers after LF line-ending normalization>
- Publication spec hash: <sha256 of the publication-spec block | not required>
- HEAD: <full commit SHA | UNAVAILABLE>
- Current state ID: <opaque digest>

## Run Control

- Stop after: <contract | plan | implementation | correctness | publication | handoff | Boundary Action ID>
- Invocation policy: fresh child for every new action; resume only the exact same
  unfinished action under the skill's recorded continuity exception

| ID | Timing | Required | Owner | Prerequisites | Exact target | Operation | Payload or reference | Authorized | Authorization source |
|---|---|---:|---|---|---|---|---|---:|---|
| PRE-1 | before_work | <yes/no> | <skill, tool, or specialist> | <gate and prior action IDs> | <exact resource> | <exact mutation> | <contract anchor, digest, or fields> | <true/false/unresolved> | <current instruction> |
| POST-1 | after_final | <yes/no> | <Git, GitHub, or other workflow> | <correctness, publication items, prior actions> | <exact resource> | <exact mutation> | <frozen candidate or fields> | <true/false/unresolved> | <current instruction> |

Authorization permits an exact action but does not require it, authorize adjacent
operations, or extend `stop_after`. A phase stop excludes later actions; an
action-ID stop executes through that action and then hands off. Human handoff is
always allowed.

## Budget

| Budget | Value | Used |
|---|---:|---:|
| Child calls | <profile default or override> | 0 |
| Repair rounds per gate | <profile default or override> | <gate -> count> |
| Final-call floor | <profile default or route-adjusted value> | not applicable |
| Boundary Action attempts per action | 2 | <action -> count> |

- Budget override: <none | value, reason, approver>
- Remaining route fits final calls: <true | false>

## Publication Readiness

- Overall status: <not_required | pending | pass | blocked summary>

| Item | Before action | Status | Evidence or blocker |
|---|---|---|---|
| <required item from publication specification> | <action ID> | <pending | pass | blocked | stale> | <reference> |

Gate each action only on items mapped to that action. The overall status is a
handoff summary and does not require future post-commit items to pass before the
commit that makes them evaluable.

## Open Items

- [ ] OI-1: <missing requirement, command, environment, or authority>

## Current State

- Phase: <contract | plan | before_work | implementation | correctness | publication | after_final | handoff>
- Current gate: <gate name>
- Current state ID: <opaque digest>
- Open blocker IDs: <IDs or none>
- Plan review: <not_required | pending | pass | blocked, evidence reference>
- Simplicity review: <not_triggered | pending | approve_delta | send_back | blocked | stale, evidence reference>
- Correctness: <pending | pass | blocked>

| Boundary Action | Status | Bound identity | Attempts | Result and authoritative read-back |
|---|---|---|---:|---|
| <action ID> | <not_attempted | pending | pass | blocked | stale | unknown> | <run, specs, state, all manifest fields, exact authorization> | <count> | <evidence or blocker> |

| Delegated action | Tool-reported child ID | Invocation mode | Resume reason |
|---|---|---|---|
| <gate and requested action> | <child ID> | <fresh | resumed> | <not applicable | concrete exception> |

| Active decision | Status | Current evidence or blocker |
|---|---|---|
| D-1 | <pending/pass/blocked> | <reference> |

| Acceptance criterion | Status | Current evidence or blocker |
|---|---|---|
| AC-1 | <pending/pass/blocked> | <reference> |
| AC-2 | <pending/pass/blocked> | <reference> |
```

## Update Rules

1. Hash each marked specification block as raw text after normalizing line
   endings to LF. Whitespace-only changes may conservatively invalidate evidence;
   do not add a custom semantic canonicalization layer.
2. Changes inside the validation-spec block invalidate dependent correctness
   evidence. Bind evidence to the decision, plan, criterion, check, and review IDs
   it covers. Final semantic review becomes stale after every
   correctness-affecting decision change; unaffected evidence may carry forward
   only with an explicit dependency-based reason.
3. The manager creates, resolves, or replaces a correctness decision atomically:
   add the active decision, move any prior decision to Superseded Decisions,
   update all linked normative targets and affected Agreed Plan steps, and then
   recompute the validation hash. Removing an unresolved row alone cannot unblock
   correctness work. An Active Decisions row that disagrees with its linked
   targets blocks the contract.
4. Before each plan review, write the exact plan under review into Agreed Plan and
   recompute the validation hash. Bind the review to that hash. Store mutable plan
   review status and evidence in Current State, outside the hash. A plan revision
   stales prior plan-review evidence.
5. Wording-only edits to Decision Sources, Superseded Decisions, or unresolved
   context do not invalidate correctness evidence because those sections are
   outside the hash. If source meaning or authority changes, treat it as a new
   decision under rule 3 rather than a context edit.
6. Changes inside the publication-spec block invalidate only
   publication-readiness evidence unless they also change candidate content.
7. Changes only to authorization, counters, findings, Boundary Action manifests,
   or current status do not invalidate correctness evidence. Recheck action policy
   immediately before an action. A changed action field, applicable specification
   hash, `state_id`, or payload makes the prior action result inapplicable.
8. After an external timeout or partial result, read the exact target before any
   retry. Do not repeat successful sub-operations. Retry only a confirmed-
   incomplete idempotent operation with current authorization, prerequisites,
   stop point, and budget, then read back again. An unavailable read-back or
   non-idempotent unknown result remains non-pass. Preserve reported successes as
   tool-reported-only and do not repeat them when authoritative read-back is
   unavailable.
9. Recompute `state_id` after every candidate-content-changing work slice and
   before and after each authoritative check set, review, or Boundary Action that
   could touch repository content.
10. A changed candidate makes previous content-bound evidence stale. Classify each
     changed path: lockfiles, changelogs, and generated release artifacts are
     publication repair; every other path is a work slice. Mixed changes follow
     both routes. Reopen Final Correctness before applying required or optional
     failure behavior. Reassess the simplicity trigger against the new diff.
     Refresh simplicity-review evidence only when the prior state or new state is
     triggered, and refresh affected mechanical evidence for the new `state_id`.
     A `HEAD`-only commit may use the equivalence rule below.
11. Publishing the agreed plan does not promote its external copy to a Decision
    Source. Bind the result to `agreed-plan@<validation_spec_hash>`; a changed
    plan needs a new applicable action result.
12. Keep manager-owned child IDs and invocation mode outside the normative
    contract. Record a concrete reason for every resume. Children do not create
    separate decision, evidence, or invocation ledgers.
13. When history is useful, write one concise
   `.backpressure/runs/<run_id>/run.md` containing the final contract, gate
   decisions, evidence references, action results, and handoff. Historical state
   is never current authority.

## Repository State Requirements

The state record must include:

- Base and current `HEAD`, recorded separately
- Base-to-index changes
- Index-to-worktree changes
- Relevant untracked paths, modes, symlink targets, and content

Derive `state_id` from the base and candidate content, not from current
commit-object identity. The implementation must be read-only and deterministic.
Store detailed components and `HEAD` once in the run record and use the opaque
`state_id` in handoffs and evidence. For non-Git work, use an immutable base
snapshot and a deterministic manifest. If no trustworthy base exists,
whole-changeset correctness is unresolved.

After commit, compare the committed tree or publication manifest with the frozen
candidate. Preserve content-bound evidence when they are identical. Revalidate
when content differs or a check explicitly depends on commit identity.

Commit-dependent check evidence records the exact `HEAD` before and after the
check. A `HEAD`-only change does not invalidate content-bound evidence.

For PR updates, list every authorized mutation. Permission to update one field
does not authorize changing another field, closing, or merging the PR.
