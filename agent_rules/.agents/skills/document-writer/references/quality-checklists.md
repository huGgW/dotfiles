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
- Shared-screen fit: the document can be followed during live review without burying key points in long prose.
- Flow: the next needed information appears before the reader has to hunt for it.
- Cognitive load: the document avoids unnecessary branching, formatting, tables, diagrams, and digressions.
- Information density: each passage improves the reader's understanding, decision, or action rather than adding ornamental framing, repetition, inflated importance, or unrelated background.
- Representation fit: prose, bullets, steps, tables, diagrams, screens, and examples match the shape of the information instead of following one default format.
- Scannability: independent ideas are separated when that helps scanning, while connected causality, rationale, and trade-offs remain readable as continuous reasoning.
- Visual utility: diagrams, screens, and examples expose useful structure or replace difficult explanation instead of duplicating nearby text.
- Language fit: Korean documents minimize unnecessary English and difficult phrasing without losing technical precision.
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
5. Decide whether content, order, representation, or wording causes the gap.
6. Make one coherent improvement.
7. Verify facts and examples.
8. Repeat if the next improvement is still in scope.

## Representation Choice

Use prose when continuity carries meaning:

- Causes, consequences, rationale, and trade-offs.
- Background that must connect several concepts.
- Explanations where isolated bullets would obscure the argument.

Use numbered steps for ordered actions where sequence matters.

Use bullets when ideas are independent or need to be checked separately:

- Conditions, caveats, risks, and action items.
- Parallel alternatives, findings, statuses, or constraints.
- Ideas where the reader needs to pause at each point rather than follow one connected argument.

Use tables when they make comparison or lookup easier:

- API fields, options, limits, and errors.
- Short decision comparisons.
- Status, ownership, and follow-up tracking.
- Compatibility or support matrices.
- Items that each have several short attributes, such as status, owner, scope, default, constraint, option, or comparison point.

Avoid tables when:

- Cells require long prose or nested lists.
- The content is a narrative, tutorial, or rationale.
- Code blocks or commands dominate the content.
- The table will wrap heavily on mobile.
- Bullets or short sections would preserve meaning with less visual strain.

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

Use example screens or wireframes when spatial layout or user interaction is part of what the reader must understand:

- Use verified captures when the actual product state matters.
- Use clearly labeled wireframes for proposed, unavailable, or variable interfaces.
- Do not present invented UI details as current product behavior.

Use concrete examples and expected output when the reader needs to recognize correct system behavior. Avoid examples that add volume without clarifying use, constraints, or results.

## Korean Readability

For Korean documents, check:

- English terms are used only when needed for exact technical meaning, such as code, commands, identifiers, API names, configuration keys, product names, or unavoidable industry terms.
- Plain Korean is preferred over difficult Sino-Korean terms, translationese, or overly formal phrasing.
- Unavoidable English terms are introduced with enough context for the intended reader.
- Natural Korean word order is preserved instead of mirroring English sentence structure.

## Final Delivery Notes

Include concise notes only when they help the user trust or continue the work:

- Sources checked.
- Assumptions made.
- Verification performed or skipped.
- Known gaps or follow-up questions.

Do not add boilerplate metadata, decorative markers, or long self-review sections unless the user asked for them or the repository convention requires them.
