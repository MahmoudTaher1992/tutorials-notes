# The relational model

* is the foundation for most used databases SQL
* designed to achieve data independence
    * data is organized for users is separate from how it's physically stored on disk.

* Data organization
    * Data is stored in tables
    * Each table has columns (attributes) and rows (tuples)

* NULL represents non existing data

* constraints
    * Key Constraints
        * one or more attributes that uniquely identifies each row in a table
        * primary key must be used for each table
    * Foreign Keys
        * set of attributes in one table whose values must match the primary key values of a row in another table
    * Row constraints
        * Aa cel must equal the multiple of 2