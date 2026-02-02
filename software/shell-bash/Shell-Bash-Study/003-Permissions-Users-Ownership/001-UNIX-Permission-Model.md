Here is a comprehensive explanation of **The UNIX Permission Model**. This is one of the most fundamental concepts in Linux/Unix operating systems because the entire security model relies on it.

Unlike Windows, which has a complex Access Control List (ACL) system, traditional Unix permissions are elegant, simple, and strict.

---

# 001-UNIX-Permission-Model

## 1. The Core Concept: "Everything is a File"
In Linux, almost everything is treated as a file (documents, directories, hardware devices). The OS needs a way to decide: **Who is allowed to do what to this file?**

To solve this, Unix divides the world into three specific **Identities** and three specific **Actions**.

## 2. The "Who" (Identities)
Every file and directory in Linux has three distinct sets of permissions assigned to three different categories of people:

1.  **User (u):** The **Owner**. Usually the person who created the file. This person has the most control.
2.  **Group (g):** A defined set of users. For example, a "developers" group might need access to edit a project file, but the "marketing" group shouldn't.
3.  **Others (o):**  **The World**. Everyone else on the system who is not the Owner and not in the Group. This is effectively "the public."

## 3. The "What" (Actions)
There are only three things you can arguably do to a file. These actions are represented by letters:

1.  **Read (`r`)**
2.  **Write (`w`)**
3.  **Execute (`x`)**

### Important Distinction: Files vs. Directories
These permissions behave differently depending on whether the target is a simple file (like `text.txt`) or a directory (like `/home/user`).

| Permission | Effect on a **FILE** | Effect on a **DIRECTORY** |
| :--- | :--- | :--- |
| **Read (r)** | You can open the file and see its content (e.g., `cat file.txt`). | You can **list** the names of files inside the folder (e.g., `ls folder`). |
| **Write (w)** | You can modify, edit, or delete the file's contents. | You can **create, delete, or rename** files inside this folder. |
| **Execute (x)** | You can run the file as a program (e.g., a script or application). | You can **enter** (traverse) the folder (e.g., `cd folder`) and access file metadata. |

> **Note on Directory Permissions:** To actually copy files out of a folder or view them, you generally need both **Read** (to see the filenames) and **Execute** (to enter the folder context).

## 4. Reading Permissions: Anatomy of `ls -l`
When you type `ls -l` in a terminal, you see a seemingly cryptic string of characters on the left, like this:

`drwxr-xr--`

Let's break that string down into 4 parts:

### Part 1: File Type (The first character)
*   `-` : It is a regular file.
*   `d` : It is a directory.
*   `l` : It is a symbolic link (shortcut).

### Part 2: The Owner's Permissions (The next 3 characters)
*   **`rwx`**: The **User (Owner)** can Read, Write, and Execute.

### Part 3: The Group's Permissions (The next 3 characters)
*   **`r-x`**: The **Group** can Read and Execute, but **cannot Write** (indicated by the dash `-`).

### Part 4: The Others' Permissions (The last 3 characters)
*   **`r--`**: **Others** can only Read. They cannot Write or Execute.

---

## 5. The Notation Systems: Symbolic vs. Octal
You will see permissions written in two ways. You need to know both.

### A. Symbolic Notation
This uses the letters `u`, `g`, `o` (identities) and `r`, `w`, `x` (permissions).
*   *Example:* `rwxr-xr-x`

### B. Octal (Numeric) Notation
Pro permissions users and sysadmins often use numbers because it's faster to type. The system assigns a numeric value to each permission:

*   **Read (r) = 4**
*   **Write (w) = 2**
*   **Execute (x) = 1**
*   **No Permission (-) = 0**

To get the permission number for a user, you strictly add the numbers together.

**Common Examples:**

1.  **Full Control (`rwx`):**
    $4 (\text{read}) + 2 (\text{write}) + 1 (\text{execute}) = \mathbf{7}$

2.  **Read and Execute (`r-x`):**
    $4 (\text{read}) + 0 + 1 (\text{execute}) = \mathbf{5}$

3.  **Read Only (`r--`):**
    $4 (\text{read}) + 0 + 0 = \mathbf{4}$

### Putting it together (The "777" or "755" notation)
Since there are three groups (User, Group, Other), there are three numbers.

**Example: `chmod 755 filename`**
*   **7** (1st digit, User): $4+2+1$. The Owner has full 100% control.
*   **5** (2nd digit, Group): $4+0+1$. The Group can Read and Execute (Run/Access), but not edit.
*   **5** (3rd digit, Other): $4+0+1$. The Public can Read and Execute, but not edit.

**Example: `chmod 600 private_key.pem`**
*   **6** (User): $4+2$. Owner can Read and Write.
*   **0** (Group): No permissions.
*   **0** (Other): No permissions.
*   *Result:* Only the owner can see or edit this file. It is invisible to everyone else.

## 6. Summary Visual

Imagine a file listed as:
`-rwxrw-r-- user1devs`

1.  **`-`**: It's a file.
2.  **`rwx` (User):** `user1` can Read, Write, and Execute it. (Octal: 7)
3.  **`rw-` (Group):** Anyone in the `devs` group can Read and Write, but not Execute. (Octal: 6)
4.  **`r--` (Other):** Anyone else can only Read it. (Octal: 4)

**The Octal code for this file is `764`.**
