Based on the Table of Contents you provided, here is a detailed explanation of **Part III: Text Editors -> A. Vim / Neovim**.

Vim (Vi IMproved) and its modern fork, Neovim, are command-line text editors. Unlike standard text editors (like Notepad or VS Code) where you can immediately type text, Vim relies on **keyboard shortcuts** and **modes** to edit files efficiently without touching the mouse.

Here is the breakdown of the concepts listed in that section:

---

### 1. Modal Editing Philosophy
Most editors are "modeless"—meaning if you press the letter `j`, the letter `j` appears on the screen. Vim is **Modal**, meaning the keys on your keyboard do different things depending on which "mode" you are in.

*   **Normal Mode:** The default mode when you open Vim. Here, keys are used for **navigation and manipulation**. Pressing `j` moves the cursor down; it does not type the letter "j". You cannot type text in this mode.
*   **Insert Mode:** This acts like a standard text editor. You enter this mode by pressing `i` (insert) or `a` (append). Now, if you press `j`, the letter "j" is typed into the file. You press `Esc` to leave Insert Mode and return to Normal Mode.
*   **Visual Mode:** Used for highlighting and selecting text. You enter this by pressing `v` (character select) or `V` (line select). Once selected, you can delete, copy, or format that block of text.

### 2. Basic Navigation
Because you don't use a mouse in Vim, you use keys to move the cursor. While the arrow keys usually work, Vim professionals use the "Home Row" keys for speed (so your hands never leave the typing position).

*   **`h`:** Move Left.
*   **`j`:** Move Down.
*   **`k`:** Move Up.
*   **`l`:** Move Right.
*   **Word-wise Movement:**
    *   `w`: Jump forward to the start of the next **w**ord.
    *   `b`: Jump **b**ackward to the start of a word.
*   **Line-wise Movement:**
    *   `0`: Jump to the start of the line.
    *   `$`: Jump to the end of the line.
    *   `gg`: Jump to the beginning of the file.
    *   `G`: Jump to the very end of the file.

### 3. File Operations
To save files or quit, you must switch to **Command-Line Mode** by typing a colon (`:`) while in Normal Mode. The command appears at the bottom left of the screen.

*   **`:w`**: Write. This saves the file to the disk.
*   **`:q`**: Quit. This closes Vim. (If you have unsaved changes, Vim will refuse to close).
*   **`:q!`**: Force Quit. This closes Vim and discards unsaved changes.
*   **`:wq`** (or `:x`): Write and Quit. Save the file and close the editor immediately.

### 4. Editing Text
In Normal Mode, the keyboard becomes a control panel for editing structure. Vim treats editing like a language (Subject + Verb + Object).

*   **Deleting (`d`):**
    *   `x`: Delete the character under the cursor.
    *   `dd`: Delete the entire line.
    *   `dw`: Delete from the cursor to the next **w**ord.
*   **Yanking (`y`):** In Vim terminology, "Yank" means **Copy**.
    *   `yy`: Copy the current line.
    *   `yw`: Copy the current word.
*   **Putting (`p`):** In Vim terminology, "Put" means **Paste**.
    *   `p`: Paste the deleted or copied text *after* the cursor.
    *   `P`: Paste *before* the cursor.
*   **Undo/Redo:**
    *   `u`: Undo the last change.
    *   `Ctrl` + `r`: Redo the change.

### 5. Searching and Replacing
Vim has powerful search tools built-in.

*   **Searching:**
    *   Type `/` in Normal mode followed by your search term (e.g., `/error`).
    *   Press `Enter` to highlighting matches.
    *   Press `n` to go to the **n**ext match.
    *   Press `N` to go to the previous match.
*   **Search and Replace:**
    *   The syntax is `:%s/old/new/g`.
    *   `:`: Enter command mode.
    *   `%`: Apply to the whole file (if omitted, it only applies to the current line).
    *   `s`: Substitute command.
    *   `/old/`: The word you are looking for.
    *   `/new/`: The word you want to replace it with.
    *   `/g`: Global flag (replace all occurrences on the line, not just the first one).

### 6. Configuration
You can customize Vim to look and behave how you want (change colors, enable line numbers, change font behavior).

*   **Vim:** Looks for a file named `.vimrc` in your home directory (`~/.vimrc`).
*   **Neovim:** Looks for a file named `init.vim` or `init.lua` in `~/.config/nvim/`.
*   **Example config lines:**
    *   `set number` (Shows line numbers on the left).
    *   `syntax on` (Enables code highlighting).
    *   `set ignorecase` (Makes search case-insensitive).

### 7. Plugins and Extensions
While Vim is powerful out of the box, **Plugins** allow you to turn it into a full-featured Integrated Development Environment (IDE) like VS Code.

*   **Plugin Managers:** You usually install a "manager" first, which downloads and updates plugins for you.
    *   *vim-plug:* The most popular simple manager for standard Vim.
    *   *Packer* or *Lazy.nvim:* Modern managers used specifically for Neovim (written in Lua).
*   **Popular Plugins:**
    *   *NERDTree / Nvim-Tree:* A sidebar file explorer.
    *   *Telescope:* A fuzzy finder (find files by typing parts of their names).
    *   *Treesitter:* Better syntax highlighting.
    *   *CoC / Lsp-Zero:* Auto-completion and code intelligence.
