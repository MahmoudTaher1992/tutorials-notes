This section of the roadmap covers **Advanced Pattern Matching**. In the world of Shell/Bash, pattern matching is the ability to define a specific set of filenames or strings using shorthand characters instead of typing out every single exact name.

Here is a detailed breakdown of the three core concepts in this section: **Globbing**, **Brace Expansion**, and **Regular Expressions**.

---

### 1. Wildcards (Globbing)
"Globbing" is the shell’s native method of matching filenames. When you type a glob pattern, Bash expands it into a list of matching filenames *before* the command is even executed.

#### The Asterisk (`*`)
Matches **zero or more** characters.
*   **Concept:** "I don't care what is here, or how short/long it is."
*   **Example:** `ls *.txt`
    *   Matches: `notes.txt`, `README.txt`, `.txt`
*   **Example:** `rm log*`
    *   Matches: `log`, `log_2023`, `login_script.sh`

#### The Question Mark (`?`)
Matches **exactly one** character.
*   **Concept:** "There must be a character here, but it can be anything."
*   **Example:** `ls image_?.jpg`
    *   Matches: `image_1.jpg`, `image_a.jpg`
    *   Does **not** match: `image_10.jpg` (because `10` is two characters).

#### Square Brackets (`[...]`)
Matches **exactly one** character from a specific set or range.
*   **Concept:** "I want one character here, but only if it's one of these specific ones."
*   **Explicit List:** `ls file[123].txt` matches `file1.txt`, `file2.txt`, or `file3.txt`.
*   **Range:** `ls file[a-z].txt` matches any file with a single lowercase letter in that spot.
*   **Negation (`!` or `^`):** `ls file[!0-9].txt` matches files where the character is *not* a number.

---

### 2. Brace Expansion
While Globbing is used to **find** existing files, Brace Expansion is used to **generate** arbitrary strings. The shell creates the strings regardless of whether the files actually exist or not.

#### Lists
Since it generates strings, it is perfect for batch operations.
*   **Syntax:** `{item1,item2,item3}`
*   **Command:** `touch project/{src,bin,doc}/info.txt`
*   **Result:** This creates `project/src/info.txt`, `project/bin/info.txt`, and `project/doc/info.txt` simultaneously.

#### Ranges
You can generate sequences of numbers or letters.
*   **Syntax:** `{start..end}`
*   **Command:** `echo {1..10}`
    *   **Output:** `1 2 3 4 5 6 7 8 9 10`
*   **Command with Step:** `echo {0..10..2}` (0 to 10 in steps of 2)
    *   **Output:** `0 2 4 6 8 10`

#### The "Backup Trick"
A very common use case for system administrators is quickly backing up a file without retyping the path.
*   **Command:** `cp /etc/nginx/nginx.conf{,.bak}`
*   **What happens:** Bash expands this to `cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak`.

---

### 3. Extended Globbing (`extglob`)
This is the "Advanced" part of Bash pattern matching. Standard globs (`*`, `?`) are sometimes not specific enough. By enabling extended globbing (`shopt -s extglob`), you unlock logic that looks very similar to Regular Expressions, but works on filenames.

**Why use it?** It solves the problem of "Select everything EXCEPT this one thing."

*   `?(pattern-list)`: Matches zero or one occurrence of the patterns.
*   `*(pattern-list)`: Matches zero or more occurrences.
*   `+(pattern-list)`: Matches one or more occurrences.
*   `@(pattern-list)`: Matches exactly one occurrence.
*   `!(pattern-list)`: **Matches anything that DOES NOT match the pattern.**

**Example:** Deleting all files except your script.
```bash
shopt -s extglob       # Turn it on
rm !(*.sh)             # Delete everything that does NOT end in .sh
```

---

### 4. Regular Expressions (Regex) Revisited
While Globbing works on **filenames**, Regular Expressions work on **text content**.

#### In Bash (`[[ ]]`)
Bash has a built-in regex operator `=~` used inside the modern test brackets `[[ ... ]]`. This allows for validation logic inside scripts.

**Example: Validating a date format (YYYY-MM-DD)**
```bash
date_string="2023-10-31"
if [[ "$date_string" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
    echo "Valid date format."
else
    echo "Invalid format."
fi
```

#### In External Tools
Most text processing in Bash scripts is handed off to tools that specialize in Regex:

*   **`grep`:** Uses Regex to search *within* files.
    *   `grep -E "Error|Warning" log.txt` (Find lines with "Error" OR "Warning").
*   **`sed`:** Uses Regex to replace text.
    *   `sed 's/[0-9]\{3\}/XXX/g' file.txt` (Mask all 3-digit numbers).
*   **`awk`:** Uses Regex to decide which lines of data to process.

### Summary Table

| Feature | Primary Use | Example |
| :--- | :--- | :--- |
| **Globbing** | Matching specific Filenames | `*.jpg`, `file[1-3].txt` |
| **Brace Expansion** | Generating strings/sequences | `{1..10}`, `file{A,B}.txt` |
| **Extglob** | Complex file matching (Negation) | `rm !(keep.txt)` |
| **Regex** | Text content analysis | `[[ $VAR =~ ^[0-9]+$ ]]`, `grep` |
