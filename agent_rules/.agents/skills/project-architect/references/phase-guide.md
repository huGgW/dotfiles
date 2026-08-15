# Phase Guide

Detailed guidance for each Phase of the design process.
Consult this when entering a new Phase or when revisiting a completed one.
Apply the Breadth-First Discussion Protocol from `SKILL.md` throughout: confirm the current-level discussion list, cover sibling topics once, park deeper questions, explain any blockers, then deepen only user-confirmed items.

---

## Phase 1: Problem Definition

### Purpose
Define **what** problem to solve and **why** it matters. Establish the foundation
that all subsequent Phases build upon — but stay light. Phase 1 is not a place to
specify guardrails or pre-commit to a solution direction.

### Key Questions
- What specific problem are we solving?
- Who is affected and how?
- What does success look like? (measurable criteria)
- What are the scope boundaries? (in/out of scope)
- What hard external constraints exist? (budget, timeline, technology — only if real)
- [Non-greenfield] What does the current system look like? What are its pain points?

### Activities
1. **Present and confirm the Phase 1 discussion list** — problem statement, goals and success criteria, scope boundaries, hard constraints (only if any), and `[Non-greenfield]` as-is analysis. Let the user add, remove, merge, or reorder items before discussing the first one.
2. **Complete a first pass across the list** — propose initial candidate content for each item at the same level of detail. Park solution ideas, architecture questions, and implementation details under `Later Discussion` instead of following them immediately.
3. **Deepen only where needed and converge** — revisit only items that the user selects. If an item blocks a clear problem definition, explain why and ask the user to confirm that deeper pass. Confirm the agreed problem framing, goal priorities, scope boundaries, and any genuine constraints. Avoid manufacturing constraints or principles to fill out the section.
4. **Write Phase 1 artifacts after consensus** — write only the artifacts the project actually needs:
   a. `problem-statement.md` — articulate the agreed core problem and its impact (always)
   b. `goals.md` — numbered goals with measurable success criteria and priority (always)
   c. `constraints.md` — external limitations only when there are non-trivial ones to document (often skipped for greenfield projects with no hard constraints)
   d. `[Non-greenfield] as-is-analysis.md` — current architecture, components, technology, and pain points
5. Write `index.md` — summarize Phase 1 deliverables, discussion outcomes, and key takeaways

> **Where did `principles.md` go?** Architecture principles are now established in Phase 3 (Solution Concept), after the project's identity and operating direction are agreed. Establishing principles before the concept is decided tends to either be too generic to guide decisions, or to over-constrain the concept exploration.

Do not create final Phase 1 artifacts before the user agrees on the relevant agenda content. Use conversation for unresolved exploration.

### Deliverables
| File | Required | Notes |
|------|----------|-------|
| `index.md` | Always | |
| `problem-statement.md` | Always | |
| `goals.md` | Always | |
| `constraints.md` | When applicable | Skip if there are no non-trivial external constraints |
| `as-is-analysis.md` | Non-greenfield only | Current system analysis |

### Completion Criteria
- Problem is clearly stated with impact analysis
- Goals are specific and measurable
- Scope boundaries (in/out) are defined
- Constraints are documented only when they are real and material to design
- User has agreed that the Phase 1 framing is ready to document

### Revisit Conditions
- New requirements discovered during later Phases
- Scope change requested by stakeholders
- External feedback from team review introduces new constraints or goals

---

## Phase 2: Research

### Purpose

Conduct systematic, in-depth research to build the information foundation for later design phases. Phase 2 is **decision preparation, not decision making**: gather and organize the facts, existing-codebase context, constraints, risks, technology options, tradeoffs, and open questions that Phase 3 (Solution Concept) and Phase 4 (High-Level Design) will need.

This is not a quick lookup or surface-level survey. Each research topic is an independent investigation that requires multi-source analysis, cross-validation of findings, and careful organization of decision inputs. Do not recommend, select, or finalize a design direction in Phase 2; design opinions and conclusions belong to Phase 3, 4, or 5 after user discussion.

Every research document must be **self-sufficient**: a reader with no prior context should be able to understand the topic fully from the document alone, verify claims through the cited references, and see which later-phase questions the information supports.

