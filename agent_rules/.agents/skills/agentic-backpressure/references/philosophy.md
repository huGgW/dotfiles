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

With backpressure, the flow becomes:

```text
Goal
-> Contract
-> Plan reviewed by independent feedback
-> Work subagent writes a patch
-> Mechanical checks reject bad patches first
-> Feedback subagents reject design, correctness, or test-quality issues
-> Final evidence bundle reaches the human
```

The important shift is not more autonomy by default. The shift is longer
delegation with earlier refusal points.

## Local Adaptation

The original `backpressured` plugin includes a broad flow with browser testing,
benchmarks, PR opening, and PR monitoring. This skill intentionally narrows the
scope:

- It sets up and manages the backpressure flow.
- It creates and maintains `BACKPRESSURE.md` for tracking.
- It delegates work, verification, and feedback to subagents.
- It routes specialized runtime work to existing skills or tools instead of
  owning those domains directly.

That narrower scope keeps the skill composable and prevents it from becoming a
large all-purpose automation layer.
