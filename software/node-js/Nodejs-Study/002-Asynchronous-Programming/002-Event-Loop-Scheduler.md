This section explains the **Event Loop Scheduler**, which is the logic Node.js uses to decide "what code runs next."

While the Event Loop phases (Timers, Poll, Check) explain the general flow, the **Scheduler** deals with priority. Not all asynchronous tasks are created equal; some are "VIPs" that cut the line, while others wait for their specific turn.

Here is a detailed breakdown of **Part II - B: The Event Loop Scheduler**.

---

### 1. Macrotasks vs. Microtasks
To understand scheduling, you must visualize two distinct types of queues.

#### **Macrotasks (The Standard Queue)**
These correspond to the main phases of the Event Loop. When people talk about the "Event Loop," they are usually talking about processing Macrotasks.
*   **Examples:** `setTimeout`, `setInterval`, `setImmediate`, I/O operations (file reading, network requests).
*   **Execution:** The loop executes one phase (e.g., Timers), then moves to the next (e.g., I/O).

#### **Microtasks (The VIP Queue)**
Microtasks are high-priority tasks that **do not wait for the current phase to finish**. They are executed immediately after the currently executing operation completes, *before* the Event Loop moves on to the next task or phase.
*   **Examples:** `Promise.resolve().then()`, `queueMicrotask`, and (technically) `process.nextTick`.
*   **Execution:** If you schedule a microtask, it runs ASAP. If a microtask schedules *another* microtask, that runs too. The Event Loop pauses until the Microtask queue is empty.

---

### 2. `process.nextTick()` ( The "Super" VIP)
Although often grouped with Microtasks, `process.nextTick()` is unique to Node.js and has the **highest priority** of all asynchronous code.

*   **How it works:** It maintains its own queue. When the current operation (call stack) finishes, Node.js checks the `nextTick` queue *before* it even checks the Promise microtask queue and *before* it continues the Event Loop.
*   **Use Case:** It is used when you need a callback to execute "right now," but effectively asynchronously (to allow the current function to complete its execution context).
*   **The Danger:** If you recursively call `process.nextTick()`, you can create an infinite loop that starves I/O operations, preventing Node.js from ever reaching the Timer or Check phases.

---

### 3. `setTimeout()` & `setInterval()` (Timers Phase)
These are standard **Macrotasks** that belong to the **Timers Phase**.

*   **`setTimeout(fn, delay)`:** Schedules code to run after a *minimum* threshold of milliseconds.
*   **The "Minimum" Catch:** If you set a delay of `100ms`, it does not guarantee execution in exactly 100ms. It guarantees that the code will not run *before* 100ms. If the Event Loop is blocked by a heavy calculation (blocking the stack), the timer will wait until the stack is clear.

---

### 4. `setImmediate()` (Check Phase)
This is a standard **Macrotask** that belongs to the **Check Phase**.

*   **Purpose:** It is designed to execute a script once the current **Poll Phase** (I/O phase) completes.
*   **Comparison to `setTimeout(fn, 0)`:**
    *   If you run both in the main module (global scope), the order is non-deterministic (random) because it depends on system performance.
    *   **However**, if you run both inside an **I/O callback** (like reading a file), `setImmediate` is **guaranteed** to run first, because the I/O phase is immediately followed by the Check phase (where `setImmediate` lives).

---

### Summary of Priority (The "Pecking Order")

If all these tasks were scheduled at the exact same moment, here is the order Node.js would execute them:

1.  **Synchronous Code** (The Call Stack) - Runs line by line.
2.  **`process.nextTick()`** - Runs immediately after the stack empties.
3.  **Microtasks** (`Promise.then`) - Runs after `nextTick` is empty.
4.  **Event Loop Phases** (Macrotasks):
    *   **Timers** (`setTimeout`)
    *   **Check** (`setImmediate`)

---

### 5. Practical Example

Let's look at code that combines all these concepts to prove the scheduling order.

```javascript
const fs = require('fs');

console.log('1. Start (Synchronous)');

// Macrotask: Timer Phase
setTimeout(() => {
  console.log('7. setTimeout 0ms');
}, 0);

// Macrotask: Check Phase
setImmediate(() => {
  console.log('8. setImmediate');
});

// Microtask: Promise
Promise.resolve().then(() => {
  console.log('5. Promise.then');
});

// Priority Queue: nextTick
process.nextTick(() => {
  console.log('3. process.nextTick');
  
  // Nested nextTick
  process.nextTick(() => {
    console.log('4. Nested process.nextTick');
  });
});

console.log('2. End (Synchronous)');
```

#### **The Output will be:**
1. `1. Start (Synchronous)`
2. `2. End (Synchronous)`
3. `3. process.nextTick`
4. `4. Nested process.nextTick` (Runs before Promises!)
5. `5. Promise.then`
6. `7. setTimeout 0ms` (See note below*)
7. `8. setImmediate`

*(Note: The order of 7 and 8 can swap depending on CPU performance if run in the global scope, but 3, 4, and 5 will always happen before 7 and 8).*

### Key Takeaways for your Interview/Study:
1.  **Microtasks** (Promises) drain completely before the loop moves to the next phase.
2.  **`process.nextTick`** is technically not part of the Event Loop phases; it's a queue that runs whenever the boundary between C++ and JavaScript is crossed (as soon as the stack is empty).
3.  **`setImmediate`** is misnamed. It runs in the next cycle (Check phase). **`process.nextTick`** is the one that actually runs "immediately."
