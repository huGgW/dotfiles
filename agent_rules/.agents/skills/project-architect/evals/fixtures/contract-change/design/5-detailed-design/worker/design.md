---
type: component-design
title: Worker
---

# Worker

Depends on [delivery identity](../../4-high-level-design/delivery-contract.md).
Automatic retries and manual replay reuse delivery_id. The Worker skips an ID already applied.
Provider timeout handling remains an open separate agenda.
