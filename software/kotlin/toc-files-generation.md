Here is the bash script to generate the directory structure and files for your Kotlin study guide.

### Instructions:
1.  Copy the code block below.
2.  Save it as a file named `setup_kotlin_study.sh` (e.g., use `nano setup_kotlin_study.sh`).
3.  Make it executable: `chmod +x setup_kotlin_study.sh`.
4.  Run it: `./setup_kotlin_study.sh`.

```bash
#!/bin/bash

# Root directory name
ROOT_DIR="Kotlin-Study"

# Create root directory and enter it
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR" || exit

echo "Creating Kotlin study structure in ./$ROOT_DIR..."

# -----------------------------------------------------------------------------
# Part I: Kotlin Fundamentals & Core Philosophy
# -----------------------------------------------------------------------------
DIR="001-Kotlin-Fundamentals-Core-Philosophy"
mkdir -p "$DIR"

# Section A
cat <<'EOF' > "$DIR/001-Introduction-to-Kotlin.md"
# Introduction to Kotlin

- Motivation and Philosophy (Pragmatic, Concise, Safe, Interoperable)
- Key Advantages over Java (Null Safety, Conciseness, Coroutines)
- The Kotlin Ecosystem (JVM, Android, Native, JS, Multiplatform)
- Kotlin vs. Other JVM Languages (Java, Scala, Groovy)
- The Place of Kotlin in Modern Software Development
EOF

# Section B
cat <<'EOF' > "$DIR/002-Setting-Up-Project.md"
# Setting Up a Kotlin Project

- JDK and Environment Setup (JVM, PATH)
- IDEs: IntelliJ IDEA (Community/Ultimate), Android Studio, VS Code with Extensions
- Build Tools: Gradle (Kotlin DSL) vs. Maven
- Project Structure and File Organization
  - Standard Directory Layout (`src/main/kotlin`)
  - Package Naming Conventions
- Creating Your First "Hello, World" Application
- Using the Kotlin REPL for Experimentation
EOF

# -----------------------------------------------------------------------------
# Part II: Language Fundamentals & Syntax
# -----------------------------------------------------------------------------
DIR="002-Language-Fundamentals-Syntax"
mkdir -p "$DIR"

# Section A
cat <<'EOF' > "$DIR/001-Variables-Types-Control-Flow.md"
# Variables, Types, and Control Flow

- `val` (immutable) vs. `var` (mutable): The Immutability Principle
- Basic Data Types (Int, Long, Double, Float, Boolean, Char)
- Strings and String Templates
- Type Inference: When and Why to Declare Types Explicitly
- Collections: Lists, Sets, Maps (Read-only vs. Mutable versions)
- Ranges and Progressions
- Control Flow as Expressions
  - `if`/`else` expressions
  - `when` expressions (the "switch" on steroids)
- Loops: `for`, `while`, `do-while`, and Iterating over Collections
- `break` and `continue` (with Labels for nested loops)
EOF

# Section B
cat <<'EOF' > "$DIR/002-Functions-Lambdas.md"
# Functions & Lambdas

- Defining Functions (Syntax, Parameters, Return Types, `Unit`)
- Named and Default Arguments
- Single-Expression Functions
- Top-Level vs. Member Functions
- `vararg` for variable number of arguments
- Infix Notation for Functions
- Lambdas and Higher-Order Functions
  - Lambda Syntax (`{ }`, `it` convention)
  - Passing Functions as Arguments
  - Returning Functions from Functions
EOF

# -----------------------------------------------------------------------------
# Part III: The Kotlin Type System & Null Safety
# -----------------------------------------------------------------------------
DIR="003-Type-System-Null-Safety"
mkdir -p "$DIR"

# Section A
cat <<'EOF' > "$DIR/001-Core-Null-Safety.md"
# The Core of Null Safety

- The Problem of `NullPointerException`
- Nullable (`?`) vs. Non-nullable Types
- The Billion-Dollar Mistake and How Kotlin Solves It
EOF

# Section B
cat <<'EOF' > "$DIR/002-Working-with-Nullable-Types.md"
# Working with Nullable Types

- Safe Call Operator (`?.`)
- The Elvis Operator (`?:`)
- Not-Null Assertion Operator (`!!`): Dangers and Use-Cases
- Safe Casts (`as?`)
- `let` Scope Function for Handling Nullables
- Working with Platform Types (Java Interoperability)
EOF

# -----------------------------------------------------------------------------
# Part IV: Object-Oriented Programming in Kotlin
# -----------------------------------------------------------------------------
DIR="004-OOP-in-Kotlin"
mkdir -p "$DIR"

# Section A
cat <<'EOF' > "$DIR/001-Classes-Objects.md"
# Classes & Objects

- Defining Classes and Creating Instances
- Properties (`val`, `var`) with Custom Getters/Setters and Backing Fields
- Constructors (Primary, Secondary, `init` block)
- Inheritance (`open` keyword, `super`)
- Abstract Classes and Interfaces (with default implementations)
- Visibility Modifiers (`private`, `protected`, `internal`, `public`)
EOF

# Section B
cat <<'EOF' > "$DIR/002-Advanced-OOP-Concepts.md"
# Advanced OOP Concepts

- **Data Classes**: Auto-generated `equals()`, `hashCode()`, `toString()`, `copy()`
- **Sealed Classes and Interfaces**: For Restricted Class Hierarchies (State Machines)
- **Enum Classes**: Type-safe Enumerations
- **Objects**: Singletons and Companion Objects
- Nested vs. Inner Classes
- Type Aliases
- Generics (Declaration-site and Use-site variance: `in`, `out`)
EOF

# -----------------------------------------------------------------------------
# Part V: Functional Programming & Idiomatic Kotlin
# -----------------------------------------------------------------------------
DIR="005-Functional-Programming-Idiomatic"
mkdir -p "$DIR"

# Section A
cat <<'EOF' > "$DIR/001-Advanced-Collection-Processing.md"
# Advanced Collection Processing

- The Standard Library's Power Tools (`map`, `filter`, `flatMap`, `reduce`, `fold`)
- Eager vs. Lazy Evaluation: Collections vs. Sequences
- Grouping, Partitioning, and Zipping
- Aggregate Operations
- Ordering and Sorting (natural, custom)
EOF

# Section B
cat <<'EOF' > "$DIR/002-Standard-Library-Scope-Functions.md"
# Standard Library Scope Functions

- `let`: Executing a block on a non-null object
- `run`: Scope and compute a result
- `with`: Operating on an object without calling its name
- `apply`: Configuration and initialization
- `also`: Additional actions (logging, side effects)
- Choosing the Right Scope Function
EOF

# Section C
cat <<'EOF' > "$DIR/003-Idiomatic-Language-Features.md"
# Idiomatic Language Features

- **Extension Functions & Properties**: Adding functionality without inheritance
- **Delegated Properties** (`by lazy`, `by Delegates.observable`, custom delegates)
- **Operator Overloading**
- **Destructuring Declarations**
EOF

# -----------------------------------------------------------------------------
# Part VI: Concurrency & Asynchronous Programming
# -----------------------------------------------------------------------------
DIR="006-Concurrency-Async-Programming"
mkdir -p "$DIR"

# Section A
cat <<'EOF' > "$DIR/001-Introduction-to-Coroutines.md"
# Introduction to Coroutines

- The Problem with Threads and Callbacks
- Structured Concurrency: The Core Principle
- Coroutines vs. Threads
EOF

# Section B
cat <<'EOF' > "$DIR/002-Core-Coroutine-Concepts.md"
# Core Coroutine Concepts

- Suspending Functions (`suspend` keyword)
- Coroutine Builders: `launch`, `async`, `runBlocking`
- Coroutine Scopes (`CoroutineScope`, `viewModelScope`, `lifecycleScope`)
- Jobs, Deferreds, and Cancellation
- Dispatchers (`Main`, `IO`, `Default`)
EOF

# Section C
cat <<'EOF' > "$DIR/003-Async-Data-Streams-Flow.md"
# Asynchronous Data Streams with Flow

- Cold vs. Hot Streams: The `Flow` API
- Building and Collecting Flows
- Flow Operators (like RxJava/Collections: `map`, `filter`, `onEach`)
- StateFlow and SharedFlow for UI State Management
EOF

# Section D
cat <<'EOF' > "$DIR/004-Advanced-Concurrency.md"
# Advanced Concurrency

- Channels for Coroutine Communication
- Mutexes and Semaphores for Synchronization
- Exception Handling in Coroutines
EOF

# -----------------------------------------------------------------------------
# Part VII: Java Interoperability
# -----------------------------------------------------------------------------
DIR="007-Java-Interoperability"
mkdir -p "$DIR"

# Section A
cat <<'EOF' > "$DIR/001-Using-Java-from-Kotlin.md"
# Using Java from Kotlin

- Calling Java Code Seamlessly
- Getters, Setters, and Property Syntax
- Handling Nullability with Platform Types and Annotations (`@Nullable`, `@NonNull`)
EOF

# Section B
cat <<'EOF' > "$DIR/002-Using-Kotlin-from-Java.md"
# Using Kotlin from Java

- Understanding Compiled Kotlin Code (the JVM bytecode)
- Calling Kotlin Functions and Properties
- Annotations for Java Compatibility (`@JvmStatic`, `@JvmOverloads`, `@JvmName`)
- Interop with Top-Level Functions and Extension Functions
EOF

# -----------------------------------------------------------------------------
# Part VIII: Testing Strategies
# -----------------------------------------------------------------------------
DIR="008-Testing-Strategies"
mkdir -p "$DIR"

# Section A
cat <<'EOF' > "$DIR/001-Types-of-Testing.md"
# Types of Testing

- Unit Testing Business Logic and Utility Functions
- Integration Testing
- End-to-End Testing (in the context of an application)
EOF

# Section B
cat <<'EOF' > "$DIR/002-Testing-Tools-Libraries.md"
# Testing Tools & Libraries

- Test Runners: JUnit 5, Kotest
- Assertion Libraries: AssertJ, Strikt, Atrium
- Mocking and Verification: MockK, Mockito-Kotlin
- Testing Coroutines (`runTest`, `TestCoroutineDispatcher`)
EOF

# -----------------------------------------------------------------------------
# Part IX: Kotlin Platforms & Multiplatform (KMP)
# -----------------------------------------------------------------------------
DIR="009-Platforms-Multiplatform"
mkdir -p "$DIR"

# Section A
cat <<'EOF' > "$DIR/001-Kotlin-Different-Platforms.md"
# Kotlin on Different Platforms

- **Kotlin/JVM**: Server-side, Desktop, and Android
- **Kotlin/JS**: For Web Frontends (with React, Vue, etc.)
- **Kotlin/Native**: Compiling to Native Binaries (iOS, macOS, Linux)
  - C & Objective-C/Swift Interoperability
- **Kotlin/WASM** (Experimental)
EOF

# Section B
cat <<'EOF' > "$DIR/002-Kotlin-Multiplatform.md"
# Kotlin Multiplatform (KMP)

- The "Write Once, Run Anywhere" Paradigm
- Project Structure: `commonMain`, `jvmMain`, `iosMain`, etc.
- `expect` and `actual` Declarations for Platform-Specific APIs
- Sharing Logic Across Mobile (iOS/Android), Web, and Backend
- KMP Libraries (Ktor, SQLDelight, etc.)
EOF

# -----------------------------------------------------------------------------
# Part X: Ecosystem & Major Frameworks
# -----------------------------------------------------------------------------
DIR="010-Ecosystem-Frameworks"
mkdir -p "$DIR"

# Section A
cat <<'EOF' > "$DIR/001-Server-Side-Development.md"
# Server-Side Development

- **Ktor**: A lightweight, asynchronous framework from JetBrains
- **Spring Boot** with Kotlin Support
- **Quarkus**, **Micronaut**: Modern, cloud-native frameworks
EOF

# Section B
cat <<'EOF' > "$DIR/002-Android-Development.md"
# Android Development

- Android Jetpack and Kotlin-First APIs
- Jetpack Compose: Declarative UI
- Android Architecture Components (`ViewModel`, `LiveData`, `Room`)
EOF

# Section C
cat <<'EOF' > "$DIR/003-Data-Science-Analysis.md"
# Data Science & Analysis

- Kotlin Notebooks (Jupyter, Datalore)
- Libraries: Kotlin DataFrame, Kandy (for plotting)
EOF

# -----------------------------------------------------------------------------
# Part XI: Build Tools, Tooling & Developer Experience
# -----------------------------------------------------------------------------
DIR="011-Build-Tools-Dev-Experience"
mkdir -p "$DIR"

# Section A
cat <<'EOF' > "$DIR/001-Build-Systems-Deep-Dive.md"
# Build Systems Deep Dive

- Gradle Kotlin DSL (`build.gradle.kts`)
- Managing Dependencies and Repositories
- Multi-Module Project Configuration
- Writing Custom Gradle Tasks
EOF

# Section B
cat <<'EOF' > "$DIR/002-Documentation-Code-Quality.md"
# Documentation & Code Quality

- Documentation with **Dokka** and KDoc
- Linting and Static Analysis: `ktlint`, Detekt
- Formatting Code Automatically
EOF

# Section C
cat <<'EOF' > "$DIR/003-Debugging-Profiling.md"
# Debugging & Profiling

- IntelliJ IDEA Debugger (Breakpoints, Watches, Evaluate Expression)
- Profiling Tools for Performance Analysis (VisualVM, IntelliJ Profiler)
- Decompiling Kotlin to Java and viewing Bytecode
EOF

# Section D
cat <<'EOF' > "$DIR/004-CICD-Deployment.md"
# CI/CD & Deployment

- Building and Publishing Libraries to Maven Central
- Containerizing Kotlin Applications with Docker
- CI/CD Pipelines with GitHub Actions, TeamCity, Jenkins
EOF

echo "Done! Hierarchy created in $(pwd)"
```
