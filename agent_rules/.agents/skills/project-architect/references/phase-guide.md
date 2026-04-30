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

Conduct systematic, in-depth research to build the knowledge foundation for Phase 3 design decisions. This is not a quick lookup or surface-level survey — each research topic is an independent deep investigation that requires multi-source analysis, cross-validation of findings, and synthesis into actionable insights.

Every research document must be **self-sufficient**: a reader with no prior context should be able to understand the topic fully from the document alone, verify claims through the cited references, and trace how the findings connect to design decisions.

### Key Questions
- What approaches exist for solving this type of problem, and what are their underlying mechanisms?
- What are the industry best practices, and what evidence supports them?
- What technology options are available? How do they compare across our evaluation criteria?
- What have similar projects done in production? What worked, what failed, and why?
- What risks, edge cases, or failure modes should we anticipate?
- What are the ecosystem maturity, community support, and long-term viability of each option?
- How does each approach align with our goals, constraints, and principles from Phase 1?

### Research Topic Identification

Derive research topics systematically from Phase 1 deliverables. Each topic must directly inform a Phase 3 design decision — if a topic doesn't connect to a concrete decision, it doesn't belong here.

| Phase 1 Source | Topic Derivation |
|---|---|
| `goals.md` | Technical approaches to achieve each goal |
| `constraints.md` | Viable options within each constraint |
| `principles.md` | Patterns and methodologies that embody each principle |
| `problem-statement.md` | Prior art — how similar problems have been solved |
| `as-is-analysis.md` | Approaches to overcome current system limitations |

**Filtering rule**: For each candidate topic, ask "Which Phase 3 design decision does this inform?" If there is no clear answer, either refine or drop the topic.

### Per-Topic Research Protocol

Each topic requires thorough investigation across multiple dimensions, not just a single-source summary. The goal is comprehensive understanding that enables confident design decisions.

#### Research Angles

Apply the relevant angles based on the topic's nature. Not every angle applies to every topic, but consider each before skipping it.

| Angle | What to Investigate | When Essential |
|---|---|---|
| **Mechanism** | How it works internally — architecture, data flow, algorithms | Always for technical options |
| **Tradeoffs** | Strengths, weaknesses, and the tensions between them | Always |
| **Ecosystem** | Community size, tooling, documentation quality, release cadence, corporate backing | When choosing between competing technologies |
| **Production Evidence** | Real-world case studies, post-mortems, migration stories | When evaluating unproven or high-risk approaches |
| **Risk & Edge Cases** | Known pitfalls, failure scenarios, scaling limits, operational complexity | Always |
| **Fit Assessment** | Alignment with our specific goals, constraints, and principles | Always — this is the bridge to Phase 3 |

#### Source Diversity

A single source produces a single perspective. Cross-validate findings across different source types to build confidence. Each topic should draw from at least **2 different source types**.

| Source Type | Best For | Examples |
|---|---|---|
| Official documentation | Authoritative specs, API behavior, configuration | Docs sites, RFCs, specifications |
| Technical blogs & talks | Practical experience, operational insights, lessons learned | Engineering blogs, conference presentations |
| GitHub repositories | Real implementation patterns, community adoption signals | OSS projects, example architectures |
| Benchmarks & comparisons | Quantitative performance data, objective comparisons | Published benchmarks, comparison reports |
| Community discussions | Real-user pain points, gotchas, workarounds | Stack Overflow, GitHub Issues/Discussions |

#### Self-Sufficiency Principle

Each `{topic}.md` must stand on its own. A reader should never need to leave the document to understand the core content.

- Define acronyms and technical terms on first use
- Include enough background that the "why" behind each finding is clear
- Do not write "see X for details" without also including the essential content inline
- References are for **verification and deeper exploration**, not for carrying essential information

#### Reference Tracking

Every factual claim, data point, and external example must cite its source using inline references.

**Inline format**: Use `[Ref-N]` markers in the body text where a claim is made.

**Reference table** (required at the end of every `{topic}.md`):

| # | Title | Type | URL/Location | Credibility | Note |
|---|-------|------|-------------|-------------|------|

**Credibility guidelines**:
- **High**: Official documentation, peer-reviewed papers, established technical authorities
- **Medium**: Reputable engineering blogs, well-known tech publications, vendor-published reports (note potential bias)
- **Low–Medium**: Community forums, individual blog posts, anecdotal reports

**Unsourced claims**: If a claim comes from general experience or inference rather than a specific source, mark it explicitly as "Based on general industry practice" or "Requires further verification."

### Activities

1. **Identify topics** — Review Phase 1 deliverables and derive research topics using the topic identification table above. Present the topic list to the user for confirmation before proceeding.
2. **Research each topic** — For each topic, conduct a thorough, multi-source investigation:
   a. Establish scope: what specific questions does this topic need to answer?
   b. Gather information across multiple source types (see Source Diversity)
   c. Analyze from relevant research angles (see Research Angles)
   d. Cross-validate key claims across sources
   e. Assess fit with project context (goals, constraints, principles)
   f. Document everything in `{topic}.md` using the template from `references/templates.md`
3. **Synthesize findings** — Compile cross-topic patterns, insights, and implications into `findings-summary.md`
4. **Update principles** — If research reveals new architectural considerations, revisit Phase 1 `principles.md`
5. **Write `_overview.md`** — Summarize Phase 2 scope, topics covered, and key takeaways

### Deliverables
| File | Required | Notes |
|------|----------|-------|
| `_overview.md` | Always | |
| `{topic}.md` | Per topic | One file per research area — must follow the topic template |
| `findings-summary.md` | Always | Cross-topic synthesis with design implications and consolidated references |

### Completion Criteria
- All identified topics researched across multiple angles with multiple source types
- Each `{topic}.md` is self-sufficient — readable without external context
- Each `{topic}.md` has a References table with **3+ sources** and inline `[Ref-N]` citations
- Findings are synthesized with clear implications for Phase 3 design decisions
- Open questions and remaining uncertainties are documented with suggested next steps
- Enough information to make confident, well-informed decisions in Phase 3

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
