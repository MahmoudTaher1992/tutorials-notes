Here is a detailed explanation of **Part VI, Section B: Data-Centric Architectural Patterns**.

While many architectural patterns focus on how components *communicate* (like Layered Architecture or Microservices), **Data-Centric patterns** focus on how data is **stored, accessed, synchronized, and managed**. In these architectures, the data is the primary design consideration, often dictating the structure of the rest of the system.

Here is the breakdown of the four specific concepts listed in your Table of Contents.

---

### 1. CQRS (Command Query Responsibility Segregation)

**The Core Concept**
In traditional architectures (like CRUD), the same data model is used to update the database and to read from it. CQRS breaks this by splitting the application into two distinct parts:
1.  **Command Side (Write):** Handles `Create`, `Update`, `Delete`. Its job is to enforce business rules and ensure data integrity.
2.  **Query Side (Read):** Handles `Read`. Its job is to fetch data as fast as possible.

**How it Works**
*   **The Command Model:** Optimized for writing. It often uses a highly normalized database (to prevent data duplication and errors). It processes "Commands" (e.g., `BookFlightCommand`).
*   **The Query Model:** Optimized for reading. It often uses "Materialized Views" or denormalized tables. It might look exactly like the UI requires (e.g., a JSON blob ready to be sent to the frontend).
*   **Synchronization:** When a command changes data, an event is usually fired to update the Query database asynchronously.

**Why use it?**
*   **Scaling:** In most systems, reads happen 100x more than writes. CQRS allows you to scale the Read database (add more replicas) independently of the Write database.
*   **Performance:** The Read database doesn’t need complex joins; the data is pre-assembled.
*   **Security:** You can create different security permissions for writing vs. reading.

**Trade-off:** It introduces **Eventual Consistency**. Since the Read DB is updated after the Write DB, there is a tiny fraction of time where the user reads old data.

---

### 2. Event Sourcing

**The Core Concept**
In traditional databases, we store the **current state** of an object. If a user changes their address, we overwrite the old address.
In **Event Sourcing**, we do not store the current state. Instead, we store a sequence of **Events** (immutable facts) that have happened over time.

**How it Works**
*   **The Event Store:** This is an append-only database. You never delete or update rows; you only add new ones.
*   **Example (Banking):**
    *   *Traditional:* Table shows `Account Balance: $100`.
    *   *Event Sourcing:* Table shows:
        1.  `AccountCreated` (Balance: $0)
        2.  `MoneyDeposited` (+$50)
        3.  `MoneyDeposited` (+$70)
        4.  `MoneyWithdrawn` (-$20)
*   **Replaying State:** To know the current balance, the system calculates (replays) all events from the beginning ($0 + 50 + 70 - 20 = $100).

**Relationship with CQRS**
Event Sourcing is almost always paired with CQRS. The Event Store is the "Write Side." The "Read Side" listens to the events and maintains a current-state snapshot so users don't have to wait for the system to recalculate the balance every time they load the page.

**Why use it?**
*   **Audit Trail:** You have a perfect history of *everything* that ever happened.
*   **Time Travel:** You can reconstruct the state of the system exactly as it was last Tuesday at 2:00 PM.
*   **Business Intent:** Storing "AddressChanged" is more meaningful than just seeing a different string in a column.

---

### 3. Blackboard Pattern

**The Core Concept**
This pattern is distinct from standard business web apps. It is used for solving non-deterministic, complex problems where no single algorithm can solve the whole thing (e.g., Speech Recognition, AI Planning, Signal Processing).

It relies on a shared memory space (the Blackboard) where different specialized modules (Knowledge Sources) contribute to the solution iteratively.

**The Components**
1.  **The Blackboard:** A structured global memory containing objects from the solution space (raw data, partial solutions, hypothesis).
2.  **Knowledge Sources (The Experts):** Independent modules that are specialists in one specific part of the problem. They watch the blackboard.
3.  **The Control Component:** It monitors the blackboard and decides which Knowledge Source gets to execute next based on the state of the data.

**The Metaphor**
Imagine a group of cryptic crossword puzzle solvers standing around a large blackboard.
*   Solver A sees a clue they understand and writes a word.
*   Solver B sees that word, which helps them figure out a vertical word, and writes that down.
*   This continues until the puzzle is solved. No solver knows how to solve the whole puzzle, but together via the Blackboard, they do.

---

### 4. Master-Slave & Master-Master Replication

These patterns address **Availability** and **Redundancy** of data across multiple servers. (Note: Modern terminology often uses *Primary-Replica* or *Leader-Follower*).

#### A. Master-Slave (Primary-Replica) Replication
*   **How it works:** One server is the **Master**. All data writes (Insert/Update/Delete) *must* go to the Master. The Master then copies (replicates) changes to the **Slaves**.
*   **Reads:** Applications can read data from the Slaves.
*   **Use Case:** Ideal for **Read-Heavy systems** (like Wordpress or a News site). You can add 10 Slave servers to handle millions of readers, while the single Master handles the occasional article edit.
*   **Downside:** If the Master fails, no one can write data until a new Master is elected.

#### B. Master-Master (Multi-Primary) Replication
*   **How it works:** Two or more servers act as Masters. You can write data to *any* of them. They synchronize changes between each other bi-directionally.
*   **Use Case:** High Availability for **Writes**. If one Master goes down, you can still write to the other one.
*   **Downside:** **Conflict Resolution.** If User A updates a record on Master 1, and User B updates the *same* record on Master 2 at the exact same time, the databases will conflict. The system needs complex logic to decide which update "wins."

### Summary Comparison Table

| Pattern | Primary Focus | Best Use Case |
| :--- | :--- | :--- |
| **CQRS** | Separation of Concerns | High-traffic apps with complex business logic and different read/write loads. |
| **Event Sourcing** | Reliability & History | Financial ledgers, complex ordering systems requiring audit trails. |
| **Blackboard** | Collaborative Problem Solving | AI, Speech Recognition, complex data interpretation. |
| **Replication** | Availability & Scaling | Scaling databases to handle more traffic or survive server crashes. |
