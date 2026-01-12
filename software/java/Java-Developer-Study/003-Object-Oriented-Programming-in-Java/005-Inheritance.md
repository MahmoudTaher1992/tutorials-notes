Based on the Table of Contents you provided, here is a detailed explanation of **Part III, Section E: Inheritance**.

---

# 003-Object-Oriented-Programming-in-Java / 005-Inheritance.md

Inheritance is one of the four pillars of Object-Oriented Programming (OOP). It is the mechanism by which one class (the **Child** or **Subclass**) acquires the properties (fields) and behaviors (methods) of another class (the **Parent** or **Superclass**).

**Core Concept:** It represents an **"IS-A"** relationship.
*   *Example:* A `Dog` **IS-A** `Animal`. A `Car` **IS-A** `Vehicle`.

Here is the breakdown of the specific topics in that section:

---

### 1. Basic Inheritance (`extends`)

To create a subclass in Java, you use the `extends` keyword. When a class extends another, it automatically gets access to all non-private members of the parent class.

*   **Code Stability:** You write the common code once in the parent, and all children reuse it.
*   **Single Inheritance:** In Java, a class can define only **one** parent class (e.g., `class A extends B`). You cannot say `class A extends B, C`.

**Example:**
```java
// Parent Class (Superclass)
class Animal {
    String name;

    public void eat() {
        System.out.println("This animal is eating.");
    }
}

// Child Class (Subclass)
// Dog inherits 'name' and 'eat()' from Animal
class Dog extends Animal {
    public void bark() {
        System.out.println("Woof! Woof!");
    }
}

public class Main {
    public static void main(String[] args) {
        Dog myDog = new Dog();
        myDog.name = "Buddy"; // Inherited field
        myDog.eat();          // Inherited method
        myDog.bark();         // Specific method
    }
}
```

---

### 2. Method Overriding (`@Override`)

Sometimes, the generic behavior provided by the parent class isn't specific enough for the child class. The child class can provide its own implementation of that method. This is called **Overriding**.

*   **Rules:** The method name, return type, and parameters must match the parent's method exactly.
*   **The `@Override` Annotation:** Always place `@Override` above the method in the child class. It tells the compiler "I intend to change a parent method." If you make a typo in the method name, the compiler will throw an error (which creates safety).

**Example:**
```java
class Animal {
    public void makeSound() {
        System.out.println("Some generic animal sound");
    }
}

class Cat extends Animal {
    @Override
    public void makeSound() {
        System.out.println("Meow");
    }
}

class Dog extends Animal {
    @Override
    public void makeSound() {
        System.out.println("Bark");
    }
}
```

---

### 3. `super` Keyword and Constructor Chaining

The `super` keyword is a reference variable used to refer to the immediate parent class object. It is used for two main purposes:

#### A. Accessing Parent Methods/Fields
If a child overrides a method but still needs to call the original parent version, it uses `super`.

```java
class Dog extends Animal {
    @Override
    public void makeSound() {
        super.makeSound(); // Calls Animal's version first ("Some generic sound")
        System.out.println("Bark"); // Then adds Dog's version
    }
}
```

#### B. Constructor Chaining (`super()`)
When you create an object of a Child class (e.g., `new Dog()`), **Java must initialize the Parent class first.**

*   **Implicit Call:** If you don't write any constructor code, Java effectively puts `super()` (the no-argument parent constructor) as the very first line of your child constructor.
*   **Explicit Call:** If the parent class **does not** have a default (no-argument) constructor (i.e., it only has a constructor that takes parameters), the child class **must explicitly call `super(arguments)`**.

**Example:**
```java
class Person {
    String name;

    // Parent constructor
    Person(String name) {
        this.name = name;
        System.out.println("Person constructor called");
    }
}

class Employee extends Person {
    int employeeId;

    // Child constructor
    Employee(String name, int employeeId) {
        // MUST be the first line
        super(name); 
        this.employeeId = employeeId;
        System.out.println("Employee constructor called");
    }
}
```

---

### 4. Multiple Inheritance & Interfaces

This is a common interview topic.

**The Problem:** Java **does not** support Multiple Inheritance for classes.
*   *Why?* The "Diamond Problem." If Class A has a method `run()`, and Class B has a method `run()`, and Class C extends both A and B... which `run()` does Class C execute? To avoid this ambiguity, Java forbids `class C extends A, B`.

**The Solution:** Java allows a class to implement **multiple Interfaces**.
*   An Interface is like a contract. It defines *what* a class should do, but (usually) not *how*.
*   A class can extend **one** parent class, but implement **many** interfaces.

**Structure:**
```java
class Child extends Parent implements Interface1, Interface2 { ... }
```

**Example:**
```java
interface Swimmable {
    void swim();
}

interface Flyable {
    void fly();
}

// Duck inherits biology from Animal, but capabilities from interfaces
class Duck extends Animal implements Swimmable, Flyable {
    @Override
    public void swim() {
        System.out.println("Duck works hard paddling.");
    }

    @Override
    public void fly() {
        System.out.println("Duck takes flight.");
    }
}
```

---

### Summary Checklist for this Section
1.  **Inheritance:** Uses `extends`. Creates "IS-A" relationship. Reuse code.
2.  **Access:** Private members of Parent are **not** directly accessible by Child (unless using getters/setters). `Protected` members are accessible.
3.  **Overriding:** Changing parent behavior in child. Use `@Override`.
4.  **`super`:** Used to access Parent constructors or hidden Parent methods.
5.  **Multi-Inheritance:** Not allowed with classes; achieved via Interfaces.
