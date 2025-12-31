# Terminal Knowledge: Comprehensive Study Table of Contents

## Part I: The Command Line Interface (CLI) & Shell Fundamentals

### A. Introduction to the Terminal
*   **The Role of the Shell:** Understanding the command-line interpreter.
*   **Common Shells:** Bash, Zsh, Fish, and PowerShell.
*   **Terminal vs. Shell:** Distinguishing between the terminal emulator and the shell.
*   **The Prompt:** Anatomy of the command prompt and customization (`PS1`).
*   **Executing Commands:** Syntax, arguments, and options.

### B. Filesystem Navigation & Management
*   **Core Commands:** `ls`, `cd`, `pwd`, `mkdir`, `rmdir`.
*   **File Operations:** `touch`, `cp`, `mv`, `rm`.
*   **Directory Structure:** Understanding the Linux/Unix filesystem hierarchy (/, /bin, /etc, /home, etc.).
*   **Permissions:** `chmod` and `chown` for managing file and directory access.
*   **Finding Files:** `find` and `locate` for powerful file searches.

### C. Input, Output, and Pipelines
*   **Standard Streams:** stdin, stdout, and stderr.
*   **Redirection:** Using `>`, `>>`, `<`, and `2>` to control input and output.
*   **Piping:** Chaining commands together with the pipe `|` operator for complex workflows.
*   **Command Substitution:** Using `$(command)` or `` `command` `` to use a command's output as an argument.

## Part II: Scripting & Automation

### A. Bash Scripting
*   **Shebang:** The importance of `#!/bin/bash`.
*   **Variables:** Declaration, assignment, and best practices.
*   **Data Types:** Strings and numbers.
*   **Command-line Arguments:** `$1`, `$@`, `$#`.
*   **Conditional Logic:** `if-elif-else` statements and test conditions (`[ ]`, `[[ ]]`).
*   **Loops:** `for`, `while`, and `until` loops for iterative tasks.
*   **Functions:** Defining and using reusable blocks of code.
*   **Error Handling:** `set -e`, `set -u`, `set -o pipefail` for robust scripts.

### B. PowerShell Scripting
*   **Introduction to PowerShell:** Core concepts and comparison to other shells.
*   **Cmdlets:** Understanding and discovering commands (`Get-Command`, `Get-Help`).
*   **Variables and Data Types:** Strongly typed variables.
*   **Pipelines and Objects:** Passing objects between cmdlets.
*   **Conditional Logic:** `If`, `ElseIf`, `Else` statements.
*   **Loops:** `ForEach-Object`, `For`, `While`, `Do-While`/`Until`.
*   **Functions:** Basic and advanced function creation.
*   **Modules:** Finding, installing, and using PowerShell modules.

## Part III: Text Editors

### A. Vim / Neovim
*   **Modal Editing Philosophy:** Understanding Normal, Insert, and Visual modes.
*   **Basic Navigation:** `h`, `j`, `k`, `l`, and word/line-wise movements.
*   **File Operations:** Opening, saving, and quitting (`:w`, `:q`, `:wq`).
*   **Editing Text:** Deleting, yanking (copying), and putting (pasting).
*   **Searching and Replacing:** `/` for searching, `:%s/foo/bar/g` for find and replace.
*   **Configuration:** Customizing Vim with a `.vimrc` file.
*   **Plugins and Extensions:** Enhancing Vim with plugin managers (e.g., vim-plug, Packer).

### B. Nano
*   **Introduction to Nano:** A beginner-friendly, modeless editor.
*   **Basic Operations:** Opening, saving, and exiting files.
*   **Navigation:** Moving the cursor and scrolling.
*   **Editing:** Cutting, copying, and pasting text.
*   **Searching and Replacing:** Finding and replacing text within a file.
*   **Configuration:** Customizing Nano with a `.nanorc` file.

### C. Emacs
*   **Core Concepts:** Buffers, windows, and the minibuffer.
*   **Keybindings:** Understanding `C-` (Control) and `M-` (Meta/Alt) commands.
*   **File Management:** Opening, saving, and managing buffers.
*   **Basic Editing:** Navigation, deletion, and copy/paste.
*   **Extensibility:** Introduction to Emacs Lisp for customization.
*   **Major and Minor Modes:** Understanding how Emacs adapts to different file types.
*   **Configuration:** The `.emacs` or `init.el` file.

## Part IV: System Monitoring & Management

### A. Process Monitoring
*   **Listing Processes:** `ps`, `pgrep`.
*   **Real-time Monitoring:** `top`, `htop`.
*   **Terminating Processes:** `kill`, `killall`, `pkill`.
*   **Job Control:** Running processes in the foreground and background (`&`, `fg`, `bg`, `jobs`).
*   **Process Priority:** `nice` and `renice`.

### B. Performance Monitoring
*   **CPU Usage:** `top`, `htop`, `vmstat`.
*   **Memory Usage:** `free`, `vmstat`, `top`.
*   **Disk I/O:** `iostat`, `iotop`.
*   **Comprehensive Tools:** `atop`, `glances` for a holistic view.

## Part V: Networking & Text Manipulation

### A. Networking Tools
*   **Connectivity and Troubleshooting:** `ping`, `traceroute`, `mtr`.
*   **Network Configuration:** `ip`, `ifconfig` (legacy).
*   **DNS Lookup:** `dig`, `host`, `nslookup`.
*   **Socket and Port Information:** `ss`, `netstat` (legacy).
*   **Data Transfer:** `curl`, `wget`.
*   **Remote Access:** `ssh`, `scp`, `rsync`.

### B. Text Manipulation
*   **Viewing and Concatenating:** `cat`, `tac`, `less`, `more`.
*   **Searching and Filtering:** `grep` for pattern matching.
*   **Stream Editing:** `sed` for find and replace operations.
*   **Advanced Text Processing:** `awk` for field-based processing.
*   **Sorting and Uniqueness:** `sort`, `uniq`.
*   **Extracting Columns:** `cut`.
*   **Character Translation:** `tr`.
*   **Counting:** `wc` (word, line, and character count).