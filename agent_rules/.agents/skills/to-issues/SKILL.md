---
name: to-issues
description: >
  Use this skill whenever the user asks to break a plan, specification,
  conversation, epic, or parent issue into reviewable implementation issues,
  tracer-bullet slices, sub-issues, or tracker-ready work items. It designs
  outcome-centered vertical slices with explicit blockers, verification,
  review boundaries, and rollout risk, and can materialize approved issues as
  local files or publish them to a real tracker. Do not use it to implement
  issues, review a pull request, plan commits, write one unsplit bug report, or
  replace `to-tickets` when the user explicitly requests that skill.
---

# To Issues

Turn a broad outcome into issues that an implementer can deliver and a human can review with confidence.

An issue is a planning boundary, not necessarily a pull request. A good issue may land as one focused PR or as an explicitly ordered stack of independently green PRs. Commits remain the implementation narrative inside those PRs.

## Core contract

Each issue should have:

- one observable outcome
- one principal change intent or risk
- the implementation and tests needed to verify that outcome
- a safe landing state that can be merged, released, or rolled back deliberately
- only direct blocking edges that genuinely prevent work from starting

Use the transitive reduction for every blocker list. If A blocks B and B blocks C, C lists B, not both A and B. List A too only when C has an independent dependency on A that completing B does not satisfy.

Prefer a thin vertical slice through all layers required by the behavior. Do not invent schema, API, UI, or other layers that the outcome does not need.

## Process

### 1. Gather the source and destination

Use the current conversation first. If the user provides a specification, issue, document, or URL, read its full relevant content, including comments that change scope or acceptance criteria.

Determine whether the requested result is:

- a proposal only
- complete local issue files
- tracker-ready issue drafts without publication
- publication to a specific tracker, repository, project, or team

Ask a focused question only when a missing outcome, constraint, destination, or authorization would materially change the breakdown. Preparing a proposal or draft never implies permission to publish it.

Explore the codebase when implementation boundaries, established terminology, ADRs, rollout constraints, or existing tests affect the split. Avoid speculative exploration when the supplied plan already defines the relevant boundaries.

### 2. Define the parent outcome

State the overall outcome before splitting it:

- who observes the result
- what behavior or operational capability changes
- how success can be demonstrated or measured
- which constraints cannot be deferred
- what is explicitly out of scope

If the source is already an issue, preserve it as the parent. Do not close, rewrite, relabel, or otherwise modify the parent as a side effect of creating children. A native child relationship is allowed only when the approved publication scope includes it.

### 3. Choose the smallest useful split dimension

Start with the simplest complete path, then separate meaningful variations. Use the first split that creates independently valuable and verifiable outcomes.

| Situation | Preferred split |
| --- | --- |
| A broad user or operator flow | Simplest end-to-end happy path, then workflow steps or operations |
| Several rules or variants | Business rule, data variation, interface variation, or simple-versus-complex case |
| CRUD-like capability | Independently useful operations rather than technical layers |
| Deferrable quality work | A later issue only when deferral is safe and explicitly accepted |
| Wide mechanical refactor | Expand, migrate in green batches, then contract |
| Irreducible uncertainty | A time-boxed spike with a decision or evidence deliverable |

Use a spike only after trying outcome-based splits. A spike must reduce a named uncertainty and end with evidence, a decision, or a discarded option; "investigate" alone is not an outcome.

Authorization, security boundaries, data integrity, privacy, and compliance needed for a usable slice are part of that slice. Do not defer them to a hardening issue. Likewise, keep behavior-specific tests with the implementation rather than creating a later testing issue.

### 4. Draft reviewable slices

Apply these rules to every proposed issue:

1. Express the outcome in one sentence from the user, operator, or system-observer perspective.
2. Keep one principal intent or risk. Split unrelated behavior, broad cleanup, generated churn, formatting, or renames when they would obscure review.
3. Include every layer required to make the outcome work and no layer included only for symmetry.
4. Make acceptance criteria observable and measurable. Include important boundaries and failure behavior, not a layer-by-layer task list.
5. Keep each landing state buildable and testable. Avoid an issue that is useful only after several broken intermediate merges.
6. Prefer safe rollback or staged rollout when behavior, data, compatibility, or operations make a direct release risky.
7. Use project vocabulary. Avoid file paths and code snippets that will go stale, except for a decision-rich prototype fragment that is clearer than prose.

