# Documentation Quality Checklists

Use these checklists before finalizing substantial documentation or when reviewing existing documentation.

## Functional Quality

Functional quality is about whether the document is technically correct and usable within its stated scope.

Check:

- Accuracy: commands, APIs, configuration, examples, diagrams, and descriptions match the actual system.
- Completeness for scope: the reader has enough information to satisfy the chosen need without unnecessary coverage.
- Consistency: terminology, names, versions, paths, and concepts match the repository and related docs.
- Precision: requirements, defaults, limits, failure modes, and side effects are specific.
- Executability: steps can be followed, examples run, and expected outputs are shown where useful.
- Preconditions: required permissions, environment, dependencies, versions, and risks are stated.
- Freshness: volatile facts link to authoritative sources instead of being duplicated.
- Safety: destructive, security-sensitive, or production-impacting actions are clearly bounded.
- Source traceability: important facts can be traced to code, config, tests, specs, issues, or prior docs.

## Deep Quality

Deep quality is about fit to human need. A document can be accurate and still feel bad if it fights the reader's situation.

Check:

- Reader fit: the assumed skill level matches the actual audience.
- Use moment: the document works where it will be read, such as during work, during learning, or during reflection.
- Flow: the next needed information appears before the reader has to hunt for it.
- Cognitive load: the document avoids unnecessary branching, formatting, tables, diagrams, and digressions.
- Anticipation: likely next questions are answered or linked without derailing the current mode.
- Confidence: the reader can tell when they are done, successful, or ready to continue elsewhere.
- Navigability: headings, anchors, and links support scanning without replacing the substance.

## Mode-Specific Quality

Tutorial:

- The path is safe, concrete, and reliable.
- The reader sees visible progress early.
- Expected outputs or checks are present.
- Options and alternatives are minimized.
- Explanation is short or linked out.

How-to guide:

- The title and structure reflect a real user goal.
- Prerequisites are clear.
- Steps are executable and ordered by the user's workflow.
- Branches reflect real decision points.
- Verification, rollback, cleanup, or escalation are included when relevant.

Reference:

- Similar things follow the same structure.
- Required fields, defaults, limits, errors, and behavior are explicit.
- Examples illustrate facts without turning into tutorials.
- The organization mirrors the machinery or domain model.
- There is no unnecessary rationale or narrative.

Explanation:

- The section answers a bounded why/context question.
- Concepts, constraints, and consequences are connected.
- Trade-offs and alternatives are clear.
- Opinion or perspective is identified through reasoning.
- Procedures and exhaustive tables are moved or linked elsewhere.

## Mode Contamination Review

Ask these questions section by section:

- Is this section trying to teach, direct work, describe facts, or explain why?
- Does the heading promise one mode while the body delivers another?
- Would a reader in the intended situation welcome this content right now?
- Should this content be split, shortened, or linked because it serves a different need?

Common fixes:

- Move background paragraphs from a how-to into an explanation link.
- Move option lists from a tutorial into reference.
- Move task sequences from explanation into a how-to guide.
- Move rationale from reference into explanation.
- Split a mixed README section into quick start, common tasks, configuration, and background.

## Existing Documentation Improvement Loop

Use small, responsive improvements instead of defaulting to broad rewrites.

1. Choose one document or section.
2. Identify the reader and use moment.
3. Classify the current and intended Diataxis mode.
4. Find the most harmful mismatch or quality gap.
5. Make one coherent improvement.
6. Verify facts and examples.
7. Repeat if the next improvement is still in scope.

## Tables And Diagrams

Use tables when they make comparison or lookup easier:

- API fields, options, limits, and errors.
- Short decision comparisons.
- Status, ownership, and follow-up tracking.
- Compatibility or support matrices.

Avoid tables when:

- Cells require long prose or nested lists.
- The content is a narrative, tutorial, or rationale.
- Code blocks or commands dominate the content.
- The table will wrap heavily on mobile.

Use diagrams when they reduce explanation cost:

- Architecture boundaries.
- Data flow or control flow.
- Sequence of interactions.
- State transitions.
- Entity relationships.

Avoid diagrams when:

- A short paragraph or list is clearer.
- The diagram duplicates nearby text without adding structure.
- Maintaining it would be harder than maintaining the source facts.

## Final Delivery Notes

Include concise notes only when they help the user trust or continue the work:

- Sources checked.
- Assumptions made.
- Verification performed or skipped.
- Known gaps or follow-up questions.

Do not add boilerplate metadata, decorative markers, or long self-review sections unless the user asked for them or the repository convention requires them.
