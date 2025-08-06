# Database Design

## The Three-Phase Design Process

* Conceptual Design
    * the architect's first sketch
    * figure out what information you need to store
    * focus on the big ideas
        * how they relate to each other
    * The goal is a high-level map
    * The final drawing here is called a Conceptual Schema

* Logical Design
    * detailed blueprint
    * translate Conceptual Design into the language of a specific database model
        * like the relational model
    * This is called the Logical Schema

* Physical Design
    * You decide exactly how the data will be stored on the disk 
    * i.e.
        * choose file types
        * create indexes
        * ...
    * This is the Physical Schema


## The Entity-Relationship (E-R) Model

* set of drawing that explain the Conceptual Design

* Entities
    * main "things" or "nouns" you want to keep track
    * i.e.
        * EMPLOYEE
        * PROJECT
        * DEPARTMENT
        * ...

* Attributes
    * details about an entity
    * i.e.
        * An EMPLOYEE entity might have attributes like Name, Age, and Salary.
        * ...

* Relationships
    * show how entities are connected
    * i.e.
        * An EMPLOYEE works in a DEPARTMENT
        * ...

* E-R diagram details and rules
    * how many?
        * relationShips
            * (minimum, maximum)
            * (1, 1)
            * (1, N)
            * ...

    * keys
        * primary key
        * foreign key

    * Generalization
        * adding `is` relationships
        * CAT is ANIMAL
        * DOG is ANIMAL 