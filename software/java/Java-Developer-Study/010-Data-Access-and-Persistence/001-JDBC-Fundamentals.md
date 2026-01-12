Here is a detailed explanation of **JDBC (Java Database Connectivity) Fundamentals**.

---

# 010 - Data Access and Persistence
## 001 - JDBC Fundamentals

**JDBC** allows Java applications to communicate with relational databases (like MySQL, PostgreSQL, Oracle, SQL Server) in a standard way. Before frameworks like Hibernate or Spring Data existed, everyone wrote raw JDBC code. Even today, those frameworks rely on JDBC under the hood, so understanding this is critical for debugging and performance tuning.

### 1. The Core JDBC Workflow
To perform any database operation, you generally follow these five steps:

1.  **Load the Driver:** Tell Java which database software you are using.
2.  **Establish a Connection:** Log in to the database.
3.  **Create a Statement:** Prepare the SQL query you want to run.
4.  **Execute & Process Results:** Send the query and handle the data returned.
5.  **Close Resources:** Disconnect to prevent memory leaks.

---

### 2. Deep Dive into Components

#### A. Loading Drivers
A **Driver** is a library (usually a `.jar` file like `mysql-connector-java`) that acts as a translator between generic Java code and the specific database protocol.

*   **Old Way:** You had to explicitly load the class: `Class.forName("com.mysql.cj.jdbc.Driver");`
*   **Modern Way:** As long as the driver jar is in your classpath (e.g., in your Maven dependencies), Java automatically detects it.

#### B. Connections (`Connection` interface)
The `Connection` object represents a physical session with the database.
*   **Creating it:** You use `DriverManager.getConnection(url, user, password)`.
*   **The URL:** A special string identifying the DB location, e.g., `jdbc:mysql://localhost:3306/mydb`.
*   **Cost:** Creating a connection is an **expensive** operation (network handshake, authentication). You don't want to create a new one for every single user request (see *Connection Pooling* below).

#### C. Statements vs. PreparedStatements
This is the most important distinction in JDBC.

**1. `Statement` (The unsafe way)**
Used for simple SQL queries with no parameters.
```java
Statement stmt = conn.createStatement();
// DANGEROUS: Concatenating input directly into the string
stmt.execute("SELECT * FROM users WHERE name = '" + userName + "'");
```

**2. `PreparedStatement` (The safe, standard way)**
Used for parameterized queries. The database "pre-compiles" the SQL structure, and you fill in the blanks later.
*   **Performance:** Faster if executed multiple times.
*   **Security:** Prevents **SQL Injection**.

```java
String sql = "SELECT * FROM users WHERE name = ?";
PreparedStatement pstmt = conn.prepareStatement(sql);
pstmt.setString(1, "Alice"); // Replaces the first '?'
ResultSet rs = pstmt.executeQuery();
```

#### D. The ResultSet
The `ResultSet` is a table of data representing a database result set. It acts like a cursor (pointer) pointing *before* the first row of data.
*   **`rs.next()`:** Moves the cursor to the next row. Returns `false` when there are no more rows.
*   **Getters:** You retrieve data by column name or index (e.g., `rs.getInt("id")`, `rs.getString("email")`).

---

### 3. Practical Code Example
Here is how modern JDBC code looks using **Try-with-Resources** (which automatically closes the connection, statement, and result set so you don't leak memory).

```java
import java.sql.*;

public class JdbcExample {
    public static void main(String[] args) {
        // Database credentials
        String url = "jdbc:postgresql://localhost:5432/mydb";
        String user = "admin";
        String password = "secret_password";

        String query = "SELECT id, username FROM users WHERE age > ?";

        // Try-with-resources ensures .close() is called automatically
        try (Connection conn = DriverManager.getConnection(url, user, password);
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            // Set the parameter (fill the '?')
            pstmt.setInt(1, 18);

            // Execute the query
            try (ResultSet rs = pstmt.executeQuery()) {
                // Iterate through results
                while (rs.next()) {
                    int id = rs.getInt("id");
                    String username = rs.getString("username");
                    System.out.println("User: " + id + " - " + username);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
```

---

### 4. SQL Injection Prevention
SQL Injection occurs when a hacker manipulates your input to run malicious SQL.

**The Vulnerability (String Concatenation):**
If `userInput` is generic text like `"Smith"`, it works.
But if `userInput` is `"Smith' OR '1'='1"`, the resulting query becomes logic that always evaluates to true, potentially dumping your whole database.

**The Solution (`PreparedStatement`):**
When you use `pstmt.setString(1, userInput)`, the JDBC driver escapes the input. It treats the input strictly as **data**, never as executable **code**. Even if the user types SQL commands, the database just looks for a user literally named "Smith' OR '1'='1".

---

### 5. Transactions
By default, JDBC is in **Auto-Commit** mode. Each SQL statement is saved immediately. To group multiple operations into a single atomic Transaction (all or nothing):

1.  **Turn off Auto-Commit:** `conn.setAutoCommit(false);`
2.  **Run Queries:** Perform updates, inserts, deletes.
3.  **Commit:** If everything worked, save it: `conn.commit();`
4.  **Rollback:** If an error happens (in `catch` block), undo changes: `conn.rollback();`

```java
try {
    conn.setAutoCommit(false); // Start transaction
    
    // ... run multiple SQL updates ...

    conn.commit(); // Save changes
} catch (SQLException e) {
    conn.rollback(); // Undo changes if something failed
}
```

---

### 6. Connection Pooling
In real-world enterprise applications, you never use `DriverManager.getConnection()` directly for every request because it is too slow.

Instead, you use a **Connection Pool** (like **HikariCP**, **Apache DBCP**, or **C3P0**).
1.  The app starts up and creates, say, 10 open connections to the database.
2.  When a thread needs to save data, it "borrows" a connection from the pool.
3.  It does the work.
4.  It "closes" the connection (which actually just returns it to the pool to be reused).

**Why this is huge:** It allows Java applications to handle thousands of requests per second efficiently.
