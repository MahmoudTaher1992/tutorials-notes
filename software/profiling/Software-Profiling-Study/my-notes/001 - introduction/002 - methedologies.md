# 🛠️ Core Methodologies

## 🔍 Instrumentation
*   **Definition:** Involves inserting code into the original code that sends data outside; the aim is to get insights.
*   **Risk:** It carries the risk of introducing an overhead that distorts the original results.
*   **📂 Types:**
    *   **✍️ Source Code Modification (Manual instrumentation)**
        *   You explicitly change your code to add the code that will send the data outside.
        *   **✅ Pros:**
            *   You are in control.
        *   **❌ Cons:**
            *   Takes time and effort.

    *   **🤖 Binary Injection (Automatic instrumentation)**
        *   An automated approach where the profiling tool modifies the compiled program at runtime or load time.
        *   **e.g.:**
            *   Wrapping.
            *   Code injection.
        *   **✅ Pros:**
            *   Quick implementation.
        *   **❌ Cons:**
            *   High overhead.
            *   Lots of noisy output data.

---

## ⏱️ Sampling 
*   **Definition:** Instead of measuring stuff continuously, we measure at intervals/frequency.
*   **Mechanism:** The profiler estimates the execution time/result from the frequency measuring results.
*   **✅ Pros:**
    *   This technique is used to decrease the overhead.
*   **❌ Cons:**
    *   Some very fast functions/targets may be missed because of them outrunning the measuring code frequency (**Blind spot**).
## 📍 Tracing
*   **Definition:** It is the process of regiestering [registering] the lifecycle of events.
*   **Mechanism:** It regesters [registers] the start timestamp and end time stamp [timestamp] of events.
*   **💡 Examples:**
    *   **🌐 Distributed Tracing**
        *   Jaeger
        *   Zipkin
    *   **💻 Syscall Tracing**
        *   strace
*   **🔄 Difference from Sampling:**
    *   **Sampling:** Tells you that function A took *x* ms.
    *   **Tracing:** Tells you the specific start and end timestamp.

---

## 🎮 Emulation
*   **Definition:** The process of running code/program on simulated hardware.
*   **📱 Common In:** 
    *   Mobile development.
    *   Embeded [Embedded] systems.
*   **⚖️ Logic vs. Performance:** Emulation is great in checking logic correcteness [correctness], but not in performace [performance] measuring.
*   **❌ Risk:** Using emulation in profiling results an inaccurate results [results in inaccurate results], because of the dirfferent [different] environments.
*   **✅ Best Practice:** Always profile performance on real devices.

---

## ⚖️ Deterministic vs. 🎲 Non-deterministic Profiling

### ⚖️ Deterministic Profiling
*   **Definition:** Profiling results that doesn't [don't] change.
*   **Consistency:** Each time you measure it, you get the same results.
*   **💡 e.g.:** Function A calls number [Function A call counts].

### 🎲 Non-deterministic Profiling
*   **Definition:** Profiling results that always change.
*   **Consistency:** Each time you measure it, you get a different result.
*   **💡 e.g.:** CPU usage while running a specific function.
*   **🎯 Purpose:** Used in getting insights.

---

## 🕙 Wall-clock Time vs. 💻 CPU Time

### 💻 CPU Time
*   **Definition:** The amount of time the processor spent actually executing instructions for your code.
*   **🛠️ Optimization:** If CPU time is high, you need to optimize your algorithms.

### 🕙 Wall-clock Time
*   **Definition:** The total time elapsed from the start of a function to the end.
*   **🧮 Formula:** Wall Time = CPU Time + Wait Time.
    *   **⏳ Wait Time:** Time spent sleeping, waiting for a Database response, waiting for a file to read, or waiting for a Lock/Mutex.
*   **⚠️ Insight:** [If wait time is high], optimizing the code loop won't help; you need to fix the database or network.