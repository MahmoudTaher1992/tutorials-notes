Here is a detailed explanation of **Part VII - A: Spring Boot Actuator**.

### **What is Spring Boot Actuator?**
In software development, writing the code is only half the battle. Once an application is deployed to production, you need to know if it is running, how it is performing, and if it has encountered any errors.

**Spring Boot Actuator** is a sub-project of Spring Boot that provides **production-ready features** to help you **monitor** and **manage** your application. Think of it as a "dashboard" or a "heartbeat monitor" for your app. It automatically exposes endpoints (URLs) that give you insight into the internal state of the running application without you having to write the code yourself.

---

### **1. Built-in Endpoints**
Actuator comes with many built-in endpoints. By default, they are exposed at the base path `/actuator`. Here are the most critical ones:

#### **A. /health**
*   **Purpose:** Shows the health status of the application.
*   **How it works:** It doesn't just say "I am alive." It checks the status of downstream dependencies. If your app uses a Database, Redis, and a Disk drive, `/health` will check if *all* of them are up.
*   **Output:**
    *   **Simple:** `{"status": "UP"}`
    *   **Detailed:** Shows details for every component (e.g., Database: UP, Disk Space: Free).
    *   *Essential for Load Balancers to know if they should send traffic to this instance.*

#### **B. /metrics**
*   **Purpose:** Provides numeric data about the application's performance.
*   **Examples:** Memory usage, CPU usage, number of HTTP requests, number of 404 errors, active threads, garbage collection stats.
*   **Usage:** You usually connect this endpoint to a monitoring tool (like Prometheus or Grafana) to visualize graphs of your application's performance over time.

#### **C. /env**
*   **Purpose:** Exposes properties from the Spring `Environment`.
*   **Details:** It shows system environment variables, command-line arguments, and properties loaded from `application.properties` or `application.yml`.
*   **Security Risk:** This is very sensitive as it might reveal internal IP addresses or configurations. It should be secured strictly.

#### **D. /info**
*   **Purpose:** Displays arbitrary application info.
*   **Usage:** You can configure this in your properties file. It is commonly used to display the **Git commit hash**, the **build version**, or the contact email for the team owning the service.
    ```yaml
    info:
      app:
        name: My Inventory Service
        version: 1.0.2
    ```

#### **E. /mappings**
*   **Purpose:** Displays a list of all `@RequestMapping` paths.
*   **Usage:** incredibly useful for debugging. If you are getting a `404 Not Found` and don't know why, you can check `/mappings` to see exactly what URLs Spring Boot has detected and configured.

---

### **2. Custom Actuator Endpoints**
Sometimes the built-in endpoints aren't enough. You might want to expose a specific business metric (e.g., "Current Inventory Count") or a management feature (e.g., "Clear Internal Cache").

*   **Annotation:** You use the `@Endpoint` annotation on a class.
*   **Operations:**
    *   `@ReadOperation`: Maps to HTTP **GET**. Used to retrieve data.
    *   `@WriteOperation`: Maps to HTTP **POST**. Used to change the state (e.g., toggle a feature flag).
    *   `@DeleteOperation`: Maps to HTTP **DELETE**.

**Example:**
```java
@Component
@Endpoint(id = "custom-feature")
public class CustomEndpoint {
    @ReadOperation
    public String getFeatureStatus() {
        return "Feature is ACTIVE";
    }
}
// Accessible via: GET /actuator/custom-feature
```

---

### **3. Health Checks (Liveness vs. Readiness)**
In modern cloud environments like **Kubernetes (K8s)**, "Health" is split into two concepts. Actuator supports both out of the box (often enabled via `management.endpoint.health.probes.enabled=true`).

#### **A. Liveness Probe (`/actuator/health/liveness`)**
*   **Question:** "Is the application internal state valid?"
*   **Scenario:** The app has entered a deadlock or an infinite loop. It is technically "running," but it is broken.
*   **Action:** If Liveness fails, the cloud platform (K8s) will **restart** the application container.

#### **B. Readiness Probe (`/actuator/health/readiness`)**
*   **Question:** "Is the application ready to accept traffic?"
*   **Scenario:** The app is starting up, migrating the database, or warming up a large cache. It is healthy, but not ready yet.
*   **Action:** If Readiness fails, the load balancer **stops sending traffic** to this instance until it passes, but it does *not* restart the app.

---

### **4. Security for Actuator Endpoints**
This is the most critical part of this module. **Actuator exposes internal details of your application.** If hackers access `/env` or `/heapdump`, they can steal passwords or user data.

#### **A. Default Exposure**
In recent versions of Spring Boot, only `/health` and `/info` are exposed over HTTP by default to be safe. You must explicitly enable others in `application.properties`:
```properties
# DANGEROUS: Expose everything
management.endpoints.web.exposure.include=* 
```

#### **B. Securing with Spring Security**
You should apply a security filter chain to the `/actuator/**` paths.
*   Require authentication (Login).
*   Require a specific Role (e.g., `ADMIN` or `OPS`).

```java
@Bean
public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    http.authorizeHttpRequests()
        .requestMatchers("/actuator/**").hasRole("ADMIN") // Only Admins
        .anyRequest().authenticated()
        .and().httpBasic();
    return http.build();
}
```

#### **C. Changing the Port/Path**
A common security practice used in large companies is to run Actuator on a completely different port and firewall it so only internal monitoring tools can reach it.

```properties
# Main app runs on 8080
server.port=8080 
# Actuator runs on 8081 (Internal only)
management.server.port=8081
```

### **Summary Table**

| Component | Function | Real World Use Case |
| :--- | :--- | :--- |
| **Endpoint** | Exposes data via HTTP/JMX | Checking system status via browser or API. |
| **Health** | Aggregates system status | Load balancer checks this to route traffic. |
| **Metrics** | Numeric data (CPU, RAM) | Sending data to Grafana to visualize memory leaks. |
| **Liveness/Readiness** | K8s specific probes | Telling Kubernetes when to restart a frozen pod. |
| **Security** | Protecting insights | Preventing hackers from seeing environment variables. |
