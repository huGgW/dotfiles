# Phases 1-4: Query Analysis through Research Execution

## Phase 1: Query Analysis

Objective: clarify research intent and establish scope.

Process:

1. Assess query clarity (score 0.0-1.0).
2. Identify ambiguities and generate clarification questions if score < 0.7.
3. Define scope boundaries.
4. Determine depth level (see SKILL.md).
5. Document clarified objectives.

Clarity assessment (+0.2 each): specific objectives present, scope well-defined,
technical terms used correctly, measurable outcomes specified, time/context
constraints clear.

Output:

```
- clarified_query: string
- depth_level: quick | standard | deep
- scope_boundaries: string[]
- key_entities: string[]
```

Skip clarification when: query has specific measurable objectives, scope is
well-defined, technical terms are correct, and intent is unambiguous.

## Phase 2: Research Planning

Objective: generate structured research questions and identify sources.

Process:

1. Decompose into hierarchical questions: primary (1), secondary (2-5),
   detail questions as needed per secondary.
2. Map information sources per question.
3. Prioritize by importance and dependencies.

Replanning entry from Phase 5:

- Record the canonical transition `Phase 5 -> Phase 2` before changing the plan.
- Preserve existing questions, findings, source links, and resolved conclusions.
- Convert only material synthesis gaps into new or refined questions.
- Recalculate priorities and dependencies for affected questions.
- Avoid repeating completed research unless new evidence invalidates it.
- Build the next plan from the remaining iteration and source budget.
- Record affected question IDs, still-valid source IDs/links, and question-graph changes.

Question types: Definition (What is X?), Comparison (A vs B?), Relationship
(X affects Y?), Evaluation (pros/cons?), Implementation (apply X in Y?).

Source mapping:

| Question Type  | Preferred Sources                          |
| -------------- | ------------------------------------------ |
| Definition     | Official docs, academic papers             |
| Comparison     | Reviews, benchmarks, case studies          |
| Relationship   | Research papers, expert analysis           |
| Evaluation     | User reports, case studies, expert opinion |
| Implementation | Technical docs, code repos, tutorials      |

Output:

```
- research_questions:
    - id: string
      question: string
      type: definition | comparison | relationship | evaluation | implementation
      priority: high | medium | low
      source_types: string[]
      dependencies: string[] (question ids)
```

## Phase 3: Strategy Development

Objective: execution plan optimized for available resources.

Process:

1. Determine pattern: Sequential (dependencies exist), Parallel
   (independent), Hybrid (mix from dependency graph).
2. Allocate resource budget per question.
3. Set quality checkpoints.

Execution patterns:

```
Sequential:   Q1 → Q2 → Q3 → Q4
Parallel:     Q1 ─┬─→ Synthesis
              Q2 ─┤
              Q3 ─┤
              Q4 ─┘
Hybrid:       Q1 → Q2 ─┬─→ Synthesis
                      Q3 ─┤
                      Q4 ─┘
```

Resource budget by depth:

| Depth    | Max Sources per Question | Iteration Limit |
| -------- | ------------------------ | --------------- |
| quick    | 3                        | 1               |
| standard | 5                        | 2               |
| deep     | 10                       | 3               |

The initial Phase 4 pass consumes the first iteration. Each complete
`Phase 5 -> Phase 2 -> Phase 3 -> Phase 4 -> Phase 5` cycle consumes one
additional iteration; do not double-count replanning plus research pass. Record
`iteration_budget_remaining` in every Phase 5 gate. Preserve completed work so
budget is spent only on unresolved or new questions.

Output:

```
- execution_plan:
    - pattern: sequential | parallel | hybrid
    - phases:
        - phase_id: string
          questions: string[]
          parallel: boolean
    - total_budget: number
```

## Phase 4: Research Execution

Objective: research across multiple dimensions.

Dimensions:

1. Academic: theory, peer-reviewed findings, methodologies, citation chains.
2. Web: current events/trends, industry reports, expert opinions, real-world use.
3. Technical: implementation patterns, architecture decisions, code examples,
   best practices.
4. Data analysis (when applicable): metrics, benchmarks, statistics, performance.

### Measurement semantics (when relevant)

For metrics, benchmark, or capacity questions, capture the context needed to
interpret or compare the numbers: units, population/denominator, time window
and timezone, aggregation, sampling and missing-data coverage, and measurement
start/end boundaries. Distinguish the target outcome from a proxy and label
values as observed, synthetic, calculated, or assumed as appropriate. Missing
context is a limitation, not permission to invent it or treat unlike measures
as equivalent. Keep this proportional to the question; it is not a universal
finding schema or an extra source quota. For useful analysis when exact
reproduction is unavailable, see the conditional-analysis guidance in
`synthesis-gate.md`.

Evidence gap handling: record the gap against the existing question without
creating a new question, finish the current pass, proceed to Phase 5 for
materiality assessment. Phase 4 must not launch its own additional pass. New
questions, dependency, or priority changes go through the Phase 5 gate and
Phase 2 replanning entry.

Finding documentation:

```
- finding_id: string
- question_id: string
- content: string
- source:
    - type: academic | web | technical | data
    - url: string
    - credibility: high | medium | low
    - date: string
- confidence: 0.0-1.0
- related_findings: string[]
```
