Based on the Table of Contents provided, here is a detailed explanation of **Part II, Section B: Data Types and Variables**.

In Java, data types are the foundation of the language because Java is **Statically Typed**. This means every variable must have a declared type (or an inferred one) before you can use it, and that type cannot change once the program is running.

Here is the breakdown of the three key components in this section.

---

### 1. Primitive Types
Primitive types are the most basic data types in Java. They contain pure values (not objects), are stored directly on the stack memory (which makes them very fast), and have no methods associated with them.

There are exactly **8 primitive types** in Java, categorized into four groups:

#### A. Integers (Whole Numbers)
Used for numbers without decimals.
*   **`byte`**: The smallest integer. Size: 8-bit. Range: -128 to 127. Used mostly for raw binary data or file I/O to save memory.
*   **`short`**: Size: 16-bit. Range: -32,768 to 32,767. Rarely used today.
*   **`int`**: Size: 32-bit. **The default choice** for whole numbers in Java. Range: approx -2 billion to +2 billion.
*   **`long`**: Size: 64-bit. Used when `int` is not big enough (e.g., timestamps, global IDs). You must suffix the value with an `L` (e.g., `100000L`).

#### B. Floating Point (Decimal Numbers)
Used for numbers with fractions.
*   **`float`**: Size: 32-bit single precision. Ends with an `f` (e.g., `3.14f`). Less precise; rarely used unless memory is critical or using specific graphics libraries.
*   **`double`**: Size: 64-bit double precision. **The default choice** for decimals in Java.

#### C. Characters
*   **`char`**: Size: 16-bit Unicode character. Holds a single character enclosed in single quotes (e.g., `'A'`). It essentially functions like an unsigned integer behind the scenes.

#### D. Boolean
*   **`boolean`**: Represents truth values. can only be `true` or `false`. (It cannot be 0 or 1 like in C++).

**Example:**
```java
int userAge = 25;
double accountBalance = 100.50;
boolean isActive = true;
char grade = 'A';
long earthPopulation = 7_800_000_000L; // Underscores used for readability
```

---

### 2. Wrapper Classes
Java is an Object-Oriented language, but primitives are *not* objects. This creates a problem when using Java Collections (like `ArrayList`, `HashMap`) because collections can only store Objects.

To solve this, Java provides **Wrapper Classes**. These are Object representations of the 8 primitives. They wrap the primitive value inside a class object, stored on the Heap.

| Primitive | Wrapper Class |
| :--- | :--- |
| `int` | `Integer` |
| `char` | `Character` |
| `byte` | `Byte` |
| `boolean` | `Boolean` |
| `double` | `Double` |
| ...and so on | |

#### Key Concepts:
1.  **Utility Methods:** Wrapper classes provide helper methods (e.g., converting a String to a number).
    ```java
    String quantity = "50";
    int converted = Integer.parseInt(quantity); // "50" gets converted to primitive 50
    ```
2.  **Null Ability:** Primitives cannot be `null` (they default to 0 or false). Wrapper classes *can* be `null` because they are objects.
3.  **Autoboxing and Unboxing:**
    *   **Autoboxing:** Java automatically converts a primitive to its Wrapper.
    *   **Unboxing:** Java automatically converts a Wrapper back to a primitive.

**Example:**
```java
// Primitives are efficient
int a = 5; 

// WRONG: Collections cannot store primitives
// ArrayList<int> list = new ArrayList<>(); 

// CORRECT: Use the Wrapper Class
ArrayList<Integer> list = new ArrayList<>();

list.add(10); // Autoboxing: Java turns int 10 into Integer(10) implicitly
int num = list.get(0); // Unboxing: Java extracts int 10 from the Integer object
```

---

### 3. Type Inference (`var`) (Java 10+)
Historically, Java was very verbose (`String name = "John"`). In Java 10, the `var` keyword was introduced to reduce boilerplate code.

*   **How it works:** You use `var` instead of the data type. The compiler looks at the value on the right side of the `=` and "infers" (guesses) the type.
*   **It is NOT dynamic:** This is not like JavaScript's `var` or `let`. Once Java decides the variable is a String, it is a String forever. You cannot change the type later.

#### Rules for `var`:
1.  **Local Variables Only:** You can only use it inside methods. You cannot use it for class fields (variables declared at the class level).
2.  **Must Initialize Immediately:** You cannot say `var x;` and define it later, because the compiler won't know what type it is.

**Example:**

```java
// explicit typing (Old way)
String message = "Hello World";
ArrayList<String> names = new ArrayList<String>();

// Type Inference (New way)
var message = "Hello World"; // Compiler knows this is a String
var names = new ArrayList<String>(); // Compiler knows this is an ArrayList

// This throws an error! 
// message = 100; // Error: message was inferred as String, cannot hold int.
```

### Summary Comparison

| Concept | Description | Memory | Key Use Case |
| :--- | :--- | :--- | :--- |
| **Primitive** | Basic value (`int`, `double`) | Stack (Fast) | Math, loops, logic |
| **Wrapper** | Object version (`Integer`) | Heap (Slower) | Inside Collections (`List`, `Map`), handling nulls |
| **`var`** | Syntax sugar for inference | N/A | Reducing code verbosity for local variables |
