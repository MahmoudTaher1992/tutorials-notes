Here is a detailed explanation of **Part II, Section E: Scope and Lifetime of Variables**.

In Java, understanding variables isn't just about declaring them; it’s about knowing **where** you can use them (Scope) and **how long** they stay alive in memory (Lifetime).

---

### 1. Categories of Variables
Java categorizes variables into three types based on where they are declared. This determines their scope and lifetime.

#### A. Local Variables
*   **Definition:** Variables declared inside a method, constructor, or a specific block of code (like an `if` statement or `for` loop).
*   **Scope (Visibility):** They are only visible inside the block `{ ... }` where they are declared. Once the code execution leaves that block, the variable is inaccessible.
*   **Lifetime:** They are created when the execution enters the block and destroyed (popped off the Stack memory) immediately when the block finishes.
*   **Key Constraint:** They do **not** imply any default value (see section 2 below).

```java
public void calculate() {
    // 'result' is a LOCAL variable
    int result = 10; 

    if (result > 5) {
        // 'message' is local to this IF block
        String message = "Success"; 
        System.out.println(message);
    }
    
    // System.out.println(message); // ERROR: 'message' does not exist here
}
```

#### B. Instance Variables (Non-Static Fields)
*   **Definition:** Variables declared inside a class but *outside* any method. They do **not** use the keyword `static`.
*   **Scope:** They belong to a specific **Object** (an instance of the class). They can be accessed by all methods within that class.
*   **Lifetime:** They are created when you create a new object (using `new ClassName()`) and live in the Heap memory. They are destroyed only when the object is Garbage Collected.

```java
public class User {
    // 'username' is an INSTANCE variable
    String username; 

    public void login() {
        // We can access 'username' here because it belongs to the object
        System.out.println("User " + username + " logged in.");
    }
}
```

#### C. Class Variables (Static Fields)
*   **Definition:** Variables declared inside a class with the `static` keyword.
*   **Scope:** They belong to the **Class itself**, not individual objects. All objects share the *exact same copy* of this variable.
*   **Lifetime:** They are created when the program starts (when the ClassLoader loads the class) and destroyed only when the program stops.
*   **Use Case:** Constants, counters shared across users (e.g., `totalUsers`), or configuration settings.

```java
public class Constants {
    // 'APP_NAME' is a CLASS variable. Every part of the app sees the same value.
    public static final String APP_NAME = "MyBankingApp";
}
```

---

### 2. Initialization and Default Values

One of the most common sources of bugs for beginners is misunderstanding how Java initializes variables.

#### The "Default Value" Rule
If you declare a variable but do not assign it a value (e.g., `int x;`), specific rules apply based on the variable type:

*   **Instance & Global Variables:** Java **automatically assigns** a default value.
    *   `int`, `byte`, `short`, `long` $\rightarrow$ `0`
    *   `double`, `float` $\rightarrow$ `0.0`
    *   `boolean` $\rightarrow$ `false`
    *   `Object` (String, User, etc.) $\rightarrow$ `null`
*   **Local Variables:** Java **does NOT** assign a default value. You must initialize them before use, or you will get a compile-time error ("Variable might not have been initialized").

**Example:**
```java
public class Test {
    int instanceVar; // Will automatically be 0

    public void show() {
        int localVar; 
        
        System.out.println(instanceVar); // Valid: prints 0
        // System.out.println(localVar); // ERROR: Compilation fails! localVar is empty.
    }
}
```

---

### 3. Variable Shadowing

Shadowing occurs when variables in different scopes have the **same name**. The variable in the "closer" or "narrower" scope hides the variable in the outer scope.

#### How it works:
If you have a global variable named `salary` and a local variable inside a function also named `salary`, the computer will use the local one by default inside that function.

#### How to bypass it:
*   To refer to the Instance variable, use `this.variableName`.
*   To refer to the Static variable, use `ClassName.variableName`.

**Example:**
```java
public class Employee {
    int salary = 5000; // Instance variable

    public void setSalary(int salary) {
        // Here, the 'salary' parameter (local) SHADOWS the instance variable.
        
        System.out.println(salary); // Prints the parameter passed in
        
        // To assign the parameter value to the instance variable, we use 'this':
        this.salary = salary; 
    }
}
```

---

### Summary Table

| Feature | Local Variable | Instance Variable | Class (Static) Variable |
| :--- | :--- | :--- | :--- |
| **Declaration** | Inside method/block | Inside class, no `static` | Inside class, with `static` |
| **Scope** | Only within the block `{}` | Within the Class | Global to the Class |
| **Lifetime** | Method execution time | Object's life | Application's life |
| **Storage** | Stack Memory | Heap Memory | Metaspace / Method Area |
| **Default Value?**| **NO** (Must initialize) | **YES** (e.g., 0, null) | **YES** (e.g., 0, null) |
| **Access Syntax**| Direct name | `obj.name` or `this.name` | `ClassName.name` |
