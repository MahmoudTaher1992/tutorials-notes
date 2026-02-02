Based on the roadmap you provided, here is a detailed explanation of **Part II: Programming Fundamentals – A. Programming Paradigms**.

### What is a Programming Paradigm?
A **paradigm** is not a specific language; it is a fundamental style, mindset, or approach to organizing your code to solve a problem. Think of it like a philosophy of how software should be structured.

Different languages are designed to support different paradigms. However, most modern languages (like Python, JavaScript, and C++) are **multi-paradigm**, meaning they allow you to mix and match these styles.

---

### 1. Imperative & Procedural
 This is the "traditional" way of programming, focusing on **HOW** to solve a problem step-by-step.

*   **Imperative**: The interaction focuses on changing the state of the program through a sequence of commands. You tell the computer exactly what to do, line by line.
    *   *Analogy:* Following a cooking recipe. "Take a bowl. Add flour. Stir."
*   **Procedural**: This is a sub-category of Imperative. It organizes the step-by-step instructions into reusable blocks called **Procedures** (also known as functions, routines, or subroutines).
    *   *Concept:* Instead of writing the same 20 lines of code every time you need to calculate an average, you put those lines in a function called `calculateAverage` and call it whenever needed.
    *   *Languages:* C, Pascal, COBOL, BASIC.

**Example (Pseudocode):**
```text
list = [1, 2, 3]
total = 0
for number in list:
    total = total + number  // We are changing the state of 'total' step-by-step
print(total)
```

---

### 2. Object-Oriented Programming (OOP)
This paradigm organizes code around **Data** (Objects) rather than just logic. It is based on the idea that software should model real-world things.

*   **Concept**: You create "Classes" (blueprints) that define what an object is (data/attributes) and what it can do (methods/behaviors).
*   **The 4 Pillars of OOP**:
    1.  **Encapsulation**: Bundling data and methods together and hiding the internal details (private vs. public).
    2.  **Abstraction**: Hiding complexity and showing only the necessary features.
    3.  **Inheritance**: Creating new classes based on existing ones to reuse code (e.g., a "Car" class inherits from a "Vehicle" class).
    4.  **Polymorphism**: The ability to treat different objects (like a Dog or a Cat) as a generic type (Animal), yet each responds to the same method (Search `speak()`) in its own way.
*   *Languages:* Java, C++, C#, Python, Ruby.

**Example:**
Instead of a loose variable for `speed`, you have a `Car` object.
```text
Class Car:
    Attribute speed = 0

    Method accelerate():
        speed = speed + 10

myCar = new Car()
myCar.accelerate() // We ask the object to change its own state
```

---

### 3. Functional & Declarative
This paradigm focuses on **WHAT** results you want, rather than the steps to get there. It is mathematical in nature.

*   **Declarative**: You declare your intent. You don't manage the control flow (loops, if/else) manually; the underlying system handles that.
    *   *Example:* SQL. You write `SELECT * FROM Users WHERE Age > 18`. You don't tell the database *how* to search the file; you just say *what* you want.
*   **Functional**: A specific type of declarative programming based on mathematical functions.
    *   **Immutability**: Data cannot be changed once created. You don't modify a variable; you create a *new* variable with the updated value.
    *   **Pure Functions**: A function's output depends *only* on its input and has no "side effects" (it doesn't change anything outside the function).
    *   **Functions as First-Class Citizens**: You can pass functions as arguments to other functions (e.g., `.map()`, `.filter()`, `.reduce()`).
*   *Languages:* Haskell, Lisp, Erlang, F#. (Also heavily used in React.js, modern Java, and Python).

**Example (Functional approach to the sum problem):**
```text
list = [1, 2, 3]
// We don't loop manually. We ask the system to "reduce" the list to a single number by adding.
sum = list.reduce((a, b) => a + b)
```

---

### 4. Scripting & Event-Driven
These are often used for specific use cases like web development or automation.

*   **Scripting**: Writing code to automate tasks that would otherwise be executed one-by-one by a human operator. Scripting languages are usually **Interpreted** (run immediately) rather than Compiled. They are often used as "glue" code to connect different systems.
    *   *Languages:* Bash, PowerShell, Python, Ruby, Perl.
*   **Event-Driven**: The flow of the program is determined by **Events** (user actions like clicks, sensor outputs, or messages from other programs).
    *   *Concept:* The program sits in a loop (an "Event Loop") waiting for something to happen. When a button is clicked, a specific function (Event Handler) runs.
    *   *Context:* Essential for GUIs (Graphical User Interfaces) and Web Servers.
    *   *Languages:* JavaScript (Node.js), Visual Basic.

**Example (JavaScript):**
```javascript
button.addEventListener('click', function() {
    alert("Button was clicked!");
    // The code only runs WHEN the event happens.
});
```

---

### 5. Logic Programming
This is a highly specialized paradigm significantly different from the others. It is based on **formal logic**.

*   **Concept**: Instead of telling the computer strictly *what to do*, you give the computer a set of **Facts** (Data) and **Rules** (Logic).
*   **Execution**: You ask the computer a question (Query), and the computer's "inference engine" tries to figure out the answer by connecting the facts and rules.
*   **Use Cases**: AI research, natural language processing, expert systems (e.g., medical diagnosis systems).
*   *Languages:* Prolog, Datalog, Mercury.

**Example (Prolog):**
```prolog
// Facts
parent(john, jim).   // John is the parent of Jim
parent(john, ann).   // John is the parent of Ann

// Rules
sibling(A, B) :- parent(P, A), parent(P, B). 

// Query: "Are Jim and Ann siblings?"
?- sibling(jim, ann).
// Output: Yes.
```
*Note: We never wrote a loop to check parents. We defined the relationship, and the computer figured it out.*

---

### Summary Table

| Paradigm | Focus | Key Concept | Analogy |
| :--- | :--- | :--- | :--- |
| **Imperative/Procedural** | **How** (Steps) | Subroutines, loops, state change. | Following a recipe line-by-line. |
| **Object-Oriented** | **Who** (Models) | Objects, Classes, Inheritance. | Organizing tools in a toolbox. |
| **Functional** | **What** (Math) | Immutability, Pure Functions. | Solving a math equation ($f(x) = y$). |
| **Event-Driven** | **When** (Triggers) | Listeners, Callbacks, Asynchronous. | A waiter waiting for you to wave. |
| **Logic** | **Why** (Truths) | Facts, Rules, Inference. | A detective solving a mystery. |
