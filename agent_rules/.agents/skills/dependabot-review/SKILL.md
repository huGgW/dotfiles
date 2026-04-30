---
name: dependabot-review
version: 4.0.0
description: >
  This skill should be used when the user asks to review, analyze, or merge Dependabot
  dependency update PRs. Common requests include "dependabot PR 리뷰", "의존성 업데이트 PR 정리해줘",
  "dependabot 머지", "dependency PR batch review", "dependabot PR 일괄 처리",
  "review dependabot PRs", "merge dependabot PRs", "review dependency updates",
  "batch merge dependency PRs". It orchestrates parallel agents for batch review
  with a wave-based merge strategy, supporting Go, Java/Gradle, Node.js, Python,
  Rust and other ecosystems. For Hold/Caution PRs, it posts actionable remediation
  comments directly on each PR with investigation steps.
---

# Dependabot PR Batch Review & Merge

A workflow that reviews Dependabot PRs using **parallel Agents** and merges them via a dependency-aware **Wave-based strategy**.

## Core Principles

- **No human intervention during review** — Review Phase runs end-to-end automatically
- **User approval required ONLY before action execution** — the single approval gate
- **Parallel processing** — always launch independent analyses simultaneously
- **CI-failed PRs are analyzed equally** — full analysis needed for planning next steps
- **Caution PRs are NOT auto-merged** — merge only when user explicitly includes them
- **Actionable follow-up** — post remediation comments on Hold/Caution PRs for trackability
- Language/build-system agnostic; language-specific tips live in `references/`

## Workflow Overview

```
┌─────────────────────────────────────────────────┐
│  Review Phase (automatic, no user intervention)  │
│                                                   │
│  Step 1: Collect PRs + Auto-detect language       │
│  Step 2: Classify + Group + Design agent plan     │
│  Step 3: Launch N parallel agents                 │
│          (info gathering + impact analysis)        │
│  Step 4: Consolidate → Final Summary Report       │
│                                                   │
│  → Present report, await user decision            │
└─────────────────────────────────────────────────┘
                        │
          User selects action (see below)
                        │
┌─────────────────────────────────────────────────┐
│  Action Phase (after user approval)              │
│                                                   │
│  Step 1: Prepare action plan + pre-build comments │
│  Step 2: Launch ALL agents simultaneously:        │
│          ├── Comment Agents (⚠️/⛔ PRs)           │
│          ├── Wave 1 Merge Agent (independent)     │
│          └── Wave 2+ Merge Agents (groups)        │
│  Step 3: Collect results + Verify                 │
│  Step 4: Result report                            │
└─────────────────────────────────────────────────┘
```

### User Decision Options

After the review report, present these options:

| Option | Merge ✅ | Merge ⚠️ | Post Comments ⚠️ | Post Comments ⛔ |
|--------|---------|---------|-----------------|-----------------|
| **"머지"** (default) | Yes | No | Yes | Yes |
| **"⚠️ 포함 머지"** | Yes | Yes | Yes | Yes |
| **"코멘트만"** | No | No | Yes | Yes |
| **"중단"** | No | No | No | No |

> **Default behavior**: ⚠️ Caution PRs are **NOT merged** unless the user explicitly requests it.
> Remediation comments are **always posted** on all ⚠️/⛔ PRs regardless of merge status.
> Even when ⚠️ PRs are merged, the comment serves as a record of the risk assessment and
> conditions that were evaluated before merging.

> **[CRITICAL]** Do NOT ask for user approval between steps within the Review Phase.
> Continue automatically from PR collection through final summary report.
> The ONLY approval gate is between Review Phase and Action Phase.

---

## Review Phase (Automatic)

Execute all 4 steps in a continuous flow without stopping for user input.

### Step 1: Collect & Detect

#### 1.1 Collect PR List

```bash
gh pr list --label dependencies --state open --json number,title,labels --limit 50
```

#### 1.2 Auto-detect Language/Ecosystem

Check project root for dependency files:

| File | Ecosystem | Reference |
|------|-----------|-----------|
| `go.mod` | Go | `references/language-tips-go.md` |
| `build.gradle` / `build.gradle.kts` | Java/Gradle | `references/language-tips-java.md` |
| `package.json` | Node.js | `references/language-tips-others.md` |
| `pyproject.toml` / `requirements.txt` | Python | `references/language-tips-others.md` |
| `Cargo.toml` | Rust | `references/language-tips-others.md` |

Read the matching `references/language-tips-*.md` to load:
- Core dependency list
- Search patterns and commands
- Changelog access methods
- Dependency group patterns

