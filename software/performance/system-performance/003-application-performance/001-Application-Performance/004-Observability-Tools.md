# Observability Tools for Applications

- **System-Wide Profilers**
    - **perf**: The Linux standard for CPU profiling
    - **profile**: BPF-based CPU profiler (frequency counts)
- **Off-CPU Tools**
    - **offcputime**: Visualizing where time is lost while blocking
- **System Call Tracers**
    - **strace**: The classic debugger (Warning: High overhead!)
    - **perf trace**: Low-overhead alternative to strace
    - **syscount**: Summarizing syscall counts and latencies
- **Execution Tracers**
    - **execsnoop**: Tracing new process execution (short-lived processes)
    - **bpftrace**: Custom dynamic tracing scripts for application logic
