# Classification, Grouping, and Subsuming PRs

Read this file during Review Phase Step 2. It holds the full classification
rules, grouping patterns, subsuming detection, and hold propagation.

## Classify each PR

| Criterion          | Value                                |
| ------------------ | ------------------------------------ |
| Package name       | Extract from PR title                |
| Version change     | old -> new                           |
| Change type        | Major / Minor / Patch                |
| Security           | Check for CVE, security keywords     |
| Core dependency    | Match against language-tips core list |

Priority policy:

1. Security updates (CVE): handle immediately.
2. Major versions: careful review.
3. Minor + core dependency: thorough review.
4. Minor/Patch general: standard review.

## Action classification criteria

Agents must classify each PR using these explicit criteria.

**⛔ Hold** — merge blocked; requires action first:

1. CI failure.
2. Confirmed breaking change that affects this project.
3. Language/runtime version upgrade required — e.g. go directive change
   (Go 1.24 → 1.25), Java sourceCompatibility change, Node.js engines change,
   Python requires-python change, Rust MSRV change. Always ⛔ Hold regardless
   of CI status — CI may pass via setup actions while local dev and production
   still use the older version. This is a team-wide infrastructure decision.
4. Team or infrastructure decision required.
5. Security vulnerability newly introduced by the update.

**⚠️ Caution** — CI passes, mergeable, but elevated risk:

1. 0.x library breaking changes assessed as "not affecting project", but
   pre-1.0 instability warrants caution.
2. Large transitive dependency changes (many deps bumped simultaneously).
3. Project uses deprecated APIs scheduled for removal in a future version.
4. Multi-version jump in a single PR (e.g. 0.11 → 0.13).

**✅ Merge** — CI passes, no concerns identified.

## Group related PRs

Apply dependency group patterns from the loaded
`references/language-tips-*.md`:

- Core package + integration/plugin packages → one group.
- SDK core + config + credential + service modules → one group.
- Any packages sharing a common version lifecycle → one group.

## Detect subsuming PRs within groups

When multiple PRs exist in a group, check whether one PR's dependency file
changes are a superset of another's — a subsuming relationship.

Definition: PR A subsumes PR B when A's diff includes all dependency version
changes B makes, plus additional changes. After merging A, B becomes redundant
(auto-closes or conflicts).

Common patterns:

- Integration/plugin PR bumps both plugin AND core, while a separate PR bumps
  only the core (e.g. `sentry-go/gin` bumps `sentry-go` + `sentry-go/gin`
  while another PR bumps only `sentry-go`).
- A "wide" PR updating multiple packages in a group, overlapping narrower
  single-package PRs.

Detection: agents confirm subsuming relationships by comparing dependency file
diffs during PR diff inspection (Review Step 3). The main agent flags potential
patterns during grouping for agents to verify.

Impact on merge strategy:

- Only the subsuming PR is merged; subsumed PRs are skipped.
- After merging the subsuming PR, subsumed PRs auto-close or conflict.
- This reduces merge count and simplifies the action plan.

Impact on reporting:

- Overview Table: subsumed PRs keep their Action (✅/⚠️) plus
  Note "subsumed by #{N}".
- Section 3 (Dependency Groups & Merge Order): strikethrough subsumed PRs,
  e.g. "Merge #X → ~~#Y~~ (auto-closes, subsumed)".
- Subsumed PRs do NOT appear in the merge action plan.

## Group hold propagation

If any PR in a dependency group is ⛔ Hold, propagate Hold to the entire group.
Interdependent packages cannot merge partially — partial merges risk version
mismatch and build failures.

Dependent-PR comment note:
"Held due to group dependency — core package `{pkg}` (#{N}) is blocked."

## Design agent assignment

- Related PR groups: 1 agent handles all PRs in the group.
- Independent PRs: batch 2-4 similar PRs per agent, or 1 agent per PR.
- Cap: max 10 agents.
- Output the assignment plan (no need to show user; proceed immediately).
