Here is a detailed breakdown of **Part VIII - A: Exit Codes and Conditional Logic**.

This is one of the most critical sections of Bash scripting. Up until this point, a script is just a list of commands running from top to bottom. **Conditional logic** is what gives your script the ability to "think," make decisions, and react to errors.

---

# Detailed Explanation: Exit Codes and Conditional Logic

## 1. Exit Codes (The Pulse of a Command)

In many programming languages (like C, Python, or Java), functions return `true`, `false`, `void`, or an object. In the Shell, every single command finishes by sending a number back to the system. This number is called an **Exit Code** (or Exit Status).

### The Golden Rule of Exit Codes:
*   **`0` (Zero):** Means **Success**. The command did exactly what it was supposed to do without error.
*   **`1` - `255` (Non-Zero):** Means **Failure**. Something went wrong.

*(Note: This is often confusing for programmers because in Boolean logic, 1 is usually True and 0 is False. In Bash, `0` is "No Error".)*

### How to see the Exit Code: `$?`
Bash stores the exit code of the **last executed command** in a special variable called `$?`.

**Example:**
```bash
ls /home              # Assume this directory exists
echo $?               # Output: 0 (Success)

ls /non_existent_dir  # This directory normally doesn't exist
echo $?               # Output: 2 (Error - standard for 'No such file')
```

---

## 2. The `if`, `elif`, `else` Constructs

Conditionals allow your script to execute code blocks only if certain criteria are met.

### Basic Syntax
The syntax relies on `if`, `then`, `elif` (else if), `else`, and `fi` (if spelled distinct/backwards, allowing the shell to know the block is finished).

```bash
if [ condition ]; then
    # Code to run if condition is true
elif [ other_condition ]; then
    # Code to run if the first failed, but this one is true
else
    # Code to run if everything above failed
fi
```

### How `if` actually works
The `if` statement actually checks the **Exit Code** of the command following it. If the exit code is `0`, the `then` block runs.

Consider this:
```bash
if grep -q "ERROR" logfile.txt; then
    echo "An error was found in the log!"
fi
```
Here, `if` runs `grep`. If `grep` finds the text (exit code 0), the echo statement runs.

---

## 3. The Test Commands: `test`, `[ ]`, and `[[ ]]`

Usually, you aren't just checking if a command ran; you want to compare numbers, check strings, or see if files exist. To do this, we use a "test" command.

### The Evolution of Test
1.  **`test`:** The original command. e.g., `test -f filename`.
2.  **`[ text ]`:** A synonym for `test`. It requires spaces on the inside: `[ condition ]`. This is POSIX standard (runs on any shell).
3.  **`[[ text ]]`:** The **modern Bash** version. It is an upgrade over `[ ]`.

### Why use `[[ ]]` instead of `[ ]`?
*   It is safer with variables that contain spaces.
*   It supports pattern matching/regex.
*   It uses distinct logical operators (`&&` instead of `-a`).

**Recommendation:** Always use `[[ ... ]]` when writing scripts specifically for Bash. Keep `[ ... ]` only if you need strict portability to other shells (like `sh`).

---

## 4. Bash Operators

When using `[[ ... ]]` or `[ ... ]`, you use **Operators** to define the rules.

### A. File Test Operators
Used to check the status of files on the disk.
*   `-e file` : Returns True if the file (or directory) **exists**.
*   `-f file` : Returns True if it exists and is a **regular file**.
*   `-d file` : Returns True if it exists and is a **directory**.
*   `-x file` : Returns True if the file is **executable**.

```bash
if [[ -d "/var/www/html" ]]; then
    echo "The web directory exists."
fi
```

### B. String Comparison Operators
Used to compare text.
*   `"$a" = "$b"` : True if the strings are **equal**. (Can also use `==` in `[[ ]]`).
*   `"$a" != "$b"` : True if strings are **not equal**.
*   `-z "$a"` : True if the string is **empty** (Zero length).
*   `-n "$a"` : True if the string is **not empty** (Non-zero length).

*Pitfall:* Always wrap variables in quotes inside single brackets `[ "$var" ]` to prevent errors if the variable is empty. `[[ ]]` handles this safer, but quoting is still a good habit.

### C. Numeric Comparison Operators
Used strictly for integers. **Do not** use `<` or `>` inside `[ ]` for math, because the shell interprets those as file redirections!

*   `-eq` : Equal to (`1 -eq 1`)
*   `-ne` : Not Equal (`1 -ne 2`)
*   `-gt` : Greater Than (`10 -gt 5`)
*   `-lt` : Less Than (`5 -lt 10`)
*   `-ge` : Greater than or Equal
*   `-le` : Less than or Equal

```bash
count=10
if [[ $count -gt 5 ]]; then
    echo "Count is greater than 5."
fi
```

### D. Logical Operators
Used to combine multiple checks.
*   `&&` (AND): Both conditions must be true.
*   `||` (OR): Either condition can be true.
*   `!` (NOT): Inverts the result.

```bash
# Check if file exists AND is readable
if [[ -f "config.txt" && -r "config.txt" ]]; then
    cat config.txt
fi
```

---

## 5. The `case` Statement

If you find yourself writing a long chain of `if`, `elif`, `elif`, `elif`, you should switch to a `case` statement. It operates like a "Switch" statement in other languages.

### Syntax
*   `case` starts the block.
*   `in` defines the variable to check.
*   `)` ends a pattern logic.
*   `;;` means "Stop here, I found a match" (break).
*   `esac` ends the block (case backwards).

### Example
```bash
read -p "Are you sure? (y/n) " ans

case "$ans" in
    [Yy]|[Yy][Ee][Ss]) # Matches Y, y, YES, yes, Yes...
        echo "You agreed."
        ;;
    [Nn]|[Nn][Oo])
        echo "You disagreed."
        ;;
    *) # The wildcard matches anything else (the default case)
        echo "Invalid input."
        ;;
esac
```

### Summary of this Section
1.  **Exit Codes** are how the system tells you if a command succeeded (0) or failed (non-zero).
2.  **`if`** checks exit codes.
3.  **`[[ ... ]]`** is the test command used to generate exit codes based on comparisons (files, strings, numbers).
4.  **`case`** is cleaner than many `elif` statements for pattern matching.
