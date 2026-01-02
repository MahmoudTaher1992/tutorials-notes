**Role:** I am your Computer Science Teacher, specializing in Modern Web Architecture and Observability.

Here is the summary of the Client-Side RUM Evolution material, structured as a deep tree for your study notes.

***

### 🌳 Topic: OpenTelemetry Client-Side RUM (Real User Monitoring)

*   **1. The Main Concept: Full-Stack Observability**
    *   **The Goal**
        *   Move away from using many different closed tools (like having separate tools for Google Analytics, New Relic, etc.).
        *   Adopting a **Unified Open Standard** (OpenTelemetry) for everything.
    *   **End-to-End Visibility** (The most important value)
        *   **The Problem:**
            *   Frontend and Backend used to be blind to each other.
            *   (If a button clicked on a phone fails, the backend developer doesn't know which user clicked it).
        *   **The Solution:**
            *   **TraceId Injection**
                *   The browser generates a `TraceId`.
                *   This ID is stuck onto the HTTP headers of the request.
                *   The backend reads this ID.
            *   **Result:** A single connected line from the browser click $\to$ the server $\to$ the database.
            *   (Think of this like a restaurant order ticket: The specific ticket number follows the order from the waiter's pad, to the kitchen line, to the chef, ensuring everyone knows exactly which customer ordered the burger).

*   **2. Measuring User Experience (Web Vitals)**
    *   **Integration Approach**
        *   Treats Google's Core Web Vitals as **Metric Instruments**.
        *   Uses **Auto-instrumentation** (code that automatically wraps browser tools like `PerformanceObserver` so you don't have to write math logic yourself).
    *   **Key Metrics (The 2025 Standard)**
        *   **LCP** (Largest Contentful Paint)
            *   (How fast does the main stuff load?)
        *   **CLS** (Cumulative Layout Shift)
            *   (Does the page jump around while I'm reading it?)
        *   **INP** (Interaction to Next Paint)
            *   (When I click a button, how fast does the browser paint the next frame? This replaced the old metric FID).
    *   **The Power of Attributes**
        *   Allows slicing data by context.
        *   (e.g., "Show me the loading speed specifically for premium users on iPhones").

*   **3. Session Replay & Logs**
    *   **The Strategy: Contextual Linking**
        *   OTel does **not** send the actual video/replay (It is too heavy).
        *   **The Bridge Mechanism:**
            *   1. Generate a unique `session.id`.
            *   2. Inject this ID into every span and log.
            *   3. Create a link in the backend that opens your separate Session Replay tool using that ID.
    *   **Future Innovation**
        *   **Log-based Replay**
            *   Turning DOM events (clicks, scrolls) into structured OTel **Logs**.
            *   (Instead of recording a video, you record a script of what happened and "replay" the script later).

*   **4. Technical Challenges & Solutions**
    *   **A. The Clock Skew Problem**
        *   **Issue:** User devices (phones/laptops) often have the wrong time compared to servers.
        *   **Solution:** **Clock Skew Correction**
            *   The backend compares the "sent" time vs. "received" time.
            *   It calculates the difference and retroactively fixes the timestamps.
    *   **B. Network Constraints**
        *   **Issue:** Sending data from mobile uses battery and bandwidth.
        *   **Solutions:**
            *   **Protobuf over HTTP** (Switching from heavy text JSON to lightweight binary data).
            *   **Beacon API** (Ensures data is sent even if the user closes the tab immediately).
            *   **Aggressive Sampling** (Only recording 1% of users unless an error happens).
    *   **C. Single Page Applications (SPAs)**
        *   **Issue:** Pages don't reload in frameworks like React or Vue, so "Page Load" events don't happen often.
        *   **Solution:** **Soft Navigations**
            *   Detects changes in the History API (URL changes).
            *   Creates a "Navigation Span" that groups all subsequent API calls under it.

*   **5. The "One Agent" Philosophy**
    *   **The Emerging Frontier**
        *   Stop installing 3 different agents (Marketing agent, Error agent, Performance agent).
        *   Install **one OpenTelemetry Web SDK**.
        *   Capture data once, and let the Collector route it to the correct destination.
