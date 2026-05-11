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
1. **Present the Phase 1 agenda** — problem statement, goals, scope boundaries, constraints, principles, and `[Non-greenfield]` as-is analysis.
2. **Discuss candidate content before writing** — propose initial candidates in conversation and invite the user to add, remove, reprioritize, or rephrase them.
3. **Converge on local consensus** — confirm the agreed problem framing, goal priorities, constraints, scope boundaries, and guiding principles.
4. **Write Phase 1 artifacts after consensus**:
   a. `problem-statement.md` — articulate the agreed core problem and its impact
   b. `goals.md` — numbered goals with measurable success criteria and priority
   c. `constraints.md` — external limitations (budget, timeline, tech stack, compliance)
   d. `principles.md` — architecture guardrails that all future decisions must respect
   e. `[Non-greenfield] as-is-analysis.md` — current architecture, components, technology, and pain points
5. Write `_overview.md` — summarize Phase 1 deliverables, discussion outcomes, and key takeaways

Do not create final Phase 1 artifacts before the user agrees on the relevant agenda content. Use conversation for unresolved exploration.

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
- User has agreed that the Phase 1 framing is ready to document

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

### Research Plan Discussion

Before performing research, discuss what should be researched and why. Present candidate topics with the Phase 3 decision each topic informs, proposed scope, priority, depth, and comparison criteria. Let the user add, remove, split, merge, or reprioritize topics before writing the research plan.

### Activities

1. **Identify candidate topics** — Review Phase 1 deliverables and derive research topics using the topic identification table above. Present the topic list as candidates, not as a final plan.
2. **Discuss and refine the research scope** — For each topic, agree on:
   a. Which Phase 3 decision it informs
   b. Priority (`Must`, `Should`, `Optional`)
   c. Depth (`Quick`, `Standard`, `Deep`)
   d. Included and excluded scope
   e. Relevant source types and comparison criteria
3. **Write `research-plan.md` after consensus** — Record the agreed topics, scope, priority, depth, and user notes.
4. **Research each topic** — For each agreed topic, conduct a thorough, multi-source investigation:
   a. Establish scope: what specific questions does this topic need to answer?
   b. Gather information across multiple source types (see Source Diversity)
   c. Analyze from relevant research angles (see Research Angles)
   d. Cross-validate key claims across sources
   e. Assess fit with project context (goals, constraints, principles)
   f. Document everything in `{topic}.md` using the template from `references/templates.md`
5. **Synthesize findings** — Compile cross-topic patterns, insights, risks, and candidate directions for Phase 3 discussion into `findings-summary.md`. Do not treat these as final design decisions.
6. **Update principles** — If research reveals new architectural considerations, revisit Phase 1 `principles.md`
7. **Write `_overview.md`** — Summarize Phase 2 scope, topics covered, and key takeaways

### Deliverables
| File | Required | Notes |
|------|----------|-------|
| `_overview.md` | Always | |
| `research-plan.md` | Always | Agreed topic list, priority, depth, scope, and decision mapping |
| `{topic}.md` | Per topic | One file per research area — must follow the topic template |
| `findings-summary.md` | Always | Cross-topic synthesis with design implications and consolidated references |

`research-plan.md` is required for Phase 2 completion, but must not be created before the user agrees on topic list, scope, priority, depth, and comparison criteria.

### Completion Criteria
- All identified topics researched across multiple angles with multiple source types
- Each `{topic}.md` is self-sufficient — readable without external context
- Each `{topic}.md` has a References table with **3+ sources** and inline `[Ref-N]` citations
- Findings are synthesized with clear implications for Phase 3 design decisions
- Open questions and remaining uncertainties are documented with suggested next steps
- Enough information to make confident, well-informed decisions in Phase 3
- User has agreed on the research topic list before research begins

### Revisit Conditions
- Phase 3 or 4 reveals insufficient information on a topic
- External feedback introduces new topics requiring investigation
- Technology landscape changes (new options become available)

---

## Phase 3: High-Level Design

### Purpose
Decide the **overall direction** for the project. Discuss options, compare tradeoffs,
and select approaches for key design decisions after explicit user consensus.

### Key Questions
- What are the major design decisions to make?
- For each decision, what are the viable options?
- What are the tradeoffs between options?
- Which options best align with our principles and constraints?
- How do the components interact at a high level?

### Activities
1. **Identify decision-area candidates in conversation** — determine whether a single-decision or multi-decision structure is needed. Ask the user to add, remove, split, merge, or reprioritize areas.
2. **Agree on decision areas and evaluation criteria** — confirm what decisions will be made and which criteria matter most (principles, constraints, delivery speed, operability, cost, risk, etc.).
3. **For each decision area, discuss candidate directions before writing artifacts**:
   a. Present 2+ candidate directions in conversation
   b. Incorporate user-added options as equal candidates (for example, a new `Option D`)
   c. Compare pros, cons, risks, fit, and principle alignment
   d. Use neutral fit assessment only; do not recommend or select until the user explicitly decides
   e. If the user adds a new option during comparison, reopen the candidate comparison, confirm the full candidate set, then write or update one option file per agreed candidate
4. **Document the agreed candidate set** — after the user agrees which options should be considered, create one file per option under `options/` using the option template.
5. **Confirm the final decision explicitly** — ask the user to choose or confirm the direction. Do not write `decision.md` before this point.
6. **Document the decision** — write `decision.md`, record the entry in `_decisions.md`, and summarize the discussion rationale and rejected alternatives.
7. Draft or update `architecture-overview.md` when needed — required for multi-decision Phase 3, optional for single-decision projects when a system-level view is still useful.
8. Write `_overview.md`

