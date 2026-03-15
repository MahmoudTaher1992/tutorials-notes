# Kafka Consumer Lag: The Metric That Actually Matters

**Category**: Backend
**Difficulty**: Intermediate
**Estimated Duration**: 60 sec (Short)
**Date Proposed**: 2026-03-15
**Source Inspiration**: software/message-brokers/kafka/general.md

---

## Introduction

Consumer lag is the single most important metric in any Kafka-based system — yet many teams only discover it after users are already affected. Consumer lag measures how far behind a consumer group is from the latest messages in a topic. When it climbs, your pipeline is falling behind in real time, and you need to know why before it becomes a crisis.

---

## Body

### Key Points to Cover
1. What consumer lag is: the difference between the latest offset in a partition and the last offset committed by the consumer group. A lag of zero means the consumer is keeping up. A rising lag means it is falling behind.
2. Why lag rises: the consumer application is too slow (CPU-bound processing, slow downstream calls), there are too few consumer instances relative to partition count, or a consumer is paused/stuck in a rebalance loop.
3. How to measure it: `kafka-consumer-groups.sh --describe` shows per-partition lag. Tools like Burrow, Kafka UI, or Confluent Control Center visualise it over time. Alert when lag grows consistently across multiple polling intervals.
4. The fix: scale consumers (up to the number of partitions), optimize consumer processing, or increase partitions if the bottleneck is parallelism.

### Suggested Code Examples / Demos
- Run `kafka-consumer-groups.sh --bootstrap-server localhost:9092 --group my-group --describe` to show the LAG column.
- Show a Grafana panel with a consumer lag time-series spiking during a slow consumer.
- Show adding a second consumer instance to the same group and watching lag drain.

### Common Pitfalls / Misconceptions
- Monitoring only broker health and ignoring consumer lag — the broker can be perfectly healthy while consumers are hours behind.
- Adding more consumers than there are partitions — extra consumers sit idle because each partition is assigned to exactly one consumer per group.
- Lag measured in message count, not time — a lag of 10,000 messages on a low-traffic topic may be fine; on a high-traffic topic it could mean minutes of delay.
- Auto-committing offsets before processing completes — hides real lag and risks data loss on consumer restart.

---

## Conclusion / Footer

Key takeaway: consumer lag is the heartbeat of your Kafka pipeline. If you are not alerting on it, you are flying blind. Viewer challenge: run `kafka-consumer-groups.sh --describe` on your production group and check the LAG column right now.

---

## Notes for Production
- Thumbnail idea: a speedometer in the red with a Kafka logo watermark.
- Related videos: Kafka partitions and offsets, liveness vs readiness probes.
- Mention Burrow (LinkedIn's open-source lag monitor) as a production-grade alerting tool.
