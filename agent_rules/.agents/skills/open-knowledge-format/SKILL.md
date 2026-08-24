---
name: open-knowledge-format
description: >
  Use this skill whenever the user asks to create, convert, enrich, review, or
  validate OKF or Open Knowledge Format content. Trigger for OKF, Open Knowledge
  Format, knowledge bundle, Markdown + YAML frontmatter knowledge base,
  agent-readable wiki, LLM wiki, OKF v0.1 migration, OKF v0.2 provenance,
  trust metadata, Attested Computation, web enrichment, citations, metrics,
  joins, reference docs, index.md, log.md, or validate OKF bundle. This skill
  focuses on writing and reviewing OKF-structured bundles without executing or
  publishing them.
---

# Open Knowledge Format

Use this skill to produce or improve OKF v0.2 bundles while continuing to read
v0.1 bundles safely. Treat the canonical specification as authoritative:
<https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md>.

## Core Mental Model

- Treat OKF as a file format, not a platform, SDK, runtime, service, or fixed taxonomy.
- A bundle is a directory tree of `.md` files. Each non-reserved Markdown file is one concept document.
- A concept ID is the bundle-relative path without `.md`, such as `tables/events` or `references/metrics/revenue`.
- Frontmatter carries machine-readable identity, provenance, trust, and lifecycle signals. The body carries prose, schemas, examples, per-claim attribution, and links.
- Links make the bundle graph-shaped. `index.md` files provide progressive disclosure for humans and agents browsing one level at a time.
- A bundle may also contain files referenced by an Attested Computation, such as SQL or deterministic attester code. Those files are artifacts, not concept documents.
- Web enrichment should add grounded context without destroying existing structure or overstating trust.

## Scope Boundaries

- Do not run external publishing, loading, or write operations unless the user explicitly asks for a separate task outside this skill.
- Treat databases, catalogs, APIs, docs sites, PDFs, and web pages as source material or citation targets only.
- OKF records how an Attested Computation is executed and checked; it does not execute the computation or store runtime receipts and verdicts.
- Do not author a supposedly sanctioned computation, executor, attester, source credibility signal, or verification event without authoritative input.
- When the user asks for operational setup or executable code, separate that work from the OKF authoring task and use the applicable workflow.

## Choose The Task Mode

1. Author mode
   Create new OKF concept docs, `index.md`, or `log.md` from source notes, code, schemas, docs, or user-provided context.

2. Convert or migrate mode
   Turn existing material into an OKF v0.2 bundle or explicitly migrate v0.1 concepts. Split by stable concepts, not by arbitrary page length.

3. Enrich mode
   Add grounded context, structured sources, metrics, dimensions, joins, examples, or cross-links while preserving existing structure and trust history.

4. Review mode
   Inspect a bundle for baseline conformance, v0.2 contract violations, migration issues, weak provenance, broken links, reserved filename misuse, destructive rewrite risk, and missing navigation.

## Version Compatibility

- Author new concepts as v0.2. Do not emit legacy `timestamp` or a new body `# Citations` list.
- Read v0.1 concepts as valid legacy input. Their `timestamp` and `# Citations` are not baseline conformance failures.
- Detect capabilities from fields. A missing root `okf_version` does not prove that a bundle is v0.1.
- Prefer `generated.at` when `generated` exists; fall back to legacy `timestamp` only when `generated` is absent.
- Prefer `sources` for provenance when present; fall back to a legacy `# Citations` section only when `sources` is absent.
- When both new and legacy forms exist, use the v0.2 form as authoritative but
  preserve legacy content unless the user requests migration.
- Do not migrate v0.1 content merely because a safe mapping appears possible.
  Migrate only when the user requests migration or the requested edit directly
  targets a legacy field; complete mapping is a safety requirement, not
  authorization to broaden the change.

Read `references/okf-v0.1-to-v0.2-migration.md` before migrating a bundle or editing a concept that contains legacy fields.

