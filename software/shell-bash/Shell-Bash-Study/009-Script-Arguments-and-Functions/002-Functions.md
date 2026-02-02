Here is a detailed explanation of **Part IX, Section B: Functions**.

In Bash, functions are one of the most important tools for writing clean, maintainable, and professional-grade scripts. They allow you to group logic into reusable blocks, much like functions or methods in languages like Python or JavaScript, but with specific syntactical quirks unique to the shell.

---

### 1. Defining and Calling Functions

There are two portable ways to define a function in Bash.

#### Syntax
**Method 1 (The POSIX Standard way - Recommended):**
This is the most compatible method across different shells (sh, dash, bash, zsh).
```bash
my_function_name() {
    # Code goes here
    echo "Hello from the function!"
}
```

**Method 2 (The Bash specific way):**
This is easy to read but less portable if you execute your script on a system that doesn't use Bash.
```bash
function my_function_name {
    echo "Hello from the function!"
}
```

#### Calling a Function
To execute the function, you simply write its name. **Do not use parentheses `()` when calling it.**

```bash
# Correct
my_function_name

# Incorrect (will cause errors)
my_function_name()
```

---

### 2. Passing Arguments and Scope

This is where Bash behaves differently than Python or C. You do not define arguments in the parentheses (e.g., `func(arg1)` is invalid). Instead, functions handle arguments exactly like a shell script handles command-line arguments.

#### Processing Arguments
Inside a function:
*   `$1` is the first argument passed *to the function*.
*   `$2` is the second argument, etc.
*   `$@` represents the array of all arguments passed.
*   `$#` is the number of arguments passed.

**Example:**
```bash
greet_user() {
    echo "Hello, $1! Today is $2."
}

# Calling the function with arguments
greet_user "Alice" "Monday"
# Output: Hello, Alice! Today is Monday.
```

#### Variable Scope (`local`)
By default, **all variables in Bash are global**. If you define a variable inside a function, it is visible to the rest of the script. This can lead to bugs where a function accidentally overwrites a variable used elsewhere.

To prevent this, use the `local` keyword.

**The "Global" Problem (Bad Practice):**
```bash
name="John"

set_name() {
    name="Bob"  # This overwrites the global variable!
}

set_name
echo $name
# Output: Bob (The global variable was changed)
```

**The "Local" Solution (Best Practice):**
```bash
name="John"

set_name() {
    local name="Bob" # This exists ONLY inside this function
    echo "Inside: $name"
}

set_name
echo "Outside: $name"
# Output:
# Inside: Bob
# Outside: John (The global variable remains untouched)
```

---

### 3. Returning Values

In languages like Python, you do `return result`. In Bash, `return` does **not** return data; it controls the **exit status**.

There are two ways to get data out of a function:

#### A. The `return` command (Exit Status)
You use `return` to indicate Success (0) or Failure (1-255). This is used for conditional logic.

```bash
check_file_exists() {
    if [[ -f "$1" ]]; then
        return 0 # Success
    else
        return 1 # Failure
    fi
}

# Usage example:
if check_file_exists "/etc/passwd"; then
    echo "File found!"
else
    echo "File missing!"
fi
```

#### B. Echoing to Stdout (Returning Data)
If you want a function to calculate a value (like a string or a number) and "return" it to a variable, you must `echo` the result and capture it using **Command Substitution** `$(...)`.

```bash
get_uppercase() {
    local input="$1"
    # echo the result to standard output
    echo "${input^^}" 
}

# Capture the output into a variable
my_var=$(get_uppercase "hello world")

echo "The value is: $my_var"
# Output: The value is: HELLO WORLD
```

---

### 4. Building Reusable Script Libraries

As your scripts grow, you will want to share functions between multiple scripts. You can do this by creating a "library" file and importing it using `source` (or the dot operator `.`).

**Step 1: Create a library file (`utils.sh`)**
*Note: This file does not need a shebang or executable permissions.*
```bash
# utils.sh

log_message() {
    local msg="$1"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $msg"
}

add_numbers() {
    echo $(($1 + $2))
}
```

**Step 2: Import and use it in your main script (`main.sh`)**
```bash
#!/bin/bash

# Import the library
# "." is the same as "source", but shorter
. ./utils.sh  

log_message "Script started."

result=$(add_numbers 10 5)
echo "The sum is: $result"

log_message "Script finished."
```

### Summary of Best Practices for Functions
1.  **Naming:** Use `snake_case` (e.g., `process_data`).
2.  **Definition:** Use `name() { ... }` for maximum portability.
3.  **Variables:** Always use `local` for variables defined inside the function.
4.  **Returns:** Use `return` for status codes (success/fail), use `echo` for data strings.
5.  **Simplicity:** Adhere to the UNIX philosophy—write functions that do one thing well.
