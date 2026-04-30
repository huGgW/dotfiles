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
  It guides through diff analysis, commit message formatting following
  Conventional Commits v1.0.0, commit planning with user feedback, and
  sequential execution of git add/commit operations.
---

# Git Commit Creation and Splitting Guidelines

## Commit Message Format (Conventional Commits v1.0.0)

All commit messages follow the Conventional Commits format:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Quick Reference

| Type | When to use | SemVer |
|------|-------------|--------|
| feat | New feature or capability | MINOR |
| fix | Bug fix | PATCH |
| refactor | Code restructuring, no behavior change | - |
| docs | Documentation only | - |
| style | Formatting, whitespace, no logic change | - |
| perf | Performance improvement | - |
| test | Adding or correcting tests | - |
| build | Build system or dependency changes | - |
| ci | CI/CD configuration changes | - |
| chore | Maintenance tasks (no src/test change) | - |

### Key Rules

- **Type**: Lowercase noun from the table above
- **Scope** (optional): Module or component in parentheses — `fix(parser):`
- **Description**: Lowercase start, imperative mood ("add" not "added"), no trailing period
- **Breaking change**: Add `!` before colon — `feat!:` or `feat(api)!:`

### Examples

```
feat: add user authentication via OAuth2
fix(parser): handle null input in token validation
refactor: extract validation logic into shared module
docs: update API endpoint documentation for v2
feat!: redesign configuration format
```

**Multi-line example:**
```
fix(auth): prevent session fixation on login

Regenerate session ID after successful authentication
to prevent session fixation attacks.

Closes #1234
```

> See `references/conventional-commits.md` for full spec details including
> type selection decision tree, body/footer rules, and BREAKING CHANGE syntax.

---

## Workflow: Single Commit

For cases where the user wants to commit all current changes as a single commit:

1. Run `git diff --stat` and `git diff` to understand what changed
2. Determine the appropriate commit type from the Quick Reference table
3. Identify scope if changes are concentrated in a specific module
4. Draft a commit message following the Conventional Commits format above
5. Present the proposed message to the user for confirmation
6. Execute `git add` and `git commit` with user-approved message

---

## Workflow: Splitting Changes into Multiple Commits

### Phase 1: Understanding Changes

*   **Goal**: Identify and understand all changes to plan commits on a file-by-file basis.
*   **Tasks**:
    *   Analyze the `git diff` provided by the user.
    *   Integrate any additional context (issue tracker IDs, work descriptions, feature branch names).
    *   **Identify work units strictly on a file basis — each file belongs to only one commit.** Related files can be bundled into a single commit after discussion with the user, but there must be no overlap between commits.
    *   If the diff is large or file-based splitting is ambiguous, ask clear questions before proceeding. Example: "The changes in file A and file B appear to be closely related. Should we bundle these into one commit, or separate them?"

### Phase 2: Planning Commit Structure

*   **Goal**: Propose a structured list of atomic commits, each with a clear Conventional Commits message.
*   **Tasks**:
    *   For each proposed commit:
        *   List the specific files and changed hunks to include.
        *   Draft a commit message following the Conventional Commits format:
            *   **Subject**: `<type>[scope]: <description>` — imperative mood, under 50 characters preferred
            *   **Body** (optional, recommended for complex changes): Explain "what" and "why", not "how". Reference issue IDs where applicable.
    *   Present the complete plan as a numbered list for review.

### Phase 3: Incorporating Feedback

*   **Goal**: Collaboratively refine the commit plan.
*   **Tasks**:
    *   Review user feedback on groupings and messages.
    *   Adjust as needed: regroup changes, modify messages, add or remove commits.
    *   Present the revised plan and repeat until the user explicitly confirms.
    *   **Do not proceed with any `git commit` operations during this phase.** Wait for explicit user instruction.

### Phase 4: Commit Execution

*   **Goal**: Execute commits sequentially according to the approved plan.
*   **Tasks**:
    *   Only after the user explicitly commands to proceed:
        *   For each planned commit, one by one in agreed order:
            *   Announce the commit being created (e.g., "Creating commit: `refactor(db): simplify connection pooling`").
            *   Stage files with `git add <file1> <file2>...` and wait for user approval.
            *   If the user wants to stage only specific hunks, guide them to use `git add -p <file>` directly.
            *   Execute `git commit -m "subject line" -m "body content..."` with the planned message and wait for user approval.
            *   After confirming success (e.g., `git log -1`), proceed to the next commit.
    *   If errors occur or the user wants changes midway, return to Phase 3.

---

## General Principles

*   **User Control**: The user is always in control. Suggest and guide, but the user makes decisions and approves critical commands.
*   **Clarity and Precision**: All suggestions, file lists, and commands must be clear and accurate.
*   **Atomicity**: Each commit represents a single logical unit of work.
*   **Context Awareness**: If aware of project-specific commit message formats or conventions (e.g., from `CONTRIBUTING.md` or existing commit history), integrate this knowledge.
*   **Confirmed Execution**: Repository-changing operations (`git add`, `git commit`) are executed only after proposing the command and receiving explicit user approval.
*   **Hook Respect**: Do not skip git hooks (`-n`, `--no-verify`) unless the user explicitly requests it. If a pre-commit hook fails, diagnose the error, report it to the user, and suggest options: fix the issue or skip hooks if the user confirms.
