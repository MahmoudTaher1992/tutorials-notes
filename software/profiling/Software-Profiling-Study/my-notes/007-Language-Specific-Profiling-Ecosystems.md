# Language-Specific-Profiling-Ecosystems

## 001-Java-JVM
---

## Nodejs-V8

*   **focuses on**
    *   CPU execution (how fast V8 executes JavaScript)
    *   Memory management (Garbage Collection and leaks)
    *   Event Loop latency (async I/O blocking)

#### The V8 Profiler
*   includes a built-in sampling profiler
*   The raw output is often a series of "ticks" and memory addresses
*   You can manipulate with the inspector inside your code using the built-in inspector module

```javascript
const inspector = require('inspector');
const session = new inspector.Session();
session.connect();
session.post('Profiler.enable', () => {
  session.post('Profiler.start', () => {
    // Run code to profile...
  });
});
```

#### Chrome DevTools for Node
*   you can use the Chrome DevTools frontend to profile Node.js backend applications
*   This is the most user-friendly way to analyze performance.
*   `node --inspect app.js`: Starts the app and listens for a debugger.
*   open Chrome and navigate to `chrome://inspect`. Your Node process will appear there as a "Remote Target."
*   **Capabilities:**
    *   **Performance Tab:** Records CPU activity over time.
    *   **Memory Tab:** Allows you to take Heap Snapshots and look for allocation spikes.

#### Heap Snapshots in JavaScript
*   a profiling data that lets you Identify Leaks

#### `0x` (Flamegraph Generation)
*   `0x` is a popular command-line tool in the Node.js ecosystem used to generate **Flamegraphs** about stack traces