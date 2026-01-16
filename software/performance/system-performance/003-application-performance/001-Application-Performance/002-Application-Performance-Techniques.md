# Application Performance Techniques

- **I/O Strategies**
    - **Selecting an I/O Size**: Finding the "sweet spot" for throughput
    - **Caching**: Storing results to avoid recalculation/re-fetching
    - **Buffering**: Grouping small I/O into larger chunks
    - **Polling**: CPU cost vs. latency trade-offs
- **Concurrency & Parallelism**
    - **Multiprocess**: Forking worker processes (e.g., Nginx, Apache prefork)
    - **Multithreading**: Lightweight threads within a process
    - **Event-Driven**: Event loops and callbacks (e.g., Node.js)
    - **Non-Blocking I/O**: Asynchronous operations (epoll, kqueue, io_uring)
- **Processor Binding**
    - **CPU Affinity**: Pinning processes/threads to specific cores to maximize CPU cache hits (L1/L2)
