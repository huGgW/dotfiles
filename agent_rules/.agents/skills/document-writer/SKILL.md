---
name: document-writer
description: >
  This skill should be used whenever the user asks to write, draft, rewrite,
  organize, audit, or improve technical documentation for software projects.
  Common requests include "문서 작성", "기술 문서 만들어줘", "설계 문서 작성해줘",
  "API 문서 정리", "README 작성", "runbook 만들어줘", "온보딩 문서 작성",
  "아키텍처 문서 작성", "write documentation", "draft a README",
  "create API docs", "write a runbook", "improve this design doc", and
  "document this feature". Use this skill for README, API reference, runbook,
  tutorial, how-to guide, architecture, onboarding, design, and problem-analysis
  docs, even when the user does not name a documentation framework. It applies
  the Diataxis documentation model to select the reader need first, then drafts
  or revises the document with mode-specific guardrails and quality checks.
---

# Document Writer

Use this skill to create or improve technical documentation by matching the document to the reader's actual need. The operating model is Diataxis-first: classify the reader need before choosing structure, tone, examples, tables, or diagrams.

## Default Behavior

- Write documentation in Korean unless the user explicitly requests another language.
- Keep code, commands, identifiers, and code comments in English.
- Assume documentation may be reviewed together over screen sharing. Favor compact, scannable structure over long prose.
- In Korean documents, minimize English except where exact technical meaning requires it, such as code, commands, identifiers, API names, configuration keys, and product names. Prefer plain Korean over difficult Sino-Korean terms, translationese, or overly formal phrasing.
- If working inside a repository, inspect relevant source files, existing docs, configuration, or tests before writing factual technical content.
- Ask one concise clarification question only when the audience, use moment, or requested output is too ambiguous to choose a documentation mode safely. Otherwise, proceed and state assumptions at the end.
- Prefer the smallest useful documentation change when improving existing docs. Diataxis is a guide for better local decisions, not a reason to rewrite everything.

## Diataxis Compass

Before drafting, classify the document or section with two questions:

1. Is the reader trying to act or think?
2. Is the reader acquiring new capability or applying existing capability?

| Need | Mode | Reader question | Use this when |
| --- | --- | --- | --- |
| Action + acquisition | Tutorial | "Can you teach me to...?" | The reader needs a safe, guided learning experience. |
| Action + application | How-to guide | "How do I...?" | The reader is competent and needs to complete a real task. |
| Cognition + application | Reference | "What is...?" | The reader needs exact facts while working. |
| Cognition + acquisition | Explanation | "Why...?" | The reader needs context, background, or understanding. |

Do not treat README, API docs, runbooks, architecture docs, onboarding guides, design docs, or problem-analysis docs as primary modes. They are composite document patterns that may contain multiple Diataxis modes.

## Workflow

1. Define the reader and use moment.
   - Identify who reads the document, what they already know, what they are trying to do or understand, and when they read it.
   - Capture constraints such as output path, language, product area, deadline, required sources, or style requirements.

2. Classify the mode.
   - For a simple document, choose one primary mode.
   - For a composite document, classify each major section independently.
   - If helpful, create a compact section map: `Section | Reader need | Diataxis mode | Source material`.

3. Gather source material.
   - Use existing code, configuration, tests, API schemas, design notes, incidents, tickets, or prior docs as evidence.
   - Prefer links and citations to duplicated facts when duplication would become stale.
   - Do not invent commands, API fields, system behavior, ownership, SLAs, or operational procedures.

4. Draft or revise with mode-specific rules.
   - Use `references/diataxis-mode-guide.md` for non-trivial tutorial, how-to, reference, or explanation work.
   - Use `references/composite-doc-patterns.md` when the user asks for README, API docs, runbook, architecture, onboarding, design, or problem-analysis docs.
   - Keep each section locally pure. If a section needs a different mode, split it or link to a better location.

