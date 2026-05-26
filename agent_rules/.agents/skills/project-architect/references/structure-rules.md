# Structure Rules

Rules for naming, organizing, and managing the design directory tree.

---

## Directory Naming

| Type | Convention | Examples |
|------|-----------|----------|
| Phase directories | Number prefix + kebab-case | `1-problem-definition/`, `2-research/`, `3-solution-concept/`, `4-high-level-design/`, `5-detailed-design/` |
| Component directories | kebab-case (descriptive name) | `auth-service/`, `order-service/`, `payment-gateway/` |
| Decision area directories | kebab-case (topic name) | `communication/`, `data-strategy/`, `deployment/` |
| Special directories | Reserved names | `cross-cutting/`, `interfaces/`, `options/` |

## File Naming

| Type | Convention | Examples |
|------|-----------|----------|
| Meta files | `_` prefix + kebab-case | `_plan.md`, `_overview.md`, `_decisions.md`, `_changelog.md` |
| Content files | kebab-case | `problem-statement.md`, `goals.md`, `concept.md`, `operating-model.md`, `architecture-overview.md`, `domain-model.md`, `design.md` |
| Option files | `option-{letter}-{short-name}.md` | `option-a-event-driven.md`, `option-b-rest.md` |
| Research files | Topic name | `event-sourcing.md`, `database-per-service.md` |

---

## Phase 3 Structure Rules

Phase 3 (Solution Concept) is intentionally lighter than the structural phases. It always contains the core artifacts and only adds an option-decision branch when there are competing big-picture directions.

### Required Structure

```
3-solution-concept/
├── _overview.md
├── concept.md
├── operating-model.md
├── principles.md
└── options/                       # only when competing big-picture directions exist
    ├── option-a-{name}.md
    └── option-b-{name}.md
└── decision.md                    # paired with options/
```

### When to Add Concept-Level Options

Add `options/` and `decision.md` to Phase 3 only when there are genuinely competing **big-picture directions** — different concepts of what the system fundamentally is or how it operates. Examples:

- Real-time streaming product vs scheduled batch product
- Single-tenant vs multi-tenant from day one
- Product (end-user-facing) vs platform (developer-facing API)
- Push-based vs pull-based interaction model

Do **not** create options for:
- Architecture-style choices (REST vs gRPC, etc.) → Phase 4
- Technology choices (Postgres vs DynamoDB, etc.) → Phase 4
- Component-internal choices → Phase 5

### Option Artifact Rules (Phase 3)

The same general rules apply as in Phase 4 / Phase 5:
- Discuss candidate directions in conversation before creating option files.
- After the user agrees on the candidate set, create exactly one file per candidate direction under `options/`.
- `_overview.md` should summarize purpose, children, and status; it may link to option files but must not replace them.
- `decision.md` should reference option files and explain the final rationale; it should not duplicate full option analysis.

---

## Phase 4 Structure Rules

### Determining Decision Areas

| Condition | Structure | Example |
|-----------|----------|---------|
| No skeleton-level decisions to make | Just `architecture-overview.md` + `domain-model.md` | Project where the concept is concrete enough that the structure follows naturally |
| One dominant skeleton-level decision | Flat `_overview.md` + `options/` + `decision.md` alongside the overview/model | Project where one structural choice dominates |
| 2+ independent skeleton-level decisions | Multi (decision area subdirectories) | Microservices platform with communication, data, deployment choices |

### Skeleton-Level Decision Test

A question belongs in Phase 4 only if **changing it later would ripple across multiple components**. Examples of skeleton-level decisions:

- Synchronous vs asynchronous communication style across services
- Centralized vs distributed data ownership
- Deployment topology (monolith vs services, regional vs global)
- Authentication / identity propagation strategy
- Event schema / contract evolution policy

If the question stays inside a single component, push it to Phase 5.

### Multi-Decision Guidelines

- Each decision area gets its own subdirectory with `_overview.md`, `options/`, and `decision.md`
- `architecture-overview.md` and `domain-model.md` at Phase 4 root are always required, regardless of whether decision-area subdirectories exist
- Decision areas should be **independent** — if two decisions are tightly coupled, merge them into one area

### Option Artifact Rules (Phase 4)

- Discuss candidate directions in conversation before creating option files.
- After the user agrees on the candidate set, create exactly one file per candidate direction under `options/`.
- Do not store full option descriptions only in `_overview.md`, `architecture-overview.md`, `domain-model.md`, or `decision.md`.
- `_overview.md` should summarize purpose, children, and status; it may link to option files but must not replace them.
- `decision.md` should reference option files and explain the final rationale; it should not duplicate full option analysis.
- If the user introduces a new option later, add the next lettered option file (for example, `option-d-workflow-engine.md`) and re-evaluate it alongside the existing options.

Required structure for a decision area:

```
{decision-area}/
├── _overview.md
├── options/
│   ├── option-a-{name}.md
│   ├── option-b-{name}.md
│   └── option-c-{name}.md
└── decision.md
```

