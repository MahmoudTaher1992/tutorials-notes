# 14. Transaction Profiling

## 14.1 Transaction Lifecycle
- 14.1.1 Transaction begin
- 14.1.2 Statement execution
- 14.1.3 Savepoints
- 14.1.4 Commit processing
- 14.1.4.1 Log flush
- 14.1.4.2 Lock release
- 14.1.4.3 Notification
- 14.1.5 Rollback processing
- 14.1.5.1 Undo operations
- 14.1.5.2 Partial rollback to savepoint

## 14.2 Transaction Metrics
- 14.2.1 Transaction rate (TPS)
- 14.2.2 Transaction duration distribution
- 14.2.3 Commit latency
- 14.2.4 Rollback rate
- 14.2.5 Transaction size (operations per transaction)
- 14.2.6 Active transaction count

## 14.3 Long-Running Transaction Analysis
- 14.3.1 Detection methods
- 14.3.2 Impact assessment
- 14.3.2.1 Lock holding impact
- 14.3.2.2 MVCC bloat impact
- 14.3.2.3 Replication impact
- 14.3.3 Root cause identification
- 14.3.4 Remediation strategies

## 14.4 Transaction Log Profiling
- 14.4.1 Log generation rate
- 14.4.2 Log buffer usage
- 14.4.3 Log flush frequency
- 14.4.4 Log write latency
- 14.4.5 Log space consumption
- 14.4.6 Log archival performance

## 14.5 Distributed Transaction Profiling
- 14.5.1 Two-phase commit overhead
- 14.5.2 Prepare phase analysis
- 14.5.3 Commit phase analysis
- 14.5.4 Coordinator bottlenecks
- 14.5.5 In-doubt transaction handling
- 14.5.6 Distributed deadlock detection
