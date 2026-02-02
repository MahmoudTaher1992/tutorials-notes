This section looks at **Resilience Patterns**, which are strategies used to keep your application running—or failing gracefully—when things go wrong (e.g., a database goes down, an external API relies on is slow, or the network is flaky).

In a Monolithic app, one error can often crash the whole server. In Microservices, a single failing service can cause a **"Cascading Failure,"** knocking out every service that depends on it. Resilience patterns prevent this chain reaction.

Here is the detailed explanation of **Part VI - E: Resilience Patterns**.

---

# 006-Microservices-Cloud-Native / 005-Resilience-Patterns

## 1. The Core Problem: Cascading Failures
Imagine **Service A** calls **Service B**.
1. **Service B** becomes unresponsive (database lock, network issue).
2. **Service A** keeps calling B and waiting for a response.
3. **Service A's** threads get stuck waiting. Eventually, **Service A** runs out of threads/resources.
4. **Service A** stops responding to the User.
5. The entire system is effectively down because of one minor issue in Service B.

**Resilience Patterns** solve this by isolating faults and providing backup plans.

---

## 2. Key Resilience Patterns

The standard library for implementing these in Spring Boot today is **Resilience4j** (which replaced the older Netflix Hystrix).

### A. Circuit Breaker
This is the most famous pattern. It functions exactly like an electrical circuit breaker in your house.

*   **Concept:**
    *   **CLOSED State (Normal):** Requests go through to the external service. If calls succeed, it stays closed.
    *   **OPEN State (Failure):** If the failure rate crosses a threshold (e.g., 50% of requests fail), the "circuit trips" (opens). **New requests are blocked immediately** without calling the external service. This prevents waiting and allows the failing service time to recover.
    *   **HALF-OPEN State (Testing):** After a set time, the circuit allows a few requests through to test if the service is back up. If they succeed, it pushes the state back to **Closed**. If they fail, it goes back to **Open**.

*   **Spring Boot Example (Resilience4j):**
    ```java
    @Service
    public class OrderService {

        @CircuitBreaker(name = "inventoryService", fallbackMethod = "fallbackInventory")
        public String checkInventory(String productId) {
            // Call external Inventory Microservice
            return restTemplate.getForObject("http://inventory-service/api/" + productId, String.class);
        }

        // This runs if the circuit is OPEN or the call throws an exception
        public String fallbackInventory(String productId, Throwable t) {
            return "Inventory unchecked - Defaulting to 'In Stock' (Cached)";
        }
    }
    ```

### B. Retry Pattern
Sometimes a failure is a temporary network "blip." The Retry pattern simply tries the request again before giving up.

*   **Configuration:** You define how many times to retry (e.g., 3 times) and how long to wait between attempts (backoff).
*   **Warning:** Do not use Retry on heavy loads. If Service B is overloaded, retrying will just DDOS attack your own service. Use **Exponential Backoff** (wait 1s, then 2s, then 4s).

*   **Spring Boot Example:**
    ```java
    @Retry(name = "inventoryService", fallbackMethod = "fallbackInventory")
    public String checkInventory(String productId) { ... }
    ```

### C. Bulkhead Pattern
This is named after the compartments in a ship (like the Titanic). If the hull is breached, water fills only one compartment, preventing the whole ship from sinking.

*   **Concept:** You allocate a specific number of threads or semaphores to specific services.
*   **Scenario:**
    *   You have 50 threads total.
    *   You allocate 10 threads to the "Image Processing Service" (which is slow).
    *   If Image Processing hangs, it consumes all 10 threads, but **the other 40 threads** are still free to handle "User Login" requests.
*   **Result:** A failure in one part of the app does not consume all resources of the application.

### D. Rate Limiter
This restricts the number of requests a user (or service) can make in a given time period.

*   **Use Case:** Preventing your service from being overwhelmed by a burst of traffic or a malicious bot.
*   **Mechanism:** "You can only make 10 requests per second." If the 11th request comes in, it is rejected immediately (HTTP 429 Too Many Requests).

### E. Time Limiter (Timeout)
Never wait forever.

*   **Concept:** Every network call must have a timeout. If the database usually takes 50ms, set a timeout to 2 seconds. If it takes longer, kill the connection and return an error/fallback.
*   **Why:** Frees up threads in the calling service.

---

## 3. The Fallback Mechanism
All the patterns above (Circuit Breaker, Retry, etc.) usually lead to a **Fallback** if they fail.

A Fallback is a graceful response to the user instead of an error page.
*   **Example 1 (E-commerce):** Recommendation service is down? **Fallback:** Show "Top Selling Items" (hardcoded/cached) instead of personalized suggestions.
*   **Example 2 (Banking):** Balance check service is down? **Fallback:** Show "Balance currently unavailable, please try later" (don't show $0.00).

---

## 4. Implementation in Spring Boot

To implement this, you usually add the **App AOP** and **Resilience4j** dependencies.

**`pom.xml` dependency:**
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-circuitbreaker-resilience4j</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-aop</artifactId>
</dependency>
```

**`application.yml` configuration:**
```yaml
resilience4j:
  circuitbreaker:
    instances:
      inventoryService:
        registerHealthIndicator: true
        slidingWindowSize: 10          # Check last 10 calls
        failureRateThreshold: 50       # Open circuit if 50% fail
        waitDurationInOpenState: 5s    # Wait 5s before trying again
  retry:
    instances:
      inventoryService:
        maxAttempts: 3
        waitDuration: 1s
```

## Summary Comparison

| Pattern | Problem Solved | Real World Analogy |
| :--- | :--- | :--- |
| **Circuit Breaker** | Prevent repeated calls to a dead service. | Electrical Fuse. |
| **Retry** | Handle temporary network blips. | "Can you repeat that?" |
| **Bulkhead** | Isolate resources so one failure doesn't crash all. | Watertight compartments on a ship. |
| **Rate Limiter** | Prevent overloading a service. | Bouncer at a club entry. |
| **Fallback** | Provide a default value when things fail. | Spare tire. |

In a Cloud-Native architecture, **Circuit Breakers** and **Timeouts** are considered mandatory requirements for production readiness.
