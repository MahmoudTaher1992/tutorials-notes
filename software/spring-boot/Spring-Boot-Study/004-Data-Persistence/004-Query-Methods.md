Here is a detailed explanation of **Part IV, Section D: Query Methods** from your Spring Boot Study Table of Contents.

In Spring Data JPA, **Query Methods** are the mechanism used to retrieve or manipulate data from the database without writing boilerplate JDBC code. The beauty of Spring Data is that you often just define the *interface*, and Spring provides the *implementation* at runtime.

Here is the deep dive into the four main concepts of Query Methods.

---

# 004-Query-Methods.md

## 1. Derived Query Methods
The most implicit and "magical" way to query data. You name your interface method following a specific naming convention, and Spring Data parses the name to generate the SQL automatically.

### Syntax
The standard syntax is: `find` + `By` + `Properties` + `Conditions`.

### Examples
Assuming you have a `User` entity with `firstName`, `lastName`, `age`, and `email`.

```java
public interface UserRepository extends JpaRepository<User, Long> {

    // SQL: SELECT * FROM user WHERE email = ?
    User findByEmail(String email);

    // SQL: SELECT * FROM user WHERE last_name = ?
    List<User> findByLastName(String lastName);

    // Chaining properties with And / Or
    // SQL: SELECT * FROM user WHERE first_name = ? AND age = ?
    List<User> findByFirstNameAndAge(String firstName, Integer age);

    // Logical Conditions (LessThan, GreaterThan, Between, Like, Containing)
    // SQL: SELECT * FROM user WHERE age > ?
    List<User> findByAgeGreaterThan(Integer age);

    // Ordering results
    // SQL: SELECT * FROM user WHERE last_name = ? ORDER BY first_name ASC
    List<User> findByLastNameOrderByFirstNameAsc(String lastName);
}
```

**Pros:** No SQL needed; very readable for simple queries.
**Cons:** Method names become absurdly long and unreadable for complex queries (e.g., `findByFirstNameAndLastNameOrEmailAndAgeGreaterThan...`).

---

## 2. JPQL and The `@Query` Annotation
When derived methods become too long, or the logic involves complex joins that the naming convention cannot handle, you use the `@Query` annotation.

By default, `@Query` uses **JPQL (Java Persistence Query Language)**. JPQL operates on **Entity Objects**, not database tables. This makes it database-agnostic (it works on MySQL, PostgreSQL, Oracle without changing the code).

### Examples

```java
public interface UserRepository extends JpaRepository<User, Long> {

    // Using JPQL. Notice 'User' (Entity class name) and 'u.active' (field name)
    @Query("SELECT u FROM User u WHERE u.active = true")
    List<User> findAllActiveUsers();

    // Using Named Parameters (:paramName) - Recommended for clarity
    @Query("SELECT u FROM User u WHERE u.email = :email AND u.lastName = :lastname")
    User findUserByEmailAndName(@Param("email") String email, 
                                @Param("lastname") String lastname);
    
    // Using Indexed Parameters (?1, ?2) - Less readable but faster to write
    @Query("SELECT u FROM User u WHERE u.age > ?1")
    List<User> findUsersOlderThan(Integer age);
}
```

---

## 3. Native Queries
Sometimes JPQL isn't enough because you need to use a specific feature of your database (like a Postgres JSONB function or a complex Oracle window function). In this case, you use standard SQL.

You simply add `nativeQuery = true` to the annotation.

### Example
```java
public interface UserRepository extends JpaRepository<User, Long> {

    // This is raw SQL. It refers to table 'users_table', not the Entity 'User'
    @Query(value = "SELECT * FROM users_table WHERE email_address = :email", 
           nativeQuery = true)
    User findUserByEmailNative(@Param("email") String email);
}
```
**Warning:** Native queries couple your code to a specific database logic. If you migrate from MySQL to PostgreSQL later, you might have to rewrite these queries.

---

## 4. Modifying Queries (`@Modifying`)
Standard standard query methods are for *reading* (SELECT). If you want to perform an **UPDATE** or **DELETE** using a custom query, you must add the `@Modifying` annotation.

Also, modifying queries usually require an active transaction, so you often add `@Transactional`.

### Example
```java
public interface UserRepository extends JpaRepository<User, Long> {

    @Modifying
    @Transactional
    @Query("UPDATE User u SET u.active = false WHERE u.lastLoginDate < :date")
    int deactivateInactiveUsers(@Param("date") LocalDate date);
    // Returns an int representing the number of rows affected
}
```

---

## 5. Projections and DTO Mapping
Sometimes your `User` entity has 50 fields, but for a specific dropdown menu on the UI, you only need the `id` and `fullName`. Fetching the entire object (including relationships) is bad for performance.

**Projections** allow you to fetch only specific data.

### A. Interface-based Projection (Closed Projection)
Spring creates a proxy on the fly.

1. **Define an Interface:**
```java
public interface UserSummary {
    String getFirstName();
    String getLastName();
}
```

2. **Use it in Repository:**
```java
// Spring knows to only select first_name and last_name
List<UserSummary> findByAge(Integer age);
```

### B. Class-based Projection (DTOs)
The query result is mapped directly into a constructor of a DTO (Data Transfer Object).

```java
public class UserDto {
    private String email;
    private String city;
    
    public UserDto(String email, String city) {
        this.email = email;
        this.city = city;
    }
    // getters...
}

// In Repository
@Query("SELECT new com.example.dto.UserDto(u.email, u.address.city) FROM User u")
List<UserDto> findAllUserDtos();
```

---

## Summary Checklist
When choosing a query method:

1.  **Simple logic?** Use **Derived Methods** (`findByEmail`).
2.  **Complex logic?** Use **JPQL** (`@Query("SELECT...")`).
3.  **Database specific features?** Use **Native Queries** (`nativeQuery = true`).
4.  **Updating data?** Use **@Modifying**.
5.  **Performance issue?** Use **Projections** to select partial data.
