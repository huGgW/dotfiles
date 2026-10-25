---
type: implementation-issue
title: Manual Replay API and Worker
---

# Scope

API and Worker implement replay using the original delivery_id.
Acceptance: duplicate replay requests cannot apply the same delivery twice.
Direct blocker: replay identity contract must be settled before implementation.
Release condition: operator runbook review before production launch, not before coding.
Status: local draft; no remote issue exists.
