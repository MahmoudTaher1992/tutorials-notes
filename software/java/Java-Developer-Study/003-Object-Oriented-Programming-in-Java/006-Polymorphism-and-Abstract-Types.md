Here is a detailed explanation of **Part III, Section F: Polymorphism and Abstract Types**. This is one of the most critical concepts in Java, as it allows your code to be flexible, scalable, and modular.

---

# F. Polymorphism and Abstract Types

## 1. Method Overloading & Overriding
These are the two ways methods of the same name can exist, but they utilize different "bindings" (when Java decides which method to run).

### A. Method Overloading (Compile-Time Polymorphism)
Overloading occurs when two or more methods in the same class share the **same name** but have **different parameter lists** (number, type, or order of parameters).

*   **Goal:** Readability. You don't need `addInts()`, `addFloats()`, `addDoubles()`. You just need `add()`.
*   **Return Type:** Changing *only* the return type is not sufficient for overloading.
*   **Binding:** The compiler decides which method to call based on the arguments you pass.

```java
public class Calculator {
    // 1. Basic addition
    public int add(int a, int b) {
        return a + b;
    }

    // 2. Overloaded: Different parameter types
    public double add(double a, double b) {
        return a + b;
    }

    // 3. Overloaded: Different number of parameters
    public int add(int a, int b, int c) {
        return a + b + c;
    }
}
```

### B. Method Overriding (Runtime Polymorphism)
Overriding occurs when a **child class (subclass)** provides a specific implementation of a method that is already declared in its **parent class (superclass)**.

*   **Goal:** To define behavior that is specific to the subclass type.
*   **Rules:**
    1.  Same name, same parameters, same return type (or covariant return type).
    2.  Access level cannot be more restrictive (e.g., if parent is `public`, child cannot be `private`).
    3.  Cannot override `static` or `final` methods.
*   **Annotation:** Always use `@Override`. It tells the compiler to check if you are actually overriding something. If you made a typo, the compiler will error out, saving you bugs.

```java
class Animal {
    void makeSound() {
        System.out.println("Generic animal noise");
    }
}

class Dog extends Animal {
    @Override
    void makeSound() {
        System.out.println("Bark");
    }
}
```

---

## 2. Dynamic Dispatch & Late Binding
This is the "Magic" behind how Java handles Overriding.

### The Concept
When you write code, you often refer to an object by its **Parent Type**, but the object acts like its **Child Type**.

```java
// Reference is Animal (Parent), Object is Dog (Child)
Animal myPet = new Dog(); 
myPet.makeSound(); 
```

### Static vs. Dynamic Binding
1.  **Static Binding (Early Binding):** Used for **Overloading**, `static` methods, `private` methods, and `final` methods. The compiler knows exactly which line of code to jump to before the program runs.
2.  **Dynamic Binding (Late Binding):** Used for **Overriding**. The compiler looks at `myPet.makeSound()` and thinks, "Okay, this is an Animal." However, at **Runtime**, the JVM looks at the actual object in memory (heap), sees it is a `Dog`, and calls the Dog's version of `makeSound`.

**Why is this useful?**
It allows you to write generic code that handles new types without changing the code.
```java
List<Animal> zoo = List.of(new Dog(), new Cat(), new Lion());

for (Animal a : zoo) {
    a.makeSound(); // The loop doesn't care WHAT animal it is.
                   // Polymorphism ensures the correct sound is played.
}
```

---

## 3. Abstract Classes and Methods
An `abstract` class is a class that **cannot be instantiated** on its own. It is meant to be a parent class for other classes.

### When to use it?
Use an Abstract Class when you want to share code among several closely related classes (fields, non-abstract methods) but also force them to implement specific custom logic.

### Abstract Methods
Methods declared without an implementation (no body `{}`).
*   If a class has at least one abstract method, the class must be declared `abstract`.
*   Child classes **must** override/implement all abstract methods (unless the child is also abstract).

```java
// Abstract Class
abstract class Shape {
    String color; // Concrete Field (State)

    // Concrete Method (Shared logic)
    void setColor(String color) {
        this.color = color;
    }

    // Abstract Method (MUST be implemented by children)
    // We can't calculate area unless we know the shape.
    abstract double calculateArea();
}

class Circle extends Shape {
    double radius;

    @Override
    double calculateArea() {
        return Math.PI * radius * radius;
    }
}
```

---

## 4. Interfaces and Functional Interfaces

### A. Interfaces
An interface is a **contract**. It defines *what* a class can do, without declaring *how* to do it (mostly). Unlike abstract classes, interfaces cannot hold state (instance variables), only constants (`public static final`).

*   A class can extend only **one** class (Abstract or Concrete).
*   A class can implement **multiple** interfaces.

**Modern Interface Features (Java 8/9+):**
Traditionally, interfaces only had abstract methods. Now they can have:
1.  **Default Methods:** Methods with a body (using keyword `default`). Allows adding new methods to interfaces without breaking existing implementations.
2.  **Static Methods:** Utility methods inside the interface.
3.  **Private Methods (Java 9):** To share code between default methods within the interface.

```java
interface Flyable {
    // Constant
    int MAX_SPEED = 100; // implicitly public static final

    // Abstract Method
    void fly();

    // Default Method (optional to override)
    default void checkWind() {
        System.out.println("Checking wind conditions...");
    }
}
```

### B. Functional Interfaces
A Functional Interface is an interface that contains **exactly one abstract method**.

*   They can have multiple `default` or `static` methods, but only **one** single abstract method (SAM).
*   **Significance:** They are the target type for **Lambda Expressions** and **Method References** introduced in Java 8.
*   **Annotation:** `@FunctionalInterface` (ensures compilation error if you add a second abstract method).

**Example:**
```java
@FunctionalInterface
interface Greeting {
    void sayHello(String name);
}

// Usage with Lambda
public class Main {
    public static void main(String[] args) {
        // Implementing the interface using a Lambda
        Greeting greet = (name) -> System.out.println("Hello, " + name);
        
        greet.sayHello("Java Developer");
    }
}
```

### Summary: Abstract Class vs. Interface

| Feature | Abstract Class | Interface |
| :--- | :--- | :--- |
| **Inheritance** | Single (`extends`) | Multiple (`implements`) |
| **Fields** | Can have any variables (state) | Only `public static final` constants |
| **Methods** | Abstract or Concrete | Abstract, Default, Static, Private |
| **Purpose** | Share implementation code; "Is-A" relationship | Define a contract/capabilities; "Can-Do" relationship |