### Step 2: Classify & Group

#### 2.1 Classify Each PR

| Criterion | Value |
|-----------|-------|
| **Package name** | Extract from PR title |
| **Version change** | old -> new |
| **Change type** | Major / Minor / Patch |
| **Security** | Check for CVE, security keywords |
| **Core dependency** | Match against language-tips core list |

**Priority policy:**
1. **Security updates** (CVE): Handle immediately
2. **Major versions**: Careful review
3. **Minor + core dependency**: Thorough review
4. **Minor/Patch general**: Standard review

#### 2.1.1 Action Classification Criteria

Agents must classify each PR using these explicit criteria:

**⛔ Hold** — Merge blocked; requires action first:
1. CI failure
2. Confirmed breaking change that affects this project
3. **Language/runtime version upgrade required** — e.g., go directive change (Go 1.24 → 1.25),
   Java sourceCompatibility change, Node.js engines change, Python requires-python change,
   Rust MSRV change. **Always ⛔ Hold regardless of CI status** — CI may pass via setup actions
   while local dev and production environments still use the older version. This is a team-wide
   infrastructure decision.
4. Team or infrastructure decision required
5. Security vulnerability newly introduced by the update

**⚠️ Caution** — CI passes, mergeable, but elevated risk:
1. 0.x library breaking changes assessed as "not affecting project", but pre-1.0 instability warrants caution
2. Large transitive dependency changes (many deps bumped simultaneously)
3. Project uses deprecated APIs scheduled for removal in a future version
4. Multi-version jump in a single PR (e.g., 0.11 → 0.13)

**✅ Merge** — CI passes, no concerns identified

#### 2.2 Group Related PRs

Apply dependency group patterns from the loaded `references/language-tips-*.md`:
- Core package + integration/plugin packages → one group
- SDK core + config + credential + service modules → one group
- Any packages that share a common version lifecycle → one group

#### 2.2.1 Detect Subsuming PRs Within Groups

When multiple PRs exist in a dependency group, check if one PR's dependency file changes
are a **superset** of another PR's changes — this is a **subsuming relationship**.

**Definition**: PR A **subsumes** PR B when PR A's diff includes all the dependency version
changes that PR B makes, plus additional changes of its own. After merging PR A, PR B
becomes redundant (auto-closes or conflicts).

**Common patterns:**
- Integration/plugin PR bumps both the plugin AND core package, while a separate PR bumps only the core
  - e.g., `sentry-go/gin` PR bumps `sentry-go` + `sentry-go/gin`, while another PR bumps only `sentry-go`
- A "wide" PR that updates multiple packages in a group, overlapping with narrower single-package PRs

**Detection**: Agents confirm subsuming relationships by comparing dependency file diffs
during PR diff inspection (Step 3). The main agent flags potential patterns during grouping
for agents to verify.

**Impact on merge strategy:**
- Only the subsuming PR needs to be merged; subsumed PRs are skipped
- After merging the subsuming PR, subsumed PRs will auto-close or become conflicting
- This reduces actual merge count and simplifies the action plan

**Impact on reporting:**
- In the Overview Table, subsumed PRs keep their original Action classification (✅/⚠️)
  but add a Note: "subsumed by #{N}"
- In Section 3 (Dependency Groups & Merge Order), use strikethrough for subsumed PRs:
  "Merge #X → ~~#Y~~ (auto-closes, subsumed)"
- Subsumed PRs do NOT appear in the merge action plan

#### 2.3 Group Hold Propagation

If any PR within a dependency group is classified as ⛔ Hold, **propagate Hold to the entire group**.
Interdependent packages cannot be merged partially — merging only some members of a group
risks version mismatch and build failures.

The comment on dependent PRs should note:
"Held due to group dependency — core package `{pkg}` (#{N}) is blocked."

#### 2.4 Design Agent Assignment

- **Related PR groups**: 1 Agent handles all PRs in the group
- **Independent PRs**: batch 2-4 similar PRs per Agent, or 1 Agent per PR
- **Cap**: max 10 agents
- Output the assignment plan (no need to show user; proceed immediately)

### Step 3: Parallel Deep Analysis (N Agents)

Launch all N Agents **simultaneously** using the Agent tool with `run_in_background: true`.
Each agent performs **both info gathering AND impact analysis** in a single pass.

See `references/agent-prompts.md` for the unified prompt template.
See `~/.agents/skills/parallel-agents/SKILL.md` for general parallel agent orchestration patterns.

