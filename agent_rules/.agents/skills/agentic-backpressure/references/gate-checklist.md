# Gate Checklist

Use this checklist to decide whether the loop can advance. A gate passes only
with evidence.

## Contract Gate

Passes when:

- `BACKPRESSURE.md` exists at the project root or the manager has created it.
- Goal and acceptance criteria are explicit.
- Iteration budget is explicit, defaulting to 3 failed attempts per gate.
- Mechanical checks are listed or marked unknown.
- Feedback lenses and routing triggers are listed.
- Open items are captured instead of assumed.

Fails when:

- The run has no written contract.
- Required commands or credentials are silently guessed.
- Acceptance criteria are too ambiguous to guide work.

## Plan Gate

Passes when:

- A work/planning subagent produced a lightweight plan.
- An independent feedback subagent reviewed the plan.
- The plan has no [BLOCKER] findings.
- Load-bearing decisions are explicit enough to start implementation.

Fails when:

- The plan reviewer reports [BLOCKER] findings.
- The approach does not satisfy acceptance criteria.
- The plan ignores existing project structure or reinvents obvious infrastructure.
- A load-bearing decision is left as "somewhere appropriate" or equivalent.

## Role Boundary Gate

Passes when:

- The main agent only orchestrated: contract edits, routing, synthesis, budget
  decisions, and human handoff.
- Implementation work came from worker subagents.
- Mechanical checks came from verification subagents or explicitly delegated
  specialized flows.
- Code review came from independent feedback subagents.

Fails when:

- The main agent writes implementation patches during the backpressure run.
- The main agent runs tests, builds, lint, typecheck, or other mechanical checks
  directly instead of delegating verification.
- The main agent performs the only code review or treats its own inspection as
  independent feedback.
- The main agent bypasses a missing delegation path instead of recording a
  blocker or asking the human.

## Mechanical Gate

Passes when:

- Required checks for the stage ran successfully.
- Each check has command, exit status, and output evidence.
- Unknown or skipped checks have explicit contract entries.

Fails when:

- Any required check fails.
- The verifier cannot run a required check because setup is unknown.
- A check is skipped without an explicit skip rule.
- A command is retried repeatedly without new diagnosis.
- The manager ran the required check directly and presented it as delegated
  verification evidence.

## Agentic Review Gate

Passes when:

- Required lenses ran through independent feedback subagents.
- Conditional lenses were routed when their triggers matched the change.
- No required lens has unresolved [BLOCKER] findings.
- [SHOULD] findings are either fixed or explicitly accepted as residual risk.
- Reviewers considered relevant existing codebase patterns when those patterns
  were discoverable in the touched area.

Fails when:

- The same subagent that wrote the patch is the only reviewer.
- The manager performs the only review instead of routing to independent feedback
  subagents.
- Required lenses were skipped.
- A [BLOCKER] remains unresolved.
- Findings lack enough detail for the work subagent to act.
- The review ignores an obvious divergence from existing project patterns that
  affects maintainability, integration, test consistency, or reviewability.

## Final Gate

Passes when:

- Full required mechanical checks pass.
- Whole-changeset review passes.
- Each acceptance criterion has evidence.
- Runtime, browser, benchmark, deployment, or PR gates are either delegated,
  completed, marked not required, or explicitly blocked.
- The evidence bundle is ready for human review.

Fails when:

- Only targeted checks ran.
- Acceptance criteria are asserted without evidence.
- Specialized gates are required but there is no responsible skill/tool/subagent.
- The manager is about to call the task done because the work subagent says it is
  done.

## Human Handoff Gate

Passes when the manager can report:

- What changed
- Which acceptance criteria pass
- Which mechanical checks ran and passed
- Which agentic reviews ran and passed
- Which gates were skipped and why
- Budget usage
- Remaining risks, blockers, or final decision points

Fails when the handoff asks the human to discover routine issues that the loop
should have checked first.
