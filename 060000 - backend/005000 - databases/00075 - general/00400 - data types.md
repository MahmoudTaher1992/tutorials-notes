# SQL Data Types

* Numeric Data Types
    * Integers (Whole Numbers):
        * TINYINT
        * SMALLINT
        * INT
        * BIGINT


* Why do we have to pick the right data type
    * Data Integrity & Validation
        * the data types stored is of correct types
    * Storage Efficiency
        * data doesn't use more storage more than it needs/might need
            * if you store TINYINT values in BIGINT, you will lose storage and you will feel it with huge amounts of records
    * Performance (Speed)
        * Faster I/O
        * Less RAM Usage
        * Faster Comparisons & Sorting
        * Efficient Indexing