### Key Questions
- What approaches exist for solving this type of problem, and what are their underlying mechanisms?
- What are the industry best practices, and what evidence supports them?
- What technology options are available? How do they compare across our evaluation criteria?
- What have similar projects done in production? What worked, what failed, and why?
- What risks, edge cases, or failure modes should we anticipate?
- What are the ecosystem maturity, community support, and long-term viability of each option?
- How does each approach relate to our goals and constraints from Phase 1, without choosing among approaches yet?
- What does the current codebase already do, and which files, modules, data flows, APIs, dependencies, tests, or deployment paths will later design phases need to understand?

### Research Topic Identification

Derive research topics systematically from Phase 1 deliverables. Each topic must directly inform a Phase 3 or Phase 4 design question — if a topic doesn't connect to a concrete downstream information need, it doesn't belong here.

| Phase 1 Source | Topic Derivation |
|---|---|
| `goals.md` | Technical approaches to achieve each goal |
| `constraints.md` | Viable options within each constraint |
| `problem-statement.md` | Prior art — how similar problems have been solved |
| `as-is-analysis.md` | Current codebase structure, constraints, risks, and options for addressing current system limitations |

**Filtering rule**: For each candidate topic, ask "Which Phase 3 or Phase 4 question does this prepare us to answer?" If there is no clear answer, either refine or drop the topic.

### Per-Topic Research Protocol

Each topic requires thorough investigation across multiple dimensions, not just a single-source summary. The goal is comprehensive understanding that enables later design discussions to make informed decisions without prematurely making those decisions in Phase 2.

#### Research Angles

Apply the relevant angles based on the topic's nature. Not every angle applies to every topic, but consider each before skipping it.

| Angle | What to Investigate | When Essential |
|---|---|---|
| **Mechanism** | How it works internally — architecture, data flow, algorithms | Always for technical options |
| **Tradeoffs** | Strengths, weaknesses, and the tensions between them | Always |
| **Ecosystem** | Community size, tooling, documentation quality, release cadence, corporate backing | When choosing between competing technologies |
| **Production Evidence** | Real-world case studies, post-mortems, migration stories | When evaluating unproven or high-risk approaches |
| **Risk & Edge Cases** | Known pitfalls, failure scenarios, scaling limits, operational complexity | Always |
| **Project Context Mapping** | How the findings relate to our goals, constraints, current codebase, risks, and later design questions | Always — this is the bridge to Phase 3 / Phase 4, but it must not select a design direction |

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

Before performing research, discuss what should be researched and why. First present all candidate topics as a current-level list with the downstream Phase 3 or Phase 4 question each topic informs. Let the user add, remove, split, merge, reorder, or reprioritize topics before discussing any one topic's detailed scope, depth, sources, or comparison criteria. The agreed research itself may be deep; keep the planning conversation and later synthesis compact unless the user requests full detail.

### Phase 2 Non-Goals

Phase 2 should make later design conversations easier, not replace them. Avoid these patterns:

- Do not write a recommended architecture, selected option, or target refactoring plan
- Do not rank one approach as the final answer; capture comparative facts and tradeoffs instead
- Do not create Phase 3 or Phase 4 option/decision artifacts from research alone
- Do not turn codebase analysis into a proposed implementation plan
- Do not skip codebase investigation for non-greenfield work when the repository is available and relevant

### Codebase Investigation (When Applicable)

When the project evolves an existing repository, migrates a system, or the user asks for codebase understanding, Phase 2 must include codebase investigation. The purpose is to document what later design phases need to know about the actual system, not to propose the target architecture or refactoring plan.

Investigate the relevant current-state facts:

- Entrypoints, package/module boundaries, layers, and ownership areas
- Existing data flow, request flow, event flow, API surfaces, and integration points
- Dependencies, configuration, persistence, infrastructure, build/test/deploy paths
- Existing conventions, extension points, and constraints that future design should respect
- Fragile areas, hidden coupling, missing tests, operational risks, and unknowns

Document broad findings in `codebase-analysis.md` when the whole codebase matters, or inside a narrower `{topic}.md` when the investigation belongs to a specific research topic. Cite file paths, directories, commands, or local artifacts as references. End with later-phase design questions and open issues, not recommendations.

### Activities

1. **Identify and confirm the current-level topic list** — Review Phase 1 deliverables and derive research topics using the topic identification table above. Present all topics as candidates with one-line purposes. Confirm the full list and order before opening any topic's detailed research scope.
2. **Complete a planning pass across all topics** — For each topic, briefly identify its downstream question, priority, and likely depth. Park detailed source or mechanism questions until every sibling topic has been covered.
3. **Refine every agreed topic's research scope** — For each agreed topic, settle:
   a. Which Phase 3 or Phase 4 design question or artifact it informs
   b. Priority (`Must`, `Should`, `Optional`)
   c. Depth (`Quick`, `Standard`, `Deep`)
   d. Included and excluded scope
   e. Relevant source types and comparison criteria
