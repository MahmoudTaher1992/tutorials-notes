Here is a detailed explanation of **Part IV: Edge Data & Storage Solutions - E. Queues**.

---

# 005-Queues (Asynchronous Workloads)

Cloudflare Queues is a global message queuing service. In distributed systems, you often need to perform tasks that don't need to happen *immediately* while the user is waiting. Queues allow you to send a message from one part of your application (the Producer) and process it later in another part (the Consumer).

Think of it like a restaurant kitchen: The waiter (Producer) takes an order and sticks the ticket on a rail (The Queue). The chefs (Consumers) grab tickets and cook the food when they are ready, rather than the waiter standing there screaming the order at the chef immediately.

### 1. Use Cases: Decoupling, Background Jobs, Batch Processing

The primary goal of a Queue is to **decouple** components. If Component A talks directly to Component B, and B crashes, A fails. If A puts a message in a Queue, and B crashes, the message stays safely in the Queue until B is fixed.

*   **Decoupling Services:**
    *   *Scenario:* User registration.
    *   *Without Queue:* User clicks "Sign Up" -> API saves to DB -> API sends Welcome Email -> API creates Stripe customer -> API returns "Success". (If the email server is down, the whole sign-up fails).
    *   *With Queue:* User clicks "Sign Up" -> API saves to DB -> API sends message to Queue -> API returns "Success". A separate worker processes the email later.
*   **Background Jobs:**
    *   Tasks that take too long for an HTTP response (e.g., resizing a 4K video, generating a PDF report, running an AI model analysis). You acknowledge the request instantly and do the heavy lifting in the background.
*   **Smoothing Traffic Spikes (Buffering):**
    *   If 10,000 users click a button at once, your database might crash. A Queue absorbs the 10,000 clicks instantly, and your Consumer Worker processes them at a steady, safe pace (e.g., 50 at a time).

### 2. Producer Workers and Consumer Workers

In Cloudflare, Queues work by connecting two Workers.

#### The Producer (Sending Messages)
The Producer is usually a standard `fetch` Worker (handling HTTP requests). It binds to the Queue and sends data to it.

**Configuration (`wrangler.toml`):**
```toml
[[queues.producers]]
 queue = "my-job-queue"
 binding = "MY_QUEUE"
```

**Code (Producer Worker):**
```typescript
export default {
  async fetch(request, env) {
    // 1. Receive data from user
    const data = await request.json();

    // 2. Send job to the queue (this is very fast)
    await env.MY_QUEUE.send({
      type: 'send_email',
      userId: data.userId,
      timestamp: Date.now()
    });

    // 3. Respond immediately
    return new Response("Job queued!");
  }
};
```

#### The Consumer (Processing Messages)
The Consumer is a Worker that doesn't necessarily listen for HTTP requests (`fetch`). Instead, it exports a `queue` handler. Cloudflare automatically wakes up this Worker when there are messages in the queue.

**Configuration (`wrangler.toml`):**
```toml
[[queues.consumers]]
  queue = "my-job-queue"
  max_batch_size = 10 # Process 10 messages at once
  max_batch_timeout = 5 # Or wait 5 seconds max
```

**Code (Consumer Worker):**
```typescript
export default {
  // distinct handler from 'fetch'
  async queue(batch, env) {
    // 'batch' contains a list of messages
    for (const message of batch.messages) {
      const job = message.body;
      console.log(`Processing job for user: ${job.userId}`);
      
      // Perform logic (e.g., send email via 3rd party)
      await sendWelcomeEmail(job.userId);

      // Explicitly acknowledge success (removes from queue)
      message.ack();
    }
  }
};
```

### 3. Message Retries and Dead-Letter Queues (DLQ)

One of the biggest advantages of Queues is **reliability**.

#### Retries
If your Consumer Worker throws an error (e.g., the external Email API is down), Cloudflare detects the failure.
*   By default, the message is returned to the queue to be tried again.
*   You can control this programmatically:
    ```typescript
    try {
      await externalApiCall();
      message.ack(); // Success
    } catch (err) {
      // Something went wrong, retry this specific message later
      message.retry({ delaySeconds: 10 }); 
    }
    ```

#### Dead-Letter Queues (DLQ)
What if a message creates a bug that *always* crashes the worker? It would retry infinitely, clogging your system and costing money.
A **Dead-Letter Queue** is a specific queue where "failed" messages go after they have been retried a maximum number of times (e.g., 5 times).
*   Developers monitor the DLQ to investigate bugs ("Why did this message fail 5 times?").
*   It prevents data loss (the message isn't deleted, just moved aside).

### 4. Batching for Efficient Processing

Cloudflare Queues is designed to reduce costs and improve efficiency via **Batching**.

If you have 1,000 messages in a queue, Cloudflare will not spin up the Consumer Worker 1,000 times. That would be expensive and slow (due to "cold starts").

Instead, it grabs a "batch" (e.g., 100 messages) and spins up the Worker **once**.

**Why is this powerful?**
Imagine you are logging analytics to a database (D1 or Supabase).
*   *Without Batching:* 100 database connections, 100 `INSERT` statements. (Slow, connection limits hit).
*   *With Batching:* The Consumer receives 100 messages. You create 1 database connection and send 1 big `INSERT` statement containing all 100 records.

**Example of Batch Handling:**
```typescript
async queue(batch, env) {
  // Prepare a bulk insert array
  const logsToInsert = batch.messages.map(msg => msg.body);

  // One database call for all messages
  await env.DB.prepare("INSERT INTO logs (...) VALUES ...")
              .bind(logsToInsert)
              .run();
              
  // If the DB write succeeds, all messages are auto-acked.
}
```

### Summary of Workflow
1.  **Client** makes a request.
2.  **Producer Worker** sends a JSON payload to the Queue and responds to Client.
3.  **Queue** holds the message (buffer).
4.  **Cloudflare** waits for a batch to fill up (or a timeout).
5.  **Consumer Worker** wakes up, receives the batch, and processes the data (DB writes, API calls).
6.  If successful, messages are deleted. If failed, they are retried or sent to a DLQ.
