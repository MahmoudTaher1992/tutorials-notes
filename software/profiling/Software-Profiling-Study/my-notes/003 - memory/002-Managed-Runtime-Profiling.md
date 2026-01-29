# ⚙️ Managed Runtime Profiling

*   In some environments, a system called the **Garbage Collector (GC)** runs in the background to reclaim memory that is no longer being used.
*   **Examples:**
    *   ☕ Java
    *   🐍 Python
    *   🐹 Go
    *   🌐 JavaScript/Node
    *   🎼 C#

---

## 🧹 Garbage Collection Patterns

*   It is effective in profiling to know the **Garbage Collection Patterns**.

### 🛑 Stop-the-World
*   The GC **pauses the entire application** to do its work.
*   You will see the application pause for a while and then return.
*   ⏱️ It may cause **latency spikes** in the app.

### 🏃 Concurrent GC
*   GC **doesn't stop** the app; instead, it runs in the background.
*   ⚡ You will see the **CPU usage increase** due to the GC background load.

### ♻️ Generational GC
*   A pattern that classifies objects in memory and deals with them accordingly.
*   **👶 Young Generation**
    *   Objects are **born** in it.
    *   Most of them will **die** in it quickly.
    *   🚀 GC works here **fast and frequent**.
*   **👴 Old Generation**
    *   Objects are **promoted** here from Young Generation if they should live longer.
    *   🐢 GC works here **slow and expensive**.
*   ⚠️ If too many objects move from Young Generation to Old Generation, GC couldn't clean the memory, and your app will **slow down with time**.

---

## 📊 Allocation Profiling

*   A report that shows the **allocation rates** and relates them to the functions.
*   📈 **High allocation rates** mean that something is storing objects massively.
*   🔁 Example: Allocating objects inside a **loop**.

---

## 🌳 Retention Paths and Dominator Trees

*   When you have a **memory leak**, you have to find why objects don't get deleted from the memory.

### 🔗 Retention Paths
*   GC will **not delete** the object if something is **holding** it.
*   To know what is holding the object, you have to trace the object path to the **GC root**.
*   📍 You pick an object (e.g., `UserSession`) and ask the profiler: **"Show me the Shortest Path to GC Roots."**

### 👑 Dominator Trees
*   If object A holds object B, then **deleting A will free B** and GC can delete it.
*   Object A is the **dominator** on object B.
*   🕵️ Analyzing the Dominators gives you leads on how to **reduce the memory usage**.

---

## 📸 Analyzing Heap Dumps (Shallow vs. Retained Size)

*   **Heap Dump** is a file containing a **snapshot** of the entire memory of the application at a specific moment.

### 🐚 Shallow Heap
*   The size of the **object itself**.
*   🚫 Not the objects inside it (i.e., array references only).

### 🕸️ Retained Heap
*   The size of the object **plus** the size of all the objects it keeps alive.
*   📦 **i.e.** An `ArrayList` itself is small, but the Retained Heap is **large** if children are included.

---

## 💧 Identifying Memory Leaks vs. 🐡 Memory Bloat

### 💧 Memory Leak
*   📈 You will see it in the graph when memory usage **grows continually** over time and **never drops**.
*   📉 Even when GC works it drops, but it **doesn't drop** to the point of the last trough.
*   🦷 The **"Sawtooth" pattern** (memory goes up, GC runs, memory drops) keeps trending upward. The "floor" of the sawtooth gets higher every time.
*   💥 Eventually leading to an **OutOfMemory** crash.
*   **i.e.** Adding listeners to a button but **never removing** them.

### 🐡 Memory Bloat
*   Memory usage is **stable**, but **unnecessarily high**.
*   💰 It doesn't crash, but it **costs a lot of money**.
*   🛠️ **Cause:** Inefficient data structures.
*   ➖ **Shape:** A **flat line**, but sitting at 90% usage constantly.