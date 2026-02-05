# 13. Alternative Concurrency Control

## 13.1 Multi-Version Concurrency Control (MVCC)
- 13.1.1 MVCC principles
- 13.1.2 Version chain management
- 13.1.3 Snapshot creation and management
- 13.1.4 Visibility rules
- 13.1.5 MVCC overhead
- 13.1.5.1 Version storage overhead
- 13.1.5.2 Garbage collection (vacuum/purge)
- 13.1.5.3 Version chain traversal cost

## 13.2 MVCC Profiling
- 13.2.1 Version bloat detection
- 13.2.2 Long-running transaction impact
- 13.2.3 Snapshot too old errors
- 13.2.4 Vacuum/purge performance
- 13.2.4.1 Vacuum lag
- 13.2.4.2 Dead tuple accumulation
- 13.2.4.3 Bloat measurement
- 13.2.5 MVCC-related wait events

## 13.3 Optimistic Concurrency Control
- 13.3.1 OCC principles
- 13.3.2 Conflict detection profiling
- 13.3.3 Retry rate analysis
- 13.3.4 OCC vs. pessimistic locking trade-offs

## 13.4 Latch Profiling
- 13.4.1 Latches vs. locks
- 13.4.2 Buffer pool latches
- 13.4.3 Internal structure latches
- 13.4.4 Latch contention hotspots
- 13.4.5 Latch wait analysis
