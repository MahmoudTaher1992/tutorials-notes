This section of the syllabus marks the transition from **traditional system administration** to **modern, programmable kernel analysis**. It covers how we ask the Linux Operating System what it is doing, and how that method has evolved from simple counters to sophisticated, safe code injection.

Here is a detailed breakdown of **Part VI: Linux Observability & eBPF**.

---

## A. Standard Linux Tools (The "Classic" Toolkit)

Before eBPF came along, engineers relied on a specific set of binary utilities to diagnose performance. These tools mostly read from static counters provided by the Linux kernel (usually found in the `/proc` or `/sys` file systems).

### 1. Top, Htop, Atop
These are the dashboard views of your system.
*   **Top:** The oldest standard. It provides a real-time list of running processes ordered by CPU or Memory usage.
*   **Htop:** A more user-friendly, colorful version of Top that allows for scrolling and mouse interaction.
*   **Atop:** The "Advanced" top. It is unique because it can log historical data. If a server crashed at 3 AM, `top` won't tell you what happened, but `atop` (if configured to log) allows you to "rewind" time and see the system state at 3 AM.

### 2. The `*stat` Tools (`vmstat`, `iostat`, `netstat`, `mpstat`)
These tools provide high-level **metrics** rather than process details.
*   **vmstat (Virtual Memory Statistics):** Tells you if you are swapping memory (bad) or have high context switching.
*   **iostat:** Essential for disk latency. It tells you how long I/O requests wait in the queue.
*   **mpstat:** Shows CPU usage breakdown **per core**. Essential for detecting if a single-threaded application is maxing out one CPU core while the rest of the server is idle.

### 3. `strace` (System Call Tracing)
This is a powerful but dangerous tool.
*   **What it does:** It intercepts every single "System Call" a program makes. If your program wants to read a file, open a network socket, or allocate memory, it must ask the Kernel. `strace` logs these requests.
*   **The Problem:** `strace` works by pausing the application at every step to record the action. This introduces massive **overhead** (slowness). Using `strace` on a production database can slow it down by 10x or 100x, potentially causing an outage.

### 4. `perf` (Linux Profiling Subsystem)
`perf` is the standard Linux profiler.
*   It uses hardware performance counters (PMU) built into your CPU.
*   It can count how many CPU cycles a function takes, how many cache misses occurred, or how many branch mispredictions happened.
*   Unlike `strace`, `perf` is **sampling-based**, making it much faster and safer to use in production.

---

## B. Modern eBPF (Extended Berkeley Packet Filter)

eBPF is considered the biggest change to Linux networking and observability in the last decade. It turns the Linux Kernel into a programmable engine.

### 1. Architecture of eBPF (Safe Kernel-Space Instrumentation)
In the past, if you wanted to measure something inside the Linux Kernel that standard tools didn't cover, you had to write a **Kernel Module**.
*   **The Old Risk:** If your Kernel Module had a bug, the entire Operating System would crash (Kernel Panic).
*   **The eBPF Solution:** eBPF allows you to write mini-programs that run **inside** the Kernel, but inside a **Sandbox**.
    *   **The Verifier:** Before the kernel runs your eBPF code, it analyzes it. If your code has infinite loops or tries to access invalid memory, the Verifier rejects it.
    *   **JIT (Just-In-Time) Compiler:** The code is compiled to native machine code, making it incredibly fast.
    *   **Result:** You get the deep visibility of `strace` with the low overhead of `perf`, and the safety of a sandbox.

### 2. BCC (BPF Compiler Collection)
BCC is a toolkit that makes writing eBPF programs easier.
*   Writing raw eBPF bytecode is extremely difficult.
*   BCC allows you to write the "User space" part of the tool in **Python** (or Lua) and the "Kernel space" part in restricted C.
*   **Pre-built Tools:** BCC comes with dozens of famous tools ready to use, such as:
    *   `execsnoop`: Watch every new process start on the system in real-time.
    *   `opensnoop`: See every file being opened by any application.
    *   `biolatency`: Measure disk I/O latency distributions (histograms) rather than just averages.

### 3. `bpftrace` One-Liners
While BCC is powerful, it requires writing a lot of code. `bpftrace` is a high-level scripting language for eBPF, similar to `awk` or `sed`.
*   It allows you to type a single command to ask complex questions.
*   **Example:** "Count the number of times `malloc` is called by process PID 1234 every second."
    *   *With BCC:* 50 lines of Python + C.
    *   *With bpftrace:* 1 line of code.

### 4. Uprobes vs. Kprobes (The Hooks)
To profile software with eBPF, you need to attach your program to an "Event."
*   **Kprobes (Kernel Probes):**
    *   These hook into **Kernel functions**.
    *   *Use case:* "Alert me whenever the TCP stack retransmits a packet" or "Measure how long the disk write function takes."
*   **Uprobes (User Probes):**
    *   These hook into **User-space functions** (your actual application code: C++, Go, Rust, etc.).
    *   *Use case:* "Trace the `HTTPHandleRequest` function in my web server."
    *   This allows eBPF to spy on your application code without changing or recompiling your application.

### Summary of the Shift
*   **Classic (Part VI.A):** We look at **averages** and **counters** (e.g., "CPU is at 80%").
*   **Modern eBPF (Part VI.B):** We look at **individual events** with context (e.g., "The CPU is at 80% because function `process_image()` is running on this specific JPEG file").
