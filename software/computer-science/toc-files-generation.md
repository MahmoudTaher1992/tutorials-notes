#!/bin/bash

# Define the root directory name
ROOT_DIR="Computer-Science-Roadmap"

# Create the root directory
mkdir -p "$ROOT_DIR"
cd "$ROOT_DIR" || exit

echo "Creating Computer Science Roadmap directory structure..."

# ==========================================
# PART I: Foundations of Computer Science
# ==========================================
DIR="001-Foundations-of-Computer-Science"
mkdir -p "$DIR"

# A. What is Computer Science?
cat <<EOF > "$DIR/001-What-is-Computer-Science.md"
# What is Computer Science?

* Definition & Scope
* Major Fields & Subfields
* Interdisciplinary Applications
EOF

# B. History of Computing
cat <<EOF > "$DIR/002-History-of-Computing.md"
# History of Computing

* Early Computing Devices
* Turing, von Neumann, and Modern Computing
* Growth of Software and the Internet
EOF

# C. Mathematics for Computer Scientists
cat <<EOF > "$DIR/003-Mathematics-for-Computer-Scientists.md"
# Mathematics for Computer Scientists

* Discrete Mathematics
    * Logic, Propositions, Truth Tables
    * Proof Techniques (Direct, Contrapositive, Induction)
* Set Theory
* Relations, Functions, Mappings
* Combinatorics & Permutations/Combinations
* Graph Theory (Intro)
* Probability & Statistics (Basics)
* Number Theory (Prime, GCD, Modulo Arithmetic)
* Boolean Algebra
* Matrix/Linear Algebra Basics
EOF

# ==========================================
# PART II: Programming Fundamentals
# ==========================================
DIR="002-Programming-Fundamentals"
mkdir -p "$DIR"

# A. Programming Paradigms
cat <<EOF > "$DIR/001-Programming-Paradigms.md"
# Programming Paradigms

* Imperative & Procedural
* Object-Oriented
* Functional & Declarative
* Scripting & Event-Driven
* Logic Programming (e.g., Prolog)
EOF

# B. Languages
cat <<EOF > "$DIR/002-Languages.md"
# Languages

* Static vs. Dynamic Typing
* Compilation vs. Interpretation
* Memory Management (Manual, GC, RAII)
* Popular Languages: C, C++, Java, Python, Rust, JavaScript, Go, etc.
* Source Code Structure & Organization
EOF

# C. Control Structures
cat <<EOF > "$DIR/003-Control-Structures.md"
# Control Structures

* Variables & Data Types
* Scoping and Lifetime
* Conditional Statements (if, case/switch)
* Loops (for, while, recursion)
* Functions/Procedures
* Exception & Error Handling
EOF

# D. Abstractions
cat <<EOF > "$DIR/004-Abstractions.md"
# Abstractions

* Modularization & Namespacing
* Classes & Objects
* Interfaces and Abstract Data Types
* Generics & Templates
EOF

# E. Coding Practices
cat <<EOF > "$DIR/005-Coding-Practices.md"
# Coding Practices

* Style and Readability
* Code Reviews & Collaboration
* Version Control (Git & Workflows)
EOF

# ==========================================
# PART III: Data Structures
# ==========================================
DIR="003-Data-Structures"
mkdir -p "$DIR"

# A. Primitive Data Structures
cat <<EOF > "$DIR/001-Primitive-Data-Structures.md"
# Primitive Data Structures

* Integers, Float, Char, String, Boolean
EOF

# B. Linear Data Structures
cat <<EOF > "$DIR/002-Linear-Data-Structures.md"
# Linear Data Structures

* Arrays (1D, 2D, Multidimensional)
* Linked Lists (Singly, Doubly, Circular)
* Stacks & Queues (Array/Linked Implementations)
* Deques, Priority Queues
EOF

# C. Non-Linear Data Structures
cat <<EOF > "$DIR/003-Non-Linear-Data-Structures.md"
# Non-Linear Data Structures

* Trees
    * Binary Trees, Binary Search Trees
    * AVL & Red-Black Trees
    * B-Trees/2-3-4 Trees
    * Segment, Fenwick, K-D Trees
    * Tries (Prefix Tree)
* Graphs
    * Directed & Undirected, Weighted & Unweighted
    * Graph Representations (Adjacency List, Matrix)
    * Spanning Trees
    * Heap & Priority Queue (Min/Max Heap)
* Hash Tables
    * Collision Resolution, Open/Closed Addressing
    * Hashing Functions & Maps
* Sets & Maps
    * Ordered/Unordered Variants
    * Skip Lists, Bloom Filters
