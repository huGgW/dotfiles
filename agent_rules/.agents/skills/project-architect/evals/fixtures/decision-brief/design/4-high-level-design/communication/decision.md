---
type: Architecture Decision
title: "Partner Order Status Communication"
source_revision: "2026-07-15-v1"
---

# Communication Decision

> Internal artifact: Phase 4
> Decision ID: D-17

## Context

Partner traffic can peak at 2,000 order-status changes per minute. Partners should receive accepted changes within two minutes.

## Options Considered

- **Asynchronous domain events**: selected because they absorb bursts, allow replay, and isolate partner outages.
- **Synchronous callbacks**: rejected because partner latency and outages would affect order processing.
- **Nightly polling files**: rejected because they cannot meet the two-minute delivery objective.

## Consequences

Consumers observe eventual consistency and must deduplicate by `order_id + status_version`. The team must operate and monitor the event broker. Cross-region active-active delivery is outside the first release.
