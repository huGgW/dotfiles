---
name: project-architect
description: >
  This skill should be used when the user needs to design a complex,
  large-scale project that requires systematic decomposition across
  multiple dimensions. Common requests include "프로젝트 설계해줘",
  "아키텍처 설계 시작하자", "시스템 설계", "프로젝트 구조 잡아줘",
  "설계 분해해줘", "새 프로젝트 설계", "대규모 시스템 설계",
  "architect this project", "design this system",
  "start project design", "system architecture design".
  It creates a mindmap-like directory tree
  of design documents with discussion-first agenda gates, non-linear
  phase navigation, recursive depth expansion, and continuous progress
  tracking.
---

# Project Architect

## Overview

A structured design skill for complex, large-scale projects that require branching exploration across multiple dimensions. It produces a **mindmap-like directory tree** of design documents, enabling systematic decomposition of complex problems with persistent progress tracking. It uses a **discussion-first, documentation-after-consensus** workflow: explore agendas and candidate directions in conversation first, then document the agreed outcome and rationale.

**Use when:**
- The project is too complex to design in a single document
- Multiple dimensions need parallel exploration (architecture, data model, API, infrastructure, etc.)
- Design decisions branch into sub-decisions recursively
- A persistent, trackable design artifact is needed across sessions

**Do not use when:**
- Simple feature addition or bug fix
- Design fits in a single document (use `document-writer` instead)
- Task is research-only without design output (use deep research instead)

## Core Concepts

### Mindmap → Directory Mapping

| Mindmap Element | File System | Convention |
|---|---|---|
| Central topic | `design/` root | Project-level container |
| Branch | Directory | Phase: number prefix, component: descriptive name |
| Node label | `_overview.md` | Required in every directory |
| Leaf | `.md` file | Detailed content |
| Meta info | `_` prefix files | `_plan.md`, `_decisions.md`, `_changelog.md` |

### Meta Files

| File | Role | When to Read |
|------|------|-------------|
| `_plan.md` | Phase tracking + current status (lightweight) | Every session start |
| `_decisions.md` | All design decisions log | When referencing prior decisions |
| `_changelog.md` | Revisit/change history + affected artifacts | When checking change history |
| `_overview.md` | Directory summary: purpose, key decisions, children | When exploring a branch |

### Discussion → Artifact Mapping

| Stage | Location | Rule |
|---|---|---|
| Open exploration | Conversation | Discuss agendas, candidate directions, tradeoffs, and user-added options before writing final artifacts |
| Agreed candidate set | `options/*.md` for Phase 3 / recursive Phase 4; relevant Phase file only for non-option agendas | Document only after the user agrees which candidates/topics/goals should be recorded |
| Final decision | `decision.md`, `_decisions.md`, or Phase artifact | Write only after explicit user consensus on the direction |
| Summary | `_overview.md` | Summarize status and links; do not use `_overview.md` as the only place where option details live |

## Phase Flow

### Overview

```
1. Problem Definition → 2. Research → 3. High-Level Design → 4. Detailed Design
```

| Phase | Purpose | Key Deliverables | Revisit When |
|---|---|---|---|
| **1. Problem Definition** | Define what and why through discussion | Agreed problem-statement, goals, constraints, principles | New requirements, scope change |
| **2. Research** | Agree what to research and then investigate | research-plan, per-topic research files, findings-summary | Insufficient info found in Phase 3/4 |
| **3. High-Level Design** | Decide direction after option discussion | architecture-overview, option files, decision per area | Direction proves infeasible |
| **4. Detailed Design** | Detail components after design discussion | Per-component designs, recursive option files/decisions | — (recursive expansion) |

See `references/phase-guide.md` for detailed per-Phase guidance.

### Non-Linear Navigation

Phases are **not strictly sequential**:

- **Phase 1, 2 are revisitable.** New findings or external feedback may require returning to redefine scope or conduct additional research.
- **Phase 3 → 4 is recursive.** Each component in Detailed Design can spawn its own discussion → option files → decision → sub-design cycle.
- **Mark all revisits** in `_plan.md` with 🔁 status and record in `_changelog.md`.

### Phase Transition Protocol

At every Phase transition (forward or backward):
1. Summarize current Phase results in its `_overview.md`
2. Update `_plan.md` with completion status
3. Present summary to user and get confirmation before proceeding

### Phase 3: Multi-Decision Structure

When multiple independent design decisions are needed, organize Phase 3 into decision-area subdirectories, each with its own `_overview.md`, `options/`, and `decision.md`. Each candidate direction must be documented as a separate file under `options/` after the candidate set is agreed. Place `architecture-overview.md` at the Phase 3 root to provide the system-level view. For simple projects with a single dominant decision, use flat `_overview.md` + `options/` + `decision.md` directly.

See `references/structure-rules.md` for detailed rules.

### Phase 4: Completion Criteria

Phase 4 uses a **soft completion** model:
1. All components from Phase 3 have at least `_overview.md` + `design.md`
2. `interfaces/` and `cross-cutting/` documented (if applicable)
3. → Present to user: "First pass complete. Which components need deeper design?"
4. → Extend recursively **only on user request**

## Working Principles

