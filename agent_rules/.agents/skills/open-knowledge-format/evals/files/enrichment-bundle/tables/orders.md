---
type: BigQuery Table
title: Customer Orders
description: One row per customer order.
resource: https://bigquery.example.com/sales/orders
tags:
  - orders
status: stable
custom_owner: data-platform
generated:
  by: process:warehouse-export
  at: 2026-08-01T08:00:00Z
verified:
  - by: human:data-owner
    at: 2026-08-02T09:00:00Z
sources:
  - id: warehouse-schema
    resource: https://docs.example.com/warehouse-schema
    title: Warehouse Schema
---

Customer Orders contains one row for each order loaded into the warehouse.

# Schema

| Field | Type | Description |
| --- | --- | --- |
| `order_id` | string | Stable order identifier. |
| `status` | string | Current order state. |
| `net_amount` | numeric | Net order amount. |

# Examples

```sql
SELECT order_id, status, net_amount
FROM sales.orders;
```
