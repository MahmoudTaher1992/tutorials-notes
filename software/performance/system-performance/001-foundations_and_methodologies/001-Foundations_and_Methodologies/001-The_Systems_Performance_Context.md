This document outline covers the **foundational knowledge required for Systems Performance Engineering**. It appears to be heavily influenced by the industry-standard work of experts like Brendan Gregg (author of *Systems Performance*).

Here is a detailed explanation of each section within Part I.

---

### A. The Systems Performance Context
This section sets the stage: before looking at code or servers, you must understand the environment.

*   **The Performance Environment:**
    *   **Complexity:** Modern apps aren't just one server. They are software stacks (Java on Linux) running on virtual machines, running on clouds (AWS/Azure). Finding a problem involves peeling back these layers.
    *   **Subjectivity:** "The system is slow" is a subjective statement. An engineer might look at CPU load and say it's fine, while a user sees a spinning loading icon. You must define what "slow" means objectively (e.g., "Page loads take >2 seconds").
    *   **Multiple Causes:** It is rarely just *one* thing. Usually, a slow database causes a queue in the app server, which causes a timeout in the load balancer.
*   **Roles:** SREs (Site Reliability Engineers) and DevOps focus on the system in production, while Core Engineering focuses on feature code. Performance is the bridge between them.
*   **Perspectives:**
    *   **User Perspective:** Cares about **Latency** (how long do I wait?).
    *   **Resource Perspective:** Cares about **Utilization** (how busy is my expensive hardware?).
*   **Cloud Implications:** You don't own the hardware.
    *   **Noisy Neighbors:** Another company running a heavy workload on the same physical server might steal your CPU cycle or disk I/O.
    *   **Virtualization Overhead:** The "tax" the OS pays to translate virtual requests to physical hardware.

### B. Core Terminology and Concepts
This section defines the vocabulary so everyone speaks the same language.

*   **Latency:** The time spent waiting for an operation to perform.
    *   **The "99th Percentile" (p99):** If your average speed is fast, but 1% of your users wait 10 seconds, that 1% (the 99th percentile) determines your reputation. Analyzing the "tail" is more important than the average.
*   **Time Scales:** Humans have bad intuition for computer time.
    *   *Analogy:* If 1 CPU cycle = 1 Second...
    *   Accessing RAM ≈ 6 Minutes.
    *   Accessing Disk (SSD) ≈ 2-6 Days.
    *   Network Packet (Internet) ≈ Years.
    *   *Lesson:* Avoid going to Disk or Network whenever possible; it is astronomically expensive.
*   **Utilization vs. Saturation:**
    *   **Utilization:** The road is 100% full of cars, but they are moving at 60mph. (Busy, but working).
    *   **Saturation:** The road is 100% full, and cars are backing up on the on-ramp waiting to get on. (Queued work). Saturation kills performance.
*   **The "Unknowns":**
    *   **Known-Knowns:** You know the CPU is high.
    *   **Known-Unknowns:** You know the DB is slow, but don't know why.
    *   **Unknown-Unknowns:** A random bug in the kernel you didn't even know existed is causing the issue.

### C. Types of Observability
How do we see inside the "Black Box"?

*   **Counters/Metrics:** "How many?" (e.g., Total HTTP requests = 50,000). Good for high-level health.
*   **Profiling (Sampling):** "What is the CPU doing right now?" A profiler takes a snapshot of the CPU 100 times a second. If 80 of those snapshots show the CPU inside `function_calculate_tax()`, you know that function is the bottleneck.
*   **Tracing:** "Follow the bouncing ball." A trace assigns an ID to a user request and logs every hop it makes (Load Balancer -> App Server A -> Database). It shows exactly where the time went for a *specific* request.

### D. Analytical Methodologies (The Frameworks)
This is the most critical section. It teaches you **how to think** so you don't panic during an outage.

*   **The Anti-Methods (What NOT to do):**
    *   **Streetlight:** Checking the CPU just because `top` is easy to run, even if the problem is network-related.
    *   **Random Change:** "Let's double the RAM." "Let's restart MySQL." This destroys evidence and rarely fixes the root cause.
*   **The Scientific Method:** Use logic. "I see high latency. I hypothesize it is the database. I predict if I check DB logs, I see slow queries. Test: Check logs."
*   **The USE Method (For Hardware):** Invented by Brendan Gregg. For every resource (CPU, Memory, Disk, Network), check:
    1.  **U**tilization (Is it busy?)
    2.  **S**aturation (Is work queuing?)
    3.  **E**rrors (Are things failing?)
*   **The RED Method (For Services):** For every microservice endpoint:
    1.  **R**ate (Requests per second)
    2.  **E**rrors (How many 500s?)
    3.  **D**uration (How long does it take?)
*   **Linux Performance in 60 Seconds:** A standard checklist of commands (`uptime`, `dmesg`, `vmstat`, `iostat`) to run immediately when logging into a Linux box to get situational awareness.

### E. Modeling and Capacity Planning
How do we predict when the system will crash?

*   **Scalability Laws:**
    *   **Amdahl’s Law:** The maximum speedup of a task is limited by its serial part. If 5% of your program cannot be parallelized, adding 1,000 CPUs won't make it infinitely fast.
    *   **Universal Scalability Law (USL):** It gets worse. Adding more CPUs eventually *slows you down* because the CPUs have to talk to each other directly (coherency/crosstalk) to manage data.
*   **Queueing Theory (The Hockey Stick):**
    *   As utilization approaches 100%, response time does not increase linearly; it increases exponentially.
    *   *Rule of Thumb:* Once a resource hits 70-80% utilization, latency spikes vertically (the blade of the hockey stick).

### F. Statistics for Performance
Math is required to interpret data correctly.

*   **The Problem with Averages:**
    *   If request A takes 1ms and request B takes 9.9 seconds. The average is ~5 seconds. That number describes *neither* user's experience. Averages hide spikes.
*   **Percentiles:**
    *   **p50 (Median):** The "typical" user.
    *   **p99:** The user experiencing the worst performance (often the most important metric for reliability).
*   **Multimodal Distributions:** In computing, data often has two "humps" (modes).
    *   *Example:* Disk I/O latency. One hump is very fast (0.1ms - Cache Hit), the second hump is slow (5ms - Cache Miss / Physical Disk). An average would land in the middle (2.5ms), describing a scenario that never actually happens.

### G. Visualization and Monitoring
How to look at the data so the problem becomes obvious.

*   **Pattern Recognition:** looking for "The 9am Login Spike" or "The Hourly Batch Job."
*   **Why Line Charts Fail:** They often average out data over 1-minute intervals, erasing the split-second spikes that crash servers.
*   **Heat Maps:** Instead of a single line, a heat map shows a cloud of dots. It allows you to see the "Multimodal" distributions (two layers of clouds) mentioned in section F.
*   **Flame Graphs:** A specific visualization for CPU profiling. They stack function calls on top of each other. The wider the bar, the more CPU time that function is using. It allows engineers to identify the bottleneck in code instantly.
