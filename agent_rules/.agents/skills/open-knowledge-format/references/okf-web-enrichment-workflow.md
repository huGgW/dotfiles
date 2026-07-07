# OKF Web Enrichment Workflow

Use this reference when adding information from web pages, docs sites, local exports, or other source documents to an existing OKF bundle.

## Enrichment Goal

Web enrichment should increase grounded context without making the bundle less stable. The goal is not to scrape everything. The goal is to add citations, definitions, examples, metrics, dimensions, joins, and reference concepts that help agents answer future questions accurately.

## Source Selection

- Start from explicit user-provided URLs, repository docs, local files, or cited source lists.
- Prefer primary sources: official docs, source repositories, API references, standards, design docs, or owned documentation.
- Use secondary sources only when they add interpretation and the user accepts that trust level.
- Skip generic landing pages, marketing overviews, changelogs, quickstarts, FAQs, and roadmap pages unless they define a reusable concept needed by the bundle.
- Do not invent URLs or cite sources that were not read.

## Page Triage

For each source, choose one outcome.

| Outcome | Use when | Result |
| --- | --- | --- |
| Enrich existing concept | The page clarifies a concept already present. | Update the existing concept conservatively. |
| Create reference concept | The page defines a reusable concept by name. | Add a `references/...` concept doc. |
| Extract structured concept | The page defines a metric, dimension, enum, schema, or join. | Add or update structured sections/reference docs. |
| Skip | The page is generic, stale, thin, duplicative, or unsupported by citations. | Do not create bundle noise. |

## Preservation Rules

- Preserve every existing frontmatter key unless the user explicitly asks for cleanup.
- Preserve `type`, `resource`, and `title` unless the existing value is clearly wrong and the source proves the correction.
- Merge `tags` rather than replacing them.
- Preserve all existing top-level `#` headings in the same order and wording.
- Add content under existing headings when possible.
- Add new top-level headings only after existing top-level headings.
- Do not shrink existing `# Schema`, `# Examples`, `# Common usage`, or `# Citations` sections.
- If safe preservation is not possible, create a separate reference doc or propose a remediation plan instead of rewriting.

## Citation Policy

- Every factual claim imported from a source should be traceable to a citation.
- Put citations in `# Citations` when the body uses several source-backed facts.
- Inline links are acceptable for local, narrow claims, but keep a final citation section for scanability.
- Use the source page title or concise descriptive text as citation label.
- Do not cite a homepage when a deep source page supports the claim more precisely.
- Do not cite search result snippets.

## Metric Extraction

Create a metric reference when a source defines a named measurement, calculation, numerator/denominator, filter condition, or comparison rule that future agents may reuse.

Metric docs should include:

- `type: Metric`
- `title` with the metric name
- One-sentence `description`
- Definition section with formula or pseudo-SQL when available
- Usage notes with assumptions and caveats
- Citations that justify the formula and interpretation

Add links from contributing concepts to the metric reference under a `# Metrics` section or a relevant existing section.

## Dimension And Enum Extraction

Add dimensions and enum definitions where they will be found during use.

- If the dimension belongs primarily to one schema-bearing concept, add it to that concept's `# Schema`, `# Dimensions`, or `# Details` section.
- If the enum or dimension is shared across multiple concepts, create a `references/...` concept doc.
- Cite the source of allowed values, labels, or interpretation.
- Avoid creating standalone docs for trivial fields that are self-explanatory and not reused.

## Join Extraction

Create a join reference only when a source explicitly documents or demonstrates the relationship.

Join docs should include:

- `type: Join`
- `title` naming both sides
- One-sentence `description`
- A fenced SQL or pseudo-code join condition
- Usage notes for cardinality, filtering, or caveats when known
- Citations for the relationship

Add links from both participating concepts to the join reference under `# Joins` or a relevant existing section.

## Reference Concept Gate

Before creating a new reference concept, ask:

1. Does the source define a concrete reusable topic by name?
2. Would at least two existing or likely future concepts benefit from linking to it?
3. Can a future answer cite this reference naturally?
4. Is the source authoritative enough for the claim?

If the answer is no or unclear, enrich an existing concept or skip the source.

## Enrichment Output Checklist

- Existing frontmatter keys are preserved.
- Existing top-level headings are preserved.
- Tags are merged.
- New facts have citations.
- Metrics, dimensions, and joins are structured instead of buried in prose.
- No schema or citation section shrank.
- New internal links point to existing or newly created concept docs.
- Any skipped source is explained briefly when the user expected it to be used.
