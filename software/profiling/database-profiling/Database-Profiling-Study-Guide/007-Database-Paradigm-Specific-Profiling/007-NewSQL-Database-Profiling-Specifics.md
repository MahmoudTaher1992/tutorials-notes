# 27. NewSQL Database Profiling Specifics

## 27.1 NewSQL Characteristics Impact
- 27.1.1 SQL compatibility profiling
- 27.1.2 Distributed ACID overhead
- 27.1.3 Horizontal scaling profiling
- 27.1.4 Automatic sharding analysis

## 27.2 NewSQL Query Profiling
- 27.2.1 Distributed query execution plans
- 27.2.2 Query routing decisions
- 27.2.3 Cross-range/cross-region queries
- 27.2.4 Push-down optimization analysis
- 27.2.5 Parallel execution profiling

## 27.3 NewSQL Transaction Profiling
- 27.3.1 Distributed transaction latency
- 27.3.2 Clock synchronization impact
- 27.3.2.1 TrueTime (Spanner)
- 27.3.2.2 Hybrid logical clocks
- 27.3.3 Transaction contention in distributed settings
- 27.3.4 Serializable snapshot isolation profiling

## 27.4 NewSQL Cluster Profiling
- 27.4.1 Range/region distribution
- 27.4.2 Leader distribution
- 27.4.3 Follower read profiling
- 27.4.4 Leaseholder/leader hotspots
- 27.4.5 Automatic rebalancing overhead

## 27.5 NewSQL Database Tools (Mention Only)
- 27.5.1 CockroachDB: `EXPLAIN ANALYZE`, DB Console, `crdb_internal` tables, Statement Statistics
- 27.5.2 TiDB: `EXPLAIN ANALYZE`, TiDB Dashboard, Prometheus + Grafana integration
- 27.5.3 Google Spanner: Query Insights, Cloud Monitoring, Query Statistics
