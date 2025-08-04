# Stored procedures

* A stored procedure is a named block of pre-compiled SQL code
    * stored inside the database itself
    * accept input parameters
    * perform a series of actions
    * return output parameters or result sets

* Pros
    * Performance
        * Pre-Compilation & Cached Execution Plans
            * saves compilation time
            * saves execution plans creation time
        * Reduce network traffic
            * the data needed to be sent to the database server to be processed
    * Security
        * prevents SQL injection
    * Reusability
        * write it once in the db instead of many places across the app

* Cons
    * vendor lock-in
    * no version control
    * hard to debug
    * Separation of control violation
        * as the business logic should be in the app layer, not the database layer
    * scalability issues
        * it is hard and costly to scale the database compared to the applications