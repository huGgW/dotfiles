---
name: parallel-agents
description: >
  Use this skill before planning or acting on any task with two or more
  workstreams that can be owned and verified independently, even when the user
  never mentions agents. Load it before proposing the execution plan; do not
  defer orchestration decisions until implementation begins.
  Always invoke it for multi-area repository analysis; multi-component
  implementation, migration, or batch updates; multi-perspective review;
  independent incident hypotheses; and any request to parallelize, use multiple
  agents, split ownership, or reconcile independent findings into one result.
  It decides whether to delegate to subagents, selects foreground, background,
  or hybrid execution from the dependency graph, and governs orchestration,
  synthesis, and final verification. Do not invoke it for async or parallel
  programming explanations, parallel shell commands, one or two direct reads,
  small single-file changes, tightly coupled work, or explicit no-agent requests.
---

# Subagent Orchestration

## Purpose

Use subagents only when decomposition creates a clear quality or latency benefit. Subagents are the only delegation mechanism in this workflow; do not introduce a second coordination model. The main agent owns the goal, dependency graph, coordination, synthesis, decisions, and final verification.

Default to direct execution. Delegation is an optimization, not a requirement for every multi-step task.

## Delegation Gate

Delegate only when all of these conditions hold:

1. The user has not prohibited agents or constrained execution to the main agent.
2. The task contains at least two substantive workstreams, or one specialized blocking investigation whose isolated result materially improves the next decision.
3. Each delegated workstream has a distinct scope, clear deliverable, and independent verification method.
4. Ownership boundaries avoid shared mutable state and likely file conflicts.
5. Delegation and synthesis cost less than performing the work directly.

Meaningful parallelism is structural. It exists when two or more ready workstreams can proceed without waiting for each other's result and can return independently useful evidence.

## Main Agent Responsibility

When subagents are active, act as the orchestration owner rather than another worker.

- Do not duplicate delegated investigation, implementation, or verification.
- Do not take a separate substantive parallel workstream while subagents run.
- Perform only lightweight inspection needed to decompose work, clarify contracts, manage dependencies, resolve conflicts, synthesize results, make final decisions, and verify the integrated outcome.
- Track which workstreams are ready, running, blocked, completed, or failed.
- Keep responsibility for the user-facing answer and the correctness of the combined result.

This boundary prevents wasted work and preserves a single source of coordination.

## When Not to Use Subagents

Work directly when any of these apply:

- One or two direct reads or searches answer the question.
- The change is small, local, and confined to one file.
- A clear singular bug can be reproduced, fixed, and verified in one tight loop.
- Workstreams depend heavily on shared context or frequent back-and-forth decisions.
- Multiple writers would touch the same files or mutable state.
- The deliverable is ambiguous, unbounded, or not independently verifiable.
- The task only discusses asynchronous or parallel programming concepts.
- The request only asks to run independent shell commands or tests concurrently.
- Delegation overhead is likely to exceed its quality or latency benefit.
- The user says not to use agents, subagents, delegation, or parallel execution.

Do not manufacture extra perspectives solely to justify delegation.

## Execution Modes

Choose the mode from the dependency graph, not from task size alone.

When explaining an orchestration plan, name the selected mode explicitly as `foreground`, `background`, or `hybrid`. Words such as "parallel" and "sequential" describe scheduling but do not replace the mode decision.

### Foreground

Use foreground execution when a subagent's result blocks the next orchestration decision.

- Launch the blocking task without background execution.
- Wait for its result before assigning dependent work.
- Use the result to refine scope, select an approach, or construct the next task contract.
- Prefer foreground for a single blocking dependency; a lone background task usually provides no concurrency benefit.

```text
Investigate root cause
        |
        v
Choose fix and assign implementation
```

### Background

Use background execution when two or more ready workstreams are independent or when staggered results can advance different parts of the dependency graph.

