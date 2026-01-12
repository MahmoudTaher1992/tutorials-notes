This section of your roadmap touches on one of the most powerful, yet "dangerous," features of the Java language.

In the context of this Table of Contents, **Dynamic Programming** does not refer to the algorithmic technique (like solving the Knapsack problem). Instead, it refers to **Dynamic Code Execution**—the ability of Java to modify its behavior, load code, or inspect itself while the program is actually running, rather than just at compile time.

Here is a detailed breakdown of **Reflection and Dynamic Programming**.

---

### 1. What is Reflection?
Normally, when you write Java code, you know exactly what classes, methods, and variables you are using. You type `Dog myDog = new Dog();` and `myDog.bark();`.

**Reflection** allows Java code to inspect and manipulate itself at runtime. It allows a program to examine or "introspect" the loaded classes, methods, fields, and constructors, even if it didn't know they existed at compile time.

Think of it as looking in a mirror. The code can ask: *"What methods do I have? What defines me? Let me change this private variable."*

#### Key Classes in `java.lang.reflect`
*   **`Class`**: The entry point. Every type in Java is represented by a `Class` object at runtime.
*   **`Method`**: Represents a specific function inside a class.
*   **`Field`**: Represents a variable inside a class.
*   **`Constructor`**: Represents the logic used to create an instance of the class.

### 2. Practical Examples of Reflection

#### A. Inspecting a Class (Introspection)
Imagine you built a plugin system where users drop a `.jar` file into a folder, and your app reads it. You don't know the class names beforehand.

```java
// Get the Class object (normally this might come from Class.forName("com.plugin.MyPlugin"))
Class<?> clazz = String.class; 

// Print all methods available in the String class
Method[] methods = clazz.getDeclaredMethods();
for (Method method : methods) {
    System.out.println("Method name: " + method.getName());
}
```

#### B. Invoking Methods Dynamically
Instead of calling `obj.method()`, you look up the method by name and invoke it.

```java
String data = "Hello World";
// Standard way:
// int length = data.length();

// Reflection way:
Method method = String.class.getMethod("length");
int length = (int) method.invoke(data); // Returns 11
```

#### C. Breaking Encapsulation (Accessing Private Fields)
This is controversial but powerful. Reflection allows you to access `private` fields and methods that are usually hidden.

```java
public class Secret {
    private String password = "123";
}

Secret s = new Secret();
Field f = Secret.class.getDeclaredField("password");

f.setAccessible(true); // <--- The "Magic" key. Disables privacy check.
String value = (String) f.get(s); 

System.out.println(value); // Prints "123"
```

---

### 3. Dynamic Programming (Dynamic Proxies)
This refers to creating code structures on the fly. The most common tool here is the **Java Dynamic Proxy**.

It allows you to create an instance of an interface at runtime without defining a concrete class source file. You define an "Invocation Handler"—a middleman that intercepts all method calls.

**Real-world analogy:** You want to talk to the CEO (the real object), but you have to go through the Assistant (the Proxy). The Assistant logs your request, checks your security clearance, and *then* lets you talk to the CEO.

```java
// The Interface
interface Service {
    void performTask();
}

// The Handler (The "Middleman")
InvocationHandler handler = (proxy, method, args) -> {
    System.out.println("Logging: Method " + method.getName() + " was called.");
    return null; 
};

// Creating the Proxy Instance dynamically
Service proxyService = (Service) Proxy.newProxyInstance(
    Service.class.getClassLoader(),
    new Class<?>[]{Service.class},
    handler
);

// When we call this, the "handler" logic runs, not a standard class method
proxyService.performTask(); 
// Output: Logging: Method performTask was called.
```

---

### 4. Why/When do we use this? (The "Magic" behind Frameworks)
As a standard application developer, you will rarely write Reflection code manually. However, **you use it every day** because frameworks are built on it.

1.  **Spring Framework (Dependency Injection):**
    *   How does `@Autowired` work? Spring uses Reflection to scan your classes, find the fields annotated with `@Autowired`, uses `setAccessible(true)`, and injects the dependency.
2.  **Hibernate / JPA (Databases):**
    *   How does Hibernate take a row from a SQL database and turn it into a `User` object? It creates an instance of `User` reflectively and sets the private fields directly from the database columns.
3.  **JUnit:**
    *   How does JUnit know which methods are tests? It scans your class for any method with the `@Test` annotation and invokes them using Reflection.
4.  **Jackson / GSON (JSON Parsing):**
    *   How does Java turn a JSON string `{"name":"John"}` into a Java Object? It uses Reflection to match the JSON keys to the Object field names.

---

### 5. Pitfalls and Trade-offs
If Reflection is so powerful, why don't we use it for everything?

1.  **Performance Overhead:**
    *   Reflective operations are slower than standard Java code because the JVM cannot optimize them as easily (JIT compiler limitations). It involves dynamic type resolving.
2.  **Loss of Compile-Time Safety:**
    *   If you type `dog.bark()`, the compiler checks if `bark` exists.
    *   If you write `class.getMethod("brk")`, the compiler says it's fine. You will only crash when you run the app (RuntimeException).
3.  **Security Risks:**
    *   Reflection allows code to access private internals. This can break library logic or expose sensitive data if not managed correctly.
4.  **Code Readability:**
    *   Reflection code is verbose, hard to debug, and hard to understand.

### Summary
*   **Reflection** gives Java the ability to modify its own structure and behavior at runtime.
*   It is the backbone of "Magic" frameworks like **Spring, Hibernate, and Mockito**.
*   **Dynamic Proxies** allow you to intercept method calls.
*   **Use sparingly:** It is great for building tools and frameworks, but usually bad for writing standard business logic.
