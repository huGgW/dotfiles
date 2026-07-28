---
type: Component Design
title: "Delivery Worker"
source_revision: "2026-07-10-v1"
---

# Delivery Worker

> Internal artifact: Phase 5

The worker performs up to five total delivery attempts. Retry delays are 30 seconds, 2 minutes, 10 minutes, and 30 minutes.

After the fifth failed attempt, the alert moves to a dead-letter state. An operator may replay it only with the `alerts:replay` permission.

The worker publishes delivery latency, retry count, terminal failure count, and dead-letter depth metrics.
