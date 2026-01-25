Here is the beautified version of the additional sections, keeping your exact wording.

***

## ⚡ On-CPU profiling

*   ⏱️ analysis the time spent by processes on CPU
*   🔋 which functions consuming the CPU power
*   **⚙️ Mechanism**
    *   🎲 sampling
    *   🛑 the profiler intrrupts the CPU and save the
        *   📝 current instruction
        *   📚 stack trace
*   **📊 Results**
    *   🚧 computation bottlenecks
    *   🐌 Inefficient algorithms
    *   🔁 Infinite loops
*   **🙈 Blind spots**
    *   💤 It doesn't see the process when it is sleeping or waiting for I/O

***

## 💤 Off-CPU Profiling

*   📉 analysis the processes when they are not in the CPU
*   **⚙️ Mechanism**
    *   🗓️ the OS scheduler tracing
    *   🔄 register the processes when their status changes from sleep to running and vise versa
    *   ℹ️ gets info about the reason why it went to that mode
*   **🔍 Results**
    *   💾 Disk I/O
    *   🌐 Network I/O
    *   🔒 Lock Contention
    *   🛌 Explicit Sleep

***

## 🧩 Inlining and Compiler Optimizations

### 📦 Inlining
*   🔗 The process (in compilers) of combining small functions into big functions to save CPU time

### 🚩 Challenge
*   🏗️ Profiles have to reconstruct the compiled function into their original form, to give a richful insights about the app

***

## 🐉 Tail Call Optimization

*   🛠️ An optimization is done for a case that corrupts the profiling results
*   **❓ when**
    *   ⏭️ Main => funcA => funcB => funcC
    *   📉 the profiler stack trace will be main => funcC
*   🧠 just keep it in your mind when profiling, to know why the profiling data looks wrong