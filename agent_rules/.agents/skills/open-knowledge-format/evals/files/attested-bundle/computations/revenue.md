---
type: Attested Computation
title: Revenue
description: Computes recognized revenue.
status: stable
parameters:
  - name: year
    type: integer
computation: /references/computations/revenue.sql
executor:
  resource: /references/skills/run-query.md
attester:
  resource: llm://judge-query
verified:
  by: human:finance-owner
  at: 2026-08-20T10:00:00Z
sources:
  - id: revenue-policy
    title: Revenue Policy
---

# Computation

```sql
SELECT SUM(amount) FROM revenue WHERE fiscal_year = @year;
```