---

## Phase 5 Special Directories

### Recursive Decision Structure

When a Phase 5 component needs a local design decision, use the same option artifact rules as Phase 4. A component-level alternative becomes a local sub-decision only when:

1. The options differ in architecture, data ownership, interface contract, operational model, scalability, security, cost, or delivery risk, **and**
2. Choosing wrongly would block or invalidate work-issue creation for this component.

If the alternatives are genuinely interchangeable from a work-planning perspective, defer the choice to the actual work — do not spawn a sub-decision tree for it.

```
{component}/
├── _overview.md
├── design.md
└── {sub-decision}/
    ├── _overview.md
    ├── options/
    │   ├── option-a-{name}.md
    │   └── option-b-{name}.md
    └── decision.md
```

Only write or update the parent `design.md` with the selected direction after the user explicitly confirms the local decision and the local `decision.md` exists. If no decision has been made, record it under `Open Decisions` in `design.md` instead of presenting a tentative direction as final. `design.md` may summarize and link to option files, but must not be the only place where substantive option details are recorded.

### `cross-cutting/`

**Purpose**: Design **policies** that span multiple components.
**When to create**: When 2+ components share a concern that doesn't belong to any single component.

Examples:
- `security.md` — authentication/authorization strategy across all services
- `observability.md` — logging, metrics, tracing standards
- `error-handling.md` — error handling patterns and standards
- `data-flow.md` — end-to-end data flow design (common in ML/pipeline systems)

### `interfaces/`

**Purpose**: Design **contracts** between components.
**When to create**: When components need explicit agreements on data exchange formats.

Examples:
- `api-contracts.md` — REST/gRPC interface specifications
- `event-schemas.md` — async event schemas and topics
- `data-formats.md` — shared data format definitions

### When NOT to create these directories

- Small projects with 2-3 components where cross-cutting concerns are obvious
- Projects where all components use the same technology stack with built-in conventions
- When the information fits naturally within individual component `design.md` files

---

## Depth Management

### Policy

- **No hard depth limit.** Design depth follows the complexity of the problem.
- **At 4+ depth**, proactively review the entire tree and propose compression if possible.
- **Compression requires user consent.** Never restructure without explicit approval.

### Compression Strategies

| Strategy | When to Apply | Example |
|----------|--------------|---------|
| **Leaf merge** | Multiple small leaf files covering closely related topics | Merge `jwt-validation.md` + `jwt-refresh.md` + `jwt-revocation.md` → `jwt-token-management.md` |
| **Directory flattening** | Intermediate directory with only 1-2 children | Remove `token-management/` if it only contains `design.md` — move content up to parent |
| **Summary consolidation** | Deep branch that can be summarized without losing critical detail | Replace 3-level deep sub-tree with a single comprehensive `design.md` that covers all sub-components |

### Compression Proposal Format

When proposing compression to the user:
1. Show the current tree structure
2. Show the proposed compressed structure
3. Explain what information would be consolidated
4. Confirm no critical detail would be lost

---

## Non-Greenfield Projects

For migration or evolution projects (non-greenfield):

- Add `as-is-analysis.md` to Phase 1 deliverables
  - Documents the current system's architecture, components, technology, and pain points
  - Serves as the baseline for understanding what exists before designing what comes next
- Phase 2 research should include current-codebase analysis when the repository is available and relevant, alongside any external research
- Phase 3 (Solution Concept) should explicitly capture how the new system relates to the old one (replacement, parallel run, gradual migration, etc.) in `concept.md` or `operating-model.md`
- Phase 5 decomposition may use different units depending on the project nature:
  - Migration: wave-based (`wave-1-auth/`, `wave-2-orders/`)
  - Evolution: change-area-based (`api-layer-refactor/`, `db-migration/`)
  - The appropriate decomposition unit is determined during Phase 4

---

## Invalidation Tracking

When a Phase is revisited and changes are made:

### Recording Changes

Add an entry to `_changelog.md` with:
- Date of change
- Which Phase was revisited
- What changed
- Why (reason/source)
- Source: `Internal discovery` or `External feedback` (with meeting/review details)
- List of affected artifacts in downstream Phases

### Marking Affected Documents

Before updating an affected document, add this marker at the top:

```markdown
> ⚠️ This document needs update due to: {change description} (see _changelog.md YYYY-MM-DD)
```

After the document has been updated, remove the marker.

### Cascade Check

After modifying a document, check whether downstream documents are affected:
- Phase 1 change → may affect Phase 2, 3, 4, 5
- Phase 2 change → may affect Phase 3, 4, 5
- Phase 3 change → may affect Phase 4, 5 (concept and principles propagate)
- Phase 4 change → may affect Phase 5
- Phase 5 component change → may affect `interfaces/`, other dependent components

Document all affected artifacts in `_changelog.md` before starting updates.
