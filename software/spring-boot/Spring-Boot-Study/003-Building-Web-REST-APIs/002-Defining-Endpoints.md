Based on the detailed structure you provided, here is an in-depth explanation of the section **Part III (Building Web/REST APIs) -> B (Defining Endpoints)**.

This section covers how you actually create the "doors" to your application that clients (browsers, mobile apps, Postman) interact with.

---

# 002-Defining-Endpoints.md

In Spring Boot, defining an endpoint is done inside a **Controller** class. Before Spring 4.3, we used `@RequestMapping` for everything. Now, we have specialized annotations that make the code more readable and align strictly with RESTful verbs.

Here is the breakdown of the concepts required to define robust endpoints:

## 1. Mapping HTTP Verbs
REST APIs rely on standard HTTP verbs (GET, POST, PUT, DELETE, PATCH). Spring Boot maps Java methods to these verbs using specific annotations.

### The Annotations
Instead of writing generic request handlers, we explicitly state what the method does:

*   **`@GetMapping("/resource")`**: Fetches data (Read). idemptotent.
*   **`@PostMapping("/resource")`**: Creates new data (Create).
*   **`@PutMapping("/resource/{id}")`**: Replaces an existing resource entirely (Update).
*   **`@PatchMapping("/resource/{id}")`**: Partially updates a resource (Partial Update).
*   **`@DeleteMapping("/resource/{id}")`**: Removes a resource (Delete).

### Example
```java
@RestController
@RequestMapping("/api/users") // Base path for all endpoints in this class
public class UserController {

    @GetMapping
    public List<User> getAllUsers() {
        // logic to get users
    }

    @PostMapping
    public User createUser(@RequestBody User user) {
        // logic to create user
    }
}
```

---

## 2. Extracting Data from the Request
When a client calls your API, they send data. Your endpoint needs to capture that data. There are three main ways to do this:

### A. Path Variables (`@PathVariable`)
This is used when a value is part of the URL structure itself. It usually identifies a specific resource.

*   **URL:** `GET /api/users/105`
*   **Usage:** The `105` is the ID of the user we want.

```java
@GetMapping("/{id}")
public User getUserById(@PathVariable("id") Long userId) {
    // Spring extracts "105" from URL and assigns it to userId
    return userService.findById(userId);
}
```

### B. Request Parameters (`@RequestParam`)
This is used for query strings (the part after the `?` in a URL). These are typically used for filtering, sorting, or optional data.

*   **URL:** `GET /api/users?role=ADMIN&active=true`
*   **Usage:** We want to filter the list of users.

```java
@GetMapping
public List<User> searchUsers(
    @RequestParam(name = "role") String role, 
    @RequestParam(name = "active", defaultValue = "true") boolean active
) {
    // Spring maps keys "role" and "active" from URL to variables
    return userService.search(role, active);
}
```
*Note: You can make parameters optional using `required=false` or providing a `defaultValue`.*

### C. Request Body (`@RequestBody`)
This is used primarily with `POST`, `PUT`, and `PATCH`. The client sends a JSON payload (or XML) containing the object data.

*   **Payload (JSON):**
    ```json
    {
      "username": "john_doe",
      "email": "john@example.com"
    }
    ```
*   **Usage:** Spring automatically deserializes (converts) this JSON into a Java Object (POJO/DTO).

```java
@PostMapping
public User createUser(@RequestBody UserDto userDto) {
    // 'userDto' is now a Java object containing the JSON data
    return userService.save(userDto);
}
```

---

## 3. Request Validation (`@Valid`)
You should never trust data sent by the client. Spring Boot integrates with the **Bean Validation API (Hibernate Validator)** to validate incoming DTOs automatically.

### Step 1: Annotate the DTO
Inside your Data Transfer Object (DTO), you define rules:

```java
public class UserDto {
    @NotNull(message = "Username cannot be empty")
    private String username;

    @Email(message = "Invalid email format")
    private String email;
    
    @Min(18)
    private int age;
    
    // getters and setters
}
```

### Step 2: Enable Validation in Endpoint
Add the `@Valid` annotation before the `@RequestBody`:

```java
@PostMapping
public ResponseEntity<String> createUser(
    @Valid @RequestBody UserDto userDto
) {
    // If validation fails, this code is NOT executed.
    // Spring throws a MethodArgumentNotValidException automatically.
    
    userService.save(userDto);
    return ResponseEntity.ok("User created");
}
```

---

## 4. Accessing Headers (`@RequestHeader`)
Sometimes data is hidden in headers (like Authentication tokens, User-Agent, or custom API keys).

```java
@GetMapping("/secret-data")
public String getSecret(
    @RequestHeader("Authorization") String token,
    @RequestHeader(value = "Accept-Language", defaultValue = "en") String lang
) {
    // Logic using the token
    return "Data";
}
```

---

## Summary Checklist for Defining Endpoints
When you build this part of your API, you are essentially answering these questions:

1.  **What is the HTTP Verb?** (GET, POST, DELETE?) $\rightarrow$ determines the `@Mapping` annotation.
2.  **What is the URI?** (`/users`, `/products/{id}`) $\rightarrow$ determines the path hierarchy.
3.  **Where is the data coming from?**
    *   In the URL path? $\rightarrow$ `@PathVariable`
    *   After the `?` query string? $\rightarrow$ `@RequestParam`
    *   Inside the JSON body? $\rightarrow$ `@RequestBody`
    *   Inside the Header? $\rightarrow$ `@RequestHeader`
4.  **Is the data valid?** $\rightarrow$ Add `@Valid`.
