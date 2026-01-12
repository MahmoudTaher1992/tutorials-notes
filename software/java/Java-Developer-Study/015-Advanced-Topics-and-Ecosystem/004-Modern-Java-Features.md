This section of your roadmap focuses on the significant evolution Java has undergone since Java 8. Starting with Java 9 (modules) and accelerating with the 6-month release cycle (Java 10+), the language has introduced features to reduce "boilerplate" code, improve readability, and support functional programming styles.

Here is a detailed explanation of the four specific items listed in your TOC: **Records**, **Switch Expressions**, **Pattern Matching**, and **Sealed Classes**.

---

### 1. Records (Java 14 preview, Java 16 standard)

**The Problem:**
Historically, creating a simple "data carrier" class (like a DTO - Data Transfer Object) required a lot of verbose code. You had to write private fields, public getters, a constructor, and override `equals()`, `hashCode()`, and `toString()`.

**The Solution:**
**Records** are a compact syntax for declaring classes that are transparent holders for shallowly immutable data.

*   **Immutability:** Fields are `private final` by default.
*   **Boilerplate-free:** Java automatically generates definitions for `equals`, `hashCode`, `toString`, accessors (getters), and the constructor.

**Code Example:**

```java
// OLD WAY: Verbose
public class Person {
    private final String name;
    private final int age;

    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
    // ... plus getters, equals, hashCode, toString ...
}

// MODERN WAY: Records
public record Person(String name, int age) {}
// That's it! You can now do:
// Person p = new Person("Alice", 30);
// System.out.println(p.name()); // Note: accessor is name(), not getName()
```

---

### 2. Switch Expressions (Java 12 preview, Java 14 standard)

**The Problem:**
The traditional `switch` statement was clunky. It required `break` statements to prevent "fall-through" bugs, and it was a *statement*, meaning it couldn't return a value directly into a variable.

**The Solution:**
**Switch Expressions** allow you to use `switch` to compute a value. It adds a new arrow syntax (`->`) that eliminates the need for `break`.

**Key Features:**
*   Returns a result.
*   No fall-through logic with the `->` syntax.
*   Can handle multiple cases in one line.

**Code Example:**

```java
// OLD WAY: Switch Statement
String dayType;
switch (day) {
    case MONDAY:
    case TUESDAY:
    case WEDNESDAY:
    case THURSDAY:
    case FRIDAY:
        dayType = "Weekday";
        break;
    case SATURDAY:
    case SUNDAY:
        dayType = "Weekend";
        break;
    default:
        throw new IllegalArgumentException("Invalid day: " + day);
}

// MODERN WAY: Switch Expression
String dayType = switch (day) {
    case MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY -> "Weekday";
    case SATURDAY, SUNDAY -> "Weekend";
};
```

---

### 3. Pattern Matching (Introduced incrementally Java 14-21)

 **The Problem:**
 When checking an object's type, we usually follow a check with a cast. This is repetitive and error-prone.

#### A. Pattern Matching for `instanceof` (Java 16)
This combines the type check and the casting into a single step.

```java
Object obj = "Hello World";

// OLD WAY
if (obj instanceof String) {
    String s = (String) obj; // Manual casting
    System.out.println(s.toLowerCase());
}

// MODERN WAY
if (obj instanceof String s) {
    // 's' is already cast and available here
    System.out.println(s.toLowerCase());
}
```

#### B. Pattern Matching for `switch` (Java 21)
This allows you to switch on Types, not just values (like ints, Strings, or Enums). It replaces long chains of `if-else-if`.

```java
Object obj = 123;

String result = switch (obj) {
    case Integer i -> "It is an integer: " + i;
    case String s  -> "It is a string: " + s.toLowerCase();
    case null      -> "It is null";
    default        -> "Unknown type";
};
```

#### C. Record Patterns (Java 21)
This allows you to verify a type AND extract its data (deconstruction) in one step.

```java
record Point(int x, int y) {}

Object obj = new Point(10, 20);

if (obj instanceof Point(int x, int y)) {
    // We checked the type AND extracted x and y into variables automatically
    System.out.println("X is " + x + ", Y is " + y);
}
```

---

### 4. Sealed Classes (Java 15 preview, Java 17 standard)

**The Problem:**
In standard OOP, inheritance is "open." If you make a class public, *anyone* can extend it. Sometimes (especially in API design or domain modeling), you want to define exactly which classes are allowed to be children of a parent class.

**The Solution:**
**Sealed Classes** (or Interfaces) restrict which other classes may extend or implement them. This gives you fine-grained control over your inheritance hierarchy.

**How it works:**
1.  Use the `sealed` modifier.
2.  Use the `permits` clause to list allowed subclasses.
3.  The subclasses must be `final`, `sealed`, or `non-sealed`.

**Code Example:**

```java
// Only Circle and Square are allowed to be Shapes.
// No one else can create a 'Triangle' without modifying this file.
public sealed interface Shape permits Circle, Square {}

public final class Circle implements Shape { ... }
public final class Square implements Shape { ... }
```

**Why is this powerful?**
It pairs perfectly with **Pattern Matching for Switch**. Because the compiler knows *exactly* which subclasses exist, it can check for **exhaustiveness**. You don't need a `default` case if you handle `Circle` and `Square`, because the compiler knows those are the only possibilities.

---

### Summary of How They Work Together

Modern Java features often combine to create very clean, declarative code. Here is an example combining `Records`, `Sealed Interfaces`, and `Switch Expressions`:

```java
// 1. Sealed Interface
sealed interface Result permits Success, Failure {}

// 2. Records representing the states
record Success(String data) implements Result {}
record Failure(Exception error) implements Result {}

// ... somewhere in your code ...
Result response = new Success("Data Loaded");

// 3. Switch Expression with Pattern Matching
String message = switch (response) {
    case Success(String data) -> "Yay! " + data;   // Record Pattern
    case Failure(Exception e) -> "Oops: " + e.getMessage();
    // No default needed because Interface is Sealed!
};
```
