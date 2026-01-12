**Role:** I am your **Computer Science Performance Engineering Teacher**. Today we are looking at why computer programs sometimes freeze or get slow when they try to do too many things at once.

---

### **Summary: Lock Analysis & Concurrency Bottlenecks**

*   **1. Contention Profiling**
    *   (This is what happens when two threads fight over the same resource, like two students trying to use the single bathroom pass at the same time.)
    *   **Mutexes (Mutual Exclusion)**
        *   **Mechanism**: Sleep Mode
            *   (If the resource is busy, the Operating System puts the waiting thread to sleep and lets someone else work.)
        *   **The Cost**: **Context Switching**
            *   (Saving the current work and loading new work takes time and effort.)
        *   **Symptoms of Bad Performance**:
            *   **High Voluntary Context Switches** (The system is spending too much time switching tasks rather than doing them.)
            *   **Low CPU Utilization** (The computer looks lazy because everyone is asleep waiting for a turn.)
    *   **Spinlocks**
        *   **Mechanism**: Busy Waiting
            *   (Instead of sleeping, the thread runs a `while(true)` loop asking "Is it free? Is it free?" millions of times a second.)
        *   **The Cost**: **High CPU Burn**
            *   (It wastes 100% of the processor's energy just to ask a question.)
        *   **Symptoms of Bad Performance**:
            *   **High User CPU Usage** (The fan is spinning loud, but the program isn't finishing work.)
            *   **Hotspots in Atomic Instructions** (The profiler shows time spent in low-level locking code, not your actual program logic.)

*   **2. Logic Errors (Deadlocks & Livelocks)**
    *   (These are bugs where the logic gets stuck.)
    *   **Deadlocks**
        *   **The Scenario**: The Standoff
            *   (Thread A has Key 1 and wants Key 2. Thread B has Key 2 and wants Key 1. Neither will let go, so they wait forever.)
        *   **Profiling Signs**:
            *   **Total Silence** (CPU usage drops to 0%.)
            *   **Detection Tools** (Profilers explicitly warn: "Found Deadlock between Thread A and B".)
    *   **Livelocks**
        *   **The Scenario**: The "Hallway Dance"
            *   (Like when you meet someone in a hallway: you step left, they step left. You step right, they step right. You are both moving, but nobody passes.)
        *   **Profiling Signs**:
            *   **High CPU Usage** (Threads are active and running.)
            *   **Zero Throughput** (Despite the effort, no actual work gets finished.)
            *   **Repetitive Stack Traces** (The code just bounces back and forth between two states.)

*   **3. Scheduling Fairness**
    *   (Who gets to go first?)
    *   **Starvation**
        *   **Concept**: The Bully Effect
            *   (A low-priority thread never gets a turn because high-priority threads keep cutting in line.)
        *   **Profiling Signs**:
            *   **Bad Tail Latency** (Most requests are fast, but the unfortunate 1% take forever to complete.)
    *   **Priority Inversion**
        *   **Concept**: The Traffic Jam
            *   (A High-Priority task is waiting for a Low-Priority task to finish. But a Medium-Priority task distracts the Low-Priority task, causing the High-Priority task to wait excessively.)
        *   **Profiling Signs**:
            *   **Blocked Critical Threads** (Important tasks are stuck waiting on unimportant background tasks.)

*   **4. Hardware Issues: False Sharing**
    *   (This is a tricky invisible problem inside the CPU memory.)
    *   **The Problem**: **Cache Line Conflict**
        *   (CPUs read memory in chunks called "Cache Lines"—usually 64 bytes. Imagine a shared desk where two students sit.)
        *   **The Scenario**:
            *   Variable A and Variable B are next to each other in memory (on the same desk).
            *   Thread 1 writes to A. Thread 2 writes to B.
            *   Because they share the "desk" (Cache Line), every time Thread 1 writes, the CPU forces Thread 2 to re-read the whole desk from slow memory.
    *   **The Result**: **Cache Thrashing**
        *   (The threads aren't logically sharing data, but they fight over the physical storage space.)
    *   **Profiling Signs**:
        *   **High CPI** (Cycles Per Instruction are unusually high.)
        *   **Cache Coherency Misses** (Requires advanced hardware profiling tools to see.)
