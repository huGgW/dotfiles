# Unified Agent Prompt Template

Each agent performs **both info gathering AND impact analysis** in a single pass.

## Template

```
You are analyzing Dependabot PR(s) for a {language} project at {repo_path}.

## Target PRs
| PR# | Package | Old Version | New Version | Type |
|-----|---------|------------|-------------|------|
{pr_rows}

## Part 1: Information Gathering

For each PR:
1. `gh pr view {N} --json title,body,state,mergeable,statusCheckRollup`
2. Check current version in {dependency_file}
3. **Inspect PR diff for dependency file changes**:
   `gh pr diff {N}` — focus on {dependency_file} changes.
   Look for: runtime/language version directive changes, new dependencies added, large version jumps in transitive dependencies.
   {pr_diff_inspection_instructions}
4. Search codebase for usage:
   {usage_search_commands}
5. Check for security keywords (CVE, security, vulnerability) in PR body

## Part 2: Impact Analysis

For each PR:
1. Fetch and analyze changelog/release notes:
   {changelog_commands}
   Identify: breaking changes, deprecated APIs, new features
2. Read key usage files found in Part 1 → assess breaking change impact
3. Check {language} version compatibility:
   {version_check_instruction}
4. Check CI status: `gh pr checks {N}`
5. Assess risk with rationale

## Output Format

For each PR, return this structure:

### PR #{N}: {package} ({old} → {new})

**Basic Info**
| Item | Value |
|------|-------|
| Type | Major / Minor / Patch |
| Security | Yes / No (CVE detail if yes) |
| Core Dependency | Yes / No |
| CI Status | ✅ Passed / ❌ Failed (which check, brief detail) |
| Usage Scope | N files |
| Key Files | (list top 5) |

**Changelog Summary**
(Key changes between old and new version. Focus on: breaking changes, deprecations, notable bug fixes, new features)

**Breaking Changes & Codebase Impact**
(List each breaking change and whether it affects this project. If not affected, explain why.)

**Compatibility**
({language} version requirement vs project version)

**Risk: Low / Medium / High**
Rationale: (1-2 sentences)

**Recommended Action: ✅ Merge / ⚠️ Caution / ⛔ Hold**
Reason: (1-2 sentences)

## Part 3: Subsuming PR Detection (for grouped PRs only)

When analyzing multiple PRs in a dependency group:
1. Compare the dependency file diffs across PRs in this group
2. Check if any PR's dependency file changes are a **superset** of another's
3. Example: PR A changes packages {X, Y} while PR B changes only {X} → PR A subsumes PR B
4. After merging the subsuming PR, the subsumed PR will auto-close or conflict (no separate merge needed)

If a subsuming relationship is found, add this to your output:

**Subsuming Relationship**
- PR #{A} subsumes PR #{B}: PR #{A} bumps {list of packages} while PR #{B} only bumps {subset}
- Merge strategy: merge #{A} only → #{B} auto-closes

Use these classification criteria:

⛔ Hold — merge blocked; requires action first:
  - CI failure
  - Confirmed breaking change that affects this project
  - Language/runtime version upgrade required (e.g., go directive Go 1.24 → 1.25,
    Java sourceCompatibility change, Node.js engines change, Python requires-python change,
    Rust MSRV change) — ALWAYS ⛔ Hold regardless of CI status. CI may pass via setup
    actions while local dev and production environments still use the older version.
  - Team or infrastructure decision required
  - Security vulnerability newly introduced by the update

⚠️ Caution — CI passes, mergeable, but elevated risk:
  - 0.x library breaking changes assessed as "not affecting project", but pre-1.0 instability warrants caution
  - Large transitive dependency changes (many deps bumped simultaneously)
  - Project uses deprecated APIs scheduled for removal in a future version
  - Multi-version jump in a single PR (e.g., 0.11 → 0.13)

✅ Merge — CI passes, no concerns identified

---
Research only. Do NOT modify any code. Respond in Korean for explanations.
```

