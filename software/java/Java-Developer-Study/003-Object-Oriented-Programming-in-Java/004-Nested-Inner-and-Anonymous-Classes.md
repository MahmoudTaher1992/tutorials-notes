Here is a detailed explanation of **Unit 003, Section 004: Nested, Inner, and Anonymous Classes**.

In Java, it is possible to define a class **inside another class**. These are collectively called **Nested Classes**.

This feature allows you to logically group classes that are only used in one place, increases encapsulation, and creates more readable and maintainable code.

There are **four** specific types of nested classes you need to understand:

1.  **Static Nested Classes**
2.  **Non-Static Nested Classes (Inner Classes)**
3.  **Local Classes** (Inside a method)
4.  **Anonymous Classes** (Unnamed)

---

### 1. Static Nested Classes
A static nested class is associated with its outer class, but **not** with a specific instance (object) of that outer class.

*   **Behavior:** It behaves just like a top-level class, except it is tucked inside another class for packaging convenience.
*   **Accessibility:** It **cannot** access non-static instance variables or methods of the outer class directly. It can only access `static` members of the outer class.
*   **Instantiation:** You do not need an object of the outer class to create the nested class.

**Code Example:**
```java
public class OuterClass {
    static int outerStaticVar = 10;
    int instanceVar = 20;

    // Static Nested Class
    static class StaticNested {
        void display() {
            // Can access static member of Outer
            System.out.println("Static Var: " + outerStaticVar); 
            
            // COMPILER ERROR: Cannot access non-static member
            // System.out.println("Instance Var: " + instanceVar); 
        }
    }
}

// Usage in Main:
public class Main {
    public void main(String[] args) {
        // No need to create 'new OuterClass()' first
        OuterClass.StaticNested nested = new OuterClass.StaticNested();
        nested.display();
    }
}
```
**Common Use Case:** The **Builder Pattern** (e.g., `User.Builder`) is almost always implemented as a Static Nested Class.

---

### 2. Non-Static Nested Classes (Inner Classes)
When people say "Inner Class," they usually mean this type. An inner class is associated with an **instance** of the outer class.

*   **Behavior:** It exists *within* an object of the outer class. It is like a member (like a field or method) of the outer object.
*   **Accessibility:** It has **full access** to the members of the outer class, including `private` fields and methods.
*   **Instantiation:** You must create an instance of the outer class *first* before you can create an instance of the inner class.

**Code Example:**
```java
public class OuterClass {
    private String secret = "I love Java";

    // Inner Class (Non-static)
    class InnerClass {
        void revealSecret() {
            // Can access private members of Outer!
            System.out.println("The secret is: " + secret);
        }
    }
}

// Usage in Main:
public class Main {
    public void main(String[] args) {
        // 1. Create Outer object
        OuterClass outer = new OuterClass();
        
        // 2. Create Inner object using the outer reference
        OuterClass.InnerClass inner = outer.new InnerClass(); // Note the syntax!
        
        inner.revealSecret();
    }
}
```
**Common Use Case:** Consider a `HashMap`. The `Entry` (key-value pair) or the `Iterator` are often inner classes because they need to reach into the internal data of the Map to work correctly.

---

### 3. Local Classes
A Local Class is a class defined **inside a block**, typically inside a method body.

*   **Behavior:** It is not visible outside that method. You can only use it within the method where it is defined.
*   **Accessibility:** It can access members of the enclosing class. Crucially, it can also access **local variables** of the method, but only if they are `final` or "effectively final" (initialized once and never changed).

**Code Example:**
```java
public class OuterClass {
    
    void validatePhoneNumber(String phoneNumber) {
        final int validLength = 10;

        // Local Class defined inside the method
        class PhoneNumberValidator {
            void validate() {
                if (phoneNumber.length() == validLength) {
                    System.out.println("Valid number");
                } else {
                    System.out.println("Invalid number");
                }
            }
        }

        // Must be used inside this method
        PhoneNumberValidator validator = new PhoneNumberValidator();
        validator.validate();
    }
}
```

---

### 4. Anonymous Classes
An anonymous class is a local class **without a name**. It is used to declare and instantiate a class at the same time.

*   **Behavior:** It is usually used to override a method of a class or implement an interface on the fly.
*   **Context:** Before Java 8 (Lambdas), this was the only way to pass functionality (callbacks) around.

**Code Example (Implementing an Interface):**
```java
interface Greeter {
    void sayHello();
}

public class Main {
    public static void main(String[] args) {
        
        // Anonymous Class
        // We are creating a class that implements Greeter, 
        // defining the sayHello method, and instantiating it, all at once.
        Greeter englishGreeter = new Greeter() {
            @Override
            public void sayHello() {
                System.out.println("Hello there!");
            }
        };

        englishGreeter.sayHello();
    }
}
```

**Note:** In modern Java (Java 8+), if the interface only has **one method** (a Functional Interface), we typically use **Lambda Expressions** instead of Anonymous classes because they are much shorter:
```java
// Lambda equivalent of the above
Greeter modernGreeter = () -> System.out.println("Hello there!");
```

---

### Summary and Comparison

| Feature | **Static Nested Class** | **Inner Class** (Non-static) |
| :--- | :--- | :--- |
| **Keyword** | Defined with `static` | No `static` keyword |
| **Connection** | Independent of Outer *Instance* | Bound to an Outer *Instance* |
| **Access** | Can only access static members of Outer | Can access ALL members (static & private) of Outer |
| **Creation** | `new Outer.Nested()` | `outerObj.new Inner()` |
| **Use Case** | Helper classes, Builders | Adapters, Listeners, Iterators |

### Why use them?
1.  **Logical Grouping:** If class B is only useful to class A, keeping B inside A makes the project structure cleaner.
2.  **Encapsulation:** Inner classes can access private members of the outer class. This lets you hide the internal workings of the outer class while still allowing the specific helper class to manipulate it.
3.  **Readability:** Places code closer to where it is used.
