Based on the study roadmap you provided, here is a detailed explanation of **Part II, Section A: Syntax & Core Concepts**.

This section serves as the "grammar" lesson for the Java language. Just as you need to know how to construct sentences and paragraphs to write English, you need to understand Structure, Statements, and Naming to write Java.

---

# 002-Java-Language-Fundamentals / 001-Syntax-and-Core-Concepts.md

## 1. Java Program Structure & File Organization
In Java, code is not just written strictly top-to-bottom like a script; it is organized into **Classes** and **Packages**.

### The Rules of the File:
1.  **Everything lives in a Class:** Java is completely Object-Oriented. Every line of executable code you write must be inside a `class`.
2.  **The "One Public Class" Rule:** A generic `.java` source file can contain multiple classes, but it can only contain **one** `public` class.
3.  **Filename Matching:** The name of the file **must** match the name of the `public` class exactly (including capitalization).
    *   *Example:* If your class is `public class MyFirstApp`, the file must be named `MyFirstApp.java`.

### The Anatomy of a Java File:
A standard Java file follows this specific order:
1.  **Package Declaration** (Optional but recommended): Tells Java which folder/namespace this file belongs to.
2.  **Import Statements**: Brings in code from other packages so you can use it (e.g., `import java.util.Scanner;`).
3.  **Class Definition**: The meat of your code.
4.  **Main Method**: The entry point where the application starts running.

**Example:**
```java
// 1. Package Declaration
package com.example.basics; 

// 2. Imports
import java.util.Date; 

// 3. Class Definition
public class ProgramStructure { 

    // 4. The Main Method (The entry point)
    public static void main(String[] args) {
        System.out.println("Hello, Java!");
    }
}
```

---

## 2. Statements, Expressions, and Blocks
These are the building blocks of logic within your methods.

### A. Expressions (The Phrases)
An expression is a construct of variables, operators, and method invocations that **evaluates to a single value**.
*   *Think of this as a fragment of a sentence.*
*   **Examples:**
    *   `1 + 2` (Evaluates to `3`)
    *   `"Hello " + "World"` (Evaluates to `"Hello World"`)
    *   `x > y` (Evaluates to `true` or `false`)

### B. Statements (The Sentences)
A statement formed a complete unit of execution. In Java, simple statements always end with a semicolon (`;`).
*   *Think of this as a complete sentence.*
*   **Types of Statements:**
    *   **Declaration statements:** `int score = 90;`
    *   **Assignment statements:** `score = 100;`
    *   **Invocation statements:** `System.out.println("Score is " + score);`
    *   **Control flow statements:** `if`, `while`, `return`.

### C. Blocks (The Paragraphs)
A block is a group of zero or more statements enclosed in curly braces `{ }`.
*   Blocks define the **Scope** of variables. If you declare a variable inside a block `{ int x = 5; }`, it ceases to exist once the code exits that block.
*   Blocks are used for class bodies, method bodies, loops, and if-statements.

**Combined Example:**
```java
public void calculate() {
    // START OF METHOD BLOCK
    
    int x = 5; // A Statement
    int y = 10;
    
    // (x + y) is an Expression. 
    // The whole line below is a Statement.
    int sum = x + y; 
    
    if (sum > 10) { 
        // START OF IF-BLOCK
        System.out.println("Great job!"); // Statement
    } 
    // END OF IF-BLOCK

} // END OF METHOD BLOCK
```

---

## 3. Naming Conventions & Best Practices
Java has strict rules (compiler errors) and "soft" rules (conventions). Following conventions makes your code readable to other developers.

### Camel Case
Java uses "Camel Case," where words are joined without spaces, and the first letter of each internal word is capitalized.

### The Specific Rules:

| Element | Convention | Explanation | Example |
| :--- | :--- | :--- | :--- |
| **Classes** | **UpperCamelCase** (PascalCase) | Nouns. Start with uppercase. | `BankAccount`, `String`, `UserController` |
| **Methods** | **lowerCamelCase** | Verbs. Start with lowercase. | `calculateTotal()`, `getName()`, `printDetails()` |
| **Variables** | **lowerCamelCase** | Short and meaningful. Start with lowercase. | `firstName`, `accountBalance`, `userConfig` |
| **Constants** | **SCREAMING_SNAKE_CASE** | All uppercase with underscores. | `MAX_LOGIN_ATTEMPTS`, `PI` |
| **Packages** | **lowercase** | Usually reverse domain name. | `com.google.search`, `net.myapp.utils` |

### Best Practices:
1.  **Descriptive Names:** Avoid single letters like `int x` (unless it's coordinate math). Use `int age` or `int index`.
2.  **Boolean variables:** Should sound like a question. Use `isActive`, `hasAccess`, or `canView`.
3.  **Don't start with numbers:** `1stPlayer` is invalid. Use `playerOne`.
4.  **Case Sensitivity:** Java is case-sensitive. `myVar`, `MyVar`, and `MYVAR` are three totally different variables.

---

### Summary Checklist for this Section
When you practice this section, ensure you can answer these questions:
1.  [ ] Can I create a file named `Application.java` and write the correct class structure inside it?
2.  [ ] Do I know where to put the `package` and `import` lines?
3.  [ ] Can I spot the difference between an *expression* (math/logic) and a *statement* (execution)?
4.  [ ] If I see a variable named `MAX_WIDTH`, do I know it is a constant?
5.  [ ] If I see a file named `userService.java`, can I explain why that violates convention (it should be `UserService.java`)?
