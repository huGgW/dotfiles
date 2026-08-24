# OKF v0.2 Authoring Checklist

Use this reference when creating a bundle, converting source material, or
writing concept documents. Read `okf-v0.1-to-v0.2-migration.md` instead when
the input already contains legacy `timestamp` or `# Citations` content.

## Bundle Structure

- Use a directory hierarchy organized around stable concepts.
- Treat every non-reserved `.md` file as one concept document.
- Use the bundle-relative path without `.md` as the concept ID.
- Keep paths stable and descriptive, such as `schemas/orders` or
  `references/metrics/revenue`.
- Reserve `index.md` for one-level navigation and `log.md` for chronological
  updates.
- Treat files referenced by Attested Computation contracts as artifacts, not
  concepts, unless they are themselves non-reserved `.md` concept documents.
- Treat `references/` as a convention, not a required directory.

## Baseline Conformance

- Every non-reserved `.md` file starts with parseable YAML frontmatter.
- Frontmatter parses to a mapping and has a non-empty `type` string.
- `index.md` follows the index structure and is not a concept document.
- `log.md` follows the log structure and is not a concept document.
- Do not require optional v0.2 metadata for baseline conformance.

## Useful Concept Metadata

Include metadata only when its value is known.

- `title`: Human-readable display name.
- `description`: One concise sentence suitable for an index entry or search
  result.
- `resource`: Canonical URI of the asset described by the concept. Omit it for
  abstract concepts without a canonical asset.
- `tags`: YAML list of short strings.
- `status`: Use `draft` for unreviewed agent-generated content. Omission means
  `stable`; use `deprecated` for retained but no-longer-current concepts.
- `generated`: Current producer and last meaningful content change. Omit it
  rather than inventing an actor.
- `verified`: Evidence of actual checks, never an authoring default.
- `stale_after`: An evidence-based absolute expiry instant, never an invented
  TTL.
- Unknown producer fields: Preserve them during edits.

## Provenance Checklist

- Put derived materials in `sources`, not a new `# Citations` section.
- Each source entry has a `resource`.
- Give a source a stable `id` when a body claim attributes to it.
- Use the source ID as a Markdown footnote label.
- Keep the concept's canonical `resource` separate from web pages or documents
  that informed it.
- Record `author`, `usage_count`, `last_modified`, and `usage_window` only from
  known evidence.
- Every `usage_count` is framed by one shared `usage_window` or that source's
  explicit override.
- Do not add a credibility score or a `derived_from` field. Consumers infer
  credibility from source signals and follow concept links for lineage.

## Trust And Time Checklist

- Use `<producer>/<version>` for agents or tools, `human:<id>` for people, and
  `process:<id>` for automated processes.
- When `generated` is present, include its required `by`; normally include `at`
  to record the meaningful content change.
- Represent `verified` as a list of `{ by, at }` events. A single mapping is
  legal input, but a list is clearer for new authoring.
- Preserve verification history during edits. Do not imply that an old event
  verified newer content.
- Use ISO 8601 datetime strings with an explicit UTC offset for every
  timestamp-valued key, for example `2026-08-21T10:00:00Z`.
- Apply that format to `generated.at`, `verified[].at`, `stale_after`,
  `sources[].last_modified`, and both ends of `usage_window`.
- Use date-only `YYYY-MM-DD` values only for `log.md` headings.

## General Frontmatter Template

Replace or omit values that are not known. Do not copy the example actor into
real content without confirming it describes the producer.

```yaml
---
type: Reference
title: Example Concept
description: One sentence explaining what this concept captures.
resource: https://example.com/canonical-asset
tags:
  - example
status: draft
generated:
  by: knowledge_agent/model-version
  at: 2026-08-21T10:00:00Z
sources:
  - id: source-doc
    resource: https://example.com/source-document
    title: Source Document
---
```

## General Concept Template

````markdown
---
type: Reference
title: Concept Title
description: One sentence describing the concept and its role in the bundle.
tags:
  - domain-tag
status: draft
generated:
  by: knowledge_agent/model-version
  at: 2026-08-21T10:00:00Z
sources:
  - id: source-doc
    resource: https://example.com/source-document
    title: Source Document
---

