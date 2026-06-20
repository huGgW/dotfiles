---
name: agentic-backpressure
description: >
  Use this skill when the user explicitly asks for backpressure, backpressured,
  agentic feedback, subagent review loops, quality-gated development, or a
  BACKPRESSURE.md-driven workflow. It sets up and runs a managed backpressure
  flow where the main agent acts as the flow manager, work and feedback are
  delegated to subagents, mechanical checks run before agent review, and human
  review is reserved for final judgment or blockers. Do not use for ordinary
  coding tasks unless the user asks for backpressure-style execution or
  subagent-based feedback loops.
---

# Agentic Backpressure

## Overview

Backpressure means downstream checks can refuse upstream work before a human has
to catch it. In this skill, the main agent is the manager of that flow, not the
worker and not the reviewer. Work is produced by subagents. Mechanical feedback
comes from commands such as compile, typecheck, lint, tests, build, and project
checks. Agentic feedback comes from independent subagents that did not produce
the work.

The goal is not to make one agent smarter. The goal is to create multiple clear
places where bad work is rejected before it reaches human review.

## When To Use

Use this skill when the user asks for any of these:

- A backpressure or backpressured workflow
- A `BACKPRESSURE.md` setup or run
- A subagent-based work and feedback loop
- A quality-gated coding flow where checks must pass before human review
- A manager/worker/reviewer split for autonomous development

Do not use this skill for a normal implementation request that does not mention
backpressure, subagents, or quality-gated flow. Do not use it for pure code
review unless the user wants the review to act as part of a backpressure loop.

## Manager Role

The main agent manages the flow:

1. Define or refine the goal, acceptance criteria, checks, budget, and gates.
2. Create or update `BACKPRESSURE.md` by default so the run is trackable.
3. Route work to work subagents.
4. Route command execution to verification subagents.
5. Route review to independent feedback subagents.
6. Decide whether each gate passes based on evidence.
7. Stop on exhausted budget, unresolved ambiguity, or a blocker only a human can
   resolve.
8. Hand off to the human with evidence, not vague progress.

The main agent is an orchestrator only. During a backpressure run, it may edit
the backpressure contract, launch subagents, route feedback, synthesize evidence,
and ask the user for decisions. It must not write implementation patches, run
mechanical checks such as tests, builds, lint, or typecheck, perform code review
directly, or use tool access to bypass the worker/verifier/reviewer split. If no
delegation path is available for required work or verification, record the
blocker and ask the human instead of doing the work personally.

## Default Flow

### Phase 0: Contract Setup

Create or update `BACKPRESSURE.md` at the project root before launching work.
Use it as the run contract and tracking artifact. If the file already exists,
preserve user-approved content and update only the parts relevant to this run.

The contract should capture:

- Goal and acceptance criteria
- Iteration budget, defaulting to 3 failed attempts per gate
- Mechanical checks and when they run
- Feedback lenses and routing triggers
- Discoverable codebase patterns and project standards relevant to review
- Subagent roles
- Evidence requirements
- Human handoff rules
- Explicit skips and project-specific constraints

If a value cannot be discovered, write it as an open item in the contract and
ask the user before depending on it. Do not silently invent commands, credentials,
or project conventions.

See `references/backpressure-contract.md` for the template.

### Phase 1: Plan Gate

Ask a work or planning subagent to produce a lightweight plan focused on approach
and architecture, not line-level detail. Then ask an independent feedback subagent
to review the plan. Iterate until the plan has no blocker or until the plan-gate
budget is exhausted.

The plan reviewer should reject approaches that fail acceptance criteria, ignore
known project structure, leave load-bearing decisions unspecified, or overbuild
the solution.

### Phase 2: Work Iterations

Run one coherent patch at a time:

1. Send the next task slice to a work subagent.
2. After the patch, send the result to a verification subagent.
3. Have a verification subagent run mechanical checks before agent review.
4. If a required mechanical check fails, feed the failure packet back to a work
   subagent and do not run code review yet unless review is needed to diagnose.
5. If mechanical checks pass, send the diff to feedback subagents using the
   relevant lenses.
6. If any required lens reports a blocker, feed the findings back to a work
   subagent.
7. Continue until acceptance criteria and required checks pass, or the budget is
   exhausted.

Mechanical feedback comes first because it is cheaper, deterministic, and often
removes noise from later review.

