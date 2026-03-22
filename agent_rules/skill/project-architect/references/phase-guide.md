# Phase Guide

Detailed guidance for each Phase of the design process.
Consult this when entering a new Phase or when revisiting a completed one.

---

## Phase 1: Problem Definition

### Purpose
Define **what** problem to solve and **why** it matters. Establish the foundation
that all subsequent Phases build upon.

### Key Questions
- What specific problem are we solving?
- Who is affected and how?
- What does success look like? (measurable criteria)
- What are the scope boundaries? (in/out of scope)
- What external constraints exist? (budget, timeline, technology)
- What architecture principles should guide all decisions?
- [Non-greenfield] What does the current system look like? What are its pain points?

### Activities
1. Draft `problem-statement.md` — articulate the core problem and its impact
2. Define `goals.md` — numbered goals with measurable success criteria and priority
3. Document `constraints.md` — external limitations (budget, timeline, tech stack, compliance)
4. Establish `principles.md` — architecture guardrails that all future decisions must respect
5. [Non-greenfield] Write `as-is-analysis.md` — analyze the current system's architecture, components, and pain points
6. Write `_overview.md` — summarize Phase 1 deliverables and key takeaways

### Deliverables
| File | Required | Notes |
|------|----------|-------|
| `_overview.md` | Always | |
| `problem-statement.md` | Always | |
| `goals.md` | Always | |
| `constraints.md` | Always | May be brief if few constraints |
| `principles.md` | Always | May evolve after Phase 2 research |
| `as-is-analysis.md` | Non-greenfield only | Current system analysis |

### Completion Criteria
- Problem is clearly stated with impact analysis
- Goals are specific and measurable
- Constraints are documented
- At least 2-3 architecture principles are established
- Scope boundaries (in/out) are defined

### Revisit Conditions
- New requirements discovered during later Phases
- Scope change requested by stakeholders
- External feedback from team review introduces new constraints or goals

---

## Phase 2: Research

### Purpose
Gather information to make informed decisions in Phase 3.
Investigate options, study prior art, and evaluate technologies.

### Key Questions
- What approaches exist for solving this type of problem?
- What are the industry best practices?
- What technology options are available, and what are their tradeoffs?
- What have similar projects done? What worked and what didn't?
- Are there any risks or unknowns that need investigation?

### Activities
1. Identify research topics based on Phase 1 deliverables
2. Research each topic thoroughly and from multiple angles
   - Proven approaches and their tradeoffs
   - Real-world implementations and case studies
   - Edge cases and risks
3. Document findings in per-topic `.md` files
4. Synthesize all findings into `findings-summary.md`
5. Update `principles.md` if research reveals new architectural considerations (Phase 1 revisit)
6. Write `_overview.md`

### Deliverables
| File | Required | Notes |
|------|----------|-------|
| `_overview.md` | Always | |
| `{topic}.md` | Per topic | One file per research area, dynamically created |
| `findings-summary.md` | Always | Synthesis of all research with design implications |

### Completion Criteria
- All identified topics researched with sufficient depth
- Findings are synthesized with clear implications for design
- Open questions are documented with suggested next steps
- Enough information to make informed decisions in Phase 3

### Revisit Conditions
- Phase 3 or 4 reveals insufficient information on a topic
- External feedback introduces new topics requiring investigation
- Technology landscape changes (new options become available)

---

## Phase 3: High-Level Design

### Purpose
Decide the **overall direction** for the project. Generate options, compare tradeoffs,
and select approaches for key design decisions.

### Key Questions
- What are the major design decisions to make?
- For each decision, what are the viable options?
- What are the tradeoffs between options?
- Which options best align with our principles and constraints?
- How do the components interact at a high level?

### Activities
1. Draft `architecture-overview.md` — system diagram (Mermaid C4 or similar) + component roles table
2. Identify decision areas — determine if single-decision or multi-decision structure is needed
3. For each decision area:
   a. Generate 2+ options in `options/` directory
   b. Analyze tradeoffs (pros, cons, alignment with principles)
   c. Present options to user for decision
   d. Document selection and rationale in `decision.md`
