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
Externalize the state needed for each action, then start it in a fresh child so
stale assumptions and prior role context do not silently shape the result. Truth
comes from the active contract, current repository state, and attributable
evidence, not session continuity.

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
7. Start every new delegated action in a fresh child. Resume only the exact same
   unfinished action under the narrow continuity exception below.
8. Bound total child calls and repair rounds across fresh launches and resumes.
9. Do not repeat an unchanged failure without new evidence.
10. Run final required mechanical checks and an independent whole-changeset review
   against one frozen candidate. Mechanical success does not establish semantic
   correctness.
11. Link every active correctness decision and acceptance criterion to current
     evidence or an explicit blocker.
12. Stop for unresolved requirements, exhausted budget, repeated failures, or
    unavailable required evidence instead of weakening a gate.
13. Treat `stop_after` and authorization for every Boundary Action as separate
    decisions. Authorization permits an exact action; it does not require one or
    authorize adjacent operations.
14. Keep Boundary Actions declarative and ordered; they must not become arbitrary hooks or mutate the frozen candidate without reopening the correctness loop.

Gate outcomes are `PASS`, `SEND_BACK`, `BLOCKED`, `STALE`, and `ESCALATE_HUMAN`. Only `PASS` advances.

## Roles

### Intake Coordinator

Read `references/run-lifecycle.md` before activating or reusing a contract. Choose
`new` (default), `extend` (justified expansion), or `continue` (unfinished contract).
For `new`, dispatch a fresh manager without inherited conversation history. The
coordinator handles intake and user communication, not gates. An assigned manager
starts directly without another manager dispatch. Report unavailable isolation.

### Manager

The run's manager owns the decision record, faithful projection of the agreed plan,
contract activation, routing, budget accounting, gate decisions, evidence
synthesis, Boundary Action coordination, and human handoff. It delegates each
action to the named specialized workflow or tool and records child IDs, fresh or
resumed mode, and any resume reason. Child IDs are operational state, not fields
a child must discover or report about itself.

When explicit user feedback creates, resolves, or changes a correctness decision,
the manager records the active decision, marks any prior decision superseded,
updates every linked normative contract field and affected plan step, and
recomputes the validation specification hash before work continues. Children
report conflicts; they do not maintain or rewrite the decision record.

The manager must not:

- Write implementation patches.
- Run authoritative mechanical checks.
- Perform the only correctness review.
- Reset an unchanged run's budgets by changing sessions, run IDs, or gate names.
- Mint a new run or extension grant to bypass failure or authority stops.
- Infer permission for an external action.

### Worker

A worker creates a plan or the next coherent patch. It preserves unrelated
worktree changes and does not approve its own output. A plan revision, patch
repair, investigation, or distinct work slice is a new action and uses a fresh
worker with an explicit handoff.

### Verifier

A verifier runs the contract's mechanical checks without editing source files.
A changed state, check set, gate, or verification purpose creates a new action and
uses a fresh verifier. Retain cumulative budgets and completed evidence that still
matches the current state; evidence reuse does not require session reuse.

### Reviewer

A reviewer is independent of the worker, does not edit files, and uses a fresh
child. The child loads `plan-reviewer` or `code-reviewer` for the manager's exact
request; the manager owns mapping and routing through `references/gate-checklist.md`.

## Invocation Freshness

An action identity consists of the `run_id`, role, gate, requested action,
applicable specification hashes, current `state_id`, and declared check or review
scope. Launch a new child or subtask with no inherited child transcript for every
new action. A new child ID created by forking an earlier child transcript is not
fresh. Boundary Action identity also includes every manifest field, including
exact authorization and payload.

Resume a child only when the original action has not returned a terminal result,
every action-identity field is unchanged, and one of these conditions applies:

- A transport or protocol interruption stopped the action.
- A specialized workflow explicitly requires non-reconstructible child-local
  runtime state.
- The user explicitly requires continuity without weakening role separation or a
  gate.

Before resuming, re-establish the current contract and repository state and record
the concrete reason. A partial result from an unfinished check set may remain
valid when it matches the same state; run only the incomplete portion. Familiarity,
useful context, token savings, ownership of a prior patch or finding, or membership
in the same gate are not sufficient reasons to resume.

Do not resume when an action returned a terminal result; any action-identity field
changed; a decision, plan, candidate, work slice, role, or gate changed; a repair
or changed-state recheck begins; or an independent or final judgment is required.
Do not switch a child between worker, verifier, reviewer, or specialist roles.

## Active Contract And State

Create or update `BACKPRESSURE.md` before launching work. Keep it limited to one
active run. Apply `references/run-lifecycle.md` and the template in
`references/backpressure-contract.md` before reusing a contract or its budgets.

The active run records:

- `run_id`, request mode and source, profile, and manager context isolation
- Concise decision sources, normative active decision bindings, superseded
  decisions, and unresolved decisions