4. **Write `research-plan.md` after consensus** — Record the agreed topics, scope, priority, depth, and user notes.
5. **Research each topic** — For each agreed topic, conduct a thorough, multi-source investigation:
   a. Establish scope: what specific questions does this topic need to answer?
   b. Gather information across multiple source types (see Source Diversity)
   c. Analyze from relevant research angles (see Research Angles)
   d. Cross-validate key claims across sources
   e. Map findings to project context (goals, constraints, current codebase) without recommending a design direction
   f. Document everything in `{topic}.md` using the template from `references/templates.md`
6. **Synthesize findings** — Compile cross-topic patterns, facts, constraints, risks, open questions, and later-phase decision inputs into `findings-summary.md`. Present a compact cross-topic summary first and offer per-topic detail on request. Do not treat these as recommendations or final design decisions.
7. **Write `index.md`** — Summarize Phase 2 scope, topics covered, and key takeaways

### Deliverables
| File | Required | Notes |
|------|----------|-------|
| `index.md` | Always | |
| `research-plan.md` | Always | Agreed topic list, priority, depth, scope, and later-phase question/artifact mapping |
| `codebase-analysis.md` | When applicable | Current-codebase findings needed by later design phases |
| `{topic}.md` | Per topic | One file per research area — must follow the topic template |
| `findings-summary.md` | Always | Cross-topic synthesis with later-phase inputs, open questions, and consolidated references |

`research-plan.md` is required for Phase 2 completion, but must not be created before the user agrees on topic list, scope, priority, depth, and comparison criteria.

### Completion Criteria
- All identified topics researched across multiple angles with multiple source types
- Each `{topic}.md` is self-sufficient — readable without external context
- Each `{topic}.md` has a References table with **3+ sources** and inline `[Ref-N]` citations
- Existing codebase context is documented when relevant, with concrete file paths, modules, flows, dependencies, and risks
- Findings are synthesized as clear inputs and questions for Phase 3 (concept-level) and Phase 4 (skeleton-level) discussion, not as recommendations
- Open questions and remaining uncertainties are documented with suggested next steps
- Enough information for Phase 3 and Phase 4 to make confident, well-informed decisions later
- User has agreed on the research topic list before research begins

### Revisit Conditions
- Phase 3, 4, or 5 reveals insufficient information on a topic
- External feedback introduces new topics requiring investigation
- Technology landscape changes (new options become available)

---

## Phase 3: Solution Concept

### Purpose

Decide **what we are building** and **how it operates** at a big-picture level, before drawing any architecture. Phase 3 produces a shared mental model of the system — its identity, its primary mode of operation, and the principles that should govern subsequent design — so that Phase 4 can focus on structural decisions instead of re-debating the project's identity.

This phase is intentionally lighter than the structural phases that follow. It exists because skipping straight from research to high-level design tends to surface concept-level disagreements (what is this thing, exactly?) too late, when they are expensive to undo.

### Key Questions
- In one paragraph, what is this system? What is it not?
- How does it operate from an outside view? (key user / integrating-system scenarios, mode of operation, lifecycle)
- Are there genuinely competing big-picture directions? (e.g., real-time vs batch, product vs platform, push vs pull, single-tenant vs multi-tenant)
- What architecture principles should guide all subsequent decisions?

### Activities

1. **Present and confirm the concept discussion list** — list the system definition, operating model, possible big-picture direction, and principles with one-line purposes. Let the user change the list and order before discussing the first item.
2. **Complete a concept-level first pass** — cover each list item without drawing internal architecture or expanding structural details. Park those questions as Phase 4 inputs.
3. **Identify whether competing big-picture directions need a deeper pass** — If multiple genuinely different concepts could solve the problem (e.g., "real-time event streaming product" vs "scheduled batch analytics product"), treat them as a Phase 3 decision. Otherwise, do not manufacture options.
4. **For competing directions, follow the option-decision pattern**:
   a. Present 2+ candidate directions in conversation
   b. Compare implications: how each would feel to use, operate, and evolve
   c. Use neutral fit assessment only; do not recommend or select until the user explicitly decides
   d. After candidate set is agreed, document each candidate under `options/`
   e. After explicit user decision, write `decision.md`
