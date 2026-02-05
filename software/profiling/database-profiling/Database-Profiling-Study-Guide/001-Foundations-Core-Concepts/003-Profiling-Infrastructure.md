# 3. Profiling Infrastructure

## 3.1 Data Collection Methods
- 3.1.1 Polling/Pull-based collection
- 3.1.1.1 Advantages and disadvantages
- 3.1.1.2 Polling frequency considerations
- 3.1.2 Push-based collection
- 3.1.2.1 Agent-based approaches
- 3.1.2.2 Database-native push mechanisms
- 3.1.3 Event-driven collection
- 3.1.3.1 Hooks and triggers
- 3.1.3.2 Change data capture for profiling
- 3.1.4 Sampling strategies
- 3.1.4.1 Random sampling
- 3.1.4.2 Systematic sampling
- 3.1.4.3 Adaptive sampling
- 3.1.4.4 Head-based vs. tail-based sampling

## 3.2 Profiling Overhead
- 3.2.1 Understanding observer effect
- 3.2.2 CPU overhead of profiling
- 3.2.3 Memory overhead
- 3.2.4 I/O overhead (especially logging)
- 3.2.5 Network overhead
- 3.2.6 Minimizing profiling impact
- 3.2.6.1 Selective profiling
- 3.2.6.2 Sampling rates
- 3.2.6.3 Asynchronous collection
- 3.2.6.4 Off-peak profiling

## 3.3 Storage for Profiling Data
- 3.3.1 Short-term vs. long-term retention
- 3.3.2 Time-series databases for metrics
- 3.3.3 Log aggregation systems
- 3.3.4 Data compression strategies
- 3.3.5 Retention policies

## 3.4 Visualization and Alerting
- 3.4.1 Dashboard design principles
- 3.4.2 Time-series visualization
- 3.4.3 Heatmaps and histograms
- 3.4.4 Alert threshold definition
- 3.4.5 Anomaly detection basics
- 3.4.6 Alert fatigue prevention
