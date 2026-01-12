This section refers to the **Java Platform Module System (JPMS)**, arguably the most significant architectural change in Java’s history, introduced in September 2017 with **Java 9** (under the code name "Project Jigsaw").

Here is a detailed breakdown of **Part VI, Section B: Modules: Encapsulation and Java 9+ Features**.

---

### 1. The Problems Before Java 9
To understand modules, you must understand the problems they solved:

1.  **"JAR Hell" (Classpath Issues):** In Java 8 and older, the Classpath is just a flat list of JARs. If two different libraries require different versions of the same dependency, or if a class is missing, you often wouldn't know until the application crashed at runtime (`NoClassDefFoundError`).
2.  **Weak Encapsulation:** Before Java 9, the access modifiers were limited. If a class was `public`, it was visible to **everyone**.
    *   *The issue:* Library authors often have "internal" helper classes (public so packages inside the library can share them) that they don't want external users to touch. But users would use them anyway. When the library updated and changed those internal classes, the users' code would break.
3.  **Monolithic JDK:** The Java Runtime Environment (JRE/rt.jar) was massive. Even if you wrote a "Hello World" app, you had to carry around the entire library for CORBA, SQL, XML, and UI code, resulting in heavy memory usage.

---

### 2. What is a Module?
A Module is a new level of aggregation, sitting **above packages**.
*   **Java 8:** Classes $\rightarrow$ Packages $\rightarrow$ JARs (but JARs are just zip files with no rules).
*   **Java 9:** Classes $\rightarrow$ Packages $\rightarrow$ **Modules** $\rightarrow$ Application.

A module is a group of compile-time code, data, and resources. It describes:
1.  Which other modules it **needs** (Dependencies).
2.  Which packages within itself are **visible** to others (Exports).

---

### 3. The `module-info.java` File
The heart of the module system is a file named `module-info.java`, which must be placed in the **root** of your source folder.

Here is the syntax and the key keywords (directives):

```java
module com.mycompany.payment {
    
    // 1. REQUIRES: Defines dependencies
    // We need the basic Java logic (implicitly bundled, but shown for clarity)
    requires java.base; 
    // We need the SQL module to talk to databases
    requires java.sql;
    // We need a custom logging module
    requires com.mycompany.logging;

    // 2. EXPORTS: Defines the public API (Strong Encapsulation)
    // Only classes in 'com.mycompany.payment.api' are accessible to other modules.
    // Classes in 'com.mycompany.payment.internal' cannot be seen by ANYONE outside this module.
    exports com.mycompany.payment.api;

    // 3. OPENS: For Reflection
    // Allows frameworks like Hibernate or Spring to use reflection on this package, 
    // even if it isn't exported for general use.
    opens com.mycompany.payment.entities to org.hibernate;
    
    // 4. PROVIDES / USES: Service Provider Interface (SPI)
    // Used for decoupling implementations (interfaces)
    provides com.mycompany.payment.api.PaymentService
        with com.mycompany.payment.internal.StripePaymentImpl;
}
```

#### Key Directives Explained:
*   **`requires`**: Declares that this module depends on another. The JVM checks this at startup. If the module is missing, the app refuses to start (solving the "missing class at runtime" issue).
*   **`requires transitive`**: If Module A depends on B, and exports a method that returns a type from B, anyone reading A also needs B. Transitive requires handles this automatically.
*   **`exports`**: The firewall. If you do not explicitly `export` a package, **no one** can import its classes, even if those classes are marked `public`. This is **Strong Encapsulation**.
*   **`opens`**: This allows deep reflection (accessing private members). This was added because frameworks like Spring and Hibernate rely heavily on reflection, which the Module system blocks by default to ensure security.

---

### 4. Key Benefits

#### A. Strong Encapsulation
In Java 9, `public` no longer means "public to the world." It means "public to other classes within this module." To be public to the world, a class must be **public** AND in an **exported package**.

This allows library developers to freely refactor their internal code without breaking their users' applications.

#### B. Reliable Configuration
The Module system validates the dependency graph **at startup**. If you have cyclic dependencies (A requires B, B requires A) or missing dependencies, the application fails fast with a clear error message, rather than crashing randomly later.

#### C. Custom Runtimes (jlink)
Because the JDK itself was modularized (broken into pieces like `java.base`, `java.desktop`, `java.sql`), you can now use a tool called **`jlink`**.

`jlink` allows you to build a custom, minimal Java Runtime Image containing *only* the modules your specific application needs.
*   *Before:* A standard JRE might be 200MB+.
*   *With Modules:* A microservice that only uses string manipulation might run on a custom image that is only 30MB. This is vital for **Containerization (Docker)** and Cloud deployments.

---

### 5. Migration (The Classpath vs. Module Path)
Java 9 introduced a "Module Path" aimed to replace the "Classpath." However, to ensure backward compatibility:

1.  **The Unnamed Module:** If you run your code the old way (using Classpath without a `module-info.java`), Java puts all your code into the "Unnamed Module." This module reads everything and exports everything. This is why legacy Java 8 apps still run on Java 17 or 21 without changes.
2.  **Automatic Modules:** If you put a regular JAR (without `module-info`) on the *Module Path*, Java automatically treats it as a module, deriving its name from the JAR filename.

### Summary Checklist for this Section
When studying this, ensure you can answer:
1.  Why did Java introduce modules? (Reliability, Encapsulation, Scalability).
2.  What is the difference between `requires` and `exports`?
3.  How does the Module system affect Reflection (the `opens` keyword)?
4.  What is `jlink` and how does it help cloud deployment?