- Goal, scope, out-of-scope boundary, and acceptance criteria
- Required ownership boundaries, public API shape, and a semantically faithful
  agreed plan
- Required correctness checks and review triggers
- `validation_spec_hash` and `publication_spec_hash` when publication is required
- Repository base, `HEAD`, and current `state_id`
- The ordered Boundary Action manifest, `stop_after`, and separate exact action
  authorization
- Child-call and per-gate repair limits and usage, plan-review allowance,
  final-call floor, and compact idempotent extension grants
- Current blockers, gate results, and acceptance status
- Per-action status, result, evidence binding, and authoritative read-back
- Tool-reported child identity, invocation mode, and any resume reason attached to
  the applicable evidence

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

Archive replaced contracts at `.backpressure/runs/<run_id>/run.md`. New runs retain
only relevant handoff facts, not historical approvals or evidence. Never record secrets.

## Profiles And Budgets

Choose the lowest profile that covers known risk. Use Standard when uncertain.

| Profile | Use when | Max child calls | Repair rounds per gate | Final-call floor |
|---|---|---:|---:|---:|
| Lite | Localized, low-risk work | 10 | 2 | 3 |
| Standard | Ordinary multi-file or behavioral work | 20 | 3 | 4 |
| Critical | Auth, security, migration, data loss, concurrency, production, or release risk | 32 | 4 | 6 |

These are initial ceilings, not targets. Apply `references/run-lifecycle.md`
before dispatch: `new` starts with full profile limits; `extend` adds a unique
profile-sized or explicit grant; `continue` preserves limits and usage. Every
child launch or resume costs a call; completed non-pass gates cost repair rounds.
Plan review allows two calls per initial or material-extension allowance. Boundary
Actions retain two attempts. Recompute the final-call floor; never add floors.

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

Before dispatch, the manager adds and checks the required role-specific fields in
`references/subagent-prompts.md`, then derives the action identity from the full
handoff. It launches fresh and records mode and any valid resume reason outside
the specification. Recover missing facts from sources; never invent them.

The child reads the references and acts in the same invocation without an identity
handshake. If context or state cannot be established, non-reviewers return `STALE`
or `BLOCKED`; reviewers return capability `SUBJECT_MISMATCH` or `INCOMPLETE` for
manager mapping. Neither may substitute prior evidence for the referenced state.

If required facts remain unavailable, report the gap and route investigation or handoff.

## Default Flow

### 1. Contract

1. Apply `references/run-lifecycle.md`; preserve work and choose the review base.
2. Discover the goal, decision sources, active and superseded decisions, scope,
   checks, risk, repository state, stop point, and authorization without guessing.
3. Project the final agreed plan faithfully; an already user-approved plan needs
   no duplicate worker approval. Preserve accepted terminology, ordering,
   constraints, ownership, public API shape, and non-goals.
4. When a structural request such as split, move, extract, merge, unify, or
   separate has plausible interpretations that materially change the diff,
   ownership boundary, or public API, ask one focused axis question before
   freezing the contract. Do not force clarification when those outcomes are
   materially the same.
5. Select the profile and initialize, extend, or retain budgets for the mode.
6. Activate `BACKPRESSURE.md` and compute specification hashes and state ID.
7. Stop before planning or implementation when a required decision or material
   structural axis remains unresolved.

### 2. Plan When Needed

Use a planning worker and one independent plan-review action for Standard and
Critical work, or when architecture, migration, rollback, or scope is uncertain.
Lite may proceed without a separate plan review unless the user requested a plan
stop or the task has a load-bearing decision.

Before each review, hash the exact plan into the validation specification and
launch a fresh `plan-reviewer` child through `references/subagent-prompts.md`.
Required coverage includes semantic drift, scope, ownership, public API,
repository fit, load-bearing decisions, and superseded decisions. Map the report
through `references/gate-checklist.md`; a plan edit invalidates dependent evidence.

If backpressure creates a materially new plan, stop before patching until the user
agrees. Findings cannot broaden scope; plan changes need renewed agreement, and
unrelated findings are reported rather than fixed.

After a revision, use a fresh reviewer for the second and final review in that
plan allowance. Unresolved blockers or SHOULD findings then require escalation.
Only a user-authorized material contract extension grants another plan allowance
under `references/run-lifecycle.md`; ordinary revisions and reviewer replacement
never reset it or remove existing findings.

### 3. Before Work Actions

After Contract and any required Plan Gate pass, execute eligible `before_work`
actions in manifest order without crossing `stop_after`. A required non-pass
blocks implementation; an optional non-pass may continue only when independent
of every correctness prerequisite. An action-ID stop executes through that action.

Bind plan-publishing evidence to `agreed-plan@<validation_spec_hash>`. Publishing
a plan does not make the external copy a Decision Source unless the user grants
it that authority.

### 4. Work And Verify

For each coherent patch:

