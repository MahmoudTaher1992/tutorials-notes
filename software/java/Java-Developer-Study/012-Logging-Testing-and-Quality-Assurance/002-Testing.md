Here is a detailed explanation of **Part XII, Section B: Testing**.

In professional Java development, testing is not just about making sure the code works once; it is about creating a safety net that ensures the code continues to work as the application grows. This section breaks down the different layers of the **Testing Pyramid** and the specific tools used in the Java ecosystem.

---

# 002 - Testing: Detailed Breakdown

## 1. Unit Testing (`JUnit`, `TestNG`)
Unit testing is the foundation of software quality. It involves testing individual components (usually a single class or method) in isolation from the rest of the system.

### **JUnit (Specifically JUnit 5 / Jupiter)**
JUnit is the de facto standard for unit testing in Java.
*   **Annotations:** You mark methods with `@Test` to define a test case. Use lifecycle annotations like `@BeforeEach` (run before every test) or `@AfterAll` (run once after all tests) to setup/teardown data.
*   **Assertions:** You use `Assertions` to verify expectations.
    *   `assertEquals(expected, actual)`
    *   `assertThrows(Exception.class, () -> method())`

**Example:**
```java
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;

class CalculatorTest {
    @Test
    void testAddition() {
        Calculator calc = new Calculator();
        assertEquals(5, calc.add(2, 3), "2 + 3 should equal 5");
    }
}
```

### **TestNG**
An alternative to JUnit. While JUnit is more popular in modern Spring Boot apps, TestNG is powerful for complex scenarios.
*   **Key Features:** Stronger support for parallel execution, dependent test methods (method B only runs if method A passes), and grouping tests.

---

## 2. Mocking and Spying (`Mockito`)
Unit tests must be fast and isolated. If your service calls a Database or a payment API, you don't want to actually hit those systems during a unit test. You use **Mockito** to simulate them.

### **Mocking**
Creates a "fake" object with no real behavior. You define specifically what it should return when called.
*   **Use case:** "When the `userRepository.findById(1)` is called, return this specific User object."

### **Spying**
Wraps a "real" object. It calls the real methods unless you specifically override one.
*   **Use case:** You want to test a real service, but verify that a specific internal method was called.

**Example:**
```java
// We mock the database dependency so we don't need a real DB connection
UserRepository mockRepo = Mockito.mock(UserRepository.class);

// Define behavior
Mockito.when(mockRepo.findById(1)).thenReturn(Optional.of(new User("John")));

// In the test, we verify interaction
userService.getUser(1);
Mockito.verify(mockRepo).findById(1); // Ensure the repo was actually called
```

---

## 3. Integration Testing
Integration tests verify that different layers of the application work together correctly (e.g., The Controller talking to the Service, talking to the Database).

### **Spring Boot Tests**
If you use Spring Boot, you use `@SpringBootTest`. This spins up the actual Application Context (Dependency Injection container).
*   It is slower than Unit Tests but tests reality.
*   **Testcontainers:** A modern best practice in integration testing. Instead of using an in-memory database (like H2), which might behave differently than production, you use Docker to spin up a *real* PostgreSQL/MySQL instance solely for the test duration.

---

## 4. REST Assured for API Testing
This is a specific library designed to test HTTP endpoints (REST APIs). It uses a readable "Fluent Interface" (Given-When-Then).

*   **Given:** Headers, Authentication tokens, Request Body.
*   **When:** The HTTP method (GET, POST, PUT) and the URL.
*   **Then:** Assertions on the Status Code (200 OK) and the JSON response body.

**Example:**
```java
given()
    .contentType("application/json")
    .body(newUserObject)
.when()
    .post("/api/users")
.then()
    .statusCode(201)
    .body("name", equalTo("John"));
```

---

## 5. Behavior Testing (`Cucumber-JVM`)
This falls under **BDD (Behavior Driven Development)**. It is useful when you need to bridge the gap between Developers and Product Managers/QA.

*   **Gherkin Syntax:** Tests are written in plain English files (`.feature` files).
*   **Implementation:** Java code maps these English sentences to code logic.

**Example (.feature file):**
```gherkin
Feature: User Login
  Scenario: Successful Login
    Given the user is on the login page
    When the user enters valid credentials
    Then the user should be redirected to the dashboard
```

---

## 6. Performance Testing (`JMeter`)
Functional tests check *if* it works; Performance tests check if it works *fast* and under *load*.

*   **JMeter:** A Java-based tool (usually run via GUI or CLI) used to simulate heavy loads on a server, group of servers, or network.
*   **Stress Testing:** Pushing the app until it crashes to find the breaking point.
*   **Load Testing:** Simulating a specific number of concurrent users (e.g., 1000 users hitting the "Buy" button at once) to ensure the API doesn't slow down or timeout.

---

### **Summary of the Testing Pyramid**
1.  **Unit Tests (JUnit/Mockito):** ~70% of your tests. Fast, cheap, specific.
2.  **Integration Tests (Spring Boot Test/REST Assured):** ~20% of your tests. Slower, verifies wiring.
3.  **UI/E2E/Performance (Selenium/JMeter):** ~10% of your tests. Slowest, most expensive, tests the whole system.
