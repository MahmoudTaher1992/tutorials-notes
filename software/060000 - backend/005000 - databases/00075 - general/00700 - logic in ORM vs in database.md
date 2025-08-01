# Logic in Application Level or in Database

* Application Level
    * using ORMs
    * Pros
        * Developer Familiarity & Productivity
        * Testability
        * Flexibility & Agility
        * Debugging
        * Scalability (Horizontal)
        * Portability
            * if ORM is replaced with another adapter, you use the same logic with another database vendor
        * Rich Ecosystem
            * access libraries, configurations, variable, services ...
    * Cons
        * Data integrity risk
            * if the logic is placed only in the application, bypassing the app can lead to invalid data
        * Performance
            * it takes more time and resources compared to databases, it has to fetch the data first, process it and commit it
        * Duplicate Logic
            * if multiple apps are working on the same database, the logic will be duplicated
        * Transactional Atomicity
            * harder to achieve
    * Use cases
        * most of the business logic 
        * UI specific validations
        * Integration with External Services
        * Reporting & Data Transformation

* Database Level
    * pros
        * Guaranteed Data Integrity
            * can not be bypassed
        * Performance
        * centralized logic
        * Transactional Atomicity
            * ensure that a sequence of operations is either fully committed or fully rolled back
    * const
        * vendor lock-in
            * changing the databases are not easy
            * you have to write the code again
        * Developer Skillset
            * requires skills in this area from the developers
        * Testability Challenges
        * Debugging Difficulty
        * Hidden Logic 
            * especially with Triggers
        * Version Control & Deployment
        * Scalability
            * you have to write an efficient logic
            
    * use cases
        * Absolute Data Integrity Rules
        * Critical Auditing
        * Complex, Atomic, Multi-Table Operations
        * Heavy Batch Processing

* Push down to the database only what ABSOLUTELY MUST BE THERE
* Keep everything else in the application layer