- Launch all currently ready independent tasks in the same turn with background execution enabled.
- Keep the main agent focused on coordination rather than starting another implementation task.
- Process completion notifications as they arrive and unlock dependent workstreams.
- Do not poll, sleep, or duplicate a running task.
- Wait for every required result before synthesis and final verification.

```text
Explore API area -------+
Explore storage area ---+--> Synthesize --> Decide
Review tests -----------+
```

A single background task is justified only when other real orchestration work can proceed while it runs. Otherwise use foreground.

### Hybrid

Use a hybrid graph when some workstreams are parallel and later work depends on their results.

```text
Explore area A --+
Explore area B --+--> Synthesize constraints --> Implement X --+
Explore area C --+                         Implement Y --+--> Verify
```

Run each ready parallel wave in the background. Use foreground for a single blocking edge between waves when no other work is ready.

## Orchestration Workflow

1. **Define the outcome**: State the final deliverable and success criteria.
2. **Build the dependency graph**: Separate ready independent work from blocked work.
3. **Apply the delegation gate**: Keep direct work direct; delegate only bounded, valuable units.
4. **Assign ownership**: Give each workstream exclusive scope and avoid overlapping writes.
5. **Choose execution mode**: Foreground for a blocking result; background for independent ready work; hybrid for mixed graphs.
6. **Launch efficiently**: Start independent background tasks together. Start dependent tasks only after prerequisites complete.
7. **Advance the graph**: Record results, handle failures, and unlock the next work without duplicating active tasks.
8. **Synthesize**: Reconcile overlap, contradictions, assumptions, and confidence into one coherent result.
9. **Verify**: Run the narrowest reliable integrated checks and confirm the user's original success criteria.

## Subagent Task Contract

Every delegated prompt should include:

- The exact objective and why the result is needed.
- Owned files, component, perspective, or question.
- Explicit exclusions and work owned by other agents.
- Whether the task is research-only or may edit files.
- Required deliverables, evidence, and verification commands.
- For a blocking investigation, the recommended next orchestration decision.
- Relevant constraints, project conventions, and specialized skills to load.
- A request to report blockers, uncertainty, and changed files.

Choose the narrowest capable subagent type. Resume an existing task only when continuity is valuable; otherwise provide a fresh, self-contained contract.

## Common Patterns

### Multi-Area Analysis

Assign separate repository areas or review perspectives to background subagents. Require file and line evidence. The main agent deduplicates and prioritizes findings, resolves contradictions, and verifies material claims.

### Parallel Implementation

Use only when each subagent owns disjoint files or components with stable interfaces. Define integration constraints before launch. The main agent reviews diffs, resolves integration issues, and runs combined verification after all work completes.

### Independent Verification

Separate implementation from an independent verification workstream only when their scopes do not cause duplicate implementation. The verifier should inspect outcomes, tests, or evidence rather than redo the implementation.

### Blocking Investigation

Use one foreground subagent when a specialized investigation determines whether or how later work should proceed. Do not pre-assign downstream implementation before the result is known.

## Synthesis and Failure Handling

For each result:

1. Check that the agent stayed within scope and supplied the requested evidence.
2. Distinguish verified facts from assumptions and recommendations.
3. Resolve conflicting findings against source code, tests, or authoritative documentation.
4. Reassign only missing or failed work; do not rerun successful work without cause.
5. Inspect all edits before integration and protect unrelated user changes.
6. Verify the combined result rather than treating individual success as integration success.

If a subagent fails, determine whether the task is still needed, whether it partially changed state, and whether retrying is safe. Narrow or clarify the contract before retrying. Escalate to the user only when scope, risk, or required information materially changes.

## Anti-Patterns

- Delegating tiny tasks that the main agent could complete faster than describing them.
- Launching a single background task while the main agent performs the same kind of work.
- Assigning overlapping file ownership without a conflict plan.
- Treating sequential dependencies as parallel work.
- Creating vague roles such as "review everything" without evidence requirements.
- Returning a list of subagent outputs without synthesis.
- Trusting subagent completion as a substitute for final integrated verification.
