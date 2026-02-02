Based on the file path you provided (`003-Building-Web-REST-APIs/005-API-Documentation.md`) and the corresponding section in the Table of Contents (**Part III, Section E**), here is a detailed explanation of **API Documentation** in the context of Spring Boot.

This section focuses on how to turn your code into a readable manual for the developers (frontend, mobile, or third-party) who will consume your API.

---

### 1. The Core Concept: OpenAPI & Swagger
In the past, developers had to manually write Word documents or Wikis to explain how their API worked. This was prone to error and quickly became outdated.

Today, we use a **"Code-First" approach**. We add small descriptions to our Java code, and a library automatically generates an interactive website for us.

*   **OpenAPI Specification (OAS):** The industry standard format (usually JSON or YAML) for defining REST APIs. It describes endpoints, request data types, and response formats.
*   **Swagger UI:** A web-based interface that reads the OAS file and creates a beautiful, interactive webpage where anyone can test your API endpoints directly from the browser.

### 2. Implementation: Springdoc OpenAPI
In modern Spring Boot (especially version 3.x), the standard library used to achieve this is **`springdoc-openapi`**. (Note: An older library called *Springfox* exists but is largely deprecated/inactive).

#### How to set it up:
You simply add a dependency to your `pom.xml` (Maven) or `build.gradle`.

```xml
<!-- Maven Dependency for Spring Boot 3 -->
<dependency>
    <groupId>org.springdoc</groupId>
    <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
    <version>2.2.0</version> <!-- Check for latest version -->
</dependency>
```

Once you run your application, two magic URLs become available immediately:
1.  **`/v3/api-docs`**: The raw JSON definition of your API (machine readable).
2.  **`/swagger-ui.html`**: The visual website (human readable).

#### Annotations (Decorating your Code):
While Springdoc scans your code automatically, you can add annotations to make the documentation clearer.

*   **`@OpenAPIDefinition`**: Sets the general info for the page (Title, Version, Description).
*   **`@Tag`**: Groups endpoints (e.g., "User Management", "Product Search").
*   **`@Operation`**: Describes what a specific HTTP method does.
*   **`@ApiResponse`**: Documents specific return scenarios (200 OK, 404 Not Found, etc.).

**Example Code:**
```java
@RestController
@RequestMapping("/api/users")
@Tag(name = "User System", description = "Operations related to user management")
public class UserController {

    @Operation(
        summary = "Get User by ID", 
        description = "Fetches user details from the database using the numeric ID."
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "User found successfully"),
        @ApiResponse(responseCode = "404", description = "User not found")
    })
    @GetMapping("/{id}")
    public ResponseEntity<User> getUser(@PathVariable Long id) {
        // Logic here
        return ResponseEntity.ok(new User());
    }
}
```

---

### 3. API Versioning Techniques
APIs change over time. You might change a field name from `firstName` to `givenName`. If you do this without versioning, you will break the mobile app currently installed on user phones. Versioning creates "snapshots" of your API logic.

There are four main strategies to handle this in Spring Boot:

#### A. URI Versioning (Most Common)
You verify the version explicitly in the URL path.
*   **URL:** `http://api.example.com/v1/users` inside `http://api.example.com/v2/users`
*   **Spring Implementation:**
    ```java
    @RequestMapping("/v1/users")
    public class UserControllerV1 { ... }

    @RequestMapping("/v2/users")
    public class UserControllerV2 { ... }
    ```
*   **Pros:** Very easy for developers to see which version they are using. Cashes well.
*   **Cons:** Can clutter URL paths.

#### B. Request Parameter Versioning
You pass the version as a query parameter.
*   **URL:** `http://api.example.com/users?version=1`
*   **Spring Implementation:**
    ```java
    @GetMapping(value = "/users", params = "version=1")
    public ResponseEntity<User> getUserV1() { ... }
    ```
*   **Pros:** Keeps URLs clean.
*   **Cons:** Some proxies strip query parameters.

#### C. Custom Header Versioning
You use a custom HTTP header to specify the version.
*   **Header:** `X-API-VERSION: 1`
*   **Spring Implementation:**
    ```java
    @GetMapping(value = "/users", headers = "X-API-VERSION=1")
    public ResponseEntity<User> getUserV1() { ... }
    ```
*   **Pros:** URLs are very clean (`/users`). Separation of concerns (URI is for resource, Header is for metadata).
*   **Cons:** Harder to test in a simple browser (need Postman or Curl to send headers).

#### D. Media Type Versioning (Content Negotiation)
Also known as "Accept Header" versioning. This is the most "RESTful" approach.
*   **Header:** `Accept: application/vnd.company.app-v1+json`
*   **Spring Implementation:**
    ```java
    @GetMapping(value = "/users", produces = "application/vnd.company.app-v1+json")
    public ResponseEntity<User> getUserV1() { ... }
    ```
*   **Pros:** Allows granular versioning of specific resources.
*   **Cons:** Most complex to implement and test.

### Summary
In the **API Documentation** section of your study:
1.  You will learn to install **Springdoc**.
2.  You will run the app and see the **Swagger UI** auto-generated.
3.  You will practice adding annotations like `@Operation` to make the docs look professional.
4.  You will learn how to structure your controllers to handle **API versions** so your app can evolve without breaking existing clients.
