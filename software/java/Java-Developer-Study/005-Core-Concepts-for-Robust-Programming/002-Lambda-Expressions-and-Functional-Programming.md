Here is a detailed explanation of **Part V, Section B: Lambda Expressions & Functional Programming**.

This section represents one of the biggest shifts in Java history (introduced in Java 8). It moved Java from being purely **Object-Oriented** (where everything must be an object) to a hybrid language that supports **Functional Programming** (where you can treat code/functions as data).

---

### **1. Basics of Lambdas**

**Concept:** A Lambda expression is essentially an **anonymous function**. It is a block of code that you can pass around to other methods. Before Java 8, if you wanted to pass functionality (logic) to a method, you had to create a class or an anonymous inner class.

**Syntax:**
```java
(parameters) -> { body }
```

**Comparison:**
Imagine you want to sort a list of Strings by length.

*   **Before Java 8 (Anonymous Inner Class):**
    ```java
    Collections.sort(names, new Comparator<String>() {
        @Override
        public int compare(String s1, String s2) {
            return s1.length() - s2.length();
        }
    }); // Very verbose!
    ```

*   **With Lambda:**
    ```java
    Collections.sort(names, (s1, s2) -> s1.length() - s2.length());
    ```

**Key Takeaway:** Lambdas strip away the "boilerplate" code (class, method definition) and focus strictly on the logic (input -> output).

---

### **2. Functional Interfaces**

**Concept:** How does Java know what a Lambda is? It uses **Functional Interfaces**. A Functional Interface is an interface that contains **exactly one abstract method**.

The compiler creates an instance of this interface using your lambda expression as the implementation of that single method.

*   **Annotation:** `@FunctionalInterface` is used to ensure the interface strictly follows this rule (compiler will strict check it).

**Example:**
```java
@FunctionalInterface
interface Calculator {
    int operate(int a, int b);
}

// Usage:
Calculator add = (a, b) -> a + b;
Calculator sub = (a, b) -> a - b;

System.out.println(add.operate(5, 3)); // Outputs: 8
```

---

### **3. Predefined Functional Interfaces (The `java.util.function` Package)**

You don't need to write your own interfaces (like `Calculator` above) for common tasks. Java provides standard ones:

| Interface | Function Signature | Description | Example Usage |
| :--- | :--- | :--- | :--- |
| **Predicate\<T>** | `T -> boolean` | Tests a condition. Returns true/false. | Filtering a list (e.g., `x -> x > 10`) |
| **Consumer\<T>** | `T -> void` | Takes an input, does something, returns nothing. | Printing or saving data (e.g., `s -> System.out.println(s)`) |
| **Supplier\<T>** | `() -> T` | Takes nothing, returns a result. | Generating IDs or Lazy loading (e.g., `() -> Math.random()`) |
| **Function\<T, R>** | `T -> R` | Transforms input T into output R. | Mapping data (e.g., `String` to `Integer`) |

---

### **4. Method References**

**Concept:** If your Lambda expression acts strictly as a "pass-through" to another existing method, you can use a **Method Reference** to make it even cleaner. It uses the double colon `::` operator.

**Types:**
1.  **Static Method:** `(args) -> Class.method(args)` becomes `Class::method`
2.  **Instance Method:** `(obj) -> obj.method()` becomes `String::toUpperCase`
3.  **Constructor:** `() -> new ArrayList<>()` becomes `ArrayList::new`

**Example:**
```java
List<String> messages = Arrays.asList("hello", "world");

// Lambda
messages.forEach(s -> System.out.println(s));

// Method Reference (Logic: Pass the element directly to println)
messages.forEach(System.out::println);
```

---

### **5. Stream API**

**Concept:** The Stream API is the most powerful tool built upon Lambdas. It allows you to process collections of objects (Lists, Sets) in a declarative way (like SQL for Java objects).

**The Pipeline Structure:**
1.  **Source:** The collection (e.g., `list.stream()`).
2.  **Intermediate Operations:** Methods that return a Stream. They are **Lazy** (they don't execute until the end).
    *   `filter(Predicate)`: Keep only items matching criteria.
    *   `map(Function)`: Transform items from one shape to another.
    *   `sorted()`: Sort execution.
3.  **Terminal Operation:** Triggers the processing and produces a result.
    *   `collect()`: Gather results into a List/Set.
    *   `forEach()`: Loop over them.
    *   `count()`: Return a number.

**Real-World Example:**
*Get all names of users over age 18, convert them to uppercase, and return a List.*

```java
List<User> users = database.getUsers();

List<String> activeUserNames = users.stream()                 // 1. Source
    .filter(u -> u.getAge() > 18)                             // 2. Filter (Predicate)
    .map(u -> u.getName().toUpperCase())                      // 3. Map (Function)
    .sorted()                                                 // 4. Sort
    .collect(Collectors.toList());                            // 5. Terminal Operation
```

---

### **6. Optional (Handling Nulls)**

**Concept:** `NullPointerException` is the most common bug in Java. Java 8 introduced `Optional<T>` explicitly for return types that might not have a value. It forces the developer to "unwrap" the value safely.

**Usage:**
Instead of returning `null`, return `Optional<User>`.

```java
Optional<User> userOpt = findUser("john_doe");

// 1. Check if present
if(userOpt.isPresent()) {
    System.out.println(userOpt.get().getName());
}

// 2. Functional Style (Better!)
userOpt.ifPresent(u -> System.out.println(u.getName()));

// 3. Default value if null
User u = userOpt.orElse(new User("Default"));

// 4. Throw exception if null
User u = userOpt.orElseThrow(() -> new NotFoundException());
```

### **Summary of Why This Matters**
1.  **Conciseness:** Reduces boilerplate code significantly.
2.  **Readability:** Code reads more like the business logic ("Filter active users, map to names") rather than loop syntax (`for (int i=0...)`).
3.  **Immutability & Thread Safety:** Functional programming encourages stateless functions, making it much easier to run code in parallel (using `.parallelStream()`) without worrying about thread synchronization.
