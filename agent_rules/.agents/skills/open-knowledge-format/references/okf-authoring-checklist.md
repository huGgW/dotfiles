# OKF Authoring Checklist

Use this reference when creating a new OKF bundle, converting existing notes, or writing concept documents from scratch.

## Bundle Structure

- Use a directory tree of Markdown files.
- Treat each non-reserved `.md` file as one concept.
- Use the bundle-relative path without `.md` as the concept ID.
- Keep concept paths stable and descriptive, such as `concepts/customer_lifetime_value`, `schemas/orders`, or `references/metrics/revenue`.
- Use lowercase or snake_case paths when the project has no existing convention.
- Reserve `index.md` for navigation.
- Reserve `log.md` for chronological updates.
- Do not put ordinary concept frontmatter in `index.md` or `log.md` unless the user explicitly needs a bundle-root version declaration.

## Conformance Checklist

- Every non-reserved `.md` file starts with parseable YAML frontmatter.
- Every concept frontmatter has non-empty `type`.
- Frontmatter parses to a mapping, not a list or scalar.
- `index.md` is a navigation page, not a concept document.
- `log.md` is an update log, not a concept document.
- Markdown links use valid Markdown syntax.
- Citations point to actual source material used in the body.

## Practical Compatibility Checklist

These fields are not all required by the OKF spec, but they make bundles easier for agents and reference tooling to consume.

- `title` is present and human-readable.
- `description` is one concise sentence.
- `timestamp` is present and ISO 8601 formatted.
- `resource` is present when the concept represents an external asset.
- `tags` is a YAML list, not a comma-separated string.
- Unknown frontmatter keys are preserved during edits.
- Concept docs include enough prose for an agent to understand why the concept matters.

## Frontmatter Template

```yaml
---
type: Reference
resource: https://example.com/source
title: Example Concept
description: One sentence explaining what this concept captures.
tags:
  - example
  - reference
timestamp: 2026-07-02T00:00:00Z
---
```

## Generic Concept Template

````markdown
---
type: Reference
resource: https://example.com/source
title: Concept Title
description: One sentence describing the concept and its role in the bundle.
tags:
  - domain-tag
timestamp: 2026-07-02T00:00:00Z
---

This concept explains the role, scope, and context of the subject.

# Details

- Key fact grounded in the cited source.
- Relationship to [Another Concept](../path/another_concept.md).

# Examples

```text
Concrete example or usage pattern.
```

# Citations

1. [Source title](https://example.com/source)
````

## Schema-Bearing Concept Template

Use this when a concept describes an API response, event, file, table-like structure, typed record, or other schema-bearing asset.

````markdown
---
type: Schema
resource: https://example.com/schema-source
title: Orders Event
description: Event schema emitted when an order changes state.
tags:
  - schema
  - orders
timestamp: 2026-07-02T00:00:00Z
---

This concept describes the row, event, message, or object grain and the business meaning of the schema.

# Schema

| Field | Type | Description | Notes |
| --- | --- | --- | --- |
| `order_id` | string | Stable identifier for the order. | Required. |
| `status` | string | Current order state. | See [Order Status](../references/order_status.md). |

# Common usage

```sql
-- Example query or pseudo-query when relevant.
SELECT order_id, status
FROM orders
WHERE status = 'paid';
```

# Citations

1. [Schema source](https://example.com/schema-source)
````

## Metric Reference Template

````markdown
---
type: Metric
resource: https://example.com/metric-source
title: Conversion Rate
description: Percentage of sessions that complete the target conversion event.
tags:
  - metric
timestamp: 2026-07-02T00:00:00Z
---

Conversion Rate measures the share of eligible sessions that completed the target conversion event.

# Definition

```text
conversion_rate = converted_sessions / eligible_sessions
```

# Usage notes

- Define the eligible population before comparing this metric across reports.
- Link contributing concepts, such as [Sessions](../../schemas/sessions.md), in prose.

# Citations

1. [Metric definition source](https://example.com/metric-source)
````

## Join Reference Template

````markdown
---
type: Join
resource: https://example.com/join-source
title: Orders to Customers Join
description: Join path from orders to customers through customer_id.
tags:
  - join
timestamp: 2026-07-02T00:00:00Z
---

Use this join when attributing order behavior to customer attributes.

# Join condition

```sql
orders.customer_id = customers.customer_id
```

# Usage notes

- Use an inner join when only orders with known customers should remain.
- Use a left join when preserving all orders is more important than complete customer attribution.

# Citations

1. [Join source](https://example.com/join-source)
````

## index.md Template

```markdown
# Directory Title

## Concepts

* [Concept Title](concept.md) - Short description of the concept.
* [Another Concept](another_concept.md) - Short description of the concept.

## Subdirectories

* [References](references/index.md) - Reusable definitions, metrics, joins, and background concepts.
```

## log.md Template

```markdown
# Change Log

## 2026-07-02

* **Creation** - Created initial OKF bundle structure.
* **Update** - Added metric references and citations for conversion analysis.
```

## Conversion Heuristics

- Split by concept identity, not by source page boundaries.
- Keep source page URLs in `resource` when a concept primarily summarizes one source.
- Use `# Citations` for source evidence and Markdown links for bundle-internal relationships.
- Create reference docs only for reusable concepts, definitions, metrics, joins, enums, or background needed by multiple concepts.
- Prefer a shallow structure first. Add deeper directories when there are enough related concepts to justify progressive disclosure.
