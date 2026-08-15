---
name: plan-reviewer
description: >
  Use this skill only to review, critique, validate, or stress-test an existing
  software implementation, refactoring, migration, rollout, or architecture
  plan, including a delegated pre-implementation plan review. Evaluate the plan
  against authoritative decisions, repository evidence, scope, ownership,
  public API constraints, verification, migration safety, and unresolved
  decisions. Do not use it to create or rewrite a plan, generate an architecture
  design, review code or a pull request, perform ordinary code-development
  planning, or orchestrate agentic backpressure.
---

# Plan Reviewer

## Purpose

Review an existing software plan without changing it. Produce a capability
report that states what was reviewed, what the evidence supports, which defects
were found, and what remains unverified.

This skill owns review methodology only. It does not authorize implementation
or make workflow routing decisions.

## Boundaries

### In scope

- Existing implementation, refactoring, migration, rollout, and architecture
  plans.
- Explicit requests to review, critique, validate, or stress-test such a plan.
- Delegated pre-implementation plan review when the caller supplies the exact
  subject, scope, and authoritative context.
- Read-only repository inspection needed to test the plan against current code,
  configuration, tests, migrations, and established conventions.

### Out of scope

- Creating a plan from a task, issue, specification, or design discussion.
- Rewriting, repairing, or publishing the reviewed plan.
- Designing a new architecture or selecting a product direction for the user.
- Reviewing implementation code, diffs, commits, or pull requests as the primary
  subject.
- Approving a plan on behalf of the user or authorizing implementation.
- Owning a Plan Gate or emitting orchestration verdicts such as `PASS`,
  `SEND_BACK`, `ESCALATE_HUMAN`, or `APPROVE`.
- Choosing retry limits, repair routes, child freshness, or independence policy.
- Creating or maintaining `BACKPRESSURE.md` or orchestrating
  `agentic-backpressure`.

Never claim that a review is independent merely because this skill is loaded.
Independence is a property the host or orchestrator must establish and report.

## Read-Only Rule

Do not edit, create, delete, rename, format, or otherwise mutate the plan,
repository files, tracker items, or external systems. Use read-only inspection
only. Recommended corrections describe the smallest needed plan change; they do
not apply that change.

If the request also asks for mutation, complete only the review capability
report and state that mutation is outside this skill's scope.

## Input Contract

Require the caller to identify:

- **Repository root**: the exact repository to inspect.
- **Plan subject/ref**: the exact plan artifact, message, section, immutable
  reference, or supplied plan text under review.
- **Review scope**: the plan sections, decisions, work slices, or risks included
  in this review.
- **Authoritative context**:
  - decision sources and their authority;
  - active and superseded decisions;
  - scope and non-goals;
  - ownership and public API constraints;
  - acceptance criteria.
- **Required lenses**: all mandatory review concerns for this invocation.
- **Prior findings**: stable finding IDs and dispositions, or `none`.
- **Expected subject identity**: when the caller has one, the expected path,
  revision, hash, title, or other exact identity.

Do not silently invent missing authority, scope, or identity. Ask for a missing
value only when interaction is available and it is necessary to review the
declared scope. Otherwise report `INCOMPLETE` and name the missing evidence.

## Authority Model

Build a compact authority map before judging the plan:

1. Use the authority ordering explicitly supplied by the caller or repository.
2. Treat the latest explicit active decision as controlling when the supplied
   context identifies it as replacing an earlier decision.
3. Keep active, superseded, rejected, unresolved, and merely informative material
   distinct.
4. Treat acceptance criteria as derived checks. They can clarify or test a
   source decision, but they cannot broaden, narrow, or override its meaning.
5. When sources conflict and no supplied authority rule resolves the conflict,
   record the load-bearing decision as unresolved. Do not choose one for the
   user.

## Review Workflow

### 1. Bind the subject

Identify the observed subject using the strongest available identity: immutable
revision or hash first, then exact path and version, then exact title and supplied
content boundary.

When an expected identity is supplied and does not match the observed subject,
return `SUBJECT_MISMATCH`. State both identities and the mismatch evidence. Do
not review a nearby or newer plan as though it were the requested subject.

### 2. Establish coverage

List the declared review scope and required lenses. For each lens, record one of:

- `REVIEWED`: sufficient plan and authority evidence was available.
- `PARTIAL`: some relevant material was reviewed, but named evidence is missing.
- `NOT_REVIEWED`: the lens could not be evaluated.

Coverage is about review work performed, not whether the plan is acceptable.

### 3. Inspect authoritative context and repository fit

Read the exact plan and supplied decision sources. Inspect only repository areas
needed to verify its claims and assumptions. Prefer direct evidence such as
public symbols, callers, tests, migration files, ownership boundaries, and
project guidance over generic best practices.

Do not turn review into open-ended repository research. Put evidence outside the
declared scope in residual risks unless it directly invalidates an in-scope plan
claim.

### 4. Apply the required lenses

Apply every caller-required lens. Use another core lens only when it is necessary
to verify an in-scope plan claim or binding constraint; do not broaden the
declared review scope.

#### Semantic alignment

- Preserve the meaning, terminology, sequencing constraints, and conditions of
  authoritative decisions.
- Detect paraphrases that materially broaden, narrow, or reverse source meaning.
- Check that acceptance criteria test source meaning rather than replace it.

#### Scope and non-goals

- Detect work that is forbidden, unrelated, speculative, or deferred by the
  authoritative scope.
- Check that every step contributes to an in-scope outcome.
- Report out-of-scope observations without turning them into required plan work.

#### Ownership and public API

- Check that state, behavior, migration, and operational responsibilities stay
  with their intended owners.
- Detect implicit public API changes, competing entry points, leaked internals,
  and ownership transfers not authorized by the source decisions.

