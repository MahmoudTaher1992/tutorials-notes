# Transactions

* the problem
    * The world is unreliable and chaotic
        * Things fail
            * i.e.
                * Power cuts
                * Server crashes
                * Network drops
                * Hard drives die
                * ...
        * Pressure
            * every one is trying to do everything at once
            * multiple users try to read, write same data at once

* the solution
    * following the ACID principles
        * Atomicity
        * Consistency
        * Isolation
        * Durability

* Nested transactions
    * if a transaction has child transactions
    * the child transactions will only 