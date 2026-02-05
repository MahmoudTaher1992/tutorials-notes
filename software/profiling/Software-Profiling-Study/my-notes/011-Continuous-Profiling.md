# Continuous Profiling

----

## concepts

#### Why Profile in Production?

*   solve the problem of **Works on my machine**, but not in production
*   **Intermittent Issues**
    *   some errors doesn't occur unless it works for long time or under high load that can not be simulated locally
*   **Cost Reduction**
    *   to know where the resources are consumed, and where the money is spent

#### Low-Overhead Agents

*   high overhead is a problem in reality
*   **solutions**
    *   **sampling**
        *   taking samples instead of all the data
    *   **Target Overhead**
        *   some profilers are made so that it doesn't increase the consumption more that a percentage (target overhead)
    *   **eBPF**
        *   use effiecient technologies

#### Merging Profiles Over Time
*   you can not navigate through accumilated enormous data
*   solutions
    *   **Aggregation**
        *   aggregate data and consume the Aggregation
    *   **Querying** (query to look at what you need only)
    *   **Diffing**
        *   compare the results at some time with others in another time
        *   differences give you good insights

----


## Tools and Architecture

#### The Tools
*   **Pyroscope**
    *   client-server model
    *   add the sdk to the app
    *   data will be sent somewhere
*   **Parca**
    *   Focuses heavily on eBPF and Kubernetes
    *   runs on the machine level, outside the app
*   **Google Cloud Profiler / AWS CodeGuru**
    *   tools that are managed by the IAAS
    *   easily integrated

#### Architecture & Data Storage
*   **The Architecture**
    *   Agent => gathers data and sends it
    *   Transporter/collectors => aggregates and collect data from multiple agents
    *   Storage Engine => stores the data
    *   Query UI => queries the data
*   **Storage Formats**
    *   depends on the tools, but it should be compressed
*   **Retention strategy**
    *   keep high resolution for data that is near (< 2 weeks)
    *   keep aggregate for data that is far (> 2 weeks)

