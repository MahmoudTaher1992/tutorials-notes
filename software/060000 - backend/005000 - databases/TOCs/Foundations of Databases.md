Contents
Preface vii
PART A ANTECHAMBER 1
1 Database Systems 3
1.1 The Main Principles 3
1.2 Functionalities 5
1.3 Complexity and Diversity 7
1.4 Past and Future 7
1.5 Ties with This Book 8
Bibliographic Notes 9
2 Theoretical Background 10
2.1 Some Basics 10
2.2 Languages, Computability, and Complexity 13
2.3 Basics from Logic 20
3 The Relational Model 28
3.1 The Structure of the Relational Model 29
3.2 Named versus Unnamed Perspectives 31
3.3 Conventional versus Logic Programming Perspectives 32
3.4 Notation 34
Bibliographic Notes 34
xiii
xiv Contents
PART B BASICS: RELATIONAL QUERY LANGUAGES 35
4 Conjunctive Queries 37
4.1 Getting Started 38
4.2 Logic-Based Perspectives 40
4.3 Query Composition and Views 48
4.4 Algebraic Perspectives 52
4.5 Adding Union 61
Bibliographic Notes 64
Exercises 65
5 Adding Negation: Algebra and Calculus 70
5.1 The Relational Algebras 71
5.2 Nonrecursive Datalog with Negation 72
5.3 The Relational Calculus 73
5.4 Syntactic Restrictions for Domain Independence 81
5.5 Aggregate Functions 91
5.6 Digression: Finite Representations of Infinite Databases 93
Bibliographic Notes 96
Exercises 98
6 Static Analysis and Optimization 105
6.1 Issues in Practical Query Optimization 106
6.2 Global Optimization 115
6.3 Static Analysis of the Relational Calculus 122
6.4 Computing with Acyclic Joins 126
Bibliographic Notes 134
Exercises 136
7 Notes on Practical Languages 142
7.1 SQL: The Structured Query Language 142
7.2 Query-by-Example and Microsoft Access 149
7.3 Confronting the Real World 152
Bibliographic Notes 154
Exercises 154
PART C CONSTRAINTS 157
8 Functional and Join Dependency 159
8.1 Motivation 159
8.2 Functional and Key Dependencies 8.3 Join and Multivalued Dependencies 163
169
Contents xv
8.4 The Chase 173
Bibliographic Notes 185
Exercises 186
9 Inclusion Dependency 192
9.1 Inclusion Dependency in Isolation 192
9.2 Finite versus Infinite Implication 197
9.3 Nonaxiomatizability of fd’s + ind’s 202
9.4 Restricted Kinds of Inclusion Dependency 207
Bibliographic Notes 211
Exercises 211
10 A Larger Perspective 216
10.1 A Unifying Framework 217
10.2 The Chase Revisited 220
10.3 Axiomatization 226
10.4 An Algebraic Perspective 228
Bibliographic Notes 233
Exercises 235
11 Design and Dependencies 240
11.1 Semantic Data Models 242
11.2 Normal Forms 251
11.3 Universal Relation Assumption 260
Bibliographic Notes 264
Exercises 266
PART D DATALOG AND RECURSION 271
12 Datalog 273
12.1 Syntax of Datalog 276
12.2 Model-Theoretic Semantics 278
12.3 Fixpoint Semantics 282
12.4 Proof-Theoretic Approach 286
12.5 Static Program Analysis 300
Bibliographic Notes 304
Exercises 306
13 Evaluation of Datalog 311
13.1 Seminaive Evaluation 312
13.2 Top-Down Techniques 316
13.3 Magic 324
xvi Contents
13.4 Two Improvements 327
Bibliographic Notes 335
Exercises 337
14 Recursion and Negation 342
14.1 Algebra + While 344
14.2 Calculus + Fixpoint 347
14.3 Datalog with Negation 355
14.4 Equivalence 360
14.5 Recursion in Practical Languages 368
Bibliographic Notes 369
Exercises 370
15 Negation in Datalog 374
15.1 The Basic Problem 374
15.2 Stratified Semantics 377
15.3 Well-Founded Semantics 385
15.4 Expressive Power 397
15.5 Negation as Failure in Brief 406
Bibliographic Notes 408
Exercises 410
PART E EXPRESSIVENESS AND COMPLEXITY 415
16 Sizing Up Languages 417
16.1 Queries 417
16.2 Complexity of Queries 422
16.3 Languages and Complexity 423
Bibliographic Notes 425
Exercises 426
17 First Order, Fixpoint, and While 429
17.1 Complexity of First-Order Queries 430
17.2 Expressiveness of First-Order Queries 433
17.3 Fixpoint and While Queries 437
17.4 The Impact of Order 446
Bibliographic Notes 457
Exercises 459
18 Highly Expressive Languages 466
18.1 WhileN—while with Arithmetic 467
18.2 Whilenew—while with New Values 469
Contents xvii
18.3 Whileuty—An Untyped Extension of while 475
Bibliographic Notes 479
Exercises 481
PART F FINALE 485
19 Incomplete Information 487
19.1 Warm-Up 488
19.2 Weak Representation Systems 490
19.3 Conditional Tables 493
19.4 The Complexity of Nulls 499
19.5 Other Approaches 501
Bibliographic Notes 504
Exercises 506
20 Complex Values 508
20.1 Complex Value Databases 511
20.2 The Algebra 514
20.3 The Calculus 519
20.4 Examples 523
20.5 Equivalence Theorems 526
20.6 Fixpoint and Deduction 531
20.7 Expressive Power and Complexity 534
20.8 A Practical Query Language for Complex Values 536
Bibliographic Notes 538
Exercises 539
21 Object Databases 542
21.1 Informal Presentation 543
21.2 Formal Definition of an OODB Model 21.3 Languages for OODB Queries 21.4 Languages for Methods 563
21.5 Further Issues for OODBs 547
556
571
Bibliographic Notes 573
Exercises 575
22 Dynamic Aspects 579
22.1 Update Languages 580
22.2 Transactional Schemas 584
22.3 Updating Views and Deductive Databases 586
22.4 Updating Incomplete Information 593
22.5 Active Databases 600
xviii Contents
22.6 Temporal Databases and Constraints 606
Bibliographic Notes 613
Exercises 615
Bibliography 621
Symbol Index 659
Index 661