# Tracker Issue Template

Read this template only after the user approves the breakdown and requests tracker-ready drafts or authorizes publication to a real tracker.

Use the issue title separately from the body. Replace every placeholder with concrete content and omit conditional sections that do not apply.

**Title:** `<Outcome-oriented issue title>`

```markdown
## Parent

<!-- Include only when no native parent relationship is available or a textual reference is required for portability. -->

<Parent issue reference.>

## Outcome

<One independently observable user, operator, or system result.>

## Context / Why

<Why this result matters now and the minimum context needed to make sound implementation decisions.>

## Acceptance criteria

- [ ] <Observable success behavior and its important boundary.>
- [ ] <Failure, authorization, compatibility, or integrity behavior when relevant.>
- [ ] <Required verification evidence is produced.>

## Non-goals

- <Related work intentionally excluded from this issue.>

## Verification

- <Focused automated test, integration check, runtime observation, or reproducible evidence.>

## Risks and rollout

- **Principal intent / risk:** <The behavior to review or the main data, compatibility, security, or operational risk.>
- **Rollout:** <Direct, staged, flag-controlled, migration-aware, or no special rollout required.>
- **Rollback:** <How to return to a safe state, or why ordinary revert is sufficient.>

## Review plan

<!-- Include only when the issue needs multiple PRs or a non-obvious review order. -->

- **Delivery shape:** <Ordered PR stack and why one PR would be harder to review.>
- **Review order:** <The order and contract between PRs.>
- **Green guarantee:** <How each PR remains buildable and testable.>

## Blocked by

- <Issue reference, or "None - can start immediately".>
```

Keep acceptance criteria behavioral rather than a checklist of files or layers. Use project terminology and avoid volatile paths or code snippets. A short prototype fragment is acceptable only when it preserves a decision more precisely than prose.

When publishing, apply parent, blocking, label, project, and team metadata through native tracker fields when supported. Omit the `Parent` and `Blocked by` body sections when native relationships fully express them, unless a text reference is required for portability.
