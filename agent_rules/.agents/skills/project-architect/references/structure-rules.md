# Structure Rules

Rules for naming, organizing, and managing the design directory tree.

---

## Directory Naming

| Type | Convention | Examples |
|------|-----------|----------|
| Phase directories | Number prefix + kebab-case | `1-problem-definition/`, `2-research/`, `3-high-level-design/`, `4-detailed-design/` |
| Component directories | kebab-case (descriptive name) | `auth-service/`, `order-service/`, `payment-gateway/` |
| Decision area directories | kebab-case (topic name) | `communication/`, `data-strategy/`, `deployment/` |
| Special directories | Reserved names | `cross-cutting/`, `interfaces/`, `options/` |

## File Naming

| Type | Convention | Examples |
|------|-----------|----------|
| Meta files | `_` prefix + kebab-case | `_plan.md`, `_overview.md`, `_decisions.md`, `_changelog.md` |
| Content files | kebab-case | `problem-statement.md`, `goals.md`, `design.md` |
| Option files | `option-` prefix or descriptive | `option-a-event-driven.md`, `option-b-rest.md` |
| Research files | Topic name | `event-sourcing.md`, `database-per-service.md` |

---

## Phase 3 Structure Rules

### Determining Single vs Multi-Decision

| Condition | Structure | Example |
|-----------|----------|---------|
| One dominant architectural choice | Single (flat `options/` + `decision.md`) | Small service with one core design question |
| 2+ independent design decisions | Multi (decision area subdirectories) | Microservices platform with communication, data, deployment choices |

### Multi-Decision Guidelines

- Each decision area gets its own subdirectory with `options/` + `decision.md`
- `architecture-overview.md` at Phase 3 root provides the system-level view
- Decision areas should be **independent** — if two decisions are tightly coupled, merge them into one area

---

## Phase 4 Special Directories

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
- Phase 2 research may include analysis of the existing codebase alongside external research
- Phase 4 decomposition may use different units depending on the project nature:
  - Migration: wave-based (`wave-1-auth/`, `wave-2-orders/`)
  - Evolution: change-area-based (`api-layer-refactor/`, `db-migration/`)
  - The appropriate decomposition unit is determined during Phase 3

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
- Phase 1 change → may affect Phase 2, 3, 4
- Phase 2 change → may affect Phase 3, 4
- Phase 3 change → may affect Phase 4
- Phase 4 component change → may affect `interfaces/`, other dependent components

Document all affected artifacts in `_changelog.md` before starting updates.
