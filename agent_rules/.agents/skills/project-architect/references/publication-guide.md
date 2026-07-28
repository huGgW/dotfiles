# Publication Guide

Use this guide when Project Architect turns agreed internal design artifacts into an externally shareable standalone document.

Publication output is a derived view. It is not a sixth design phase, an OKF design bundle, or an authoritative source for design decisions.

## When to Publish

Create or update a publication document only when the user requests an external-facing artifact and the audience, purpose, scope, language, and disclosure boundary are known.

Use only:

- Design content that has passed the relevant consensus gate
- Verified technical facts from the current codebase or other authoritative sources
- Public external references suitable for the intended audience

Do not present unresolved options, provisional directions, invalidated content, or update-needed artifacts as final. If publication feedback changes the design, return to the relevant internal discussion and consensus cycle first.

## Directory Contract

Use one kebab-case subdirectory per document at the project-root `output/` path:

```text
output/
└── {document-slug}/
    ├── {document-slug}.md
    ├── internal-source-map.md
    └── assets/                         # optional
```

Rules:

1. Name the primary document `{document-slug}.md`; do not use `index.md`.
2. Treat the primary document and public-safe files listed in the source map as the only shareable artifacts.
3. Keep `internal-source-map.md` in the document directory, but never link it from the primary document or include it in the shareable allowlist.
4. Put images or exported diagrams in `assets/` only when the primary document uses them. Keep asset paths within the document directory and do not use `../` links.
5. Do not apply Project Architect OKF frontmatter to publication files unless the user explicitly requests OKF output.

## Publication Workflow

### 1. Confirm the publication contract

Confirm or derive from the user's request:

- Audience and existing knowledge
- Use moment and reader goal
- Document title and slug
- Scope and expected depth
- Language and tone
- Public disclosure boundary

Ask only when a missing answer would materially change the document. Do not reopen settled design discussions merely because a publication was requested.

### 2. Select eligible sources

Read the smallest set of current design artifacts needed to support the document. Exclude internal discussion history, rejected option details that the audience does not need, unresolved decisions, and sensitive operational information outside the approved scope.

Create or update `internal-source-map.md` before drafting so the source boundary is explicit.

### 3. Apply Document Writer

Load and apply the `document-writer` skill before outlining or drafting the primary document.

- Organize the document around the external reader's questions, not the internal Phase order.
- Select the Diataxis mode for the document and major sections.
- Use short sections, compact paragraphs, lists, tables, and diagrams according to reader need.
- Include enough background and rationale for the document to stand alone.
- Avoid fixed metadata or boilerplate that does not help the reader.

### 4. Draft and verify technical meaning

Draft from eligible sources while preserving facts, decisions, scope boundaries, uncertainty, obligations, terminology, metrics, and causal relationships.

Do not cite internal design artifacts in the primary document. Instead, include the essential explanation directly. Public external sources may be cited for verification or deeper reading.

### 5. Apply Humanizer

After the full technical draft is complete, load and apply the `humanizer` skill to the entire primary document.

- Preserve technical meaning and the intended professional register.
- Remove inflated claims, formulaic transitions, repetitive structure, vague attribution, filler, and translationese.
- For Korean documents, apply the Korean-specific guidance referenced by the Humanizer skill.
- Do not invent examples, evidence, dates, metrics, outcomes, or reader reactions.

Any later content revision to the primary document must repeat the Document Writer, technical verification, and Humanizer sequence. A source-map-only metadata update does not require rewriting the primary document.

### 6. Verify and mark current

Run the verification checklist below. Mark the source map `Current` only after all required checks pass. Otherwise use `Draft`, `Stale`, or `Blocked`.

## Readability and Compression

- Start with what the intended reader needs to understand or decide.
- Keep one primary idea per paragraph and remove repeated facts or rationale.
- Prefer a table when several items share the same short attributes. Use prose for nuanced rationale that would wrap heavily in cells.
- Define acronyms on first use and keep terminology consistent.
- Do not reproduce the internal design tree, discussion chronology, or exhaustive option history.
- Keep a fact in one primary representation. A diagram, table, and paragraph should not repeat the same information without adding distinct value.
- Remove sections that exist only because an internal template had them.

## Visual Material

Evaluate visual material for every non-trivial publication document. Use it when it reduces the reader's effort to understand a relationship, sequence, state transition, lifecycle, comparison, or system boundary.

