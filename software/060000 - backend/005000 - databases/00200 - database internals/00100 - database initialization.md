# Database initialization



## Startup invocation
* server process is invoked
    * manually, throw a command
    * automatically, throw a service/daemon


## Configuration Loading
* database engine loads configuration files
    * determines aspects like memory limits, networking, file paths, logging, authentication settings, etc.


## Resource Allocation
* Allocates necessary resources such as
    * Memory Buffers
    * Network Sockets
    * File Handles


## System Catalog/Metadata Loading
* information about databases, schemas, tables, users, privileges.


## Module/Subsystem Initialization
* i.e.
    * Thread/process pool
    * Storage engines
    * Transaction manager
    * Authentication/authorization
    * Logging and recovery systems
    * Replication/subscription services
    * ...


## Crash Recovery
* Checks for uncommitted transactions, incomplete changes, or system inconsistencies left by a previous crash
* Ensures the database is in a consistent state before accepting connections.


## Open for Connections
* Starts listening on interfaces/ports or sockets.


## Startup Tasks
* Runs any registered startup routines, jobs, or maintenance