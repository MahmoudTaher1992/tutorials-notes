# Conceptual Design

* Goal
    * Create a blueprint called the conceptual schema
    * Entity-Relationship (E-R) model is used to draw it

* Understand the Requirements
    * Gather data from
        * the client meeting
        * reading existing documents
        * looking at old system
        * talk to future users
    * Set standard vocabulary
        * to avoid confusion
        * to provide consistency

* Choose Your Building Blocks
    * define
        * Entities
            * a thing you want to store the data about
            * i.e.
                * Trainee
                * Instructor
                * Course
                * ...
        * Attributes
            * details about an entity
            * i.e.
                * Trainee
                    * Name
                    * Age
                    * Email
                * Course
                    * Title
                    * Description
                    * Duration
                * ...
        * Relationships
            * how entities are connected
            * i.e.
                * A Trainee ENROLLS IN a Course
                * An Instructor TEACHES a Course

* Choose a Design Strategy
    * Top-Down
        * start from the main ideas and add the details till you finish
    * Bottom-Up
        * reverse of Top-Down
    * Mixed Strategy
        * The most realistic approach
        * start from an idea from top-down, then you will find your self changing the direction to bottom-up
        * iterate until you finish

* E-R model quality
    * E-R model correctness
    * Completeness
        * is the model complete, Are there missing parts ?
    * Readability
    * Minimality