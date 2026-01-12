Based on **Prompt 3**, here is your summary in the requested format.

**Role:** I am your **Computer Science Teacher**, specializing in Software Architecture and Performance Engineering.

---

### **Common Bottleneck Patterns**

*   **1. The N+1 Query Problem** (The most frequent database mistake in modern web apps)
    *   **The Concept**
        *   **Scenario**
            *   You want to load a list of "Parents" and one specific detail about their "Children".
            *   [Analogy: Imagine a waiter going to the kitchen to get a customer's order, coming back to the table, then going back to the kitchen to get the fork, coming back, then going back for the knife. It creates unnecessary trips.]
        *   **The Error**
            *   Step 1: Code runs **1** query to fetch the list.
            *   Step 2: Code loops through the list and runs a **new query** for every single item to get details.
            *   **Math**: 1 initial query + 100 items = **101 total queries**.
    *   **Diagnosis** (How to spot it)
        *   **"Waterfall" Effect**
            *   [In a visual profiler, this looks like a cascading staircase of hundreds of tiny, fast database calls that add up to a long delay.]
    *   **The Fix**
        *   **Eager Loading**
            *   [Tell the database: "Give me the Parents AND their Children in one specific command," usually using SQL `JOIN` or `WHERE IN`.]

*   **2. Busy Waiting** (Also known as Spin-Waiting)
    *   **The Concept**
        *   **Scenario**
            *   Thread A needs to wait for Thread B to finish a job.
            *   [Analogy: A child in the backseat constantly asking "Are we there yet? Are we there yet?" without taking a breath. It exhausts the driver (CPU) without making the car go faster.]
        *   **The Error**
            *   Using an aggressive `while` loop that constantly checks status without pausing.
    *   **Diagnosis** (How to spot it)
        *   **100% CPU Usage**
            *   [The processor core is maxed out, but the program isn't actually processing data—it is just "spinning".]
        *   **Flame Graph Signature**
            *   A **flat, wide bar** for a simple check function.
    *   **The Fix**
        *   **Synchronization Primitives**
            *   Use **Events, Signals, or Semaphores**. [Think of this like an alarm clock: The thread goes to sleep completely until the alarm wakes it up.]
        *   **Yielding**
            *   Force the thread to `sleep` for a few milliseconds inside the loop.

*   **3. Object Churn** (Memory Management inefficiency)
    *   **The Concept**
        *   **Scenario**
            *   Creating temporary objects, using them once, and throwing them away inside a fast loop.
            *   [Analogy: Using a brand new disposable plate for every single bite of food at dinner. The dining table looks clean, but the janitor (Garbage Collector) is sweating trying to empty the trash bin constantly.]
        *   **The Error**
            *   Allocating new buffers or substrings for every network packet or string operation.
    *   **Diagnosis** (How to spot it)
        *   **Garbage Collector (GC) Spikes**
            *   The profiler won't blame your code directly.
            *   It will show high CPU time in system functions like **`gc_collect`** or **`Young Generation GC`**.
            *   **"Stop the World"**
                *   [The application freezes momentarily so the GC can clean up the memory mess.]
    *   **The Fix**
        *   **Object Pooling**
            *   [Reuse the same heavy objects (like database connections) instead of buying new ones.]
        *   **Allocation-free code**
            *   Use stack memory or mutable structures.

*   **4. Optimization Strategy** (Where to focus your energy)
    *   **Premature Optimization** (The Enemy)
        *   **Definition**
            *   Optimizing code *before* you have measured where the problem actually is.
        *   **The Risk**
            *   **Wasted Effort**
                *   [You might spend days making a function 500% faster, but if that function only runs for 1 millisecond, nobody will notice.]
    *   **Necessary Optimization** (The Goal)
        *   **Definition**
            *   Optimizing code only *after* a profiler proves it is a bottleneck.
        *   **The Strategy**
            *   Focus on the **Critical Path**.
            *   [If Function X takes 80% of the time, fixing it by just 10% makes the whole app significantly faster.]

### **Summary Checklist** (Questions to ask when profiling)
1.  **N+1:** Am I talking to the database too many times?
2.  **Busy Wait:** Is the CPU burning hot but doing nothing?
3.  **Object Churn:** Is the Garbage Collector working harder than my app?
4.  **Strategy:** Am I fixing the part that actually matters?
