---
name: git-commit
description: >
  This skill should be used when the user asks to create commits, write commit
  messages, split changes into multiple commits, organize commit structure, or
  follow commit message conventions. Common requests include "커밋 해줘",
  "커밋 메시지 작성해줘", "커밋 나눠줘", "커밋 분리해줘", "변경사항 커밋으로 정리",
  "커밋 메시지 포맷", "Conventional Commits 적용", "commit these changes",
  "write commit message", "split commits", "organize commits",
  "create atomic commits", "commit message format", "conventional commit".
  It autonomously analyzes diffs, groups related changes, writes messages in
  the repo's own style, and commits without asking for confirmation.
---

# Git Commit (Autonomous)

## Autonomy Principle

- The user's commit request **is** the authorization.
  Do not present a plan and wait for approval.
  Default flow is **analyze → commit → report**.
- Do not use `question` / `wait_for_user` for routine decisions
  (message wording, single vs. split, file grouping).
  Make the best judgment and record it in the post-commit report.
- Ask the user only on true blockers where proceeding would be
  unsafe or impossible (see Blocking Cases).

### Blocking Cases (ask, do not proceed blindly)

- No changes to commit (`git status --porcelain` empty for the task scope).
- Merge conflicts or dirty merge/rebase state.
- Pre-commit hook failure.
- Suspected secrets about to be committed (`.env`, `*.pem`, `*id_rsa*`,
  API keys/tokens visible in diff).
- A destructive operation would be required first
  (`reset --hard`, `clean`, `checkout --`, forced unstage of user's staged files).

Everything else: decide autonomously.

---

## Scope: Related Changes Only

Never blindly commit the whole worktree. The default target is
**changes related to the current task**, unrelated user work stays untouched.

1. User named explicit paths/issue → those paths only.
2. Otherwise → files touched in this session/task plus files that
   clearly belong to the same logical unit.
3. Check `git status --porcelain` first:
   - Unrelated modified/untracked files stay uncommitted.
   - Never run bare `git add -A` / `git commit -a`.
     Always stage by explicit paths: `git add <path>...`.
   - Already-staged files: use them only if they belong to the task.
     Do not silently commit someone else's staged work;
     leave it and note it in the report.
4. Report `included` vs. `excluded (left in worktree)` files after committing.

---

## Workflow

### 1. Gather Context (parallel where possible)

- `git status --porcelain` — what is dirty, staged, untracked.
- `git diff --stat` + `git diff` (scoped to task paths) — what changed.
- `git log --oneline -20` — learn the repo's actual message style.
- `CONTRIBUTING.md` / existing history win over any default format.

### 2. Decide Message Style (history first)

- If the repo has a consistent style (e.g. `area - description`,
  `type(scope): subject`), follow it.
- Otherwise fall back to Conventional Commits
  (`<type>[scope]: <description>`, imperative, lowercase start,
  no trailing period, subject ≤ 72 chars).
- Explain what + why in the body for non-trivial changes, not how.
- See `references/conventional-commits.md` for the full spec
  (type decision tree, body/footer, BREAKING CHANGE syntax).

### 3. Decide Single vs. Split (heuristic, no asking)

- **Single commit** by default.
- **Split** only when all hold:
  - ≥ 2 logically independent units (e.g. `feat` logic + unrelated `docs`,
    two untouched modules, src change + independent config change), AND
  - cleanly separable by file (no file needs to be in two commits), AND
  - each unit is independently understandable.
- Never split a single file's hunks across commits unless the file
  contains two obviously independent concerns AND hunk-level staging
  is safe. Prefer one coherent commit over a risky split.
- Group by directory/module cohesion first, then by change type.

### 4. Execute

- Stage by paths: `git add <file1> <file2>...`.
- Commit directly: `git commit -m "subject" -m "body..."`.
- One commit at a time, in dependency order.
- No `--no-verify` / `-n` unless the user explicitly requested it.

### 5. Verify and Report (no approval gate)

- Verify with `git log -1 --stat` and `git status --porcelain`.
- Report concisely:
  - commit hash + subject per commit,
  - included files,
  - excluded files left in the worktree (and why),
  - hook/test outcome if relevant.
- On hook failure: stop, show the error, suggest fix vs. retry.
  Do not auto-skip hooks.

---

## Never Do

- `push`, `rebase`, `reset`, `clean`, `checkout --`, `commit --amend`
  unless the user explicitly requested that exact operation.
- Commit secrets, generated binaries, or local-only config.
- Co-mingle unrelated work to "save time".
- Invent issue numbers or `Closes #` footers without evidence.
