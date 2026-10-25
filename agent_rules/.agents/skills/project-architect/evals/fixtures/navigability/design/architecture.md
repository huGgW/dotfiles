---
type: architecture
title: Buffering Architecture
---

# Current Implementation

Direct callbacks run inside the API process. No durable buffer or replay exists today.

# Agreed Target

Transactional outbox and managed queue decouple the API from provider outages.
Implementation has not started. Worker owns deduplication by delivery_id.

# Proposed, Not Approved

Retention could be 30 or 90 days; cost review is pending.

# Related Context

- [Earlier rationale](4-high-level-design/communication/decision.md)
