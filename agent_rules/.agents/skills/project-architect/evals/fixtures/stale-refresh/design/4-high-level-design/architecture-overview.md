---
type: Architecture Overview
title: "Order Event Architecture"
source_revision: "2026-07-25-v2"
---

# Architecture Overview

> Internal artifact: Phase 4
> Decision ID: D-23

The Order API writes each accepted status change and a transactional outbox record in one database transaction.

An outbox relay publishes `order.status.v2` records to managed Kafka. Kafka retains records for seven days.

Partner consumers apply each record idempotently using `order_id + status_version` and commit the Kafka offset only after successful application.

Kafka replaces RabbitMQ so consumers can replay a longer event history without a separate archival path.