#### Each Agent performs:

**Info Gathering:**
1. PR details: `gh pr view {N} --json title,body,state,mergeable,statusCheckRollup`
2. Dependency file: verify current version
3. **PR diff inspection**: `gh pr diff {N}` — check dependency file for runtime/language version directive changes, new transitive dependencies, large version jumps (see language-tips for ecosystem-specific instructions)
4. Usage search: language-specific search for imports/usages
5. Security keyword check in PR body
6. Core dependency classification

**Impact Analysis:**
7. Changelog/Release Notes: fetch and analyze for breaking changes, deprecations, new features
8. Codebase impact: read key usage files, assess breaking change impact
9. Version compatibility: check language/runtime version vs library requirement
10. CI status: `gh pr checks {N}`
11. Risk assessment: High / Medium / Low with rationale

> **CI-failed PRs**: Analyze fully. Understanding the failure scope and cause is essential for planning remediation.

### Step 4: Final Summary Report

When all agents complete, consolidate results into the report format below.
Present the report to the user and await their decision.

---

## Review Report Format

See `references/review-report-format.md` for the full report template with 5 sections:
1. **Overview Table** — all PRs at a glance with Action column (✅/⚠️/⛔)
2. **Action Plan** — ✅ gets 1-line reason; ⚠️/⛔ get detailed inline reports
3. **Dependency Groups & Merge Order** — which PRs must merge together
4. **Key Findings** — security alerts, breaking changes, deprecations
5. **Per-PR Details (Appendix)** — detailed analysis for ✅ PRs only

---

## Action Phase (After User Approval) — Parallel Agent Orchestration

Proceed ONLY after explicit user approval.

### Overview

Launch **all action agents simultaneously** in a single message:

```
Single message with N Agent tool calls (all run_in_background: true):
│
├── Comment Agent 1: Post comments on ⚠️ PR #A, #B       ← background
├── Comment Agent 2: Post comment on ⛔ PR #C             ← background
├── Wave 1 Merge Agent: Independent PRs                   ← background
├── Wave 2 Merge Agent: Dependency Group A (ordered)      ← background
└── Wave 3 Merge Agent: Dependency Group B (ordered)      ← background
```

Comments and merges are **completely independent** — run them simultaneously.

See `references/action-agent-prompts.md` for all agent prompt templates.

### Step 1: Prepare Action Plan

From Review Phase data, prepare before launching agents:

1. **Wave assignments**: Group ✅ PRs into waves with merge order
   - Wave 1: Independent PRs (no shared lock file conflicts)
   - Wave 2+: Dependency groups (1 wave per group, ordered core → dependent)
2. **Comment assignments**: Group all ⚠️/⛔ PRs for comment agents (2-3 PRs per agent) — comments are always posted regardless of merge status
3. **Pre-build comment bodies**: Construct each comment using review data + `references/remediation-comment-template.md`
   - Comment bodies must be **fully assembled before agent launch** — agents only post, never analyze

### Step 2: Launch All Agents Simultaneously

Launch ALL agents in a **single message** using Agent tool with `run_in_background: true`.

#### Comment Agents (1 per 2-3 ⚠️/⛔ PRs)

- Each agent receives: PR numbers + **pre-built comment bodies** (complete `gh pr comment` commands)
- Each agent executes the commands and reports success/failure
- No analysis, no template filling — purely mechanical posting
- Total agents: ceil(non_merge_PRs / 3)

#### Wave 1 Merge Agent (independent PRs)

- Receives: list of independent ✅ PRs
- Strategy: attempt parallel merge → on conflict: batch rebase → wait 90s → retry (max 3 rounds)
- Self-contained retry loop — no main agent involvement needed

#### Wave 2+ Merge Agents (1 per dependency group)

- Each receives: **ordered** list of PRs within the group (core → dependent)
- **Subsumed PRs**: If the group has subsuming relationships, only the subsuming PR is in the
  merge list. After merging it, verify subsumed PRs are auto-closed; if not, close them with
  a comment noting the subsuming PR number.
- Strategy per PR:
  1. Merge current PR
  2. If subsumed PRs exist: check their state and close if still open
  3. Request `@dependabot rebase` for ALL remaining PRs in the group
  4. Wait 90s for rebases
  5. Proceed to next PR
- Self-contained retry loop (max 3 retries per individual PR)

#### Agent Count Limits

- Comment Agents: ceil(non_merge_PRs / 3)
- Merge Agents: 1 (independent wave) + N (dependency groups)
- Total cap: 10 agents

