---
name: agentic-backpressure
description: >
  Use when the user explicitly asks for backpressure, backpressured development,
  agentic feedback loops, subagent review loops, quality-gated development, or a
  BACKPRESSURE.md-driven workflow. Runs a bounded worker, verifier, and reviewer
  flow with current-state evidence and explicit human escalation. Do not use for
  ordinary coding tasks unless the user asks for this style of execution.
---

# Agentic Backpressure

## Purpose

Backpressure lets downstream checks reject incomplete work before a human has to
catch it. The manager coordinates the run, workers produce plans and patches,
verifiers run mechanical checks, and independent reviewers assess correctness
and risk.

The protocol should be no more complicated than the guarantees it protects.
Session continuity is useful operational context, but truth comes from the active
contract, current repository state, and attributable evidence.

## Core Invariants

Apply these rules to every run:

1. The manager owns one authoritative decision record. The latest explicit user
   feedback overrides earlier plans, agent-authored specifications, and reviewer
   assumptions. A superseded decision is never an active requirement.
2. Define the goal, scope, acceptance criteria, required checks, and stop point
   before depending on them. Do not guess unresolved requirements or authority.
3. Preserve the final agreed plan's terminology, sequence, boundaries,
   ownership, public API shape, conditions, and non-goals. Normalize structure,
   not meaning, and do not copy the full discussion transcript.
4. Keep producer, verifier, and reviewer responsibilities separate. A worker
   cannot approve its own patch, and worker-run commands are diagnostic only.
5. Verifiers and reviewers do not edit the validation subject.
6. Bind every gate decision to the active validation specification and current
   repository state. Evidence for another state is `STALE`, not `PASS`.
7. Bound total child calls and repair rounds across session replacement.
8. Do not repeat an unchanged failure without new evidence.
9. Run final required mechanical checks and an independent whole-changeset review
   against one frozen candidate. Mechanical success does not establish semantic
   correctness.
10. Link every active correctness decision and acceptance criterion to current
    evidence or an explicit blocker.
11. Stop for unresolved requirements, exhausted budget, repeated failures, or
   unavailable required evidence instead of weakening a gate.
12. Treat `stop_after` and authorization for commit, push, and PR as separate
    decisions. Authorization permits an action; it does not require one.

Gate outcomes are `PASS`, `SEND_BACK`, `BLOCKED`, `STALE`, and
`ESCALATE_HUMAN`. Only `PASS` advances successfully.

## Roles

### Manager

The main agent owns the decision record, faithful projection of the agreed plan,
contract activation, routing, budget accounting, gate decisions, evidence
synthesis, and human handoff. It records child IDs returned by the orchestration
tool and resumes them when useful. Child IDs are operational state, not fields a
child must discover or report about itself.

When explicit user feedback creates, resolves, or changes a correctness decision,
the manager records the active decision, marks any prior decision superseded,
updates every linked normative contract field and affected plan step, and
recomputes the validation specification hash before work continues. Children
report conflicts; they do not maintain or rewrite the decision record.

The manager must not:

- Write implementation patches.
- Run authoritative mechanical checks.
- Perform the only correctness review.
- Reset budgets by creating a new session or renaming a gate.
- Infer permission for an external action.

### Worker

A worker creates a plan or the next coherent patch. It preserves unrelated
worktree changes and does not approve its own output. Resume a worker for a
focused repair when its context remains useful; use a fresh worker for a distinct
work slice when that reduces anchoring or contamination.

### Verifier

A verifier runs the contract's mechanical checks without editing source files.
Prefer resuming the same verifier for retries in one gate, but do not equate
session survival with evidence validity. If replacement is necessary, retain
cumulative budgets and completed evidence that still matches the current state.

### Reviewer

A reviewer is independent of the worker and does not edit files. Use a focused
review only when a risk trigger or blocker repair requires it. Use a fresh final
reviewer for the whole changeset. Add a specialist only when the contract's risk
requires one.

## Active Contract And State

Create or update `BACKPRESSURE.md` before launching work. Keep it limited to one
active run. Use the template in `references/backpressure-contract.md`.

The active run records:

- `run_id` and profile
- Concise decision sources, normative active decision bindings, superseded
  decisions, and unresolved decisions
