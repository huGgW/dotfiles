# OKF v0.2 Attested Computation

Use this reference when authoring or validating a sanctioned computation
contract. Provenance answers where a definition came from; attestation answers
whether one runtime value was produced through the sanctioned computation.

## Safety Boundary

- OKF describes the contract but does not execute it.
- Do not turn an illustrative query into a sanctioned computation.
- Use only a computation, executor, and attester supplied or confirmed by an
  authoritative owner.
- Do not implement an executor or attester as incidental OKF authoring work.
- Do not store runtime receipts or attestation verdicts in the bundle.
- The attester is deterministic, no-LLM code executed by a consumer.

## One Computation Per Concept

Use a standalone `type: Attested Computation` concept for each independently
verified and attested calculation. Narrative metric, dashboard, or report
concepts link to these computation concepts rather than embedding several
sanctioned calculations in one document.

This keeps the following state scoped correctly:

- `runtime` and parameter binding semantics.
- Computation content or file identity.
- Executor receipt shape.
- Deterministic attester.
- Verification and freshness.

## Contract Fields

### `runtime`

Required for `type: Attested Computation`. It identifies how to interpret and
run the computation and what parameter binding means. Examples include
`bigquery`, `postgres`, `dbt`, `python`, and `Looker`.

### `parameters`

A list of named, typed values the caller may supply:

```yaml
parameters:
  - name: year
    type: integer
    required: true
```

- Keep `{ name, type, required }` together.
- Binding semantics follow `runtime`.
- During execution, an agent may supply values only for declared parameters.
- An executing agent must not author or edit the sanctioned computation.

### `computation`

Optional path to a file containing the computation. It accepts an absolute URL,
a bundle-relative path beginning with `/`, or a relative path.

```yaml
computation: /references/computations/revenue.sql
```

When absent, the body supplies the computation as one fenced block under
`# Computation`.

### `executor`

Describes how a consumer runs the computation.

```yaml
executor:
  resource: /references/skills/run-on-bq.md
  receipt:
    - job_id
    - executed_sql
    - result
```

- `resource` names run instructions or executable integration code.
- `receipt` declares evidence fields a run must return.
- A receipt is a runtime artifact, not frontmatter history.

### `attester`

Names deterministic code that inspects a receipt and returns a verdict.

```yaml
attester:
  resource: /references/attesters/sql-equality.py
```

The resource packaging may be a script, container, or other consumer-supported
artifact. OKF fixes the contract shape, not the packaging or ABI.

## Inline Versus File Computation

Choose exactly one representation.

Inline form:

````markdown
# Computation

```sql
SELECT SUM(amount) AS revenue
FROM finance.recognized_revenue
WHERE fiscal_year = @year
```
````

File form:

```yaml
runtime: bigquery
computation: /references/computations/revenue.sql
```

- Do not provide both a `computation` path and an inline computation fence.
- Use inline form for short contracts reviewed with the concept.
- Use file form for long, generated, shared, or independently versioned code.
- Ensure the computation uses only declared parameters.

## Complete Example

The SQL and resources below are illustrative. Real authoring requires
authoritative artifacts and actor identities.

````markdown
---
type: Attested Computation
title: Revenue for fiscal year
description: Computes recognized revenue for a fiscal year.
tags: [finance, revenue]
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
generated:
  by: knowledge_agent/model-version
  at: 2026-08-21T10:00:00Z
sources:
  - id: revenue-policy
    resource: https://example.com/revenue-policy
    title: Revenue Recognition Policy
---

# Computation

```sql
SELECT SUM(amount) AS revenue
FROM finance.recognized_revenue
WHERE fiscal_year = @year
```

The computation follows the recognized-revenue definition.[^revenue-policy]

[^revenue-policy]: Revenue Recognition Policy
````

## Authoring Workflow

1. Confirm the authoritative owner and sanctioned computation.
2. Create one standalone concept for that computation.
3. Select the runtime and declare only allowed parameters.
4. Choose inline or file representation.
5. Reference known executor instructions and receipt fields.
6. Reference deterministic attester code.
7. Add definition provenance in `sources` and keyed body attribution.
8. Add actual generation, verification, lifecycle, and freshness facts without
   inventing missing values.
9. Link narrative concepts to the computation.
10. Validate paths and contract consistency without executing the computation.

## Validation Checklist

- `type` is exactly `Attested Computation` when this contract is intended.
- `runtime` is non-empty.
- Every parameter has `name`, `type`, and `required`.
- Parameter names used by the computation are declared.
- Exactly one computation representation is present.
- An inline representation has one fenced block under `# Computation`.
- A file representation points to the intended artifact.
- When present, `executor.resource` and `executor.receipt` have usable shapes.
- When present, `attester.resource` points to deterministic checking code.
- The computation, executor, and attester came from authoritative input.
- Definition provenance is separate from runtime attestation.
- `verified` records definition checks, not per-run success.
- Receipts and verdicts are absent from persisted bundle metadata.
- Consumers can warn or refuse when the definition is stale or attestation
  fails, but authoring does not execute that gate.

## Verification Versus Attestation

| Signal | Scope | Persisted in bundle | Meaning |
| --- | --- | --- | --- |
| `verified` | Concept definition | Yes | The definition was checked against policy or source material. |
| Attestation verdict | One execution | No | The reported value came from the sanctioned computation and receipt. |

A fresh definition still needs per-run attestation. A stale definition may
produce a mechanically valid run, but consumers should still apply freshness
policy.
