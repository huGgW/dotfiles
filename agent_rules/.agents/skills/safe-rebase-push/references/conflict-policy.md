# Rebase Conflict Policy

## Default: Stop for Semantic Decisions

A rebase conflict is not automatically safe because it is textually small. Resolve
it automatically only when equivalence is mechanically provable, such as:

- both sides select byte-identical blobs;
- one side is an exact duplicate of already-applied content; or
- deterministic generated output can be reproduced from unchanged, non-conflicting
  sources and verified against the generator's expected output.

Record the proof and validate the resulting tree. If the proof depends on intent,
runtime behavior, an undocumented generator, or a judgment about product behavior,
it is not mechanical; ask the user.

## Always Treat These as Semantic Unless Proven Otherwise

Ask before resolving collisions involving business logic, public APIs, configuration,
permissions, authentication, retries, transactions, data migrations, dependency
lockfiles, generated artifacts with changed inputs, tests that establish behavior,
or analogous files where ordering, identity, deployment, or history matters.

Similarly, detect semantic identity, order, and history conflicts in other migration
or deployment tools conservatively. Do not invent tool-specific rules that have not
been established for that tool.

## Rebase-Specific `ours` and `theirs`

During rebase, Git replays a commit from the branch being rebased onto the target.
At a conflict, `ours` normally means the target/base side already checked out by the
rebase, while `theirs` normally means the commit currently being replayed. This is
the reverse of the intuition many users bring from an ordinary merge. Verify the
operation state and conflict stage before relying on either label.

Never apply blanket strategies (`-X ours`, `-X theirs`, or equivalent), bulk
`checkout --ours`, bulk `checkout --theirs`, or `git rebase --skip` as automatic
resolution. These can silently discard the target's content or the replayed commit.
Use any of them only after the user explicitly decides it for the specific conflict
or commit and understands what will be omitted or retained.

## Asking a Useful Bounded Question

For each semantic conflict, summarize:

1. the target-side change and the replayed-commit change;
2. the concrete semantic question, including any behavior, API, ordering, or data
   consequence; and
3. bounded choices, such as keep target behavior, keep replayed behavior, combine
   the changes with a stated rule, or abort/preserve the work for later.

Do not ask an open-ended "how should this be resolved?" question without this
context. Do not continue the rebase until the decision is explicit.