- Goal, scope, out-of-scope boundary, and acceptance criteria
- Required ownership boundaries, public API shape, and a semantically faithful
  agreed plan
- Required correctness checks and review triggers
- `validation_spec_hash`
- `publication_spec_hash` when publication is required
- Repository base, `HEAD`, and current `state_id`
- `stop_after` and separate action authorization
- Three budget values: total child calls, repair rounds per gate, and the
  final-call floor
- Current blockers, gate results, and acceptance status

`validation_spec_hash` covers correctness-affecting contract fields, including
active decision bindings, the agreed plan, ownership and public API constraints,
goal, scope, acceptance criteria, base, required correctness checks, and review
requirements. Action authorization and mutable control state are outside that
hash.

Changing a correctness-affecting decision requires an atomic decision-record and
specification update. Evidence whose declared decision, criterion, check, or
review coverage changed becomes stale; final semantic review always becomes
stale. The manager may carry unaffected evidence forward only with an explicit
dependency-based reason. Concise source excerpts, superseded history, and
unresolved-decision context remain outside the hash so wording-only history edits
do not invalidate evidence. A source edit that changes meaning or authority is a
new decision, not metadata cleanup. Changing only authorization or `stop_after`
does not invalidate correctness evidence; verify those values again immediately
before an action.

`publication_spec_hash` separately covers required publication artifacts,
checks, and judgment review. Changing it makes publication-readiness evidence
stale without invalidating unaffected correctness evidence.

`state_id` identifies the validation base plus candidate content, including all
relevant staged, unstaged, and untracked content while excluding
`BACKPRESSURE.md` and `.backpressure/**`. Record `HEAD` separately; commit-object
identity is not part of this content identity. Use one deterministic
implementation for the run. Evidence records the opaque `state_id`; detailed
identity components are recorded once in the active run.

Keep one concise historical record at `.backpressure/runs/<run_id>/run.md` when
history is needed. Historical approvals, skips, and evidence are context only and
do not govern a new run. Never record secret values.

## Profiles And Budgets

Choose the lowest profile that covers known risk. Use Standard when uncertain.

| Profile | Use when | Max child calls | Repair rounds per gate | Final-call floor |
|---|---|---:|---:|---:|
| Lite | Localized, low-risk work | 10 | 2 | 3 |
| Standard | Ordinary multi-file or behavioral work | 20 | 3 | 4 |
| Critical | Auth, security, migration, data loss, concurrency, production, or release risk | 32 | 4 | 6 |

These are ceilings, not targets. Every child launch or resume consumes one child
call. A completed non-pass gate evaluation consumes one repair round. Protocol or
transport failure consumes a child call but not a repair round.

The final-call floor is reserved inside the child-call ceiling, not consumed as a
separate budget. Before another repair, confirm that remaining child calls exceed
the floor needed for final verification and review. Otherwise escalate. Plan
review, when used, has at most two invocations across replacements. Token and
unique-session counts may be recorded as telemetry, but they are not separate
pass conditions.

The user may override a budget explicitly. Record the value and reason without
weakening state freshness, role separation, or stop conditions.

## Handoffs

Do not copy the full contract or run history into child prompts. Send:

```text
Run ID: <run_id>
Role: <role>
Contract reference: BACKPRESSURE.md#validation-spec:<hash>
Decision source reference: BACKPRESSURE.md#decision-sources
Publication reference: BACKPRESSURE.md#publication-spec:<hash> | not applicable
Repository root: <path>
Base: <sha | immutable reference>
Current state ID: <state_id>
Decision IDs: <relevant active and superseded IDs | none>
Gate: <gate>
Requested action: <one action>
Delta: <changed files, findings, or contract fields | none>
```

The child reads the referenced sections and performs the requested action in the
same invocation. It does not perform a separate acknowledgement handshake or
self-report its session ID. If it cannot establish the referenced state, it
returns `STALE` or `BLOCKED` with the mismatch and does not rely on prior evidence.

See `references/subagent-prompts.md` for role-specific prompts.

## Default Flow

### 1. Contract

1. Discover the goal, decision sources, active and superseded decisions, scope,
   checks, risk, repository state, stop point, and authorization without guessing.
2. Project the final agreed plan into the contract as faithfully as practical.
   Preserve accepted terminology, ordering, constraints, ownership, public API
   shape, and non-goals; omit rejected alternatives and transcript history.
