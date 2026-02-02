Based on **Part III: Building Web/REST APIs**, Section **A. Spring MVC Fundamentals**, here is a detailed explanation of the core machinery that powers Spring Web applications.

Understanding this section is critical because even though Spring Boot automates configuration, **Spring MVC** is the actual engine handling every HTTP request your API receives.

---

# 003-Building-Web-REST-APIs / 001-Spring-MVC-Fundamentals

### 1. The Core Concept: The MVC Pattern
MVC stands for **Model-View-Controller**. It is a design pattern used to separate concerns in software:
*   **Model:** The data (e.g., a User object, data from a database).
*   **View:** What the user sees (HTML, JSON, PDF).
*   **Controller:** The traffic cop that takes user input, calls business logic, updates the model, and picks the view.

In modern REST APIs, the "View" is usually just the JSON data returned to the client, but the architectural flow remains the same.

---

### 2. The Request Lifecycle (Dispatcher Servlet & Handler Mapping)

To understand Spring MVC, you must understand the "lifespan" of a single HTTP Request (like a `GET /users` call).

#### A. The DispatcherServlet (The Front Controller)
In standard Java web apps, you might have many servlets. In Spring MVC, there is usually only **one** actual Servlet exposed to the web: the `DispatcherServlet`.

*   **Role:** It acts as the **Front Controller**. Think of it as the "Hotel Receptionist."
*   **How it works:** All incoming requests (whether for `/users`, `/products`, or `/login`) hit the `DispatcherServlet` first.
*   **Responsibility:** It delegates the request to the right place. It doesn't do the business logic itself; it knows *who* should do it.

#### B. Handler Mapping
Once the `DispatcherServlet` receives a request (e.g., `GET /api/products`), it needs to find out which Java method in your code is responsible for it.

*   **Role:** The "Phone Directory" or "Lookup Table."
*   **How it works:** It scans your code for annotations like `@RequestMapping`, `@GetMapping`, etc.
*   **Result:** It tells the DispatcherServlet: *"Hey, the request for `/api/products` belongs to `ProductController.java` method `getAllProducts()`."*

#### C. The Flow Diagram
```text
[Browser/Postman]
       |
       v (1. HTTP Request)
       |
[DispatcherServlet] <---- (2. Who handles this URL?) ---- [Handler Mapping]
       |                                                    |
       |  <---- (3. "ProductController serves this!") ------/
       |
       v (4. Forward request)
       |
[Your Controller]  ----> (5. Execute Business Logic)
       |
       v (6. Return Data/Object)
       |
[DispatcherServlet]
       |
       v (7. Convert Data to JSON via Jackson)
       |
[Browser/Postman] (8. HTTP Response)
```

---

### 3. Interceptors (HandlerInterceptors)

Interceptors are powerful tools that allow you to "intercept" a request **before** it reaches the controller or **after** the controller is done, but before the response is sent to the user.

Think of them as **Airport Security Checks**:
1.  **preHandle()**: Runs before the controller.
    *   *Use Case:* Check if the request has a valid API Key used for logging ("Request received at 10:00 AM"). If this returns `false`, the request stops here and never reaches the controller.
2.  **postHandle()**: Runs after the controller executes but before the view/response is built.
    *   *Use Case:* Adding global headers to the response.
3.  **afterCompletion()**: Runs after the response is sent.
    *   *Use Case:* Cleanup resources or log execution time exceptions.

---

### 4. `@Controller` vs. `@RestController`

This is the most common interview question and distinct architectural choice in Spring Boot.

#### A. `@Controller` (Traditional MVC)
*   User mainly for serving **Web Pages** (HTML).
*   By default, methods in this class return a **String** that represents a filename (View Name), like `index.html` or `home.jsp`.
*   If you want to return JSON from a classic `@Controller`, you must add `@ResponseBody` to the method.

#### B. `@RestController` (Modern REST APIs)
*   Used for serving **Data** (JSON/XML).
*   It is a convenience annotation.
*   **Formula:** `@RestController` = `@Controller` + `@ResponseBody`.
*   It assumes that *every* method in the class is writing data directly to the HTTP response body, not trying to load an HTML file.

**Code Comparison:**

**Scenario 1: Traditional Controller (Serving HTML)**
```java
@Controller
public class WebController {
    @GetMapping("/hello")
    public String sayHello() {
        // This looks for a file named "hello.html" or "hello.jsp"
        return "hello"; 
    }
}
```

**Scenario 2: REST Controller (Serving JSON)**
```java
@RestController
public class ApiController {
    @GetMapping("/hello")
    public String sayHello() {
        // This returns the actual String "Hello World" or JSON data to the browser
        return "Hello World"; 
    }
}
```

### Summary of Differences

| Feature | `@Controller` | `@RestController` |
| :--- | :--- | :--- |
| **Primary Use** | Web Applications (Server-side rendering) | RESTful Web Services |
| **Return Value** | View Name (e.g., "index") | Data Payload (JSON/XML) |
| **Annotation** | Requires `@ResponseBody` to return data | Includes `@ResponseBody` implicitly |
| **Workflow** | Dispatcher -> Handler -> View Resolver | Dispatcher -> Handler -> Message Converter (Jackson) |

### Why this matters to you?
When building the REST API in subsequent steps of your study plan:
1.  You will rely on **`DispatcherServlet`** automatically (Spring Boot configures it).
2.  You will write **`@RestController`** classes to hold your endpoints.
3.  You will use **`HandlerMappings`** by writing annotations like `@GetMapping("/users")`.
4.  You might use **Interceptors** later to add security checks or logging.
