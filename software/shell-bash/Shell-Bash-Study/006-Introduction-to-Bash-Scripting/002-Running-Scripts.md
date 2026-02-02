Based on the Table of Contents you provided, here is a detailed explanation of **Part VI, Section B: Running Scripts**.

This section focuses on the different mechanics of actually executing the code you have written. While it might seem like there should be only one way to "run a program," in Bash, *how* you run the script determines *where* it runs and *what permissions* it needs.

Here is the breakdown of the three main concepts involved:

---

### 1. Making a Script Executable: `chmod +x`

By default, when you create a file in Linux/Unix (e.g., typically using a text editor like command `touch` or `nano`), the system treats it as a text file for reading and writing, **not** as a program to be run.

If you try to run it immediately, you will get a `Permission denied` error. To fix this, you must change the file mode bits.

*   **Command:** `chmod +x my_script.sh`
*   **What it does:** This adds the **eXecute** permission to the file. It tells the operating system, "This isn't just a text document; it's a program that can perform actions."

---

### 2. Execution Methods & Their Differences

Once you have a script, there are three distinct ways to run it. Understanding the difference is crucial because they affect how variables and processes are handled.

#### A. The Standard Method: `./my_script.sh`
This is how most scripts are meant to be run.

*   **Prerequisite:** The file **must** have executable permissions (`chmod +x`).
*   **The Shebang:** The system looks at the top line of your script (e.g., `#!/bin/bash`) to decide which program (interpreter) to use to run the code.
*   **The `./`:** You might wonder, "Why can't I just type `my_script.sh`?" For security reasons, Linux does not look in the current folder for commands. You must explicitly tell it: "Run the script located in **.** (current directory) named **/my_script.sh**."
*   **Scope (Important):** This runs the script in a **Subshell**.
    *   The system creates a temporary, new instance of Bash to run your script.
    *   When the script finishes, that temporary instance closes.
    *   Any variables created inside the script **disappear** when the script ends.

#### B. The Interpreter Method: `bash my_script.sh`
You are manually invoking the `bash` program and passing your script file as an argument.

*   **Prerequisite:** The file **does NOT** need executable permissions. You can run read-only text files this way.
*   **Scope:** Like the standard method, this also runs inside a **Subshell**. Variables created inside do not stick around after the script finishes.
*   **Use Case:** This is often used for debugging (e.g., `bash -x my_script.sh`) or when you don't have permission to modify the file's permissions with `chmod`.

#### C. The Sourcing Method: `source` or `.`
This is fundamentally different from the previous two.

*   **Commands:** `source my_script.sh` OR `. my_script.sh` (The dot is just a shortcut for `source`).
*   **What it does:** It tells your **current** terminal shell to read the file and execute lines one by one as if you were typing them yourself right now.
*   **Scope:** It runs in the **Current Shell**.
    *   **No new process is created.**
    *   **Persistence:** If the script defines a variable (e.g., `API_KEY="123"`), that variable will **remain available** in your terminal even after the script finishes running.
*   **Use Case:** This is primarily used for configuration files (like `.bashrc`) because you want the settings inside that file to apply to your current session.

---

### Summary Comparison Table

| Method | Syntax | Needs `chmod +x`? | Runs in... | Variables Persist? |
| :--- | :--- | :---: | :--- | :---: |
| **Direct** | `./script.sh` | **Yes** | New Subshell | No |
| **Interpreter** | `bash script.sh` | No | New Subshell | No |
| **Source** | `source script.sh` | No | **Current Shell** | **Yes** |
