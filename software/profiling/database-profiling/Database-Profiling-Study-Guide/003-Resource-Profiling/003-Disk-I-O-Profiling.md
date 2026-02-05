# 9. Disk I/O Profiling

## 9.1 Database I/O Patterns
- 9.1.1 Random vs. sequential I/O
- 9.1.2 Read vs. write patterns
- 9.1.3 Synchronous vs. asynchronous I/O
- 9.1.4 Direct I/O vs. buffered I/O

## 9.2 I/O Metrics
- 9.2.1 IOPS (read/write)
- 9.2.2 Throughput (MB/s)
- 9.2.3 Latency (average, percentiles)
- 9.2.4 Queue depth
- 9.2.5 I/O wait time

## 9.3 Storage Components Profiling
- 9.3.1 Data files I/O
- 9.3.2 Index files I/O
- 9.3.3 Transaction log/WAL I/O
- 9.3.4 Temporary files I/O
- 9.3.5 Checkpoint I/O patterns
- 9.3.6 Background writer activity

## 9.4 I/O Bottleneck Identification
- 9.4.1 Storage saturation detection
- 9.4.2 I/O wait analysis
- 9.4.3 Hot files/tables identification
- 9.4.4 Log write bottlenecks
- 9.4.5 Checkpoint spikes

## 9.5 I/O Optimization
- 9.5.1 Storage configuration (RAID, SSDs, NVMe)
- 9.5.2 Filesystem selection and tuning
- 9.5.3 File placement strategies
- 9.5.4 I/O scheduler tuning
- 9.5.5 Read-ahead configuration
- 9.5.6 Write-back vs. write-through caching