3. When a structural request such as split, move, extract, merge, unify, or
   separate has plausible interpretations that materially change the diff,
   ownership boundary, or public API, ask one focused axis question before
   freezing the contract. Do not force clarification when those outcomes are
   materially the same.
4. Select the profile and budgets.
5. Activate `BACKPRESSURE.md` and compute the applicable specification hashes and
   state ID.
6. Stop before planning or implementation when a required decision or material
   structural axis remains unresolved.

### 2. Plan When Needed

Use a planning worker and one independent plan reviewer for Standard and Critical
work, or when architecture, migration, rollback, or scope is uncertain. Lite may
proceed without a separate plan review unless the user requested a plan stop or
the task has a load-bearing decision.

The plan must preserve active decision sources and the agreed plan's meaning. The
reviewer checks for semantic drift, forbidden scope, ownership or public API
changes, and reintroduced superseded decisions instead of treating generated
acceptance criteria as sole authority. Before each review, the manager writes the
current plan into the validation specification without broadening or compressing
away accepted constraints and recomputes its hash. The reviewer evaluates that
exact hash. Record review status and evidence outside the hashed specification;
do not edit the approved plan afterward without invalidating dependent evidence.

Resume the reviewer once after a plan revision. If the second review still has a
blocker, escalate. Do not create another reviewer to reset the limit.

### 3. Work And Verify

For each coherent patch:

1. Let the worker implement only the requested slice.
2. Record the new `state_id`.
3. Ask a verifier to run applicable targeted checks once for that state.
4. Reject evidence whose state differs or whose check changed the candidate.
5. Before a production repair or scope expansion, apply the conditional
   root-cause evidence rule below when triggered.
6. Route a repair only when failure evidence identifies a repairable owner.
7. Run a focused risk or blocker review only when required.
8. Stop when the gate passes, blocks, or reaches budget.

Mechanical failure normally prevents review for that attempt. Use review for
diagnosis only when mechanical evidence cannot identify a route.

Require stronger root-cause evidence only when a proposed next step would widen
production scope based on one failing test, change a transaction boundary, change
locking or concurrency behavior, or act before fixture-versus-production
attribution is resolved. Before that production change, establish where
applicable and feasible:

1. The authoritative precondition.
2. A clean fixture reproduction.
3. A control case that isolates the suspected path.
4. Transaction ownership and exception propagation when transaction behavior is
   implicated.
5. The concrete lock target and acquisition order when locking or concurrency is
   implicated.

Record an unverified cause as a hypothesis, not a conclusion. Missing evidence
cannot produce `PASS` or an immediate production repair. Route a focused
investigation to an available worker, verifier, reviewer, or specialist owner;
use `BLOCKED` when evidence is unavailable and `ESCALATE_HUMAN` when a requirement
or authority decision is needed.

### 4. Final Correctness

Stop repository-changing work and freeze the active decisions, agreed plan,
current `validation_spec_hash`, base, and `state_id`.

1. A verifier runs all required final mechanical checks.
2. A fresh independent reviewer examines the whole changeset from base to the
   frozen candidate against active decision sources, forbidden and out-of-scope
   changes, required ownership boundaries, required public API shape, acceptance
   criteria, and superseded decisions that must not reappear.
3. The manager confirms every active correctness decision and acceptance
   criterion has current evidence.
4. Mechanical `PASS` proves only that declared commands passed on the referenced
   state; it cannot substitute for semantic review.
5. Any candidate-content or correctness-specification change returns the gate to
   pending.

Targeted checks and focused reviews do not replace this final gate.

### 5. Publication Readiness When Needed

Create a publication-readiness checklist only when commit, push, PR, or a release
artifact is in scope. Include required lockfiles, generated artifacts, changelog,
version metadata, migration packaging, and project-specific publication checks.
A verifier owns mechanical publication checks. Use an independent reviewer only
when the publication specification requires judgment review.

Correctness may pass while publication readiness is blocked. A repair that
changes the candidate reopens final correctness.

After commit, compare the committed tree or publication manifest with the frozen
candidate. Carry content-bound evidence forward when they are identical. Reopen
final correctness only when content differs or a required check depends on the
commit object or post-commit environment.

