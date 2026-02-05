# 6. Execution Plan Analysis (Deep Dive)

## 6.1 Cost Model Understanding
- 6.1.1 What cost represents
- 6.1.2 Cost formula components
- 6.1.2.1 I/O cost
- 6.1.2.2 CPU cost
- 6.1.2.3 Network cost (distributed systems)
- 6.1.3 Cost calibration
- 6.1.4 Cost model limitations

## 6.2 Cardinality Estimation
- 6.2.1 Statistics and histograms
- 6.2.1.1 Column statistics
- 6.2.1.2 Multi-column statistics
- 6.2.1.3 Histogram types (equi-width, equi-depth)
- 6.2.2 Selectivity estimation
- 6.2.3 Join cardinality estimation
- 6.2.4 Estimation errors
- 6.2.4.1 Causes of misestimation
- 6.2.4.2 Impact on plan quality
- 6.2.4.3 Detecting estimation errors
- 6.2.5 Statistics maintenance
- 6.2.5.1 Manual statistics updates
- 6.2.5.2 Auto-statistics
- 6.2.5.3 Statistics staleness

## 6.3 Join Analysis
- 6.3.1 Join algorithm selection
- 6.3.1.1 Nested loop joins (when chosen, characteristics)
- 6.3.1.2 Hash joins (memory requirements, build vs. probe)
- 6.3.1.3 Merge joins (sort requirements, efficiency)
- 6.3.1.4 Index nested loop joins
- 6.3.2 Join order optimization
- 6.3.2.1 Join order search strategies
- 6.3.2.2 Join order hints
- 6.3.3 Join performance profiling
- 6.3.3.1 Spill to disk detection
- 6.3.3.2 Memory pressure from joins

## 6.4 Scan Analysis
- 6.4.1 Sequential scans
- 6.4.1.1 When sequential is optimal
- 6.4.1.2 Parallel sequential scans
- 6.4.2 Index scans
- 6.4.2.1 Index selection criteria
- 6.4.2.2 Index-only scans
- 6.4.2.3 Index scan vs. bitmap scan
- 6.4.3 Bitmap scans
- 6.4.3.1 Bitmap creation
- 6.4.3.2 Bitmap AND/OR operations
- 6.4.4 Covering indexes and scan efficiency

## 6.5 Advanced Plan Analysis
- 6.5.1 Parallel query plans
- 6.5.1.1 Parallelism decision factors
- 6.5.1.2 Gather/scatter operations
- 6.5.1.3 Parallel worker efficiency
- 6.5.2 Partitioned table plans
- 6.5.2.1 Partition pruning
- 6.5.2.2 Partition-wise joins
- 6.5.3 Subplan and CTE analysis
- 6.5.4 Plan caching and reuse
- 6.5.4.1 Plan cache hit rates
- 6.5.4.2 Plan cache pollution
- 6.5.4.3 Prepared statement plans