EOF

# ==========================================
# PART IV: Algorithms
# ==========================================
DIR="004-Algorithms"
mkdir -p "$DIR"

# A. Algorithm Fundamentals
cat <<EOF > "$DIR/001-Algorithm-Fundamentals.md"
# Algorithm Fundamentals

* Algorithmic Thinking & Problem Solving
* Pseudocode & Flowcharts
* Asymptotic Analysis (Big O, Ω, Θ)
* Recursion & Recursive Complexity
EOF

# B. Searching Algorithms
cat <<EOF > "$DIR/002-Searching-Algorithms.md"
# Searching Algorithms

* Linear Search
* Binary Search
* Search in Trees (BFS, DFS)
EOF

# C. Sorting Algorithms
cat <<EOF > "$DIR/003-Sorting-Algorithms.md"
# Sorting Algorithms

* Selection, Bubble, Insertion Sort
* Merge Sort, Quick Sort, Heap Sort
* Count/Bucket/Radix Sort
EOF

# D. Graph Algorithms
cat <<EOF > "$DIR/004-Graph-Algorithms.md"
# Graph Algorithms

* Traversals: BFS, DFS
* Shortest Path: Dijkstra, Bellman-Ford, A*
* Minimum Spanning Tree: Kruskal's, Prim's
* Network Flow: Ford-Fulkerson, Edmonds-Karp
* Cycle Detection & Topological Sort
EOF

# E. Dynamic Programming
cat <<EOF > "$DIR/005-Dynamic-Programming.md"
# Dynamic Programming

* Memoization & Tabulation
* Classic Problems: Fibonacci, Knapsack, LIS, LCS
EOF

# F. Greedy Algorithms
cat <<EOF > "$DIR/006-Greedy-Algorithms.md"
# Greedy Algorithms

* Activity Selection, Fractional Knapsack
EOF

# G. Backtracking
cat <<EOF > "$DIR/007-Backtracking.md"
# Backtracking

* N-Queens, Subset Sum, Hamiltonian Path
EOF

# H. String Algorithms
cat <<EOF > "$DIR/008-String-Algorithms.md"
# String Algorithms

* Pattern Search: KMP, Rabin-Karp, Boyer-Moore
* Trie/Prefix Tree Applications
* Suffix Arrays / LCP Array
EOF

# I. Randomized & Approximation Algorithms
cat <<EOF > "$DIR/009-Randomized-and-Approximation-Algorithms.md"
# Randomized & Approximation Algorithms

* (Content details to be added)
EOF

# ==========================================
# PART V: Computer Architecture & Organization
# ==========================================
DIR="005-Computer-Architecture-and-Organization"
mkdir -p "$DIR"

# A. Digital Logic
cat <<EOF > "$DIR/001-Digital-Logic.md"
# Digital Logic

* Transistors and Gates (AND, OR, NOT, NAND, NOR, XOR)
* Combinational & Sequential Circuits
* Flip-Flops, Latches, Registers
EOF

# B. Machine Architecture
cat <<EOF > "$DIR/002-Machine-Architecture.md"
# Machine Architecture

* CPU Components (ALU, Control Unit, Registers)
* Instruction Set Architecture
* Data Paths & Control Paths
* Memory (RAM, ROM, Cache - L1, L2, L3)
* I/O Operations
* Microarchitecture Concepts (Pipelining, Superscalar, Out-of-Order)
EOF

# C. Number Systems
cat <<EOF > "$DIR/003-Number-Systems.md"
# Number Systems

* Binary, Decimal, Hexadecimal, Octal
* Signed/Unsigned Representation
* Endianness: Big/Little Endian
* Floating-Point Representation (IEEE 754)
EOF

# D. Assembly Language Basics
cat <<EOF > "$DIR/004-Assembly-Language-Basics.md"
# Assembly Language Basics

* Structure, Instructions, Addressing Modes
EOF

# ==========================================
# PART VI: Operating Systems
# ==========================================
DIR="006-Operating-Systems"
mkdir -p "$DIR"

# A. Operating System Concepts
cat <<EOF > "$DIR/001-Operating-System-Concepts.md"
# Operating System Concepts

* Kernel/User Space
* Monolithic vs Microkernel Structure
* Device Drivers
EOF

# B. Process Management
cat <<EOF > "$DIR/002-Process-Management.md"
# Process Management

* Processes & Threads, Process States
* Scheduling Algorithms (FCFS, SJF, RR, Priority)
* Context Switching
* Concurrency, Synchronization (Mutex, Semaphore, Monitor)
* Deadlock: Detection, Avoidance, Recovery, Prevention
EOF

