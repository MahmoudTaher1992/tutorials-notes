This section focuses on **how systems talk to each other**. As an architect, choosing the right API style is one of your most critical decisions. Valid options usually include making trade-offs between meaningful coupling, performance, developer experience, and ease of correct usage.

Here is a detailed breakdown of **006-API-Design-and-System-Integration / 001-API-Design-Styles**.

---

### 1. REST (Representational State Transfer)
**The Standard / The Workhorse**

REST is the most common architectural style for public web APIs. It is resource-oriented, meaning it treats data (like Users, Orders, Products) as "Resources" accessed via standard URLs.

*   **Core Principles:**
    *   **Statelessness:** Every request must contain all the information necessary to understand the request. The server should not store "session state" between requests.
    *   **Standard HTTP Verbs:**
        *   `GET`: Retrieve data (Safe, Idempotent).
        *   `POST`: Create new data (Not Idempotent).
        *   `PUT`: Replace data entirely (Idempotent).
        *   `PATCH`: Partial update (Not always Idempotent).
        *   `DELETE`: Remove data (Idempotent).
    *   **Standard Status Codes:** Using 200 (OK), 404 (Not Found), 500 (Server Error) generally makes the API predictable.

*   **Richardson Maturity Model:**
    A way to grade how "RESTful" an API is:
    *   **Level 0:** The Swamp of POX (Plain Old XML/JSON). Using HTTP as a transport tunnel (usually just POSTing everywhere).
    *   **Level 1:** Resources. Using distinct URLs for different resources (e.g., `/users`, `/products`).
    *   **Level 2:** HTTP Verbs. Using GET, POST, DELETE correctly. (This is where most industry APIs sit).
    *   **Level 3:** Hypermedia Controls (**HATEOAS** - Hypermedia As The Engine Of Application State). The API response includes links telling the client what they can do next (e.g., checking out an order, cancelling it).

*   **Architectural Trade-offs:**
    *   *Pros:* Highly scalable, distinct separation of client/server, excellent caching support (via HTTP headers), universally understood.
    *   *Cons:* **Over-fetching** (getting more fields than you need) and **Under-fetching** (needing to make 5 different requests to distinct URLs just to render one screen).

### 2. GraphQL
**The Frontend Favorite / The "Query Language"**

Developed by Facebook, GraphQL shifts control from the server to the client. Instead of multiple endpoints, there is usually just **one single endpoint** (e.g., `/graphql`).

*   **Core Concepts:**
    *   **Schema & Types:** The backend defines strictly what data is available (The Schema).
    *   **Query (Read):** The client sends a JSON-like query asking specifically for what it needs.
        *   *Example:* "Give me the User's Name and their last 3 Order IDs, but nothing else."
    *   **Mutation (Write):** Used to modify data (create, update, delete).
    *   **Subscription:** Allows the client to listen for real-time updates via WebSockets.

*   **Architectural Trade-offs:**
    *   *Pros:* Solves Over-fetching/Under-fetching perfectly. Strong typing allows for auto-generating frontend code. Great for mobile apps where bandwidth is expensive. Detaches frontend release cycles from backend changes (frontends can ask for new data without backend code changes, assuming the data is in the schema).
    *   *Cons:* **Complexity.** Caching is difficult (you can't just use standard HTTP caching/CDNs because everything is a POST). Dealing with the "N+1 Problem" on the database side usually requires DataLoaders. Authorization logic can get messy.

### 3. gRPC (Google Remote Procedure Call)
**The High-Performance / Internal Communicator**

gRPC is a modern open-source framework that facilitates communication between services. It effectively calls a function on a different integration server as if it were a local function call.

*   **Core Concepts:**
    *   **Protocol Buffers (Protobuf):** Instead of JSON (text), gRPC uses a binary format. It is much smaller across the wire and much faster to serialize/deserialize.
    *   **HTTP/2:** gRPC runs on top of HTTP/2, allowing for multiplexing (sending multiple requests over one connection).
    *   **Streaming:**
        *   *Server Streaming:* Client sends one request, server sends back a stream of data.
        *   *Client Streaming:* Client uploads a stream of data, server sends one response.
        *   *Bi-directional:* Both talk at the same time.

*   **Architectural Trade-offs:**
    *   *Pros:* **Performance.** It is significantly faster and lighter than REST/JSON. Strong contract enforcement via `.proto` files ensures compatibility. Ideal for **Microservices-to-Microservices** internal communication.
    *   *Cons:* Harder to debug (you can't just read the binary network traffic). Browser support is weak (requires a proxy like gRPC-Web to work in frontend apps). High coupling between client and server (breaking changes in the file require recompiling clients).

### 4. Webhooks and Asynchronous Callbacks
**The "Don't Call Us, We'll Call You" Pattern**

API Styles usually assume the Client calls the Server. Webhooks invert this. They are used for **Event-Driven** interactions over HTTP.

*   **How it works:**
    1.  **Subscription:** Consumer A registers a "Callback URL" with Provider B (e.g., `https://api.myshop.com/payment-received`).
    2.  **Trigger:** An event happens in Provider B (e.g., a credit card charge succeeds).
    3.  **Action:** Provider B sends an HTTP POST request to Consumer A's URL with the data.

*   **Architectural Trade-offs:**
    *   *Pros:* Eliminates **Polling** (checking "is it done yet?" every 5 seconds). Reduces server load and latency close to real-time.
    *   *Cons:* **Reliability.** If the Consumer is down when the webhook fires, the data is lost (unless the Provider implements retry logic). **Security.** The Consumer needs to verify that the request actually came from the Provider (usually via HMAC signatures) and not a hacker.

---

### Summary Table for Decision Making

| Feature | REST | GraphQL | gRPC |
| :--- | :--- | :--- | :--- |
| **Data Format** | JSON (usually) | JSON | Binary (Protobuf) |
| **Contract** | Loose (OpenAPI/Swagger) | Strict (Schema) | Strict (.proto) |
| **Coupling** | Low | Medium | High |
| **Performance** | Good | Variable (depends on query complexity) | Excellent |
| **Browser Support** | Use Everywhere | Use Everywhere | Needs Proxy |
| **Best Use Case** | Public APIs, Simple Apps | Complex Frontends, Mobile Apps | Internal Microservices, Low Latency |
