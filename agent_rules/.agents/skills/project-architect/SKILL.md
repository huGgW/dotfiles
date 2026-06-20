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
  of design documents through a five-phase workflow
  (problem → research → solution concept → high-level design → detailed design)
  with discussion-first agenda gates, non-linear phase navigation,
  recursive depth expansion, and continuous progress tracking.
---

# Project Architect

## Overview

A structured design skill for complex, large-scale projects that require branching exploration across multiple dimensions. It produces a **mindmap-like directory tree** of design documents, enabling systematic decomposition of complex problems with persistent progress tracking. It uses a **discussion-first, documentation-after-consensus** workflow: explore agendas and candidate directions in conversation first, then document the agreed outcome and rationale.

The skill organizes design work into **five phases** with progressively narrowing scope:
**problem definition → research → solution concept → high-level design → detailed design**.
Each phase has a clear purpose and produces artifacts that feed the next phase, while keeping each phase as light as the project actually needs.

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
| `_plan.md` | Current operational checkpoint: phase, active agenda, unresolved discussion, pending candidate set, and next confirmation; not a history log | Every session start |
| `_decisions.md` | All design decisions log | When referencing prior decisions |
| `_changelog.md` | Design-impacting revisit/change history with affected artifacts; compact or archive stale entries | When checking change history |
| `_overview.md` | Directory summary: purpose, key decisions, children | When exploring a branch |

### Discussion → Artifact Mapping

| Stage | Location | Rule |
|---|---|---|
| Open exploration | Conversation | Discuss agendas, candidate research topics, factual inputs, candidate directions, tradeoffs, and user-added options before writing final artifacts |
| Agreed candidate set | `options/*.md` for Phase 3, Phase 4, and recursive Phase 5; relevant Phase file only for non-option agendas | Document only after the user agrees which candidates/topics/goals should be recorded |
| Final decision | `decision.md`, `_decisions.md`, or Phase artifact | Write only after explicit user consensus on the direction |
| Summary | `_overview.md` | Summarize status and links; do not use `_overview.md` as the only place where option details live |

## Phase Flow

### Overview

```
1. Problem Definition → 2. Research → 3. Solution Concept → 4. High-Level Design → 5. Detailed Design
```

| Phase | Purpose | Key Deliverables | Revisit When |
|---|---|---|---|
| **1. Problem Definition** | Define what and why through discussion | problem-statement, goals, constraints (when applicable), as-is (non-greenfield) | New requirements, scope change |
| **2. Research** | Gather and organize information needed by later design phases; do not make design decisions | research-plan, per-topic research files, codebase-analysis when applicable, findings-summary | Insufficient info found in later phases |
| **3. Solution Concept** | Decide what we are building and how it operates at a big-picture level | concept, operating-model, principles, direction options + decision (when needed) | Big-picture direction proves wrong |
| **4. High-Level Design** | Capture the overall flow and key models for the system | architecture-overview, domain-model, system-skeleton decisions only | A skeleton-level decision proves infeasible |
| **5. Detailed Design** | Detail components to a level that can be split into work issues | Per-component designs, recursive option files/decisions | — (recursive expansion) |

See `references/phase-guide.md` for detailed per-Phase guidance.

### Phase Scope Discipline

The five phases are designed to **layer scope from broad to narrow**. Each phase should stay within its scope and push finer-grained concerns down to the next phase.

| Phase | Resolves | Defers to Next |
|---|---|---|
| 3. Solution Concept | What it is, how it operates conceptually, big direction, guiding principles | Concrete architecture and component breakdown |
| 4. High-Level Design | Overall flow, primary domain/data model, system-skeleton decisions (e.g., communication style, data strategy) | Component-internal structure, behavior, and contracts |
| 5. Detailed Design | Component responsibility, behavior, error handling, interfaces, dependencies — enough to split into work issues | Implementation-level micro-decisions (variable names, small algorithms, minor optimizations) — handled during the actual work |

**Anti-pattern to avoid**: pulling Phase 5 details into Phase 4, or pulling Phase 4 design decisions into Phase 3. When in doubt, ask: *"Does this need to be decided now, or can the next phase decide it with the current artifacts?"* Defer when possible.

### Non-Linear Navigation

Phases are **not strictly sequential**:

- **Phase 1, 2 are revisitable.** New findings or external feedback may require returning to redefine scope or conduct additional research.
- **Phase 3 → 4 → 5 is recursive at each step.** A wrong concept-level direction triggers a Phase 3 revisit; a wrong high-level skeleton triggers a Phase 4 revisit; component decomposition in Phase 5 may spawn its own discussion → option files → decision → sub-design cycle.
- **Mark active revisits** in `_plan.md` with 🔁 status while they are being worked, and record only design-impacting revisit history in `_changelog.md`.

### Phase Transition Protocol