1. **Plan first, always** — Read `_plan.md` before any work. Update it at every milestone and agenda boundary, including the last consensus gate, unresolved discussion, pending candidate set, and next required user confirmation.
2. **Discussion before documentation** — For each agenda (goals, constraints, research topics, decision areas, component designs), discuss candidate directions in conversation before creating or updating final artifacts.
3. **User gates at phase and agenda boundaries** — Confirm with the user before advancing between Phases and before finalizing each agenda. Work autonomously only after the user agrees on the local direction or scope.
4. **Every directory tells its story** — Every directory must have `_overview.md` answering: what is this, what was decided, what are its children?
5. **Options before decisions** — Present 2+ options with tradeoff analysis in conversation before offering a provisional fit assessment. Do not use final-sounding labels like "recommended" or "selected" until the user explicitly decides.
6. **Option artifacts are first-class documents** — For Phase 3 and recursive Phase 4 decisions, each candidate direction must be documented as a separate file under `options/`. Do not collapse full option details into `_overview.md`, `architecture-overview.md`, `design.md`, or `decision.md`.
7. **Research as deep investigation** — Treat each research topic as a thorough, independent investigation requiring multi-source analysis and synthesis into actionable insights. Each research document must be self-sufficient (fully understandable on its own) and include verifiable references. See `references/phase-guide.md` Phase 2 for the full research protocol.
8. **Depth-aware structure** — No depth limit, but at 4+ depth, review the tree and propose compression to user if possible. See `references/structure-rules.md` for compression strategies.
9. **Documentation after consensus** — Write design documents as work progresses, but only after local consensus. Capture the discussion summary, criteria, alternatives, and rationale when documenting the agreed outcome.

## Output Directory

Default: `design/` at the project root. User may specify a different path.

```
design/
├── _plan.md
├── _decisions.md
├── _changelog.md
│
├── 1-problem-definition/
│   ├── _overview.md
│   ├── problem-statement.md
│   ├── goals.md
│   ├── constraints.md
│   ├── principles.md
│   └── as-is-analysis.md              # non-greenfield only
│
├── 2-research/
│   ├── _overview.md
│   ├── research-plan.md
│   ├── {topic}.md
│   └── findings-summary.md
│
├── 3-high-level-design/
│   ├── _overview.md
│   ├── architecture-overview.md          # required for multi-decision, optional for single-decision
│   ├── {decision-area}/
│   │   ├── _overview.md
│   │   ├── options/
│   │   │   ├── option-a-{name}.md
│   │   │   └── option-b-{name}.md
│   │   └── decision.md
│   └── ...
│
└── 4-detailed-design/
    ├── _overview.md
    ├── cross-cutting/                  # optional
    ├── interfaces/                     # optional
    ├── {component}/
    │   ├── _overview.md
    │   ├── design.md
    │   ├── {sub-decision}/
    │   │   ├── _overview.md
    │   │   ├── options/
    │   │   │   ├── option-a-{name}.md
    │   │   │   └── option-b-{name}.md
    │   │   └── decision.md
    │   └── {sub-component}/           # recursive
    └── ...
```

See `references/templates.md` for file templates and `references/structure-rules.md` for naming conventions.

## Initialization & Resume

### New Project

1. Confirm with user: project name, output directory (default `design/`), known constraints/context
2. Determine project type: **Greenfield** or **Non-greenfield** (migration/evolution)
   - Non-greenfield: include `as-is-analysis.md` in Phase 1 deliverables
3. Create only root meta files (`_plan.md`, `_decisions.md`, `_changelog.md`) after the user agrees on the output location
4. Begin Phase 1 by discussing the agenda in conversation. Do not create Phase 1 artifacts until the user agrees on problem framing, goals, constraints, scope boundaries, and principles

### Resume (Continuing a Previous Session)

1. Read `_plan.md` → identify current Phase and progress
2. Read current Phase's `_overview.md` → restore working context
3. Identify the last consensus gate: what is already documented as agreed, what remains unresolved, and whether any candidate set was discussed but not yet recorded in option files
4. Summarize current state to user and confirm continuation
5. If consensus is unclear or not recorded, ask the user to restate or confirm the candidate set / direction before creating or updating artifacts
6. Read additional files selectively as needed

### External Feedback (Post-Meeting/Review)

When the user returns with feedback from team reviews or stakeholder meetings:

1. **Collect**: Structure the feedback items
2. **Analyze impact**: Classify each item by which Phase/artifact it affects
   - Scope/requirement changes → Phase 1 revisit
   - New information/constraints → Phase 1 or 2 revisit
   - Direction/decision changes → Phase 3 revisit
   - Component-level feedback → Phase 4 modification
3. **Propose changes**: Present affected artifacts + modification plan to user for confirmation
4. **Restart local discussion cycles when needed**: If feedback introduces, removes, or changes alternatives, reopen the relevant discussion → option files → explicit decision cycle. Add new alternatives as the next `option-{letter}-*.md` file before changing `decision.md` or `design.md`
5. **Execute**: Record in `_changelog.md` with feedback source, mark affected documents with `⚠️ update needed`, revisit relevant Phases (🔁), remove markers after update
6. **Check cascade**: Verify whether changes propagate to downstream Phases

## Additional Resources

- **`references/phase-guide.md`** — Detailed per-Phase guidance: purpose, key questions, activities, deliverables, completion criteria, revisit conditions
- **`references/templates.md`** — File templates for all design artifacts (`_plan.md`, `_overview.md`, `_decisions.md`, `_changelog.md`, `principles.md`, `decision.md`, etc.)
- **`references/structure-rules.md`** — Directory/file naming conventions, Phase 3 multi-decision rules, special directories (`cross-cutting/`, `interfaces/`), depth management, non-greenfield guidance, invalidation tracking
