Here is a detailed breakdown of **Part IV, Section E: Transactions** (`004-Data-Persistence/005-Transactions.md`).

In enterprise application development, handling data consistency is critical. Spring Boot makes this much easier through **Declarative Transaction Management**.

---

# 005 - Transaction Management in Spring Boot

### 1. What is a Transaction? (The "ACID" Concept)
Before looking at the code, remember that a transaction is a set of operations that must either **all succeed** or **all fail**. It follows the **ACID** principles:
*   **A**tomicity: All or nothing.
*   **C**onsistency: Data remains valid according to rules.
*   **I**solation: Parallel transactions don't affect each other (depending on levels).
*   **D**urability: Once committed, it's saved permanently.

**Classic Example:** Transferring money.
1. Debit Account A ($100).
2. Credit Account B ($100).
*If step 2 fails (e.g., server crash), Step 1 must be undone (rolled back).*

---

### 2. The `@Transactional` Annotation
In Spring Boot, you don't commonly write `connection.beginTransaction()` and `connection.commit()`. Instead, you use **Declarative Transaction Management** via the `@Transactional` annotation.

**How it works (AOP Proxy):**
When you annotate a method (or class) with `@Transactional`, Spring creates a **Proxy** around your class.
1.  **Start:** When the method is called, the Proxy starts a database transaction.
2.  **Execute:** The actual method logic runs.
3.  **End:**
    *   If successful, the Proxy **Commits** the transaction.
    *   If an exception occurs, the Proxy **Rolls back** the transaction.

**Basic Usage:**
```java
@Service
public class BankService {

    @Autowired
    private AccountRepository accountRepo;

    @Transactional
    public void transferMoney(Long fromId, Long toId, Double amount) {
        Account from = accountRepo.findById(fromId).orElseThrow();
        Account to = accountRepo.findById(toId).orElseThrow();

        from.setBalance(from.getBalance() - amount);
        to.setBalance(to.getBalance() + amount);
        
        accountRepo.save(from);
        // If an error happens here (e.g., RunTimeException), 
        // the deduction from 'from' account is undone implicitly.
        accountRepo.save(to); 
    }
}
```

---

### 3. Transaction Propagation
**Propagation** defines how transactions relate to each other when one transactional method calls another.

*Scenario: `Method A` calls `Method B`.*

| Propagation Type | Description | Use Case |
| :--- | :--- | :--- |
| **REQUIRED** (Default) | If `A` has a transaction, `B` joins it. If not, `B` creates a new one. | Standard business logic. |
| **REQUIRES_NEW** | `B` always creates a new transaction. `A` is paused until `B` finishes. | Audit logging (save the log even if the main business logic fails). |
| **SUPPORTS** | If `A` has a transaction, `B` uses it. If not, `B` runs without one. | Read-only operations that might need to be part of a larger write. |
| **MANDATORY** | `B` throws an exception if `A` does not have an active transaction. | Methods that strictly require an existing context (e.g., internal helper updates). |
| **NEVER** | `B` throws an exception if `A` has a transaction. | Operations strictly non-transactional. |
| **NOT_SUPPORTED** | `B` pauses `A`'s transaction (if exists) and runs non-transactionally. | Heavy processing where you don't want to hold a DB lock. |
| **NESTED** | Creates a "savepoint" within the existing transaction. If `B` fails, it rolls back to the savepoint, but `A` continues. | Complex workflows with partial failure recovery (JDBC only). |

**Example:**
```java
@Transactional(propagation = Propagation.REQUIRES_NEW)
public void saveAuditLog() {
    // This commits even if the calling method eventually fails
}
```

---

### 4. Isolation Levels
**Isolation** dictates how data is visible to other users/processes while a transaction is running (Concurrency control).

*   **DEFAULT**: Uses the underlying database's default (Read Committed for Postgres, Repeatable Read for MySQL).
*   **READ_UNCOMMITTED**: Transaction A can read changes made by Transaction B *before* B commits.
    *   *Risk:* Dirty Reads.
*   **READ_COMMITTED**: Transaction A can only read changes B has *committed*.
    *   *Risk:* Non-Repeatable Reads (If A reads a row twice, the data might change in between).
*   **REPEATABLE_READ**: Ensures that if Transaction A reads a row, that row will remain the same throughout A's lifecycle.
    *   *Risk:* Phantom Reads (New rows appearing).
*   **SERIALIZABLE**: Strict execution. Transactions run one after another.
    *   *Performance:* Lowest.
    *   *Risk:* None (Perfect consistency).

**Example:**
```java
@Transactional(isolation = Isolation.SERIALIZABLE)
public void purelyConsistentCheck() { ... }
```

---

### 5. Rollback Scenarios
This is a very common interview topic and bug source.

**The Default Behavior:**
Spring explicitly rolls back for **Unchecked Exceptions** (`RuntimeException` and its subclasses, e.g., `NullPointerException`, `IllegalArgumentException`) and `Error`.
Spring **DOES NOT** roll back for **Checked Exceptions** (`Exception`, `IOException`, `SQLException`) by default.

**Customizing Rollback:**
You can force a rollback for checked exceptions using `rollbackFor`.

```java
// 1. Rollback for a specific Checked Exception
@Transactional(rollbackFor = IOException.class)
public void uploadFileAndSave() throws IOException { ... }

// 2. Don't rollback for specific Unchecked Exception
@Transactional(noRollbackFor = ArithmeticException.class)
public void mathOperation() { ... }
```

---

### 6. Read-Only Optimization
If a method only fetches data (Selects) and does not modify it, mark it as read-only. This allows the Jpa/Hibernate to apply performance optimizations (skipping dirty checking).

```java
@Transactional(readOnly = true)
public List<User> getAllUsers() {
    return userRepository.findAll();
}
```

---

### 7. Common Pitfalls (The "Gotchas")

**A. The Self-Invocation Problem**
Since `@Transactional` works via a Proxy (wrapper), calling a transactional method from within the **same class** bypasses the proxy, meaning **no transaction is created**.

*   *This won't work:*
    ```java
    public void methodA() {
        methodB(); // This call bypasses the proxy!
    }

    @Transactional
    public void methodB() { ... }
    ```
*   *Solution:* Move `methodB` to a different Service (Bean) and inject it, or use `AopContext.currentProxy()`.

**B. Using @Transactional on Private Methods**
It typically **does not work** on `private` or `protected` methods because standard Spring AOP proxies only intercept public method calls.

**C. Placement**
Always place `@Transactional` at the **Service Layer**, not the Controller (presentation logic) or the Repository (data access logic, which is usually already transactional by default in Spring Data JPA).
