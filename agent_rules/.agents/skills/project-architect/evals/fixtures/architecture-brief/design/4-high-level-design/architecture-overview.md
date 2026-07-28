---
type: Architecture Overview
title: "Merchant Alerting Architecture"
source_revision: "2026-07-10-v1"
---

# Architecture Overview

> Internal artifact: Phase 4
> Decision ID: D-12

The platform accepts merchant alert requests and delivers them to external notification providers.

## Components

- **Ingest API** validates the request and writes both the alert and an outbox record in one PostgreSQL transaction.
- **Outbox** preserves accepted delivery work if a downstream component is unavailable.
- **Dispatcher** claims pending records with `SKIP LOCKED` and assigns them to provider adapters.
- **Provider adapters** translate the canonical alert into provider-specific requests.

## Reliability

Delivery is at least once. The tuple `merchant_id + alert_id` is the idempotency key. The initial release has no end-user interface.
