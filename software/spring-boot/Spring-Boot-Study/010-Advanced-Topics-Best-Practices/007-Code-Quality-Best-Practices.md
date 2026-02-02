This section of your study plan focuses on **maintainability, reliability, and professionalism**. In professional software development, getting the code to "work" is only half the battle. This section teaches you how to write code that is clean, readable for other developers, and easy to maintain over time.

Here is a detailed breakdown of the concepts within **Code Quality & Best Practices** for Spring Boot.

---

### 1. Static Analysis & Linting
This involves using automated tools to scan your source code for errors, bugs, stylistic errors, and suspicious constructs *before* the code is even run.

*   **Linting (e.g., Checkstyle):**
    *   **What it is:** Enforces a specific coding style (indentation, naming conventions, whitespace, brace placement).
    *   **Why in Spring Boot?** It ensures that `UserService.java` looks like it was written by the same person as `OrderController.java`, even if five different people worked on them.
    *   **Example Rule:** "Class names must be UpperCamelCase" or "Method lines cannot exceed 50 lines."

*   **Static Analysis (e.g., PMD, SpotBugs):**
    *   **What it is:** Looks for potential bugs, dead code (unused variables), complicated logic (Cyclomatic complexity), and performance inefficiencies.
    *   **Why in Spring Boot?** It catches common mistakes like empty `catch` blocks, inefficient String concatenation loops, or failing to close InputStreams.

*   **SonarQube (The Dashboard):**
    *   **What it is:** A platform that aggregates data from Linter and Analysis tools. It tracks **"Technical Debt"**—an estimated time calculation of how long it would take to fix all the bad code in your project. It also checks for security vulnerabilities (e.g., hardcoded passwords).

---

### 2. Spring Boot Architecture Patterns (Layered Architecture)
Spring Boot is opinionated about configuration, but unopinionated about structure. However, there is a widely accepted "Best Practice" standard known as **Layered Architecture**.

You should strict separation of concerns:

1.  **Presentation Layer (Controllers):**
    *   **Role:** Handle HTTP requests, parse JSON, validate input (`@Valid`), and return HTTP responses (`ResponseEntity`).
    *   **Rule:** **Never write business logic here.** The controller should just be a "traffic cop" routing data.
2.  **Service Layer (Services):**
    *   **Role:** The heart of the application. It performs calculations, business rules, talks to other services, and manages Transactions (`@Transactional`).
    *   **Rule:** Services should not know about HTTP concepts (like `HttpServletRequest`). They should just take data objects and return results.
3.  **Data Access Layer (Repositories):**
    *   **Role:** Talk to the database.
    *   **Rule:** No logic here unless it is a database query.

**The "DTO vs. Entity" Rule:**
One of the most important quality checks is ensuring you **never** return your Database `@Entity` directly to the API user.
*   **Bad:** Controller returns `UserEntity` (which might contain a password field or internal IDs).
*   **Good:** Controller maps `UserEntity` to a `UserResponseDTO` (Data Transfer Object) and returns that.

---

### 3. Package Structure Strategies
How do you organize your folders?

*   **Package by Layer (Old School/Simple):**
    *   `com.app.controllers` (contains ALL controllers)
    *   `com.app.services` (contains ALL services)
    *   *Pros:* Easy for beginners.
    *   *Cons:* In large apps, unrelated features are mixed together.

*   **Package by Feature (Modern/Preferred):**
    *   `com.app.user` (contains UserController, UserService, UserRepository)
    *   `com.app.order` (contains OrderController, OrderService)
    *   *Pros:* Highly modular. If you want to delete the "Order" feature, you delete one folder. It aligns better with Microservices and Domain-Driven Design (DDD).

---

### 4. Dependency Injection Best Practices
How you inject dependencies affects testability and code quality.

*   **Standard: Field Injection (Discouraged)**
    ```java
    @Autowired
    private UserService userService; // Hard to test without loading Spring Context
    ```
*   **Best Practice: Constructor Injection (Highly Recommended)**
    ```java
    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }
    ```
    *   *Why?* It allows you to create immutable fields (`final`). It also makes Unit Testing with Mockito much easier because you can instantiate the class using generic Java `new UserController(mockService)`.

---

### 5. Exception Handling
Do not clutter your business logic with try-catch blocks to handle HTTP errors.

*   **Bad Code Quality:**
    ```java
    // Controller
    try {
        service.findUser();
    } catch (UserNotFoundException e) {
        return new ResponseEntity(404);
    }
    ```
*   **Good Code Quality:** specific logic stays clean, error handling is global.
    *   Use `@ControllerAdvice` and `@ExceptionHandler`. This allows you to define how to handle a `UserNotFoundException` in **one distinct place** for the entire application.

---

### Summary Checklist for this Module
If you are studying this section, you should be able to answer "Yes" to these:
1.  Are you using **Constructor Injection** instead of `@Autowired` on fields?
2.  Are you using **DTOs** instead of returning Entities?
3.  Is your **Business Logic** strictly inside Services, not Controllers?
4.  Do you have a consistent formatted style (e.g., via Checkstyle)?
5.  Are you handling errors globally using **@ControllerAdvice**?
