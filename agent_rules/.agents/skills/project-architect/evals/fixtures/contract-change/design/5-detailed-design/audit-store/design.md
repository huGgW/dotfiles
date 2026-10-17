---
type: component-design
title: Audit Store
---

> ⚠️ Needs revalidation: manual replay identity change; consumer contract verification pending owner confirmation.

# Audit Store

Depends on [delivery identity](../../4-high-level-design/delivery-contract.md).
Current consumer stores one audit identity per delivery_id and assumes manual replay shares the original ID.
Whether it can persist original_delivery_id is unverified; do not treat this contract as current.
