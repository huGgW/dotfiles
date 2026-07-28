# Order Event Architecture

The Order API publishes `order.status.v1` messages to RabbitMQ. The queue retains messages for 24 hours, and partner consumers acknowledge each message after processing.

```text
Order API -> RabbitMQ queue (24 hours) -> Partner consumer
```
