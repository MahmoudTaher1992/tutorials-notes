Here is a detailed explanation of **Unit 004 / Section 005: Optionals (Java 8+)** from your Roadmap.

---

# 005 - Optionals (Java 8+)

### 1. The Problem: The "Billion Dollar Mistake"
Before Java 8, managing missing data was done using `null`. This led to the dreaded **`NullPointerException` (NPE)**, the most common exception in Java.

**The Old Way:**
If you wanted to get a User's City, but the User (or their Address) might be null, you wrote defensive spaghetti code:

```java
public String getUserCity(User user) {
    if (user != null) {
        if (user.getAddress() != null) {
            String city = user.getAddress().getCity();
            if (city != null) {
                return city;
            }
        }
    }
    return "Unknown";
}
```

### 2. The Solution: `java.util.Optional<T>`
`Optional` is a **container object** which may or may not contain a non-null value. It forces the programmer to explicitly handle the case where a value might be missing, rather than hoping it isn't null.

Think of it as a **box**.
1.  The box has data inside.
2.  The box is empty.

You interact with the *box*, not the data directly, preventing accidental crashes.

---

### 3. Creating Optionals
There are three main ways to create an Optional object:

**A. `Optional.empty()`**
Creates a definitely empty box.
```java
Optional<String> empty = Optional.empty();
```

**B. `Optional.of(T value)`**
Creates a box containing a value.
*⚠️ WARNING:* If you pass `null` here, it throws a `NullPointerException` immediately. Use this only when you are 100% sure the object is not null.
```java
Optional<String> opt = Optional.of("Hello");
```

**C. `Optional.ofNullable(T value)`** (Most Common)
Creates a box that contains the value if it exists, or instances an empty box if the value is null. This bridges the gap between legacy `null` code and modern Optional code.
```java
String name = null;
Optional<String> opt = Optional.ofNullable(name); // Result is Optional.empty()
```

---

### 4. Unwrapping the Box (Getting values out)
Once you have an Optional, how do you get the data? Avoid using `.get()` unless you are certain!

**A. The Unsafe Way (`.get()`)**
```java
Optional<String> opt = Optional.ofNullable(null);
String value = opt.get(); // Throws NoSuchElementException!
// This is practically the same as getting a NullPointerException. Avoid this.
```

**B. The Safe Ways**

1.  **`orElse(T other)`**
    Return the value if present, otherwise return a default value.
    ```java
    String name = opt.orElse("Default Name"); 
    ```

2.  **`orElseGet(Supplier<? extends T> other)`** (Lazy Loading)
    Similar to `orElse`, but the default value is only generated if the Optional is empty. Crucial for performance if the default value is expensive to create (e.g., calling a DB).
    ```java
    // "generateDefault()" is strictly only called if opt is empty
    String name = opt.orElseGet(() -> generateDefault()); 
    ```

3.  **`orElseThrow()`**
    Return value if present, otherwise throw an exception that you define.
    ```java
    User user = userOpt.orElseThrow(() -> new IllegalArgumentException("User not found"));
    ```

---

### 5. Functional Operations (The Power of Optionals)
You can transform the data *inside* the box without opening it. If the box is empty, these operations simply do nothing.

**A. `map()`**
Transform the value if present.
```java
Optional<String> opt = Optional.of("java");
// Converts contents to uppercase safely. if opt was empty, result is empty.
Optional<String> upper = opt.map(String::toUpperCase); 
```

**B. `filter()`**
Keep the value only if it matches a condition; otherwise, empty the box.
```java
Optional<Integer> ageOpt = Optional.of(20);
// Checks if > 18. If true, keep 20. If false, return empty.
Optional<Integer> legalAge = ageOpt.filter(age -> age >= 18);
```

**C. `ifPresent()`**
Execute a block of code only if the value exists. (Void return).
```java
opt.ifPresent(name -> System.out.println("Processing " + name));
```

---

### 6. The "Old Way" Refactored
Remember nested `if` statements from Section 1? Here is the implementation using `Optional` chaining:

```java
public String getUserCity(User user) {
    return Optional.ofNullable(user)
                   .map(User::getAddress)   // If user exists, get address
                   .map(Address::getCity)   // If address exists, get city
                   .orElse("Unknown");      // If anything was null, return Unknown
}
```

---

### 7. Best Practices & Pitfalls

**✅ DO:**
1.  **Use as a Return Type:** This is the primary design goal. If a method might not return a result (e.g., `findUserByEmail`), return `Optional<User>` instead of `null`. It creates a clear API contract telling the caller "You must handle the missing case."
2.  **Chain methods:** Use `map`, `filter`, and `orElse` rather than `if(opt.isPresent())`.

**❌ DON'T:**
1.  **Do not use as Field (Class variable):** Optional is **not Serializable**. If you declare `private Optional<String> name;` inside a class and try to serialize that class (e.g., send it over a network or save to file), it will fail.
2.  **Do not use as Constructor or Method Parameter:** It complicates the code for the caller.
    *   *Bad:* `public void printName(Optional<String> name)` -> Caller must wrap: `printName(Optional.of("John"))`
    *   *Good:* `public void printName(String name)` -> Caller just passes "John" or checks null before calling.
3.  **Do not use `Optional` for Collections:**
    *   *Bad:* `Optional<List<String>>`
    *   *Good:* Return an empty `List` (`Collections.emptyList()`) instead. It's easier to handle `for (String s : list)` on an empty list than an Optional wrapper.

### Summary
*   **Purpose:** To represent "optionality" in return types and avoid explicit null checks.
*   **Key Idea:** It is a container (Box).
*   **Golden Rule:** Never call `get()` without calling `isPresent()` first, or better yet, use `orElse` / `ifPresent`.
