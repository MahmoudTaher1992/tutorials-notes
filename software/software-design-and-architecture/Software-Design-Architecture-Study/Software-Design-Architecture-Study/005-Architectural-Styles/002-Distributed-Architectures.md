Here is a detailed breakdown of **Part V, Section B: Distributed Architectures**.

### What is Distributed Architecture?
In a monolithic architecture, all components (user interface, business logic, data access) live in a single application process on a single machine.

In a **Distributed Architecture**, the components of the software system are spread across multiple computers (nodes) connected by a network. They communicate and coordinate their actions by passing messages to one another to appear as a single coherent system.

---

### 1. Client-Server Architecture
This is the vast majority of web usage today. It is the fundamental pattern of distributed computing.

*   **The Concept:** The system is divided into two distinct roles.
    *   **Client (Requester):** Initiates communication (e.g., a Web Browser, a Mobile App). It handles the presentation logic.
    *   **Server (Provider):** Waits for requests, processes data, interacts with the database, and sends a response back.
*   **How it works:** A standard Request/Response cycle (usually via HTTP).
*   **Pros:** Centralized control of data; easier maintenance of the business logic (update the server, all clients get the behavior).
*   **Cons:** The Server is a Single Point of Failure (SPOF). If the server crashes, the app dies. It allows for "Vertical Scaling" (bigger server) but makes "Horizontal Scaling" (adding more servers) slightly more complex requiring load balancers.

### 2. Peer-to-Peer (P2P) architecture
*   **The Concept:** There is no distinction between a client and a server. Every node (computer) in the network is a "Peer." Every node can request a service and provide a service.
*   **How it works:** Nodes discover each other via a decentralized protocol.
*   **Examples:** BitTorrent (File Sharing), Blockchain (Bitcoin/Ethereum), Skype (original VoIP architecture).
*   **Pros:**
    *   **High Fault Tolerance:** If one node goes down, the network survives.
    *   **Scalability:** The more users (nodes) join, the more powerful the network becomes.
*   **Cons:** extremely difficult to manage. Security is hard (who do you trust?), and data consistency is very difficult to guarantee.

### 3. Service-Oriented Architecture (SOA)
*   **The Concept:** An architectural style where applications are built by combining large, reusable software services. This was the Enterprise standard before Microservices.
*   **Key Component: The Enterprise Service Bus (ESB):** In SOA, services communicate via a distinct, smart middleware pipe called an ESB. The ESB handles message routing, translation (e.g., converting XML to JSON), and orchestration.
*   **The Philosophy:** "Share as much as possible." One giant User Service is intended to be used by HR, Finance, and Payroll applications simultaneously.
*   **Pros:** Great for integrating legacy systems (e.g., making an ancient Mainframe talk to a modern web app).
*   **Cons:** The ESB becomes a massive bottleneck and a single point of failure. It is often considered "heavyweight" due to complex protocols primarily like SOAP/XML.

### 4. Microservices Architecture
*   **The Concept:** Building an application as a collection of small, independent services.
*   **The Philosophy:** "Share as little as possible." Decoupling is the main goal.
    *   **Bounded Context:** Each service handles **one** specific business domain (e.g., "Order Service," "Payment Service," "Shipping Service").
    *   **Own Data:** Ideally, each microservice has its *own* database. The Order Service cannot touch the Customer database directly; it must ask the Customer Service via API.
*   **Communication:** "Smart endpoints and dumb pipes." Unlike SOA (which has a smart ESB pipe), microservices use simple protocols (REST/HTTP, gRPC, or Message Queues).
*   **Pros:**
    *   **Tech Agnostic:** The Payment service can be written in Java, while the Notification service is written in Node.js.
    *   **Independent Scaling:** If you get a million orders, you only need to scale the "Order Service," not the "User Profile Service."
    *   **Resilience:** If the "Recommendation Service" crashes, the rest of Amazon still works; you just don't see recommendations.
*   **Cons:** **Complexity.** Instead of managing one application, you are now managing 50. Distributed transactions (keeping data in sync across services) are very hard.

### 5. Serverless Architecture (Function-as-a-Service / FaaS)
*   **The Concept:** You rely entirely on a cloud provider (AWS Lambda, Azure Functions, Google Cloud Functions). You do not manage the server OS, patching, or scaling.
*   **How it works:** You write a single function of code. It sleeps until an event triggers it (e.g., a file upload, an HTTP request). It wakes up, runs, and disappears.
*   **Pros:**
    *   **Cost:** You assume zero cost when the code isn't running.
    *   **Infinite Scaling:** The cloud provider automatically spawns thousands of instances if traffic spikes.
*   **Cons:**
    *   **Cold Starts:** Since the function turns off when not used, the first request after a break might take 2-3 seconds to load.
    *   **Vendor Lock-in:** Moving from AWS Lambda to Azure Functions often requires rewriting code.
    *   **Stateless:** You cannot keep data in memory; everything must be saved to a database immediately.

### 6. Space-Based Architecture (Tuple Space)
*   **The Concept:** Designed to solve the problem of high load interfering with the database. It tries to remove the database as the bottleneck.
*   **How it works:** It relies on an **In-Memory Data Grid**. Instead of writing to a disk database for every transaction, data is replicated across the RAM of many different active processing units. The database is usually updated asynchronously in the background.
*   **Analogy:** Imagine a team of accountants. instead of one filing cabinet (database) that everyone fights over, everyone has a photocopy of all the active files on their desk (in-memory). They sync up later.
*   **Use Cases:** High-volume trading systems, massive online gaming backends.
*   **Pros:** Extremely high performance and scalability.
*   **Cons:** difficult to test and debug, risk of data loss if the RAM grid fails before syncing to disk.

---

### Summary Comparison

| Style | Coupling | Scalability | Complexity | Primary Use Case |
| :--- | :--- | :--- | :--- | :--- |
| **Monolith** | High | Low (Vertical) | Low | Startups, Simple Apps |
| **SOA** | Medium | Medium | High | Enterprise Integration |
| **Microservices** | Low | High (Horizontal) | High | Complex, Large Systems |
| **Serverless** | Zero | Very High | Medium | Event-driven, Utility tasks |
| **Peer-to-Peer** | Low | High | High | Decentralized networks |
