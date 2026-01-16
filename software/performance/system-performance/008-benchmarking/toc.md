## Part VIII: Benchmarking (Chapter 12)

### A. Benchmarking Philosophy
- **Why Benchmark?**: Capacity planning, regression testing, tuning verification
- **The Risks**: "Benchmarking is easy; benchmarking *correctly* is hard."
- **Benchmarking Crimes** (Common mistakes):
    - Testing the cache (working set fits in RAM when testing Disk)
    - Using default tool configurations
    - Ignoring errors during the test
    - Comparing apples to oranges

### B. Methodology
- **Active Benchmarking**: Generating artificial load
- **Passive Benchmarking**: Analyzing production load (metrics)
- **Micro-Benchmarking**: Testing a small component (e.g., `getpid()` speed, L1 cache speed)
- **Macro-Benchmarking**: Testing the whole system (e.g., Web server + DB)
- **Ramping Load**: Testing scaling behavior (finding the "Knee" of the curve)

### C. Statistical Analysis of Results
- **Run Duration**: Long enough to bypass warm-up/jitter?
- **Variance**: Are results reproducible? (Coefficient of Variation)
- **The "Sanity Check"**: Does the result match the physics of the hardware?

### D. Tools
- **Micro-benchmarks**: `lmbench`, `fio` (disk), `iperf` (net)
- **Application Simulators**: `sysbench`, `pgbench` (Postgres), `wrk` (HTTP)