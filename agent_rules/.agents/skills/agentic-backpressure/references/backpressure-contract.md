# BACKPRESSURE.md Contract Template

Create or update `BACKPRESSURE.md` at the project root by default whenever this
skill starts a backpressure run. Use the file as the shared contract for the
current project or run. Preserve existing user-approved content when editing.

Do not record secrets. Record where secrets come from, not their values.

## Template

```markdown
# Backpressure Contract

## Goal

- Objective: <what the run is trying to accomplish>
- Scope: <files, modules, feature area, or issue links>
- Out of scope: <what this run must not do>

## Acceptance Criteria

- [ ] <observable criterion 1>
- [ ] <observable criterion 2>
- [ ] <observable criterion 3>

## Iteration Budget

- Default failed-attempt budget: 3 per gate
- Override for this run: <none | number and reason>
- Stop early when the same failure repeats without new evidence.

## Mechanical Checks

| Check | Command | Stage | Scope | Required | Notes |
|---|---|---|---|---:|---|
| compile/build | <command or unknown> | each-iteration, final | targeted/full | yes | <notes> |
| typecheck | <command or unknown> | each-iteration, final | full if cheap | yes | <notes> |
| lint | <command or unknown> | each-iteration, final | changed files/full | yes | <notes> |
| tests-targeted | <command or unknown> | each-iteration | touched behavior | yes | <notes> |
| tests-full | <command or unknown> | final | full | yes | <notes> |
| coverage | <command or unknown> | final when behavior changes | full | conditional | <notes> |
| project-specific | <command or unknown> | <stage> | <scope> | <yes/no> | <notes> |

## Feedback Lenses

| Lens | Stage | Required | Routing Trigger | Notes |
|---|---|---:|---|---|
| plan | before implementation | yes | always | approach and load-bearing decisions |
| correctness-test | each mechanically green patch, final | yes | always | behavior, edge cases, test quality |
| type-design | each relevant patch, final if touched | conditional | models, APIs, schemas, type signatures, casts | <notes> |
| security | each relevant patch, final if touched | conditional | auth, permissions, input, secrets, fs, network, commands | <notes> |
| performance | each relevant patch, final if touched | conditional | hot paths, DB, concurrency, large data | <notes> |
| integration-runtime | final or wiring-heavy iterations | conditional | runnable behavior, env, service boundaries | <notes> |

Across code review lenses, compare patches against discoverable patterns in the
touched area: architecture boundaries, naming, error handling, test style,
dependency usage, and comparable implementation shapes. Treat unnecessary
divergence as review feedback when it creates maintainability, integration, or
reviewability risk; do not block solely on harmless style preference.

## Subagent Roles And Boundaries

- Manager: main agent. Owns routing, gates, budget, synthesis, and human handoff.
  Does not write implementation patches, run mechanical checks, or perform code
  review directly during the backpressure run.
- Worker: subagent that writes the next patch or plan. Does not approve own work.
- Verifier: subagent that runs mechanical checks. Does not edit files.
- Reviewer: independent feedback subagent. Does not edit files.

## Evidence Requirements

- Mechanical check evidence: command, exit status, and relevant output.
- Review evidence: lens, reviewer role, findings, and approval/blocker status.
- Role-boundary evidence: work, checks, and review came from the assigned
  worker, verifier, and reviewer roles rather than the manager.
- Acceptance evidence: how each criterion was observed or verified.
- Skip evidence: explicit skip reason from this file or the user.

## Runtime And Specialized Gates

- Browser testing: <delegate to existing skill/tool/subagent | not required | unknown>
- Benchmarking: <delegate to existing skill/tool/subagent | not required | unknown>
- PR monitoring: <delegate to existing skill/tool/subagent | not required | unknown>
- Deployment or release: <delegate to existing skill/tool/subagent | not required | unknown>

## Human Handoff

- Human reviews after required gates pass or a blocker is reached.
- Human should decide product/design tradeoffs, unresolved blockers, or final approval.
- Human should not be asked to catch missing compile, lint, test, or routine review failures.

## Skips

- <gate>: <reason and who approved it>

## Open Items

- [ ] <missing command, credential source, environment requirement, or decision>
```

## Creation Rules

When creating the file:

1. Fill in what can be discovered safely.
2. Mark unknowns explicitly instead of inventing answers.
3. Ask the user for required unknowns before the run depends on them.
4. Keep the file concise enough to remain useful as a tracking artifact.
5. Update the file as the run discovers gates, skips, or blockers.

When editing an existing file:

1. Preserve existing decisions and project-specific guidance.
2. Add run-specific information under the relevant headings.
3. Do not delete skips, commands, or constraints unless the user asks.
4. Record budget overrides and human-approved exceptions.