# C. Memory Management
cat <<EOF > "$DIR/003-Memory-Management.md"
# Memory Management

* Physical/Virtual Memory
* Paging, Segmentation
* Swapping, Fragmentation, Demand Paging
EOF

# D. File Systems
cat <<EOF > "$DIR/004-File-Systems.md"
# File Systems

* File Organization, Metadata, Directory Structures
* Common File Systems (FAT, NTFS, ext4)
* Permissions and Access Control
EOF

# E. Storage & I/O
cat <<EOF > "$DIR/005-Storage-and-IO.md"
# Storage & I/O

* Disk Scheduling
* DMA, Buffers, Caching
* RAID & Storage Redundancy
EOF

# F. Security & Protection
cat <<EOF > "$DIR/006-Security-and-Protection.md"
# Security & Protection

* Privilege Levels
* User/Group Management
* Sandboxing, Access Control Lists (ACLs)
EOF

# ==========================================
# PART VII: Networking and the Internet
# ==========================================
DIR="007-Networking-and-the-Internet"
mkdir -p "$DIR"

# A. Networking Fundamentals
cat <<EOF > "$DIR/001-Networking-Fundamentals.md"
# Networking Fundamentals

* OSI & TCP/IP Model Layers
* Network Topologies
* Switching & Routing Concepts
EOF

# B. Data Transmission
cat <<EOF > "$DIR/002-Data-Transmission.md"
# Data Transmission

* Packets, Frames, Segments
* Network Devices (Hub, Switch, Router)
* Flow Control, Error Detection & Correction (CRC, Parity)
EOF

# C. Protocols
cat <<EOF > "$DIR/003-Protocols.md"
# Protocols

* HTTP, HTTPS, FTP, SMTP, POP3, IMAP
* TCP, UDP, ICMP, ARP, DHCP, DNS
* SSL/TLS, SSH, VPN Basics
EOF

# D. Internet Architecture
cat <<EOF > "$DIR/004-Internet-Architecture.md"
# Internet Architecture

* IP Addressing (IPv4, IPv6, Subnetting)
* NAT, Firewalls, Proxies
* Content Delivery Networks (CDNs)
* Load Balancers
EOF

# E. Web Technologies
cat <<EOF > "$DIR/005-Web-Technologies.md"
# Web Technologies

* Sockets & APIs
* REST, gRPC, GraphQL (brief overview)
EOF

# ==========================================
# PART VIII: Databases and Persistence
# ==========================================
DIR="008-Databases-and-Persistence"
mkdir -p "$DIR"

# A. Database Models
cat <<EOF > "$DIR/001-Database-Models.md"
# Database Models

* Relational (SQL)
* NoSQL (Document, Key-Value, Graph, Time-series)
EOF

# B. Relational DB Fundamentals
cat <<EOF > "$DIR/002-Relational-DB-Fundamentals.md"
# Relational DB Fundamentals

* Tables, Schemas, Keys (PK, FK)
* Normalization (1NF, 2NF, 3NF, BCNF)
* SQL Syntax and Operations (DDL, DML, DQL, DCL)
* Indexes, Views, Transactions
* ACID Properties
EOF

# C. NoSQL Concepts
cat <<EOF > "$DIR/003-NoSQL-Concepts.md"
# NoSQL Concepts

* CAP Theorem
* BASE
* Document & Key-Value Stores (MongoDB, Redis)
* Graph DBs
EOF

# D. Advanced Topics
cat <<EOF > "$DIR/004-Advanced-Topics.md"
# Advanced Topics

* Database Sharding & Replication
* Backup, Recovery, Federation
* ORMs
EOF

# ==========================================
# PART IX: Software Engineering and Development Practices
# ==========================================
DIR="009-Software-Engineering-and-Development-Practices"
mkdir -p "$DIR"

# A. Software Development Life Cycle (SDLC)
cat <<EOF > "$DIR/001-Software-Development-Life-Cycle.md"
# Software Development Life Cycle (SDLC)

* Requirement, Design, Implementation
* Waterfall, Agile, DevOps, CI/CD
EOF

# B. Version Control & Collaboration
cat <<EOF > "$DIR/002-Version-Control-and-Collaboration.md"
# Version Control & Collaboration

* git, GitHub/GitLab Workflows
* Branching Strategies
EOF

# C. Software Design Patterns
cat <<EOF > "$DIR/003-Software-Design-Patterns.md"
# Software Design Patterns

* GoF Patterns (Singleton, Factory, Observer, MVC, etc.)
* Architectural Patterns (MVC, MVP, MVVM, Microservices, Monolith)
EOF

