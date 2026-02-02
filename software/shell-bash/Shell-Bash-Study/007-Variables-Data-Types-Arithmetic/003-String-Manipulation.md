Based on the Table of Contents you provided, **Part VII, Section C (String Manipulation)** focuses on how to modify and handle text strings strictly using **Native Bash features** (specifically a feature called **Parameter Expansion**).

This is distinct from using external tools like `sed` or `awk`. The advantage of using these native methods is that they are much faster because the shell doesn't have to start a new external process to do the work.

Here is a detailed explanation of each concept listed in that section.

---

### The Core Concept: Parameter Expansion `${...}`
In Bash, you usually access a variable like `$var`. However, by wrapping the variable in braces—`${var}`—you unlock a syntax that allows you to manipulate the data *inside* the variable before it is printed or used.

#### 1. Length: `${#string}`
This syntax allows you to count the number of characters inside a string variable.

*   **Syntax:** `${#variable_name}`
*   **Logic:** The `#` symbol at the start tells Bash to count the length rather than return the value.

**Example:**
```bash
text="Hello World"
echo ${#text}

# Output: 11
# (5 letters + 1 space + 5 letters = 11 characters)
```

#### 2. Substring Extraction: `${string:position:length}`
This allows you to "slice" a string, extracting only a specific portion of it based on a starting index (offset) and a character count.

*   **Syntax:** `${variable:start_index:number_of_characters}`
*   **Note:** Bash strings are "0-indexed," meaning the first character is at position 0.

**Example:**
```bash
filename="report_2023.txt"

# Extract from index 0, take 6 characters
echo ${filename:0:6}
# Output: report

# Extract from index 7 to the end (length is optional)
echo ${filename:7}
# Output: 2023.txt

# Extract the last 3 characters (using a negative index requires parentheses or a space)
echo ${filename: -3}
# Output: txt
```

#### 3. Pattern Matching & Replacement: `${string/pattern/replacement}`
This is like a "Find and Replace" function built directly into Bash.

*   **Replace First Match:** `${variable/find/replace}`
*   **Replace All Matches:** `${variable//find/replace}` (Note the double slash `//`)
*   **Delete Match:** `${variable/find}` (If you omit the replacement, it deletes the pattern).

**Example:**
```bash
server_path="/home/user/code/project"

# Replace "user" with "admin" (First match only)
echo ${server_path/user/admin}
# Output: /home/admin/code/project

# Replace ALL slashes with dashes
echo ${server_path//\//-}
# Output: -home-user-code-project

# Delete the word "code/"
echo ${server_path/code\//}
# Output: /home/user/project
```

#### 4. Case Conversion: `${string,,}` and `${string^^}`
This feature (introduced in Bash 4.0) allows you to instantly convert text to Lowercase or Uppercase. This is very useful for normalizing user input (e.g., making sure a "YES", "Yes", or "yes" answer are all treated the same).

*   **Lowercase (`,,`):** Converts the whole string to lowercase.
*   **Uppercase (`^^`):** Converts the whole string to uppercase.

**Example:**
```bash
user_input="YeS"
name="john doe"

# Convert to all lowercase
echo ${user_input,,}
# Output: yes

# Convert to all uppercase
echo ${name^^}
# Output: JOHN DOE

# Bonus: Convert only the first character to uppercase (Title Case)
echo ${name^}
# Output: John doe
```

### Summary of concepts in a Script
Here is how you might see these used in a real script:

```bash
#!/bin/bash

file="Video_Holiday_2023.mp4"

# 1. Get Length
len=${#file}
echo "Filename length: $len"

# 2. Extract Year (Start at index 14, take 4 chars)
year=${file:14:4}
echo "Year: $year"

# 3. Replace underscore with space for a nice title
title=${file//_/ }
echo "Title: $title"

# 4. Convert extension to uppercase
extension=${file: -3}
echo "Format: ${extension^^}"
```

### Why learn this?
You *could* use `sed` or `cut` to do these things, but using these native **Variable Expansions** is:
1.  **Faster:** The script doesn't have to pause to call an external program.
2.  **Cleaner:** Your code has fewer pipes (`|`).
3.  **Portable:** It works anywhere modern Bash is installed.