5. **Agree on principles** — Discuss architecture guardrails that all later decisions must respect. Principles should be specific enough to influence decisions (e.g., "prefer eventual consistency when synchronous coordination would harm availability") rather than generic (e.g., "be reliable").
6. **Write Phase 3 artifacts after consensus**:
   a. `concept.md` — definition of the system, its boundaries, what it is and is not
   b. `operating-model.md` — outside view of how the system behaves: key scenarios, mode of operation, lifecycle
   c. `principles.md` — architecture principles with concrete examples
   d. `options/option-*.md` + `decision.md` — only if competing big-picture directions were identified
7. **Write `index.md`** — Summarize Phase 3 outcomes and any deferred questions for Phase 4

### Deliverables
| File | Required | Notes |
|------|----------|-------|
| `index.md` | Always | |
| `concept.md` | Always | One-paragraph system definition + boundaries |
| `operating-model.md` | Always | Outside view: key scenarios, mode of operation |
| `principles.md` | Always | At least 2-3 specific architecture principles |
| `options/*.md` | When competing big-picture directions exist | One file per candidate concept-level direction |
| `decision.md` | Paired with `options/` | Selected concept-level direction with rationale |

### Completion Criteria
- The system is defined in a way that anyone joining the project understands what it is
- The operating model is clear enough that Phase 4 can focus on internal structure
- Principles are specific and grounded; each principle would change at least one downstream decision
- Big-picture directional alternatives, if any, were considered explicitly and a decision was made
- User has agreed the concept is ready to drive Phase 4

### Scope Discipline

Phase 3 should **not** include:
- Architecture diagrams of internal components → Phase 4
- Domain model definitions → Phase 4
- Decisions like "REST vs gRPC", "Postgres vs DynamoDB", "monolith vs microservices" → Phase 4 (skeleton-level)
- Component-internal design → Phase 5

If a concept-level discussion drifts into structural specifics, capture the drift as input to Phase 4 (e.g., in `index.md` under "Inputs to Phase 4") and stay at the concept level.

### Revisit Conditions
- Phase 4 or Phase 5 reveals the concept-level direction does not actually fit
- External feedback changes how the system should be perceived or operated
- A new principle emerges that would have changed the decision

---

## Phase 4: High-Level Design

### Purpose
Capture the **overall flow and primary models** of the system, plus the small set of **system-skeleton decisions** that shape the architecture. The goal is to produce a high-level view that is rich enough to drive Phase 5 component design, and no richer.

Phase 4 is the structural phase: it answers "what does the system look like at the system level?" — not "how does each component work internally?".

### Key Questions
- What is the overall flow of the system? (request flow, event flow, data flow)
- What are the primary domain entities and their relationships?
- What are the major components and what does each one own?
- What system-skeleton decisions need to be made? (communication style, data ownership/strategy, deployment topology, sync vs async boundaries, etc.)
- For each skeleton decision, what are the viable options and their tradeoffs?

### Activities
1. **Present and confirm the full skeleton discussion list** — show the overall flow, primary model, major components, and every candidate skeleton-level decision area with one-line purposes. Ask the user to add, remove, split, merge, reorder, or reprioritize areas before opening option details. If there are no genuine skeleton-level decisions to make, the architecture overview and domain model are sufficient.
2. **Complete a first pass across the full list** — outline the overall flow, primary model, and component roles, then establish each decision area's boundary, reason, and key criterion at the same level of detail. Park component-internal questions for Phase 5.
3. **Select areas for deeper comparison** — confirm which skeleton-level decisions need option analysis and which criteria matter most (principles, constraints, delivery speed, operability, cost, risk, etc.).
4. **For each selected decision area, discuss candidate directions before writing artifacts**:
   a. Present 2+ candidate directions in conversation
   b. Incorporate user-added options as equal candidates (for example, a new `Option D`)
   c. Compare pros, cons, risks, fit, and principle alignment (referencing `principles.md` from Phase 3)
   d. Use neutral fit assessment only; do not recommend or select until the user explicitly decides
   e. If the user adds a new option during comparison, reopen the candidate comparison, confirm the full candidate set, then write or update one option file per agreed candidate
5. **Document the agreed candidate set** — after the user agrees which options should be considered, create one file per option under `options/` using the option template.
6. **Confirm the final decision explicitly** — ask the user to choose or confirm the direction. Do not write `decision.md` before this point.
7. **Document the decision** — write `decision.md`, record the entry in `decisions.md`, and summarize the discussion rationale and rejected alternatives.
8. **Draft `architecture-overview.md` and `domain-model.md`** — these capture the system-level view and primary model. They are required.
9. Write `index.md`

