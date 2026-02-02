Based on **Part VII, Section B** of your Table of Contents, here is a detailed explanation of **Metrics and Monitoring** in Spring Boot.

This section moves beyond simply checking if an application is "up" (Health Checks) and focuses on understanding **how** the application is performing over time (trends, latencies, error rates, and business statistics).

---

# 007-Monitoring-Management / 002-Metrics-And-Monitoring

In a production environment, you cannot debug issues by staring at console logs. You need numerical data to visualize trends. Spring Boot solves this using a library called **Micrometer** to collect data and expose it to monitoring systems.

## 1. The Core Concept: Micrometer
Think of **Micrometer** as "SLF4J but for metrics."
*   **SLF4J** allows you to write log statements without caring if the backend is Logback, Log4j2, or JUL.
*   **Micrometer** allows you to record metrics without caring if the monitoring system is Prometheus, Datadog, New Relic, or Dynatrace.

Spring Boot auto-configures Micrometer for you. You code against the Micrometer interface, and Spring exports the data to whichever system you choose via configuration.

## 2. Default Metrics (Out-of-the-Box)
As soon as you add the `spring-boot-starter-actuator` dependency, Spring Boot automatically begins recording critical system metrics. You don't need to write any code for these:

*   **JVM Metrics:** Memory usage (Heap/Non-heap), Garbage Collection pauses, Thread counts.
*   **System Metrics:** CPU usage, File descriptor usage, Uptime.
*   **Web MVC Metrics:** Request duration, generic HTTP 404/500 count (tagged by URI).
*   **Data Source Metrics:** HikariCP connection pool usage (active connections, idle connections, threads waiting).
*   **Cache Metrics:** Cache hits vs. misses.

## 3. Micrometer + Prometheus + Grafana Setup
This is the most popular open-source monitoring stack for Spring Boot.

### The Architecture:
1.  **Spring Boot**: Collects metrics using Micrometer.
2.  **Prometheus Endpoint**: Spring Boot exposes an endpoint (usually `/actuator/prometheus`) formatted specifically for Prometheus to read.
3.  **Prometheus Server**: A separate database that "scrapes" (pulls) data from your Spring Boot API every few seconds and stores it.
4.  **Grafana**: A dashboard UI that connects to Prometheus to turn those numbers into graphs.

### How to Enable it:
**1. Add Dependencies:**
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
<!-- This bridge enables the Prometheus format -->
<dependency>
    <groupId>io.micrometer</groupId>
    <artifactId>micrometer-registry-prometheus</artifactId>
</dependency>
```

**2. Configure `application.properties`:**
```properties
# Expose the specific endpoint
management.endpoints.web.exposure.include=health,info,prometheus
```

Now, if you visit `http://localhost:8080/actuator/prometheus`, you will see a massive list of text-based metrics ready to be scraped.

## 4. Custom Metrics (Application & Business Metrics)
System metrics tell you if the *server* is healthy. Custom metrics tell you if the *business* is healthy. You define these using the **MeterRegistry**.

### Common Metric Types:

#### A. Counters
*   **What it is:** A number that only goes up (monotonically increasing).
*   **Use Case:** Counting total number of orders, total errors, or number of emails sent.
*   **Example:**
    ```java
    @Service
    public class OrderService {
        private final Counter orderCounter;

        public OrderService(MeterRegistry registry) {
            // Create a counter named "shop.orders.placed"
            this.orderCounter = registry.counter("shop.orders.placed");
        }

        public void placeOrder(Order order) {
            // Business logic...
            orderCounter.increment(); // +1
        }
    }
    ```

#### B. Gauges
*   **What it is:** A snapshot of a value at a specific point in time. It goes up and down.
*   **Use Case:** The size of a specific List/Queue, current temperature, or number of users currently logged in.
*   **Example:**
    ```java
    @Component
    public class QueueManager {
        private List<String> processingQueue = new ArrayList<>();

        public QueueManager(MeterRegistry registry) {
            // This gauge will constantly check the .size() of the list
            registry.gauge("job.queue.size", processingQueue, List::size);
        }
    }
    ```

#### C. Timers
*   **What it is:** Measures both the **latency** (how long it took) and the **frequency** (how often it happened).
*   **Use Case:** Measuring how long the `processPayment()` method takes.
*   **Example:**
    ```java
    Timer.builder("payment.process.time")
        .register(registry)
        .record(() -> {
            // Method to be timed
            paymentGateway.charge(100);
        });
    ```
    *Note: Spring automatically times HTTP requests, but you use this for internal methods.*

## 5. Tags (Dimensionality)
Tags are strictly enforced in Micrometer. They allow you to "slice and dice" your data.

Instead of creating different metric names for errors:
*   `http_errors_500`
*   `http_errors_404`

You create **one** metric with a tag:
*   `http_errors` | `status=500`
*   `http_errors` | `status=404`

**Why?**
In Grafana, you can ask a query like: *"Show me the total HTTP errors grouped by status code."* This is powerful for root cause analysis.

---

### Summary
To summarize this section of your study table:
1.  **Actuator** is the engine.
2.  **Micrometer** is the language/interface.
3.  **Prometheus/Grafana** is the destination/visualization.
4.  **Counters/Gauges/Timers** are the tools you use to measure business logic inside your Java code.
