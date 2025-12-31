Based on the roadmap you provided, **Part III, Section B: Built-in Core Modules** is a fundamental chapter. It covers the tools that come pre-installed with Node.js.

Unlike third-party packages (which you install via `npm`), these modules are available immediately. You simply import them to access the operating system, file system, and network.

Here is a detailed explanation of the four most critical core modules.

---

### 1. The File System Module (`fs`)
The `fs` module allows your Node.js application to interact with the computer’s hard drive. You use it to create, read, update, and delete files.

To use it:
```javascript
const fs = require('node:fs');
```

#### A. Synchronous vs. Asynchronous vs. Promise-based
This is the most important concept in this module. Node.js offers three ways to do the same thing:

1.  **Synchronous (`readFileSync`):** "Blocking." The code stops and waits for the file to be read before moving to the next line.
    *   *Use case:* Only acceptable in simple scripts or configuration loading at startup.
2.  **Asynchronous Callbacks (`readFile`):** "Non-blocking." The code moves on immediately, and a "callback function" runs when the file is finished reading.
    *   *Issue:* Can lead to "Callback Hell" (nested indentation).
3.  **Promise-based (`fs/promises`):** The modern standard. Non-blocking, but uses `await` or `.then()` for cleaner code.

**Example: Reading a file (The Modern Way)**
```javascript
const fs = require('node:fs/promises');

async function readMyFile() {
  try {
    const data = await fs.readFile('example.txt', 'utf-8');
    console.log(data);
  } catch (error) {
    console.error('File not found!');
  }
}
readMyFile();
```

#### B. Reading, Writing, and Appending
*   **Reading:** Loads the content of a file into memory.
*   **Writing (`writeFile`):** Creates a file or **overwrites** it if it already exists.
*   **Appending (`appendFile`):** Adds data to the end of an existing file (useful for logs).

#### C. Working with Directories
*   `fs.mkdir()`: Create a new folder (Make Directory).
*   `fs.readdir()`: List the files inside a folder.
*   `fs.rmdir()`: Delete a folder.

---

### 2. The Path Module (`path`)
The `path` module helps you manipulate file paths (locations) strings.

**Why do we need this?**
*   **Windows** uses backslashes for paths: `C:\Users\Project\file.txt`
*   **Mac/Linux** use forward slashes: `/Users/Project/file.txt`

If you manually type strings like `'folder/file.txt'`, your code might break on Windows. The `path` module handles this automatically.

To use it:
```javascript
const path = require('node:path');
```

#### A. `__dirname` and `__filename`
These are global variables available in CommonJS (standard Node.js files).
*   `__dirname`: The absolute path to the **folder** the current script is in.
*   `__filename`: The absolute path to the **file** itself.

#### B. Key Methods
*   **`path.join()`**: Joins path segments together using the correct separator for the OS.
    ```javascript
    // Instead of: 'logs/' + 'error.log'
    const fullPath = path.join(__dirname, 'logs', 'error.log');
    // Result on Mac: /Users/me/project/logs/error.log
    // Result on Win: C:\Users\me\project\logs\error.log
    ```
*   **`path.resolve()`**: Resolves a sequence of paths into an **absolute path** (from the root of the drive).
*   **`path.extname()`**: Gets the extension of a file (e.g., `.jpg`, `.txt`).

---

### 3. The Operating System Module (`os`)
The `os` module provides information about the computer's operating system. This is useful for building system utilities or optimizing app performance based on hardware.

To use it:
```javascript
const os = require('node:os');
```

#### Key Features:
*   **System Info:** `os.platform()` (e.g., 'win32', 'linux') and `os.arch()` (e.g., 'x64').
*   **Memory:** `os.totalmem()` (Total RAM) and `os.freemem()` (Available RAM). You can use this to warn if the server is running out of memory.
*   **CPUs:** `os.cpus()` returns an array of objects describing every CPU core.
    *   *Advanced Use:* When using the **Cluster** module later, you use `os.cpus().length` to decide how many worker processes to spawn (one per core).

---

### 4. The HTTP Module (`http`)
This is the module that allows Node.js to act as a Web Server. It can receive requests from browsers and send back responses (HTML, JSON, etc.).

*Note: In the real world, developers rarely use `http` directly. They use frameworks like **Express.js** (covered in Part IV). However, Express is built **on top** of this module, so understanding it is crucial.*

To use it:
```javascript
const http = require('node:http');
```

#### Creating a Basic Server
The `createServer` method takes a callback function with two arguments:
1.  **`req` (Request):** Details about what the user asked for (URL, method, headers).
2.  **`res` (Response):** Methods to send data back to the user.

```javascript
const server = http.createServer((req, res) => {
  // 1. Check the URL the user visited
  if (req.url === '/') {
    res.write('Welcome to the Home Page');
    res.end();
  } else if (req.url === '/api/courses') {
    res.write(JSON.stringify([1, 2, 3]));
    res.end();
  } else {
    res.write('404 Not Found');
    res.end();
  }
});

// 2. Listen on port 3000
server.listen(3000);
console.log('Listening on port 3000...');
```

### Summary of Part III-B
*   **`fs`**: Read/Write files. Use Promise-based methods (`fs/promises`) to keep the Event Loop running smoothly.
*   **`path`**: Construct file paths dynamically so your code works on Windows, Mac, and Linux.
*   **`os`**: check hardware stats (RAM/CPU) for performance tuning.
*   **`http`**: The low-level building block for creating web servers and APIs.