#### Repository fit and simplest coherent approach

- Compare the plan with established repository structure, abstractions,
  dependencies, and test strategy.
- Prefer reuse of the existing owner and the smallest direct approach that
  satisfies all active constraints.
- Flag unnecessary layers, speculative flexibility, duplicate mechanisms, or a
  proposed dependency when a suitable established capability already exists.
- Do not recommend simplification that removes a load-bearing security,
  compatibility, migration, or operational safeguard.

#### Steps, dependencies, and work slices

- Check that steps have observable outcomes and preserve a coherent buildable or
  deployable state where required.
- Check ordering, prerequisites, dependency direction, ownership handoffs, and
  opportunities for safe parallel work.
- Detect component-layer batches that postpone integration risk instead of
  producing reviewable end-to-end slices.

#### Verification

- Map each active decision and acceptance criterion to an appropriate check or
  explicit unverified area.
- Distinguish mechanical checks from semantic review, migration rehearsal,
  operational observation, and rollback validation.
- Check that evidence can be attributed to the planned state and that success
  conditions are observable.

#### Migration, rollout, rollback, and data preservation

- Identify the owner of forward migration, rollback, compatibility windows,
  rollout decisions, monitoring, and recovery actions.
- Check ordering, reversibility assumptions, mixed-version behavior, retry or
  replay effects, and point-of-no-return conditions.
- Require an explicit data-preservation strategy when existing data can be
  transformed, re-keyed, deleted, overwritten, or made unreadable.
- Do not accept "restore from backup" as complete without ownership, tested
  procedure, recovery objective, and treatment of writes after the backup.

#### Unresolved and superseded decisions

- Identify unresolved choices that materially change the diff, ownership,
  public API, migration safety, rollout, or verification strategy.
- Do not choose a load-bearing structural interpretation for the user.
- Detect reintroduction of superseded or explicitly rejected decisions, even when
  generated acceptance criteria describe the old direction as successful.

### 5. Reconcile prior findings

Use prior finding IDs and dispositions to keep review history stable:

- Reuse the same ID when the same underlying issue remains.
- Do not recycle an old ID for a different issue.
- Treat a claimed resolution as verified only when current plan and evidence show
  the defect is removed.
- Assign new IDs monotonically after the highest supplied ID when practical.

### 6. Classify findings

Use these severities:

- `BLOCKER`: the plan cannot safely or correctly proceed as written because it
  conflicts with controlling meaning, leaves a load-bearing decision unresolved,
  risks data or compatibility loss, lacks a required owner, or cannot establish a
  critical outcome.
- `SHOULD`: a material weakness in scope, sequencing, repository fit,
  verification, operability, or maintainability that should be corrected but does
  not by itself make the declared plan incoherent.
- `NIT`: a localized clarity or precision improvement with low execution risk.

Severity describes the finding, not an orchestration route or implementation
authorization.

Each finding must include:

- stable ID;
- severity;
- exact plan location;
- repository evidence when applicable;
- issue and evidence;
- impact;
- recommended correction;
- why the finding is relevant to the declared scope.

Do not create a finding for optional detail that can safely be decided during
implementation. Put genuinely unavailable evidence under `unverified_areas`.

### 7. Set review completion

Return exactly one capability status:

- `COMPLETE`: the full declared scope and required lenses were reviewed. This can
  include any number or severity of findings. It does not authorize
  implementation or approve the plan.
- `INCOMPLETE`: missing evidence or an unresolved load-bearing decision prevented
  review of the full declared scope. Report reviewed portions and the exact gaps;
  do not choose a workflow route.
- `SUBJECT_MISMATCH`: the observed subject does not match the supplied expected
  identity. Report the mismatch and do not substitute another subject.

An observable plan defect or omitted element does not by itself make the review
incomplete when available evidence is sufficient to assess it. Use `INCOMPLETE`
when missing evidence or an unresolved load-bearing choice prevents a declared
lens from being fully applied.

## Report Format

Use this structure:

```markdown
# Plan Review Capability Report

- review_completion: <COMPLETE, INCOMPLETE, or SUBJECT_MISMATCH>
- subject_identity:
  - expected: <identity | not supplied>
  - observed: <identity>
  - basis: <path, revision, hash, title, or supplied-content boundary>
- reviewed_scope: <exact scope actually reviewed>

## Coverage

| Lens | Status | Evidence |
|---|---|---|
| <lens> | <REVIEWED, PARTIAL, or NOT_REVIEWED> | <source and repository references> |

## Findings

### PLAN-001 [<BLOCKER, SHOULD, or NIT>] <concise title>
- Plan location: <section, step, or exact reference>
- Repository evidence: <file:line, symbol, test, or not applicable>
- Issue and evidence: <what is wrong and what proves it>
- Impact: <execution, correctness, data, compatibility, or review impact>
- Recommended correction: <smallest correction, without applying it>
- Scope relevance: <connection to declared review scope>

<Use "None." when no findings exist.>

## Unverified Areas

- <missing evidence or "None.">

## Residual Risks

- <risk that remains after the declared review or "None identified.">
```

Use one allowed coverage status per row.

## Final Self-Check

Before returning the report, confirm that:

- The exact subject and scope are explicit.
- Expected and observed identities were compared when expected identity exists.
- Active sources, superseded sources, and acceptance criteria were not conflated.
- Every required lens has a coverage status.
- Every finding has stable identity, evidence, impact, correction, and scope
  relevance.
- `COMPLETE` means review coverage only and is not presented as approval.
- Missing evidence or a load-bearing unresolved decision produces `INCOMPLETE`.
- No plan, repository, or external state was mutated.
- No independence claim, gate verdict, repair route, retry policy, or
  backpressure state was invented.
