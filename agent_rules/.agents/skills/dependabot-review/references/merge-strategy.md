# Action Phase: Waves, Comments, Verify, Rollback

Read this file after the user approves action. It holds wave orchestration,
comment-agent mechanics, verification, rollback, tool fallback, and the
practices/anti-patterns checklist.

## Prepare action plan

From Review Phase data, before launching agents:

1. Wave assignments: group ✅ PRs into waves with merge order.
   - Wave 1: independent PRs (no shared lock file conflicts).
   - Wave 2+: dependency groups (1 wave per group, ordered core → dependent).
2. Comment assignments: group all ⚠️/⛔ PRs for comment agents (2-3 PRs per
   agent) — comments are always posted regardless of merge status.
3. Pre-build comment bodies using review data plus
   `references/remediation-comment-template.md`. Bodies must be fully assembled
   before launch — agents only post, never analyze.

## Launch all agents simultaneously

Launch ALL agents in a single message with `run_in_background: true`.
Comments and merges are independent — run them simultaneously. See
`references/action-agent-prompts.md` for prompt templates.

Comment agents (1 per 2-3 ⚠️/⛔ PRs):

- Receive PR numbers + pre-built comment bodies (complete `gh pr comment`
  commands). Execute and report success/failure. No analysis or template
  filling — purely mechanical posting.
- Total agents: ceil(non_merge_PRs / 3).

Wave 1 merge agent (independent PRs):

- Receives list of independent ✅ PRs.
- Strategy: attempt parallel merge → on conflict: batch rebase → wait 90s →
  retry (max 3 rounds). Self-contained retry loop, no main-agent involvement.

Wave 2+ merge agents (1 per dependency group):

- Each receives the ordered PR list (core → dependent).
- Subsumed PRs: only the subsuming PR is in the merge list. After merging it,
  verify subsumed PRs auto-closed; if not, close them with a comment noting
  the subsuming PR number.
- Strategy per PR: merge current PR; check/close subsumed PRs; request
  `@dependabot rebase` for ALL remaining PRs in the group; wait 90s; proceed
  to next PR. Self-contained retry loop (max 3 retries per PR).

Agent count limits: comment agents ceil(non_merge_PRs / 3); merge agents 1
(independent wave) + N (groups); total cap 10 agents.

## Collect results and verify

When all agents complete, consolidate results, then:

```bash
git pull origin {branch}
```

Run language-specific verification commands (see
`references/language-tips-*.md`).

## Result report

```markdown
| Wave | PR | Package | Action | Status |
|------|-----|---------|--------|--------|
```

Include merge and comment results:

- ✅ Merged: successfully squash-merged.
- 🔄 Auto-closed: subsumed by another PR (no separate merge needed).
- 💬 Commented: remediation comment posted.
- ❌ Failed: merge or comment failed (with reason).
- ⏭️ Skipped: skipped due to persistent conflict after retries.

## Rollback strategy

- Individual PR: `git revert <commit>`.
- Group: revert in reverse order.

## GitHub interaction: gh CLI and MCP fallback

Primary tool is `gh` CLI; use GitHub MCP tools as fallback when `gh` is
unavailable or fails.

| Operation | gh CLI | GitHub MCP Fallback |
|-----------|--------|---------------------|
| List PRs | `gh pr list --label dependencies --state open --json number,title,labels --limit 50` | `search_pull_requests` (query: `label:dependencies is:open repo:{owner}/{repo}`) |
| View PR | `gh pr view {N} --json title,body,state,mergeable,statusCheckRollup` | `pull_request_read` (method: `get`, pullNumber: N) |
| Check CI | `gh pr checks {N}` | `pull_request_read` (method: `get_check_runs`, pullNumber: N) |
| Merge PR | `gh pr merge {N} --squash` | `merge_pull_request` (pullNumber: N, merge_method: `squash`) |
| Comment PR | `gh pr comment {N} --body "..."` | `add_issue_comment` (issue_number: N, body: "...") |

When using MCP tools, extract `owner`/`repo` from the git remote URL or ask
the user.

## Best practices

1. No interruption — Review Phase runs start-to-finish without approval asks.
2. Parallel first — analyze independent PRs with parallel agents.
3. Unified agents — info gathering + impact analysis in one pass.
4. Group awareness — detect and group interdependent PRs.
5. Analyze everything — CI-failed PRs get full analysis for remediation.
6. Trust CI — CI pass/fail is the primary merge gate.
7. Incremental merge — lowest-impact PRs first to minimize conflicts.
8. Auto rebase — `@dependabot rebase` for conflicts.
9. Verify always — build/test verification after all merges.
10. Rollback ready — squash merge for individual reverts.
11. Leave a trail — remediation comments on Hold/Caution PRs.
12. Reuse analysis — build comments from gathered data; never re-analyze.
13. Parallel action — ALL action agents (merge + comment) in one message.
14. Pre-build comments — bodies ready before launch; agents only post.
15. Self-contained retry — each merge agent owns its rebase-retry loop.
16. Subsuming detection — merge only the subsuming PR.

## Anti-patterns

- Asking approval between Review Phase steps.
- Info gathering and impact analysis as separate agent rounds.
- Skipping analysis for CI-failed PRs.
- Merging without review or with failing CI.
- Merging ⚠️ Caution PRs without explicit user consent.
- Merging interdependent PRs independently.
- Proceeding to action without user approval.
- Skipping post-merge verification.
- Re-analyzing PRs when posting comments.
- Generic/vague comments without concrete investigation steps.
- Main agent blocking on merge-rebase-wait loops.
- Sequential merge-then-comment instead of parallel launch.
- Launching merge agents one at a time.
- Skipping comments on merged ⚠️ PRs (always post risk assessment).
- Classifying language/runtime version upgrades as ⚠️ (always ⛔ Hold).
- Merging subsumed PRs separately; ignoring subsuming relationships.
