## Part I: Foundations & Methodologies

### A. The Systems Performance Context
- **The Performance Environment**
    - Complexity: Systems, cloud, and software stacks
    - Subjectivity: When is a system "slow"?
    - The "Multiple Causes" Problem
- **Roles and Responsibilities**
    - SRE (Site Reliability Engineering) vs. DevOps vs. Core Engineering
    - Crisis Management vs. Proactive Analysis
- **Core Perspectives**
    - **User Perspective**: Response time and latency
    - **Resource Perspective**: Utilization and saturation
- **Cloud Computing Implications**
    - Noisy neighbors
    - Virtualization overhead
    - Scalability vs. Performance

### B. Core Terminology and Concepts
- **Latency**: The most important metric
    - Latency vs. Response Time
    - The "99th Percentile" importance
- **Time Scales**
    - Human-comprehensible comparisons (System clock vs. Disk I/O vs. Network)
    - Understanding the cost of I/O
- **The State of Resources**
    - **Utilization**: Time busy processing work
    - **Saturation**: Work waiting in a queue
    - **Errors**: Failed operations
- **Trade-offs**
    - The "Good, Fast, Cheap" triangle
    - Tuning efforts: ROI on optimization
- **Caching Fundamentals**
    - Hit ratios and cold/warm caches
    - The problem of invalidation
- **The "Unknowns"**
    - Known-Knowns vs. Known-Unknowns vs. Unknown-Unknowns

### C. Types of Observability
- **Counters, Statistics, and Metrics**
    - Cumulative counters vs. instantaneous gauges
- **Profiling**
    - Sampling execution at intervals
    - Building stack traces
- **Tracing**
    - Event-based recording
    - Capturing per-event data
- **Static Performance Tuning**
    - Checking configuration without load

### D. Analytical Methodologies (The Frameworks)
- **The Anti-Methods** (What to avoid)
    - The "Streetlight" Anti-Method (Looking only where it's easy)
    - The "Random Change" Anti-Method (Tuning by guessing)
    - The "Blame-Someone-Else" Anti-Method
- **The Scientific Method**
    - Question -> Hypothesis -> Prediction -> Test -> Analysis
- **The Diagnosis Cycle**
    - Hypothesis generation and data collection loops
- **The USE Method** (For Resources)
    - **U**tilization, **S**aturation, **E**rrors
    - Iterating through every hardware resource
- **The RED Method** (For Services/Microservices)
    - **R**ate (Requests per second)
    - **E**rrors (Failed requests)
    - **D**uration (Latency distributions)
- **Drill-Down Analysis**
    - Starting high-level and narrowing scope (5 whys)
- **Workload Characterization**
    - Who is calling the system? Why? How often?
- **Latency Analysis**
    - Breaking down response time into components (Method R)
- **Linux Performance Analysis in 60 Seconds**
    - The essential checklist for immediate diagnosis

### E. Modeling and Capacity Planning
- **System Models**
    - System Under Test (SUT)
    - Queueing Systems
- **Scalability Laws**
    - **Amdahl’s Law**: The limit of parallelism (serial contention)
    - **Universal Scalability Law (USL)**: Contention + Coherency (crosstalk)
- **Queueing Theory**
    - M/M/1 and M/M/c models
    - Utilization vs. Response Time curve (the "Hockey Stick")
- **Capacity Planning**
    - Resource Limits
    - Factor Analysis
    - Scaling Solutions (Vertical vs. Horizontal)

### F. Statistics for Performance
- **Quantifying Gains**
    - Geometric mean vs. Arithmetic mean
- **The Problem with Averages**
    - How averages hide spikes
- **Distribution Analysis**
    - Standard Deviation and Variance
    - **Percentiles** (p50, p90, p95, p99, p99.9)
    - Median vs. Mean
- **Complex Distributions**
    - Multimodal distributions (e.g., Cache hits vs. Misses)
    - Outliers and their impact

### G. Visualization and Monitoring
- **Pattern Recognition**
    - Time-based patterns (Daily, Weekly peaks)
    - Summary-Since-Boot analysis
- **Chart Types & Usage**
    - Line Charts (and their quantization issues)
    - Scatter Plots (visualizing raw event density)
    - **Heat Maps**: Visualizing multimodal distributions and latency quantization
    - **Flame Graphs**: Visualizing stack traces and CPU profiling
    - Timeline Charts and Surface Plots