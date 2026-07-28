# Agentic Backpressure Evaluations

These evaluations follow the standard `skill-creator` workflow. They test
observable control decisions rather than requiring the model to serialize an
internal evidence or budget ledger.

## What They Measure

- Role separation and independent final review
- Rejection of evidence for a stale repository state
- Bounded repair and plan-review loops
- Preservation of final verification capacity
- `stop_after` and external-action authorization boundaries
- Safe recovery when a verifier session is unavailable
- Correctness and conditional publication readiness
- Required baseline failures and publication-spec freshness
- Field-level external-action authorization

The scenarios are policy-level tests. They do not replace end-to-end repository
runs with real child sessions, hidden defects, commands, and side-effect
telemetry.

## Standard Workflow

1. Snapshot the current skill before editing.
2. Run every case in `evals.json` against the candidate and snapshot in parallel.
3. Grade assertions from the output, not from model-authored internal counters.
4. Record actual outer and nested tokens, child calls, wall time, forbidden or
   unauthorized actions, and repeated commands when the host exposes them.
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

Keep host-generated event IDs and counters outside model output. The model should
report only its terminal decision, current state, evidence summary, and user-facing
handoff.
