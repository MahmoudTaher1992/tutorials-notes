# The Optimization Loop

## Establishing baselines
*   answers the question of "What is 'normal' for this system?"
*   without the baseline, you can not say if the optimization works or not
*   **Valid Baseline characteristics**
    *   **Reproducibility**
        *   if you can not reproduce it under the same circumstances, then it is not a baseline
        *   it is normal that you don't get a stable baseline, try with it till you get the baseline
    *   **Environment Parity**
        *   the baseline should be established in an environment close to the production environment
    *   **Specific Metrics**
        *   you should come up with a solid Metrics

----

## The Loop: Benchmark -> Profile -> Optimize -> Verify

#### Benchmarking (Load Generation)
*   This is the act of stressing the system to trigger the performance issue.
*   this step stops when you reach a bottleneck

#### Profiling
*   use you profiling tools during the Benchmarking to get the cause of the bottleneck

#### Optimization
*   make a fix to eliminate the bottleneck
*   each loop should concern one fix, multiple fixes will not give you a clue on which one worked, may be one succeeds and the other fails, but the accumulation is a positive result


#### Optimization
*   run the benchmarking again to see if the bottleneck is removed/improved
*   run the baseline again to see the performance improvement
*   if the results were Significantly Better, commit
*   if the results were same/worse, your fix hypothesis was wrong, start the loop all over again

*   you may want to stop the loop if
    *   the cost of optimization outweighs the benefit.
    *   your Service Level Objectives (SLOs)

#### Summary Visualization

```text
       [ Start ]
           |
           v
   [ Establish Baseline ] <-----------+
           |                          |
           v                          |
   +-> [ Benchmark ]                  |
   |       |                          |
   |       v                          |
   |   [ Profile ]                    |
   |       |                          |
   |       v                          | (No improvement? Revert & Retry)
   |   [ Optimize ]                   |
   |   (Change 1 thing)               |
   |       |                          |
   |       v                          |
   +-- [ Verify ] --------------------+
           |
           v
   [ Success / Commit ]
```


----


# Analysis Frameworks

*   When a system performs poorly, you have thousands of metrics available (CPU, memory, disk I/O, network packets, HTTP status codes, etc.). It is easy to get overwhelmed. 
*   Analysis Frameworks provide a systematic checklist to help you diagnose problems quickly without guessing

## The USE Method
*   **Creator**: Brendan Gregg (Netflix, Intel)
*   **Best For**: Analyzing Resources (Physical Hardware & Operating System components).
*   USE looks at the hardware
*   Answers the question "Is the hardware the bottleneck?"
*   **apply these three checks to every resource CPU, Memory, Disk, Network)**
    *   **U - Utilization**
        *   The percentage of time the resource was busy doing work
    *   **S - Saturation**
        *   The degree to which extra work is queued (waiting) because the resource is busy
    *   **E - Errors**
        *   The count of error events

## The RED Method
*   **Creator**: Tom Wilkie (Grafana Labs) 
*   **Best For**: Analyzing Microservices (Request-driven applications).
*   looks at the software service and how it feels to the user
*   usually visualized in dashboards (Prometheus/Grafana).
*   **look at the following**
    *   **R - Rate**
        *   The number of requests per second (Traffic).
        *   spikes cause problems
    *   **E - Errors**
        *   The number of requests that failed.
    *   **D - Duration**
        *   The amount of time requests take (Latency).
        *   percentiles are important here

## The Four Golden Signals
*   **Creator**: Google (SRE Book)
*   **Best For**: General Distributed Systems Monitoring
*   grandfather of the RED method
*   **look at the following**
    *   **Latency**
        *   The time it takes to service a request
    *   **Traffic**
        *   A measure of how much demand is being placed on your system.
    *   **Errors**
        *   The rate of requests that fail
    *   **Saturation**
        *   How "full" is your service?


----

# Common Bottleneck Patterns

## The N+1 Query Problem
*   most common bottleneck in web applications that use Object-Relational Mappers (ORMs)
*   If you have 100 sub queries, you run 1 initial query + 100 subsequent queries = 101 queries.
*   Fix => Eager Loading (loading all of them at once)

## Busy Waiting (Spin-Waiting)
*   Thread A is waiting another thread to work
*   It doesn't sleep, causes the CPU utilization to go up, while the throughput is zero

## Object Churn (Memory Churn)
*   bottleneck in "managed" languages with Garbage Collection
*    function creates temporary objects, uses them once, and discards them inside a high-frequency loop
*   The GC needs to work a lot to continuously clean those objects
*   The GC burns CPU
*   in the profiler you will see high consumption from the GC
*   **Fix**
    *   Object Pooling (use the same object again and again)
    *   Allocation-free code (mutable structures or stack memory)

## Premature Optimization vs. Necessary Optimization

#### Premature Optimization
*   Spending time optimizing a piece of code before you have profiled the application.
*   optimization without prioritization often result in investing lots of time on less important stuff
*   You usually optimize the wrong thing

#### Necessary Optimization
*   Optimizing code after a profiler has proven it is a bottleneck
*   targeting the bad places to optimize, leaving the less worse till end
*   good approach

