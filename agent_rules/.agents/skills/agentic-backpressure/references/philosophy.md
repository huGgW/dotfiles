# Backpressure Philosophy

This skill follows the backpressure model described by Lucas F. Costa in
"Backpressure is all you need" and the public `lucasfcosta/backpressured`
example plugin.

Source references:

- https://www.lucasfcosta.com/blog/backpressure-is-all-you-need
- https://github.com/lucasfcosta/backpressured

## Core Idea

In systems engineering, backpressure is how a downstream component tells an
upstream producer it cannot accept more work. In agentic development, the same
principle means a check, verifier, reviewer, or runtime gate refuses incomplete
work before a human has to catch it.

Humans should be the final review layer, not the default feedback loop. Every
issue that can be caught by compile, typecheck, lint, tests, build, benchmark,
verification scripts, or independent review should be caught there first.

## Applied To Agentic Work

Without backpressure, the main agent produces patches and asks the human to catch
mistakes. That creates low-quality handoffs and makes the human an expensive
clipboard between automated systems.

For local implementation, the default flow becomes:

```text
Goal
-> Contract
-> Plan reviewed by independent feedback when risk or uncertainty requires it
-> Optional declared before-work actions
-> Work subagent writes a patch
-> Freeze one completed patch
-> One verifier covers targeted and required final checks
-> One fresh independent whole-changeset reviewer covers applicable lenses
-> Final correctness decision
-> Optional declared after-final actions
-> Selected CI and PR feedback observations when applicable
-> Final evidence bundle reaches the human
```

The important shift is not more autonomy by default. The shift is longer
delegation with earlier refusal points.

The main current session manages the run. Early slice gates are conditional on
risk or uncertainty, not a ritual; same-role worker/verifier continuation can
save context without making stale evidence current. The final review stays fresh.

## Local Adaptation

The original `backpressured` plugin includes a broad flow with browser testing,
benchmarks, PR opening, and PR monitoring. This skill intentionally narrows the
scope:

- It sets up and manages the backpressure flow.
- It creates and maintains `BACKPRESSURE.md` for tracking.
- It delegates work, verification, and feedback to subagents.
- It routes specialized runtime work to existing skills or tools instead of
  owning those domains directly.
- It permits ordered `before_work` and `after_final` Boundary Actions only when
  they are declared in the active contract with exact authorization and read-back.
- It does not expose arbitrary plugin hooks or a generic failure finalizer.

That narrower scope keeps the skill composable and prevents it from becoming a
large all-purpose automation layer.

`routing.md` also permits entry at an existing PR or directly at CI/feedback
observation. Choose only capabilities needed for the goal. An observation-only
handoff need not manufacture a patch or local review, and does not claim the whole
candidate is correct. Required outcomes remain binding; active capability,
required outcome, and exact mutation authority are separate decisions.

Keep the recipe and current evidence, not numeric call/repair budgets or a node
ledger. Stop unchanged failures and recurring fruitless repairs instead of
restarting the same loop with new names. External waits use a persistent deadline
and host events/checkpoints, not a monitoring daemon. Existing PNG/Excalidraw
diagrams are legacy local-route illustrations, not current routing policy.
