Formal Relational Query Languages
4.1. Relational Algebra
4.1.1. Core Unary Operations (SELECT/Restriction σ, PROJECT/Projection π, RENAME ρ)
4.1.2. Set Theory Operations (UNION ∪, INTERSECTION ∩, DIFFERENCE/EXCEPT −)
4.1.3. Binary Operations (CARTESIAN PRODUCT ×, JOIN ⋈, DIVISION ÷)
4.1.4. Types of Joins (THETA, EQUIJOIN, NATURAL, OUTER)
4.1.5. Extended Operators (EXTEND, SUMMARIZE, GROUP, UNGROUP)
4.2. Relational Calculus
4.2.1. Tuple Relational Calculus (TRC)
4.2.2. Domain Relational Calculus (DRC)
4.3. Other Formalisms
4.3.1. Datalog
4.3.2. Query-By-Example (QBE)



Of course. This is an excellent table of contents that covers the theoretical foundations of how we "ask questions" of a relational database. Let's break down each part in detail.

### Introduction: What are Formal Relational Query Languages?

Before diving into the sections, it's important to understand the "why." Formal relational query languages are not languages you typically write code in (like SQL). Instead, they are the **mathematical foundation** upon which practical languages like SQL are built.

They serve two main purposes:
1.  **To provide a precise way of defining queries.** They are unambiguous and based on mathematical principles (set theory and logic).
2.  **To define the "expressive power" of a query language.** A language is considered **relationally complete** if it can express any query that can be expressed in relational algebra.

The two main formalisms, **Relational Algebra** and **Relational Calculus**, represent two different ways of thinking about queries:
*   **Relational Algebra (Procedural):** You specify *how* to get the result. It's a step-by-step procedure using operators to build the final result set (e.g., "First, take the `Employees` table, then filter it to get only the Sales department, then select just the `Name` and `Salary` columns").
*   **Relational Calculus (Declarative):** You specify *what* the result should be. You describe the properties of the desired rows without saying how to find them (e.g., "Get me the names and salaries of all employees who are in the Sales department").

---

### 4.1. Relational Algebra

Relational Algebra is a procedural query language. It takes one or more relations (tables) as input and produces a new relation as output. This property, known as **closure**, is powerful because it allows you to chain operations together, using the output of one operation as the input for the next.

#### 4.1.1. Core Unary Operations (Operating on a single table)

*   **SELECT / Restriction (σ)**
    *   **Purpose:** To filter rows based on a condition. It performs a *horizontal* slice of a table.
    *   **How it works:** You provide a condition (a predicate), and the SELECT operator returns a new table containing only the rows from the original table that satisfy the condition.
    *   **Example:** `σ_ (Department = 'Sales') (Employees)` would return all rows from the `Employees` table where the `Department` column has the value 'Sales'.
    *   **SQL Equivalent:** The `WHERE` clause.

*   **PROJECT / Projection (π)**
    *   **Purpose:** To select specific columns from a table. It performs a *vertical* slice of a table.
    *   **How it works:** You provide a list of column names, and the PROJECT operator returns a new table containing only those columns. It automatically eliminates duplicate rows.
    *   **Example:** `π_ (Name, Salary) (Employees)` would return a new table with only the `Name` and `Salary` columns for all employees.
    *   **SQL Equivalent:** The column list in the `SELECT` clause (e.g., `SELECT Name, Salary FROM ...`).

*   **RENAME (ρ)**
    *   **Purpose:** To change the name of a relation or its attributes (columns).
    *   **How it works:** This is a simple but essential utility operator. It's crucial when you need to join a table to itself (a self-join) or to give a clear name to the result of a complex expression.
    *   **Example:** `ρ_ (Emps, (EmpName, EmpSalary)) (π_ (Name, Salary) (Employees))` renames the result of the projection to `Emps` and its columns to `EmpName` and `EmpSalary`.
    *   **SQL Equivalent:** The `AS` keyword (e.g., `FROM Employees AS E`).

#### 4.1.2. Set Theory Operations

These operations treat tables as sets of rows. For these to work, the two tables must be **union-compatible**, meaning they have the same number of columns, and the data types of the corresponding columns are compatible.

*   **UNION (∪):** Returns a table containing all rows that are in the first table, the second table, or both. Duplicate rows are eliminated.
*   **INTERSECTION (∩):** Returns a table containing only the rows that appear in *both* the first and the second table.
*   **DIFFERENCE / EXCEPT (−):** Returns a table containing rows that are in the first table but *not* in the second. The order matters (`TableA - TableB` is different from `TableB - TableA`).
*   **SQL Equivalent:** `UNION`, `INTERSECT`, and `EXCEPT` (or `MINUS` in Oracle).

#### 4.1.3. Binary Operations (Operating on two tables)

*   **CARTESIAN PRODUCT (×)**
    *   **Purpose:** To combine every row from one table with every row from another table.
    *   **How it works:** If `TableA` has `m` rows and `TableB` has `n` rows, `TableA × TableB` will have `m * n` rows. It's a brute-force combination and is rarely used alone because it generates a massive, often meaningless, result. However, it's the fundamental basis for the JOIN operation.
    *   **SQL Equivalent:** `FROM TableA, TableB` (old syntax) or `CROSS JOIN`.

