Based on the Table of Contents you provided, here is a detailed explanation of **Part I, Section C: Input, Output, and Pipelines**.

This is one of the most powerful concepts in the Linux/Unix command line. It explains how commands communicate with each other and how you can manipulate where data goes (to a file, to another program, or to the screen).

---

### 1. Standard Streams
Every time you run a command in the terminal (like `ls` or `cat`), the shell opens three distinct data streams (channels). Think of these as logical "pipes" connected to the program.

*   **stdin (Standard Input - File Descriptor 0):** This is where the command receives information. By default, this is your **keyboard**.
*   **stdout (Standard Output - File Descriptor 1):** This is where the command sends its normal results. By default, this is your **terminal screen**.
*   **stderr (Standard Error - File Descriptor 2):** This is where the command sends error messages. By default, this is also your **terminal screen**.

**Why this matters:** Linux splits "success messages" (stdout) and "error messages" (stderr) so you can separate them if needed (e.g., save the data to a file but print errors to the screen).

---

### 2. Redirection
Redirection allows you to change where `stdin`, `stdout`, and `stderr` go. Instead of the screen or keyboard, you can point them to files.

#### **Output Redirection (`>` and `>>`)**
*   **`>` (Overwrite):** Takes the output of a command and writes it to a file. **Warning:** If the file exists, it empties it and starts fresh.
    *   *Example:* `echo "Hello World" > notes.txt`
    *   *Result:* Creates `notes.txt` containing only "Hello World".
*   **`>>` (Append):** Takes the output and adds it to the **end** of an existing file without deleting current content.
    *   *Example:* `echo "Another line" >> notes.txt`
    *   *Result:* `notes.txt` now has two lines.

#### **Input Redirection (`<`)**
*   **`<`:** Feeds the contents of a file into a command as input.
    *   *Example:* `sort < unsorted_names.txt`
    *   *Result:* The `sort` command reads the file and outputs the names alphabetically to the screen.

#### **Error Redirection (`2>`)**
*   **`2>`:** Specifically redirects only the **Error (Stream 2)** messages to a file.
    *   *Example:* `ls /fake/directory 2> errors.log`
    *   *Result:* The error message (e.g., "No such file or directory") is hidden from the screen and saved into `errors.log`.

---

### 3. Piping (`|`)
This is the "killer feature" of the Linux shell. A pipe allows you to take the **Standard Output** of one command and plug it directly into the **Standard Input** of the next command.

This allows you to chain simple tools together to build complex workflows.

*   **Syntax:** `command1 | command2`
*   **Concept:** Think of an assembly line. Command 1 processes data -> hands it to Command 2 -> hands it to Command 3.

**Example Scenario:**
You want to see how many files inside a directory are Python scripts.
1.  `ls` (lists files)
2.  `grep` (filters text)
3.  `wc -l` (counts lines)

**The Command:**
```bash
ls | grep ".py" | wc -l
```
*   **Step 1:** `ls` lists all files.
*   **Step 2:** The pipe `|` sends that list to `grep ".py"`, which throws away anything that isn't a Python file.
*   **Step 3:** The pipe `|` sends the remaining list of Python files to `wc -l`, which counts them and prints the number.

---

### 4. Command Substitution
This allows you to run a command, capture its output, and immediately use that output as an argument inside *another* command.

There are two ways to do this:
1.  **Modern Syntax:** `$(command)` (Recommended)
2.  **Legacy Syntax:** `` `command` `` (Backticks)

**How it works:**
The shell runs the inner command first, replaces it with the result, and then runs the outer command.

**Example 1:**
You want to create a file with today's date in the name.
```bash
touch log-$(date +%F).txt
```
*   The shell runs `date +%F` which calculates `2023-10-27` (for example).
*   The command actually executed becomes: `touch log-2023-10-27.txt`.

**Example 2:**
You want to find where the `java` program is located and check its file type.
```bash
file $(which java)
```
*   `which java` finds the path (e.g., `/usr/bin/java`).
*   The command becomes: `file /usr/bin/java`.

---

### Summary Table

| Symbol | Name | Function |
| :--- | :--- | :--- |
| `>` | Redirect Output | Writes output to a file (Overwrites). |
| `>>` | Append Output | Adds output to the end of a file. |
| `<` | Redirect Input | Feeds a file into a command. |
| `2>` | Redirect Error | Writes only error messages to a file. |
| `|` | Pipe | Passes output of Command A to Command B. |
| `$()` | Substitution | Uses the result of a command as text. |