1. Let a fresh worker implement only the requested slice and record its new `state_id`.
2. Ask a fresh verifier to run applicable targeted checks once for that state.
3. Reject evidence whose state differs or whose check changed the candidate.
4. Apply the conditional root-cause evidence rule before a triggered production repair or scope expansion.
5. After targeted `PASS`, use a fresh `code-reviewer` child with the simplicity
   lens only for a trigger in `references/simplicity-review.md`.
6. Route a supported repair to a fresh worker.
7. Reverify and rereview every repair against its new `state_id` before freezing.
8. Run any other fresh focused risk or blocker review through `code-reviewer`
   only when required.
9. Stop when the gate passes, blocks, or reaches budget.

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

### 5. Final Correctness

Stop repository-changing work and freeze the active decisions, agreed plan,
current `validation_spec_hash`, base, and `state_id`.

1. A fresh verifier runs all required final mechanical checks.
2. A fresh independent child loads `code-reviewer` for the whole changeset and
   required semantic context. The manager maps its capability report; the reviewer
   does not approve the gate.
3. The manager confirms every active correctness decision and acceptance
   criterion has current evidence.
4. Mechanical `PASS` proves only that declared commands passed on the referenced
   state; it cannot substitute for semantic review.
5. Any candidate-content or correctness-specification change returns the gate to
   pending.

Targeted checks and focused reviews do not replace this final gate.

### 6. Publication Readiness When Needed

Create a publication-readiness checklist only when an `after_final` action needs
it. Map each item to the action it must precede. Include required lockfiles,
generated artifacts, changelog, version metadata, migration packaging, and
project-specific publication checks. A verifier owns mechanical publication
checks. Use an independent reviewer only when the publication specification
requires judgment review.

Correctness may pass while publication readiness is blocked. Candidate-changing
repairs reopen it. After commit, preserve content-bound evidence only when the
committed tree equals the frozen candidate; rerun commit-dependent checks against
the exact `HEAD`.

### 7. After Final Actions And Handoff

Final Correctness must pass before any `after_final` action. Execute eligible
actions sequentially from the manifest:

1. Confirm the action is not beyond `stop_after`.
2. Confirm current target-specific authorization and operation mode.
3. Confirm its prerequisites and applicable publication readiness pass.
4. Delegate to the declared specialized skill or tool.
5. Read the resulting state back from the authoritative source.

Candidate mutation takes precedence over action failure classification. Classify
each changed path: lockfiles, changelogs, and generated release artifacts are
publication repair; every other candidate change is a work slice. Mixed changes
follow both routes and cannot hide non-publication work. Recompute `state_id` and reopen
Final Correctness regardless of requiredness. When content is unchanged, a
required failure blocks later actions without changing correctness `PASS`; an
optional failure may continue only to independent actions. On timeout or partial
success, read back before retrying. Recheck current prerequisites, stop point,
budget, and authorization, then retry only confirmed-incomplete idempotent work.
Without authoritative read-back, preserve reported success as tool-reported-only
and do not repeat it. A commit retains content-bound evidence only when its tree
equals the frozen candidate.

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
| `SEND_BACK` | Worker-, fixture-, or tooling-owned repair is supported by evidence | Send a focused delta to a fresh child in the owner role |
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

Boundary Action evidence records identity, requiredness, owner, target, operation,
payload, prerequisites, authorization, applicable hashes and state, attempts,
before/after observations, authoritative read-back, and result. Unknown external
outcomes remain non-pass until read-back resolves them.

The manager attaches tool-reported producer identity, invocation mode, and any
resume reason to the applicable evidence and updates budgets. Child responses do
not maintain duplicate evidence, invocation, or decision ledgers. Add timestamps
or environment details only when they matter to a flaky, time-sensitive, or
environment-sensitive result.

## Stop Conditions

Stop and hand off when:

- A required contract value or authorization is unresolved.
- A structural axis that materially changes the diff, ownership, or public API is unresolved.
- The plan still has a blocker after the second review in its current allowance.
- A hard budget is reached or another repair would cross the final-call floor.
- The same failure repeats without new evidence.
- Required evidence cannot be bound to current state.
- A required specialized flow has no available owner.
- The current execution of a required Boundary Action is terminally non-pass or
  has an unresolved partial result; stale results retain real-world outcome facts.
- The user asks to stop or `stop_after` is reached.

The handoff reports the active contract and state IDs, acceptance status, checks,
reviews, open blockers, budget usage, action authorization and results, residual
risk, and the exact human decision needed.

## Reference Files

- `references/run-lifecycle.md` defines request modes, manager isolation, and grants; read at intake and before budget decisions.
- `references/philosophy.md` explains the underlying model.
- `references/backpressure-contract.md` defines the active contract template.
- `references/boundary-actions.md` defines the action schema and execution rules.
- `references/subagent-prompts.md` defines concise role handoffs.
- `references/gate-checklist.md` defines gate decisions without repeating the protocol.
- `references/simplicity-review.md` defines the conditional simplicity lens and repair route.
