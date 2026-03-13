# Review Report Format

When all review agents complete, consolidate results into this report format.
Present the report to the user and await their decision.

---

## Section 1: Overview Table

```markdown
| # | Package | Version | Type | CI | Risk | Action | Note |
|---|---------|---------|------|----|------|--------|------|
```

- **Action** column: ✅ Merge / ⚠️ Caution / ⛔ Hold
- **Note** column: brief reason for non-merge actions (CI fail, breaking change, etc.)

## Section 2: Action Plan

Group PRs by recommended action. **Detail level differs by action category:**

```markdown
#### ✅ Merge Ready (N PRs)
```

Each PR gets **1-line reason** explaining why it is safe to merge:

```markdown
- #1234 (package-name 1.0.0→1.0.1): Patch update, no API changes, CI passed
- #1235 (another-pkg 2.0.0→2.1.0): New features are additive only, deprecated funcs not used in project, CI passed
- #1236 (sdk-core 1.5.0→1.5.2): Internal modernization + dependency bump, no breaking changes, CI passed
```

> Sufficient context per PR so the user can understand **why** each is safe without consulting per-PR details.

```markdown
#### ⚠️ Merge with Caution (N PRs)
```

Each PR gets a **detailed inline report** including:

```markdown
##### PR #1234: package-name (1.0.0 → 2.0.0)
- **Concern**: [specific concern, e.g., "runtime version X.Y required but project uses X.Z"]
- **Breaking Changes**: [list each breaking change and whether it affects this project]
- **CI Status**: [pass/fail detail]
- **Codebase Impact**: [which files/features are affected and how]
- **Condition to Merge**: [what must be confirmed before merging, e.g., "Team agreement on runtime version adoption"]
- **Risk if Deferred**: [what happens if this PR is not merged soon]
```

```markdown
#### ⛔ Hold (N PRs)
```

Each PR gets a **detailed inline report** including:

```markdown
##### PR #1234: package-name (1.0.0 → 2.0.0)
- **Blocker**: [primary reason for hold, e.g., "CI failed: test_and_compile"]
- **Failure Analysis**: [root cause or investigation steps]
- **Breaking Changes**: [list known or suspected breaking changes]
- **Codebase Impact**: [scope of usage — N files, key packages affected]
- **Risk if Deferred**: [what happens if not addressed soon, e.g., "Security CVE remains unpatched" or "Low — no urgent security concern"]
- **Remediation Steps**: [concrete next actions with commands]
- **Alternative**: [if applicable, e.g., "Pin to vX.Y.Z for bug fixes without breaking changes"]
```

> The goal: **Merge Ready** items are scannable at a glance. **Caution** and **Hold** items provide all context needed for the user to make a decision or take action without needing to read agent transcripts.

## Section 3: Dependency Groups & Merge Order

```markdown
| Group | PRs | Strategy |
|-------|-----|----------|
```

- Which PRs must merge together
- Merge order within groups (core → dependent)
- **Subsuming PRs**: When one PR's dependency file changes are a superset of another's,
  only the subsuming PR needs to be merged. Use strikethrough for subsumed PRs.

Example with subsuming:
```markdown
| Sentry | #2278 → ~~#2282~~ | Merge #2278 only (subsumes #2282: bumps both sentry-go + sentry-go/gin). #2282 auto-closes after merge. |
```

> When a subsuming relationship exists, note it clearly so the user sees that the effective
> merge count is lower than the total PR count. This simplifies the decision.

## Section 4: Key Findings

Highlight only notable items:
- Security alerts (if any)
- Breaking changes that affect this project
- Breaking changes that do NOT affect this project (and why)
- Deprecated API usage to address in the future
- CI failure analysis and remediation suggestions

## Section 5: Per-PR Details (Appendix)

Include agent's detailed analysis **only for ✅ Merge Ready PRs** as a collapsible appendix.
Caution/Hold PRs already have full detail in Section 2 — do not duplicate.

For each Merge Ready PR:
- Basic info (type, security, core dep, CI, usage scope)
- Changelog summary
- Breaking changes + codebase impact assessment
- Risk rating + rationale
- Recommended action + reason

> This section serves as a reference for users who want to drill down into a specific Merge Ready PR beyond the 1-line summary in Section 2.
