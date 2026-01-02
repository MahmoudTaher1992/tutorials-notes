**Role:** I am your **Computer Science & Observability Professor**, specializing in how we monitor and measure large-scale software systems.

Here is the summary of **OpenTelemetry Metric Instruments**:

*   **The Core Concept: Metrics**
    *   **Purpose**
        *   (Tells the story of the **aggregate** system, unlike Traces which follow a single request)
    *   **Selection Rule**
        *   (You cannot just "log a number"; you must select a specific **Instrument**)
        *   (The choice depends on the **mathematical nature** of the data being recorded)

*   **Category 1: Synchronous Instruments**
    *   **Definition**
        *   (Called directly by **your code** / the user)
        *   (Recorded immediately when a specific line of code executes, similar to a log)
    *   **Types**
        *   **Counter (Monotonic)**
            *   **Behavior**
                *   **Values only go UP** (additive)
                *   (You can add `1` or `10`, but never `-1`)
            *   **Analogy**
                *   **Car Odometer** (It tracks total miles driven; it never resets and never goes backward)
            *   **Backend Usage**
                *   (Used to calculate **Rates**, like "Requests Per Second")
            *   **Use Cases**
                *   (Total HTTP requests, Total Error counts)
        *   **UpDownCounter**
            *   **Behavior**
                *   **Values go UP or DOWN**
                *   (Supports negative increments)
            *   **Analogy**
                *   **People in a Classroom** (Someone enters `+1`, someone leaves `-1`)
            *   **Use Cases**
                *   (Active requests currently processing, Items currently in a queue)
            *   **Distinction**
                *   (A standard Counter fails here because it cannot subtract when a task finishes)
        *   **Histogram**
            *   **Behavior**
                *   Records a **Distribution** of values
                *   (Focuses on statistical spread rather than a total sum)
            *   **Analogy**
                *   **Grading Exams** (The teacher looks at how many got As, Bs, or Fs—the spread—rather than just the total sum of all scores)
            *   **Mechanism**
                *   (Groups data into **Buckets**, e.g., 0-100ms, 100-500ms)
                *   (Allows calculation of **Percentiles**, like P99 latency)
            *   **Use Cases**
                *   (Request Latency/Duration, Response body size)

*   **Category 2: Asynchronous Instruments (Observable)**
    *   **Definition**
        *   (NOT called by your application flow)
        *   (The SDK calls a **callback function** you defined)
        *   (The SDK "observes" or scrapes the value periodically, usually every 30-60 seconds)
    *   **Why use Async?**
        *   (Checking the value might be computationally expensive)
        *   (The value might change too frequently to log every single change, like CPU cycles)
    *   **Types**
        *   **Observable Counter**
            *   **Behavior**
                *   **Monotonic** (Only goes up)
                *   (Read from a third-party source, like the OS, rather than added to by code)
            *   **Use Case**
                *   **Hardware Counters** (e.g., Network Interface Card reporting "Bytes Sent"—the OS tracks it, you just report it)
        *   **Observable Gauge**
            *   **Behavior**
                *   Captures the **Current State** at a specific moment
                *   (Can go up or down, but isn't mathematically "added" to)
            *   **Analogy**
                *   **Room Thermometer** (You don't add degrees to it; you just check it and say "It is 72 degrees right now")
            *   **Use Cases**
                *   (CPU Usage percentage, Memory/Heap usage)
            *   **Rule of Thumb**
                *   (If **you** change the value manually, use **UpDownCounter**)
                *   (If you just **read** the value periodically, use **Observable Gauge**)
        *   **Observable UpDownCounter**
            *   **Behavior**
                *   (Similar to a Gauge, but the backend treats it as a sum to analyze rates/deltas)
            *   **Use Case**
                *   (Rare usage, typically for OS-level resources like File Handle Counts)
