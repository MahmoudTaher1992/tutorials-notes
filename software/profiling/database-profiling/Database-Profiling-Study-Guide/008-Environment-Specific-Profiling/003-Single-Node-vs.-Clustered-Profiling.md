# 32. Single-Node vs. Clustered Profiling

## 32.1 Single-Node Profiling Focus
- 32.1.1 Vertical scaling limits
- 32.1.2 Single point of failure considerations
- 32.1.3 Resource contention within single node
- 32.1.4 Simplified profiling approach
- 32.1.5 Local resource optimization
- 32.1.6 Upgrade planning and profiling

## 32.2 Clustered Environment Profiling
- 32.2.1 Cluster topology awareness
- 32.2.1.1 Active-passive clusters
- 32.2.1.2 Active-active clusters
- 32.2.1.3 Shared-nothing clusters
- 32.2.1.4 Shared-disk clusters
- 32.2.2 Node-level vs. cluster-level metrics
- 32.2.3 Aggregating metrics across nodes
- 32.2.4 Identifying node-specific issues
- 32.2.5 Load distribution analysis
- 32.2.5.1 Load imbalance detection
- 32.2.5.2 Hot node identification
- 32.2.5.3 Rebalancing effectiveness

## 32.3 High Availability Profiling
- 32.3.1 Failover time measurement
- 32.3.2 Failover impact profiling
- 32.3.3 Split-brain detection
- 32.3.4 Quorum and consensus overhead
- 32.3.5 Health check profiling
- 32.3.6 Recovery time objective (RTO) validation

## 32.4 Cluster Communication Profiling
- 32.4.1 Inter-node latency
- 32.4.2 Cluster heartbeat overhead
- 32.4.3 State synchronization cost
- 32.4.4 Cluster membership changes
- 32.4.5 Network partition handling

## 32.5 Cluster Scaling Profiling
- 32.5.1 Scale-out profiling
- 32.5.1.1 Node addition overhead
- 32.5.1.2 Data redistribution impact
- 32.5.1.3 Rebalancing duration
- 32.5.2 Scale-in profiling
- 32.5.2.1 Node removal process
- 32.5.2.2 Data migration impact
- 32.5.3 Elasticity measurement
- 32.5.4 Scaling decision triggers
