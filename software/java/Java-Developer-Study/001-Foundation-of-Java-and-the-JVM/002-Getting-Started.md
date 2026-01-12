Based on the Table of Contents you provided, the section **"Getting Started"** (under Part I) is the crucial bridge between theory (Part A: Overview) and writing actual code (Part II).

Here is a detailed explanation of what this section covers and what you need to master in it.

---

# 002-Getting-Started (Detailed Explanation)

This section focuses on setting up your computer to speak "Java" and understanding the workflow of creating a running application from a text file.

## 1. Setting up Java Environment (JDK Install)
Before you can write code, you need the tools. In the Java world, terminology is important:

*   **JRE vs. JDK:**
    *   **JRE (Java Runtime Environment):** If you only want to *run* Java apps (like Minecraft), you need this. It contains the JVM.
    *   **JDK (Java Development Kit):** If you want to **write** code, you need this. It includes the JRE plus tools like the compiler (`javac`) and debuggers. **As a developer, you always install the JDK.**
*   **HTML/Vendor Confusion:**
    *   Java is open source. While Oracle maintains the core, many companies provide their own builds of the JDK.
    *   **Oracle JDK:** The commercial version.
    *   **OpenJDK:** The source code base.
    *   **Distributions:** Most developers use **Eclipse Adoptium (Temurin)**, **Amazon Corretto**, or **Azul Zulu**. These are free, reliable versions of OpenJDK.
*   **Environment Variables (`JAVA_HOME` & `PATH`):**
    *   Installing the software isn't enough. You must tell your Operating System (Windows/Mac/Linux) where Java is located.
    *   **JAVA_HOME:** A variable that points to the main installation folder. build tools (like Maven) look for this.
    *   **PATH:** You add the `/bin` folder of your JDK to your system `PATH` so you can type `java` in any command terminal without typing the full file location.

## 2. Using Command-Line Tools (`javac`, `java`)
Modern code editors (IDEs) hide the complexity of compiling, but to truly understand Java, you must do it manually at least once. This teaches you how source code becomes a running program.

*   **The Workflow:**
    1.  **Write:** Create a text file named `Hello.java`.
    2.  **Compile (`javac`):** The computer cannot run English-like code. You run the Java Compiler:
        ```bash
        javac Hello.java
        ```
        If successful, this creates a **`Hello.class`** file. This file contains **Bytecode**—instructions for the JVM, not the CPU.
    3.  **Run (`java`):** You start the Java Virtual Machine and tell it to load your class:
        ```bash
        java Hello
        ```
        *(Note: You do not type `.class` here).*

## 3. Introduction to IDEs (Integrated Development Environments)
Writing code in Notepad is painful. an IDE is a specialized text editor that understands Java syntax, highlights errors, and helps you write code faster.

*   **IntelliJ IDEA (JetBrains):** Currently the **industry standard** for Java. It is incredibly smart, handles code suggestions effectively, and integrates with almost every tool. Use the **Community Edition** (free) to start.
*   **Eclipse:** The older, classic choice. It is open-source and very powerful but can feel clunkier than IntelliJ. It is still widely used in legacy enterprise environments.
*   **VS Code (Microsoft):** A lightweight editor. With the "Extension Pack for Java," it is becoming very good for Java development, though it requires more manual configuration than IntelliJ.

**Recommendation:** Start with IntelliJ IDEA Community Edition for the smoothest learning curve.

## 4. Java Project Structure
Java enforces a tidy organization. You cannot just dump files anywhere if you want to build complex apps.

*   **The Source Folder (`src`):**
    *   Standard Java projects (especially those using Maven or Gradle setup) keep code in a folder named `src/main/java`.
*   **Packages:**
    *   Java groups classes into **packages** (like folders).
    *   **Naming Convention:** To avoid naming collisions with other developers, we use reverse domain names.
    *   *Example:* If your website is `mycoolapp.com`, your package structure should be `com.mycoolapp.utils`.
    *   On your hard drive, this literally looks like a folder structure: `src/main/java/com/mycoolapp/utils/`.
*   **Resources:**
    *   Files that are **not** code (like images, configuration `.properties` files, or XML files) go into `src/main/resources`.
*   **The Classpath:**
    *   You will learn how Java looks through these folders to find the classes it needs to run your application.

---

### Summary of Checkpoints for this Section:
By the end of this module, you should be able to:
1.  Open your terminal/command prompt and type `java -version` and see output (meaning your PATH is set).
2.  Write a "Hello World" in Notepad, compile it, and run it via the terminal.
3.  Install IntelliJ IDEA and create a new project.
4.  Understand why your code lives in `src/main/java`.