4. Record each decision in `_decisions.md` (at design root)
5. Write `_overview.md`

### Single vs Multi-Decision Structure

**Single decision** (small projects with one dominant architectural choice):
```
3-high-level-design/
├── _overview.md
├── options/
└── decision.md
```

**Multiple decisions** (complex projects with several independent design choices):
```
3-high-level-design/
├── _overview.md
├── architecture-overview.md
├── {decision-area-1}/
│   ├── options/
│   └── decision.md
├── {decision-area-2}/
│   ├── options/
│   └── decision.md
```

Determine which structure to use based on the number of independent decisions needed.
If 2+ decisions are orthogonal (can be made independently), use the multi-decision structure.

### Deliverables
| File | Required | Notes |
|------|----------|-------|
| `_overview.md` | Always | |
| `architecture-overview.md` | Multi-decision | System diagram + component roles |
| `options/*.md` | Per decision area | 2+ options per decision |
| `decision.md` | Per decision area | Selected option with rationale |

### Completion Criteria
- All major design decisions are made with documented rationale
- Architecture overview captures the overall system structure
- Each decision references relevant principles from `principles.md`
- Component interactions are visible in the architecture diagram

### Revisit Conditions
- Detailed design (Phase 4) reveals the chosen direction is infeasible
- External feedback changes priorities or introduces new requirements
- New constraints make a selected option no longer viable

---

## Phase 4: Detailed Design

### Purpose
Flesh out each component identified in Phase 3. Define internal structures,
behaviors, data models, and interfaces.

### Activities
1. Create `cross-cutting/` if there are concerns spanning multiple components (security, observability, error handling, data flow)
2. Create `interfaces/` if there are component-to-component contracts (API specs, event schemas)
3. For each component from Phase 3:
   a. Create component directory with `_overview.md`
   b. Write `design.md` — responsibility, data model, behavior, error handling, dependencies
   c. If a sub-component needs its own design cycle: create sub-directory (recursive)
4. Write Phase 4 `_overview.md`

### Recursive Mini Design Cycle

When a component is complex enough to require further decomposition:

1. Within the component directory, identify sub-components
2. For each sub-component that needs design choices, create `options/` + `decision.md`
3. For each sub-component, create its own directory with `_overview.md` + `design.md`
4. This process repeats recursively as needed

The mini design cycle starts at the "options → decision → detail" level,
not the full Phase 1-4 cycle. Problem definition and research from earlier Phases still apply.

### Special Directories

| Directory | Purpose | When to create |
|-----------|---------|---------------|
| `cross-cutting/` | Design **policies** spanning multiple components (security strategy, error handling standards, observability approach) | When 2+ components share a concern that doesn't belong to any single component |
| `interfaces/` | Design **contracts** between components (API specs, event schemas, data formats) | When components need explicit agreements on data exchange |

Both directories are **optional**. Create them only when needed.

### Deliverables
| File | Required | Notes |
|------|----------|-------|
| `_overview.md` | Every directory | Including Phase 4 root and each component |
| `design.md` | Per component | At minimum for all Phase 3 components |
| `cross-cutting/*.md` | Optional | Per cross-cutting concern |
| `interfaces/*.md` | Optional | Per interface contract |

### Completion Criteria (Soft)

Phase 4 uses a **soft completion** model:

1. All components from Phase 3 have at least `_overview.md` + `design.md` → **1st pass complete**
2. `interfaces/` defined (if applicable)
3. `cross-cutting/` documented (if applicable)
4. → Present to user: "First pass of detailed design is complete. Which components need deeper exploration?"
5. → Extend recursively **only on user request**

This prevents both over-specification and premature termination.
The default depth is 1 level of detail. Deeper recursion is user-driven.

### Revisit Conditions
Phase 4 does not have a "revisit" in the traditional sense.
Instead, components are deepened on demand through recursive expansion.
If a fundamental issue is found, it triggers Phase 3 (direction change) or Phase 2 (more research) revisit.
