Based on the detailed roadmap you provided, here is a breakdown of **Part VIII, Section A: Threads**.

This section is the cornerstone of Java concurrency. It explains how Java handles doing multiple things at once.

---

# 🧵 008-Concurrency-and-Multithreading / 001-Threads

### 1. The Concept: Process vs. Thread
Before writing code, you must understand the distinction:
*   **Process:** An execution of a program (e.g., opening Microsoft Word). It has its own heavy memory space.
*   **Thread:** A lightweight unit of execution *inside* a process. Threads share the same memory (heap) but have their own execution stack.
    *   *Benefit:* Efficient performance.
    *   *Risk:* Data corruption if two threads try to modify the same shared data simultaneously.

---

### 2. Creating and Managing Threads
There are three primary ways to define a task for a thread to execute.

#### A. Extending the `Thread` Class
This is the oldest method but is generally **discouraged** because Java only allows single inheritance (if you extend `Thread`, you can't extend anything else).

```java
class MyThread extends Thread {
    public void run() {
        System.out.println("Running in explicitly extended thread");
    }
}
// Usage:
MyThread t = new MyThread();
t.start(); // Always call start(), NOT run()
```

#### B. Implementing `Runnable` (Preferred for simple tasks)
This separates the *task* from the *runner*.

```java
Runnable task = () -> System.out.println("Running inside a Runnable");
Thread t = new Thread(task);
t.start();
```

#### C. Implementing `Callable` (Java 5+)
`Runnable` cannot return a value or throw a checked exception. `Callable` solves this. It is usually used with **Executors**.

```java
Callable<String> task = () -> {
    return "Task Complete!";
};
// Typically used with an ExecutorService (see section 4)
```

---

### 3. Thread Lifecycle & States
A thread is a state machine. It is not always "running."

1.  **New:** The thread object is created (`new Thread()`), but `start()` hasn't been called.
2.  **Runnable:** `start()` is called. It is ready to run, but the Operating System (OS) scheduler might be switching between it and other threads.
3.  **Running:** The OS has assigned CPU time to the thread.
4.  **Blocked/Waiting:** The thread stops and waits for:
    *   Access to a locked resource (`BLOCKED`).
    *   Another thread to signal it (`WAITING`).
    *   A generic timer, like `Thread.sleep(1000)` (`TIMED_WAITING`).
5.  **Terminated:** The `run()` method has finished execution.

---

### 4. Thread Pools and Executors (`ExecutorService`)
Creating a new OS Thread takes significant resources. If you create 10,000 threads for 10,000 requests, your server will crash.

**Solution:** **Thread Pools**.
A pool reuses a fixed number of threads for many tasks.

```java
// Creates a pool with exactly 10 threads
ExecutorService executor = Executors.newFixedThreadPool(10);

for (int i = 0; i < 100; i++) {
    executor.submit(() -> System.out.println("Task executing"));
}

// Always shut down the executor or the app keeps running
executor.shutdown(); 
```

**Key benefits:**
*   Reuses threads (saves memory/CPU).
*   Controls the number of concurrent tasks.

---

### 5. Synchronization, Locks, and `volatile`
When threads share data (like a bank account balance), chaos occurs. Two threads might read a balance of 100, add 10, and both save 110 (instead of 120).

#### A. `synchronized`
Ensures only **one** thread can access a block of code at a time.
```java
public synchronized void increment() {
    count++; 
}
```

#### B. `volatile`
This deals with **visibility**, not atomicity. It tells the JVM: *"Do not cache this variable in the CPU; always read/write directly to main RAM."*
Use this for flags (e.g., `volatile boolean running = true`).

#### C. Locks (ReentrantLock)
A more flexible version of `synchronized` found in `java.util.concurrent.locks`.
```java
Lock lock = new ReentrantLock();
try {
    lock.lock();
    // critical code
} finally {
    lock.unlock(); // Always unlock in finally!
}
```

---

### 6. Deadlocks, Livelocks, and Starvation
These are the nightmares of multithreading:

*   **Deadlock:** Thread A has Key 1 and wants Key 2. Thread B has Key 2 and wants Key 1. Both wait forever.
*   **Livelock:** Two threads constantly yielding to each other (like two people trying to pass in a hallway and stepping left/right simultaneously), consuming CPU but making no progress.
*   **Starvation:** Low-priority threads never get CPU time because high-priority threads hog the resources.

---

### 7. Atomic Variables
For simple operations (like incrementing a counter), `synchronized` is too "heavy" (slow). Java provides "Atomics" which use hardware-level instructions (Compare-And-Swap) for speed/safety.

*   `AtomicInteger`, `AtomicBoolean`, `AtomicReference`.

```java
AtomicInteger count = new AtomicInteger(0);
count.incrementAndGet(); // Thread-safe increment without using 'synchronized'
```

---

### 8. Virtual Threads (Project Loom - Java 21+)
This is the most significant change to Java concurrency in 20 years.

*   **Platform Threads (Old):** 1 Java Thread = 1 OS Thread. Heavy. Max ~4,000 per machine.
*   **Virtual Threads (New):** thousands of Java Virtual Threads = 1 OS Thread. Very lightweight. You can have **millions** of them.

**Why use them?**
They are perfect for I/O-heavy applications (Database calls, API calls) where threads spend most of their time waiting.

```java
// Java 21 example
try (var executor = Executors.newVirtualThreadPerTaskExecutor()) {
    IntStream.range(0, 10_000).forEach(i -> {
        executor.submit(() -> {
            Thread.sleep(Duration.ofSeconds(1));
            return i;
        });
    });
}
```

### Summary for Study
If you are learning this for an interview or project:
1.  Prefer **Executors** over `new Thread()`.
2.  Use **Atomic** variables for counters.
3.  Understand **Race Conditions** and how `synchronized` fixes them.
4.  Know that **Virtual Threads** exist for modern high-scale applications.
