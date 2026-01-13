
**Role: OS + Performance Engineering Teacher**

# Difference Between a **Process** and a **Thread**
## 1) Core definition
*   **Process** [a running program instance with its own private memory “world”]
    *   Has its own **address space** [the virtual memory range the program can use]
    *   Has its own **resources** [handles like files, sockets, permissions, environment]
*   **Thread** [a unit of execution inside a process]
    *   A process can have **one or many threads**
    *   Threads in the same process share the process’s memory and resources

## 2) What is shared vs not shared?
*   **Between different processes**
    *   Not shared by default
        *   **Memory/heap** [data the program allocates at runtime]
        *   **Global variables** [process-private copies]
    *   Sharing requires **IPC** [Inter-Process Communication: special ways to exchange data]
        *   Examples: **pipes**, **sockets**, **shared memory**
*   **Between threads in the same process**
    *   Shared
        *   **Heap memory** [same objects/data structures]
        *   **Globals/static data**
        *   **Open files/sockets** [same underlying handles]
    *   Not shared (each thread has its own)
        *   **Stack** [function call frames + local variables]
        *   **Registers** [CPU state while executing]
        *   **Thread-local storage** [per-thread variables]

## 3) Communication and safety
*   **Processes**
    *   Communicate via **IPC** [more setup, but clearer boundaries]
    *   Safer isolation [one process crashing usually doesn’t corrupt another process’s memory]
*   **Threads**
    *   Communicate by reading/writing shared memory [easy and fast]
    *   Risk: **race condition** [two threads change data at the same time in a bad order]
        *   Needs **synchronization** [locks/mutexes, semaphores, atomics]

## 4) Performance and overhead (practical view)
*   **Context switching**
    *   **Thread switch** [switch between threads, often cheaper]
    *   **Process switch** [switch between processes, often more expensive]
        *   Reason: switching **address spaces** can be heavier and can hurt CPU caches/TLB
*   **Creating**
    *   Creating a **process** is usually heavier than creating a **thread**
*   **Scheduling**
    *   The OS scheduler usually schedules **threads** onto CPU cores
        *   Even a “single-threaded process” still runs as (at least) one thread

## 5) Common use cases
*   Use **multiple processes** when you want
    *   **Strong isolation** [security/stability boundaries]
    *   **Separate services/components** [crash containment]
*   Use **multiple threads** when you want
    *   **Parallel work** inside one program [use multiple CPU cores]
    *   **Overlap waiting** [one thread waits for I/O while another continues]
    *   Shared in-memory data structures [fast sharing, but needs careful safety]

## 6) Quick memory picture (mental model)
*   **Process** = “one house” [its own rooms and keys; neighbors can’t access without a formal door like IPC]
*   **Thread** = “people in the same house” [share rooms/resources; each person has their own backpack = stack]

## 7) One key takeaway
*   **Processes** prioritize **isolation**.
*   **Threads** prioritize **sharing and lightweight concurrency**, but require **synchronization**.

If you tell me your language/runtime (e.g., **Python**, **Java**, **C++**, **Node.js**) and OS (**Linux/Windows**), I can explain what “process vs thread” looks like specifically there (because some runtimes hide or limit true parallel threads).