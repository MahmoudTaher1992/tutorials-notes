# 18. Index Performance Impact

## 18.1 Index Read Performance
- 18.1.1 Index scan efficiency
- 18.1.2 Index-only scan coverage
- 18.1.3 Key lookup overhead
- 18.1.4 Bookmark lookup analysis
- 18.1.5 Index caching effectiveness

## 18.2 Index Write Overhead
- 18.2.1 Insert overhead per index
- 18.2.2 Update overhead analysis
- 18.2.3 Delete overhead and ghost records
- 18.2.4 Index page splits
- 18.2.4.1 Page split frequency
- 18.2.4.2 Page split impact
- 18.2.4.3 Fill factor tuning
- 18.2.5 Index locking during writes

## 18.3 Index Memory Impact
- 18.3.1 Index buffer pool usage
- 18.3.2 Index cache hit rates
- 18.3.3 Index memory pressure
- 18.3.4 Index preloading/warming

## 18.4 Index and Query Optimization
- 18.4.1 Composite index design
- 18.4.2 Index consolidation opportunities
- 18.4.3 Index hints and forcing
- 18.4.4 Index anti-patterns
- 18.4.4.1 Over-indexing
- 18.4.4.2 Redundant indexes
- 18.4.4.3 Wide indexes misuse
- 18.4.4.4 Wrong column order
