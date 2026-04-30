---
name: document-writer
description: >
  This skill should be used when the user asks to write, draft, or improve
  technical documentation for software projects. Common requests include
  "설계 문서 작성해줘", "기술 문서 만들어줘", "문서 작성", "API 문서 정리",
  "아키텍처 문서 작성", "write design doc", "draft technical documentation",
  "create architecture document", "write problem analysis doc".
  It covers planning/design documents, problem analysis documents, and
  structure/usage guides with a structured workflow from gathering through review.
---

# Document writing guideline
This guide helps to produce high-quality documentation for software projects, prioritizing clarity, completeness, and developer usability.

## Audience & Language
- Default to writing documentation in Korean unless the task explicitly specifies another language.
- Identify the target audience (e.g., backend engineers, product managers, end users) and tailor terminology, level of detail, and examples to their needs.

## Document Scope
Support the following documentation categories (and similar developer-focused outputs):
- Planning & design documents (system/service abstracts, architectural decisions, component responsibilities) — **Follow the template in `references/planning-design-template.md`**
- Problem analysis & solution documents (issue overviews, root cause analysis, mitigation plans, validation strategies)
- Structure & usage guides (library/tool overviews, API references, best practices, real-world usage scenarios)

## Working Principles
1. Lead with the final outcome: state what the reader will achieve or learn.
2. Apply "problem → solution → implementation" flow where applicable.
3. Use active voice, concise sentences, and consistent technical terminology.
4. Provide concrete examples, code snippets, diagrams, and tables to clarify complex topics.
5. Ensure every instruction or code sample is executable and verified.
6. Highlight key decisions (✅), deprecated items (~~strikethrough~~), and warnings (❗) for quick scanning.

## Structured Workflow
1. **Understand & Gather**
   - Confirm the documentation goal, audience, and constraints.
   - Collect existing specs, code references, designs, or discussions relevant to the topic.
2. **Organize & Outline**
   - Define a logical structure with clear headings and navigation.
   - Prioritize information by importance and reader tasks.
3. **Draft Content**
   - Write sections with explicit outcomes and actionable guidance.
   - Include step-by-step instructions, checklists, and decision points where useful.
   - Provide code blocks with syntax highlighting and real outputs.
4. **Review & Test**
   - Follow the instructions or examples exactly to validate accuracy.
   - Cross-check terminology consistency and update any stale information.
5. **Revise & Polish**
   - Tighten language, remove redundancy, and ensure sections can stand alone.
   - Add cross-links, diagrams, or tables if they improve comprehension.

## Quality Checklist
- [ ] Documentation is clear, concise, and audience-appropriate.
- [ ] Technical details are accurate, current, and verified.
- [ ] Structure supports quick navigation and independent section reading.
- [ ] Examples, code snippets, and diagrams work as described.
- [ ] Grammar, spelling, and formatting meet professional standards.
- [ ] Action items, decisions, and warnings are explicitly marked.

## Visual Aids
Visuals are far easier to understand than prose for architecture, flows, and relationships. **Actively include diagrams** wherever they help — but do not add them where a simple table or list is clearer.

- **Prefer Mermaid diagrams** (sequence, flowchart, C4, ER, state, etc.) as the default. They are version-controllable, diffable, and render natively in most Markdown viewers.
- **Use ASCII diagrams** only when Mermaid cannot express the layout well (e.g., free-form box-and-arrow overviews, tree structures).
- **When the user explicitly requests a richer visual**, prefer generating an SVG image over ASCII art.

## Delivery Format
- Provide well-structured Markdown with descriptive headings (##, ###), ordered/unordered lists, and tables when helpful.
- Use syntax-highlighted code blocks, annotated examples, and embedded links where necessary.
- End with metadata such as "Last updated: YYYY-MM-DD" and note any open questions or follow-up actions.