## Authoring Rules

- Every non-reserved `.md` concept starts with parseable YAML frontmatter delimited by `---`.
- `type` is the only always-required key and must be non-empty. Do not make optional v0.2 families baseline requirements.
- For useful new concepts, include `title` and `description`. Include `resource` when the concept describes a canonical asset and `tags` when they improve retrieval.
- Record derived materials in `sources`; do not overload the concept's canonical `resource` with an enrichment page URL.
- For agent-generated content that has not been reviewed, write `status: draft`. Omitted `status` means `stable`.
- Add `generated` when the actor is known. Never invent an actor merely to populate the field.
- Prefer this frontmatter order: `type`, `title`, `description`, `resource`, `tags`, `status`, `generated`, `verified`, `stale_after`, `sources`, `usage_window`, type-specific fields, then producer extensions.
- Preserve unknown frontmatter keys when editing existing docs. Unknown keys may be important to another producer or consumer.
- Use short descriptive type strings such as `Reference`, `Metric`, `Join`, `Schema`, `API Endpoint`, `Dataset`, `Runbook`, or `Attested Computation`. Do not assume a central type registry.
- Keep `tags` as a YAML list of strings.
- Every timestamp-valued OKF field uses an ISO 8601 datetime with an explicit UTC offset, such as `2026-08-21T10:00:00Z`. Date-only values are for `log.md` headings, not frontmatter timestamps.
- Follow the actor convention: `<producer>/<version>` for agents or tools, `human:<id>` for people, and `process:<id>` for automated processes.
- Never create `verified` without evidence that the named actor performed the check. Never invent `usage_count`, `last_modified`, `usage_window`, or `stale_after`.

Read `references/okf-authoring-checklist.md` before creating a new bundle, adding templates, or doing a non-trivial conversion.

## Provenance And Trust

- Each `sources` entry requires `resource`. Add a stable `id` when the body attributes a claim to that source.
- Attribute a claim with a Markdown footnote whose label equals `sources[].id`, such as `[^revenue-policy]`.
- When any source has `usage_count`, frame it with the shared `usage_window` or
  that source's own override.
- Do not create a `# Citations` section in a new v0.2 concept. The footnote prose labels a claim; the matching `sources` entry carries the structured source.
- Treat `generated` as the producer and last meaningful content change. Refresh it on a meaningful edit when the current actor is known.
- Preserve existing `verified` events. If the latest `generated.at` is newer than the latest `verified.at`, report that the current content needs re-verification rather than fabricating a new event.
- Derive trust as unverified when `verified` is absent, machine-confirmed when only non-`human:` actors verified, and human-reviewed when any verifier uses `human:`.
- Treat `verified` as document-level confirmation and attestation as per-run evidence; they are not interchangeable.

## Link Policy

- The v0.2 specification recommends absolute bundle-relative links beginning with `/` because they remain stable when a document moves.
- For bundles primarily browsed as plain files or on GitHub, prefer file-relative links because root-absolute links do not resolve as bundle links there. This is a consumer-specific authoring policy, not a conformance rule.
- When the target consumer is unknown, state the chosen strategy if it materially affects portability; otherwise preserve the bundle's established link style.
- Path-valued fields accept absolute URLs, bundle-relative paths beginning with `/`, or relative paths. A `sources[].resource` may instead be a scope descriptor.
- Link only to concept docs that exist or are intentionally planned. If a link is broken, report it instead of silently inventing a target.
- Avoid links in headings, code blocks, and schema field-name listings. Link prose mentions where the relationship is clear.
- Do not self-link.

## Web Enrichment Rules

