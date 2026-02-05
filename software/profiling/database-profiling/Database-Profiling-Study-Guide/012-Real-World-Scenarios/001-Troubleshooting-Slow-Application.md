# 47. Troubleshooting Slow Application

## 47.1 Initial Assessment
- 47.1.1 User-reported symptoms
- 47.1.2 Application vs. database distinction
- 47.1.3 Quick database health check
- 47.1.4 Recent changes review

## 47.2 Database-Side Investigation
- 47.2.1 Active session analysis
- 47.2.2 Slow query identification
- 47.2.3 Lock contention check
- 47.2.4 Resource utilization review
- 47.2.5 Connection pool status

## 47.3 Query-Level Investigation
- 47.3.1 Problematic query identification
- 47.3.2 Execution plan analysis
- 47.3.3 Index usage verification
- 47.3.4 Statistics freshness check

## 47.4 Common Root Causes
- 47.4.1 Missing or inefficient indexes
- 47.4.2 Statistics staleness
- 47.4.3 Lock contention
- 47.4.4 Resource exhaustion
- 47.4.5 Connection pool exhaustion
- 47.4.6 N+1 query patterns
- 47.4.7 Large result sets
- 47.4.8 Inefficient pagination

## 47.5 Resolution and Prevention
- 47.5.1 Immediate fixes
- 47.5.2 Long-term solutions
- 47.5.3 Monitoring improvements
- 47.5.4 Alerting setup
