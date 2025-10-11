# Logical Design

* Goal
    * convert high level conceptual schema into a logical schema

* steps
    * Restructuring
        * Tweaking and optimizing the blueprint (E-R model)
    * Translation
        * Converting the E-R model into actual tables

* Restructuring E-R schema
    * make sure the plan is as good as it can be through analysis
    * analysis
        * Analyzing/reviewing Redundancies
            * where you store data that could be figured out from other data
        * Removing Generalizations
            * Generalizations is when you have parent-child relationship
            * solutions
                * Collapse into the Parent
                    * ANIMALs instead of CATS and DOGS
                    * add type column and set it
                    * it might lead into empty fields
                * Collapse into the Children
                    * CATS and DOGS instead of ANIMALs
                * Use Relationships
                    * Use 3 tables together with relationship between them

    * Partitioning and Merging
        * Partitioning
            * split one entity into two
            * This can make operations faster
        * Merging
            * This is the opposite
            * use it if you always query and update a multiple tables together

    * Selecting a Primary Identifier
        * every table must have one key

* Translation into the Relational Model
    * Creating the Tables
    * Entities and Many-to-Many Relationships
        * Each entity becomes its own table
        * A many-to-many relationship also gets its own table
    * One-to-Many Relationships
        * You don't create a new table for the relationship
        * Use PK and FK only
    * One-to-One Relationships
        * Similar to 1-n relationship
        * but the FK will also be PK