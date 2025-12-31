# Database migrations

* is a programmatic and version-controlled way of managing changes to your database schema over time.

* version-controlled
    * track the changes

* migration system/tool
    * should contain
        * A series of migration scripts
        * A tooling mechanism
            * a tool that know which migrations are run against the database

* pros
    * Consistency Across Environments (developer/staging/live)
    * Version Control & History
    * Automation
    * Error Reduction
    * Collaboration

* Zero-Downtime Migrations
    * a strategy used to change the schema without causing a downtime
    * steps (to rename a column)
        * Migration 1
            * create a new column with the new name (nullable)
        * modify the application code
            * make it read from the new column and if it is null, read it from the original column
            * make it write to both new, and old column
        * Data migration
            * set new_column = old_column
        * Migration 2
            * make the new column not null
        * modify the application code
            * make it read and write to the new column
            * make it read only from the new column
            * remove the references and usage of the old column
        * migration 3
            * drop the old column