### Scope Discipline

Phase 4 should **not** include:
- Component-internal structures (data structures inside a component, internal services, private interfaces) → Phase 5
- Detailed behavior of any single component → Phase 5
- Implementation choices that don't shape the system skeleton (e.g., which logging library to use) → defer to actual work

A useful test: *"If we change this decision later, would it ripple across multiple components?"* If yes, it is a Phase 4 skeleton decision. If it stays inside a single component, push it to Phase 5.

### Single Decision vs Multi-Decision Structure

**No skeleton-level decisions** (concept is concrete enough that the structure follows naturally):
```
4-high-level-design/
├── index.md
├── architecture-overview.md
└── domain-model.md
```

**Multiple skeleton-level decisions** (independent decisions like communication style, data strategy, deployment model):
```
4-high-level-design/
├── index.md
├── architecture-overview.md
├── domain-model.md
├── {decision-area-1}/
│   ├── index.md
│   ├── options/
│   │   ├── option-a-{name}.md
│   │   └── option-b-{name}.md
│   └── decision.md
├── {decision-area-2}/
│   ├── index.md
│   ├── options/
│   │   ├── option-a-{name}.md
│   │   └── option-b-{name}.md
│   └── decision.md
```

Use the multi-decision structure when 2+ decisions are orthogonal (can be made independently).

### Deliverables
| File | Required | Notes |
|------|----------|-------|
| `index.md` | Always | |
| `architecture-overview.md` | Always | System diagram + flow + component roles |
| `domain-model.md` | Always | Primary entities, relationships, ownership at system level (may be named `data-model.md` if more appropriate) |
| `options/*.md` | Per skeleton-level decision area | 2+ options per decision; each option must have its own file |
| `decision.md` | Per skeleton-level decision area | Selected option with rationale |

### Completion Criteria
- Architecture overview captures the system structure and overall flow
- Primary domain/data model is defined at entity-level (not field-level)
- All identified skeleton-level decisions are made with documented rationale
- Each decision references relevant principles from Phase 3 `principles.md`
- Each candidate option for each decision is documented in a separate `options/option-*.md` file
- `decision.md` is written only after explicit user consensus
- The artifacts are sufficient to start Phase 5 component design

### Revisit Conditions
- Detailed design (Phase 5) reveals the chosen skeleton decision is infeasible
- External feedback changes priorities or introduces new requirements
- New constraints make a selected option no longer viable

---

## Phase 5: Detailed Design

### Purpose
Detail each component identified in Phase 4 to a level that enables splitting the work into developer-facing work issues. Define internal structures, behaviors, data models, interfaces, and error handling — but stop before micro-design.

The phase exists for one reason: **a developer (or planning agent) should be able to read the component design and split it into work issues**. Anything finer than that is the work itself.

### Activities
1. **Present and confirm the Phase 5 discussion list** — list all components from Phase 4 and the current-level concerns: responsibility, boundaries, data model, behavior, dependencies, error handling, interfaces, and cross-cutting policies. Let the user add, remove, split, merge, reorder, or reprioritize components and concerns before opening one component's internals.
2. **Complete a one-level pass across all components** — establish each component's purpose, boundary, main flow, and visible open decisions. Park internal structures, exact contracts, and implementation choices until sibling components have been covered.
3. **Agree on component design order and required scope** — every component needs one-level design that meets the completion checklist. Choose the order for completing that pass; treat recursive expansion as a separate, later choice.
4. **For each component, discuss before writing `design.md`**:
   a. Explore candidate internal structures or design approaches in conversation
   b. Capture user-added alternatives and criteria changes
   c. Confirm the agreed component direction and any unresolved decisions
   d. Treat a component-level alternative as a local sub-decision only when it has substantive tradeoffs **and** would block work-issue creation if left unresolved. Document each such candidate in `options/option-*.md` before finalizing `design.md`.
5. **Write component artifacts after consensus**:
   a. Create component directory with `index.md`
   b. Write `design.md` to satisfy the completion checklist (see below) — no more, no less
   c. If a component contains unresolved recursive sub-decisions, `design.md` may only record them under `Open Decisions`; do not finalize the selected internal design direction until the local `decision.md` exists
