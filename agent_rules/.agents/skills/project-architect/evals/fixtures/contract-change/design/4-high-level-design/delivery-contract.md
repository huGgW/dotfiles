---
type: contract
title: Delivery Identity Contract
---

# Delivery Identity

Automatic retries and operator-requested manual replay reuse the original delivery_id.
Consumers deduplicate using delivery_id.

## Direct Dependents

- [Worker](../5-detailed-design/worker/design.md): replay handling and deduplication.
- [Audit Store](../5-detailed-design/audit-store/design.md): delivery identity in audit records.
- [Auth](../5-detailed-design/auth/design.md): tenant access to delivery operations.
