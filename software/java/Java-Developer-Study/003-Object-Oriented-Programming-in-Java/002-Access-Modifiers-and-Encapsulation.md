Based on the file title you provided (**`Access Modifiers and Encapsulation`**), here is a detailed explanation of this specific section.

This is one of the most critical pillars of Object-Oriented Programming (OOP). It is about **security** and **control** over your code.

---

### 1. What is Encapsulation?
Imagine you have a car. You drive it using the steering wheel and pedals. You do **not** drive it by manually injecting fuel into the engine cylinders while moving. The engine represents complicated, sensitive details that are "encapsulated" (hidden) under the hood.

**In Java:**
Encapsulation is the practice of wrapping data (variables) and code (methods) together into a single unit (a Class) and restricting direct access to some of that object's components.

**Why do we need it?**
1.  **Security:** External code cannot corrupt your object's internal state.
2.  **Flexibility:** You can change the internal logic of a class without breaking the code that uses that class.
3.  **Validation:** You can prevent invalid data (e.g., preventing someone from setting an age to -50).

---

### 2. Access Modifiers ( The Tools of Encapsulation)
To achieve Encapsulation, Java provides "Access Modifiers." These are keywords that determine **who** can see and use your variables and methods.

There are **4 levels of access**, ranked from most restrictive to least restrictive:

#### A. `private` (Most Restrictive)
*   **Keyword:** `private`
*   **Visibility:** Only visible **within the same class**.
*   **Use case:** Use this for all variables (fields) unless you have a specific reason not to. This "hides" your data.

#### B. Default (Package-Private)
*   **Keyword:** (No keyword used)
*   **Visibility:** Visible to any class inside the **same package**.
*   **Use case:** Helper classes or methods that only the specific module/package should know about.

#### C. `protected`
*   **Keyword:** `protected`
*   **Visibility:** Visible to classes in the **same package** AND **subclasses** (even if the subclass is in a different package).
*   **Use case:** Used heavily in inheritance. You want to hide data from the world, but allow children (subclasses) to access it.

#### D. `public` (Least Restrictive)
*   **Keyword:** `public`
*   **Visibility:** Visible to **everyone** (any class, any package).
*   **Use case:** Methods intended for the outside world to use (e.g., `main`, getters, setters, service methods).

---

### 3. Cheat Sheet: Access Levels

| Modifier | Inside Same Class | Inside Same Package | Inside Subclass (diff package) | Outside World |
| :--- | :---: | :---: | :---: | :---: |
| **private** | ✅ | ❌ | ❌ | ❌ |
| **default** | ✅ | ✅ | ❌ | ❌ |
| **protected**| ✅ | ✅ | ✅ | ❌ |
| **public** | ✅ | ✅ | ✅ | ✅ |

---

### 4. Implementation: Getters and Setters
The standard way to implement Encapsulation in Java is:
1.  Mark variables as `private`.
2.  Provide public methods to access (`get`) or modify (`set`) them.

#### Bad Example (No Encapsulation)
Here, anyone can set the balance to a negative number or mess it up.
```java
class BankAccount {
    public double balance; // DANGEROUS!
}

public class Main {
    public static void main(String[] args) {
        BankAccount account = new BankAccount();
        account.balance = -5000; // This shouldn't be allowed!
    }
}
```

#### Good Example (With Encapsulation)
Here, we protect the data.
```java
public class BankAccount {
    // 1. DATA HIDING: variable is private
    private double balance; 

    // Constructor
    public BankAccount(double initialBalance) {
        if(initialBalance >= 0) {
            this.balance = initialBalance;
        }
    }

    // 2. GETTER: Read-only access
    public double getBalance() {
        return balance;
    }

    // 3. SETTER (with logic): Controlled modification
    public void deposit(double amount) {
        if (amount > 0) {
            balance += amount;
            System.out.println("Deposited: " + amount);
        } else {
            System.out.println("Invalid deposit amount.");
        }
    }
    
    // Note: We might typically add a 'withdraw' method here too
}

public class Main {
    public static void main(String[] args) {
        BankAccount account = new BankAccount(100);
        
        // account.balance = 1000; // ERROR! Compiler stops this.
        
        account.deposit(50); // Correct way.
        System.out.println(account.getBalance()); // 150.0
    }
}
```

### Summary
*   **Encapsulation** protects your data.
*   **Access Modifiers** are the security gates.
*   **Best Practice in Java:** Make your fields `private` and your methods `public` (unless the method is an internal helper, then make it `private`).