At every Phase transition (forward or backward):
1. Summarize current Phase results in its `_overview.md`
2. Update and compact `_plan.md` with completion status, current unresolved items, and the next required confirmation
3. Record only design-impacting changes in `_changelog.md`; skip trivial wording, formatting, or typo-only edits
4. Present summary to user and get confirmation before proceeding

### Phase 3: Solution Concept Structure

Phase 3 establishes the project's identity and operating model before any structural design. It is intentionally lighter than Phase 4 — its job is to converge on **what we are building and how it conceptually works**, not to draw the architecture.

Typical artifacts:
- `concept.md` — one-paragraph definition of the system, its boundaries, and what it is (and is not)
- `operating-model.md` — how the system behaves from an outside view (key user/system scenarios, mode of operation, lifecycle)
- `principles.md` — architecture principles and guardrails that all subsequent decisions must respect
- `options/*.md` + `decision.md` — only when there are genuinely competing big-picture directions (e.g., "real-time event-driven product" vs "batch-oriented analytics product")

If the project's direction is obvious from Phase 1–2, Phase 3 can finish with just `concept.md`, `operating-model.md`, and `principles.md`. Do not manufacture options where none meaningfully exist.

### Phase 4: High-Level Design Structure

Phase 4 captures the **system-level skeleton**: the overall flow, the primary models, and the small set of skeleton-level decisions that shape the architecture. It is *not* the place to design component internals.

Required artifacts:
- `architecture-overview.md` — high-level flow diagram + component roles + key interactions
- `domain-model.md` (or `data-model.md`) — primary entities, relationships, and ownership at the system level

Optional: when multiple **system-skeleton decisions** are independent (e.g., synchronous vs asynchronous communication, monolithic vs distributed data, deployment model), organize Phase 4 into decision-area subdirectories, each with its own `_overview.md`, `options/`, and `decision.md`. For simple projects with no skeleton-level decisions to make, omit the decision-area subdirectories entirely.

**Scope guard**: Treat a question as a Phase 4 decision only if it shapes the system skeleton. Component-internal questions belong in Phase 5.

See `references/structure-rules.md` for detailed rules.

### Phase 5: Completion Criteria

Phase 5 uses a **soft completion** model anchored to a single question: *"Can a developer split this into work issues from these documents?"*

A component's detailed design is considered complete when all of the following are true:

- [ ] Component **responsibility and boundaries** are clearly stated
- [ ] **Primary data/state model** is defined (entity-level; field-level detail is not required)
- [ ] **Key behaviors and flows** are described (state transitions, main scenarios)
- [ ] **External interfaces and dependencies** are listed (APIs consumed/exposed, events, other components)
- [ ] **Error handling strategy** is specified at policy level (retry, fallback, propagation)
- [ ] **Open decisions** that block work-issue creation are flagged in `Open Decisions`

The following are **out of scope** for Phase 5 — they belong to the actual work:
- Variable/function names, exact method signatures
- Selection between equivalent small algorithms or libraries
- Pixel-level UI details, microcopy
- Micro-optimizations and implementation-time tradeoffs

Workflow:
1. All components from Phase 4 have at least `_overview.md` + `design.md` meeting the checklist
2. `interfaces/` and `cross-cutting/` documented (if applicable)
3. → Present to user: "First pass complete. Which components need deeper design?"
4. → Extend recursively **only on user request**

## Working Principles