- Prefer Mermaid for architecture, flow, sequence, state, and entity-relationship diagrams when the target Markdown renderer supports it.
- Prefer a compact comparison table for options with common evaluation dimensions.
- Use `assets/` for exported diagrams or images that must travel with the document.
- Give each visual a clear purpose and a nearby sentence stating its main takeaway or suitable alt text.
- Do not add decorative visuals. If removing a visual loses no useful understanding, remove it.
- Record each visual's purpose, takeaway, and source in `internal-source-map.md`.

## Standalone and Leakage Rules

The primary document must remain understandable when shared by itself. It must not expose or require:

- `design/` paths, repository absolute paths, `file://` URLs, or parent-directory links
- Internal Phase directory names or statements such as "Phase 4 decided"
- `plan.md`, `decisions.md`, `log.md`, option files, decision files, or other internal artifact names
- Internal decision IDs, source revisions, issue IDs, prompts, discussion summaries, or feedback provenance unless explicitly approved for disclosure
- `internal-source-map.md` or phrases directing the reader to an internal source map
- Unresolved or stale content presented as final
- Secrets, credentials, private URLs, or internal-only system identifiers outside the approved scope

Apply the same leakage check to Mermaid labels, SVG comments, image metadata when inspectable, captions, and alt text.

## Internal Source Map

Use this Markdown structure and omit rows or sections that do not apply:

```markdown
# Internal Source Map

> INTERNAL - DO NOT SHARE. This file contains internal design provenance.

## Document

- **Slug**: {document-slug}
- **Primary file**: `{document-slug}.md`
- **Title**: {document title}
- **Audience**: {audience}
- **Purpose**: {reader goal and use moment}
- **Language**: {language}
- **Status**: Draft / Current / Stale / Blocked
- **Last verified**: YYYY-MM-DDTHH:MM:SSZ / Not verified

## Shareable Files

- `{document-slug}.md`
- `assets/{file}`

## Internal Sources

| Source path | Relevant content | Revision / hash | Eligibility | Last checked |
|---|---|---|---|---|
| `design/{path}.md` | {sections, claims, or decisions used} | {revision or hash when available} | Agreed / Verified | YYYY-MM-DD |

## Section Mapping

| Output section | Internal sources | Notes |
|---|---|---|
| {heading} | `design/{path}.md` | {transformation or compression note} |

## Visuals

| Visual | Purpose | Main takeaway | Internal sources |
|---|---|---|---|
| {Mermaid heading or asset path} | {why it helps} | {what the reader should see} | `design/{path}.md` |

## Exclusions

| Source content | Reason excluded |
|---|---|
| {path and section} | Unresolved / Internal-only / Out of scope / Sensitive |

## Workflow

| Step | Status | Completed at | Notes |
|---|---|---|---|
| Document Writer | Complete / Pending | {timestamp} | {mode and structure notes} |
| Technical verification | Complete / Pending | {timestamp} | {checks performed} |
| Humanizer | Complete / Pending | {timestamp} | {language and tone notes} |
| Final verification | Complete / Pending | {timestamp} | {result or blocker} |
```

The source map is operational metadata, not an OKF concept document. Do not add it to the publication document or its references.

## Invalidation and Refresh

When an internal artifact changes:

1. Search publication source maps for the affected source path.
2. Mark each mapped publication `Stale` before assessing the change.
3. If meaning changed, complete the internal design consensus and artifact update first, then refresh the primary document through the full publication workflow.
4. If only formatting changed, verify that meaning is unchanged, update the source record, and rerun final verification.
5. If a source disappeared, moved without a known replacement, or lost its consensus status, mark the publication `Blocked`.
6. Mark the publication `Current` only after the source map and primary document agree and all checks pass.

Do not place internal invalidation markers or change history in the primary publication document. Publication-only wording or layout edits do not belong in the internal `design/log.md` unless they change design meaning.

## Verification Checklist

- [ ] The directory is `output/{document-slug}/` and the primary file is `{document-slug}.md`.
- [ ] `internal-source-map.md` exists, is marked internal, and is absent from the shareable allowlist.
- [ ] Every listed shareable file exists inside the document directory.
- [ ] Every design-derived statement is traceable through the source map to eligible current sources.
- [ ] The primary document preserves facts, decisions, boundaries, uncertainty, obligations, terminology, and metrics.
- [ ] The primary document contains enough context to stand alone.
- [ ] The primary document and public assets contain no internal paths, artifact names, provenance, or source-map references.
- [ ] Local links stay inside the document directory, do not use `../`, and target shareable files only.
- [ ] Tables and visuals reduce cognitive load rather than decorate or duplicate prose.
- [ ] Visuals have a purpose, takeaway or alt text, and source mapping.
- [ ] The complete primary draft passed Document Writer, technical verification, and Humanizer in that order.
- [ ] The source map status is `Current` only after final verification passes.