### Single vs Multi-Decision Structure

**Single decision** (small projects with one dominant architectural choice):
```
3-high-level-design/
├── _overview.md
├── options/
│   ├── option-a-{name}.md
│   └── option-b-{name}.md
└── decision.md
```

**Multiple decisions** (complex projects with several independent design choices):
```
3-high-level-design/
├── _overview.md
├── architecture-overview.md
├── {decision-area-1}/
│   ├── _overview.md
│   ├── options/
│   │   ├── option-a-{name}.md
│   │   └── option-b-{name}.md
│   └── decision.md
├── {decision-area-2}/
│   ├── _overview.md
│   ├── options/
│   │   ├── option-a-{name}.md
│   │   └── option-b-{name}.md
│   └── decision.md
```

Determine which structure to use based on the number of independent decisions needed.
If 2+ decisions are orthogonal (can be made independently), use the multi-decision structure.

### Deliverables
| File | Required | Notes |
|------|----------|-------|
| `_overview.md` | Always | |
| `architecture-overview.md` | Multi-decision | System diagram + component roles |
| `options/*.md` | Per decision area | 2+ options per decision; each option must have its own file |
| `decision.md` | Per decision area | Selected option with rationale |

### Completion Criteria
- All major design decisions are made with documented rationale
- For multi-decision Phase 3, architecture overview captures the overall system structure; for single-decision projects, create it only when useful
- Each decision references relevant principles from `principles.md`
- Component interactions are visible in the architecture diagram
- Each candidate option is documented in a separate `options/option-*.md` file
- `decision.md` is written only after explicit user consensus

### Revisit Conditions
- Detailed design (Phase 4) reveals the chosen direction is infeasible
- External feedback changes priorities or introduces new requirements
- New constraints make a selected option no longer viable

---

## Phase 4: Detailed Design

### Purpose
Flesh out each component identified in Phase 3. Define internal structures,
behaviors, data models, and interfaces.

**Substantive tradeoff rule**: A component-level alternative is substantive when options differ in architecture, data ownership, interface contract, operational model, scalability, security, cost, or delivery risk. Treat substantive alternatives as local sub-decisions with separate option files.

### Activities
1. **Present the Phase 4 agenda** — list components from Phase 3 and propose which design concerns need discussion: responsibility, boundaries, data model, behavior, dependencies, error handling, interfaces, and cross-cutting policies.
2. **Agree on component design order and scope** — let the user add, remove, split, merge, or reprioritize components and concerns.
3. **For each component, discuss before writing `design.md`**:
   a. Explore candidate internal structures or design approaches in conversation
   b. Capture user-added alternatives and criteria changes
   c. Confirm the agreed component direction and any unresolved decisions
   d. If a component-level alternative has substantive tradeoffs, treat it as a local sub-decision and document each candidate in `options/option-*.md` before finalizing `design.md`
4. **Write component artifacts after consensus**:
   a. Create component directory with `_overview.md`
   b. Write `design.md` — responsibility, data model, behavior, error handling, dependencies, rationale, alternatives, and open decisions
   c. If a component contains unresolved recursive sub-decisions, `design.md` may only record them under `Open Decisions`; do not fill the selected internal design direction, rationale, or alternatives as final until the local `decision.md` exists
5. **Create `cross-cutting/` if agreed** — only when concerns span multiple components (security, observability, error handling, data flow)
6. **Create `interfaces/` if agreed** — only when component-to-component contracts need explicit documentation (API specs, event schemas)
7. **If a sub-component or sub-decision needs its own design cycle**, use the Recursive Mini Design Cycle below
8. Write Phase 4 `_overview.md`

### Recursive Mini Design Cycle

When a component is complex enough to require further decomposition:

1. Within the component directory, identify sub-components or sub-decisions in conversation.
2. Discuss candidate directions and evaluation criteria before writing artifacts.
3. After the user agrees on the candidate set, create a sub-decision directory with `_overview.md` and `options/`.
4. Create one file per candidate direction under `options/`.
5. If the user asks to defer option files until after the final decision, clarify that option files are pre-decision artifacts created after candidate set agreement, while `decision.md` is post-decision.
6. Ask the user to explicitly confirm the final direction.
7. Create and write `decision.md`, then update the relevant component `design.md` or sub-component `design.md`.
8. This process repeats recursively as needed.

The mini design cycle starts at the "discussion → option files → decision → detail" level, not the full Phase 1-4 cycle. Problem definition and research from earlier Phases still apply.

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
| `options/*.md` | Per recursive decision | One file per candidate option |
| `decision.md` | Per recursive decision | Selected option with rationale |
| `cross-cutting/*.md` | Optional | Per cross-cutting concern |
| `interfaces/*.md` | Optional | Per interface contract |

### Completion Criteria (Soft)

Phase 4 uses a **soft completion** model:

1. All components from Phase 3 have at least `_overview.md` + `design.md` → **1st pass complete**
2. `interfaces/` defined (if applicable)
3. `cross-cutting/` documented (if applicable)
4. → Present to user: "First pass of detailed design is complete. Which components need deeper exploration?"
5. → Extend recursively **only on user request**
6. Recursive decisions, if any, have separate option files and a post-consensus `decision.md`

This prevents both over-specification and premature termination.
The default depth is 1 level of detail. Deeper recursion is user-driven.

### Revisit Conditions
Phase 4 does not have a "revisit" in the traditional sense.
Instead, components are deepened on demand through recursive expansion.
If a fundamental issue is found, it triggers Phase 3 (direction change) or Phase 2 (more research) revisit.
