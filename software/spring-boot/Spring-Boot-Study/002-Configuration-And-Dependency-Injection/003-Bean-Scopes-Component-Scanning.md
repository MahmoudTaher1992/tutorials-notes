This section allows us to dive into the core mechanics of how Spring manages objects (Beans) in memory. It answers two fundamental questions:
1.  **Component Scanning:** How does Spring find my Java classes?
2.  **Bean Scopes:** How long do these objects live, and are they shared?

Here is the detailed explanation for **Part II, Section C**.

---

# 1. The Stereotype Annotations (Component Scanning)

In old versions of Spring, we had to list every single class in an XML file to tell Spring "This is a bean." Today, we use **Annotations**.

Spring provides specific annotations to mark classes as managed components. These are called **Stereotypes**.

### The Hierarchy
Technically, `@Component` is the generic parent annotation. The others (`@Service`, `@Repository`, `@Controller`) are specializations of `@Component`.

| Annotation | Layer / Purpose | Special Behavior |
| :--- | :--- | :--- |
| **`@Component`** | **Generic** | The base annotation. Use this for utility classes or generic beans that don't fit into the other specific layers. |
| **`@Service`** | **Business Logic** | Semantically indicates this class holds business logic. Currently, it behaves exactly like `@Component`, but it makes code readable (developers know "this is where the logic lives"). |
| **`@Repository`** | **Data Access (DAO)** | Marks classes that talk to Databases. **Special Feature:** It automatically catches database-specific exceptions (SQL failures) and translates them into Spring's unified `DataAccessException` hierarchy. |
| **`@Controller`** | **Web / MVC** | Marks the class as a Web Controller to handle HTTP requests. Used with `@RequestMapping`. |
| **`@RestController`** | **Web / APIs** | A combination of `@Controller` + `@ResponseBody`. It assumes every method returns data (JSON/XML) rather than a view (HTML page). |

### Example
```java
@Service // Specialization of @Component
public class UserService {
    
    // Spring finds this via Component Scanning and manages it
    public User getUser(String id) {
        return new User(id);
    }
}
```

---

# 2. Customizing Component Scanning

When you start a Spring Boot application, look at your main class:

```java
@SpringBootApplication
public class MyApplication {
    public static void main(String[] args) { ... }
}
```

The `@SpringBootApplication` annotation actually includes `@ComponentScan` inside it. By default, **it scans the current package and all sub-packages.**

### The Problem
If your main app is in `com.example.app` but you have a service in `com.company.library`, Spring will **not** find it by default because it is outside the main package tree.

### The Solution: Custom Base Packages
You can manually tell Spring where to look:

```java
@SpringBootApplication
@ComponentScan(basePackages = {
    "com.example.app",      // Scan my main code
    "com.company.library",  // Scan the external library
    "com.legacy.code"       // Scan legacy code
})
public class MyApplication { ... }
```

You can also use **Filters** to exclude specific beans from being loaded (e.g., exclude all classes ending in `TestConfig` during production).

---

# 3. Bean Scopes

Once Spring finds a class (via scanning), it creates an instance (a Bean). The **Scope** determines the *lifecycle* and *visibility* of that instance.

You define scope using `@Scope("scopeName")`.

### A. Singleton (The Default)
If you do not specify a scope, Spring assumes **Singleton**.
*   **Behavior:** Spring creates **exactly one instance** of the bean per Application Context (container). Every time you inject this bean, you get the same shared instance.
*   **Use Case:** Stateless services (Service layer), Repositories, Configuration classes.
*   **Thread Safety:** Since the instance is shared across threads, **stateful fields** (variables that change) should be avoided in Singletons.

```java
@Service // Implicitly Singleton
public class EmailService {
    // Stateless logic is safe here
}
```

### B. Prototype
*   **Behavior:** A **new instance** is created *every single time* the bean is requested (injected) from the container.
*   **Use Case:** Stateful beans (where the object holds data specific to a process) or objects that are not thread-safe.

```java
@Component
@Scope("prototype") // or @Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE)
public class ReportGenerator {
    private int internalCounter = 0; // State is safer here because it's a unique instance
}
```

### C. Web Scopes (Only available in Web Applications)

These scopes are tied to HTTP handling.

#### 1. Request Scope (`@RequestScope`)
*   **Behavior:** Spring creates a new instance for **each single HTTP request**. Once the response is sent, the bean is destroyed.
*   **Use Case:** Storing information specific to *that* request, such as a "User Tracking ID" or user-specific preferences for the duration of the API call.

#### 2. Session Scope (`@SessionScope`)
*   **Behavior:** Spring creates one instance per **HTTP Session** (User). It persists across multiple requests made by the same user until the session times out (e.g., logout or close browser).
*   **Use Case:** Shopping Carts, User Login Details, Multi-step form wizards.

#### 3. Application Scope (`@ApplicationScope`)
*   **Behavior:** Similar to Singleton, but specifically tied to the `ServletContext`. It is shared across the entire web application.

---

# 4. The "Scoped Proxy" Problem (Core Concept)

This is a common interview question and a frequent bug source.

**Scenario:** You have a `Singleton` service (Service A) that depends on a `Request` scoped bean (Bean B).
*   The Singleton (Service A) is created **once** at startup.
*   It injects its dependencies at that exact moment.
*   Therefore, it gets **one** instance of Bean B and keeps it forever.
*   **Result:** The "Request Scope" of Bean B is ignored. All users share the same "Request" object inside the Singleton. This is bad!

**Solution:** Use **Proxies**.

We tell Spring to inject a "smart proxy" (holder) instead of the actual object. When Service A calls a method on Bean B, the Proxy checks the *current* HTTP request and fetches the correct instance of Bean B for *that specific user*.

```java
@Component
@Scope(value = "request", proxyMode = ScopedProxyMode.TARGET_CLASS)
public class UserPreferences {
    // ...
}
```

*Note: The shortcuts `@RequestScope` and `@SessionScope` perform this proxy configuration automatically for you.*

### Summary Table

| Scope | Creation Frequency | Duration |
| :--- | :--- | :--- |
| **Singleton** | Once per application startup | Application lifetime (Container up to down) |
| **Prototype** | Every time `getBean` is called | As long as the caller holds reference |
| **Request** | Once per HTTP Request | Request start to Response end |
| **Session** | Once per User Session | User login to logout/timeout |
