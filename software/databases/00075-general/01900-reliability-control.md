# Reliability Control

* Making a system survive a crash
* it should guarantee
    * Atomicity
    * Durability

* The toolkit
    * Transactional log
        * the database black box
        * the most important component for recovery

        * it is a special file
        * stored on a durable place like a hard drive
        * records every single action a database intends to take

        * there is a rule for databases
            * The Write-Ahead Logging (WAL) Rule
                * A database must write the intended change to the log before it writes the change to the actual database files

        * if the database crashed
            * it uses the logs to continue the work it was doing before the crash
        
        at any point in time a database can recover

        * Log Records
            * structured sequence of records

    * Checkpoints 
        * like milestones
        * points at which we can say 
            * every thing is fine till this point
        * runs periodically
        * in the recovery, last checkpoint will be used as a reference on where the db shall start working