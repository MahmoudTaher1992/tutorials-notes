Based on the `010-Advanced-Topics-Best-Practices/005-API-Versioning.md` entry in your table of contents, here is a detailed explanation of what that section covers, why it matters, and the different strategies used to implement it in Spring Boot.

---

# 005-API-Versioning

## 1. The Concept: Why Versioning?
API Versioning is the practice of managing changes to your API so that you can add new features or change data structures **without breaking existing clients** (mobile apps, 3rd party integrations, frontend websites).

In Spring Boot, versioning is primarily handled at the **Controller layer** (the entry point of your application).

## 2. Common Strategies
There are four main ways to version an API in Spring Boot. This section of your study plan would explain how to implement each using Spring MVC annotations.

### A. URI Versioning (Path Versioning)
This is the most common and easiest strategy to understand. You include the version number directly in the URL path.

*   **Pattern:** `http://localhost:8080/v1/student` vs `http://localhost:8080/v2/student`
*   **Spring Boot Implementation:**
    ```java
    @RestController
    @RequestMapping("/v1/student") // Version 1
    public class StudentControllerV1 {
        @GetMapping
        public StudentV1 getStudent() {
            return new StudentV1("Bob"); // Returns simple name
        }
    }

    @RestController
    @RequestMapping("/v2/student") // Version 2
    public class StudentControllerV2 {
        @GetMapping
        public StudentV2 getStudent() {
            return new StudentV2(new Name("Bob", "Smith")); // Returns complex name object
        }
    }
    ```
*   **Pros:** Very easy for developers to see which version they are using.
*   **Cons:** Technically violates strict REST principles (the "resource" is the student, changing the URL implies a different resource).

### B. Request Parameter Versioning
You use a query parameter to specify the version.

*   **Pattern:** `http://localhost:8080/student?version=1`
*   **Spring Boot Implementation:**
    You interpret the same URL differently based on the `params` attribute.
    ```java
    @RestController
    @RequestMapping("student")
    public class StudentController {

        // Matches if ?version=1 implies
        @GetMapping(params = "version=1")
        public StudentV1 getStudentV1() {
            return new StudentV1("Bob");
        }

        // Matches if ?version=2 implies
        @GetMapping(params = "version=2")
        public StudentV2 getStudentV2() {
            return new StudentV2("Bob", "Smith");
        }
    }
    ```
*   **Pros:** Takes pollution out of the URL path. Easy to request via browser.
*   **Cons:** Can make checking logs/analytics harder if query params aren't indexed properly.

### C. Header Versioning (Custom Headers)
You send the version in a custom HTTP header. The URL looks the same for everyone.

*   **Pattern:** URL: `http://localhost:8080/student` | Header: `X-API-VERSION: 1`
*   **Spring Boot Implementation:**
    Use the `headers` attribute in the mapping.
    ```java
    @RestController
    @RequestMapping("student")
    public class StudentController {

        @GetMapping(headers = "X-API-VERSION=1")
        public StudentV1 getStudentV1() {
            return new StudentV1("Bob");
        }

        @GetMapping(headers = "X-API-VERSION=2")
        public StudentV2 getStudentV2() {
            return new StudentV2("Bob", "Smith");
        }
    }
    ```
*   **Pros:** Keeps URLs very clean. Separation of concern (versioning is metadata, not resource data).
*   **Cons:** Harder to test in a simple browser (you need tools like Postman or `curl` to inject headers).

### D. Media Type Versioning (Content Negotiation)
Also known as "Accept Header" versioning. This is the most "RESTful" approach. You use the strict HTTP `Accept` header.

*   **Pattern:** URL: `http://localhost:8080/student` | Header: `Accept: application/vnd.company.app-v1+json`
*   **Spring Boot Implementation:**
    Use the `produces` attribute.
    ```java
    @RestController
    @RequestMapping("student")
    public class StudentController {

        @GetMapping(produces = "application/vnd.company.app-v1+json")
        public StudentV1 getStudentV1() {
            return new StudentV1("Bob");
        }

        @GetMapping(produces = "application/vnd.company.app-v2+json")
        public StudentV2 getStudentV2() {
            return new StudentV2("Bob", "Smith");
        }
    }
    ```
*   **Pros:** Allows you to version just the *representation* of the resource, not the entire API structure.
*   **Cons:** Most complex to implement and document.

---

## 3. Best Practices (What this file would likely conclude with)

1.  **Code Structure:** Do not copy-paste your entire application for V2. Usually, you create different DTOs (Data Transfer Objects) regarding the entry point, but the underlying **Service Layer** should hopefully be reused or adapted using the "Adapter Pattern."
2.  **Deprecation:** How to tell clients a version is going away.
    *   Use the `@Deprecated` annotation in Java.
    *   Return a standard HTTP header (e.g., `Warning: 299 - "This version is deprecated"`) to warn clients to upgrade.
3.  **Documentation:** You must clearly document (in Swagger/OpenAPI) which endpoints belong to which version, otherwise, clients won't know how to call the new features.

## Summary Checklist for your Study:
When studying this file/topic, ensure you can answer:
1.  How do I configure Spring Boot to distinguish between `/v1/` and `/v2/`?
2.  How do I manage two different Java classes (`StudentV1.java` and `StudentV2.java`) for the output?
3.  Which strategy fits my project best? (Usually, start with **URI Versioning** for simplicity, move to **Header/Media Type** for enterprise complexity).
