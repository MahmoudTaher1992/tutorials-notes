Here is the detailed content for **Section 30: On-Premise Environment Profiling**.

---

# 30. On-Premise Environment Profiling

In an on-premise environment, the DBA has full control—and full responsibility—for the entire stack, from the physical power supply to the SQL query. Profiling here is about identifying physical resource constraints before they manifest as database latency.

## 30.1 Hardware-Level Profiling

Before tuning the database configuration, one must verify the physical machinery capabilities.

### 30.1.1 Server hardware assessment
*   **30.1.1.1 CPU specifications and utilization:** Profiling cores vs. threads. Databases benefit from high clock speeds for complex serial queries and high core counts for concurrent OLTP throughput.
*   **30.1.1.2 Memory capacity and speed:** Assessing RAM bandwidth (DDR4/DDR5) and capacity. In on-premise setups, maximizing RAM to fit the entire working set (or the whole database) in memory is the most effective optimization.
*   **30.1.1.3 Storage subsystem characteristics:** Identifying the physical media (SAS HDD vs. SATA SSD vs. NVMe). Profiling the controller’s queue depth capabilities.
*   **30.1.1.4 Network interface capabilities:** Verifying link negotiation (1Gbps vs. 10/25/40Gbps). Profiling for jumbo frame support (MTU 9000) which can significantly improve throughput for backup and replication traffic.

### 30.1.2 Hardware bottleneck identification
*   **30.1.2.1 CPU-bound workloads:** Identified by a saturated Run Queue (load average > core count). In bare metal, this is often due to context switching or poorly optimized parallel queries.
*   **30.1.2.2 Memory-bound workloads:** Identified by high page scanning rates (looking for free memory) or swapping. Even minor swapping is catastrophic for database latency.
*   **30.1.2.3 I/O-bound workloads:** Identified by high `iowait` CPU states. This indicates the CPU is idle only because it is waiting for the disk controller to return data.
*   **30.1.2.4 Network-bound workloads:** Identified by high interrupt rates on network cards or dropped packets (`ifconfig` errors) during backups or heavy query result fetching.

### 30.1.3 Hardware monitoring tools
*   **30.1.3.1 IPMI and BMC data:** Profiling "out-of-band" metrics. Even if the OS is unresponsive, the Baseboard Management Controller (iDRAC, iLO) provides data on temperature, fan speeds, and power consumption.
*   **30.1.3.2 Hardware health metrics:** Monitoring for ECC (Error-Correcting Code) memory errors. A rising count of "correctable" ECC errors is a leading indicator of physical RAM failure.
*   **30.1.3.3 Predictive failure indicators:** Using S.M.A.R.T. data for disks to profile wear levels (SSD endurance remaining) and reallocated sector counts (HDD failure pending).

## 30.2 Operating System-Level Profiling

The OS manages how the database accesses hardware. Misconfigured OS schedulers are a common source of "phantom" latency.

### 30.2.1 OS metrics collection
*   **30.2.1.1 CPU metrics:**
    *   **User:** Time spent in the database code (good).
    *   **System:** Time spent in the kernel (bad if > 20%, indicates syscall overhead).
    *   **Iowait:** CPU stalled waiting for disk.
    *   **Steal:** (Virtualization only) Time the hypervisor stole cycles for another VM.
*   **30.2.1.2 Memory metrics:**
    *   **Used:** Memory occupied by processes.
    *   **Cached:** Memory used by the filesystem cache (crucial for read performance).
    *   **Buffers:** Raw disk block storage.
    *   **Swap:** Disk space used as overflow RAM. Profiling swap in/out rates (`vmstat si/so`) is critical; any activity here kills performance.
*   **30.2.1.3 Disk metrics:** Utilization % (time the disk was busy), throughput (MB/s), and latency (service time).
*   **30.2.1.4 Network metrics:** Bandwidth usage, packet rates (PPS), and errors/collisions/retransmits (indicative of bad cabling or switch issues).

### 30.2.2 Process-level profiling
*   **30.2.2.1 Database process resource usage:** Using `top` or `pidstat` to isolate the specific database process (e.g., `mysqld`, `postgres`).
*   **30.2.2.2 Thread-level profiling:** In thread-based DBs (MySQL), identifying if a single thread is consuming 100% of a core (single-threaded bottleneck).
*   **30.2.2.3 File descriptor usage:** Monitoring `lsof`. Running out of file descriptors causes sudden connection drops or inability to open table files.

