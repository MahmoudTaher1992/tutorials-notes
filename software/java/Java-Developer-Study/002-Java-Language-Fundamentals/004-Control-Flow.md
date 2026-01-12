Here is the detailed explanation for **Part II, Section D: Control Flow**.

In programming, **Control Flow** determines the order in which individual statements, instructions, or function calls are executed. Without control flow, code reads from top to bottom, line by line. Reviewing this section allows you to write logic that can make decisions (conditionals) and repeat tasks (loops).

---

# 004-Control-Flow.md

## 1. Conditionals
Conditionals allow your program to execute specific blocks of code *only if* certain criteria are met.

### A. The `if`, `else if`, and `else` Statements
This is the most basic form of logic.
*   **`if`**: Executes the block if the condition is `true`.
*   **`else`**: Executes the block if the `if` condition is `false`.
*   **`else if`**: Adds a new condition to check if the previous one was false.

```java
int score = 85;

if (score >= 90) {
    System.out.println("Grade: A");
} else if (score >= 80) {
    System.out.println("Grade: B"); // This will execute
} else {
    System.out.println("Grade: C");
}
```

### B. The Ternary Operator (`? :`)
A shorthand way to write simple `if-else` statements.
**Syntax:** `variable = (condition) ? valueIfTrue : valueIfFalse;`

```java
int age = 20;
String status = (age >= 18) ? "Adult" : "Minor";
```

### C. The `switch` Statement (Classic & Modern)
Use `switch` when comparing a single variable against multiple specific values (like an integer, String, or Enum). It is often cleaner than receiving many `else if` chains.

#### Classic Switch (Java 7+)
This requires the `break` keyword; otherwise, "fall-through" occurs (it keeps executing the next cases).

```java
String day = "MONDAY";

switch (day) {
    case "MONDAY":
        System.out.println("Start of work week");
        break; // Stops here
    case "FRIDAY":
        System.out.println("Weekend is near");
        break;
    default:
        System.out.println("Midweek days");
}
```

#### Modern Switch Expressions (Java 14+)
This is the modern, preferred way. It uses the arrow syntax `->`. It does **not** fall through, so you don't need `break`, and it can return a value directly.

```java
String day = "MONDAY";

String mood = switch (day) {
    case "MONDAY", "TUESDAY" -> "Tired";
    case "FRIDAY" -> "Happy";
    default -> "Neutral";
}; // Notice the semicolon here as it's an assignment
```

---

## 2. Loops
Loops allow you to execute a block of code repeatedly.

### A. The `for` Loop (Classic)
Use this when you know exactly how many times you want to loop.
**Structure:** `for (initialization; condition; update)`

```java
// Count from 0 to 4
for (int i = 0; i < 5; i++) {
    System.out.println("Counter: " + i);
}
```

### B. The Enhanced `for` Loop (For-Each)
Introduced in Java 5, this is the standard for iterating over **Arrays** or **Collections** (like Lists). It is cleaner and prevents "IndexOutOfBounds" errors.
**Structure:** `for (DataType item : collection)`

```java
String[] fruits = {"Apple", "Banana", "Orange"};

for (String fruit : fruits) {
    System.out.println(fruit);
}
```

### C. The `while` Loop
Use this when you **don't** know how many times the loop needs to run, but you know the condition to stop. The condition is checked *before* the loop runs.

```java
int batteryLevel = 5;

while (batteryLevel > 0) {
    System.out.println("Phone is on...");
    batteryLevel--;
}
System.out.println("Phone died.");
```

### D. The `do-while` Loop
Similar to `while`, but the condition is checked *after* the loop runs. **Guarantees the code runs at least once.**

```java
int input = 0;

do {
    System.out.println("This prints at least once.");
    // input = readUserInput(); // Imagine user enters 5
} while (input != 0);
```

---

## 3. Breaking & Continuing
Sometimes you need to alter the natural flow of a loop.

### A. `break`
Immediately **exit** the loop. No further iterations are executed.

```java
// Search for a specific number
int[] numbers = {1, 5, 8, 12, 3};

for (int n : numbers) {
    if (n == 12) {
        System.out.println("Found 12! Stopping search.");
        break; // Exits the loop immediately
    }
    System.out.println("Checking " + n);
}
```

### B. `continue`
Skips the **current iteration** and jumps to the next one.

```java
// Print only even numbers
for (int i = 0; i < 5; i++) {
    if (i % 2 != 0) {
        continue; // Skip the rest of the code for odd numbers
    }
    System.out.println("Even number: " + i);
}
```

### C. Labeled Loops (Advanced)
If you have nested loops (a loop inside a loop) and you want to `break` out of the *outer* loop from inside the *inner* loop, you use a label.

```java
outerLoop: // This is a label
for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
        if (i == 1 && j == 1) {
            break outerLoop; // Breaks the OUTER loop, not just the inner one
        }
        System.out.println(i + " " + j);
    }
}
```

---

### Summary Checklist for this Section
*   [ ] I understand `if` vs `switch`.
*   [ ] I know when to use a standard `for` loop vs. an enhanced `for-each` loop.
*   [ ] I understand the difference between `while` (check then run) and `do-while` (run then check).
*   [ ] I can use `break` to stop a loop and `continue` to skip a step.
