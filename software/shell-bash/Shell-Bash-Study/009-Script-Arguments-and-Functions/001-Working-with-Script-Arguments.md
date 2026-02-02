Based on the structure provided in your Table of Contents, here is a detailed explanation of basic script arguments (Section IX, Part A).

### **009-Script-Arguments-and-Functions**
#### **001-Working-with-Script-Arguments**

When you write a script, you often want it to be dynamic. You don't want to hardcode values (like a filename or a user's name) directly into the file. Instead, you want to pass this information to the script when you run it from the command line.

**Example:**
Instead of running a script that always backs up `/var/www`, you want to run:
`./backup_script.sh /var/www` or `./backup_script.sh /home/user`

Here is how Bash handles these arguments.

---

### 1. Positional Parameters (`$0` to `$9`)

Bash assigns numeric variables to the arguments passed to a script based on their position.

*   **`$0`**: The name of the script itself.
*   **`$1`**: The first argument passed.
*   **`$2`**: The second argument passed.
*   ...and so on.

**Note on Double-Digit Arguments:** If you have more than 9 arguments, you cannot write `$10` (Bash interprets this as `$1` followed by a zero). You must use curly braces: **`${10}`**.

**Example Script (`greeting.sh`):**
```bash
#!/bin/bash
echo "Script Name: $0"
echo "Hello, $1!"
echo "Your favorite color is $2."
```

**Running it:**
```bash
$ ./greeting.sh Alice Blue
```

**Output:**
```text
Script Name: ./greeting.sh
Hello, Alice!
Your favorite color is Blue.
```

---

### 2. Special Argument Variables

Bash provides special variables to help you manage the *metadata* of the arguments (how many there are, or all of them as a group).

#### **`$#` (Argument Count)**
This variable holds the integer number of arguments passed (excluding `$0`). This is commonly used for error checking to ensure the user provided the necessary input.

**Example:**
```bash
if [ "$#" -lt 2 ]; then
    echo "Error: You must provide a hostname and a port."
    exit 1
fi
```

#### **`$@` vs `$*` (All Arguments)**
Both of these represent "all the arguments passed," but they behave differently when wrapped in quotes.

*   **`$*` ("Star"):** Takes all arguments and crushes them into a **single string** separated by spaces.
    *   *Result:* `"arg1 arg2 arg3"`
*   **`$@` ("At"):** Keeps arguments as **separate strings**. This is usually what you want, especially if your file names contain spaces.
    *   *Result:* `"arg1" "arg2" "arg3"`

**Recommendation:** Almost always use `"$@"` (with quotes) when you want to loop through arguments.

---

### 3. The `shift` Command

Sometimes you want to process arguments one by one and then discard them. The `shift` command removes the first argument (`$1`) and shifts all remaining arguments down by one.

*   Old `$2` becomes `$1`.
*   Old `$3` becomes `$2`.
*   Old `$1` is lost forever.

This is very useful in `while` loops.

**Example Script (`countdown.sh`):**
```bash
#!/bin/bash
echo "Processing items..."

# Loop while there are still arguments left (count > 0)
while [ "$#" -gt 0 ]; do
    echo "Current item: $1"
    shift # Throw away $1, move others down
done
```

**Running it:**
```bash
$ ./countdown.sh apple banana cherry
```

**Output:**
```text
Processing items...
Current item: apple
Current item: banana
Current item: cherry
```

---

### 4. Parsing Options (`getopts`)

As scripts get more professional, you will want to handle **flags** (options) like `-v` (verbose), `-f` (force), or `-n name`.

While you *can* use `shift` and `if` statements to do this manually, Bash provides a built-in tool called **`getopts`** designed specifically for this.

**Syntax:** `getopts "optstring" variable`

*   **Optstring:** A list of characters allowed as flags. Use a colon `:` after a character if that flag requires an argument (like `-f filename`).
*   **Variable:** The variable where the current flag letter is stored.

**Example Script (`deploy.sh`):**
```bash
#!/bin/bash

# Initialize default values
VERBOSE=false
TARGET_ENV="production"

# Loop through options
# "v": allows -v
# "t:": allows -t AND expects an argument after it (like -t staging)
while getopts "vt:" opt; do
  case $opt in
    v)
      VERBOSE=true
      ;;
    t)
      TARGET_ENV="$OPTARG" # $OPTARG holds the value passed to -t
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

echo "Verbose Mode: $VERBOSE"
echo "Deploying to: $TARGET_ENV"
```

**Running it:**
```bash
$ ./deploy.sh -v -t staging
```

**Output:**
```text
Verbose Mode: true
Deploying to: staging
```

### Summary Checklist
1.  Use **`$1`**, **`$2`** to access specific inputs.
2.  Use **`$#`** to check if the user provided enough inputs.
3.  Use **`"$@"`** to loop over all inputs safely.
4.  Use **`getopts`** if you need professional-style flags (like `-v` or `-u username`).
