# Triggers

* special kind of stored procedure
* automatically executed/fired when a specific data modification event occurs on a table or view

* i.e.
    * Event
        * Someone tries to insert a new row, update an existing row, or delete a row
    * Timing
        * Just before the event happens
        * or just after it happens.
    * Action
        * executes a pre-defined set of SQL statements


* Row-level vs. Statement-level
    * for some databases
    * i.e.
        * FOR EACH ROW
            * even if the statement targets multiple rows
        * FOR EACH STATEMENT
            * even if the statement targets one/multiple rows

* Use cases
    * Auditing and Logging
    * Enforcing Complex Business Rules/Data Validation
    * Automating Derived Data/Maintaining Referential Integrity 
    * Data Synchronization/Replication
    * Security/Access Control
        * Prevent updates to specific columns outside of business hours

* cons
    * Hidden Logic + Debugging Challenges
        * we don't know what happened, from the stored procedure or the business logic
    * Complexity and Maintainability
    * Performance Overhead
    * Concurrency Issues & Deadlocks
    * Recursion
    * Portability
        * triggers can significantly between different database systems, making migrating databases more challenging 