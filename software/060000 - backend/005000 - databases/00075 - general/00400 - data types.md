# SQL Data Types

* Numeric Data Types
    * Integers (Whole Numbers):
        * TINYINT
        * SMALLINT
        * INT
        * BIGINT
    * Decimal/Exact Numeric (For precise numbers with decimals)
        * NUMERIC(precision, scale) or DECIMAL(precision, scale)
            * precision is the total number of digits
            * scale is the total number of digits after the decimal point
    * Approximate Numeric (For numbers where small rounding errors are okay)
        * FLOAT(precision)
        * REAL
        * DOUBLE PRECISION
            * more precise than real

* String/Text Data Types
    * CHAR(length)
        * exact length
        * if you enter shorter text, spaces will fill up the remaining spaces
        * space will always be filled
    * VARCHAR(length)
        * variable length
        * it won't take up all the allocated space
    * TEXT, NTEXT, CLOB, BLOB
        * store very large text blocks
        * variable length like VARCHAR

* Date and Time Data Types 
    * DATE
        * YYYY-MM-DD
    * TIME
        * HH:MM:SS
    * DATETIME or TIMESTAMP
        * YYYY-MM-DD HH:MM:SS

* Boolean Data Types
    * BOOLEAN or BOOL
        * true or false
        * TINYINT or BIT can be used instead

* Binary Data Types (For raw, unstructured data like images)
    * BINARY(length)
    * VARBINARY(length)
    * BLOB

* Spatial Data Types (For geographic information)
    * GEOMETRY
        * locations on map
        * boundaries of a city
    * GEOGRAPHY

* JSON/XML Data Types (For semi-structured data)
    * JSON
    * XML

* Questions
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