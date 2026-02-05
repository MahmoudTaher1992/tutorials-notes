## 💻 User Mode vs. 🛡️ Kernel Mode

### 👤 User Mode
*   A mode where the application code runs.
*   Restricted access to machine resources; it cannot manage [them] directly.

### 🔑 Kernel Mode
*   Where the OS kernel runs.
*   Unrestricted access to machine resources.

### 🔄 Mode Switching 
*   When your application needs some system calls, the CPU [CPU] changes the mode, then it calls the kernel code.
*   It is like privliges escilations [privilege escalation].

### 📊 Profiling Analysis
*   **High User Mode time:**
    *   Optimization to the code is going to be effective.
*   **High Kernel Mode time:**
    *   Optimization to the system calls is going to be effective.
    *   **💡 e.g.:** I/O requests batching.

---

## 🔄 Context Switching (Voluntary vs. Involuntary)
*   **Concept:** A CPU core can only execute one instruction stream at a time.
*   **Purpose:** Context Switching is [used to] create an illusion of multitasking.
*   **Mechanism:** The Scheduler rapidly switches processes in and out of the CPU.
*   **⚠️ Cost:** Context switches are expensive because the CPU has to save the registers, clear the cache, and load the new process each time.
*   **📂 Types:**
    *   🙋 **Voluntary**
        *   The process gives up the CPU by itself.
        *   **Why:** Because it is waiting for something (I/O, database response, etc.) or it is done (sleeping).
        *   **Insight:** High voluntary switching indicates an external response bottle neck [bottleneck] (I/O, database response, etc.).
    *   👊 **Involuntary**
        *   The kernel kick [kicks] off the process by force.
        *   **Why:** 
            *   It took more time than its scheduled time.
            *   A higher-priority task needs to run.
        *   **Insight:** High involuntary switching indicates high competition on the CPU (You have more active threads/processes than you have CPU cores to handle them).

---

## ⚡ CPU Saturation and Load Averages

### 📈 CPU Utilization
*   Measured as a percentage (0-100%).
*   It measures how much the CPU is used to do a work [work].
*   100% utilization is a good thing until it is saturated.

### 🚫 Saturation
*   The degree to which extra work is queued (waiting) because the resource is busy
*   It is a state the [that] describes if there are tasks waiting in a queue to be executed by the CPU because it is 100% utilized.

### ⚖️ Load Averages
*   Linux metric (not available in Windows).
*   **Formula:** Load Average = # of Running processes + # of (waiting to run) processes + # of (Uninterruptible Sleep) processes.
*   **Threshold:** If the Load Average is higher than your number of CPU Cores, you are saturated (latency will go up).

---

## 🧠 Instruction-Level Profiling

### 🏎️ IPC (Instructions Per Cycle)
*   **Definition:** Stands for Instructions Per Cycle; it counts the amount of instrcutions [instructions] executed per cycle.
*   **CPU Clock Cycle:**
    *   A unit of time used by the CPU to do a work [work].
    *   Billions of cycles per second.
    *   Each cycle, the CPU does some work.
*   **High IPC:** The code it [is] efficient.
*   **Low IPC:** The CPU is "stalled" (stopped, waiting for data to arrive from RAM).

### 🔍 Cache Misses (L1/L2/L3)
*   **Data Flow:** RAM $\rightarrow$ L3 Cache $\rightarrow$ L2 $\rightarrow$ L1 $\rightarrow$ CPU Registers.
*   **Latency Gap:** L1 cache access takes ~4 cycles. RAM access takes ~300 cycles.
*   **Code Impact:** Your code behavior may affect the Cache Misses rates.
    *   Jumping around memory randomly increases the cache misses.
*   **When Cache Misses increase:**
    *   The CPU starting [starts] getting the data from far distences [distances] (memory).
    *   The CPU waste it's [wastes its] time in getting data rather than doing instrcutions [instruction] work.
    *   **Result:** High CPU usage but less application throughput.

### 🛣️ Branch Mispredictions
*   The CPU makes assumptions on the part of the code it executes; if the assumption came out wrong, it wastes CPU cycles on correcting it.