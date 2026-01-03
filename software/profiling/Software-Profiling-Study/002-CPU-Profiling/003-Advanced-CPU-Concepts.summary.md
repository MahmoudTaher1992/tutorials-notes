Here are the summaries based on your specific prompts.

---

### Response to Prompt 2 (Concise Summary)

**Advanced CPU Concepts: Execution, Latency, and Compiler Artifacts**

*   **On-CPU Profiling (The Worker):** Focuses strictly on active execution cycles. It identifies computational bottlenecks (what is burning energy) via sampling but remains **blind to wait times**.
*   **Off-CPU Profiling (The Waiter):** The necessary counterpart to standard profiling. It traces the OS Scheduler to measure latency caused by Disk I/O, Network, or Lock Contention—crucial for diagnosing **slow applications with low CPU usage**.
*   **Compiler Distortions (The Illusion):** Optimizations make code faster but scramble profiling data:
    *   **Inlining:** Merges small functions into their callers to save overhead, causing specific function names to **disappear from the profile**.
    *   **Tail Call Optimization (TCO):** Reuses stack frames for the final function call, erasing the "parent" function from the history and breaking the **stack trace hierarchy**.

---

### Response to Prompt 3 (Super Teacher Study Notes)

**Role:** I am your Computer Science Teacher specializing in System Performance and Low-Level Debugging.

**Summary of Advanced CPU Concepts**

*   **1. The Two States of a Process** (A computer program is essentially doing one of two things: working or waiting)
    *   **A. On-CPU Profiling** (Focus: Active Execution)
        *   **The Core Question:** "Where is the time spent executing?" (Which functions are actually using the brainpower of the processor?)
        *   **The Mechanism:** **Sampling** (The profiler interrupts the CPU—like a teacher checking on you 99 times a second—to see what line of code is running).
        *   **What it Finds:**
            *   **Computational Bottlenecks** (Heavy math, image processing).
            *   **Inefficient Algorithms** (Doing things the hard way).
            *   **Infinite Loops** (Getting stuck running in circles).
        *   **The Limitation:** It has a **Blind Spot** for waiting. (If your program is waiting for a website to load, On-CPU profiling sees nothing, because the CPU isn't doing work).
    *   **B. Off-CPU Profiling** (Focus: The "Dark Matter" of performance)
        *   **The Core Question:** "Where is the process waiting or sleeping?" (Why is the app slow even though the computer fan isn't spinning?)
        *   **The Mechanism:** Tracing the **OS Scheduler**. (We watch the Operating System move the program from "Running" to "Sleep" and record how long it stays there).
        *   **What it Finds:**
            *   **Disk I/O** (Waiting for a file to save).
            *   **Network I/O** (Waiting for a database or server to reply).
            *   **Lock Contention** (Waiting for another thread to finish using a shared resource).
        *   *Analogy:* Think of this like waiting in line at the cafeteria. You aren't "working" (eating), but the time is still ticking away. On-CPU measures how fast you eat; Off-CPU measures how long you stood in line.

*   **2. Compiler Optimizations** (How the computer changes your code to make it faster, and how that confuses us)
    *   **A. Inlining** (The Copy-Paste Optimization)
        *   **The Concept:** The compiler takes a small function and pastes its body directly into the place where it was called. (It deletes the function call to save time).
        *   *Analogy:* Instead of writing "See page 54 for the definition" in your notes, you just write the definition right there. You no longer need to flip pages (faster), but you lose the reference to "Page 54".
        *   **The Profiling Challenge:** The function name **disappears**. (You look for a function called `add()` in your report, but you can't find it because the compiler erased it).
        *   **The Fix:** Modern profilers use "Debug Info" (Maps) to pretend the function is still there.
    *   **B. Tail Call Optimization (TCO)** (The Stack Reuse Optimization)
        *   **The Concept:** If the *very last thing* a function does is call another function, it doesn't need to hang around waiting for the answer. It cleans up its desk and leaves immediately.
        *   **The Optimization:** It reuses the current memory space (stack frame) instead of creating a new one.
        *   *Analogy:* You are a middleman delivering a message. Instead of taking the message, waiting for a reply, and then handing it back, you just tell the sender "Go talk to that guy directly" and you leave the room.
        *   **The Profiling Challenge:** The **middle of the stack is missing**. (You see the beginning and the end, but the function that connected them is gone from the history).
        *   **Why it matters:**
            *   **Good:** Prevents crashing (Stack Overflow) in recursive programs.
            *   **Bad:** Breaks the "Parent-Child" relationship in your data.
