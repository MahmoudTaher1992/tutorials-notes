**Role:** I am your **Computer Science Teacher**, specializing in **Web Performance Engineering**. Today we are looking at how to make sure a website doesn't just load fast, but *feels* fast while you are using it.

### 🌳 Runtime Performance Summary

*   **Runtime Performance**
    *   **Definition**
        *   Performance **after** the initial load.
        *   (Focuses on interaction: Does scrolling stutter? Do buttons react instantly?)
    *   **The "MRI Machine": Chrome DevTools Performance Tab**
        *   **The Timeline**
            *   Records browser activity millisecond-by-millisecond.
            *   (You press Record -> Interact with page -> Press Stop to analyze).
        *   **The Flame Chart**
            *   **Structure**
                *   **X-Axis:** Time.
                    *   (A wide bar means the function took a long time).
                *   **Y-Axis:** Call Stack Depth.
                    *   (Shows the chain of command: Function A called B, which called C).
            *   **Color Coding** (Traffic lights for code)
                *   **🟨 Yellow:** **Scripting** (Running JavaScript/React).
                *   **🟪 Purple:** **Rendering** (Calculating layout/positions).
                *   **🟩 Green:** **Painting** (Filling in pixels).
        *   **Screenshots**
            *   Captures frames during the recording.
            *   (Helps you see exactly what the screen looked like when the code spiked).

    *   **The Core Bottleneck: Main Thread Blocking**
        *   **Single-Threaded Nature**
            *   JavaScript has only **one thread** (The Main Thread).
            *   **Responsibilities**
                *   Running Code.
                *   Calculating Styles.
                *   Handling Inputs (Clicks/Typing).
            *   **Analogy:** **A Single-Lane Highway**
                *   (Since there is only one lane, only one car can move at a time. It cannot multitask).
        *   **Blocking**
            *   Occurs when a task takes too long.
            *   (If a massive truck—complex JS—stops in the lane for 2 seconds, the cars behind it—your mouse clicks—cannot pass).
            *   **Result:** The page appears **Frozen** or **Unresponsive**.

    *   **Detection System: Long Tasks API**
        *   **Purpose**
            *   Monitoring performance for real users, not just on your local developer machine.
        *   **Definition of "Long Task"**
            *   Any script execution taking **> 50 milliseconds**.
            *   **The "Why"**
                *   Target is **60 FPS** (Frames Per Second).
                *   Browser needs a new frame every ~16ms.
                *   (If a task takes 50ms, the browser skips frames, creating visual "Jank" or choppiness).
        *   **Implementation**
            *   Uses the **Observer Pattern**.
            *   (Code runs in the background and logs warnings to your analytics if a freeze occurs).

    *   **The Solution: Execution Limits (Time Budgeting)**
        *   **The Budget**
            *   Limit synchronous operations to **50ms**.
        *   **Strategy: Yielding**
            *   Giving control back to the browser so it can update the screen.
            *   **Technique: Chunking**
                *   Breaking massive tasks into smaller pieces.
                *   (Instead of processing 10,000 items at once, process 1,000, pause to let the browser breathe, then do the next 1,000).
        *   **Tools for Yielding**
            *   `setTimeout(func, 0)`: Pushes task to end of queue.
            *   `requestIdleCallback()`: Runs only when browser is free.
            *   **Web Workers**:
                *   The "Multi-thread" workaround.
                *   (Moves heavy logic off the Main Thread entirely, like hiring a separate assistant to do the heavy lifting so the receptionist can keep talking to customers).
