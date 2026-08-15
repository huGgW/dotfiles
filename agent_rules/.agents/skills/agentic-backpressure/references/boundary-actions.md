# Boundary Actions

Boundary Actions are optional, ordered operations at two controlled lifecycle
boundaries. They integrate a run with external systems without turning the
backpressure protocol into a general hook or callback framework.

## Timing

- `before_work`: after Contract and any required Plan Gate pass, before the first
  implementation worker. Use this for operations such as recording the reviewed
  plan in an exact Linear issue.
- `after_final`: after Final Correctness passes. Use this for commit, push, exact
  PR updates, or another explicitly authorized publication operation.

There is no pre-contract action. Contract activation supplies the run ID, plan,
state, authorization, budget, stop point, and evidence identity needed to execute
safely. There is no generic `on_failure` action in the minimal protocol.

## Manifest

Declare actions in `BACKPRESSURE.md` before execution. Keep mutable status and
results in Current State, outside the manifest.

| Field | Meaning |
|---|---|
| ID | Stable run-local ID such as `PRE-1` or `POST-2` |
| Timing | `before_work` or `after_final` |
| Required | Whether non-pass blocks the next eligible phase or action |
| Owner | Specialized skill, tool, or fresh specialist that performs one action |
| Exact target | Issue, document, worktree, branch, remote/refspec, PR, or resource |
| Operation | Exact mutation or desired-state operation |
| Payload reference | Contract anchor, content digest, or exact fields and values |
| Prerequisites | Gate, prior action IDs, and publication items that must pass |
| Authorized | `true`, `false`, or `unresolved` for the exact operation |
| Authorization source | Current user instruction or approved authority |

An action identity includes every manifest field plus the active run ID,
applicable specification hashes, current `state_id`, and payload digest or
reference. A changed identity makes the prior result inapplicable to the new
action. Do not add a separate action hash unless an implementation needs one for
stable storage; the declared identity fields are sufficient policy.

## Sequencing

1. Validate unique action IDs and require an action-ID `stop_after` to name one
   reachable manifest entry. A phase stop excludes actions after that phase; an
   action-ID stop executes through that action and then hands off.
2. Confirm all declared prerequisites are current and `PASS`.
3. Recheck exact target, operation, payload, and authorization immediately before
   execution. Authorization is permission, not an obligation or phase override.
4. Invoke the declared owner for one action. A delegated specialist starts fresh
   unless the unchanged unfinished-action resume exception applies.
5. Read the resulting state from the authoritative source.
6. Record result and evidence separately from the manifest, then advance only
   when failure policy permits it.

Examples:

- `stop_after=plan` runs no `before_work` action.
- `stop_after=PRE-1` executes `PRE-1`, records and reads back the plan, then stops
  before implementation.
- `stop_after=POST-1` may commit but does not execute a later push action.

## Failure Behavior

| Condition | Result |
|---|---|
| Required `before_work` action is non-pass | Block implementation and hand off |
| Optional `before_work` action is non-pass | Continue only if no correctness prerequisite depends on it |
| Final Correctness is non-pass | Execute no `after_final` action |
| Required `after_final` action is non-pass and content is unchanged | Keep correctness `PASS`, block later actions, and hand off |
| Optional `after_final` action is non-pass and content is unchanged | Report it; continue only to independent later actions |
| Prior result belongs to another identity | Discard it as `STALE` and evaluate the current action |
| Current action cannot establish its declared identity | Return `STALE` and hand off or refresh current state |
| Outcome is unknown or partially successful | Read back before deciding whether any retry is safe |

Do not use a post-action as a `finally` block that masks the main blocker. A
successful optional action cannot convert blocked correctness into `PASS`.

## Read-Back And Retry

The action response is not enough to establish success. Read the exact target
from its authoritative source and compare the observed state with the declared
operation and payload.

When a request times out or partially succeeds:

1. Treat the outcome as unknown, not as complete failure.
2. Read the target before retrying.
3. Preserve successful sub-operations and do not repeat them.
4. Retry only an operation confirmed incomplete, idempotent or protected by a
   stable idempotency key, with current prerequisites still `PASS`, still
   authorized, within `stop_after`, and within budget.
5. Read back again after the retry.
6. If read-back is unavailable or the operation is non-idempotent, keep the
   action non-pass, preserve reported successes as tool-reported-only, and do not
   repeat them. Hand off instead of guessing.

Allow at most two execution attempts per action, including the first. A delegated
attempt also consumes a child call. Record each attempt and observed partial
result; never broaden the target or operation to recover from a failure.

## Candidate Mutation

Boundary Actions must not silently change candidate content. Recompute
`state_id` after every action that could touch the repository.

- Classify every changed path. Reclassify lockfiles, changelogs, and generated
  release artifacts as publication repair and every other candidate change as a
  work slice. A mixed change follows both routes; publication files never hide
  non-publication work. Invalidate affected evidence and reopen Final Correctness
  before applying required or optional failure behavior.
- If only external state changed, repository correctness remains valid, but the
  action still needs authoritative read-back evidence.
- If a commit changes only `HEAD` and the committed tree equals the frozen
  candidate, carry content-bound evidence forward. Rerun only checks that depend
  on the commit object or post-commit environment.

## Example: Record The Plan In Linear

```text
ID: PRE-1
Timing: before_work
Required: yes
Owner: Linear workflow
Exact target: issue ENG-123 description section "Implementation plan"
Operation: replace that exact section
Payload reference: BACKPRESSURE.md#agreed-plan@<validation_spec_hash>
Prerequisites: Contract PASS, Plan PASS
Authorized: true
Authorization source: current user instruction
```

Read the issue after the update and verify the section. The Linear copy is not a
Decision Source merely because it exists. If the user grants it authority, update
Decision Sources and any affected decisions, recompute the validation hash, and
re-evaluate dependent evidence. If the agreed plan changes, the prior action
result does not prove that the current plan was recorded.

## Example: Commit Then Push

Declare commit and push as separate `after_final` actions with separate
authorization and prerequisites.

```text
POST-1: commit the frozen candidate in the exact worktree with hooks enabled
POST-2: push the resulting exact commit to origin/refs/heads/feature, non-force
```

Before `POST-1`, require Final Correctness and applicable pre-commit publication
items. After commit, compare the committed tree with the frozen candidate and run
any commit-dependent checks. Before `POST-2`, require `POST-1` success, applicable
post-commit publication items, exact push authorization, and the expected local
and remote refs. Read the remote ref after push. Commit authorization never
implies push, and push authorization never permits creating or amending a commit.
