---
name: git-commits
description: Guideline for creating multiple commits.
mode: subagent
---

# Git Commit Splitting and Creation Guidelines

This guideline describes the process for helping users split changes (typically `git diff` output) into logical and atomic commits. The AI should guide users through the following steps.

## 1. Understanding Changes (Based on git diff and Context)

*   **Goal**: Accurately identify and understand all changes presented by the user (primarily `git diff` output) to plan commits on a file-by-file basis.
*   **AI's Tasks**:
   *   Analyze the `git diff` provided by the user.
   *   If the user provides additional context (e.g., related issue tracker IDs, work descriptions, feature branch names), integrate this information to better understand the purpose and scope of the changes.
   *   **Work units must be identified strictly on a file basis only, and each commit should be planned to consist only of different files.** That is, one file should be included in only one commit. Even if changes are related, if they span multiple files, each file should be separated into individual commits, or related file groups should be bundled into a single commit after discussion with the user, but there should be no overlap between files.
   *   If the diff is large or complex making file-based splitting ambiguous, or if multiple files form one logical unit requiring user confirmation, ask clear questions to the user before proceeding with commit planning to ensure complete understanding. Example: "The changes in file A and file B appear to be closely related. Should we bundle these two files into one commit, or separate commits for each file?"

## 2. Planning Commit Structure (Listing Files and Messages)

*   **Goal**: Propose a structured list of commits ensuring each commit is atomic, clear, and has a well-defined purpose message.
*   **AI's Tasks**:
   *   Based on the logical units identified in step 1, propose a series of individual commits.
   *   For each proposed commit:
       *   Clearly list the specific files and related changed chunks (hunks) (or line ranges if identifiable from the diff) that should be included in this commit.
       *   Draft a clear and concise commit message. Follow standard conventions (e.g., Conventional Commits) unless project-specific guidelines (e.g., different rules, `CONTRIBUTING.md`, or user instructions) are known.
           *   **Subject line**: Use imperative mood (e.g., "Fix: null pointer exception in UserLoginService"). Should be a concise summary of the change, ideally under 50 characters.
           *   **Body (optional but recommended for complex changes)**: Explain the "what" and "why" of the change, not the "how" (which is in the code). Reference issue tracker IDs where applicable. Separate subject and body with a blank line.
   *   Present the complete list of planned commits (including files/hunks and message drafts) to the user in a clear format (e.g., numbered list) for review and feedback.

## 3. Incorporating Feedback and Revisions

*   **Goal**: Collaboratively improve the commit plan based on user feedback.
*   **AI's Tasks**:
   *   Carefully review and understand the user's feedback on the proposed commit structure, file/hunk groupings, and messages.
   *   Make necessary adjustments to the plan. This may include:
       *   Regrouping changes between commits.
       *   Changing which files or hunks are included in specific commits.
       *   Modifying commit messages.
       *   Adding or removing commits from the plan.
   *   Present the revised plan to the user.
   *   Repeat this feedback and revision cycle until the user explicitly confirms satisfaction with the plan.
   *   **Important: Do not proceed with any actual `git commit` operations or automatically suggest `git commit` commands during this step.** The goal is to finalize the *plan*. Wait for explicit user instruction to proceed to the commit execution phase.

## 4. Commit Execution (Upon User Command)

*   **Goal**: Execute commits sequentially according to the approved plan with AI performing actions under user confirmation.
*   **AI's Tasks**:
   *   Only after the user explicitly commands to proceed with commits (e.g., "Okay, let's commit these" or "Proceed with the plan"):
       *   For each planned commit, one by one in the agreed order:
           *   Specify the commit to be created (e.g., "Next, creating commit for 'Refactor: optimize data processing module'").
           *   List the exact files that need to be staged for *this specific commit*. (AI typically proposes entire files as staging targets.)
           *   AI proposes executing `git add <file1> <file2>...` command through `run_terminal_cmd` to stage the listed files and waits for user approval.
           *   If the user wants to stage only specific parts (hunks) of files, AI should guide the user to execute `git add -p <file>` directly in the terminal. In this case, AI may skip proposing the `git add` command for that file.
           *   To confirm all necessary changes are staged (e.g., AI proposes executing `git status` and user confirms results), AI proposes executing `git commit -n -m "subject line" -m "body content..."` command using the planned commit message through `run_terminal_cmd` and waits for user approval. **Always use the `-n` flag to skip git hooks during commit execution.**
           *   After confirming successful commit execution (e.g., AI proposes executing `git log -1` and user confirms results), proceed to the next commit.
   *   AI proposes exact commands at each `git add` and `git commit` step and executes them through `run_terminal_cmd` under user approval.
   *   If errors occur or the user wants changes midway, return to step 3 to adjust the plan for remaining commits.

## General Principles for AI Assistance

*   **User Control**: The user is always in control. AI suggests and guides, but the user makes decisions and executes critical commands (e.g., `git commit`).
*   **Clarity and Precision**: All suggestions, file lists, and commands must be exceptionally clear and accurate to avoid errors.
*   **Atomicity**: Continuously emphasize and help users create atomic commits. Each commit should represent a single logical unit of work.
*   **Context Awareness**: If aware of project-specific commit message formats, branch naming conventions, or pre-commit hooks (e.g., from project documentation or other conventions), integrate this knowledge into guidance.
*   **Confirmed Execution**: Repository-changing operations like `git add` and `git commit` are executed only after AI proposes command execution through `run_terminal_cmd` as described in step 4, and receives explicit user approval for each command. AI does not automatically execute commit-related commands without user approval.
*   **Hook Management**: Always use the `-n` flag with `git commit` commands to skip git hooks execution. This prevents potential interruptions or failures during the automated commit process and ensures consistent behavior across different repository configurations.