### Step 3: Collect Results & Verify

When all agents complete, consolidate results.

```bash
git pull origin {branch}
```
Then run language-specific verification commands (see `references/language-tips-*.md`)

### Step 4: Result Report

```markdown
| Wave | PR | Package | Action | Status |
|------|-----|---------|--------|--------|
```

Include both merge results and comment posting results:
- ✅ Merged: successfully squash-merged
- 🔄 Auto-closed: subsumed by another PR (no separate merge needed)
- 💬 Commented: remediation comment posted on PR
- ❌ Failed: merge or comment failed (with reason)
- ⏭️ Skipped: skipped due to persistent conflict after retries

### Rollback Strategy

- Individual PR: `git revert <commit>`
- Group: revert in reverse order

---

## GitHub Interaction: gh CLI & MCP Fallback

Primary tool is `gh` CLI. If `gh` is unavailable or fails, use **GitHub MCP** tools as fallback.

| Operation | gh CLI | GitHub MCP Fallback |
|-----------|--------|---------------------|
| List PRs | `gh pr list --label dependencies --state open --json number,title,labels --limit 50` | `search_pull_requests` (query: `label:dependencies is:open repo:{owner}/{repo}`) |
| View PR | `gh pr view {N} --json title,body,state,mergeable,statusCheckRollup` | `pull_request_read` (method: `get`, pullNumber: N) |
| Check CI | `gh pr checks {N}` | `pull_request_read` (method: `get_check_runs`, pullNumber: N) |
| Merge PR | `gh pr merge {N} --squash` | `merge_pull_request` (pullNumber: N, merge_method: `squash`) |
| Comment PR | `gh pr comment {N} --body "..."` | `add_issue_comment` (issue_number: N, body: "...") |

> When using MCP tools, `owner` and `repo` must be extracted from the git remote URL or provided by the user.

---

## Language-Specific References

- **Go**: `references/language-tips-go.md`
- **Java/Gradle**: `references/language-tips-java.md`
- **Others (Node.js, Python, Rust)**: `references/language-tips-others.md`

---

## Best Practices

1. **No interruption** — Review Phase runs start-to-finish without asking for approval
2. **Parallel first** — Always analyze independent PRs with parallel Agents
3. **Unified agents** — Each agent does both info gathering AND impact analysis in one pass
4. **Group awareness** — Automatically detect and group interdependent PRs
5. **Analyze everything** — CI-failed PRs get full analysis for remediation planning
6. **Trust CI** — Use CI pass/fail as the primary merge gate
7. **Incremental merge** — Merge lowest-impact PRs first to minimize conflicts
8. **Auto rebase** — Use `@dependabot rebase` to resolve conflicts automatically
9. **Verify always** — Run build/test verification after all merges complete
10. **Rollback ready** — Use squash merge to enable individual reverts
11. **Leave a trail** — Post remediation comments on Hold/Caution PRs for team visibility
12. **Reuse analysis** — Build comments from agent data already gathered; never re-analyze
13. **Parallel action** — Launch ALL action agents (merge + comment) in a single message
14. **Pre-build comments** — Construct comment bodies before agent launch; agents only post
15. **Self-contained retry** — Each merge agent handles its own rebase-retry loop internally
16. **Subsuming detection** — When grouping PRs, identify if one PR's changes include another's; merge only the subsuming PR

## Anti-Patterns

- Asking for user approval between Review Phase steps
- Running info gathering and impact analysis as separate agent rounds
- Skipping analysis for CI-failed PRs
- Merging without review
- Merging with failing CI
- Merging ⚠️ Caution PRs without explicit user consent
- Merging interdependent PRs independently
- Proceeding to action phase without user approval
- Skipping post-merge verification
- Re-analyzing PRs when posting comments (reuse agent results)
- Posting generic/vague comments without concrete investigation steps
- **Main agent blocking on merge-rebase-wait loops** — delegate to merge agents
- **Sequential merge then comment** — launch both in parallel since they are independent
- **Launching merge agents one at a time** — launch all waves simultaneously in a single message
- **Skipping comments on ⚠️ PRs when merging them** — always post risk assessment comments even on merged ⚠️ PRs
- **Classifying language/runtime version upgrades as ⚠️ Caution** — these are always ⛔ Hold regardless of CI status
- **Merging subsumed PRs separately** — when PR A subsumes PR B, only merge A; B auto-closes
- **Ignoring subsuming relationships during grouping** — always check if one PR's dep file diff is a superset of another's
