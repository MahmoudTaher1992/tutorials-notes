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
    * the child transaction's commits will only be permanent, if the parent commits successfully

* Distributed Transactions
    * happens when a single business operation needs to update multiple, separate databases
    * Atomicity is crucial
        * All three steps must succeed, or all three must fail
        * You can't have your card charged if the flight wasn't booked!

    * solution
        * Two-Phase Commit (2PC) protocol
            * There will be a central "coordinator" manages the transaction.

            * phases
                * phase 1 (Prepare/Voting)
                    * The coordinator asks every participating database, Are you prepared to commit?
                    * every participant does the work before the commit, then it votes (yes/no)
                * phase 2 (Commit/Abort)
                    * if all said yes
                        * the coordinator tells them all to COMMIT
                    * if any said no
                        * the coordinator tells them all to ABORT

            * it is a complex solution
                * alternatives
                    * SEGA pattern
                        * the operation is divided into steps
                        * each step handles a database
                        * each step is dependant on the previous step
                        * if one failed, a rollback is done