# D. UML & Architecture Diagrams
cat <<EOF > "$DIR/004-UML-and-Architecture-Diagrams.md"
# UML & Architecture Diagrams

* Class, Sequence, Use Case, Activity
EOF

# E. Testing & Quality
cat <<EOF > "$DIR/005-Testing-and-Quality.md"
# Testing & Quality

* Unit, Integration, System, Acceptance Testing
* TDD/BDD
* Static Analysis & Code Quality Metrics
EOF

# F. Documentation
cat <<EOF > "$DIR/006-Documentation.md"
# Documentation

* Code Documentation
* API Documentation (OpenAPI, Swagger)
* User & Developer Guides
EOF

# G. Security Practices in Software
cat <<EOF > "$DIR/007-Security-Practices-in-Software.md"
# Security Practices in Software

* Secure Development Life Cycle
* Threat Modeling, Secure Coding
* Vulnerability Testing (OWASP Top 10)
EOF

# ==========================================
# PART X: Advanced and Specialized Topics
# ==========================================
DIR="010-Advanced-and-Specialized-Topics"
mkdir -p "$DIR"

# A. Theory of Computation
cat <<EOF > "$DIR/001-Theory-of-Computation.md"
# Theory of Computation

* Automata Theory (Finite Automata, Pushdown Automata, Turing Machines)
* Formal Languages (Regular, Context-Free)
* Computability & Decidability
* Complexity Theory (P, NP, NP-Complete, NP-Hard, P=NP)
* Reductions & Intractability
EOF

# B. Parallel and Distributed Computing
cat <<EOF > "$DIR/002-Parallel-and-Distributed-Computing.md"
# Parallel and Distributed Computing

* Multithreading & Multiprocessing
* Distributed Systems (CAP Theorem, PACELC)
* RPC, Message Queues, Consensus (Paxos, Raft)
* MapReduce, Distributed Storage
* Grid & Cloud Computing, Virtualization, Containers
EOF

# C. Security, Cryptography & Privacy
cat <<EOF > "$DIR/003-Security-Cryptography-and-Privacy.md"
# Security, Cryptography & Privacy

* Symmetric & Asymmetric Cryptography
* Hashing Algorithms, Digital Signatures
* Public Key Infrastructure (PKI), Certificate Authorities
* Authentication & Authorization Mechanisms
* Network Security (TLS, SSH, VPNs, Firewall)
* Application Security (XSS, CSRF, SQLi, etc.)
EOF

# D. Artificial Intelligence & Machine Learning
cat <<EOF > "$DIR/004-Artificial-Intelligence-and-Machine-Learning.md"
# Artificial Intelligence & Machine Learning

* Definition and Categories (ML, DL, RL)
* ML Algorithms (Linear Regression, Clustering, Decision Trees, SVM, etc.)
* Neural Networks, Deep Learning, CNNs, RNNs
* Natural Language Processing
* Data Preparation, Training, Validation, Evaluation
EOF

# E. Graphics, Visualization, and HCI
cat <<EOF > "$DIR/005-Graphics-Visualization-and-HCI.md"
# Graphics, Visualization, and HCI

* 2D/3D Graphics Fundamentals
* Graphics Pipeline, Shaders
* Game Engines Basics
* UI/UX, Accessibility
EOF

# F. Emerging Topics
cat <<EOF > "$DIR/006-Emerging-Topics.md"
# Emerging Topics

* Blockchain and Distributed Ledgers
* IoT Architectures
* Edge/Fog Computing
* Quantum Computing Basics
EOF

# ==========================================
# PART XI: Capstone, Ethics, and Professionalism
# ==========================================
DIR="011-Capstone-Ethics-and-Professionalism"
mkdir -p "$DIR"

# A. Open Source & Community
cat <<EOF > "$DIR/001-Open-Source-and-Community.md"
# Open Source & Community

* (Contribution, Licenses, Community Standards)
EOF

# B. Legal, Ethical, and Social Issues
cat <<EOF > "$DIR/002-Legal-Ethical-and-Social-Issues.md"
# Legal, Ethical, and Social Issues

* Intellectual Property
* Privacy, Data Protection
* Bias & Fairness in Computing
* Responsible AI
EOF

# C. Technical Communication & Career
cat <<EOF > "$DIR/003-Technical-Communication-and-Career.md"
# Technical Communication & Career

* Effective Technical Writing & Presentations
* Interview Preparation & Coding Challenges
EOF

echo "Done! Directory and file structure created in $ROOT_DIR"
