# Planning & Design Document Template

This template defines the section structure, recurring patterns, and writing rules for planning & design documents.

## Required Section Structure

```
# [Project Name]

## 1. Problem Definition
## 2. Goals
## 3. Overall Architecture
## 4~N. Domain-specific Detailed Design (varies by project)
## N+1. Migration Strategy (if applicable)
## N+2. Confirmed Decision Catalog
## N+3. Open Items & Follow-ups
## Appendix A. Glossary (+ legacy-to-new term mapping)
## Appendix B. Reference Documents
```

## Section Details

### 1. Problem Definition

Start with a numbered summary table, then optionally drill into technical complexity.

```markdown
## 1. Problem Definition

### At a Glance
| # | Problem | Impact |
|---|---------|--------|
| **P-1** | [Problem statement] | [Who/what is affected and how] |
| **P-2** | ... | ... |

### (Optional) Technical Complexity
| Item | Detail |
|------|--------|
| [Dimension] | [Specific metrics, numbers, constraints] |

### (Optional) Deep Dive: [Topic] — [Core structural bottleneck]
> Detailed analysis with code blocks, diagrams, metrics
```

### 2. Goals

Numbered goal table followed by AS-IS vs TO-BE comparison.

```markdown
## 2. Goals

### At a Glance
| # | Goal |
|---|------|
| 1 | [Goal statement] |
| 2 | ... |

### AS-IS vs TO-BE
| Item | AS-IS | TO-BE |
|------|-------|-------|
| [Dimension] | [Current state] | [Target state] |
```

### 3. Overall Architecture

High-level diagram first, then per-component breakdown, then the single most important architectural change.

```markdown
## 3. Overall Architecture

### At a Glance
> ASCII or Mermaid diagram showing the entire flow in one view

### Component Roles
| # | Component | Target | Purpose | SoT |
|---|-----------|--------|---------|-----|

### Key Architectural Change
> State the single biggest change explicitly.
> Explain chain effects as a tree:

[Key change]
 +-- [Consequence A]: [how it resolves]
 +-- [Consequence B]: [why it becomes unnecessary]
 +-- [Consequence C]: [new behavior]

### Constraints
| # | Constraint |
|---|------------|
```

### 4~N. Domain-specific Detailed Design

Each domain section follows the same internal pattern:

```markdown
## N. [Domain Topic]

### At a Glance
> Summary table or diagram

### Key Design Decisions
| Decision | Content | Why? |
|----------|---------|------|

### (Optional) Deep Dive: [Sub-topic]
> Detailed analysis

### (Optional) Examples
> Code blocks, JSON, SQL, etc.

### (Optional) Edge Cases
| Case | Frequency | Handling |
|------|-----------|----------|
```

### N+1. Migration Strategy (if applicable)

```markdown
## N+1. Migration Strategy

### At a Glance
> Phase diagram (ASCII or Mermaid)

Phase 1: [Shadow / Parallel]
Phase 2: [Cutover]
Phase 3: [Cleanup]

### Decision Summary
| Item | Decision | Why? |
|------|----------|------|
```

### N+2. Confirmed Decision Catalog

Single table indexing ALL decisions made across the document. Also list decisions explicitly NOT made (with rationale).

```markdown
## N+2. Confirmed Decision Catalog

### All Confirmed Decisions
| # | Area | Decision Point | Decision | Rejected Alternatives |
|---|------|----------------|----------|-----------------------|

### Not Adopted (with rationale)
| # | Item | Decision | Rationale |
|---|------|----------|-----------|
```

### N+3. Open Items & Follow-ups

Separate pending items (blocked by prerequisites) from follow-up tasks (to-do).

```markdown
## N+3. Open Items & Follow-ups

### Pending Items
| Item | Pending Reason | Prerequisite | Default Direction |
|------|----------------|--------------|-------------------|

### Remaining Follow-up Tasks
| Task | Timing | Dependency |
|------|--------|------------|
```

### Appendices

```markdown
## Appendix A. Glossary

### Term Definitions
| Term | Definition | Notes |
|------|------------|-------|

### Legacy-to-New Term Mapping (if applicable)
| Legacy Code | New Term |
|-------------|----------|

## Appendix B. Reference Documents
| Document | Scope |
|----------|-------|
```

## Recurring Patterns

These patterns repeat throughout the document. Apply them consistently.

### 1. "At a Glance" Pattern
Every major section (##) opens with a summary table or diagram BEFORE any prose.
The reader should be able to skim only "At a Glance" blocks and understand the full picture.

### 2. Decision Comparison Table
When 2+ alternatives were considered, present them in a comparison table:

```markdown
| Option | Core Idea | Why Adopted/Rejected |
|--------|-----------|----------------------|
| **A. [Name]** | [1-line summary] | (cross) [Reason for rejection] |
| **B. [Name]** | [1-line summary] | (check) **Adopted** -- [Key rationale] |
```

- Use (check) for adopted, (cross) for rejected, (warning) for conditionally viable.
- Always include the reasoning, not just the decision.

### 3. AS-IS vs TO-BE Table
Use for any before/after comparison:

```markdown
| Item | AS-IS | TO-BE |
|------|-------|-------|
```

### 4. "Deep Dive" Subsection
For complex topics that need more space than the summary provides:

```markdown
### Deep Dive: [Topic Name] -- [Core Question]
```

- Place after the summary section, not instead of it.
- Always state the core question or insight upfront.

### 5. Chain Effect Tree
When a key decision cascades into other decisions:

```markdown
[Root decision]
 +-- [Effect A]: [resolution]
 +-- [Effect B]: [resolution]
 +-- [Effect C]: [resolution]
```

## Writing Rules

| Rule | Description |
|------|-------------|
| **At a Glance first** | Every major section starts with a summary table or diagram |
| **Decisions as comparison tables** | Any decision with 2+ alternatives uses the comparison table format |
| **Changes as AS-IS vs TO-BE** | Before/after content uses the comparison table |
| **Deep dive is optional** | Only complex topics get a "Deep Dive:" subsection |
| **Document what you didn't do** | Explicitly list not-adopted decisions with rationale |
| **Separate open from pending** | Pending (blocked) vs follow-up tasks (to-do) are distinct |
| **Track all decisions** | The Confirmed Decision Catalog indexes every decision in the document |
| **Use concrete numbers** | Prefer specific metrics (TPS, latency, row counts) over vague descriptions |
| **Cross-reference** | Link to research docs, prior discussions, and external references |
| **Industry validation** | When possible, cite industry examples that validate the chosen approach |
