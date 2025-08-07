# Concurrency Control

* is the process of managing simultaneous operations, without them interfering with one another
* goals
    * isolation
    * consistency

* concurrency problems
    * lost update problem
        * one transaction update is overwritten by another transaction
        * i.e.  
            * two transactions are trying to add 1 to a 100, the result is 101 instead of 102

    * dirty read problem
        * i.e.
            * one transaction is using an uncommitted change
            * if the committing transaction rolls back, the one that used the dirty value has a wrong value

    * non-repeatable read problem
        * i.e.
            * a transaction reads the inventory of a product, it is 10
            * after 5 statements, it reads it again and it is 5

    * phantom read
        * i.e.
            * a transaction runs a query, it gets a result
            * a transaction runs the same query, it gets a different results (added/removed)

* Solution
    * Locking-Based Protocols (Pessimistic)
        * Pessimistic
            * because it assumes the conflicts will happen, and it prevents it
        * it does that using locks
        * locks types
            * shared locks (read lock)
                * multiple transactions can have read locks on the same resources/data
                * additional shared locks can be added
                * no writes or writes locks can be done on those resources
                    * after all the locks are remove, this can happen
            * exclusive locks (write locks)
                * only one write lock can be added on the resource
                * no one can read/write or add read/write locks on the resource until it is released
        * 