---
name: agentic-backpressure
description: >
  Use when the user explicitly asks for backpressure, backpressured development,
  agentic feedback loops, subagent review loops, quality-gated development, or a
  BACKPRESSURE.md-driven workflow. Routes workers, verifiers, independent reviewers,
  and optional CI/PR observations with current-state evidence and explicit human
  escalation. Do not use for ordinary coding tasks unless the user asks for this
  style of execution.
---

# Agentic Backpressure

## Purpose And Ownership

Downstream checks reject incomplete work before the human handoff. Use the
smallest route preserving required evidence and independent judgment. An
observation-only deliverable does not claim whole-candidate correctness.
The **main current session is always the manager**, including for new runs.
Do not dispatch an intake coordinator or another manager, require fresh-manager
isolation. A new contract is not a new conversation.

The manager owns the contract, routing, gate mapping, and handoff. It
does not implement patches, run authoritative checks, or perform the only review.
Workers produce plans or patches; their commands are diagnostics. Verifiers run
declared checks without source edits. Independent reviewers assess without editing.

## Invariants

1. Latest explicit user intent governs scope and authority. Superseded decisions
   are context, not requirements. Reviewer preferences cannot replace user intent.
2. Resolve goal, scope, stop, and the selected capability's required prerequisites
   before relying on them. Correctness work also needs accepted plan, constraints,
   criteria, checks, and base. Preserve unrelated user work.
3. Keep child worker, verifier, reviewer, and specialist roles separate. Reuse
   never promotes old evidence or changes a child's role.
4. Gate evidence is content-bound to the current specification, base, and state.
   Another state is `STALE`, not `PASS`.
5. Every whole-candidate correctness claim needs required mechanical checks and a fresh independent
   whole-changeset semantic review. Commands cannot replace judgment.
6. Stop unchanged failures without new evidence, hypothesis, or approach. Recurring
   oscillation or fruitless repairs require investigation or human help, not
   unlimited loops disguised as novelty. Renaming preserves blockers and outcomes.
7. Stop for unresolved requirements, unavailable required evidence, repeated
   unchanged failures, fruitless repairs, or the user's stop instruction.
8. External authority and `stop_after` are separate. Exact permission neither
   authorizes adjacent actions nor overrides the stop point.

Only `PASS` satisfies a required outcome. Other gate outcomes are `SEND_BACK`,
`BLOCKED`, `STALE`, and `ESCALATE_HUMAN`. External CI `pending` is a waiting
condition, not a repair verdict; mapping belongs to `gate-checklist.md`.

## Contract Intake

Read `references/run-lifecycle.md` and `references/backpressure-contract.md`.
Choose `new` for a distinct request, `extend` for authorized added requirements
benefiting from joint validation, or `continue` for the same unfinished work.
Quiesce old children before replacing the active file; archive one compact final
summary and relevant evidence references, not log copies or gate snapshots.
Preserve existing contracts and archives; no destructive migration is required.

Inventory staged, unstaged, and relevant untracked work. Choose an immutable base
covering all in-scope changes needing review; do not hide existing in-scope work
by choosing a convenient base. Protected out-of-scope work remains untouched.

Project a sufficient user-approved plan directly into the contract: skip a
planning worker. Preserve terminology, sequence, conditions, ownership, public
API, and non-goals. A materially new plan needs user agreement before patching.

Projection also tests the plan. A decision is unresolved, even if nobody flagged
it, when a criterion cannot be made checkable, linked fields conflict, or plausible
interpretations differ in ownership, public API, failure, or rollback behavior.
Look up facts yourself. Choices that do not materially change the diff, ownership,
public API, or criteria become recorded plan assumptions, not questions. Proceed
when nothing remains; only the manager asks the user about what does.

One independent decision gets one focused question. Several or dependent decisions
need a user interview that stress-tests the plan: discover/load an available
capability through supported host tools; if none, ask in rounds every decision whose
prerequisites are settled, each with a recommended answer. The scope above bounds
any loaded capability. Stop when every contract field projects without invention
and the user confirms; record answers as decisions before freezing.

Keep `BACKPRESSURE.md` as a current summary, not a history ledger. Required fields
are goal/scope/stop, required outcomes and current evidence, active work/blocker/
next action. For correctness work include accepted plan/constraints, criteria/
checks, validation hash/state. Decisions, superseded context, publication, and
Boundary Actions appear only when applicable.
Never omit relevant superseded meaning, unresolved hazards, or unknown outcomes.

## Select The Route

Read `references/routing.md` to select capabilities from the goal, prerequisites,
and available evidence. Enter at local work, an existing PR, CI observation, or PR
feedback observation. Active, required, and authorized mean different things:
selecting a capability neither makes it required nor permits external writes.

Keep a thin recipe and current pending outcomes, not a graph engine or node ledger.
Observation-only work needs no gratuitous patch, local check, review, commit, or
push. Whole-candidate correctness and authorized publication still require the
local gates below; reuse only unaffected current evidence, never skip a required
gate. CI and PR feedback are optional capabilities; when both are selected as
required, both must pass. `run-lifecycle.md` owns continuity and anti-loop stops.

## Child Lifecycle

Use `references/subagent-prompts.md`: shared handoff plus a small role delta.
Send references, exact scope, current identity, and repair context, not full
contracts, transcripts, or duplicated ledgers. Record tool-reported child ID,
mode, and reuse/recovery reason once with evidence. Children read current facts
and act without a protocol-only identity handshake.

