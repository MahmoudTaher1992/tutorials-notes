**Role: OS + Performance Engineering Teacher**

# CPU **Cores**
## 1) What is a **CPU core**?
*   **CPU core** [an independent processing unit inside a CPU that can execute instructions]
    *   Think of a CPU as a chip that may contain **multiple cores**
    *   Each core can run program instructions “in parallel” with other cores

## 2) Why cores matter
*   **More cores** = ability to run more work at the same time
    *   If you have **4 cores**, the OS can run up to **4 threads truly at the same time** (one per core)  
        *   If there are more runnable threads than cores, the OS uses **context switching** [takes turns]
*   For performance:
    *   **CPU-bound workloads** [heavy calculations] benefit a lot from more cores
    *   **I/O-bound workloads** [waiting on disk/network] may not speed up much just by adding cores

## 3) Core vs CPU vs thread (common confusion)
*   **CPU (chip/socket)** [the physical processor package]
    *   Contains **cores**
*   **Core** [does the execution]
*   **Thread (software thread)** [a schedulable unit of work the OS runs on cores]
    *   Threads are mapped onto cores by the OS scheduler

## 4) Physical cores vs “logical” cores (Hyper-Threading / SMT)
*   **Physical core** [real hardware execution core]
*   **Logical core** / **hardware thread** [a core that appears as 2 (or more) to the OS using **SMT**]
    *   Example: **4 physical cores** with SMT can appear as **8 logical cores**
    *   Benefit: better utilization when one thread is stalled (e.g., waiting on memory)
    *   Limitation: it’s **not the same as doubling performance** [they share execution resources]

## 5) Why cores show up in profiling
*   They determine your maximum parallelism
    *   If you run **too many runnable threads** relative to cores → more **involuntary context switching** and worse **P95/P99 latency**
*   They help interpret metrics
    *   “CPU is 400%” in some tools = **4 cores fully busy**

If you tell me your machine specs (or OS output), I can explain exactly how many **physical** and **logical** cores you have and what that implies for your profiling results.