### 30.2.3 Kernel-level profiling
*   **30.2.3.1 System call profiling:** Using `strace` or `perf` to see where the DB interacts with the OS (e.g., excessive `fsync` or `open/close` calls).
*   **30.2.3.2 Kernel parameter impact:** Profiling the effect of `swappiness` (should be near 0 for DBs) and `dirty_ratio` (controls how much data sits in RAM before flushing to disk).
*   **30.2.3.3 Scheduler behavior:** Profiling context switch rates (`cs` in `vmstat`). Extremely high rates indicate the OS scheduler is thrashing tasks.

### 30.2.4 OS tuning for databases
*   **30.2.4.1 Virtual memory settings:** Profiling `vm.swappiness` and `vm.overcommit_memory`.
*   **30.2.4.2 I/O scheduler selection:** Profiling storage performance changes between `bfq`, `mq-deadline`, or `none` (for NVMe). Databases usually prefer `deadline` or `none` over fair-queuing algorithms.
*   **30.2.4.3 Network stack tuning:** Adjusting TCP buffer sizes (`net.ipv4.tcp_rmem`) to fill high-bandwidth pipes.
*   **30.2.4.4 Transparent huge pages (THP) impact:** A common profiling finding: THP often causes high latency spikes during memory compaction. Disabling THP is standard practice for Redis, MongoDB, and Oracle.

## 30.3 Virtualization Profiling

When running on-premise VMs (VMware, KVM, Hyper-V), the hypervisor introduces a "tax" on resources.

### 30.3.1 Hypervisor overhead
Profiling the difference between "wall clock time" inside the VM and actual physical time. The "virtualization tax" is typically 5-15% depending on the workload type (I/O heavy workloads pay a higher tax).

### 30.3.2 VM resource contention
*   **30.3.2.1 CPU overcommitment:** The "Noisy Neighbor" effect. Profiling **CPU Ready Time** (VMware) or **Steal Time** (KVM). High values (>5%) mean the database wants to run but the hypervisor has no physical core available.
*   **30.3.2.2 Memory ballooning impact:** The hypervisor reclaiming RAM from the guest OS. Profiling reveals this as sudden performance drops coupled with guest OS swapping, even though the guest thought it had free RAM.
*   **30.3.2.3 Storage I/O contention:** The "Blender Effect." Sequential I/O from multiple VMs merges into random I/O at the storage controller, killing throughput.

### 30.3.3 VM placement considerations
Profiling NUMA (Non-Uniform Memory Access) alignment. If a VM's vCPUs span multiple physical CPU sockets, memory access latency increases by ~30-50%.

### 30.3.4 VM vs. bare metal comparison
Benchmarking the database on bare metal vs. the VM to establish the baseline overhead. This is essential for setting realistic SLAs in virtualized environments.

### 30.3.5 Hypervisor-specific metrics
*   **30.3.5.1 VMware vSphere metrics:** `%RDY` (Ready), `%CSTP` (Co-stop - SMP scheduling issues), `%MLMTD` (Max limited - throttling).
*   **30.3.5.2 KVM/QEMU metrics:** `kvm_exit` rates (context switches between guest and host).
*   **30.3.5.3 Hyper-V metrics:** CPU Wait Time Per Dispatch.

## 30.4 Container Environment Profiling

Profiling databases in Docker/Kubernetes requires understanding cgroups and namespaces.

### 30.4.1 Container resource limits
*   **30.4.1.1 CPU limits and throttling:** Using `CPUQuota`. Profiling **CPU Throttling** metrics is critical. If a container hits its hard limit, the scheduler pauses it for the rest of the period (usually 100ms), causing massive latency spikes (the "tail latency" problem).
*   **30.4.1.2 Memory limits and OOM:** If a DB container exceeds its limit, the kernel OOM Killer kills it immediately. Profiling memory working sets to ensure `limit` > `working set`.
*   **30.4.1.3 I/O limits:** Profiling Block I/O (blkio) throttling if multiple containers share a disk.

### 30.4.2 Container overhead
Generally low (<2%), but profiling network bridging (NAT) overhead is necessary for high-throughput systems.

### 30.4.3 Container networking profiling
Profiling the cost of overlay networks (CNI plugins like Calico, Flannel, Cilium). Encapsulation (VXLAN) adds CPU overhead and lowers MTU.