A `HEAD`-only change does not stale content-bound evidence. Commit-dependent
checks rerun against the exact committed `HEAD` and record that identity.

### 6. Authorized Actions And Handoff

Before commit, push, or PR work:

1. Confirm the action is not beyond `stop_after`.
2. Confirm current target-specific authorization and operation mode.
3. Confirm correctness and any required publication readiness pass.
4. Delegate to the appropriate Git or GitHub skill.
5. Read the resulting state back from the authoritative source.

Commit permission does not imply push or PR permission. Push permission does not
permit force-push or creating a commit. PR permission does not permit commit or
push. PR update authorization must list the exact mutation; updating a body does
not authorize changing the base, labels, state, or merge status. Deployment,
release, production mutation, and notifications require a separate explicitly
authorized workflow.

## Failure Routing

Choose a route first, then record the responsible owner and optional detail tags.

| Outcome | Use when | Default route |
|---|---|---|
| `SEND_BACK` | Worker-, fixture-, or tooling-owned repair is supported by evidence | Return a focused delta to the owner |
| `BLOCKED` | Baseline, environment, or unavailable-evidence condition prevents progress | Wait, isolate once, or hand off |
| `STALE` | An applicable specification hash or candidate state differs | Discard affected evidence and reverify current state |
| `ESCALATE_HUMAN` | A requirement, authority, risk decision, or budget is unresolved | Ask for one focused decision |

Useful owner values are `worker`, `environment`, `tooling`, and `human`. Optional
tags such as `fixture`, `baseline`, `session_lost`, or `authorization` preserve
diagnostic detail without expanding the routing state machine.

To diagnose a baseline failure, use an isolated read-only base workspace or
immutable snapshot. Never reset, checkout over, or overwrite the active worktree.
Keep a required baseline failure `BLOCKED`; do not waive it. When it prevents an
acceptance criterion and no authorized repair or waiver route can establish that
criterion, escalate the handoff for one focused human decision without
reclassifying the failed check as `PASS`.

When the conditional root-cause rule applies, `SEND_BACK` routes a focused
investigation only when an owner and investigable question exist. Do not route a
speculative production repair. Use `ESCALATE_HUMAN` for unresolved intended
behavior, ownership, or authority, and preserve environment or unavailable
evidence as `BLOCKED`.

## Evidence Standard

Mechanical evidence needs:

- Gate and current `state_id`
- Actual command and cwd
- Exit status and result
- Relevant output excerpt or reference
- Failure owner and route when non-pass
- Exact before and after `HEAD` for a commit-dependent check

Review evidence needs:

- Gate, review scope, and current `state_id`
- Findings with stable IDs, severity, and file, line, or symbol evidence
- Active decision IDs and concise source references covered
- Forbidden and out-of-scope changes, ownership boundaries, public API shape,
  and superseded-decision reintroduction checks
- Acceptance-criterion coverage
- Decision and residual risk

Conditional root-cause evidence also records the trigger, the claimed cause as a
verified conclusion or hypothesis, and available precondition, reproduction,
control, transaction, exception-propagation, lock-target, and acquisition-order
evidence. Record only applicable items and do not invent evidence for unavailable
checks.

Publication evidence also records the current `publication_spec_hash`.

The manager attaches tool-reported producer identity and updates budgets. Child
responses do not maintain duplicate evidence, invocation, or decision ledgers.
Add timestamps or environment details only when they matter to a flaky,
time-sensitive, or environment-sensitive result.

## Stop Conditions

Stop and hand off when:

- A required contract value or authorization is unresolved.
- A structural axis that materially changes the diff, ownership, or public API is
  unresolved.
- The plan still has a blocker after its second review.
- A hard budget is reached or another repair would cross the final-call floor.
- The same failure repeats without new evidence.
- Required evidence cannot be bound to current state.
- A required specialized flow has no available owner.
- The user asks to stop or `stop_after` is reached.

The handoff reports the active contract and state IDs, acceptance status, checks,
reviews, open blockers, budget usage, action authorization and results, residual
risk, and the exact human decision needed.

## Reference Files

- `references/philosophy.md` explains the underlying model.
- `references/backpressure-contract.md` defines the active contract template.
- `references/subagent-prompts.md` defines concise role handoffs.
- `references/gate-checklist.md` defines gate decisions without repeating the
  protocol.
