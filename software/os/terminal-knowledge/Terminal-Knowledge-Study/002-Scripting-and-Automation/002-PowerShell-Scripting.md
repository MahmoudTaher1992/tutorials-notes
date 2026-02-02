Based on the Table of Contents you provided, here is a detailed explanation of **Part II, Section B: PowerShell Scripting**.

PowerShell is distinct from the traditional Linux shells (like Bash) discussed in Part II-A. While Bash is text-based, PowerShell is **Object-Oriented**. This section of your study plan focuses on automating administrative tasks using the PowerShell framework.

---

### 1. Introduction to PowerShell
*   **The Concept:** PowerShell is a cross-platform task automation solution made up of a command-line shell, a scripting language, and a configuration management framework.
*   **The Difference (Text vs. Objects):**
    *   **Bash:** When you pipe data in Bash (e.g., `ls | grep`), you are passing raw **text**. You have to manipulate string characters to get specific data.
    *   **PowerShell:** When you pipe data, you are passing **.NET Objects**. An object contains structured data (properties) and things it can do (methods). You don't parse text; you ask for properties (like "Name" or "ID").
*   **Cross-Platform:** Originally Windows-only, "PowerShell Core" (pwsh) now runs on Linux and macOS.

### 2. Cmdlets (Command-lets)
Cmdlets are the built-in commands in PowerShell. They follow a strict naming convention: **Verb-Noun**.
*   **Verb-Noun Syntax:** This makes commands easy to guess and read.
    *   `Get-Service` (Gets a list of services)
    *   `Stop-Process` (Stops a running program)
    *   `New-Item` (Creates a file or folder)
*   **Discovery Tools:**
    *   `Get-Command`: Lists all available commands. (e.g., `Get-Command *Network*` finds network-related tools).
    *   `Get-Help`: The manual system. (e.g., `Get-Help Get-Service -Examples` shows you exactly how to use the command).

### 3. Variables and Data Types
PowerShell variables always start with a dollar sign `$`.
*   **Loosely Typed:** You don't *have* to declare the type.
    *   `$myNumber = 10` (PowerShell guesses this is an Integer).
*   **Strongly Typed:** You can force a type if you want strictness.
    *   `[string]$myName = "John"`
    *   `[int]$myAge = 30`
*   **Special Variables:**
    *   `$_` (or `$PSItem`): Represents the "current object" inside a pipeline loop.
    *   `$null`: Represents an empty logical value.

### 4. Pipelines and Objects
This is the most powerful feature of PowerShell.
*   **Passing Objects:** Instead of passing text, you pass the whole object.
*   **Select-Object:** Used to pick specific properties you want to see.
    *   `Get-Process | Select-Object Name, Id, CPU`
*   **Where-Object:** Used to filter based on object properties.
    *   `Get-Service | Where-Object Status -eq 'Running'`
*   **Sort-Object:** Sorts the objects.
    *   `Get-Process | Sort-Object CPU -Descending`

### 5. Conditional Logic
PowerShell uses comparison operators that look different from other languages (it uses hyphens, not symbols like `==` or `>`).
*   **Operators:**
    *   `-eq` (Equal)
    *   `-ne` (Not Equal)
    *   `-gt` (Greater Than)
    *   `-lt` (Less Than)
    *   `-like` (Wildcard matching, e.g., `"Hello" -like "*ell*"`)
*   **Syntax:**
    ```powershell
    $Score = 85
    if ($Score -gt 90) {
        Write-Host "Outstanding!"
    } elseif ($Score -gt 75) {
        Write-Host "Good Job"
    } else {
        Write-Host "Try Again"
    }
    ```

### 6. Loops
Automation requires doing the same thing to many items (e.g., "create a user account for every name in this list").
*   **ForEach-Object:** Used specifically in the pipeline.
    *   `1..10 | ForEach-Object { Write-Host "Counting $_" }`
*   **ForEach:** The standard scripting loop.
    ```powershell
    $servers = @("Server1", "Server2", "Server3")
    foreach ($s in $servers) {
        Ping $s
    }
    ```
*   **While / Do-While:** Runs as long as a condition is true.

### 7. Functions
Functions allow you to save a block of code and reuse it later, keeping your scripts clean.
*   **Basic Function:**
    ```powershell
    function Say-Hello {
        param($Name)
        Write-Host "Hello, $Name"
    }
    ```
*   **Advanced Functions:** By adding `[CmdletBinding()]`, your custom function acts exactly like a native PowerShell command (supporting verbose logging, error handling parameters, and pipeline input).

### 8. Modules
Modules are packages that contain groups of functions and cmdlets.
*   **The PSGallery:** An online repository (like Python's pip or Node's npm) where people share PowerShell tools.
*   **Key Commands:**
    *   `Find-ModuleAWS*` (Search on the internet for AWS modules)
    *   `Install-Module Name` (Download and install)
    *   `Import-Module Name` (Load the commands into your current session so you can use them).

---

### Summary Table: Bash vs PowerShell

| Feature | Bash (Linux) | PowerShell |
| :--- | :--- | :--- |
| **Data Flow** | Text Streams | .NET Objects |
| **Command Style** | Short abbreviations (`ls`, `cp`) | Verb-Noun (`Get-ChildItem`, `Copy-Item`) |
| **Comparison** | `==`, `!=`, `-eq` | `-eq`, `-ne`, `-gt` |
| **Variables** | `name="John"`, call with `$name` | `$name="John"`, call with `$name` |
