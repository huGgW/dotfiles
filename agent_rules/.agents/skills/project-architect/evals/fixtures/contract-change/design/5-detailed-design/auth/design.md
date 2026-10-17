---
type: component-design
title: Auth
---

# Auth

Depends on [delivery identity](../../4-high-level-design/delivery-contract.md) for identifying the requested delivery.
Only operators in the delivery's tenant may request replay. New IDs do not change this tenant boundary.