- Start from explicit user-provided URLs, local documents, or source files. Do not invent sources.
- Prefer authoritative, primary, stable sources over summaries, landing pages, or search-result snippets.
- Decide for each source whether to enrich an existing concept, create a new reference concept, or skip it.
- Preserve the full existing frontmatter dictionary unless the user asks for a cleanup.
- Merge tags instead of replacing them.
- Merge `sources` by stable identity instead of replacing or shrinking the list.
- Preserve existing top-level `#` headings in the same order and wording. Add new top-level sections after existing ones when necessary.
- Do not shrink existing schema sections, examples, source coverage, or legacy citation coverage during enrichment.
- Extract reusable metrics, dimensions, enum definitions, and join paths into structured sections or `references/` concept docs when they are load-bearing across multiple concepts.
- Every extracted metric or join needs a `sources` entry and claim-level attribution to the source that justifies the definition or relationship.

Read `references/okf-web-enrichment-workflow.md` before enriching from web sources or splitting metrics, dimensions, joins, or reference docs.

## Attested Computation Rules

- Model a sanctioned computation as its own `type: Attested Computation` concept and link narrative metrics or reports to it.
- Require `runtime` for this type. Keep runtime and typed `parameters` together because runtime defines binding semantics.
- Provide the computation either as one fenced block under `# Computation` or through the `computation` path, not both.
- Treat `executor.receipt` as the declared evidence returned by a run and `attester.resource` as deterministic, no-LLM checking code.
- Do not store runtime receipts or verdicts in the bundle and do not execute the contract as part of authoring.

Read `references/okf-attested-computation.md` before authoring, changing, or validating this concept type.

## Reserved Files

- `index.md` and `log.md` are reserved at every level and are never concept documents.
- An `index.md` contains no frontmatter except that the bundle-root `index.md` may contain only `okf_version: "0.2"` metadata. Use it for one-level progressive disclosure.
- A `log.md` has no concept frontmatter. Group flat prose entries under `YYYY-MM-DD` headings in newest-first order.

## Review And Validation Rules

- Separate baseline conformance failures, v0.2 contract violations, migration issues, and quality or trust issues.
- Baseline conformance checks cover parseable concept frontmatter, non-empty `type`, and reserved-file structure.
- Conditional contract checks cover the shape of v0.2 families when present, including required nested fields and `runtime` for Attested Computation.
- Migration issues include legacy fields that are valid input but should not be emitted for new v0.2 concepts.
- Quality and trust checks cover missing useful metadata, weak descriptions, ungrounded claims, stale concepts, verification older than generation, poor indexes, weak cross-links, and orphaned concepts.
- Broken links are allowed by the OKF spec, but report them with target path and source file so the user can decide whether they are planned or accidental.
- Report destructive rewrite risks when an edit would drop unknown frontmatter keys, remove headings, reduce schema coverage, or reduce citation coverage.

Read `references/okf-review-and-validation.md` before reviewing an existing bundle or producing a remediation plan.

## Output Patterns

When creating or editing files:

1. Inspect the existing bundle or source files first.
2. State any assumptions only when they affect structure, link strategy, or source trust.
3. Make the smallest coherent OKF change that satisfies the task.
4. End with changed files, version compatibility, conformance notes, provenance or trust notes, and unverified items.

When only answering or planning:

1. Explain the OKF structure in the user's language.
2. Use file paths and small templates when helpful.
3. Distinguish baseline requirements, conditional field contracts, compatibility fallbacks, and authoring recommendations.

## Common Pitfalls

- Confusing OKF with an ingestion platform or data catalog service.
- Treating `index.md` or `log.md` as ordinary concepts.
- Rejecting valid v0.1 input because it uses `timestamp` or `# Citations`.
- Treating a missing `okf_version` as proof of a bundle version.
- Dropping unknown frontmatter keys during enrichment.
- Replacing an existing concept wholesale when a targeted section update would preserve more value.
- Creating reference docs for generic overview pages that do not define a reusable concept.
- Adding metrics, joins, credibility signals, or verification without concrete evidence.
- Silently choosing a link style that is incompatible with the target consumer.
- Calling an agent-authored query a sanctioned or attested computation.