This concept explains the role and scope of the subject according to the
source material.[^source-doc]

# Details

- Key fact grounded in the source.
- Relationship to [another concept](../path/another-concept.md).

# Examples

```text
Concrete example or usage pattern.
```

[^source-doc]: Source Document
````

## Schema-Bearing Concept Template

Use this for an API response, event, file, table, typed record, or other
schema-bearing asset.

````markdown
---
type: Schema
title: Orders Event
description: Event schema emitted when an order changes state.
resource: https://example.com/orders-event
tags:
  - schema
  - orders
status: draft
generated:
  by: knowledge_agent/model-version
  at: 2026-08-21T10:00:00Z
sources:
  - id: schema-source
    resource: https://example.com/orders-event-schema
    title: Orders Event Schema
---

This concept describes the event grain and business meaning documented by the
schema source.[^schema-source]

# Schema

| Field | Type | Description | Notes |
| --- | --- | --- | --- |
| `order_id` | string | Stable identifier for the order. | Required. |
| `status` | string | Current order state. | See [Order Status](/references/order-status.md). |

# Common usage

```sql
SELECT order_id, status
FROM orders
WHERE status = 'paid';
```

[^schema-source]: Orders Event Schema
````

## Metric Reference Template

````markdown
---
type: Metric
title: Conversion Rate
description: Percentage of eligible sessions that complete the target event.
tags:
  - metric
status: draft
generated:
  by: knowledge_agent/model-version
  at: 2026-08-21T10:00:00Z
sources:
  - id: metric-policy
    resource: https://example.com/conversion-policy
    title: Conversion Metric Policy
---

Conversion Rate measures the share of eligible sessions that completed the
target event.[^metric-policy]

# Definition

```text
conversion_rate = converted_sessions / eligible_sessions
```

# Usage notes

- Define the eligible population before comparing reports.
- Link contributing concepts, such as [Sessions](/schemas/sessions.md), in prose.

[^metric-policy]: Conversion Metric Policy
````

## Join Reference Template

````markdown
---
type: Join
title: Orders to Customers Join
description: Join path from orders to customers through customer_id.
tags:
  - join
status: draft
generated:
  by: knowledge_agent/model-version
  at: 2026-08-21T10:00:00Z
sources:
  - id: join-source
    resource: https://example.com/orders-data-model
    title: Orders Data Model
---

Use this relationship when attributing order behavior to customer
attributes.[^join-source]

# Join condition

```sql
orders.customer_id = customers.customer_id
```

# Usage notes

- Record cardinality and filtering caveats only when the source establishes them.

[^join-source]: Orders Data Model
````

## Attested Computation Skeleton

Use the full checklist in `okf-attested-computation.md` before populating this
shape.

````markdown
---
type: Attested Computation
title: Revenue for fiscal year
description: Computes recognized revenue for a fiscal year.
status: draft
runtime: bigquery
parameters:
  - name: year
    type: integer
    required: true
executor:
  resource: /references/skills/run-on-bq.md
  receipt: [job_id, executed_sql, result]
attester:
  resource: /references/attesters/sql-equality.py
---

# Computation

```sql
-- Insert only an authoritative sanctioned computation.
```
````

## index.md Templates

A normal directory index has no frontmatter:

```markdown
# Directory Title

## Concepts

* [Concept Title](concept.md) - Short description of the concept.

## Subdirectories

* [References](references/) - Reusable definitions and background concepts.
```

Only the bundle-root index may declare a version:

```markdown
---
okf_version: "0.2"
---

# Bundle Title

* [Schemas](schemas/) - Schemas and data contracts.
```

## log.md Template

Use newest-first date groups and no frontmatter:

```markdown
# Change Log

## 2026-08-21

* **Update**: Added structured provenance to the revenue metric.

## 2026-08-20

* **Creation**: Created the initial bundle structure.
```

## Conversion Heuristics

- Split by concept identity, not source page boundaries.
- Keep source evidence in `sources` and relationships in Markdown links.
- Create standalone reference concepts only for reusable definitions, metrics,
  joins, enums, or background needed by multiple concepts.
- Prefer a shallow structure first and add directories when they improve
  progressive disclosure.
- Preserve the target bundle's established link style unless its consumer is
  known to require another style.