Default to fresh children. The same worker may resume for an in-scope repair;
the same verifier may resume for a changed-state recheck of the same approved
scope. Reuse only a **terminal, host-reusable** child in that same role, sending
a new handoff establishing current contract, state, delta, and checks. Prior
context is not evidence. A new objective or role requires a new child.

A live child receives a queued message through the host's supported mechanism,
not a resume call. If unavailable, wait or stop; do not start a concurrent writer.
Interrupted recovery is distinct: establish actual host status, candidate state,
completed checks, and partial side effects before retrying. If recovery/resumption
is unsupported, replace only after quiescing the old action.

Every reviewer invocation is fresh and independent, with no inherited worker or
reviewer transcript. The final reviewer is fresh even after an early review.
Never switch roles, fork a worker transcript into a reviewer, or promote old
checks merely because a child is reused.

## Default Local Route: One Frozen Patch

1. Activate the contract and resolve prerequisites; apply a plan gate only when
   risk/uncertainty requires it.
2. Execute eligible declared `before_work` actions, if any.
3. Delegate one coherent patch within the accepted plan to a worker.
   Worker commands are implementation-relevant reproduction/diagnostics, not a
   ritual full-suite run before the independent verifier.
4. Stop repository-changing work; freeze specification, base, and candidate.
5. One verifier runs applicable targeted plus final required checks on that state.
   Run identical checks once on the frozen state and map all coverage IDs.
   Measure identity before/after the check set, not every command; detect drift.
6. After mechanical `PASS`, one fresh independent whole-changeset reviewer covers
   correctness/tests and applicable simplicity/risk lenses together.
7. Map its report; confirm every criterion and active decision has current evidence
   or an explicit blocker. Correctness passes only with all required gates.
8. Execute eligible publication/`after_final` actions. Observe selected external
   outcomes when applicable, then hand off at the declared stop occurrence.

Do not impose a routine targeted-review-final-verifier-final-review chain.
An unchanged frozen candidate with complete required checks already has final
mechanical evidence; no duplicate verifier invocation is needed.

## Conditional Early Gates

Plan review is required for load-bearing architecture, migration/rollback,
material scope uncertainty, or explicit user requirements. Security, migration,
data-loss, concurrency, or production risk may trigger it; file count alone does
not. Hash the exact plan and use a fresh `plan-reviewer`. Repeated unresolved
findings follow the anti-loop stop rather than triggering endless new reviews.

Early targeted verification or focused review is conditional on multiple coherent
slices, load-bearing uncertainty, or high repair risk where feedback changes the
next safe action. Record trigger and coverage. Early reviews never replace final
whole-changeset review. If early checks cover every final requirement on the
subsequently frozen unchanged state, reuse evidence; otherwise a verifier runs
only uncovered required checks for that state.

`references/simplicity-review.md` owns simplicity triggers and placement. Combine
applicable lenses in the final reviewer by default. A separate early simplicity
or risk child needs a sequencing reason, not merely a lens trigger.

## Repairs And Root-Cause Safety

Map supported in-scope findings to a worker delta; retain stable finding IDs.
Recompute state after repair and obtain changed-state evidence. Worker/verifier
may reuse terminal same-role children; reviewer stays fresh. Reassess triggers
and the required route. Material plan changes need renewed agreement: quiesce
children, then resolve their decisions under Contract Intake. Report unrelated
findings without fixing them.

Before widening production scope from one failing test, changing transaction
boundaries, changing locking/concurrency, or acting with unresolved fixture-versus-
production attribution, require applicable focused root-cause evidence:
authoritative precondition, clean fixture reproduction, control case, transaction
ownership/exception propagation, concrete lock target/acquisition order.
An unverified cause remains a hypothesis. Missing evidence routes investigation,
`BLOCKED`, or a human decision, never speculative production repair.

Diagnose baseline failures on an isolated read-only base or immutable snapshot,
never by resetting/overwriting the active worktree. Required baseline failures
remain non-pass; escalate when no authorized route establishes the criterion.

## Evidence And Handoff

`backpressure-contract.md` owns hashes/state; `gate-checklist.md` owns evidence
requirements and capability mapping. Bind before/after state to authoritative
check sets and reviews. Candidate/specification changes stale dependent evidence
and final semantic review. Child identity attributes evidence; it does not validate.
Use one compact criterion/decision-to-evidence mapping. Reference contract anchors
and IDs; report results/deltas, not unchanged facts or empty optional sections.
Retain mandatory identity, check evidence, and reviewer capability fields.

Load `references/boundary-actions.md` only when actions/publication apply. It owns
exact permissions, ordering, `stop_after`, read-back, partial-result safety,
retries, and candidate-mutation reopening. Correctness can pass while publication
or external actions remain blocked. Implementation approval never implies commit,
push, PR, release, deployment, or notification permission.

Handoff reports the deliverable actually established, actual stop occurrence,
required-outcome coverage, current evidence references, blockers, next action,
residual risk, and the exact human decision needed. Include contract/hash/state
for correctness work, and external provenance, authority, partial/unknown state,
deadline, and read-back only when relevant. Observation completion is not a
whole-candidate correctness verdict.

## Reference Loading

- Intake/state: `run-lifecycle.md`, `backpressure-contract.md`.
- Route selection and external observations: `routing.md`.
- Dispatch: `subagent-prompts.md`; gate mapping: `gate-checklist.md`.
- Simplicity: `simplicity-review.md`; actions/publication: `boundary-actions.md`.
- Rationale only: `philosophy.md`. Existing binary diagrams illustrate the legacy
  local route only; they are explanatory, not current routing policy authority.
