Based on the roadmap provided, you are asking for a detailed explanation of section **Part II: Programming Fundamentals -> B. Languages**.

This section focuses on the **nature of programming languages**—not just syntax (where semicolons go), but the fundamental theories on how they handle data, how they run, how they manage computer memory, and how code is organized.

Here is a detailed breakdown of each concept within that section:

---

### 1. Static vs. Dynamic Typing
This refers to **when** the computer checks the data types (integers, strings, booleans) of your variables.

*   **Static Typing:**
    *   **How it works:** Variable types are known and checked at **Compile Time** (before the program runs). You typically must declare the type (e.g., `int x = 5;`).
    *   **Pros:** Catches type errors early (you can't compile if you try to subtract a name from a number). It is generally faster because the computer optimizes the code better.
    *   **Examples:** C, C++, Java, Rust, Go, TypeScript.
*   **Dynamic Typing:**
    *   **How it works:** Types are checked at **Runtime** (while the program is running). You don't usually declare types (e.g., `x = 5`, then later `x = "hello"` is allowed).
    *   **Pros:** faster to write code; more flexible.
    *   **Cons:** You might encounter crashes while the program is running because of a type mismatch (e.g., `TypeError`).
    *   **Examples:** Python, JavaScript, Ruby, PHP.

### 2. Compilation vs. Interpretation
This refers to **how** the human-readable code is converted into machine code (0s and 1s) that the CPU understands.

*   **Compiled Languages:**
    *   The source code is translated **all at once** into a standalone executable file (binary) by a Compiler.
    *   **Behavior:** You build it once, then run the resulting file.
    *   **Speed:** Very fast execution.
    *   **Examples:** C, C++, Rust, Go.
*   **Interpreted Languages:**
    *   An Interpreter program reads the source code **line-by-line** and executes it on the fly. There is no pre-compilation step.
    *   **Behavior:** You define the code and run it immediately.
    *   **Speed:** Generally slower execution than compiled code because the computer is translating while running.
    *   **Examples:** Python, JavaScript, Ruby.
*   **Hybrid (JIT / Bytecode):**
    *   Languages like **Java** and **C#** differ. They compile code into an intermediate format ("Bytecode"), which is then interpreted or compiled just-in-time (JIT) by a Virtual Machine (like the JVM).

### 3. Memory Management
Computer memory (RAM) is finite. When you create a variable, it takes up space. This concept explains how that space is reclaimed when the variable is no longer needed.

*   **Manual Management:**
    *   **How it works:** The programmer must explicitly ask for memory (`malloc`) and explicitly release it (`free`).
    *   **Pros:** Total control and maximum performance.
    *   **Cons:** Dangerous. If you forget to free memory, you get a **Memory Leak**. If you free it too early, you crash the program.
    *   **Example:** C, C++ (mostly).
*   **Garbage Collection (GC):**
    *   **How it works:** An automated process (the Garbage Collector) runs in the background, looks for variables that are no longer being used, and deletes them.
    *   **Pros:** Very safe; easiest for the programmer.
    *   **Cons:** The GC consumes CPU power and can cause "pauses" in the program while it cleans up.
    *   **Examples:** Java, Python, Go, C#, JavaScript.
*   **RAII (Resource Acquisition Is Initialization) / Ownership:**
    *   **How it works:** A modern approach where memory is tied to the "scope" of a variable. As soon as a variable goes "out of scope" (e.g., the function ends), the compiler automatically inserts the cleanup code.
    *   **Pros:** Memory safety of a GC with the speed of Manual management.
    *   **Examples:** Rust (Outlook/Borrow checker), Modern C++.

### 4. Popular Languages
This part of the roadmap introduces the tools of the trade. You are expected to understand the "personality" and primary use case of major languages:

*   **C:** The foundation of modern computing. Used for Operating Systems and Embedded hardware. Minimalist and manual.
*   **C++:** Built on C but adds Object-Oriented features. Used for High-Performance applications (Video Games, Trading Engines).
*   **Java:** Heavy usage in Enterprise backends and Android apps. Known for portability ("Write Once, Run Anywhere").
*   **Python:** The most popular language for Data Science, AI, and beginners. Very readable execution is slower.
*   **JavaScript:** The language of the Web. The only language that runs natively inside a web browser.
*   **Rust:** The modern successor to C++. Guarantees memory safety without a Garbage Collector.
*   **Go (Golang):** Google's language. Built for cloud servers and severe simplicity.

### 5. Source Code Structure & Organization
This deals with how code is physically structured in files to keep it maintainable.

*   **The Entry Point:** Every program needs a starting line. In C/C++/Java/Go/Rust, this is usually a function named `main()`. In Python/JS, it is just the top of the file.
*   **Modularization:** Instead of writing 10,000 lines in one file, we break code into separate files (Modules or Packages).
*   **Imports/Includes:** How file A gains access to the functions inside file B (e.g., `#include <stdio.h>` in C, `import math` in Python).
*   **Scope:** Where a variable "lives."
    *   *Global Scope:* Visible to the whole file/program.
    *   *Local Scope:* Visible only inside the specific function where it was created.
