# Normalization

* the problem
    * Redundancy
        * the repeating of information
        * i.e.
            * storing teachers data in multiple places

        * side effects
            * CRUD
                * you will have to create, update and delete in n places

* Normalization process of organizing data in a database to eliminate redundancy and improve data integrity 

* normalization levels
    * First Normal Form (1NF)
        * each cell must contain only a single value
    * Second Normal Form (2NF)
        * each column must be fully dependent on the composite primary key
        * will be seen in tables with composite keys (not single primary key)
        * i.e.
            * student name should not be saved in student-enrollment table
            * it should be in the students table (where it will fully depend on the PK)
    * Third Normal Form (3NF)
        * 2NF + a non key attribute should not depend on other non key attributes
        * i.e.
            * BookID, Title, Author, AuthorNationality
            * AuthorNationality should not be in this table !!
    * Boyce-Codd Normal Form (BCNF)
    * Fourth Normal Form (4NF)