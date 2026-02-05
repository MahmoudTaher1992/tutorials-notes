# 4. Query Execution Fundamentals

## 4.1 Query Processing Pipeline
- 4.1.1 Query parsing
- 4.1.1.1 Lexical analysis
- 4.1.1.2 Syntax validation
- 4.1.1.3 Parse tree generation
- 4.1.2 Query rewriting
- 4.1.2.1 View expansion
- 4.1.2.2 Subquery transformation
- 4.1.2.3 Predicate pushdown
- 4.1.3 Query optimization
- 4.1.3.1 Cost-based optimization
- 4.1.3.2 Rule-based optimization
- 4.1.3.3 Heuristic optimization
- 4.1.4 Query execution
- 4.1.4.1 Execution engines
- 4.1.4.2 Operator models (volcano/iterator, vectorized, compiled)
- 4.1.5 Result delivery
- 4.1.5.1 Result set buffering
- 4.1.5.2 Streaming results
- 4.1.5.3 Cursor-based delivery

## 4.2 Execution Plans
- 4.2.1 What is an execution plan?
- 4.2.2 Logical vs. physical plans
- 4.2.3 Plan operators
- 4.2.3.1 Scan operators (sequential, index, bitmap)
- 4.2.3.2 Join operators (nested loop, hash, merge, index)
- 4.2.3.3 Aggregation operators
- 4.2.3.4 Sort operators
- 4.2.3.5 Set operators (union, intersect, except)
- 4.2.4 Reading execution plans
- 4.2.4.1 Plan tree structure
- 4.2.4.2 Cost estimates
- 4.2.4.3 Row estimates (cardinality)
- 4.2.4.4 Actual vs. estimated values
- 4.2.5 Plan stability
- 4.2.5.1 Plan changes over time
- 4.2.5.2 Parameter sensitivity
- 4.2.5.3 Plan regression detection
- 4.2.5.4 Plan pinning/forcing

## 4.3 Query Statistics
- 4.3.1 Execution time breakdown
- 4.3.1.1 Planning time
- 4.3.1.2 Execution time
- 4.3.1.3 Network time
- 4.3.2 I/O statistics
- 4.3.2.1 Buffer hits vs. disk reads
- 4.3.2.2 Pages read/written
- 4.3.2.3 Temporary file usage
- 4.3.3 Memory statistics
- 4.3.3.1 Work memory usage
- 4.3.3.2 Sort memory
- 4.3.3.3 Hash table memory
- 4.3.4 Row statistics
- 4.3.4.1 Rows scanned
- 4.3.4.2 Rows filtered
- 4.3.4.3 Rows returned