### 30.4.4 Container storage profiling
*   **30.4.4.1 Volume performance:** Profiling the difference between `emptyDir`, `hostPath`, and networked Persistent Volumes (PVs).
*   **30.4.4.2 Storage driver impact:** OverlayFS is great for images but terrible for high-write database files. Profiling verifies that data files are on volumes bypassing the storage driver.

### 30.4.5 Container orchestration impact
*   **30.4.5.1 Kubernetes scheduling:** Profiling pod startup time and node selection.
*   **30.4.5.2 Pod resource requests vs. limits:** Setting `request == limit` for databases (Guaranteed QoS) to prevent eviction under node pressure.
*   **30.4.5.3 StatefulSet considerations:** Profiling the stability of network identities (DNS resolution) during pod restarts.

### 30.4.6 Container monitoring tools
*   **30.4.6.1 cAdvisor:** Built-in tool providing raw usage metrics per container.
*   **30.4.6.2 Kubernetes metrics-server:** Aggregates resource usage for autoscaling.
*   **30.4.6.3 Prometheus with container exporters:** The standard for scraping metrics from containerized databases.

## 30.5 Storage System Profiling

Storage is often the slowest component in the stack.

### 30.5.1 Local storage profiling
*   **30.5.1.1 HDD characteristics:** Profiling seek times. Random I/O on HDDs is the death of database performance (max ~150 IOPS).
*   **30.5.1.2 SSD characteristics:** Profiling write endurance and garbage collection pauses.
*   **30.5.1.3 NVMe characteristics:** Profiling parallelism. NVMe supports massive queue depths (64k queues); profiling ensures the OS and DB are configured to use them.

### 30.5.2 RAID configuration impact
*   **30.5.2.1 RAID levels comparison:**
    *   **RAID 10:** Best for DB write performance (striping + mirroring).
    *   **RAID 5/6:** Profiling the "write penalty" (read-modify-write). Generally poor for write-heavy OLTP.
*   **30.5.2.2 RAID controller cache:** Profiling the impact of Battery-Backed Write Cache (BBWC). If the battery dies and the cache switches to "Write-Through," DB write latency can jump from <1ms to >10ms.

### 30.5.3 SAN profiling
*   **30.5.3.1 Fibre Channel metrics:** Buffer credits and link saturation.
*   **30.5.3.2 iSCSI metrics:** Profiling network latency and jitter. Shared Ethernet can cause inconsistent I/O latency.
*   **30.5.3.3 SAN latency analysis:** Differentiating between "Kernel latency" (OS queue) and "Device latency" (SAN processing time).

### 30.5.4 NAS profiling
Generally an anti-pattern for high-performance DBs due to protocol overhead.
*   **30.5.4.1 NFS performance:** Profiling attribute caching (`acregmin`/`acregmax`) and synchronous write behavior (`sync` vs `async`).
*   **30.5.4.2 SMB/CIFS performance:** Higher overhead than NFS; rarely used for production DB data files.

### 30.5.5 Software-defined storage
*   **30.5.5.1 Ceph profiling:** Profiling the "double write" penalty (writing to journal, then to disk) and network replication latency. Ceph Block Device (RBD) latency is often higher than local SSDs.
*   **30.5.5.2 GlusterFS profiling:** Profiling metadata operation performance (often a bottleneck for small files).

## 30.6 On-Premise Tools (Mention Only)

### 30.6.1 OS tools
*   `top` / `htop`: Real-time process monitoring.
*   `vmstat`: Virtual memory statistics (swapping, blocks in/out).
*   `iostat`: Disk I/O utilization and latency.
*   `iotop`: Per-process I/O usage.
*   `sar`: System Activity Report (historical metrics).
*   `dstat`: Versatile resource statistics.
*   `perf`: Linux profiling tool (CPU counters, tracepoints).
*   `strace`: Tracing system calls and signals.

### 30.6.2 Network tools
*   `netstat` / `ss`: Socket statistics.
*   `iftop`: Bandwidth usage by connection.
*   `tcpdump`: Packet capture.
*   `wireshark`: Deep packet inspection.

### 30.6.3 Storage tools
*   `fio`: Flexible I/O tester (benchmarking).
*   `hdparm`: Disk parameters and simple benchmarks.
*   `smartctl`: S.M.A.R.T. data monitoring.

### 30.6.4 Monitoring stacks
*   **Prometheus + Grafana:** Time-series metric collection and visualization.
*   **Nagios / Icinga:** Status checking and alerting.
*   **Zabbix:** Enterprise-class monitoring.
*   **Datadog Agent:** (Hybrid) On-prem agent sending data to cloud SaaS.