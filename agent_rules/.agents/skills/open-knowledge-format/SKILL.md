---
name: open-knowledge-format
description: >
  Use this skill whenever the user asks to create, convert, enrich, review, or
  validate OKF or Open Knowledge Format content. Trigger for OKF, Open Knowledge
  Format, knowledge bundle, Markdown + YAML frontmatter knowledge base,
  agent-readable wiki, LLM wiki, web enrichment, citations, metrics, joins,
  reference docs, index.md, log.md, or validate OKF bundle. This skill focuses
  only on writing OKF-structured documents and safe web enrichment.
---

# Open Knowledge Format

Use this skill to produce or improve OKF bundles: portable Markdown file trees with YAML frontmatter, human-readable prose, citations, and concept links that agents can traverse.

## Core Mental Model

- Treat OKF as a file format, not a platform, SDK, runtime, service, or fixed taxonomy.
- A bundle is a directory tree of `.md` files. Each non-reserved Markdown file is one concept document.
- A concept ID is the bundle-relative path without `.md`, such as `tables/events` or `references/metrics/revenue`.
- Frontmatter carries lightweight machine-readable metadata. The body carries prose, schemas, examples, citations, and links.
- Links make the bundle graph-shaped. `index.md` files provide progressive disclosure for humans and agents browsing one level at a time.
- Web enrichment should add grounded context without destroying existing structure.

## Scope Boundaries

- Do not run external publishing, loading, or write operations unless the user explicitly asks for a separate task outside this skill.
- Treat databases, catalogs, APIs, docs sites, PDFs, and web pages as source material or citation targets only.
- When the user asks for operational setup, clarify that this skill can prepare or review OKF files, but not perform that workflow by default.

## Choose The Task Mode

1. Author mode
   Create new OKF concept docs, `index.md`, or `log.md` from source notes, code, schemas, docs, or user-provided context.

2. Convert mode
   Turn an existing Markdown wiki, docs folder, notes dump, or loose source material into an OKF bundle. Split by stable concepts, not by arbitrary page length.

3. Enrich mode
   Add web-derived context, citations, metric docs, dimension notes, join references, examples, or cross-links to an existing bundle while preserving existing structure.

4. Review mode
   Inspect an OKF bundle for conformance, practical compatibility, weak citations, broken links, reserved filename misuse, destructive rewrite risk, and missing navigation.

## Authoring Rules

- Every non-reserved `.md` concept should start with YAML frontmatter delimited by `---`.
- For OKF spec conformance, `type` is the only required key and it must be non-empty.
- For practical authoring compatibility, include `title`, `description`, and `timestamp` on concept docs unless the user explicitly wants the minimal spec form.
- Prefer this frontmatter order: `type`, `resource`, `title`, `description`, `tags`, `timestamp`, then extra keys.
- Preserve unknown frontmatter keys when editing existing docs. Unknown keys may be important to another producer or consumer.
- Use short descriptive type strings such as `Reference`, `Metric`, `Join`, `Schema`, `API Endpoint`, `Dataset`, `Runbook`, or project-specific terms. Do not assume a central type registry.
- Keep `tags` as a YAML list of strings.
- Use ISO 8601 timestamps for the last meaningful content change.
- `index.md` and `log.md` are reserved filenames. Do not treat them as concept docs.
- Use `index.md` for one-level navigation and `log.md` for chronological updates when useful.
- Put claims that depend on external evidence under `# Citations` or near the claim with a concrete source link.

Read `references/okf-authoring-checklist.md` before creating a new bundle, adding templates, or doing a non-trivial conversion.

## Link Policy

- Default to file-relative Markdown links because they work well in GitHub-style browsing and common local viewers.
- Use absolute bundle-relative links beginning with `/` only when the user asks for spec-strict or stable bundle-relative links, or when the target consumer expects them.
- Link only to concept docs that exist or are intentionally planned. If a link is broken, report it instead of silently inventing a target.
- Avoid links in headings, code blocks, and schema field-name listings. Link prose mentions where the relationship is clear.
- Do not self-link.

## Web Enrichment Rules

- Start from explicit user-provided URLs, local documents, or source files. Do not invent sources.
- Prefer authoritative, primary, stable sources over summaries, landing pages, or search-result snippets.
- Decide for each source whether to enrich an existing concept, create a new reference concept, or skip it.
- Preserve the full existing frontmatter dictionary unless the user asks for a cleanup.
- Merge tags instead of replacing them.
- Preserve existing top-level `#` headings in the same order and wording. Add new top-level sections after existing ones when necessary.
- Do not shrink existing schema sections, examples, or citations during enrichment.
- Extract reusable metrics, dimensions, enum definitions, and join paths into structured sections or `references/` concept docs when they are load-bearing across multiple concepts.
- Every extracted metric or join needs a citation to the source that justifies the definition or relationship.

Read `references/okf-web-enrichment-workflow.md` before enriching from web sources or splitting metrics, dimensions, joins, or reference docs.

## Review And Validation Rules

- Separate hard conformance failures from soft quality issues.
- Hard conformance checks: parseable frontmatter on non-reserved concept docs, non-empty `type`, reserved filename handling, and valid Markdown file placement.
- Soft quality checks: missing `title`, `description`, `timestamp`, weak descriptions, stale timestamps, weak citations, poor indexes, weak cross-links, and orphaned concepts.
- Broken links are allowed by the OKF spec, but report them with target path and source file so the user can decide whether they are planned or accidental.
- Report destructive rewrite risks when an edit would drop unknown frontmatter keys, remove headings, reduce schema coverage, or reduce citation coverage.

Read `references/okf-review-and-validation.md` before reviewing an existing bundle or producing a remediation plan.

## Output Patterns

When creating or editing files:

1. Inspect the existing bundle or source files first.
2. State any assumptions only when they affect structure, link strategy, or source trust.
3. Make the smallest coherent OKF change that satisfies the task.
4. End with changed files, conformance notes, practical compatibility notes, and unverified items.

When only answering or planning:

1. Explain the OKF structure in the user's language.
2. Use file paths and small templates when helpful.
3. Do not claim that OKF requires optional fields; distinguish spec requirements from practical compatibility.

## Common Pitfalls

- Confusing OKF with an ingestion platform or data catalog service.
- Treating `index.md` or `log.md` as ordinary concepts.
- Dropping unknown frontmatter keys during enrichment.
- Replacing an existing concept wholesale when a targeted section update would preserve more value.
- Creating reference docs for generic overview pages that do not define a reusable concept.
- Adding metrics or joins without a concrete cited source.
- Using absolute `/...` links by default when the bundle will mainly be browsed in GitHub.
