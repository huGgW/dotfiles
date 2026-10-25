---
type: design
title: Manual Replay Slice
---

# Agreed Target

Outcome: support can replay one failed delivery without deduplication suppressing it.
Scope: operator replay API, Worker deduplication, and Audit Store identity recording.
API owns generation of a new delivery_id; original_delivery_id points to the original.
Automatic retries reuse delivery_id. Tenant ownership does not change.
Worker applies at most once per delivery_id through its existing atomic claim/apply boundary.
Audit Store owner has confirmed it can store original_delivery_id without changing consumers.
Verification: retry keeps its ID; manual replay has a new ID and original link; duplicate
submission of that new ID has no second effect; cross-tenant requests remain denied.
Implementation-time questions: helper names and equivalent router library choice.
No known blocking question remains for this slice. Retention is a separate agenda.