5. Verify functional quality.
   - Check accuracy, completeness for the chosen scope, executable examples, terminology consistency, prerequisites, version assumptions, and staleness risks.
   - Run commands or tests when feasible and safe. If not feasible, clearly state what was not verified.

6. Review deep quality.
   - Check whether the document fits the reader's need, preserves flow, anticipates likely next questions, and avoids mode contamination.
   - Check whether the document works when read together on a shared screen: compact sections, visible structure, and low scanning effort.
   - For Korean documents, check whether English terms and difficult phrasing can be reduced without losing technical precision.
   - Use `references/quality-checklists.md` before finalizing substantial docs or documentation reviews.

7. Deliver the result.
   - Provide the document or apply the file edits requested by the user.
   - End with concise notes only when useful: sources checked, assumptions, verification performed, and open gaps.

## Mode Quick Rules

| Mode | Optimize for | Include | Avoid |
| --- | --- | --- | --- |
| Tutorial | Successful learning experience | Guided steps, visible progress, expected output, things to notice | Options, digressions, troubleshooting matrices, broad explanation |
| How-to guide | Real task completion | Preconditions, executable steps, branches, checks, rollback or next action when relevant | Teaching basics, exhaustive reference, product-feature tours |
| Reference | Accurate lookup during work | Parameters, fields, commands, behavior, limits, defaults, errors, concise examples | Narrative, rationale, task walkthroughs, opinions |
| Explanation | Understanding and context | Background, reasons, trade-offs, design intent, implications, alternatives | Step-by-step procedures, exhaustive option lists, operational checklists |

## Composite Documents

Use document-type labels as practical patterns, not as substitutes for Diataxis classification.

- README: landing page plus selected tutorial, how-to, reference, and explanation sections.
- API documentation: mostly reference, with concise illustrative examples and links to task guides.
- Runbook: operational how-to, supported by brief reference facts and escalation criteria.
- Architecture document: mostly explanation, with diagrams or decision/reference tables only when they clarify the system.
- Onboarding guide: tutorial sequence plus explanation map and links to reference material.
- Design or problem-analysis document: explanation of context and trade-offs, plus decision reference and implementation follow-ups where needed.

Read `references/composite-doc-patterns.md` before drafting these document types from scratch.

## Formatting Principles

- Choose headings that match the reader's task or question, not generic template slots.
- Keep shared-screen readability in mind: prefer short sections, short paragraphs, bullets, tables, and diagrams when they help readers follow the document quickly.
- Prefer bullet points when sentences become long, contain multiple ideas, or need to separate conditions, caveats, or action items.
- Use tables for compact comparisons, option matrices, API/field references, decision catalogs, and status summaries.
- Prefer tables when each item has several short attributes, such as status, owner, scope, default, constraint, option, or comparison point.
- Avoid tables for long rationale, code-heavy walkthroughs, nested detail, or prose that wraps heavily on mobile.
- If table cells require long prose, use bullets or short sections instead.
- Use diagrams only when they reduce cognitive load. Prefer Mermaid for architecture, sequence, flow, ER, state, and dependency diagrams when Markdown rendering supports it.
- Keep examples concrete and runnable. Show expected output when it helps the reader know they are on track.
- Do not add decorative markers, forced metadata, or boilerplate sections unless the user or repository convention requires them.

## Anti-Patterns To Catch

- Mixing tutorial and how-to because both contain steps. A tutorial teaches; a how-to helps a competent user finish work.
- Turning a how-to guide into a product-feature tour. A how-to is organized around the user's goal, not the machinery.
- Expanding reference into explanation. Reference should describe facts with precision and consistency.
- Turning explanation into a procedure. Explanation should connect ideas and answer why, not instruct the reader through a task.
- Creating empty top-level `Tutorials / How-to / Reference / Explanation` boxes without evidence that the structure helps readers.
- Forcing a planning/design template onto every design problem.
- Adding diagrams, tables, examples, or decision catalogs because they look professional rather than because they improve use.
- Duplicating volatile technical facts across documents instead of linking to the authoritative source.
