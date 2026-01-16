## Part IX: Advanced Instrumentation (Tracing)

### A. perf: The Linux Profiler (Chapter 13)
- **Overview**: The official Linux profiler tool, integrated into the kernel source.
- **Event Sources**:
    - **Hardware Events**: CPU counters (Cycles, Instructions, Cache misses) via PMU.
    - **Software Events**: Kernel counters (Context switches, Page faults).
    - **Tracepoints**: Static kernel instrumentation.
    - **Dynamic Probes**: kprobes (kernel) and uprobes (user).
- **Core Subcommands**:
    - **perf list**: listing available events.
    - **perf stat**: Counting events (Global or per-process).
        - Interval statistics.
        - Per-CPU balance and shadow statistics.
    - **perf record**: Sampling and recording data to `perf.data`.
        - Frequency sampling (-F) vs. Count sampling (-c).
        - Call graph (stack) recording (`-g`, `--call-graph dwarf`).
    - **perf report**: Analyzing `perf.data`.
        - TUI (Text User Interface) vs. Stdio output.
        - Navigating the "Hot path".
    - **perf script**: Dumping raw events for custom post-processing.
        - Generating **Flame Graphs** from perf script output.
    - **perf trace**: A low-overhead alternative to `strace`.
- **Advanced Features**:
    - **Probe Events**: Adding dynamic probes (`perf probe`) to running kernels or binaries.
    - **Stack Walking**: Frame pointers vs. DWARF vs. LBR (Last Branch Record).

### B. Ftrace: The Built-in Tracer (Chapter 14)
- **Overview**: The "Always available" tracer built into `/sys/kernel/debug/tracing` (tracefs).
- **Core Mechanisms**:
    - **Function Tracer**: Tracing every kernel function call (high overhead warning).
    - **Function Graph Tracer**: Tracing entry and exit (visualizing call depth).
    - **Tracepoints**: The stable kernel hooks.
- **Interface**:
    - **tracefs**: Manipulating files in `/sys` to control tracing (echoing text into files).
    - **trace-cmd**: The standard front-end CLI for Ftrace (easier than raw tracefs).
    - **KernelShark**: Graphical UI for `trace-cmd` data.
- **Key Capabilities**:
    - **kprobes/uprobes integration**: Using Ftrace to hook dynamic functions.
    - **Hist Triggers**: Creating histograms/summaries in-kernel (zero overhead userspace).
    - **HWLAT**: Hardware Latency detector (finding System Management Interrupts/SMI).
- **perf-tools**:
    - Brendan Gregg's suite of shell scripts wrapping Ftrace/perf (`iosnoop`, `iolatency`, `execsnoop`).
    - **Design**: "Hackable" scripts relying only on standard tools (no compiler needed).

### C. BPF: The Modern Revolution (Chapter 15)
- **Overview**: Extended BPF (eBPF) – Running sandboxed, high-performance programs in the kernel.
- **BCC (BPF Compiler Collection)**:
    - **Language**: Python/Lua frontends for C BPF code.
    - **Tool Coverage**: The "BCC Tools" suite (`biolatency`, `execsnoop`, `tcplife`, etc.).
    - **Use Case**: Complex tools requiring Python data processing.
- **bpftrace**:
    - **Language**: High-level, awk-like scripting language for BPF.
    - **Capabilities**: One-liners for instant analysis.
    - **Probes**:
        - `kprobe:` / `kretprobe:` (Kernel dynamic)
        - `uprobe:` / `uretprobe:` (User dynamic)
        - `tracepoint:` (Static)
        - `software:` / `hardware:` (Counters)
        - `profile:` (Timed sampling)
    - **Maps**: Associative arrays for counting and aggregation (`@map[key] = count()`).
    - **Aggregations**: `hist()`, `lhist()`, `avg()`, `sum()`, `min()`, `max()`.
- **Comparison**:
    - **perf**: Standard CPU profiling.
    - **Ftrace**: Standard built-in function tracing.
    - **BCC/bpftrace**: Programmable, deep visibility, custom metrics.

## Part X: Synthesis & Reference

### A. Case Study: Solving a Real Problem (Chapter 16)
- **The Scenario**: "An Unexplained Win" (Performance improved, but nobody knew why).
- **The Workflow**:
    1.  **Problem Statement**: Define the observation clearly.
    2.  **Analysis Strategy**: Choosing the right tools.
    3.  **Statistics**: Checking standard metrics (load, I/O).
    4.  **Configuration**: Checking for changes in settings.
    5.  **PMCs**: Using Hardware Counters (Instructions per cycle) to find micro-architectural clues.
    6.  **Software Events**: Checking page faults and scheduler events.
    7.  **Tracing**: Using `perf` to find the exact function causing the difference.
    8.  **Conclusion**: Identifying the root cause (instruction layout/cache effects).

### B. Appendices & Reference Materials
- **Appendix A: The USE Method (Linux)**
    - A specific checklist mapping {Utilization, Saturation, Errors} to specific Linux tools for CPUs, Memory, Network, Disk, and Controllers.
- **Appendix B: sar Summary**
    - A quick reference for `sar` flags (e.g., `-u` for CPU, `-r` for RAM, `-d` for Disk).
- **Appendix C: bpftrace One-Liners**
    - A "Cheat Sheet" of powerful one-line commands to diagnose various subsystems immediately.
- **Appendix D: Solutions to Selected Exercises**
    - Answers to the questions posed at the end of each chapter.
- **Appendix E: Systems Performance Who’s Who**
    - Key figures in the history of performance engineering (e.g., Little's Law author).
- **Glossary**
    - Definitions of key terms (IOPS, Latency, Throughput, Saturation, etc.).