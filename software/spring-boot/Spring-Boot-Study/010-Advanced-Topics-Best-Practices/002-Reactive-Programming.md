Here is a detailed explanation of **Part X, Section B: Reactive Programming** from your study table.

This is one of the most significant shifts in the Spring ecosystem. It moves away from the traditional "Thread-per-Request" model (Blocking) to an "Event-Loop" model (Non-Blocking).

---

# 002 - Reactive Programming in Spring Boot

### 1. The Core Concept: Reactive vs. Imperative
To understand this, you must understand the problem with traditional Spring MVC (Imperative):
*   **The Blocking Model (Spring MVC):** When a request comes in, a thread is assigned to it. If that request calls a database or an external API, the thread **waits (blocks)** doing nothing but waiting for the response. If you have 200 threads and 201 concurrent requests, the 201st request waits in a queue.
*   **The Non-Blocking Model (Reactive):** Threads never wait. When a request needs data from a DB, the thread fires the request, registers a "callback" (what to do when data returns), and immediately goes to handle *another* request. When the DB data arrives, a thread picks it up and finishes the job. A small number of threads can handle thousands of concurrent requests.

### 2. Project Reactor: Mono & Flux
Spring Boot builds its reactive stack on **Project Reactor**. You cannot effectively write Reactive Spring code without understanding how data is represented here. Instead of returning a `String` or a `List<User>`, you return **Publishers**.

There are two main types of Publishers:

#### A. Mono `<T>`
*   Represents a stream of **0 or 1** item.
*   **Use case:** Fetching a user by ID, returning a generic HTTP 200 OK, or handling a single error.
*   **Analogy:** A promise that "I will eventually give you this one object (or fail)."

```java
// Logic: "I will eventually return a String, but not right now."
Mono<String> validMono = Mono.just("Hello World");
Mono<String> emptyMono = Mono.empty();
```

#### B. Flux `<T>`
*   Represents a stream of **0 to N** items.
*   **Use case:** Fetching a list of users, infinite event streams (like stock prices or chat messages).
*   **Analogy:** A conveyor belt that keeps dropping items until it's finished (or error/cancel).

```java
// Logic: "I will emit 1, then 2, then 3, then complete."
Flux<Integer> numerFlux = Flux.just(1, 2, 3);

// Logic: Turn a List into a Flux
Flux<User> userFlux = Flux.fromIterable(myUserList);
```

#### Important: The "Subscribe" Rule
In Reactive programming, **nothing happens until you subscribe.** If you write a database query keeping a `Flux` return type but nobody calls `.subscribe()` (or the browser doesn't request it), the query never actually runs. This is called **Lazy Evaluation**.

---

### 3. Spring WebFlux
WebFlux is the reactive alternative to Spring MVC.

*   **Server:** By default, it uses **Netty** (an asynchronous event-driven server) instead of Tomcat.
*   **Controllers:** You can write them in two styles.

#### Style A: Annotation-based (Looks like Spring MVC)
This is specific designed to be familiar to Spring developers.

```java
@RestController
@RequestMapping("/users")
public class UserReactiveController {

    @Autowired
    private UserRepository userRepository;

    // Note the return type is Flux<User>, not List<User>
    @GetMapping
    public Flux<User> getAllUsers() {
        return userRepository.findAll(); 
        // Logic: Returns the stream immediately. 
        // As the DB finds rows, they are streamed to the client.
    }

    // Note the return type is Mono<User>
    @GetMapping("/{id}")
    public Mono<User> getUser(@PathVariable String id) {
        return userRepository.findById(id);
    }
}
```

#### Style B: Functional Endpoints (Router Functions)
Ideally suited for functional programming styles, separating routing logic from handler logic.

```java
@Bean
public RouterFunction<ServerResponse> route(UserHandler handler) {
    return RouterFunctions
        .route(GET("/users"), handler::getAll)
        .andRoute(GET("/users/{id}"), handler::getOne);
}
```

---

### 4. R2DBC (Reactive Data Access)
**Problem:** If you use WebFlux (Non-blocking) but plain old JDBC or JPA (Blocking) to talk to the database, you ruin the application. The WebFlux thread will get blocked waiting for JDBC.

**Solution:** **R2DBC** (Reactive Relational Database Connectivity).
It is a specification for non-blocking database drivers.

*   **Supports:** PostgreSQL, MySQL, MSSQL, H2, etc.
*   **Repository Interface:** instead of `JpaRepository`, you use `ReactiveCrudRepository`.

```java
public interface UserRepository extends ReactiveCrudRepository<User, Long> {
    // Custom query returning a Flux
    @Query("SELECT * FROM users WHERE lastname = :lastname")
    Flux<User> findByLastname(String lastname);
}
```

> **Note:** R2DBC does not currently support the full feature set of Hibernate/JPA (like deeply complex caching, heavy lazy loading of relationships). It acts more like a reactive SQL mapper.

---

### 5. Why and When to use it?

**The Pros:**
1.  **Resource Efficiency:** Can handle massive concurrency with low memory/CPU usage.
2.  **Streaming:** Excellent for streaming data to clients (Server-Sent Events) without closing the connection.
3.  **Backpressure:** The consumer can tell the producer "I am overwhelmed, slow down," preventing system crashes under load.

**The Cons:**
1.  **Steep Learning Curve:** Thinking in streams (`map`, `flatMap`, `zip`, `merge`) is much harder than sequential imperative code.
2.  **Debugging:** Stack traces in reactive programming are notoriously difficult to read because the code "jumps" between threads.
3.  **No Thread Locals:** Traditional `ThreadLocal` storage (often used for security context/transactions) doesn't work easily.

**Summary Verdict:**
Use **Reactive (WebFlux)** for microservices that act as API Gateways, handle streaming data, or high-traffic apps where every millisecond of latency counts. Use **Spring MVC** for standard CRUD applications where code simplicity and maintainability are priority.