*   **JOIN (⋈)**
    *   **Purpose:** To combine related rows from two tables into a single row. This is arguably the most important operation in relational algebra.
    *   **How it works:** A JOIN is fundamentally a Cartesian Product followed by a SELECT (filter). You specify a condition, and only the combined rows that satisfy the condition are kept.
    *   **Example:** `Employees ⋈_(Employees.DeptID = Departments.ID)_ Departments` combines rows from `Employees` and `Departments` where the department IDs match.

*   **DIVISION (÷)**
    *   **Purpose:** To answer "for all" queries. This is the most complex operator.
    *   **How it works:** Given `TableA(x, y)` and `TableB(y)`, `A ÷ B` returns all the `x` values from `A` that are associated with *every single* `y` value in `B`.
    *   **Example:** If you have a `Students(StudentID, CourseID)` table and a `RequiredCourses(CourseID)` table, `Students ÷ RequiredCourses` would give you the `StudentID`s of students who have taken *all* the required courses.
    *   **SQL Equivalent:** There is no direct SQL operator. It is typically implemented using complex queries with `NOT EXISTS` or `GROUP BY` and a `HAVING COUNT(...)` clause.

#### 4.1.4. Types of Joins

This section details the common variations of the general JOIN (⋈) operation.

*   **THETA JOIN:** The most general form of join where the join condition (the "theta") can be any comparison operator (`=`, `<`, `>`, `≥`, etc.).
*   **EQUIJOIN:** A specific type of Theta Join where the condition *only* uses equality (`=`). This is the most common type of join.
*   **NATURAL JOIN:** A special type of Equijoin. It automatically joins two tables on all columns that have the same name. The duplicate join column is automatically removed from the result. It's convenient but can be dangerous if table schemas change unexpectedly.
*   **OUTER JOIN:** Standard joins (also called inner joins) only keep rows that have a match in the other table. Outer joins are used to also keep rows that *do not* have a match.
    *   **LEFT OUTER JOIN:** Keeps all rows from the left table. If a row has no match in the right table, the columns from the right table are filled with `NULL`.
    *   **RIGHT OUTER JOIN:** Keeps all rows from the right table.
    *   **FULL OUTER JOIN:** Keeps all rows from both tables, filling with `NULL`s where matches don't exist.

#### 4.1.5. Extended Operators

The core operators are powerful, but they can't perform calculations or aggregations. Extended operators add these capabilities.

*   **EXTEND:** Adds a new calculated column to a relation.
*   **SUMMARIZE / AGGREGATION:** Applies aggregate functions like `SUM`, `AVG`, `COUNT`, `MIN`, `MAX`.
*   **GROUP / UNGROUP:** Works with SUMMARIZE. It partitions the table into groups based on some attributes, allowing SUMMARIZE to be applied to each group individually.
*   **SQL Equivalent:** These map directly to aggregate functions (`SUM(...)`, etc.) and the `GROUP BY` clause.

---

### 4.2. Relational Calculus

Relational Calculus is a non-procedural, declarative language. You describe the set of tuples you want using logical predicates. It's the formal basis for SQL's declarative nature. There are two main flavors:

#### 4.2.1. Tuple Relational Calculus (TRC)

*   **Core Idea:** The variables in your query range over **tuples** (entire rows).
*   **Notation:** A query is of the form `{ t | P(t) }`, which reads as: "Return the set of all tuples `t` for which the predicate (condition) `P` is true."
*   **Example:** To find all employees with a salary over $50,000, you would write: `{ t | t ∈ Employees ∧ t.Salary > 50000 }`.

#### 4.2.2. Domain Relational Calculus (DRC)

*   **Core Idea:** The variables in your query range over **domain values** (individual values within cells), not entire rows.
*   **Notation:** A query is of the form `{ <x, y, ...> | P(x, y, ...) }`, which reads as: "Return the set of tuples with attributes x, y, ... for which the predicate `P` is true."
*   **Example:** To find the names and departments of employees with a salary over $50,000: `{ <n, d> | ∃s (<n, d, s> ∈ Employees ∧ s > 50000) }`. This reads: "Find all name-department pairs `<n, d>` for which there **exists** a salary `s` such that the tuple `<n, d, s>` is in the Employees relation and `s` is greater than 50000."

---

### 4.3. Other Formalisms

These are other important, though less foundational, formal languages for querying databases.

#### 4.3.1. Datalog

*   **What it is:** A declarative logic programming language that is a subset of Prolog. It is used for deductive databases.
*   **Key Feature:** It expresses queries as logical rules. Its main strength is its ability to express **recursive queries** elegantly, something standard relational algebra and calculus cannot do. For example, finding all the direct and indirect subordinates of a manager in an organizational chart.
*   **Modern SQL Equivalent:** Recursive queries in Datalog are now handled in SQL using Common Table Expressions (CTEs), specifically the `WITH RECURSIVE` clause.

#### 4.3.2. Query-By-Example (QBE)

*   **What it is:** A graphical, two-dimensional query language. It is considered the first graphical query language.
*   **How it works:** The user interacts with skeleton tables on a screen. To form a query, they fill in example values and conditions directly into the cells of these skeletons. The system then translates this visual representation into a formal query (internally, it's based on Domain Relational Calculus).
*   **Legacy:** While not widely used today in its original form, its influence is seen in many modern database GUI tools (like Microsoft Access's query designer) that allow users to build queries visually.