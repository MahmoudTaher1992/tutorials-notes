Based on the roadmap provided, here is a detailed explanation of **Part VI (Operating Systems), Section B: Process Management**.

Process Management is the heart of an Operating System (OS). It is how the OS manages all the programs running on a computer, deciding which program gets to use the CPU, for how long, and how they communicate without crashing into each other.

---

### 1. Processes & Threads, Process States

#### **What is a Process?**
A **Process** is a program in execution. When you write code (e.g., a `.py` or `.exe` file), it is just a static file on the disk. When you double-click or run it, the OS loads it into memory, turning it into a process.
*   **Components:** A process contains the program code, current activity (Program Counter), CPU registers, a stack (temporary data), and a heap (dynamically allocated memory).
*   **Isolation:** Processes are independent. If one process crashes, it generally doesn't affect others because they have separate memory spaces.

#### **What is a Thread?**
A **Thread** is the smallest unit of execution *within* a process.
*   **Relation to Process:** A single process can have multiple threads (multithreading).
*   **Shared vs. Private:** Threads within the same process share the same memory space (code, data, heap) but have their own registers and stack.
*   **Benefit:** Threads are lightweight. Creating a thread is faster than creating a whole new process.

#### **Process States**
As a process executes, it changes "states." The OS tracks these states to manage the CPU efficiently:
1.  **New:** The process is being created.
2.  **Ready:** The process is in memory and waiting to be assigned to the CPU (waiting in the "ready queue").
3.  **Running:** Instructions are being executed by the CPU.
4.  **Waiting (Blocked):** The process is waiting for some event to occur (e.g., waiting for a user to press a key or for a file to finish reading from the disk).
5.  **Terminated:** The process has finished execution.

---

### 2. Scheduling Algorithms
The **Scheduler** is the part of the OS that decides which process in the "Ready" queue gets to use the CPU next. Since a CPU can generally only do one thing at a time (per core), the OS must switch between processes quickly to create the illusion of multitasking.

*   **FCFS (First-Come, First-Served):**
    *   Like a grocery store line. The first process to arrive gets the CPU until it finishes or waits for I/O.
    *   *Pros:* Simple.
    *   *Cons:* **Convoy Effect**—if a big process waits at the front, small fast processes get stuck waiting behind it.

*   **SJF (Shortest Job First):**
    *   The process with the shortest estimated run-time goes next.
    *   *Pros:* Minimizes average waiting time.
    *   *Cons:* Impossible to know exactly how long a job will take; leads to **Starvation** (long jobs may never get to run).

*   **RR (Round Robin):**
    *   Each process gets a small unit of time called a **Time Quantum** (e.g., 20 milliseconds). If it doesn't finish, it moves to the back of the queue.
    *   *Pros:* Fair; no starvation; good for interactive systems (like desktops).
    *   *Cons:* Constant switching adds overhead.

*   **Priority Scheduling:**
    *   Each process is assigned a priority integer. Highest priority runs first.
    *   *Risk:* Starvation for low-priority processes.
    *   *Solution:* **Aging** (Wait long enough, and your priority gradually increases).

---

### 3. Context Switching
**Context Switching** is the mechanism of storing the state of the currently running process and restoring the state of the next process.

*   **How it works:** When the Scheduler decides to switch from Process A to Process B:
    1.  The OS saves Process A's context (Program Counter, registers, etc.) into a data structure called the **PCB (Process Control Block)**.
    2.  The OS loads Process B's context from its PCB into the CPU.
    3.  Process B starts running exactly where it left off.
*   **Cost:** Context switching is pure "overhead." The CPU is doing administrative work, not executing user code. If you switch too often, the system becomes slow (thrashing).

---

### 4. Concurrency & Synchronization
When multiple processes or threads access shared data at the same time, problems arise.
*   **Race Condition:** When the outcome of execution depends on the specific timing or order in which threads run. If two threads try to increment a variable `count` at the same exact moment, the count might only go up by 1 instead of 2.

To prevent this, we use **Synchronization** tools to ensure only one thread accesses the "Critical Section" (shared data) at a time:

*   **Mutex (Mutual Exclusion):**
    *   Think of it like a key to a toilet. Only one person (thread) can have the key. If you don't have the key, you wait outside until the person inside comes out and returns the key.
*   **Semaphore:**
    *   A signaling mechanism using an integer value.
    *   *Binary Semaphore:* Same as a Mutex (0 or 1).
    *   *Counting Semaphore:* Allows $N$ threads to access a resource simultaneously (e.g., a club with a capacity of 50 people).
*   **Monitor:**
    *   A high-level synchronization construct (used in Java/C#, e.g., `synchronized`). The compiler handles the locking/unlocking automatically so the programmer makes fewer mistakes.

---

### 5. Deadlock
In a multiprogramming environment, a **Deadlock** happens when processes are stuck in a circle of waiting.

*   **Example:** Process A has Resource 1 and waits for Resource 2. Process B has Resource 2 and waits for Resource 1. Neither can proceed.

**Four Necessary Conditions for Deadlock (The Coffman Conditions):**
1.  **Mutual Exclusion:** Only one process can use a resource at a time.
2.  **Hold and Wait:** A process holding a resource is waiting for another one.
3.  **No Preemption:** Resources cannot be forcibly taken away from a process.
4.  **Circular Wait:** A queue exists where P1 waits for P2, P2 waits for P3... and Pn waits for P1.

**Handling Deadlocks:**
1.  **Prevention:** Design the system so at least one of the 4 conditions is impossible (e.g., disallow "Hold and Wait" by making processes request all resources at once).
2.  **Avoidance:** The OS checks every resource request. If granting the request might lead to a deadlock (an "unsafe state"), the request is denied or delayed. (Famous algorithm: **Banker's Algorithm**).
3.  **Detection and Recovery:** Let deadlocks happen. Periodically check for them. If found, terminate one of the processes or forcibly take away its resources to break the cycle.
