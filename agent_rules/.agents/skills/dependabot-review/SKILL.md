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

Read the matching `references/language-tips-*.md` to load core dependency
list, search patterns, changelog access, and group patterns.

### Step 2: Classify & Group

Read `references/classification.md` and apply it: per-PR criteria and priority,
⛔/⚠️/✅ action rules (runtime version upgrades are always ⛔ Hold), group
patterns, subsuming detection, group hold propagation, and agent assignment
(related group → 1 agent; independent → batch 2-4; cap 10).

### Step 3: Parallel Deep Analysis (N Agents)

Launch all N Agents **simultaneously** using the Agent tool with `run_in_background: true`.
Each agent performs **both info gathering AND impact analysis** in a single pass.

See `references/agent-prompts.md` for the unified prompt template.

Each agent covers: PR details (`gh pr view`), dependency file version, PR diff
(`gh pr diff` for runtime directives, transitive deps, version jumps), usage
search, security keywords, core classification, changelog analysis, codebase
impact, version compatibility, CI status (`gh pr checks`), and High/Medium/Low
risk with rationale. Analyze CI-failed PRs fully.

### Step 4: Final Summary Report

When all agents complete, consolidate into the report format in
`references/review-report-format.md` (Overview Table, Action Plan, Dependency
Groups & Merge Order, Key Findings, Per-PR Appendix). Present the report and
await the user decision.

---

## Action Phase (After User Approval) — Parallel Agent Orchestration

Proceed ONLY after explicit user approval. Read `references/merge-strategy.md`
for wave assignments, comment-agent mechanics, retry loops, verification,
result report, rollback, `gh`/MCP fallback, and practices/anti-patterns; read
`references/action-agent-prompts.md` for prompt templates and
`references/remediation-comment-template.md` for comment bodies.

Summary: launch ALL action agents simultaneously in one message (comment agents
for ⚠️/⛔ with pre-built bodies, Wave 1 for independent ✅ PRs, Wave 2+ per
dependency group ordered core → dependent). Comments and merges run in
parallel. After completion, `git pull`, run language-specific verification, and
emit the Wave/PR/Action/Status result report.

---

## Language-Specific References

- **Go**: `references/language-tips-go.md`
- **Java/Gradle**: `references/language-tips-java.md`
- **Others (Node.js, Python, Rust)**: `references/language-tips-others.md`
