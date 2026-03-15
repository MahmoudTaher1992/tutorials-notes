# Dead Letter Queues: Never Lose a Message

**Category**: Backend
**Difficulty**: Intermediate
**Estimated Duration**: 60 sec (Short)
**Date Proposed**: 2026-03-15
**Source Inspiration**: software/integration-patterns/toc-anthropic/ip_part_1.md

---

## Introduction

When a message broker can't deliver a message — because it's malformed, or the consumer keeps crashing — most systems silently drop it. A Dead Letter Queue (DLQ) is the safety net that catches those failed messages so nothing is permanently lost. Understanding DLQs is essential for building reliable, production-grade messaging systems.

---

## Body

### Key Points to Cover
1. What a "poison message" is: a message that consistently fails processing and causes a consumer to crash on every attempt.
2. How a DLQ works: after N failed retries the broker moves the message to a dedicated DLQ topic/queue instead of dropping it or replaying it forever.
3. Why a growing DLQ is a silent alarm — it indicates a persistent bug or data contract violation that needs immediate attention.
4. Replaying DLQ messages after fixing the bug, and why consumers must be idempotent to safely do so.

### Suggested Code Examples / Demos
- Show a RabbitMQ or SQS queue configured with a `x-dead-letter-exchange` / DLQ ARN setting.
- Show a consumer that intentionally fails, then inspect the DLQ to find the offending message.
- Show a replay script that re-publishes DLQ messages back to the main queue.

### Common Pitfalls / Misconceptions
- Ignoring the DLQ entirely — messages pile up unnoticed until disk fills or the window to diagnose expires.
- Not monitoring DLQ depth — a growing DLQ is just as urgent as a rising error rate, but teams often have no alert on it.
- Replaying DLQ messages into a non-idempotent consumer — causes duplicate side effects (e.g., double-charging customers).
- Using a single shared DLQ for every queue — makes it impossible to trace which queue a message originally came from.

---

## Conclusion / Footer

Key takeaway: a DLQ turns silent data loss into a visible, fixable problem. Challenge for viewers: check whether your queues have a DLQ configured and whether you have an alert on its depth.

---

## Notes for Production
- Thumbnail idea: a trash can with a red badge count, like unread notifications.
- Related videos: Kafka consumer lag, at-least-once vs exactly-once delivery.
- Mention AWS SQS and RabbitMQ as the two most common implementations.
