# 24. Column-Family Database Profiling Specifics

## 24.1 Column-Family Model Profiling Considerations
- 24.1.1 Wide row design impact
- 24.1.1.1 Row width limits
- 24.1.1.2 Column count impact
- 24.1.2 Partition key design
- 24.1.2.1 Partition size profiling
- 24.1.2.2 Hot partition detection
- 24.1.2.3 Partition key cardinality
- 24.1.3 Clustering key design
- 24.1.3.1 Sort order impact
- 24.1.3.2 Clustering key selectivity
- 24.1.4 Data modeling for query patterns

## 24.2 Read Path Profiling
- 24.2.1 Read consistency levels
- 24.2.1.1 ONE, QUORUM, ALL impact
- 24.2.1.2 LOCAL vs. cross-datacenter reads
- 24.2.2 Read latency breakdown
- 24.2.2.1 Memtable reads
- 24.2.2.2 SSTable reads
- 24.2.2.3 Bloom filter effectiveness
- 24.2.2.4 Key cache and row cache hits
- 24.2.3 Read repair overhead
- 24.2.4 Speculative retry profiling
- 24.2.5 Range scan profiling
- 24.2.5.1 Token range scans
- 24.2.5.2 Partition range scans

## 24.3 Write Path Profiling
- 24.3.1 Write consistency levels
- 24.3.2 Write latency breakdown
- 24.3.2.1 Commit log write
- 24.3.2.2 Memtable write
- 24.3.3 Batch write profiling
- 24.3.3.1 Logged vs. unlogged batches
- 24.3.3.2 Batch size impact
- 24.3.4 Lightweight transaction overhead
- 24.3.5 Counter update profiling

## 24.4 Compaction Profiling
- 24.4.1 Compaction strategies
- 24.4.1.1 Size-tiered compaction
- 24.4.1.2 Leveled compaction
- 24.4.1.3 Time-window compaction
- 24.4.2 Compaction throughput
- 24.4.3 Compaction I/O impact
- 24.4.4 Pending compaction monitoring
- 24.4.5 Tombstone handling
- 24.4.5.1 Tombstone accumulation
- 24.4.5.2 GC grace period impact

## 24.5 Column-Family Database Tools (Mention Only)
- 24.5.1 Cassandra: `nodetool`, `tracing`, `system_traces`, `JMX metrics`, `DataStax OpsCenter`
- 24.5.2 HBase: `hbase shell`, `RegionServer metrics`, `Master UI`, `JMX`
