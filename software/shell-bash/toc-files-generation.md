Here is the bash script to generate your study structure.

I have formatted the filenames to be URL-friendly (using dashes instead of spaces) and ensured that special characters inside the Markdown content (like `$`, `` ` ``, etc.) are preserved exactly as they appear in your TOC by using quoted Heredocs (`<< 'EOF'`).

### How to use this:
1. Copy the code block below.
2. Open your terminal in Ubuntu.
3. Create a file, e.g., `nano setup_shell_study.sh`.
4. Paste the code.
5. Save and exit (`Ctrl+O`, `Enter`, `Ctrl+X`).
6. Make it executable: `chmod +x setup_shell_study.sh`.
7. Run it: `./setup_shell_study.sh`.

```bash
#!/bin/bash

# Define the root directory name
ROOT_DIR="Shell-Bash-Study"

# Create the root directory
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR" || exit

echo "Creating directory structure in $(pwd)..."

# ==========================================
# PART I: Shell Fundamentals & Core Principles
# ==========================================
PART_DIR="001-Shell-Fundamentals-Core-Principles"
mkdir -p "$PART_DIR"

# Section A
cat << 'EOF' > "$PART_DIR/001-Introduction-to-the-Shell.md"
# Introduction to the Shell

- **What is a Shell?** The "Command-Line Interface" (CLI)
- **The Shell's Role:** User Interface to the Operating System Kernel
- **CLI vs. GUI:** Why Learn the Command Line? (Speed, Automation, Power)
- **The UNIX Philosophy:** Write programs that do one thing and do it well.
- **Interactive Shell vs. Scripting:** The Two Modes of Operation
EOF

# Section B
cat << 'EOF' > "$PART_DIR/002-The-Shell-Ecosystem.md"
# The Shell Ecosystem

- **Popular Shells:**
  - **Bash (Bourne Again SHell):** The de facto standard on most Linux systems.
  - **Zsh (Z Shell):** A powerful, modern alternative with advanced features.
  - **Fish (Friendly Interactive SHell):** User-friendly with smart defaults.
  - **Legacy Shells:** sh (Bourne Shell), csh, tcsh, ksh (KornShell).
  - **Windows Equivalents:** PowerShell, CMD.
- **Why We Focus on Bash:** Portability and Ubiquity.
EOF

# Section C
cat << 'EOF' > "$PART_DIR/003-Setting-Up-Your-Environment.md"
# Setting Up Your Environment

- **Terminal Emulators:** Your Window to the Shell (GNOME Terminal, Konsole, iTerm2, Windows Terminal).
- **The Shell Prompt:** Anatomy and Customization (`PS1`).
- **Shell Startup Files:** Understanding `.bash_profile`, `.bashrc`, and `.profile`.
- **First Commands:** `whoami`, `hostname`, `uname`, `date`.
EOF


# ==========================================
# PART II: The Interactive Shell
# ==========================================
PART_DIR="002-The-Interactive-Shell-Filesystem"
mkdir -p "$PART_DIR"

# Section A
cat << 'EOF' > "$PART_DIR/001-Core-Navigation.md"
# Core Navigation

- **The Filesystem Hierarchy Standard (FHS):** Understanding `/bin`, `/etc`, `/home`, `/var`.
- **Absolute vs. Relative Paths.**
- **Navigation Commands:** `pwd`, `cd`, `ls` (with flags like `-l`, `-a`, `-h`).
- **Directory Management:** `mkdir`, `rmdir`.
- **Special Directories:** `.` (current), `..` (parent), `~` (home), `-` (previous).
EOF

# Section B
cat << 'EOF' > "$PART_DIR/002-File-and-Directory-Manipulation.md"
# File & Directory Manipulation

- **Creating Files:** `touch`.
- **Viewing Files:**
  - `cat` (concatenate and print).
  - **Pagers:** `less`, `more`.
  - **Partial Views:** `head`, `tail` (and the `-f` flag for live monitoring).
- **Copying, Moving, and Renaming:** `cp`, `mv`.
- **Deleting:** `rm` (and its dangerous flags: `-r`, `-f`).
EOF

# Section C
cat << 'EOF' > "$PART_DIR/003-Finding-Things.md"
# Finding Things

- **`find`:** Searching by name, type, size, modification time.
- **`locate`:** Fast, index-based searching.
- **`which`, `whereis`, `type`:** Finding command executables.
EOF

# Section D
cat << 'EOF' > "$PART_DIR/004-Productivity-Boosters.md"
# Productivity Boosters

- **Tab Completion:** The single most important productivity feature.
- **Command History:** `history`, `Ctrl+R` (reverse-i-search), `!!` (repeat last), `!n` (repeat nth).
- **Aliases:** Creating shortcuts for long commands with `alias`.
- **Getting Help:** `man` (manual pages), `tldr`, `--help` flag.
- **Job Control:** `Ctrl+C` (interrupt), `Ctrl+Z` (suspend).
EOF


# ==========================================
# PART III: Permissions, Users, and Ownership
# ==========================================
PART_DIR="003-Permissions-Users-Ownership"
mkdir -p "$PART_DIR"

# Section A
cat << 'EOF' > "$PART_DIR/001-UNIX-Permission-Model.md"
# The UNIX Permission Model

- **Reading Permissions:** `r` (read), `w` (write), `x` (execute).
- **Permission Groups:** User, Group, Other.
- **Notation:** Symbolic (`rwx-`) vs. Octal (`755`).
EOF

# Section B
cat << 'EOF' > "$PART_DIR/002-Managing-Permissions.md"
# Managing Permissions

- **`chmod`:** Changing permissions for files and directories.
- **`chown`:** Changing the owner.
- **`chgrp`:** Changing the group.
- **`umask`:** Setting default permissions for new files.
EOF

# Section C
cat << 'EOF' > "$PART_DIR/003-Special-Permissions.md"
# Special Permissions & Concepts

- **`sudo`:** Executing commands with superuser privileges.
- **Understanding `suid`, `sgid`, and the Sticky Bit.**
EOF


# ==========================================
# PART IV: I/O, Pipes, and Redirection
# ==========================================
PART_DIR="004-IO-Pipes-Redirection"
mkdir -p "$PART_DIR"

# Section A
cat << 'EOF' > "$PART_DIR/001-Standard-Streams.md"
# The Standard Streams

- **Standard Input (stdin, 0):** Where a program gets its input.
- **Standard Output (stdout, 1):** Where a program sends its normal output.
- **Standard Error (stderr, 2):** Where a program sends its error messages.
EOF

# Section B
cat << 'EOF' > "$PART_DIR/002-Redirection.md"
# Redirection

- **Output Redirection:** `>` (overwrite), `>>` (append).
- **Error Redirection:** `2>`, `2>>`.
- **Redirecting Both stdout & stderr:** `&>`, `> file 2>&1`.
- **Input Redirection:** `<`.
- **The Null Device:** Redirecting unwanted output to `/dev/null`.
EOF

# Section C
cat << 'EOF' > "$PART_DIR/003-Pipelines.md"
# Pipelines

- **The Pipe Operator (`|`):** Chaining commands together.
- **Building Command Chains:** e.g., `cat logfile.log | grep "ERROR" | wc -l`.
- **`xargs`:** Building and executing command lines from standard input.
EOF

# Section D
cat << 'EOF' > "$PART_DIR/004-Advanced-IO.md"
# Advanced I/O

- **Command Substitution:** `$()` vs. Backticks `` ` ``.
- **Process Substitution:** `<()` and `>()`.
- **Here Documents (`<<`) and Here Strings (`<<<`).**
EOF


# ==========================================
# PART V: Working with Text
# ==========================================
PART_DIR="005-Working-with-Text"
mkdir -p "$PART_DIR"

# Section A
cat << 'EOF' > "$PART_DIR/001-Searching-and-Filtering.md"
# Searching & Filtering

- **`grep`:** The cornerstone of text searching.
- **Regex with grep:** Basic vs. Extended Regular Expressions (`-E`).
- **Common Flags:** `-i` (ignore case), `-v` (invert match), `-c` (count), `-o` (only matching).
EOF

# Section B
cat << 'EOF' > "$PART_DIR/002-Transforming-Text.md"
# Transforming Text

- **`sed`:** The "stream editor" for find-and-replace, deletion, and insertion.
- **`tr`:** Translating or deleting characters.
- **`cut`:** Removing sections from each line of files.
- **`paste`:** Merging lines of files.
- **`join`:** Joining lines of two files on a common field.
EOF

# Section C
cat << 'EOF' > "$PART_DIR/003-Analyzing-and-Aggregating.md"
# Analyzing & Aggregating Text

- **`sort`:** Sorting lines of text files.
- **`uniq`:** Reporting or omitting repeated lines.
- **`wc`:** Word, line, character, and byte count.
- **`awk`:** A powerful pattern-scanning and processing language.
EOF


# ==========================================
# PART VI: Introduction to Bash Scripting
# ==========================================
PART_DIR="006-Introduction-to-Bash-Scripting"
mkdir -p "$PART_DIR"

# Section A
cat << 'EOF' > "$PART_DIR/001-Anatomy-of-a-Bash-Script.md"
# Anatomy of a Bash Script

- **The Shebang:** `#!/bin/bash`.
- **Comments:** The `#` symbol.
- **Commands & Exit Codes.**
- **Best Practices:** Quoting, Naming Conventions, Readability.
EOF

# Section B
cat << 'EOF' > "$PART_DIR/002-Running-Scripts.md"
# Running Scripts

- **Making a Script Executable:** `chmod +x my_script.sh`.
- **Execution Methods & Their Differences:**
  - `./my_script.sh` (in a new subshell).
  - `bash my_script.sh` (explicitly with bash).
  - `source my_script.sh` or `. my_script.sh` (in the current shell).
EOF

# Section C
cat << 'EOF' > "$PART_DIR/003-Editors-for-Scripting.md"
# Editors for Scripting

- **Terminal Editors:** Nano, Vim, Emacs.
- **GUI Editors with Shell Support:** VS Code (with extensions).
EOF


# ==========================================
# PART VII: Variables, Data Types, and Arithmetic
# ==========================================
PART_DIR="007-Variables-Data-Types-Arithmetic"
mkdir -p "$PART_DIR"

# Section A
cat << 'EOF' > "$PART_DIR/001-Variables.md"
# Variables

- **Declaration, Assignment, and Referencing:** `VAR="value"`, `echo "$VAR"`.
- **The Importance of Quoting:** `"$VAR"` vs. `$VAR`.
- **Shell vs. Environment Variables:** The `export` command.
- **Special Variables:** `$?` (exit status), `$$` (PID), `$!` (last background job PID).
EOF

# Section B
cat << 'EOF' > "$PART_DIR/002-Bash-Data-Types.md"
# Bash "Data Types"

- **Strings:** The default data type.
- **Arrays (Indexed):** `my_array=()`, `my_array[0]="A"`.
- **Associative Arrays (Hashes):** `declare -A my_map`, `my_map[key]="value"`.
EOF

# Section C
cat << 'EOF' > "$PART_DIR/003-String-Manipulation.md"
# String Manipulation

- **Length:** `${#string}`.
- **Substring Extraction:** `${string:position:length}`.
- **Pattern Matching & Replacement:** `${string/pattern/replacement}`.
- **Case Conversion:** `${string,,}` (lowercase), `${string^^}` (uppercase).
EOF

# Section D
cat << 'EOF' > "$PART_DIR/004-Arithmetic.md"
# Arithmetic

- **Arithmetic Expansion:** `((...))`.
- **Legacy Tools:** `let`, `expr`.
- **Floating Point Math:** Using `bc`.
EOF


# ==========================================
# PART VIII: Script Logic & Control Flow
# ==========================================
PART_DIR="008-Script-Logic-Control-Flow"
mkdir -p "$PART_DIR"

# Section A
cat << 'EOF' > "$PART_DIR/001-Exit-Codes-and-Conditional-Logic.md"
# Exit Codes and Conditional Logic

- **Success vs. Failure:** `0` for success, `1-255` for failure.
- **The `if`, `elif`, `else` constructs.**
- **The `test` command and its Brackets:** `[...]` (legacy) vs. `[[...]]` (modern).
- **Bash Operators:**
  - **File Tests:** `-f` (is file), `-d` (is directory), `-e` (exists).
  - **String Comparisons:** `=`, `!=`, `-z` (is null).
  - **Numeric Comparisons:** `-eq`, `-ne`, `-gt`, `-lt`.
  - **Logical Operators:** `-a`/`&&` (AND), `-o`/`||` (OR).
- **The `case` Statement.**
EOF

# Section B
cat << 'EOF' > "$PART_DIR/002-Loops.md"
# Loops

- **`for` loops:** Iterating over lists, files, command output.
- **`while` loops:** Looping as long as a condition is true.
- **`until` loops:** Looping until a condition is true.
- **Loop Control:** `break`, `continue`.
EOF


# ==========================================
# PART IX: Script Arguments and Functions
# ==========================================
PART_DIR="009-Script-Arguments-and-Functions"
mkdir -p "$PART_DIR"

# Section A
cat << 'EOF' > "$PART_DIR/001-Working-with-Script-Arguments.md"
# Working with Script Arguments

- **Positional Parameters:** `$0` (script name), `$1`, `$2`, ...
- **Special Argument Variables:** `$#` (count), `$*` (all args as one string), `$@` (all args as separate strings).
- **`shift`:** Shifting positional parameters.
- **Parsing Options:** `getopts`.
EOF

# Section B
cat << 'EOF' > "$PART_DIR/002-Functions.md"
# Functions

- **Defining and Calling Functions.**
- **Passing Arguments and Scope (`local` variables).**
- **Returning Values:** Using exit codes or `echo` to stdout.
- **Building Reusable Script Libraries.**
EOF


# ==========================================
# PART X: Advanced Scripting & Error Handling
# ==========================================
PART_DIR="010-Advanced-Scripting-Error-Handling"
mkdir -p "$PART_DIR"

# Section A
cat << 'EOF' > "$PART_DIR/001-Robust-Scripting-Practices.md"
# Robust Scripting Practices

- **"Unofficial Bash Strict Mode":** `set -e`, `set -u`, `set -o pipefail`.
- **`trap`:** Catching signals and running cleanup code.
- **Error Logging and Messaging.**
EOF

# Section B
cat << 'EOF' > "$PART_DIR/002-Debugging.md"
# Debugging

- **Tracing Execution:** `set -x` or `bash -x`.
- **Syntax Checking:** `bash -n`.
- **Static Analysis with `shellcheck`:** An essential tool.
EOF

# Section C
cat << 'EOF' > "$PART_DIR/003-Advanced-Pattern-Matching.md"
# Advanced Pattern Matching

- **Wildcards (Globbing):** `*`, `?`, `[...]`.
- **Brace Expansion:** `echo image{1..100}.jpg`.
- **Regular Expressions Revisited:** In `grep`, `sed`, and `awk`.
EOF


# ==========================================
# PART XI: Process & System Management
# ==========================================
PART_DIR="011-Process-System-Management"
mkdir -p "$PART_DIR"

# Section A
cat << 'EOF' > "$PART_DIR/001-Process-Management.md"
# Process Management

- **Foreground vs. Background Processes (`&`).**
- **Monitoring Jobs:** `jobs`.
- **Controlling Jobs:** `fg`, `bg`.
- **`nohup` & `disown`:** Keeping processes running after shell exit.
- **Viewing Processes:** `ps`, `pgrep`.
- **System Monitoring:** `top`, `htop`.
- **Sending Signals:** `kill`, `pkill`, `killall`.
EOF

# Section B
cat << 'EOF' > "$PART_DIR/002-System-Information.md"
# System Information

- **Memory Usage:** `free`.
- **Disk Usage:** `df`, `du`.
- **System Uptime:** `uptime`.
- **I/O and CPU Stats:** `iostat`, `vmstat`.
EOF


# ==========================================
# PART XII: Networking and Data Transfer
# ==========================================
PART_DIR="012-Networking-and-Data-Transfer"
mkdir -p "$PART_DIR"

# Section A
cat << 'EOF' > "$PART_DIR/001-Network-Utilities.md"
# Network Utilities

- **Connectivity Testing:** `ping`.
- **Downloading Files:** `wget`, `curl`.
- **Secure Remote Access:** `ssh`.
- **Secure File Transfer:** `scp`, `rsync`.
EOF

# Section B
cat << 'EOF' > "$PART_DIR/002-Network-Inspection.md"
# Network Inspection

- **Viewing Network Connections:** `netstat`, `ss`.
- **Viewing/Configuring Network Interfaces:** `ip`, `ifconfig` (legacy).
EOF


# ==========================================
# PART XIII: System Administration & Workflow
# ==========================================
PART_DIR="013-System-Administration-Workflow"
mkdir -p "$PART_DIR"

# Section A
cat << 'EOF' > "$PART_DIR/001-Package-Management.md"
# Package Management

- **Debian/Ubuntu:** `apt`, `apt-get`.
- **Red Hat/CentOS/Fedora:** `yum`, `dnf`.
- **macOS:** `brew`.
EOF

# Section B
cat << 'EOF' > "$PART_DIR/002-Archiving-and-Compression.md"
# Archiving and Compression

- **`tar`:** The Tape Archiver, for bundling files.
- **Compression Tools:** `gzip`, `bzip2`, `xz`.
- **All-in-one:** `zip`.
EOF

# Section C
cat << 'EOF' > "$PART_DIR/003-Task-Scheduling.md"
# Task Scheduling

- **`cron` & `crontab`:** Running jobs on a schedule.
- **`at`:** Running a job once at a later time.
- **Modern Alternatives:** `systemd` timers.
EOF


# ==========================================
# PART XIV: Where to Go Next
# ==========================================
PART_DIR="014-Where-to-Go-Next"
mkdir -p "$PART_DIR"

# Section A
cat << 'EOF' > "$PART_DIR/001-Mastering-the-Tools.md"
# Mastering the Tools

- **Diving Deeper into `awk` and `sed`.**
- **Exploring Powerful CLI Tools:** `fzf`, `ripgrep` (`rg`), `jq` (for JSON).
EOF

# Section B
cat << 'EOF' > "$PART_DIR/002-Expanding-Your-Horizons.md"
# Expanding Your Horizons

- **Exploring Other Shells:** `zsh` with Oh My Zsh, `fish`.
- **Writing Portable POSIX-compliant Scripts.**
- **Connecting Shell Scripts with Other Languages** (Python, Perl, etc.).
EOF

# Section C
cat << 'EOF' > "$PART_DIR/003-Related-Roadmaps.md"
# Related Roadmaps

- **Linux Administration:** Deepen your OS knowledge.
- **DevOps:** Apply shell scripting to automation, CI/CD, and infrastructure.
- **Backend Development:** Use shell skills for deployment and server management.
EOF

echo "Done! Study hierarchy created in $ROOT_DIR."
```
