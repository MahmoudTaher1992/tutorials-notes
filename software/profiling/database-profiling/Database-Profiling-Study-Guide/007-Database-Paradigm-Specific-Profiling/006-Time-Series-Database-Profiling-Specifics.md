# 26. Time-Series Database Profiling Specifics

## 26.1 Time-Series Model Profiling Considerations
- 26.1.1 Timestamp precision impact
- 26.1.2 Tag/label cardinality
- 26.1.2.1 High cardinality problems
- 26.1.2.2 Tag indexing overhead
- 26.1.3 Field data types
- 26.1.4 Series cardinality management
- 26.1.5 Data point density

## 26.2 Time-Series Ingestion Profiling
- 26.2.1 Write throughput (points per second)
- 26.2.2 Batch ingestion optimization
- 26.2.3 Out-of-order write handling
- 26.2.4 Backfill operations
- 26.2.5 Write buffering and batching

## 26.3 Time-Series Query Profiling
- 26.3.1 Time range query efficiency
- 26.3.2 Downsampling/aggregation profiling
- 26.3.2.1 Pre-aggregation vs. query-time aggregation
- 26.3.2.2 Continuous queries/rollups
- 26.3.3 Tag filtering performance
- 26.3.4 Group by operations
- 26.3.5 Window functions
- 26.3.6 Cross-series operations

## 26.4 Time-Series Storage Profiling
- 26.4.1 Compression effectiveness
- 26.4.1.1 Delta encoding
- 26.4.1.2 Gorilla compression
- 26.4.1.3 Dictionary encoding
- 26.4.2 Retention policy impact
- 26.4.3 Shard/chunk management
- 26.4.4 Cold storage tiering

## 26.5 Time-Series Database Tools (Mention Only)
- 26.5.1 InfluxDB: `EXPLAIN`, `SHOW STATS`, `SHOW DIAGNOSTICS`, Telegraf, Chronograf
- 26.5.2 TimescaleDB: PostgreSQL tools + `timescaledb_information` views, `chunks_detailed_size()`
