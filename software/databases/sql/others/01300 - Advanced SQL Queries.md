13. Advanced SQL Queries
13.1. Joining Multiple Tables (INNER, OUTER, CROSS, Self-Joins)
13.2. Set Operations (UNION, INTERSECT, EXCEPT)
13.3. Subqueries (Scalar, Multi-row, Correlated, EXISTS)
13.4. Common Table Expressions (CTEs) and Recursive Queries
13.5. Window Functions (OVER, PARTITION BY, RANK, LEAD, LAG)


Of course! As your super teacher for Database Systems, I will gladly provide a detailed explanation of these advanced SQL topics. Mastering these concepts is what separates a basic user from a truly proficient data professional. They allow you to solve complex problems elegantly and efficiently.

Let's break down each section in detail, following the structured format you like.

# Advanced SQL Queries

## 13.1. Joining Multiple Tables

*   **Goal**: [To combine rows from two or more tables based on a related column between them. This is the core mechanism for retrieving data that is spread across a normalized database.]
*   **Analogy**: [Imagine you have two separate lists: one with `Student Names` and their `Student IDs`, and another with `Course Names` and the `Student IDs` of those enrolled. A `JOIN` is the process of matching the `Student ID` from both lists to create a single, combined list showing which student is in which course.]

*   ### `INNER JOIN`
    *   **Function**: [Returns only the rows that have matching values in **both** tables. It's the intersection of the two tables based on the join condition.]
    *   **When to Use**: [This is the most common type of join. Use it when you only want to see records that have a direct relationship in another table.]
    *   **Example**: [To get a list of employees and the name of the department they work in.]
        ```sql
        SELECT e.FirstName, d.DepartmentName
        FROM Employees e
        INNER JOIN Departments d ON e.DepartmentID = d.DepartmentID;
        ```

*   ### `OUTER JOIN`
    *   **Function**: [Returns all rows from one table, and the matched rows from the second table. If there is no match for a row, the columns from the second table are filled with `NULL` values.]
    *   **When to Use**: [When you need to see all records from one table, even if they don't have a corresponding record in the other.]
    *   **Types**:
        *   **`LEFT OUTER JOIN` (or `LEFT JOIN`)**:
            *   [Returns **all** rows from the **left** table (the first one mentioned), and only the matching rows from the right table.]
            *   **Example**: [Find all employees and their department, but also include employees who have not yet been assigned to any department.]
                ```sql
                SELECT e.FirstName, d.DepartmentName
                FROM Employees e
                LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID;
                ```
        *   **`RIGHT OUTER JOIN` (or `RIGHT JOIN`)**:
            *   [The opposite of a `LEFT JOIN`. Returns **all** rows from the **right** table, and only the matching rows from the left table.]
            *   **Example**: [Find all departments, and list the employees in them, but also include departments that currently have no employees.]
        *   **`FULL OUTER JOIN`**:
            *   [Returns all rows when there is a match in either the left or the right table. It's a combination of `LEFT` and `RIGHT JOIN`.]

*   ### `CROSS JOIN`
    *   **Function**: [Returns the **Cartesian product** of the two tables. This means every row from the first table is combined with every row from the second table.]
    *   **When to Use**: [This is used less frequently. It's useful for generating all possible combinations of data, such as all possible sizes and colors for a T-shirt.]
    *   **Warning**: [If you join two large tables, the result set can be enormous (`Table A rows * Table B rows`), so use it with caution.]

*   ### `Self-Join`
    *   **Function**: [This is a regular join, but the table is joined with **itself**. You do this by giving the table two different aliases.]
    *   **When to Use**: [When a table contains a reference to itself, such as in a hierarchical relationship.]
    *   **Example**: [In an `Employees` table where each employee has a `ManagerID` that is also an `EmployeeID`, you can use a self-join to list each employee and their manager's name.]
        ```sql
        SELECT
            e.FirstName AS EmployeeName,
            m.FirstName AS ManagerName
        FROM Employees e
        LEFT JOIN Employees m ON e.ManagerID = m.EmployeeID;
        ```

## 13.2. Set Operations

*   **Goal**: [To combine the results of two or more `SELECT` statements into a single result set. For these to work, the `SELECT` statements must be **union-compatible**, meaning they return the same number of columns with compatible data types.]

*   ### `UNION`
    *   [Combines the result sets of two or more `SELECT` statements and **removes duplicate rows**.]
*   ### `UNION ALL`
    *   [Combines the result sets but **keeps all duplicate rows**. It's faster than `UNION` because it doesn't have to check for duplicates.]
*   ### `INTERSECT`
    *   [Returns only the rows that appear in the result sets of **both** `SELECT` statements.]
*   ### `EXCEPT` (or `MINUS` in Oracle)
    *   [Returns the rows from the first query's result set that **do not** appear in the second query's result set.]

## 13.3. Subqueries

*   **Goal**: [To use the result of one query (the "inner query" or subquery) as the input for another query (the "outer query"). A subquery is a `SELECT` statement nested inside another statement.]

*   ### Types of Subqueries
    *   **Scalar Subquery**:
        *   [A subquery that returns exactly **one row and one column** (a single value). It can be used anywhere a single value is expected.]
        *   **Example**: [Find employees who earn more than the average salary.]
            ```sql
            SELECT FirstName, Salary FROM Employees
            WHERE Salary > (SELECT AVG(Salary) FROM Employees);
            ```
    *   **Multi-row Subquery**:
        *   [A subquery that returns **multiple rows**. It is often used with operators like `IN`, `ANY`, or `ALL`.]
        *   **Example**: [Find all employees who work in a department located in the USA.]
            ```sql
            SELECT FirstName FROM Employees
            WHERE DepartmentID IN (SELECT DepartmentID FROM Departments WHERE Location = 'USA');
            ```
    *   **Correlated Subquery**:
        *   [An inner query that depends on the outer query for its values. The subquery is executed **once for each row** processed by the outer query. This can be powerful but potentially slow if not written carefully.]
        *   **Example**: [Find all employees whose salary is the maximum for their specific department.]
            ```sql
            SELECT e1.FirstName, e1.Salary, e1.DepartmentID
            FROM Employees e1
            WHERE e1.Salary = (SELECT MAX(e2.Salary) FROM Employees e2 WHERE e2.DepartmentID = e1.DepartmentID);
            ```

*   ### `EXISTS` Operator
    *   **Function**: [A special operator used with subqueries that returns `TRUE` if the subquery returns **at least one row**, and `FALSE` otherwise. This is often more efficient than `IN` because the database can stop searching as soon as it finds a single matching row.]
    *   **Example**: [Find all departments that have at least one employee.]
        ```sql
        SELECT DepartmentName
        FROM Departments d
        WHERE EXISTS (SELECT 1 FROM Employees e WHERE e.DepartmentID = d.DepartmentID);
        ```

## 13.4. Common Table Expressions (CTEs)

*   **Goal**: [To create a named, temporary result set that you can reference within a `SELECT`, `INSERT`, `UPDATE`, or `DELETE` statement. CTEs are defined using a `WITH` clause.]
*   **Benefits**:
    *   **Readability**: [They break down long, complex queries into logical, readable steps.]
    *   **Reusability**: [A CTE can be referenced multiple times within the same main query.]
*   **Recursive Queries**:
    *   [CTEs are the standard SQL way to write recursive queries, which are essential for querying hierarchical data (like an organizational chart or product categories).]
    *   **Structure**: [A recursive CTE must have an **anchor member** (the starting point) and a **recursive member** (which joins back to the CTE itself), combined with a `UNION ALL`.]
    *   **Example**: [Find the entire chain of command for a specific employee.]
        ```sql
        WITH RECURSIVE OrgChart AS (
            -- Anchor member: the starting employee
            SELECT EmployeeID, FirstName, ManagerID, 0 AS Level
            FROM Employees
            WHERE EmployeeID = 1 -- Start with the CEO

            UNION ALL

            -- Recursive member: find employees who report to the previous level
            SELECT e.EmployeeID, e.FirstName, e.ManagerID, o.Level + 1
            FROM Employees e
            INNER JOIN OrgChart o ON e.ManagerID = o.EmployeeID
        )
        SELECT * FROM OrgChart;
        ```

## 13.5. Window Functions

*   **Goal**: [To perform a calculation across a set of table rows that are somehow related to the current row. Unlike aggregate functions, they **do not collapse** the rows; they return a value for **each** row based on a "window" of related rows.]
*   **Key Clause**: [The `OVER()` clause, which defines the window (the set of rows) the function operates on.]
*   **Core Concepts**:
    *   **`PARTITION BY`**: [Divides the rows into partitions (groups). The window function is then applied independently to each partition and reset for the next. It's like `GROUP BY`, but for window functions.]
*   **Common Functions**:
    *   **Ranking Functions**:
        *   `RANK()`: [Assigns a rank to each row within a partition. Leaves gaps in the ranking for ties (e.g., 1, 2, 2, 4).]
        *   `DENSE_RANK()`: [Assigns a rank without gaps for ties (e.g., 1, 2, 2, 3).]
    *   **Offset Functions**:
        *   `LEAD()`: [Accesses data from a subsequent row in the window.]
        *   `LAG()`: [Accesses data from a previous row in the window.]
*   **Example**: [Rank employees within each department based on their salary, from highest to lowest.]
    ```sql
    SELECT
        FirstName,
        DepartmentName,
        Salary,
        RANK() OVER (PARTITION BY DepartmentName ORDER BY Salary DESC) AS SalaryRankInDept
    FROM Employees;
    ```
    *   [This query would look at all the 'Sales' employees, rank them, then look at all the 'Marketing' employees, and rank them separately, all in one result set.]