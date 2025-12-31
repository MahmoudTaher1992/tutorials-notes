Here is a detailed explanation of **Part VII - B. Streams**.

---

# 007-Advanced-Topics-and-Performance / 002-Streams

## What are Streams?

In Node.js, streams are a fundamental concept used to handle data. They are collections of data that might not be available all at once and don't have to fit in memory.

**The Analogy:**
*   **Without Streams (Buffering):** Imagine you want to watch a movie. You download the entire 4GB file to your hard drive. You wait until the download reaches 100%, and only then do you hit "Play."
*   **With Streams:** You use Netflix or YouTube. You hit "Play," and the video starts immediately. Your computer downloads small chunks of the movie, plays them, and discards them to make room for the next chunks.

In technical terms, streams allow you to process data **piece by piece** (chunk by chunk) as it arrives, rather than waiting for the entire payload to load into the computer's RAM.

---

## 1. The Power of Streaming Large Datasets

Streams are essential in Node.js for two main reasons: **Memory Efficiency** and **Time Efficiency**.

### The Problem: Loading all at once
If you try to read a **10 GB file** using `fs.readFile()` on a server with only **4 GB of RAM**, your application will crash with a "Heap Out of Memory" error. Node.js tries to fit the whole file into variables in memory, which is impossible.

### The Solution: Streaming
When you use a stream, Node.js reads the file in small chunks (default is 64KB).
1.  It reads 64KB.
2.  It sends that chunk to the destination (e.g., the user's browser).
3.  It garbage collects (deletes) that chunk from RAM.
4.  It repeats the process.

**Result:** You can process a 10 GB file (or even an infinite stream of data) using only a few megabytes of RAM.

---

## 2. Types of Streams

There are four fundamental types of streams in Node.js:

### A. Readable Streams
A stream you can **read data from**.
*   **Examples:** Reading a file (`fs.createReadStream`), the HTTP request object (`req`) on the server, `process.stdin`.
*   **How it works:** It emits a `data` event whenever a new chunk of data is ready to be consumed.

### B. Writable Streams
A stream you can **write data to**.
*   **Examples:** Writing to a file (`fs.createWriteStream`), the HTTP response object (`res`) sent back to the client, `process.stdout`.
*   **How it works:** You push data into it, and the stream handles writing it to the destination.

### C. Duplex Streams
A stream that is both **Readable and Writable**.
*   **Examples:** TCP Sockets (net module).
*   **How it works:** You can write data to it (send a message) and read data from it (receive a message).

### D. Transform Streams
A special type of Duplex stream where the output is related to the input. It **changes** the data as it flows through.
*   **Examples:** Compression (zlib), Encryption/Decryption, or parsing CSV to JSON on the fly.
*   **How it works:** Data goes in $\to$ Transformation Logic $\to$ Data comes out.

---

## 3. Using Streams in Practice

### The Old Way: Events (`.on`)
Streams are instances of `EventEmitter`. You can listen to events manually.

```javascript
const fs = require('fs');

const readable = fs.createReadStream('./large-file.txt');

// Event: 'data' runs every time a chunk (usually 64kb) is read
readable.on('data', (chunk) => {
    console.log(`Received ${chunk.length} bytes of data.`);
});

// Event: 'end' runs when there is no more data
readable.on('end', () => {
    console.log('Finished reading file.');
});
```

### The Standard Way: `.pipe()`
The `.pipe()` method is the most common way to use streams. It takes a **Readable** stream and connects it directly to a **Writable** stream. It manages the flow of data automatically so the destination doesn't get overwhelmed (a concept called **Backpressure**).

**Example: Copying a large file efficiently**
```javascript
const fs = require('fs');

const readStream = fs.createReadStream('./source.mp4');
const writeStream = fs.createWriteStream('./destination.mp4');

// Read from source -> Pipe directly to destination
readStream.pipe(writeStream);
```

**Example: Streaming a file to an HTTP Client (A Video Server)**
```javascript
const http = require('http');
const fs = require('fs');

const server = http.createServer((req, res) => {
    const stream = fs.createReadStream('./movie.mp4');
    
    // Instead of fs.readFile (which loads all to RAM), use pipe
    // The browser receives the video instantly and plays while downloading
    stream.pipe(res); 
});

server.listen(3000);
```

### The Modern/Safe Way: `stream.pipeline()`
While `.pipe()` is great, error handling can be tricky. If the read stream fails, the write stream might not close properly, leading to memory leaks.

Node.js introduced `stream.pipeline` to handle cleanup and errors automatically.

```javascript
const { pipeline } = require('stream');
const fs = require('fs');
const zlib = require('zlib');

// 1. Source (Readable)
const source = fs.createReadStream('input.txt');
// 2. Transform (Compression)
const gzip = zlib.createGzip();
// 3. Destination (Writable)
const destination = fs.createWriteStream('input.txt.gz');

pipeline(
  source,
  gzip,
  destination,
  (err) => {
    if (err) {
      console.error('Pipeline failed.', err);
    } else {
      console.log('Pipeline succeeded. File compressed.');
    }
  }
);
```

### Modern Syntax: Async Iterators
In recent versions of Node.js, streams work with `for await...of` loops, which makes the code look synchronous and cleaner.

```javascript
const fs = require('fs');

async function logChunks(readable) {
  for await (const chunk of readable) {
    console.log('>>> Data chunk received:', chunk.toString());
  }
  console.log('Stream ended');
}

const readable = fs.createReadStream('./hello.txt');
logChunks(readable);
```

## Summary
*   **Streams** allow you to process data piece-by-piece.
*   They solve **memory issues** (processing files larger than RAM) and **latency issues** (processing starts immediately).
*   **Pipe** connects a Readable source to a Writable destination.
*   **Pipeline** is preferred for production as it handles error cleanup better.
