## Part III: Application Performance

### A. Application Fundamentals
- **Performance Objectives**
    - Latency (Response time)
    - Throughput (Operations per second)
    - Resource efficiency (Cost reduction)
- **Core Principles**
    - **Optimize the Common Case**: Focusing efforts where they yield the highest ROI
    - **Observability Support**: Adding hooks and metrics during development
    - **Big O Notation**: Understanding algorithmic complexity (Time vs. Space)
- **Programming Language Impact**
    - **Compiled Languages** (C, C++, Rust, Go): CPU interaction, manual memory management
    - **Interpreted Languages** (Python, Ruby, JavaScript): Interpreter overhead, Just-In-Time (JIT) compilation
    - **Virtual Machines** (Java/JVM, Erlang/BEAM): The "Process within a Process" model
    - **Garbage Collection (GC)**: The performance cost of automatic memory management (Stop-the-world pauses)

### B. Application Performance Techniques
- **I/O Strategies**
    - **Selecting an I/O Size**: Finding the "sweet spot" for throughput
    - **Caching**: Storing results to avoid recalculation/re-fetching
    - **Buffering**: Grouping small I/O into larger chunks
    - **Polling**: CPU cost vs. latency trade-offs
- **Concurrency & Parallelism**
    - **Multiprocess**: Forking worker processes (e.g., Nginx, Apache prefork)
    - **Multithreading**: Lightweight threads within a process
    - **Event-Driven**: Event loops and callbacks (e.g., Node.js)
    - **Non-Blocking I/O**: Asynchronous operations (epoll, kqueue, io_uring)
- **Processor Binding**
    - **CPU Affinity**: Pinning processes/threads to specific cores to maximize CPU cache hits (L1/L2)

### C. Analysis Methodology
- **CPU Profiling**
    - Sampling instruction pointers (IP)
    - Identifying "hot" code paths (functions consuming the most CPU cycles)
- **Off-CPU Analysis**
    - Analyzing time spent *waiting* (blocked on I/O, locks, timers, or paging)
    - The counterpart to CPU profiling
- **Syscall Analysis**
    - Tracing the boundary between application and kernel
    - Identifying inefficient API usage
- **Thread State Analysis**
    - Categorizing time: On-CPU, waiting for I/O, waiting for run-queue, sleeping
- **Lock Analysis**
    - Identifying contention (mutexes, spinlocks)
    - The "Convoy Effect"
- **Static Performance Tuning**
    - Reviewing compilation flags (-O2, -O3)
    - Checking library versions and configurations
- **Distributed Tracing**
    - Tracking requests across microservices (Span IDs, Trace IDs)

### D. Observability Tools for Applications
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

### E. Common Pitfalls ("Gotchas")
- **Missing Symbols**
    - Seeing hex addresses (`0x4f3a...`) instead of function names
    - Stripped binaries vs. JIT symbols (e.g., Java `.map` files, Node.js `--perf-basic-prof`)
- **Missing/Broken Stacks**
    - Incomplete flame graphs or `[unknown]` frames
    - **The Frame Pointer Issue**: `-fomit-frame-pointer` compiler optimization breaking stack walking
    - Solutions: DWARF debug info, ORC (Oops Rewind Capability), or re-compiling with frame pointers