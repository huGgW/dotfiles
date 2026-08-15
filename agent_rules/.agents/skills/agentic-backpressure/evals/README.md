# Agentic Backpressure Evaluations

These evaluations follow the standard `skill-creator` workflow. They test
observable control decisions rather than requiring the model to serialize an
internal evidence or budget ledger.

## What They Measure

- Role separation and independent final review
- Fresh children for every new delegated action
- Narrow resume handling for an unchanged unfinished action
- Rejection of cross-role, changed-state, changed-plan, and changed-scope reuse
- Rejection of evidence for a stale repository state
- Bounded repair and plan-review loops
- Preservation of final verification capacity
- `stop_after` and external-action authorization boundaries
- Safe recovery when a verifier session is unavailable
- Correctness and conditional publication readiness
- Required baseline failures and publication-spec freshness
- Field-level external-action authorization
- Ordered `before_work` and `after_final` Boundary Actions
- Required `before_work` failure and prohibition on `after_final` failure cleanup
- Candidate mutation, authoritative read-back, and idempotent partial retry
- Conditional simplicity triggers, protected necessary complexity, and changed-state rechecks
- Exact subject, scope, context, lens, and identity handoff to `plan-reviewer` and
  `code-reviewer`
- Manager-owned mapping from capability reports to core gate outcomes
- Rejection of reviewer-issued approval, repair-routing, or orchestration authority

The scenarios are policy-level tests. A model saying `fresh` is not proof that the
orchestration host launched a new child without inherited transcript. They do not
replace end-to-end repository runs with real child sessions, hidden defects,
commands, invocation events, and side-effect telemetry.

## Standard Workflow

1. Snapshot the current skill before editing.
2. Run every case in `evals.json` against the candidate and snapshot in parallel.
3. Grade assertions from the output, not from model-authored internal counters.
   Prefer observable route, state, and tool behavior over unprompted negative
   enumeration or compound explanations when one sufficient condition decides.
4. Record actual outer and nested tokens, child calls, wall time, forbidden or
   unauthorized actions, fresh launches, resumes, inherited transcripts, and
   repeated commands when the host exposes them.
5. Aggregate with the standard skill-creator benchmark tool.
6. Generate the skill-creator review viewer before revising the skill again.

Safety and correctness are hard gates. Compare efficiency only among runs that
pass them; otherwise a workflow that does nothing would appear artificially
cheap.

## End-to-End Follow-Up

A release-quality benchmark should add isolated fixture repositories with hidden
defects and capture actual child events. It should verify:

- Hidden defect catch and escape rate
- False-positive blockers on a clean fixture
- Stale evidence rejection after a real candidate mutation
- No action beyond `stop_after`
- No unauthorized Git or remote mutation
- Actual child calls, nested tokens, and end-to-end duration
- New action -> fresh child routing and unchanged unfinished action -> justified
  resume routing
- No child role switching or transcript inheritance across independent actions
- No worker entry after a required `before_work` failure
- No mutating `after_final` action after blocked correctness
- Read-back before retry and no repetition of successful sub-operations
- Final correctness reopening after a Boundary Action changes candidate content
- Capability reviewers returning `COMPLETE`, `INCOMPLETE`, or
  `SUBJECT_MISMATCH` while the manager alone emits core gate outcomes
- `SUBJECT_MISMATCH` mapping to `STALE` with fresh evidence required for the exact
  current candidate

Keep host-generated event IDs and counters outside model output. The model should
report only its terminal decision, current state, evidence summary, and user-facing
handoff.