## Template Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `{language}` | Detected ecosystem | Go, Java/Gradle, Node.js |
| `{repo_path}` | Project root path | /path/to/project |
| `{pr_rows}` | PR table rows | `\| 2319 \| aws-sdk-go-v2 \| 1.41.1 \| 1.41.3 \| Patch \|` |
| `{dependency_file}` | Dep file to check | go.mod, build.gradle, package.json |
| `{usage_search_commands}` | Language-specific search | `grep -r "github.com/{pkg}" --include="*.go" -l` |
| `{changelog_commands}` | How to fetch changelogs | `curl -s "https://raw.githubusercontent.com/..."` |
| `{version_check_instruction}` | How to verify compatibility | "Check `go` directive in go.mod" |
| `{pr_diff_inspection_instructions}` | Language-specific diff inspection tips | "Check if `go` directive changed (e.g., go 1.24→1.25)" |

## Customization Rules

1. **Related PR groups** → combine into a single agent prompt with all PRs listed
2. **Independent PRs** → can batch 2-4 similar low-risk PRs per agent, or 1 per agent for high-risk
3. **Max 10 agents** — if more PRs exist, batch more aggressively
4. **Include language-specific context** from `language-tips-*.md` directly in the prompt (agents cannot read reference files)
5. **For CI-failed PRs** — still perform full analysis; add investigation of failure cause if possible
6. **GitHub MCP fallback** — if `gh` CLI is unavailable, use GitHub MCP tools instead (see SKILL.md for mapping table). Include the MCP tool names in the agent prompt when gh is not available

## Example: Go Project Agent Prompt

```
You are analyzing Dependabot PR(s) for a Go project at /path/to/project.

## Target PRs
| PR# | Package | Old | New | Type |
|-----|---------|-----|-----|------|
| 2282 | getsentry/sentry-go | 0.42.0 | 0.43.0 | Minor |
| 2278 | getsentry/sentry-go/gin | 0.42.0 | 0.43.0 | Minor |

## Part 1: Information Gathering

For each PR:
1. `gh pr view {N} --json title,body,state,mergeable,statusCheckRollup`
2. Check current version in go.mod
3. **Inspect PR diff for go.mod changes**:
   `gh pr diff {N}` — check if the `go` directive changed (e.g., `go 1.24.0` → `go 1.25.0`).
   Also note any new transitive dependencies added or large version jumps in indirect deps.
   This is critical because `go get` can auto-bump the go directive when transitive dependencies require a higher Go version.
4. Search codebase for usage:
   - `grep -r "getsentry/sentry-go" --include="*.go" -l`
   - `grep -r "sentry\." --include="*.go" -l`
5. Check for security keywords (CVE, security, vulnerability) in PR body

## Part 2: Impact Analysis

For each PR:
1. Fetch changelog:
   `curl -s "https://raw.githubusercontent.com/getsentry/sentry-go/refs/heads/master/CHANGELOG.md" | head -200`
2. Read key usage files → assess breaking change impact
3. Check Go version: verify `go` directive in go.mod meets library minimum
4. Check CI: `gh pr checks {N}`
5. Assess risk

## Part 3: Subsuming PR Detection

These PRs are in the same dependency group. Compare their dependency file diffs:
1. Check if one PR's go.mod changes include all the version bumps of another PR
2. Example: if PR #2278 bumps both `sentry-go` and `sentry-go/gin`, while PR #2282 only bumps `sentry-go`,
   then #2278 subsumes #2282 — merging #2278 makes #2282 redundant

Report any subsuming relationship found.

## Output Format
(same as template above)

## Action Classification Criteria

⛔ Hold — merge blocked; requires action first:
  - CI failure
  - Confirmed breaking change that affects this project
  - Language/runtime version upgrade required (e.g., go directive Go 1.24 → 1.25,
    Java sourceCompatibility change, Node.js engines change, Python requires-python change,
    Rust MSRV change) — ALWAYS ⛔ Hold regardless of CI status. CI may pass via setup
    actions while local dev and production environments still use the older version.
  - Team or infrastructure decision required
  - Security vulnerability newly introduced by the update

⚠️ Caution — CI passes, mergeable, but elevated risk:
  - 0.x library breaking changes assessed as "not affecting project", but pre-1.0 instability warrants caution
  - Large transitive dependency changes (many deps bumped simultaneously)
  - Project uses deprecated APIs scheduled for removal in a future version
  - Multi-version jump in a single PR (e.g., 0.11 → 0.13)

✅ Merge — CI passes, no concerns identified

Research only. Do NOT modify any code. Respond in Korean for explanations.
```
