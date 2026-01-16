# Observability Tooling Ecosystem

- **Tool Classifications**
    - **Static Performance Tools**: checking configuration attributes (e.g., `sysctl`)
    - **Crisis Tools**: Tools installed by default for when the network is down (e.g., `top`, `vmstat`)
- **Tool Types**
    - **Fixed Counters**: Simple additive metrics
    - **Profiling**: Frequency-based sampling (Snapshotting the CPU)
    - **Tracing**: Event-based logging (Capturing every occurrence)
    - **Monitoring**: Long-term trend recording
- **Deep Dive: sar (System Activity Reporter)**
    - `sar` coverage (CPU, Disk, Net, Memory)
    - Live mode vs. Historical (log) mode
    - Understanding `sar` output columns
- **Observing Observability**
    - The "Heisenbug" principle in performance
    - Cost of tracepoints vs. cost of dynamic probes
    - Tools to measure the overhead of your monitoring tools