6. **Create `cross-cutting/` if agreed** — only when concerns span multiple components (security, observability, error handling, data flow)
7. **Create `interfaces/` if agreed** — only when component-to-component contracts need explicit documentation (API specs, event schemas)
8. **If a sub-component or sub-decision needs its own design cycle**, keep it under `Open Decisions` until every current-level component has a checklist-complete `design.md`. Then use the Recursive Mini Design Cycle only for items the user selects.
9. Write Phase 5 `index.md`

### Substantive Tradeoff Rule (Refined)

A component-level alternative deserves a sub-decision only if **both** are true:
1. The options differ in architecture, data ownership, interface contract, operational model, scalability, security, cost, or delivery risk.
2. Choosing wrongly would block or invalidate work-issue creation.

If the alternatives are genuinely interchangeable from a work-planning perspective, defer the choice to the actual work. Avoid spawning sub-decisions for choices that the implementer can make at coding time without rippling consequences.

### Recursive Mini Design Cycle

When a component is complex enough to require further decomposition:

1. Within the component directory, present all current-level sub-components or sub-decisions as a short sibling list.
2. Confirm the list and order before opening candidate details.
3. Complete a first pass across the list, parking lower-level questions instead of following one branch recursively.
4. Explain which unresolved items block work-issue creation and ask the user which item to deepen. Discuss candidate directions and evaluation criteria only for a user-confirmed item.
5. After the user agrees on a selected item's candidate set, create a sub-decision directory with `index.md` and `options/`.
6. Create one file per candidate direction under `options/`.
7. If the user asks to defer option files until after the final decision, clarify that option files are pre-decision artifacts created after candidate set agreement, while `decision.md` is post-decision.
8. Ask the user to explicitly confirm the final direction.
9. Create and write `decision.md`, then update the relevant component `design.md` or sub-component `design.md`.
10. Repeat only for another user-confirmed item.

The mini design cycle starts at the "discussion → option files → decision → detail" level, not the full Phase 1-5 cycle. Problem definition, research, concept, and high-level design from earlier Phases still apply.

### Special Directories

| Directory | Purpose | When to create |
|-----------|---------|---------------|
| `cross-cutting/` | Design **policies** spanning multiple components (security strategy, error handling standards, observability approach) | When 2+ components share a concern that doesn't belong to any single component |
| `interfaces/` | Design **contracts** between components (API specs, event schemas, data formats) | When components need explicit agreements on data exchange |

Both directories are **optional**. Create them only when needed.

### Deliverables
| File | Required | Notes |
|------|----------|-------|
| `index.md` | Every directory | Including Phase 5 root and each component |
| `design.md` | Per component | Must satisfy the completion checklist below |
| `options/*.md` | Per recursive sub-decision | One file per candidate option |
| `decision.md` | Per recursive sub-decision | Selected option with rationale |
| `cross-cutting/*.md` | Optional | Per cross-cutting concern |
| `interfaces/*.md` | Optional | Per interface contract |

### Completion Criteria (Soft)

A component's `design.md` is **complete enough to drive work-issue creation** when all of the following are answered:

- [ ] Component **responsibility and boundaries** are clearly stated
- [ ] **Primary data/state model** is defined at entity level (field-level detail is not required)
- [ ] **Key behaviors and flows** are described (state transitions, main scenarios, happy path + key error paths)
- [ ] **External interfaces and dependencies** are listed (APIs consumed/exposed, events, other components)
- [ ] **Error handling strategy** is specified at policy level (retry, fallback, propagation, observability)
- [ ] **Open decisions** that block work-issue creation are flagged in `Open Decisions`

The following are **out of scope** for Phase 5 — they belong to the actual work:
- Variable / function / parameter names
- Exact method signatures
- Selection between equivalent small algorithms or libraries
- Pixel-level UI details, microcopy
- Micro-optimizations and implementation-time tradeoffs

Phase 5 first-pass workflow:
1. All components from Phase 4 have at least `index.md` + `design.md` meeting the checklist → **1st pass complete**
2. `interfaces/` defined (if applicable)
3. `cross-cutting/` documented (if applicable)
4. → Present to user: "First pass of detailed design is complete. Which components need deeper exploration?"
5. → Extend recursively **only on user request**
6. Recursive decisions, if any, have separate option files and a post-consensus `decision.md`

This prevents both over-specification and premature termination. The default depth is one level of detail. Deeper recursion is user-driven.

### Revisit Conditions
Phase 5 does not have a "revisit" in the traditional sense.
Instead, components are deepened on demand through recursive expansion.
If a fundamental issue is found, it triggers Phase 4 (skeleton change), Phase 3 (concept change), or Phase 2 (more research) revisit.