### Phase 3: Final Gate Before Human Review

Before presenting the result to the human:

1. Have a verification subagent run full required mechanical checks, not only
   targeted checks.
2. Have independent feedback subagents run a whole-changeset feedback review.
3. Confirm each acceptance criterion has evidence.
4. Identify runtime, browser, benchmark, or PR-monitoring needs and delegate them
   to the appropriate existing skill, tool, or subagent if the project requires
   them.
5. Do not personally perform specialized runtime flows such as Playwright setup
   unless another loaded skill explicitly owns that work and the user requested
   it.

This skill manages the backpressure flow. It does not replace dedicated skills
for browser testing, benchmarking, deployment, or PR monitoring.

### Phase 4: Human Handoff

Hand off only after the gates pass or a real blocker remains. The handoff should
include:

- Acceptance criteria status
- Mechanical check evidence
- Agentic review evidence
- Remaining risks or skipped gates
- Budget usage
- Clear blocker or final review request

Human review should focus on product judgment, design tradeoffs, unresolved
blockers, or final approval, not catching missing lint, tests, or obvious review
findings.

## Mechanical Checks

Mechanical checks are deterministic feedback sources. They should run before
agentic review whenever practical.

Common checks:

- compile or build
- typecheck
- lint
- format check
- targeted tests
- full tests
- coverage checks
- migration or schema checks
- project-specific verification scripts

Use targeted checks during each iteration when available, then full checks before
human review. A missing command should be recorded as an open contract item, not
treated as passing.

## Feedback Lenses

Run feedback lenses through independent subagents. Use adaptive routing: always
run the required lenses, and add conditional lenses only when the change touches
their risk area.

| Lens | Required | Trigger |
|---|---:|---|
| plan | yes | before implementation |
| correctness-test | yes | after each mechanically green patch and before human review |
| type-design | conditional | data models, APIs, state, schemas, type signatures, casts |
| security | conditional | auth, permissions, user input, secrets, filesystem, network, commands |
| performance | conditional | hot paths, database queries, concurrency, large data, benchmarked areas |
| integration-runtime | conditional | runnable behavior, wiring, env, migrations, service boundaries |

Across code review lenses, reviewers should also consider whether the patch fits
discoverable existing codebase patterns in the touched area, such as architecture
boundaries, naming, error handling, test style, dependency usage, and comparable
implementation shapes. Treat unnecessary divergence as a finding when it creates
maintainability, integration, or reviewability risk; do not block solely on
harmless style preference.

See `references/gate-checklist.md` for gate criteria and
`references/subagent-prompts.md` for prompt templates.

## Budget Rules

Default budget: 3 failed attempts per gate.

The user may override the budget in the prompt or in `BACKPRESSURE.md`. Treat the
budget as a safety valve, not a target. Stop early if the same failure repeats
without new information.

When a gate exhausts budget:

1. Stop the loop.
2. Name the gate and failure.
3. Provide evidence.
4. Explain what was tried.
5. Ask the human for a decision or missing information.

Do not burn attempts by retrying flaky commands without changing conditions or
collecting evidence.

## Evidence Standard

A gate passes only with evidence:

- Mechanical checks need exact command, exit status, and relevant output.
- Agentic reviews need reviewer role, lens, findings, and approval/blocker status.
- Acceptance criteria need observed implementation or verification evidence.
- Skipped gates need an explicit reason from `BACKPRESSURE.md` or the user.

"Looks good" is not evidence. "Tests should cover it" is not evidence. A work
subagent approving its own output is not independent review.

## Stop Conditions

Stop and report instead of forcing progress when:

- The budget is exhausted for any required gate.
- Required commands, credentials, or environment setup are unknown.
- Mechanical checks fail repeatedly with no new diagnosis.
- Feedback subagents keep finding the same blocker.
- Acceptance criteria are ambiguous and the ambiguity affects implementation.
- A specialized runtime, benchmark, browser, or PR flow is required but no proper
  skill/tool/subagent path is available.
- The user asks to leave the backpressure flow.

## Reference Files

- `references/philosophy.md` explains the backpressure philosophy and source
  inspiration.
- `references/backpressure-contract.md` provides the default `BACKPRESSURE.md`
  template.
- `references/subagent-prompts.md` provides prompt templates for worker,
  verifier, and reviewer subagents.
- `references/gate-checklist.md` provides gate-by-gate pass/fail criteria.
