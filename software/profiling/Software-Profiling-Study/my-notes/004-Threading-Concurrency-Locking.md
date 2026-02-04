#   Threading Concurrency Locking

## Locks
*   A lock is a mechanism that ensures only one thread can access a specific resource at a time
*   If I have a lock then no other thread can access/change the resource i have a lock on
*   it is the solution to race conditions

## Why lock analysis
*   some performance bottlenecks can be caused by multiple threads trying to access shared resources simultaneously.
*   symtoms
    *   High CPU usage, low throughput
    *   Low CPU usage, high latency


## The Four Main Types of Locking Problems

**1. Inefficient Waiting (Contention)**
This is the most common problem. It's about *how* a thread waits for a lock.

*   **Symptom A: Low CPU & Slow App.** Threads are "asleep" waiting for their turn. They aren't working, so the CPU is idle, but the user is waiting.
*   **Symptom B: High CPU & Slow App.** Threads are "impatiently" checking the lock over and over, burning 100% of the CPU without doing any real work.


**2. Getting Stuck (Gridlock)**
This is a critical bug where the application stops making progress.

*   **Symptom A: Application Freezes (Deadlock).** CPU drops to zero. Two or more threads are waiting for each other in a circular dependency. Nothing moves forward, ever.
*   **Symptom B: High CPU & Zero Progress (Livelock).** Threads are active but are stuck reacting to each other, like two people in a hallway constantly sidestepping into each other's way.


**3. Unfairness (Scheduling Issues)**
*   a problem in scheduling causes lock issues

**4. Invisible Hardware Conflicts (False Sharing)**


---

## Async and Event loop profiling

*   **non blocking I/O**
    *   Profiling Profiling Non-Sequential Code is not as straight as profiling Traditional/Sequential code
    *   we use another measures because the metrics of an non blocking I/O function being called are miss leading
        *   you will have to use another metrics other that time, such as IOPS—Input/Output Operations Per Second
*   **Event Loop Lag**
    *   this is a metric that will be used to analyze the event loop
    *   if a function takes too much to execute, the lag is high
    *   use this metric to start your inspection
*   **Tracking async path**
    *   once the async function is fired, the path will be broken and you will lose the tracing of the metrics
    *   some tools can guess and stich the paths, it takes some resources to achieve it
*   **Goroutine/Green-thread Scheduling Analysis**
    *   I have no idea what it means, it may be important

