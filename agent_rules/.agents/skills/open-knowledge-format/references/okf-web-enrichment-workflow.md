# OKF v0.2 Web Enrichment Workflow

Use this reference when adding information from web pages, documentation,
local exports, or other source material to an existing OKF bundle.

## Goal

Increase grounded context without weakening structure, provenance, or trust.
The goal is not to scrape everything. Add only reusable facts, definitions,
examples, metrics, dimensions, joins, and references that improve future
answers.

## Source Selection

- Start from explicit user-provided URLs, repository docs, local files, or an
  existing source list.
- Prefer primary, authoritative, stable sources.
- Use secondary sources only when their interpretation adds value and the
  accepted trust level is clear.
- Skip generic landing pages, marketing overviews, changelogs, quickstarts,
  FAQs, and roadmaps unless they define a reusable concept needed by the bundle.
- Do not invent a URL or cite a source that was not read.

## Page Triage

For each source, choose one outcome.

| Outcome | Use when | Result |
| --- | --- | --- |
| Enrich existing concept | The source clarifies a concept already present. | Conservatively augment that concept. |
| Create reference concept | The source defines a reusable concept by name. | Add a `references/...` concept and link it. |
| Extract structured concept | The source defines a metric, dimension, enum, schema, or join. | Add structured sections or focused reference concepts. |
| Skip | The source is generic, stale, thin, duplicative, or unsupported. | Avoid bundle noise. |

## Detect The Existing Version

- Read the concept before editing it.
- Do not infer v0.1 merely because the root has no `okf_version` declaration.
- Treat `timestamp` and `# Citations` as valid legacy input.
- If `generated` or `sources` already exists, preserve and extend the v0.2 form.
- Do not force a full migration as a side effect of unrelated enrichment.
- Follow `okf-v0.1-to-v0.2-migration.md` only when the user requested migration
  or the requested edit directly targets a legacy field. Safe source mapping
  alone does not authorize migration.
- When claim-to-source mapping is uncertain, preserve the legacy citation
  section and report the incomplete migration instead of guessing.

## Preservation Rules

- Preserve every existing frontmatter key except a legacy key deliberately
  superseded during an explicit, complete migration.
- Preserve `type`, canonical `resource`, and `title` unless authoritative
  evidence proves they are wrong.
- Merge `tags` and `sources`; never replace or shrink them.
- Preserve existing `verified` events. Do not add a verification event for the
  enrichment unless the named actor actually performed that check.
- Preserve every existing top-level `#` heading in the same order and wording.
- Add content under existing headings when possible and add new top-level
  headings after existing ones.
- Do not shrink `# Schema`, examples, computation contracts, source coverage,
  or legacy citation coverage.
- If safe preservation is impossible, create a separate reference concept or
  propose remediation instead of rewriting.

## Structured Provenance

For every source that materially contributes content:

1. Add or merge a `sources` entry with a required `resource`.
2. Add a stable `id` and `title` when claims will attribute to it.
3. Attribute source-backed claims with footnotes keyed to that `id`.
4. Add `author`, `usage_count`, `last_modified`, or `usage_window` only when the
   source provides those facts.

Whenever a source has `usage_count`, add a shared `usage_window` or a
source-specific override so the count has a defined period.

Example:

```yaml
sources:
  - id: export-schema
    resource: https://example.com/export-schema
    title: Export Schema
```

```markdown
Exported events use daily shards.[^export-schema]

[^export-schema]: Export Schema
```

Do not add a new `# Citations` section. For a legacy section, either migrate
its coverage safely or preserve it as compatibility content.

## Generation And Verification

- A meaningful content change should refresh `generated` when the current
  actor is known.
- Use the actor convention defined by v0.2 and an explicit-offset datetime.
- If the actor is unknown, omit the new `generated` value rather than inventing
  one. Preserve an existing value and report that it could not be refreshed.
- Keep prior `verified` events. If the new `generated.at` is later than every
  `verified.at`, report that the current content has not been re-verified.
- Keep `status` unchanged unless the task explicitly includes lifecycle review.
- Do not add or extend `stale_after` without an authoritative freshness policy.

## Metric Extraction

Create a metric reference when a source defines a named measurement,
calculation, numerator or denominator, filter condition, or comparison rule
that future agents may reuse.

Metric docs should include:

- `type: Metric` or the bundle's established metric type.
- A name and one-sentence description.
- A definition with formula or pseudo-SQL when the source provides it.
- Usage assumptions and caveats.
- A source entry and keyed attribution supporting the formula and meaning.

Link contributing concepts to the metric under `# Metrics` or an existing
relevant section. Do not duplicate the canonical formula across callers.

## Dimension And Enum Extraction

- Add a dimension to its owning schema's `# Schema`, `# Dimensions`, or
  `# Details` section.
- Create a focused reference concept when an enum or dimension is reused across
  multiple concepts.
- Attribute allowed values and interpretations to a source.
- Avoid standalone docs for trivial, self-explanatory, one-off fields.

## Join Extraction

Create a join reference only when a source explicitly documents or demonstrates
the relationship.

Join docs should include:

- A focused type and title naming both sides.
- The concrete join condition in fenced SQL or pseudocode.
- Cardinality, filtering behavior, and caveats only when known.
- A source entry and keyed attribution for the relationship.

Link both participating concepts to the join reference under `# Joins` or a
relevant existing section. Do not invent join paths from matching field names.

## Reference Concept Gate

Before creating a general reference concept, confirm all of the following:

1. The source defines a concrete reusable topic by name.
2. At least two concepts benefit, or one concept needs it as load-bearing
   background that does not fit locally.
3. A future answer can cite the reference naturally.
4. The source is authoritative enough for the claim.

If any answer is no or unclear, enrich an existing concept or skip the source.
Focused metric and join extraction may bypass this gate when the source clearly
defines the reusable contract.

## Link Strategy

- Preserve an existing bundle's link style.
- Use file-relative links for GitHub or plain-file browsing.
- Use absolute bundle-relative links when the consumer expects the spec's
  stable-root convention.
- Link only to existing or intentionally created targets.

## Completion Checklist

- Existing frontmatter keys, verification history, headings, schemas, and
  examples are preserved.
- Tags and sources are merged rather than replaced.
- New claims are backed by sources and keyed footnotes.
- Meaningful edits update `generated` only with a known actor.
- No credibility, verification, freshness, metric, or join fact was invented.
- Metrics, dimensions, and joins are structured instead of buried in prose.
- New reference concepts are linked and not orphaned.
- Skipped or incompletely migrated sources are reported when the user expected
  them to be used.
