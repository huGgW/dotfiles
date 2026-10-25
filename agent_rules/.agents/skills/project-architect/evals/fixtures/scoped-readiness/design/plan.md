---
type: plan
title: Replay and Retention Checkpoint
---

# Resume

Active agenda: manual replay identity, ready for a scoped readiness check.
Independent agenda: retention model; no selection yet between 30 and 90 days.
Current implementation: retries and manual replay both reuse delivery_id.
Agreed target: manual replay creates a new delivery_id and links original_delivery_id.
Implementation has not changed or been verified.
Next action: assess only manual replay; do not close retention or the whole project.