Treat line count as a review warning, not a quota. Conceptual breadth, number of reviewer domains, mixed risks, generated noise, and unclear verification are stronger signals than LOC. Do not size work by an agent context window.

Prefactor only when it is necessary to make the requested slice safe or reviewable. Separate it when it has an independently explainable invariant and can land green; otherwise keep the minimal enabling change with the behavior. Do not create speculative prefactoring work.

### 5. Handle wide refactors explicitly

Do not force a repository-wide rename, shared type migration, or schema transition into fake vertical features.

1. **Expand:** add the new form beside the old while preserving compatibility.
2. **Migrate:** move callers in batches sized by blast radius, ownership, and reviewability. Each batch is blocked by expand and remains green because the old form still works.
3. **Contract:** remove the old form only after all migrations and compatibility checks complete.

If no migration batch can land green alone, state that constraint and use an integration branch only as an exception. Add a final integrate-and-verify issue and make the weaker intermediate guarantee explicit.

### 6. Apply the reviewability gate

Before presenting the breakdown, verify each issue against both INVEST and the review package:

| Gate | Question |
| --- | --- |
| Independent | Can unnecessary blockers be removed? |
| Negotiable | Does the issue describe an outcome rather than freeze incidental implementation? |
| Valuable | Is the result useful or does it deliberately retire a named risk? |
| Estimable | Is enough context present to understand the work and uncertainty? |
| Small | Can one reviewer follow the main intent and risk without unrelated changes? |
| Testable | Is there concrete verification evidence the implementer can produce? |
| Safe | Can the change land green and be released or rolled back deliberately? |
| Focused | Does it have one observable outcome and one principal intent or risk? |

Split or rewrite an issue that fails the gate. Merge slices that are technically separate but have no useful or safe independent outcome.

### 7. Present the proposal and get approval

Present a numbered proposal before materializing full issue bodies. For each issue show:

- **Title:** a short outcome-oriented title
- **Outcome:** the independently observable result
- **Principal intent / risk:** the main behavior, data, compatibility, security, or operational concern
- **Blocked by:** only genuine prerequisites, or "None"
- **Verification:** the evidence that will demonstrate completion
- **Delivery shape:** one focused PR or an ordered PR stack, with the reason when stacked

Ask whether:

- the granularity is too coarse or too fine
- every blocking edge genuinely gates the issue
- any issues should be merged, split, or reordered
- the proposed PR boundaries match how reviewers will inspect the change

Iterate until the user approves the breakdown. Approval to materialize local files or drafts is not approval to publish to an external tracker.

### 8. Materialize only the requested format

Load one template only when full issue bodies are needed:

- For local Markdown files, read `references/templates/local-issue.md` immediately before writing them.
- For tracker-ready drafts or real tracker publication, read `references/templates/tracker-issue.md` immediately before creating the bodies.
- Do not read both templates unless the user requests both output formats.
- Do not load either template for a proposal-only request.

For local output, write one file per issue under `.scratch/<feature-slug>/issues/<NN>-<slug>.md`, numbered in dependency order with blockers first.

For a real tracker, verify the exact workspace, repository, team, project, parent, labels, issue count, and titles before writing. Use native sub-issue and blocking relationships when available; otherwise record explicit references in the issue body. Apply only configured or user-approved labels. Do not invent a triage vocabulary.

### 9. Publish and verify external writes

Before publication, show the exact target and issue manifest and obtain explicit authorization for that write. Publish blockers first so later issues can reference real identifiers.

After publication:

1. Read every created issue back from the authoritative tracker.
2. Verify its title, body, parent or child relationship, blockers, labels, and project or team.
3. Confirm that the parent and unrelated issues were not otherwise modified.
4. Report created identifiers and the current dependency frontier.

The frontier is the set of issues whose blockers are all complete. These are the issues that can start now.

If creation fails or times out, inspect the tracker before retrying. Distinguish complete failure, partial success, and unknown outcome; never blindly repeat non-idempotent issue creation.

Stop after producing or publishing the approved issues. Do not begin implementation, close the parent, resolve related threads, or modify adjacent tracker objects unless the user separately asks.
