# 11. Locking Fundamentals

## 11.1 Lock Types and Modes
- 11.1.1 Shared locks (read locks)
- 11.1.2 Exclusive locks (write locks)
- 11.1.3 Update locks
- 11.1.4 Intent locks (IS, IX, SIX)
- 11.1.5 Schema locks
- 11.1.6 Bulk update locks
- 11.1.7 Key-range locks

## 11.2 Lock Granularity
- 11.2.1 Database-level locks
- 11.2.2 Table-level locks
- 11.2.3 Page-level locks
- 11.2.4 Row-level locks
- 11.2.5 Column-level locks
- 11.2.6 Lock escalation
- 11.2.6.1 Escalation thresholds
- 11.2.6.2 Escalation impact on concurrency
- 11.2.6.3 Preventing unwanted escalation

## 11.3 Lock Duration
- 11.3.1 Transaction-duration locks
- 11.3.2 Statement-duration locks
- 11.3.3 Short-term latches
- 11.3.4 Lock release timing

## 11.4 Locking in Different Isolation Levels
- 11.4.1 Read uncommitted
- 11.4.2 Read committed
- 11.4.3 Repeatable read
- 11.4.4 Serializable
- 11.4.5 Snapshot isolation
- 11.4.6 Isolation level impact on lock behavior
