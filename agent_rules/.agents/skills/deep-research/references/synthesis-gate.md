# Phase 5: Findings Synthesis and Gate Protocol

Objective: integrate findings into coherent insights.

Process:

1. Group by question.
2. Cross-validate consistency across sources.
3. Resolve contradictions (identify conflict, assess credibility, document rationale).
4. Extract patterns (themes, trends, relationships).
5. Generate insights (actionable conclusions).
6. Evaluate synthesis completeness (gate below).

Phase 4 iteration fills evidence gaps for already defined questions. Phase 5
replanning changes the plan only when synthesis reveals new questions,
unresolved contradictions, or scope gaps that could materially affect the
conclusion.

## Routing invariants

- Every Phase 4 pass must proceed to Phase 5. Do not run a second Phase 4 pass,
  create new questions, or mutate dependencies before the Phase 5 gate.
- Phase 4 may note missing evidence for an existing question. Only Phase 5 may
  decide the gap is material, and only Phase 2 may create/refine questions or
  change priorities/dependencies.
- Serialize the `synthesis_gate` block for every Phase 5 pass before
  transitioning. Do not replace it with prose, a renamed status, or an implicit
  transition.
- Enter Phase 6 only after a terminal Phase 5 gate with
  `status: complete` or `status: budget_exhausted`.

## Synthesis completeness gate

Evaluate after every synthesis, including the initial one and every post-replan
synthesis. A material condition is true when:

- A high-priority question is unanswered.
- Confidence for a recommendation-affecting conclusion is below 0.7.
- A high-credibility contradiction remains unresolved.
- Synthesis reveals a new question, dependency, or scope gap that could change
  the conclusion.
- Evidence is insufficient for an actionable recommendation.

Choose exactly one status and record the gate before transitioning:

- `complete`: no material condition remains. Record `Phase 5 -> Phase 6`.
- `replan`: material condition remains and iteration budget is available. Record
  affected question IDs, reasons, proposed follow-ups; decrement remaining
  budget; then record `Phase 5 -> Phase 2`.
- `budget_exhausted`: material condition remains and no budget is available.
  Record unresolved gaps and affected conclusions; then record
  `Phase 5 -> Phase 6` without returning to Phase 2.

After `replan`, Phase 2 rebuilds priorities, source mapping, and dependencies
for only affected/new questions. Continue canonically through Phases 3, 4, 5.
The next Phase 5 pass must emit a new gate; a prior `replan` gate cannot serve
as the terminal gate.

When terminal status is `budget_exhausted`, explicitly report unresolved gaps,
affected conclusions, and uncertainty in Phase 6. Do not present a
budget-limited conclusion as settled.

## Contradiction resolution matrix

| Source A Credibility | Source B Credibility | Resolution         |
| -------------------- | -------------------- | ------------------ |
| High                 | Low                  | Trust A, note B    |
| High                 | High                 | Investigate deeper |
| Medium               | Medium               | Present both views |
| Low                  | Low                  | Flag uncertainty   |

## Mandatory gate output

Emit this block in the trace/working output for every Phase 5 pass, even when
the user only asks for the final report. Keep field names and status values
exact so the transition is auditable.

```
- synthesized_findings:
    - question_id: string
      answer: string
      supporting_evidence: string[]
      confidence: 0.0-1.0
      contradictions_resolved: string[]
      gaps_remaining: string[]
- synthesis_gate:
    status: complete | replan | budget_exhausted
    reasons: string[]
    affected_question_ids: string[]
    proposed_follow_up_questions: string[]
    iteration_budget_remaining: number
    preserved_question_ids: string[]
    preserved_source_references: string[]
    transition: Phase 5 -> Phase 2 | Phase 5 -> Phase 6
```
