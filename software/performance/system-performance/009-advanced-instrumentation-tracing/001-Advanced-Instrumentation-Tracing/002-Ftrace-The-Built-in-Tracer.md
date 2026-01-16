# Ftrace: The Built-in Tracer (Chapter 14)

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
