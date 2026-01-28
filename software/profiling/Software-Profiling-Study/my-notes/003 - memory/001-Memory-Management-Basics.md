# 🧠 Memory Management Notes

## 🥞 Stack vs. 🧱 Heap Memory

### 🥞 Stack
*   📍 A zone in the memory.
*   📝 **Ordered, temporary scratchpad** for execution.
*   ⬇️ Follows a **LIFO** (Last In, First Out) structure.
*   📋 A scratchpad for **one function**, it holds:
    *   The function parameters.
    *   Variables inside the function.
    *   Return addresses.
*   📦 A block of memory (**stack frame**) is reserved when the function gets executed; the block is **freed** when the function returns.
*   ⚡ **Stack frame is very fast.**
*   🛑 **Limited:** If you recurse too deep, you get a `StackOverflowError`.
*   👣 Stack shows the **call path** (who called whom).

### 🧱 Heap
*   📍 A zone in the memory.
*   🌊 **Large, unstructured pool** of memory.
*   🗄️ A zone that holds:
    *   Objects.
    *   Global variables.
    *   Large data structures.
*   🌎 **Not specific** to one function or process.
*   🔧 Memory must be **requested** (`malloc`, `new`) and **freed** (Garbage Collection).
*   🐢 **Heap is slow.**
*   🧀 It is harder to find a suitable place in memory as it fills up (fragmentation), like **Swiss cheese**.
*   💧 **Memory leaks** can happen here if you forget to clean up the Heap (the program consumes all RAM and crashes).

---

## 🗺️ Virtual Memory, VSZ, RSS

### 👻 Virtual Memory
*   🗺️ OS gives the programs/processes a **map** of virtual memory.
*   🧩 It has nothing to do with the original memory chip.
*   🔍 The OS uses the map to find/allocate the memory.
*   💾 This map can sometimes point to the HDD (**swap memory**).

### 🎈 VSZ (Virtual Memory Size)
*   📊 The **total amount** of memory the process has reserved or mapped.
*   🗣️ What the process **asked for** but has not yet touched.
*   📈 A process can have a **massive VSZ** (for future heap growth) but use very little RAM.
*   ✅ High VSZ is usually **not a problem**.

### 🏋️ RSS (Resident Set Size)
*   💾 The amount of **physical RAM** currently being used by the process.
*   ➕ Includes: **Stack + Heap**.
*   💰 This is the **"real" cost**.
*   💀 If RSS hits the limit of your container or physical server, the process will be **killed**.
*   🐡 High RSS is the primary metric for **memory bloating/swelling**.

---

## 🚫 Page Faults (Minor vs. Major)

### 🩹 Minor Page Faults
*   🤝 Happens when your process asks for something from memory that is **shared** among other processes (shared libraries like `libc`).
*   🧐 The OS realizes that your process memory doesn't point to the shared memory yet.
*   ⚡ It returns this fault and fixes it **very quickly** by adding the pointer.
*   🚀 High rates of minor faults usually indicate your program is **allocating memory very aggressively**.

### 🐌 Major Page Faults
*   💾 Happens when your process asks for data from memory, but it has **not yet been loaded from the hard drive**.
*   💿 This fault triggers **loading from the hard disk**.
*   🐢 This is a **very slow and expensive** operation (hard disk is very slow compared to RAM).
*   🚧 Major Page Faults indicate a **hard disk reading bottleneck**.

---

## 🔄 Swap Usage and 📉 Thrashing

### 🧊 Swap Usage
*   📥 When the **RSS gets filled up**, the OS moves **cold memory pages** to the hard drive.
*   🛡️ It prevents the app from crashing.
*   ⏳ Accessing the cold pages data in the future takes a long time (**latency increases**).

### 😫 Thrashing
*   🔥 It is a problem raised because of using hard drives as memory.
*   📉 Happens to processes that have their memory pages in the **swap**.
*   🔄 It also happens to memory pages that *will* be moved to the swap.
*   💾 The disk gets **overwhelmed** by writing/reading for the memory requests.
*   🛑 The **CPU sits idle** waiting for the disk.
*   💡 The solution is to **decrease the processes** or **increase the memory**.