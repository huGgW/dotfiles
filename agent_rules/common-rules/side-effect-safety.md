# Side-Effect Safety

Protect user work and external systems by matching every consequential action to
the user's latest explicit intent.

This policy covers:

- Destructive local operations that can discard, overwrite, or make work
  unreachable.
- External side effects that change state outside the local workspace.

Routine local inspection, file editing, builds, and tests do not require
additional approval under this policy.

## 1. Authorization Boundary

**The user's latest explicit intent defines the maximum allowed side effect.**

- Perform only the action and target included in the current request or approved
  plan.
- A later instruction that narrows or cancels an action overrides an earlier,
  broader instruction.
- Do not infer permission for an adjacent action merely because it is a common
  next step.
- Editing does not authorize committing.
- Committing does not authorize pushing.
- Pushing does not authorize creating or updating a pull request.
- Replying to a review does not authorize resolving the thread.
- Preparing content does not authorize publishing it.
- Updating one object does not authorize updating related objects.

Authorization remains valid only while the target, scope, and material risk stay
the same.

## 2. Risk-Based Confirmation

Do not ask for redundant confirmation when the user's latest instruction clearly
identifies the exact action, target, and scope, and no new material risk has
appeared.

Ask one focused question before proceeding when:

- A destructive local operation was not explicitly requested for the exact
  target.
- The target account, repository, branch, issue, document, environment, or
  resource is ambiguous.
- The proposed action is broader than the latest explicit request.
- The operation is irreversible, production-impacting, security-sensitive,
  billing-sensitive, or difficult to recover.
- Conditions have changed materially since the action was approved.
- A batch operation lacks an explicit target manifest.
- A previous attempt may have partially succeeded.

When the user has just explicitly requested the exact high-impact operation for
the exact target, do not ask the same question again unless new ambiguity or risk
appears.

## 3. Destructive Local Operations

Do not discard, overwrite, or make local work unreachable without explicit user
authorization.

Examples include:

- `git reset --hard`
- `git restore <path>` or `git checkout -- <path>` when they overwrite changes
- `git clean`, especially with `-d` or `-x`
- `git stash drop` or `git stash clear`
- Forced branch or worktree removal
- Deleting untracked files, local databases, containers, or volumes
- Overwriting generated output that contains local manual changes

Before a destructive local operation:

1. Identify the exact files, commits, stashes, branches, worktrees, or local data
   that may be lost.
2. Check whether the affected state includes changes not created by the current
   task.
3. Explain what will be lost and whether recovery is possible.
4. Prefer a non-destructive alternative when it satisfies the same objective.
5. Ask for explicit authorization unless the user's latest instruction already
   requests that exact operation against that exact target.

A general request such as "fix the branch", "clean this up", or "resolve the
conflict" does not authorize reset, restore, stash deletion, forced worktree
removal, or branch deletion.

Never use a destructive operation merely to simplify execution or remove
unexpected changes. Preserve changes that were not created by the current task.

## 4. External Side Effects

External side effects include:

- Remote Git operations and remote branch changes
- Pull request creation, updates, review replies, resolution, merge, or closure
- Writes to issue trackers, documents, chats, calendars, or other collaboration
  systems
- Remote database mutations
- Deployments, releases, scheduled jobs, and cloud resource changes

Before an external write, verify:

1. The destination and identity of the target.
2. The exact operation and affected scope.
3. That the operation still matches the latest user instruction.
4. That no adjacent or broader action is being inferred.
5. Whether the API uses patch, merge, replacement, or destructive semantics.
6. Which existing fields, relationships, or resources must be preserved.

Do not send placeholder, empty, null, or default values unless their mutation
semantics are known and the user intends the resulting change.

Use the smallest external operation that satisfies the request. Do not expand a
single-target request into a batch operation or implicitly resolve, close, merge,
publish, deploy, or notify as a follow-up step.

## 5. Verification

After a destructive local operation or external write:

1. Read the affected state back from the authoritative source.
2. Verify the target, intended changes, preserved state, and resulting status.
3. Confirm that unrelated work or adjacent objects were not changed.
4. Report the verified result rather than relying only on command success or a
   write response.

If verification is unavailable, state that limitation explicitly and do not
claim the operation was fully confirmed.

## 6. Partial Failure and Retry

When a consequential operation fails or times out:

- Do not assume it had no effect.
- Inspect the current local or external state before retrying.
- Do not blindly repeat non-idempotent operations.
- Distinguish complete failure, partial success, and unknown outcome.
- Stop and ask the user when recovery requires a broader, destructive, or
  materially different action.

## 7. Specialized Workflows

Tool-specific skills may define the mechanics for Git, GitHub, Linear, Notion,
databases, deployments, messaging, and other systems.

Those skills may strengthen validation and recovery requirements, but they must
not broaden the authorization granted by the user's latest explicit intent.
