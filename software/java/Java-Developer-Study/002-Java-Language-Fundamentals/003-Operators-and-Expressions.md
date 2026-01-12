Based on the structure provided in your roadmap, here is a detailed explanation of **Part II, Section C: Operators and Expressions**.

In Java, **Operators** are special symbols used to perform operations on variables and values. An **Expression** is a combination of variables, operators, and method calls that evaluates to a single value.

Here is the deep dive into each category:

---

### 1. Arithmetic Operators
These are used to perform common mathematical operations.

| Operator | Name | Description | Example | Result |
| :--- | :--- | :--- | :--- | :--- |
| `+` | Addition | Adds two values | `10 + 5` | `15` |
| `-` | Subtraction | Subtracts one value from another | `10 - 5` | `5` |
| `*` | Multiplication | Multiplies two values | `10 * 5` | `50` |
| `/` | Division | Divides one value by another | `10 / 5` | `2` |
| `%` | Modulo | Returns the division remainder | `10 % 3` | `1` |

**Critical Concepts:**
*   **Integer Division:** If you divide two integers (e.g., `5 / 2`), Java truncates the decimal part. The result will be `2`, not `2.5`. To get a decimal result, at least one operand must be a float/double (e.g., `5.0 / 2`).
*   **String Concatenation:** The `+` operator is overloaded. If used with Strings, it joins them: `"Hello " + "World"` becomes `"Hello World"`.

---

### 2. Unary Operators
These operators require only **one operand**.

*   `+` : Indicates positive value (implicit, rarely used).
*   `-` : Negates an expression (makes it negative).
*   `++` : **Increment** (increases value by 1).
*   `--` : **Decrement** (decreases value by 1).
*   `!` : **Logical Complement** (inverts a boolean value).

**Prefix vs. Postfix (Important):**
*   **Prefix (`++i`):** Increment happens **before** the value is used.
*   **Postfix (`i++`):** The value is used **first**, then incremented.

```java
int a = 5;
int b = ++a; // a becomes 6, then b is assigned 6.
int c = a++; // c is assigned 6, then a becomes 7.
```

---

### 3. Relational (Comparison) Operators
These compare two values and always return a `boolean` (`true` or `false`).

| Operator | Description | Example |
| :--- | :--- | :--- |
| `==` | Equal to | `5 == 5` (true) |
| `!=` | Not equal to | `5 != 3` (true) |
| `>` | Greater than | `5 > 3` (true) |
| `<` | Less than | `5 < 8` (true) |
| `>=` | Greater than or equal to | `5 >= 5` (true) |
| `<=` | Less than or equal to | `5 <= 2` (false) |

**Warning:** Do not use `==` to compare Strings or Objects unless you want to check if they are literally the same object in memory. Use `.equals()` for checking content equality in Objects.

---

### 4. Logical Operators
Used to combine multiple boolean expressions.

*   `&&` (**Logical AND**): Returns true only if **both** sides are true.
*   `||` (**Logical OR**): Returns true if **at least one** side is true.
*   `!` (**Logical NOT**): Reverses the boolean value.

**Short-Circuit Evaluation:**
Java optimizes logical operations.
*   In `A && B`: If `A` is false, Java stops and returns false immediately (it doesn't check `B`).
*   In `A || B`: If `A` is true, Java stops and returns true immediately (it doesn't check `B`).
*   *Why this matters:* You can protect against errors. E.g., `if (obj != null && obj.value > 0)` prevents a NullPointerException.

---

### 5. Bitwise Operators
These work on the binary representation (bits) of integers. Used often in low-level programming, encryption, or standard setting.

*   `&` (**Bitwise AND**): 1 if both bits are 1.
*   `|` (**Bitwise OR**): 1 if either bit is 1.
*   `^` (**Bitwise XOR**): 1 if bits are different.
*   `~` (**Bitwise Complement**): Inverts all bits (0 becomes 1, 1 becomes 0).
*   `<<` (**Left Shift**): Shifts bits left (multiplies by 2).
*   `>>` (**Signed Right Shift**): Shifts bits right (divides by 2), preserving the sign (+/-).
*   `>>>` (**Unsigned Right Shift**): Shifts bits right, filling with zeros (always positive).

---

### 6. Assignment Operators
Used to assign values to variables.

*   `=` : Simple assignment (`int x = 10;`).
*   **Compound Assignments:** Perform an operation and assign in one step.
    *   `+=` : `x += 5` is strictly equivalent to `x = x + 5`.
    *   `-=`, `*=`, `/=`, `%=`, `&=`, `^=`, etc., work similarly.
    *   *Benefit:* They automatically handle type casting in many cases.

---

### 7. The Ternary Operator
This is a shorthand for an `if-else` statement. It is the only operator that takes three operands.

**Syntax:**
`variable = (condition) ? expressionTrue : expressionFalse;`

**Example:**
```java
int a = 10, b = 20;
int max = (a > b) ? a : b; 
// Explanation: Is a > b? No. So result is b (20).
```

---

### 8. Operator Precedence & Associativity
When multiple operators appear in one expression, Java follows a strict order of operations (PEMDAS style).

1.  **High Precedence:** `++`, `--`, `!`, `()` (Parentheses).
2.  **Arithmetic:** `*`, `/`, `%` happen before `+`, `-`.
3.  **Relational:** `>`, `<`, etc.
4.  **Logical:** `&&` happens before `||`.
5.  **Assignment:** `=` happens last.

**Associativity:**
*   Most operators evaluate **Left-to-Right** (`10 - 5 - 2` evaluates as `(10-5) - 2`).
*   Assignment operators evaluate **Right-to-Left** (`a = b = c` sets c to b, then b to a).

---

### 9. Standard Math Functions (`java.lang.Math`)
Java provides the `Math` class (automatically imported) for advanced calculations. All methods in this class are `static`.

**Common Methods:**
*   `Math.abs(-10)`: Returns absolute value (10).
*   `Math.max(10, 20)`: Returns the larger value.
*   `Math.min(10, 20)`: Returns the smaller value.
*   `Math.pow(2, 3)`: Returns 2 to the power of 3 ($2^3 = 8.0$).
*   `Math.sqrt(25)`: Returns the square root (5.0).
*   `Math.random()`: Returns a random double between 0.0 (inclusive) and 1.0 (exclusive).
*   `Math.round(2.5)`: Rounds to the nearest integer.
*   `Math.PI` and `Math.E`: Constants for $\pi$ and Euler's number.
