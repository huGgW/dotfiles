# Local Issue Template

Read this template only after the user approves the breakdown and requests complete local Markdown issue files.

Create one file per issue. Replace every placeholder with concrete content and omit conditional sections that do not apply.

```markdown
# <NN> - <Outcome-oriented issue title>

**Status:** ready-for-agent

## Goal and context

- <One independently observable user, operator, or system result first.>
- <Concise reason and minimum context needed for implementation decisions.>

## Implementation approach

- **Confirmed constraints:** <Evidence-backed contracts, invariants, or boundaries that must hold.>
- **Proposed approach:** <Relevant components, contracts, and data flow; what to reuse and what to change.>
- **Assumptions:** <Only when applicable: unconfirmed premises behind the proposed approach.>
- **Open questions:** <Only when applicable: missing evidence to confirm and its effect on the approach.>

<!-- Include sequence only when ordering materially affects correctness or delivery. The approach is negotiable within confirmed constraints, not a frozen method-level task list. -->

## Acceptance criteria

- [ ] <Observable success behavior and its important boundary.>
- [ ] <Failure, authorization, compatibility, or integrity behavior when relevant.>

## Non-goals

<!-- Omit when there are no meaningful exclusions. -->

- <Related work intentionally excluded from this issue.>

## Verification

- <Focused automated test, integration check, runtime observation, or reproducible evidence.>

## Risks and rollout

<!-- Omit when there are no material risks or release concerns. Keep relevant principal intent/risk, green landing, and safe release/rollback reasoning once, here or in the approach. -->

- **Principal intent / risk:** <The behavior to review or the main data, compatibility, security, or operational risk.>
- **Rollout:** <Only when special rollout is relevant: staged, flag-controlled, or migration-aware release.>
- **Rollback:** <How to return to a safe state, or why ordinary revert is sufficient.>

## Review plan

<!-- Include only when the issue needs multiple PRs or a non-obvious review order. -->

- **Delivery shape:** <Ordered PR stack and why one PR would be harder to review.>
- **Review order:** <The order and contract between PRs.>
- **Green guarantee:** <How each PR remains buildable and testable.>

## Blocked by

- <Issue number and title, or "None - can start immediately".>
```

Keep Goal and context, Implementation approach, Acceptance criteria, and Verification in every body; retain Status and Blocked by. If evidence is missing, state what to confirm in the approach rather than inventing components, APIs, or paths. Acceptance criteria define mandatory behavior, not files or layers; Verification names the evidence path without repeating them.

Use concise, bullet-first writing with one fact per bullet and no ornamental prose, deep nesting, or repetition. Number real sequences; use tables only for comparisons. Ground stable component, symbol, and path references in evidence and avoid volatile details. Optional Mermaid can clarify relationships, state transitions, or async branches; optional snippets can preserve meaningful confirmed contracts, configuration, before/after examples, or prototypes. Neither is required, neither needs a quota, and neither should duplicate prose or contain the entire implementation.
