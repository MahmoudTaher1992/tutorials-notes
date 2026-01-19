# 📋 Definitions

## 📊 Monitoring
*   **Question:** *Is it healthy?*
*   **Basis:** Depends on metrics.
*   **Data:** Metrics are data collected from the system in a time-series format.
*   **Output:**
    *   **Graphs**
        *   *Benefits:* Quick to read; shows peaks and troughs.
        *   *Limitation:* Tells you there is a problem (and when it happened), but not the cause (what it is).
    *   **Alerting**
        *   *Process:* Logic evaluates the graph $\rightarrow$ triggers alarms $\rightarrow$ triggers action.
        *   *Examples:* Sending notifications or starting auto-scaling.

---

## 🔍 Traditional Profiling 
*(Non-OpenTelemetry Profiling)*
*   **Question:** *Why is it slow?*
*   **Function:** Provides detailed behavior of compiled code and resource usage.
*   **Data Examples:**
    *   **Stack traces:** Shows the sequence of function execution (especially during errors).
    *   **Memory allocation:** Tracks how memory is used.
    *   **CPU analysis:** Analyzes instruction execution.
*   **Goal:** Identify where resources are consumed and where bottlenecks exist.
*   **Analogy:** It is like an **MRI scan**.

---

## 🛠️ Debugging
*   **Question:** *What is the problem?*
*   **Focus:** Focuses on the logic and the flow of the code.
*   **Data:** Variable states, breakpoints, and step-by-step execution.
*   **Goal:** Determine the cause of the problem to propose and execute a solution.
