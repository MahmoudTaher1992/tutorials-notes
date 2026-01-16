# Observability Data Sources (Where data comes from)

- **File-Based Counters (The "Pull" Model)**
    - **/proc**: The process file system (kernel statistics interface)
    - **/sys**: The sysfs file system (device and driver info)
    - **Delay Accounting**: Per-task delay metrics
    - **Netlink**: Kernel-to-user communication (for network tools)
- **Instrumentation & Probes (The "Push/Event" Model)**
    - **Tracepoints**: Static, compiled-in kernel hooks (Stable API)
    - **kprobes** (Kernel Probes): Dynamic instrumentation of any kernel function (Unstable API)
    - **uprobes** (User Probes): Dynamic instrumentation of user-space application functions
    - **USDT** (User Statically Defined Tracing): "Dtrace-style" markers compiled into applications
- **Hardware Sources**
    - **PMCs (Performance Monitoring Counters)**: CPU-level registers for low-level events (cycles, cache misses, branch mispredictions)
