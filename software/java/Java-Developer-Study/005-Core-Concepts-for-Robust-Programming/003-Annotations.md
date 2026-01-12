Here is a detailed explanation of **Part V, Section C: Annotations**.

---

# 005-Core-Concepts-for-Robust-Programming / 003-Annotations

### 1. What are Annotations?
In Java, Annotations are a form of **metadata**. They provide data *about* a program that is not part of the program itself.
*   **Analogy:** Think of a codeblock as a "package." The code inside is the product. The **Annotation** is the "shipping label" stuck to the outside. The label doesn't change the product, but it tells the shipping truck (the Compiler or Framework) how to handle it.

Annotations usually start with the `@` symbol (e.g., `@Override`).

---

### A. Standard Built-in Annotations
Java comes with several annotations built into `java.lang`. You use these to communicate with the **compiler**.

#### 1. `@Override`
This tells the compiler that you intend to override a method from a parent class or interface.
*   **Why use it?** If you make a typo in the method name or get the arguments wrong, the compiler will throw an error immediately. Without it, you might accidentally create a *new* method instead of overriding the old one.

```java
class Parent {
    public void displayInfo() { }
}

class Child extends Parent {
    @Override
    public void displayInfo() { // Safe
        System.out.println("Child info");
    }

    // @Override  <-- If you uncommented this, it would throw an error
    public void displayInf0() { } // Typo: 0 instead of o
}
```

#### 2. `@Deprecated`
Marks a class, method, or field that should no longer be used. It warns other developers (and the compiler) that this feature might be removed in the future.

```java
@Deprecated(since = "2.0", forRemoval = true)
public void oldMethod() {
    System.out.println("Don't use me!");
}
```

#### 3. `@SuppressWarnings`
Instructs the compiler to ignore specific warnings.
*   *Example:* If you strictly need to use a deprecated method and don't want the yellow warning line in your IDE.
```java
@SuppressWarnings("deprecation")
void useOldCode() {
    oldMethod(); // Compiler stays silent
}
```

#### 4. `@FunctionalInterface` (Java 8+)
Ensures that an interface has **exactly one abstract method**, making it suitable for Lambda expressions.
```java
@FunctionalInterface
interface Converter {
    int convert(String s);
    // int anotherOne(); // This would cause a compilation error
}
```

---

### B. Meta-Annotations
Meta-annotations are **annotations on annotations**. They define *how* and *where* your custom annotations can be used.

#### 1. `@Target`
Defines **where** you can place the annotation.
*   `ElementType.TYPE` (Class, interface, enum)
*   `ElementType.METHOD`
*   `ElementType.FIELD`
*   `ElementType.PARAMETER`

#### 2. `@Retention` (Crucial)
Defines **how long** the annotation is kept around.
*   `RetentionPolicy.SOURCE`: Discarded during compilation (e.g., `@Override`, Lombok).
*   `RetentionPolicy.CLASS`: Recorded in the `.class` file but ignored by the JVM at runtime (default).
*   `RetentionPolicy.RUNTIME`: Retained in the `.class` file and **readable by the JVM at runtime**. (Required for Spring, Hibernate, JUnit).

#### 3. `@Documented` & `@Inherited`
*   `@Documented`: Indicates that this annotation should be included in the Javadocs.
*   `@Inherited`: Allows child classes to inherit the annotation from a parent class.

---

### C. Custom Annotations
You can create your own annotations to strictly enforce rules or mark code for frameworks.

**Syntax:** You use `@interface`.

**Example:** Creating an annotation to restrict user access.

```java
import java.lang.annotation.*;

// 1. Meta-Annotations
@Retention(RetentionPolicy.RUNTIME) // We need to read this while the app is running
@Target(ElementType.METHOD)         // Only allowed on methods

// 2. Definition
public @interface Secured {
    // 3. Elements (Parameters)
    String role() default "USER"; // Default value is "USER"
    int level() default 1;
}
```

**Usage:**
```java
public class AdminController {

    @Secured(role = "ADMIN", level = 5)
    public void deleteUser() {
        // deletion logic
    }
}
```

---

### D. Annotation Processing
This is the "Engine" that makes annotations do something. Since annotations are just metadata, they don't do anything by themselves. They need a processor.

There are two ways annotations are processed:

#### 1. Compile-Time Processing (Source Generation)
Tools like **Lombok** or **MapStruct** use this.
*   **How it works:** When you compile your code, an "Annotation Processor" scans for specific annotations (like `@Getter`). It generates new code (getters/setters) and inserts it into the bytecode *before* the program finishes compiling.
*   **Result:** You write less code, but the compiled class has everything it needs.

#### 2. Runtime Processing (Reflection)
Frameworks like **Spring Boot**, **Hibernate**, and **JUnit** use this.
*   **How it works:** While the application is running, the framework uses **Java Reflection** to inspect classes.
*   *Example:* Spring scans all classes. If it finds `@Service` on a class, it creates an instance of that class and puts it in the Application Context.

**Example of Runtime Processing logic:**
```java
// A simple annotation processor leveraging Reflection
void checkSecurity(Object obj) {
    for (Method method : obj.getClass().getDeclaredMethods()) {
        // Check if the method has the @Secured annotation
        if (method.isAnnotationPresent(Secured.class)) {
            Secured annotation = method.getAnnotation(Secured.class);
            
            System.out.println("Method: " + method.getName());
            System.out.println("Required Role: " + annotation.role());
            
            // Logic: Check if current user has this role...
        }
    }
}
```

### Summary: Why is this robust programming?
1.  **Reduceds Boilerplate:** (e.g., Lombok's `@Data`) prevents human error in writing getters/setters.
2.  **Decoupling:** You configure behavior (like `@Transactional`) without writing transaction management code inside your business logic.
3.  **Compiler Help:** `@Override` and `@NonNull` catch bugs before you even run the app.
