Based on Part II, Section C of your roadmap, here is a detailed explanation of the **Event Emitter Pattern**.

---

# 003 - The Event Emitter Pattern

The Event Emitter pattern lies at the very heart of Node.js. While you often hear that Node.js is "Event-Driven," the **Event Emitter** is the specific mechanism that makes that possible.

Almost all built-in Node.js modules (like HTTP, FS, Streams) inherit from this pattern.

## 1. The Observer Pattern in Node.js
Computer science defines the **Observer Pattern** as a design pattern where an object (the **Subject**) maintains a list of dependents (called **Observers**) and notifies them automatically of any state changes, usually by calling one of their methods.

In Node.js:
*   **The Subject** is the **Event Emitter**.
*   **The Observers** are the **Event Listeners** (callbacks).

**Why use it?**
It allows for **Decoupling**.
Imagine a Pizza Shop. The chef (Emitter) finishes a pizza. Without this pattern, the chef would have to manually call `waiter.serve()`, `cashier.printReceipt()`, and `app.sendNotification()`. The chef code becomes messy and tightly coupled to front-of-house tasks.

With the Event Emitter pattern, the chef simply yells (emits) **"Pizza Ready!"**. The waiter, cashier, and app represent listeners waiting for that specific shout to do their own jobs. The chef doesn't care who is listening.

## 2. Using the `events` Module
Node.js includes a built-in core module called `events`. You do not need to install it with npm.

```javascript
// Importing the class
const EventEmitter = require('events');

// Creating an instance
const myEmitter = new EventEmitter();
```

## 3. Key Methods: `on`, `emit`, and `once`

There are three primary methods you will use 90% of the time.

### A. `emitter.on(eventName, listener)`
This creates a **listener** (a subscription). It tells Node.js: "Wait for this specific event to happen, and when it does, run this function."

### B. `emitter.emit(eventName, ...args)`
This **triggers** the event. It signals that something happened and passes any data arguments to the listeners.

### C. `emitter.once(eventName, listener)`
This behaves exactly like `.on()`, but after the event triggers **one time**, the listener is automatically removed.

### Code Example: A Chat Room Simulation
```javascript
const EventEmitter = require('events');
const chatRoom = new EventEmitter();

// 1. Setup Listeners (The "on" method)
chatRoom.on('message', (user, text) => {
    console.log(`Received message from ${user}: ${text}`);
});

chatRoom.on('userJoined', (username) => {
    console.log(`>>> ${username} has joined the chat!`);
});

// 2. Setup a One-time Listener (The "once" method)
// This will only run for the VERY FIRST user to join
chatRoom.once('userJoined', () => {
    console.log("Welcome to the first user of the day!");
});

// 3. Trigger Events (The "emit" method)

// 'userJoined' emits
chatRoom.emit('userJoined', 'Alice'); 
// Output: 
// Welcome to the first user of the day!
// >>> Alice has joined the chat!

chatRoom.emit('userJoined', 'Bob');
// Output:
// >>> Bob has joined the chat!
// (Note: The "once" listener did not fire for Bob)

// 'message' emits
chatRoom.emit('message', 'Alice', 'Hello everyone!');
// Output: Received message from Alice: Hello everyone!
```

---

## 4. Implementing Custom Event-Driven Classes
In real-world Node.js development, you rarely use the bare `const myEmitter = new EventEmitter()` object directly. Instead, you create classes that **extend** (inherit from) the EventEmitter class.

This allows your custom objects (like a `Server`, a `DatabaseConnection`, or a `TicketSystem`) to emit events themselves.

### Example: A Timer Class
Let's build a simple countdown timer that tells us when it ticks and when it finishes.

```javascript
const EventEmitter = require('events');

// Inherit capabilities from EventEmitter
class Countdown extends EventEmitter {
    constructor(seconds) {
        super(); // Must call super() to initialize EventEmitter
        this.seconds = seconds;
    }

    start() {
        console.log(`Timer started for ${this.seconds} seconds...`);
        
        const timer = setInterval(() => {
            this.seconds--;
            
            // Emit a 'tick' event every second, pass remaining time
            this.emit('tick', this.seconds);

            if (this.seconds === 0) {
                // Emit 'end' when finished
                this.emit('end');
                clearInterval(timer);
            }
        }, 1000);
    }
}

// --- Usage ---

const myTimer = new Countdown(3);

// Attach listeners BEFORE starting
myTimer.on('tick', (timeLeft) => {
    console.log(`Ticking... ${timeLeft}s left`);
});

myTimer.on('end', () => {
    console.log('BOOM! Timer finished.');
});

// Start the logic
myTimer.start();
```

## 5. Important Gotchas

### Synchronous Execution
A common misconception is that events are always asynchronous. By default, **`EventEmitter` calls all listeners synchronously** in the order they were registered.

```javascript
myEmitter.on('event', () => console.log('A'));
myEmitter.on('event', () => console.log('B'));
myEmitter.emit('event');
console.log('C');

// Output:
// A
// B
// C
// (If it were async, C would likely print first)
```

### Handling Errors
This is critical. If an EventEmitter emits an event specifically named `'error'` and **no listener** is attached to handle it, Node.js will throw an Unhandled Exception and **crash your application**.

```javascript
const myEmitter = new EventEmitter();

// application will crash here:
// myEmitter.emit('error', new Error('Something broke!'));

// Correct way: always listen for errors
myEmitter.on('error', (err) => {
    console.error('Caught an error:', err.message);
});

myEmitter.emit('error', new Error('Something broke!')); // Handled safely
```

### Memory Leaks
If you keep adding listeners (using `.on()`) inside a loop or a recurring function without removing them, you will create a memory leak. Node.js warns you if you add more than 10 listeners to a single event (default limit).

You can remove listeners using:
*   `emitter.off(eventName, listenerFunction)`
*   `emitter.removeListener(eventName, listenerFunction)`
*   `emitter.removeAllListeners(eventName)`

---

## Summary Table

| Method | Description |
| :--- | :--- |
| `on(event, listener)` | Adds a listener to the end of the listeners array. |
| `emit(event, data)` | Synchronously calls each listener registered for the event. |
| `once(event, listener)` | Adds a one-time listener. Removes itself after running. |
| `off(event, listener)` | Removes a specific listener. |
| `listenerCount(event)` | Returns the number of listeners listening to that event. |