1. **Plan first, always** — Read `_plan.md` before any work. Update it at every milestone and agenda boundary, but keep only what helps resume the current work: the last consensus gate, unresolved discussion, pending candidate set, and next required user confirmation.
2. **Keep meta files operational** — Treat `_plan.md` and `_changelog.md` as working memory, not exhaustive history. `_plan.md` should answer “where are we and what must happen next?”; `_changelog.md` should answer “what design-impacting changes might matter later?”. Remove, summarize, or archive entries once they no longer help resume, revisit, or validate the design.
3. **Discussion before documentation** — For each agenda (problem framing, research topics, solution concept, decision areas, component designs), discuss the relevant candidates in conversation before creating or updating final artifacts: research topics and information needs in Phase 2, design directions in later design phases. This applies to **all phases including Phase 1**.
4. **User gates at phase and agenda boundaries** — Confirm with the user before advancing between Phases and before finalizing each agenda. Work autonomously only after the user agrees on the local direction or scope.
5. **Every directory tells its story** — Every directory must have `_overview.md` answering: what is this, what was decided, what are its children?
6. **Options before decisions** — Present 2+ options with tradeoff analysis in conversation before offering a provisional fit assessment. Do not use final-sounding labels like "recommended" or "selected" until the user explicitly decides.
7. **Option artifacts are first-class documents** — For Phase 3, Phase 4, and recursive Phase 5 decisions, each candidate direction must be documented as a separate file under `options/`. Do not collapse full option details into `_overview.md`, `architecture-overview.md`, `design.md`, or `decision.md`.
8. **Research as decision preparation** — Treat each research topic as a thorough, independent investigation that gathers facts, codebase observations, constraints, risks, alternatives, and open questions needed by later design phases. Phase 2 must not recommend, select, or finalize a design direction; design opinions and decisions belong to Phase 3, 4, or 5 after user discussion. Each research document must be self-sufficient (fully understandable on its own) and include verifiable references. See `references/phase-guide.md` Phase 2 for the full research protocol.
9. **Defer to the next phase or to the work itself** — If a question can be answered just as well by the next phase or during actual implementation, defer it. Phase 3 should not draw the architecture; Phase 4 should not design component internals; Phase 5 should not micro-design implementation details.
10. **Depth-aware structure** — No depth limit, but at 4+ depth, review the tree and propose compression to user if possible. See `references/structure-rules.md` for compression strategies.
11. **Documentation after consensus** — Write design documents as work progresses, but only after local consensus. Capture the discussion summary, criteria, alternatives, and rationale when documenting the agreed outcome.

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
│   ├── constraints.md                 # when applicable
│   └── as-is-analysis.md              # non-greenfield only
│
├── 2-research/
│   ├── _overview.md
│   ├── research-plan.md
│   ├── codebase-analysis.md          # when an existing codebase must inform design
│   ├── {topic}.md
│   └── findings-summary.md
│
├── 3-solution-concept/
│   ├── _overview.md
│   ├── concept.md
│   ├── operating-model.md
│   ├── principles.md
│   ├── options/                       # only when competing big-picture directions exist
│   │   ├── option-a-{name}.md
│   │   └── option-b-{name}.md
│   └── decision.md                    # paired with options/
│
├── 4-high-level-design/
│   ├── _overview.md
│   ├── architecture-overview.md
│   ├── domain-model.md
│   └── {decision-area}/               # optional: skeleton-level decisions only
│       ├── _overview.md
│       ├── options/
│       │   ├── option-a-{name}.md
│       │   └── option-b-{name}.md
│       └── decision.md
│
└── 5-detailed-design/
    ├── _overview.md
    ├── cross-cutting/                 # optional
    ├── interfaces/                    # optional
    ├── {component}/
    │   ├── _overview.md
    │   ├── design.md
    │   ├── {sub-decision}/            # only when blocking work-issue split
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
4. Begin Phase 1 by discussing the agenda in conversation. Do not create Phase 1 artifacts until the user agrees on problem framing, goals, and (if relevant) constraints. Keep Phase 1 light — write only the artifacts the project actually needs.

### Resume (Continuing a Previous Session)

1. Read `_plan.md` → identify current Phase, active agenda, unresolved discussion, and next required confirmation
2. If `_plan.md` contains stale completed agenda notes or history-like detail, compact it after confirming the useful resume state
3. Read current Phase's `_overview.md` → restore working context
4. Identify the last consensus gate: what is already documented as agreed, what remains unresolved, and whether any candidate set was discussed but not yet recorded in option files
5. Summarize current state to user and confirm continuation
6. If consensus is unclear or not recorded, ask the user to restate or confirm the candidate set / direction before creating or updating artifacts
7. Read additional files selectively as needed

### External Feedback (Post-Meeting/Review)

When the user returns with feedback from team reviews or stakeholder meetings:

1. **Collect**: Structure the feedback items
2. **Analyze impact**: Classify each item by which Phase/artifact it affects
   - Scope/requirement changes → Phase 1 revisit
   - New information/constraints → Phase 1 or 2 revisit
   - Concept-level direction or principle changes → Phase 3 revisit
   - System-skeleton or model changes → Phase 4 revisit
   - Component-level feedback → Phase 5 modification
3. **Propose changes**: Present affected artifacts + modification plan to user for confirmation
4. **Restart local discussion cycles when needed**: If feedback introduces, removes, or changes alternatives, reopen the relevant discussion → option files → explicit decision cycle. Add new alternatives as the next `option-{letter}-*.md` file before changing `decision.md` or `design.md`
5. **Execute**: Record the design-impacting change in `_changelog.md` with feedback source, mark affected documents with `⚠️ update needed`, revisit relevant Phases (🔁), remove markers after update, and avoid logging trivial wording/format edits
6. **Check cascade**: Verify whether changes propagate to downstream Phases

## Additional Resources

- **`references/phase-guide.md`** — Detailed per-Phase guidance: purpose, key questions, activities, deliverables, completion criteria, revisit conditions
- **`references/templates.md`** — File templates for all design artifacts (`_plan.md`, `_overview.md`, `_decisions.md`, `_changelog.md`, `concept.md`, `operating-model.md`, `principles.md`, `decision.md`, etc.)
- **`references/structure-rules.md`** — Directory/file naming conventions, Phase 4 multi-decision rules, special directories (`cross-cutting/`, `interfaces/`), depth management, non-greenfield guidance, invalidation tracking
