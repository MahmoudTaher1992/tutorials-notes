Here is a detailed explanation of the **Generics** section from your Java study roadmap.

Generics (introduced in Java 5) are one of the most powerful features of the Java language. They allow you to write strong, type-safe code while maintaining the ability to reuse logic across different data types.

---

# 004-Generics: Detailed Breakdown

## 1. The "Why": The Problem with Raw Types
Before Generics, collections in Java worked with the `Object` type. This led to two major problems:
1.  **Lack of Type Safety:** You could accidentally add an `Integer` to a list intended for `String`s.
2.  **Explicit Casting:** You always had to cast objects when retrieving them, which made code verbose and error-prone.

**Example (Pre-Generics):**
```java
List list = new ArrayList(); // Valid, but "Raw"
list.add("Hello");
list.add(123); // Compiler allows this

String s = (String) list.get(0); // Manual cast needed
String x = (String) list.get(1); // Throws ClassCastException at RUNTIME! 💥
```

**With Generics:**
```java
List<String> list = new ArrayList<>();
list.add("Hello");
// list.add(123); // Compiler Error! Code won't build. Safety assured. 🛡️

String s = list.get(0); // No cast needed.
```

---

## 2. Generic Classes, Interfaces, and Methods

### A. Generic Classes
You can define a class that handles any type of data by using a **Type Parameter** (usually denoted as `<T>`).

```java
// T stands for "Type"
public class Box<T> {
    private T value;

    public void set(T value) { this.value = value; }
    public T get() { return value; }
}

// Usage:
Box<Integer> intBox = new Box<>();
intBox.set(10);

Box<String> strBox = new Box<>();
strBox.set("Hello");
```
*Common Naming Conventions:*
*   `T` - Type
*   `E` - Element (used by Collections)
*   `K` - Key, `V` - Value (used by Maps)

### B. Generic Methods
You can define a single method as generic without making the whole class generic. The `<T>` goes *before* the return type.

```java
public class Printer {
    // This method can print an array of any type
    public <T> void printArray(T[] array) {
        for(T element : array) {
            System.out.println(element);
        }
    }
}
```

---

## 3. Bounded Types (`<T extends Class>`)
Sometimes you want to be generic, but not *too* generic. You might want to write a method that calculates numbers, so accepting a `String` makes no sense.

**Bounded Types** restrict the generic variable to being a specific class or a subclass of it.

```java
// T must be a specific class (Number) or its subclass (Integer, Double, etc.)
public class Calculator<T extends Number> {
    public double square(T num) {
        // Because T extends Number, we are allowed to call .doubleValue()
        return num.doubleValue() * num.doubleValue();
    }
}
```
*   **Multiple Bounds:** `<T extends Number & Comparable<T>>`
    *   *Note:* Classes must come first, followed by interfaces.

---

## 4. Wildcards (`?`)
Wildcards are used when referring to a generic type where you don't know exactly what the type is yet, often used in method parameters.

### A. Unbounded Wildcards (`List<?>`)
"A list of unknown things." You can read from it (as Objects), but you cannot write to it (because Java doesn't know what type is allowed).

```java
public void printList(List<?> list) {
    for (Object elem : list) {
        System.out.println(elem);
    }
    // list.add("test"); // ERROR: We don't know if this is a List<String> or List<Integer>
}
```

### B. Upper Bounded Wildcards (`? extends Class`)
"This list holds `Class` or its **children**."
*   **Use Case:** When you only want to **READ** (Consume in the method).
*   *Mnemonic:* **Producer Extends**. The collection produces data.

```java
// Accepts List<Number>, List<Integer>, List<Double>
public double sumBox(List<? extends Number> list) {
    double sum = 0;
    for (Number n : list) {
        sum += n.doubleValue();
    }
    return sum;
}
```

### C. Lower Bounded Wildcards (`? super Class`)
"This list holds `Class` or its **parents**."
*   **Use Case:** When you want to **WRITE** (Add to the collection).
*   *Mnemonic:* **Consumer Super**. The collection consumes data.

```java
// Accepts List<Integer>, List<Number>, List<Object>
public void addNumbers(List<? super Integer> list) {
    list.add(10); // Safe because Integer is a subclass of whatever is in the list
}
```

---

## 5. Type Erasure
This is a critical concept for interviews.

Java Generics are a **compile-time** feature. The Java Virtual Machine (JVM) does not actually know about generics. When you compile code:
1.  The compiler checks types to ensure safety.
2.  The compiler **erases** the types and replaces them with `Object` (or the bound, like `Number`).
3.  The compiler inserts the necessary type casts automatically.

**Code you write:**
```java
List<String> list = new ArrayList<>();
list.add("Hi");
String s = list.get(0);
```

**Code the JVM actually executes (after Erasure):**
```java
List list = new ArrayList(); // Raw type
list.add("Hi");
String s = (String) list.get(0); // Auto-cast inserted
```

### Limitations caused by Erasure:
Because the type `T` does not exist at runtime:
1.  **No Primitives:** You cannot do `List<int>`. You must use wrappers `List<Integer>`.
2.  **No Instantiation:** You cannot do `new T()`.
3.  **No Arrays of Generics:** You cannot do `new List<String>[10]`.
4.  **No `instanceof`:** You cannot check `if (obj instanceof T)`.

---

## Summary Checklist for Study
1.  **Syntax:** Can you declare a Generic Class (`Box<T>`) and a Generic Method?
2.  **Benefits:** Can you explain Type Safety vs. Raw types?
3.  **PECS:** Do you understand "Producer Extends, Consumer Super" regarding Wildcards?
4.  **Erasure:** Can you explain why `List<Integer>` looks like `List<Object>` to the JVM?
