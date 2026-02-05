# 48. Troubleshooting Intermittent Performance Issues

## 48.1 Intermittent Issue Characteristics
- 48.1.1 Pattern identification
- 48.1.1.1 Time-based patterns
- 48.1.1.2 Load-based patterns
- 48.1.1.3 Random occurrence
- 48.1.2 Reproducibility challenges
- 48.1.3 Evidence collection strategies

## 48.2 Investigation Techniques
- 48.2.1 Enhanced monitoring during occurrence
- 48.2.2 Wait event analysis
- 48.2.3 Lock analysis during incidents
- 48.2.4 Resource spike correlation
- 48.2.5 External dependency check

## 48.3 Common Intermittent Issue Causes
- 48.3.1 Background maintenance processes
- 48.3.1.1 Autovacuum/purge operations
- 48.3.1.2 Statistics collection
- 48.3.1.3 Backup operations
- 48.3.1.4 Index rebuilds
- 48.3.2 Checkpoint spikes
- 48.3.3 Replication lag spikes
- 48.3.4 Lock escalation
- 48.3.5 Plan changes
- 48.3.6 Resource contention from other workloads
- 48.3.7 Garbage collection pauses
- 48.3.8 Network glitches

## 48.4 Resolution Strategies
- 48.4.1 Scheduling optimization
- 48.4.2 Resource isolation
- 48.4.3 Configuration tuning
- 48.4.4 Workload separation
