# 31. Cloud Environment Profiling

## 31.1 Cloud Database Service Models
- 31.1.1 IaaS database profiling (self-managed on VMs)
- 31.1.2 PaaS database profiling (managed services)
- 31.1.3 DBaaS-specific considerations
- 31.1.4 Serverless database profiling

## 31.2 Cloud Resource Profiling
- 31.2.1 Compute profiling
- 31.2.1.1 Instance type selection impact
- 31.2.1.2 CPU credits (burstable instances)
- 31.2.1.3 vCPU vs. physical CPU
- 31.2.2 Memory profiling in cloud
- 31.2.2.1 Memory-optimized instances
- 31.2.2.2 Memory limits and pricing
- 31.2.3 Cloud storage profiling
- 31.2.3.1 EBS/Persistent Disk types
- 31.2.3.2 Provisioned IOPS
- 31.2.3.3 Throughput limits
- 31.2.3.4 Burst capacity
- 31.2.3.5 Storage latency
- 31.2.4 Cloud network profiling
- 31.2.4.1 Network bandwidth limits
- 31.2.4.2 Inter-AZ latency
- 31.2.4.3 Inter-region latency
- 31.2.4.4 VPC/VNet configuration impact

## 31.3 Managed Database Service Profiling
- 31.3.1 Service-level metrics
- 31.3.1.1 Available metrics vs. hidden metrics
- 31.3.1.2 Metric granularity limitations
- 31.3.2 Performance tier analysis
- 31.3.3 Auto-scaling profiling
- 31.3.3.1 Scale-up triggers
- 31.3.3.2 Scale-out triggers
- 31.3.3.3 Scaling latency
- 31.3.3.4 Scaling costs
- 31.3.4 Maintenance window impact
- 31.3.5 Backup and snapshot impact
- 31.3.6 Multi-AZ deployment profiling
- 31.3.7 Read replica profiling

## 31.4 Serverless Database Profiling
- 31.4.1 Cold start latency
- 31.4.2 Capacity unit consumption
- 31.4.3 Auto-pause and resume impact
- 31.4.4 Throughput throttling
- 31.4.5 Cost-based profiling
- 31.4.5.1 Request unit analysis
- 31.4.5.2 Storage cost analysis
- 31.4.5.3 Data transfer costs

## 31.5 Cloud Cost Profiling
- 31.5.1 Cost attribution to queries
- 31.5.2 Resource utilization vs. cost efficiency
- 31.5.3 Reserved capacity analysis
- 31.5.4 Spot/preemptible instance considerations
- 31.5.5 Data transfer cost analysis
- 31.5.6 Cost anomaly detection

## 31.6 Cloud-Specific Profiling Tools (Mention Only)
- 31.6.1 AWS: CloudWatch, RDS Performance Insights, Enhanced Monitoring, X-Ray, Cost Explorer
- 31.6.2 Azure: Azure Monitor, Query Performance Insight, Azure SQL Analytics, Cost Management
- 31.6.3 GCP: Cloud Monitoring, Cloud SQL Insights, Query Insights, Cloud Profiler, Cost Management
