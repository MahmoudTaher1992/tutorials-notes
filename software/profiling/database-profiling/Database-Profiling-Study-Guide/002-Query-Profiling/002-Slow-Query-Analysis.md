# 5. Slow Query Analysis

## 5.1 Identifying Slow Queries
- 5.1.1 Defining "slow" (absolute vs. relative thresholds)
- 5.1.2 Slow query logs
- 5.1.2.1 Configuration and setup
- 5.1.2.2 Log format and fields
- 5.1.2.3 Log rotation and management
- 5.1.3 Real-time slow query detection
- 5.1.4 Historical slow query analysis
- 5.1.5 Query fingerprinting and normalization

## 5.2 Slow Query Patterns
- 5.2.1 Full table scans
- 5.2.1.1 Causes and identification
- 5.2.1.2 When full scans are acceptable
- 5.2.2 Missing indexes
- 5.2.3 Inefficient joins
- 5.2.3.1 Cartesian products
- 5.2.3.2 Wrong join order
- 5.2.3.3 Missing join predicates
- 5.2.4 Suboptimal subqueries
- 5.2.4.1 Correlated subqueries
- 5.2.4.2 Subqueries vs. joins
- 5.2.5 N+1 query problems
- 5.2.6 Large result sets
- 5.2.7 Complex aggregations
- 5.2.8 Sorting without indexes
- 5.2.9 Lock contention-induced slowness

## 5.3 Query Optimization Techniques
- 5.3.1 Index-based optimizations
- 5.3.2 Query rewriting
- 5.3.2.1 Predicate optimization
- 5.3.2.2 Join reordering hints
- 5.3.2.3 Subquery to join conversion
- 5.3.3 Denormalization considerations
- 5.3.4 Partitioning for query performance
- 5.3.5 Materialized views
- 5.3.6 Query caching strategies
- 5.3.7 Batch processing vs. row-by-row

## 5.4 Verifying Query Improvements
- 5.4.1 Controlled testing methodologies
- 5.4.2 A/B testing queries
- 5.4.3 Regression testing
- 5.4.4 Production validation strategies
