# 📋 Definitions

## 📊 Monitoring
*   **❓ Question:** *Is it healthy?*
*   **🏗️ Basis:** Depends on metrics.
*   **📂 Data:** Metrics are data collected from the system in a time-series format.
*   **📤 Output:**
    *   **📈 Graphs**
        *   **✅ Benefits:** Quick to read; shows peaks and troughs.
        *   **❌ Limitation:** Tells you there is a problem (and when it happened), but not the cause (what it is).
    *   **🔔 Alerting**
        *   **⚙️ Process:** Logic evaluates the graph $\rightarrow$ triggers alarms $\rightarrow$ triggers action.
        *   **💡 Examples:** Sending notifications or starting auto-scaling.

---

## 🔍 Traditional Profiling 
*(Non-OpenTelemetry Profiling)*
*   **❓ Question:** *Why is it slow?*
*   **⚙️ Function:** Provides detailed behavior of compiled code and resource usage.
*   **📊 Data Examples:**
    *   **📜 Stack traces:** Shows the sequence of function execution (especially during errors).
    *   **🧠 Memory allocation:** Tracks how memory is used.
    *   **⚡ CPU analysis:** Analyzes instruction execution.
*   **🎯 Goal:** Identify where resources are consumed and where bottlenecks exist.
*   **🩺 Analogy:** It is like an **MRI scan**.

---

## 🪲 Debugging
*   **❓ Question:** *What is the problem?*
*   **🎯 Focus:** Focuses on the logic and the flow of the code.
*   **📂 Data:** Variable states, breakpoints, and step-by-step execution.
*   **🏁 Goal:** Determine the cause of the problem to propose and execute a solution.

---

## ⚛️ Observer Effect
*   **📜 Origin:** This concept is from Heisenberg's Uncertainty Principle.
    *   The act of measuring a system changes the system.
*   **⚠️ Overhead:**
    *   Running programs/codes/scripts will consume CPU and Memory $\rightarrow$ overhead.
    *   Measuring the performance introduces an overhead.
*   **📉 Distortion:**
    *   The introduced overhead will distort the original results that we would have expected if the profiling tools introduced no overhead.

---

## 📏 Metric Types
*   **⏱️ Latency**
    *   Time taken to complete something.
*   **📦 Throughput**
    *   Amount of work done in a duration.
*   **🔋 Utilization**
    *   How busy a resource is (0% to 100%).
*   **🚫 Saturation**
    *   It is the resource state when it is fully utilized (100%) and additional requests must wait in a queue.

---

## ⚖️ Percentiles and Averages
*   **🚨 The Golden Rule of Profiling:** Never rely solely on Averages.
*   **❌ Average's problem:**
    *   **Scenario:** 99 requests take 1ms. 1 request takes 10 seconds.
    *   **The Result:** The Average is ~100ms $\rightarrow$ looks okay.
    *   **The Reality:**
        *   1% of your users are angry.
        *   The average hides the outlier.
*   **📊 Percentiles:**
    *   A ranking system.
    *   Tells you the position of a value compared to the rest of the data.
    *   **50th percentile (Median):**
        *   You scored better than 50% of the people in that group and worse than the other half.
        *   Your request is faster than half of the requests and slower than the other half.
    *   **90th percentile:**
        *   You scored better than 90% of the people in that group.
        *   Your request is faster that 10% of the requests and slower than 90% of the requests.

---

## 📜 Amdahl’s Law
*   **🚧 Definition:** A limit of how much you can optimize a system.
*   **🔗 Core Principle:** The maximum optimization that can be done to the system is limited to the number of sequential parts of the code that can not be parallelized.
*   **🛑 Limit:** You cannot optimize more than the time taken by the sequential latencies.

---

## 🌐 Universal Scalability Law
*   **💸 Coordination Cost:** There is a penalty of coordination that will be paid in case of parallelism.
*   **📉 Reality Check:**
    *   Running 2 CPUs instead of one will not give you a 100% increase in the performance.
    *   It may be lower, and in extreme cases, it will be 0 or even crash the original program.
*   **📊 Efficiency Curve:** The number decreases as you add more resources, and then flattens, and sometime after that it crashes:
    *   1 CPU $\rightarrow$ serves 3 heavy users.
    *   2 CPU $\rightarrow$ serves 5 heavy users.
    *   10 CPU $\rightarrow$ serves 20 heavy users.
    *   100 CPU $\rightarrow$ serves 100 heavy users.
    *   200 CPU $\rightarrow$ serves 100 heavy users.