Here is a detailed explanation of section **004-Data-Persistence / 003-Entity-Relationships-Lifecycle.md**.

This section serves as the core of **ORM (Object-Relational Mapping)**. It explains how to translate Java Objects into Database Tables and how those objects interact with each other and the system over time.

---

# 003. Entity Relationships & Lifecycle

In Spring Boot, we typically use **Spring Data JPA** (which uses **Hibernate** usually underneath) to map our Java classes to database tables. This section covers how to define the structure of your data, how tables relate to one another, and how to hook into the "lifecycle" of a database record.

## 1. Entity Mapping Basics
This is the process of defining a simpler Java Class (POJO) and instructing Hibernate to treat it as a database table.

### Key Annotations
*   **`@Entity`**: Ties the class to the JPA context. Without this, Spring Data ignores the class.
*   **`@Table(name = "...")`**: (Optional) If your class is named `User`, JPA assumes the table is named `user`. Use this if the table name differs (e.g., `app_users`).
*   **`@Id`**: Marks the field as the Primary Key.
*   **`@GeneratedValue`**: Defines how the ID is created (e.g., Auto-increment).
*   **`@Column`**: Used to customize column details (nullable, length, name).

**Example:**
```java
@Entity
@Table(name = "t_products")
public class Product {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // "nullable = false" acts like SQL NOT NULL
    @Column(name = "prod_name", nullable = false, length = 100) 
    private String name;
    
    // ... getters and setters
}
```

---

## 2. Relationships (The "R" in RDBMS)
Databases are relational. Relationships define how data in one table points to data in another. In Java, this is represented by one object containing instances (or Lists) of another object.

### A. One-to-Many & Many-to-One
This is the most common relationship (e.g., One **User** has Many **Orders**).

*   **The Owner:** The "Many" side is almost always the "Owning" side because it holds the Foreign Key in the database implementation.
*   **`mappedBy`**: This tells JPA not to create a duplicate mapping table, but to look at the other object to realize they are connected.

**Example (One User, Many Orders):**

```java
// 1. Parent Side
@Entity
public class User {
    @Id
    private Long id;

    // Use mappedBy to say: "Look at the 'user' field in the Order class to handle the link"
    @OneToMany(mappedBy = "user") 
    private List<Order> orders;
}

// 2. Child Side (Owning Side - holds the FK)
@Entity
public class Order {
    @Id 
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id") // This creates the foreign key column in the Order table
    private User user;
}
```

### B. Many-to-Many
Example: **Students** and **Courses**. A student takes many courses; a course has many students.
*   **The Join Table:** In SQL, you cannot have a foreign key in both tables directly (cyclic dependency). You need a third, hidden table calling a **Join Table**.
*   **Annotation:** `@JoinTable` is used to define this bridge.

```java
@ManyToMany
@JoinTable(
  name = "student_course", 
  joinColumns = @JoinColumn(name = "student_id"), 
  inverseJoinColumns = @JoinColumn(name = "course_id"))
private Set<Course> courses;
```

### C. One-to-One
Example: **User** and **Passport**.
*   Typically used to offload heavy descriptions or detailed data to a separate table to keep the main table light.

---

## 3. Lazy vs. Eager Loading
This concept dictates **when** the related data is fetched from the database. This is critical for performance.

### Eager Loading (`FetchType.EAGER`)
*   **Behavior:** When you load the Parent, Hibernate immediately runs a join to load the Children, too.
*   **Pro:** Data is available immediately.
*   **Con:** Can result in loading way too much data (e.g., loading a User and accidentally loading their 50,000 historic logs).
*   **Default:** Generally default for `@ManyToOne` and `@OneToOne`.

### Lazy Loading (`FetchType.LAZY`)
*   **Behavior:** When you load the Parent, the Child list is literally empty (or a Proxy object). Hibernate does **not** query the children until you call `parent.getChildren()`.
*   **Pro:** Very efficient. Only loads what you need.
*   **Con:** Danger of `LazyInitializationException` if you close the database transaction/session and *then* try to get the children.
*   **Default:** Default for `@OneToMany` and `@ManyToMany`.

**Example:**
```java
// Good practice: Explicitly set ManyToOne to LAZY if you don't always need the parent data
@ManyToOne(fetch = FetchType.LAZY)
private User user;
```

---

## 4. Entity Lifecycle Callbacks
JPA entities go through life stages (New, Managed, Removed, Detached). You can write methods inside your Entity that trigger automatically when these stages change.

This is most commonly used for **Auditing** (setting `created_at` or `updated_at` dates automatically).

### Common Callbacks:
*   `@PrePersist`: Runs before the object is saved to the DB (INSERT).
*   `@PostPersist`: Runs after the save is committed.
*   `@PreUpdate`: Runs before an existing record is updated.
*   `@PreRemove`: Runs before a record is deleted.

**Example (Automatic Auditing):**

```java
@Entity
public class Post {
    // fields...

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    @PrePersist // Runs before SQL INSERT
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    @PreUpdate // Runs before SQL UPDATE
    protected void onUpdate() {
        this.updatedAt = LocalDateTime.now();
    }
}
```

### Cascade Types (Bonus context usually included here)
When you perform an action on a Parent, should it bubble down to the Child?
*   `CascadeType.PERSIST`: If I save the User, save their Orders too.
*   `CascadeType.REMOVE`: If I delete the User, delete all their Orders too.
*   `CascadeType.ALL`: Do everything.

---

### Summary Table for Study

| Concept | Annotation | Purpose |
| :--- | :--- | :--- |
| **Identity** | `@Id` | Marks primary key. |
| **Relation** | `@OneToMany` | Relationship mapping. |
| **Logic** | `mappedBy` | Defines which side owns the Foreign Key (performance critical). |
| **Timing** | `FetchType.LAZY` | Wait until queried to fetch data (performance critical). |
| **Timing** | `FetchType.EAGER` | Fetch immediately via Joins. |
| **Lifecycle** | `@PrePersist` | Hook logic (like timestamps) before saving. |
