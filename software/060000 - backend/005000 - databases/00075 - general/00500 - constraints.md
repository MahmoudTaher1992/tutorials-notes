# Constraints

* Constraint is a rule that you define and enforce on the data in your database
    * they are validators the prevent invalid data from being entered, updated or deleted

* Constraints importance
    * Data Integrity
        * the correctness of the data
    * Consistency
        * the relationship of different pieces of data are always maintained
    * Reliability
        * you can trust the data you retrieve
    * Application Logic Simplification
        * you write the code once in the database, you don't have to write it in every app the connects to the database. They will have to handle it because errors will show up
    * Performance
    * Data Security
        * invalid data can lead to security vulnerabilities

* Types of Constraints
    * Data types
    * Entity Integrity (Row Uniqueness/Identity)
        * PRIMARY KEY
        * UNIQUE
            * allows null duplicates
    * Referential Integrity
        * FOREIGN KEY
        * actions
            * ON DELETE/ON UPDATE
                * describes the action to be done, if the parent row is updated/deleted
                * actions
                    * NO ACTION
                    * CASCADE
                        * deletes child rows or updates foreign keys
                    * SET NULL
                    * SET DEFAULT
    * Assertion
        * checks that are done on the entire database or multiple tables or inside the table

* Constraint's violations
    * when violations occur
        * the transaction is rolled back
        * return error message

* Deferrable Constraints
    * not in all databases
    * some constraints can be defined as DEFERRABLE
        * the constrain check isn't performed immediately after each statement
        * it is done at the end of the transaction
    * helpful when the constraint is violated but resolved before the end of the transaction