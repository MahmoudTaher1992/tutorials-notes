Here is a detailed explanation of **Part III - G: Enums and the `final` Keyword**.

This section focuses on **immutability, constants, and data modeling**. These concepts are crucial because they help you write code that is safer, easier to read, and less prone to bugs by restricting how data can change.

---

### 1. Enums (Enumerations)

An **Enum** (short for Enumeration) is a special Java type used to define a collection of **constants**. It is used when a variable needs to be one value from a small, predefined set (e.g., Days of the Week, Card Suits, HTTP Statuses).

#### **A. Basic Definition**
In the old days, developers used integers (0, 1, 2) to represent states, which was error-prone. Java Enums are type-safe.

```java
// Defining an Enum
public enum OrderStatus {
    PENDING,
    PROCESSING,
    SHIPPED,
    DELIVERED,
    CANCELLED
}
```

#### **B. Using Enums**
You can use Enums in `if` statements and `switch` cases.

```java
OrderStatus currentStatus = OrderStatus.SHIPPED;

if (currentStatus == OrderStatus.DELIVERED) {
    System.out.println("Package arrived!");
}

// Enums work perfectly with Switch
switch (currentStatus) {
    case PENDING -> System.out.println("Waiting for payment...");
    case SHIPPED -> System.out.println("Package is on the way.");
    default -> System.out.println("Check tracking.");
}
```

#### **C. Enums are more than simple constants**
In Java, Enums are essentially **Classes**. They can have fields, constructors, and methods.

```java
public enum Planet {
    // Constants call the constructor
    MERCURY(3.303e+23, 2.4397e6),
    EARTH(5.976e+24, 6.37814e6);

    // Fields (usually final)
    private final double mass;
    private final double radius;

    // Constructor (Must be private)
    Planet(double mass, double radius) {
        this.mass = mass;
        this.radius = radius;
    }

    // Method
    public double surfaceGravity() {
        double G = 6.67300E-11;
        return G * mass / (radius * radius);
    }
}
```

**Key Methods:** `values()` (returns an array of all constants) and `valueOf("STRING")` (converts a string to the Enum).

---

### 2. The `final` Keyword

The `final` keyword allows you to enforce **immutability** (preventing change). It can be applied to variables, methods, and classes, behaving differently in each context.

#### **A. Final Variables**
When applied to a variable, its value **cannot be reassigned** once initialized.

*   **Primitives:** The value never changes.
    ```java
    final int MAX_USERS = 100;
    // MAX_USERS = 101; // Compilation Error
    ```
*   **Reference Variables (Objects):** You cannot point the variable to a *new* object, but **references are mutable**. You can still change the *data inside* the object.  
    *(This is a common interview question)*
    ```java
    final List<String> names = new ArrayList<>();
    
    // VALID: Changing the object's internal state
    names.add("Alice"); 
    
    // INVALID: Reassigning the reference
    // names = new ArrayList<>(); // Compilation Error
    ```

#### **B. Final Methods**
When applied to a method, it **cannot be overridden** by a subclass. This is used when you want to guarantee that a specific algorithm is not altered by inheriting classes.

```java
class Parent {
    public final void strictLogic() {
        System.out.println("This logic cannot be changed by subclasses.");
    }
}

class Child extends Parent {
    // @Override
    // public void strictLogic() { } // Compilation Error
}
```

#### **C. Final Classes**
When applied to a class, it **cannot be inherited (extended)**. This shuts down the entire inheritance chain.
*   **Example:** The standard `String` class is final. Java does not want you to create `class MyString extends String` because it would break security and optimizations relying on Strings being immutable.

```java
public final class ImmutableClass {
    // content
}

// class Hacker extends ImmutableClass {} // Compilation Error
```

---

### 3. The `record` Type (Java 14+)

Before Java 14, if you wanted to create a simple class to hold data (a Data Carrier or POJO), you had to write a lot of "Boilerplate" code: 
*   Private fields
*   Getters (and Setters)
*   Constructor
*   `equals()`, `hashCode()`, and `toString()`

**Records** automate this. A Record is a concise way to define an **immutable data carrier**.

#### **A. Syntax**
You define the fields in the header.

```java
// This single line replaces 50+ lines of standard class code
public record User(int id, String name, String email) {}
```

#### **B. What happens behind the scenes?**
When you compile the code above, Java automatically generates:
1.  A **constructor** that takes `id`, `name`, and `email`.
2.  **Private final** fields.
3.  **Public accessor methods** (Note: they are named `name()`, not `getName()`).
4.  `equals()` and `hashCode()` based on all fields.
5.  A clear `toString()` implementation.

#### **C. Usage**
```java
public class Main {
    public static void main(String[] args) {
        User u1 = new User(1, "Alice", "alice@example.com");
        
        // Access data
        System.out.println(u1.name()); // "Alice"
        
        // Automatic toString()
        System.out.println(u1); // Output: User[id=1, name=Alice, email=alice@example.com]
        
        // Immutability
        // u1.setName("Bob"); // Error! Records are immutable. There are no setters.
    }
}
```

### Summary Table

| Concept | Primary Purpose | Key Characteristics |
| :--- | :--- | :--- |
| **Enum** | Defining a fixed set of constants. | Type-safe, can have methods/fields, used in switch. |
| **final (Variable)** | Creating constants. | Value/Reference cannot be reassigned. |
| **final (Method)** | Security & Consistency. | Prevents method overriding by subclasses. |
| **final (Class)** | Security & Design. | Prevents inheritance (cannot extend). |
| **record** | Data Carrier (DTO). | Concise, immutable, auto-generates constructor/getters/toString. |
