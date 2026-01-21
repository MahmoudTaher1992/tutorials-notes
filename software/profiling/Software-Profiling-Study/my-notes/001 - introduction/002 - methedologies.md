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