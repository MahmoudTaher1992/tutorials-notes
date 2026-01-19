
**Role: Performance Engineering Teacher (Profiling + OS Fundamentals)**

# Context Switching (Performance)
## 1) What is **Context Switching**?
*   **Context switch** [CPU stops running one execution context and starts another]
    *   **Execution context** [the “state” needed to resume work later]
        *   **CPU registers** [current instruction pointer, stack pointer, general registers]
        *   **Thread or process state** [running, ready, blocked]
        *   **Memory mapping state** [which virtual memory belongs to which process]
*   Why it exists
    *   **Multitasking** [many tasks share limited CPU cores]
    *   **Responsiveness** [OS can preempt a long-running task so others run]
    *   **Waiting** [if a thread blocks on I/O, CPU runs something else]

## 2) Types of context switching (important distinctions)
*   **Thread context switch** [switch between threads within the same process]
    *   Usually cheaper than process switches
    *   Still can cause **cache disruption** [hot data gets evicted]
*   **Process context switch** [switch between different processes]
    *   Often more expensive because of
        *   **Address space switch** [different memory mappings]
        *   Potential **TLB effects** [translation cache gets less useful]
*   **User to kernel transitions** [not always called a context switch, but often related]
    *   **System call** [user code asks kernel to do work like read a file]
    *   Can add overhead and trigger scheduling decisions

## 3) When does context switching happen?
*   **Preemptive scheduling** [OS interrupts a running thread to run another]
    *   Trigger: **time slice** [fixed CPU time quantum]
    *   Trigger: **priority** [higher-priority thread becomes runnable]
*   **Blocking events** [thread cannot proceed]
    *   **I/O wait** [disk, network, database]
    *   **Lock contention** [waiting for a mutex or monitor]
    *   **Condition wait / parking** [thread voluntarily sleeps until signaled]
*   **Oversubscription** [more runnable threads than CPU cores]
    *   Causes frequent switches because many threads compete for limited cores

## 4) Why context switching can hurt performance
*   Direct costs
    *   **Save and restore state** [registers, scheduler bookkeeping]
    *   **Scheduler overhead** [deciding which thread runs next]
*   Indirect costs (often bigger in real systems)
    *   **Cache misses** [new thread’s working set is not in L1/L2/L3 caches]
    *   **TLB misses** [address translation cache less effective]
    *   **Pipeline disruption** [CPU loses speculative execution momentum]
*   Performance impact patterns
    *   **Higher latency** [requests take longer due to waiting and rewarming caches]
    *   **Lower throughput** [CPU spends time “switching” instead of “doing”]
    *   **More jitter** [P95/P99 gets worse because timing becomes less stable]

## 5) Key metrics to watch
*   **Context switches per second** [rate of switching]
*   **Voluntary context switches** [thread gave up CPU because it blocked or slept]
    *   Often points to **I/O waits** or **lock waits**
*   **Involuntary context switches** [OS preempted the thread]
    *   Often points to **CPU contention** or **too many runnable threads**
*   Related signals (to correlate)
    *   **Run queue length** [how many threads are waiting to run]
    *   **CPU utilization** vs **saturation** [100 percent busy plus queues means trouble]
    *   **Lock contention metrics** [time waiting on locks]

## 6) Common real-world causes (and what they “mean”)
*   **Too many threads**
    *   Symptom: high **involuntary switches**
    *   Meaning: threads fight for CPU, scheduler keeps rotating them
*   **Heavy lock contention**
    *   Symptom: high **voluntary switches** plus high wait time
    *   Meaning: threads frequently block and wake up
*   **Chatty I/O**
    *   Symptom: voluntary switches + low CPU time but high wall-clock time
    *   Meaning: code is mostly waiting, not computing
*   **Logging and flushing too frequently**
    *   Symptom: increased syscalls, potential blocking on I/O
*   **Small tasks scheduled too often**
    *   Symptom: overhead dominates useful work [similar to “observer effect” logic: fixed overhead becomes large]

## 7) How to measure it (practical tooling)
*   Linux quick checks
    *   `vmstat 1` [look at `cs` for context switches and `r` for run queue]
    *   `pidstat -w 1` [per-process voluntary and involuntary context switches]
    *   `top` or `htop` [thread count, load, CPU distribution]
*   Deeper Linux analysis
    *   `perf sched` [scheduler activity and latency]
    *   `perf stat` [task-clock, context-switches, migrations]
    *   `strace -c` [syscall summary, can hint at blocking sources]
*   Application-level
    *   **Tracing** [shows where time is spent waiting, across services]
    *   **Profiling** with attention to **wall-clock vs CPU time** [detect “waiting” vs “computing”]

## 8) Fix strategies (pick based on the root cause)
*   Reduce runnable-thread pressure
    *   **Right-size thread pools** [avoid creating more workers than cores for CPU-bound work]
    *   Prefer **async I/O** for I/O-bound workloads [fewer threads blocking]
*   Reduce blocking and contention
    *   Minimize **lock scope** [hold locks for less time]
    *   Use **concurrent data structures** [reduce global locks]
    *   Batch work [fewer wakeups and fewer scheduling events]
*   Improve CPU locality
    *   **CPU pinning / affinity** [keep hot threads on the same cores to preserve caches]
    *   Reduce cross-core sharing [less cache coherency traffic]
*   Validate with percentiles
    *   Watch **P50 vs P95 vs P99** [context switching often shows up as tail latency]

## 9) A simple diagnostic decision tree
*   If **wall-clock time** is high but **CPU time** is low
    *   Suspect **I/O wait** or **lock wait**
    *   Check **voluntary context switches**
*   If CPU is near 100 percent and performance is bad
    *   Check **run queue** and **involuntary context switches**
    *   Suspect **oversubscription** or **CPU-bound hotspots**
*   If P99 is bad but averages look fine
    *   Suspect **scheduler jitter**, **GC pauses**, **lock convoys** [many threads queued on one lock]

---

## Quick questions (so I tailor the next step)
*   Are you seeing context switching in **Linux**, **Windows**, or inside a specific runtime like **Java** or **Python**?
*   Is the workload more **CPU-bound** [math, encoding, parsing] or **I/O-bound** [database, network, disk]?