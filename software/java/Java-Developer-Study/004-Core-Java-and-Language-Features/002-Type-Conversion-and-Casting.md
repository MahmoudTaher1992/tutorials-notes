Here is a detailed explanation of **Type Conversion and Casting** in Java. This is a fundamental concept because Java is a **strongly typed language**, meaning every variable must have a declared type, and Java is strict about how different types interact.

---

# 002 - Type Conversion and Casting

In Java, type conversion is the process of converting a value from one data type to another. There are two main categories:
1.  **Primitive Casting:** Converting between numbers (e.g., `int` to `long`).
2.  **Reference (Object) Casting:** Converting between class types in an inheritance hierarchy (e.g., `Object` to `String`).

---

## 1. Primitive Type Conversion

This deals with the 8 primitive data types (specifically the numeric ones: `byte`, `short`, `int`, `long`, `float`, `double` and `char`).

### A. Implicit Conversion (Widening Casting)
This happens **automatically** when you convert a "smaller" type to a "larger" type size. It is safe because there is no risk of losing data (the big bucket can easily hold the contents of the small bucket).

**The Flow:**
`byte` → `short` → `int` → `long` → `float` → `double`

*Note: `char` can be implicitly cast to `int`.*

**Example:**
```java
public class WideningExample {
    public static void main(String[] args) {
        int myInt = 9;
        
        // Automatic casting: int to double
        double myDouble = myInt; 

        System.out.println(myInt);      // Outputs 9
        System.out.println(myDouble);   // Outputs 9.0
    }
}
```

### B. Explicit Conversion (Narrowing Casting)
This must be done **manually** by placing the type in parentheses `()` in front of the value. This is required when converting a "larger" type to a "smaller" type size.

**Why is it manual?**
Because you might lose data (truncation) or precision. You are forcing a big bucket into a small bucket; Java requires you to sign off on the risk.

**The Flow:**
`double` → `float` → `long` → `int` → `char` → `short` → `byte`

**Example:**
```java
public class NarrowingExample {
    public static void main(String[] args) {
        double myDouble = 9.78d;
        
        // Manual casting: double to int
        // The decimal part .78 is LOST (Truncated, not rounded)
        int myInt = (int) myDouble; 

        System.out.println(myDouble);   // Outputs 9.78
        System.out.println(myInt);      // Outputs 9
    }
}
```

**The Overflow Trap (Byte wrap-around):**
If you cast a number larger than the target type can hold, it wraps around (overflows).
```java
int largeNum = 130;
byte smallNum = (byte) largeNum; 
// byte range is -128 to 127.
// 130 wraps around to -126. This produces unexpected bugs!
```

---

## 2. Reference (Object) Casting

This deals with objects and classes. You can only cast between objects that are related through **inheritance** (Parent/Child relationship).

### A. Upcasting (Implicit)
Treating a specific object (Child) as a generic object (Parent). This is always safe and happens automatically (polymorphism).

```java
String myString = "Hello";
Object myObject = myString; // Upcasting (Automatic)
// Every String IS optionally an Object, so this is safe.
```

### B. Downcasting (Explicit)
Treating a generic reference (Parent) as a specific type (Child). This requires explicit casting syntax and is risky.

**Why is it risky?**
The compiler knows the variable type, but it doesn't know what object is *actually* sitting in memory at runtime.

```java
Object myObj = "Hello World";

// Manual casting: Object back to String
String myStr = (String) myObj; // Safe here, because myObj is ACTUALLY a string.
```

### The Risk: `ClassCastException`
If you try to downcast an object to a type it *isn't*, the code compiles fine, but crashes at runtime.

```java
Object myObj = new Integer(100);

// Compiles? Yes. (Because Integer is a Child of Object)
// Runs? No. Crashes with ClassCastException.
String myStr = (String) myObj; 
```
*Analogy: You can label a "Dog" as an "Animal" (Upcasting), but you cannot force an "Animal" label onto a "Cat" and expect it to bark (Downcasting error).*

### The Solution: `instanceof`
Before downcasting, always check the type using the `instanceof` operator to prevent crashes.

```java
Object myObj = 100;

if (myObj instanceof String) {
    String s = (String) myObj; // Safe
    System.out.println("It's a string!");
} else {
    System.out.println("Not a string, cannot cast.");
}
```

---

## 3. Special Case: Automatic Type Promotion

In Java expressions (math operations), types shorter than `int` (like `byte`, `short`, `char`) are **automatically promoted to `int`** before the calculation happens.

**Example of a common error:**
```java
byte a = 10;
byte b = 20;

// Error: incompatible types: possible lossy conversion from int to byte
byte c = a + b; 
```

**Why creates an error?**
Even though `a` and `b` are bytes, Java calculates `a + b` as an **`int`**. To fix this, you must cast the result back to byte:
```java
byte c = (byte) (a + b);
```

---

## 4. What about String conversion?

Beginners often confuse Casting with Parsing. You **cannot** cast a `String` to an `int`.

```java
String s = "123";
int x = (int) s; // COMPILER ERROR
```

Since `String` and `int` are not in the same inheritance hierarchy (one is an Object, one is a primitive), you cannot cast them. You must use **Wrapper Class Parsing methods**:

```java
String s = "123";
int x = Integer.parseInt(s); // Correct way
```

---

## Summary Checklist

1.  **Widening (Primitive):** Small to Large. Automatic. Safe.
2.  **Narrowing (Primitive):** Large to Small. Manual `(type)`. Risky (Data loss).
3.  **Upcasting (Object):** Child to Parent. Automatic. Safe (Polymorphism).
4.  **Downcasting (Object):** Parent to Child. Manual `(type)`. Risky (`ClassCastException`).
5.  **`instanceof`:** The safety check you should use before Downcasting.
