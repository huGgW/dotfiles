---
type: options
title: Delivery Buffer Review
---

# Review Candidates — No Selection

Audience: partner engineering leads. Outcome: absorb provider outages without losing deliveries.
Option A: managed queue, per-tenant ordering through partition keys; lower operational burden,
but replay requires a separate retained event store.
Option B: managed Kafka, seven-day replay and keyed ordering; higher operational complexity.
Common agreed constraints: at-least-once delivery, tenant isolation, idempotent consumers.
Neither option is approved. The delivery-team owner must select after cost review.
Current implementation: direct synchronous callbacks, no durable buffer.
Internal discussion marker: D-DRAFT-42. Never copy this marker into the shareable document.
