 13
1.1 1.2 1.3 Who This Book Is For . . . . . . . . . . . . . . . . . . . . What’s in This Book . . . . . . . . . . . . . . . . . . . . What’s Not in This Book . . . . . . . . . . . . . . . . . . 14
15
17
1.4 1.5 1.6 Conventions . . . . . . . . . . . . . . . . . . . . . . . . . Example Database . . . . . . . . . . . . . . . . . . . . . Acknowledgments . . . . . . . . . . . . . . . . . . . . . . 18
19
22
I Logical Database Design Antipatterns 24
2 Jaywalking 25
2.1 2.2 2.3 2.4 2.5 Objective: Store Multivalue Attributes . . . . . . . . . . Antipattern: Format Comma-Separated Lists . . . . . . How to Recognize the Antipattern . . . . . . . . . . . . Legitimate Uses of the Antipattern . . . . . . . . . . . . Solution: Create an Intersection Table . . . . . . . . . . 26
26
29
30
30
3 Naive Trees 34
3.1 3.2 3.3 3.4 3.5 Objective: Store and Query Hierarchies . . . . . . . . . Antipattern: Always Depend on One’s Parent . . . . . . How to Recognize the Antipattern . . . . . . . . . . . . Legitimate Uses of the Antipattern . . . . . . . . . . . . Solution: Use Alternative Tree Models . . . . . . . . . . 35
35
39
40
41
4 ID Required 54
4.1 Objective: Establish Primary Key Conventions . . . . . 55
4.2 Antipattern: One Size Fits All . . . . . . . . . . . . . . . 4.3 How to Recognize the Antipattern . . . . . . . . . . . . 4.4 Legitimate Uses of the Antipattern . . . . . . . . . . . . 4.5 Solution: Tailored to Fit . . . . . . . . . . . . . . . . . . 57
61
61
62
CONTENTS 8
5 Keyless Entry 65
5.1 5.2 5.3 5.4 5.5 Objective: Simplify Database Architecture . . . . . . . . Antipattern: Leave Out the Constraints . . . . . . . . . How to Recognize the Antipattern . . . . . . . . . . . . Legitimate Uses of the Antipattern . . . . . . . . . . . . Solution: Declare Constraints . . . . . . . . . . . . . . . 66
66
69
70
70
6 Entity-Attribute-Value 73
6.1 6.2 6.3 6.4 6.5 Objective: Support Variable Attributes . . . . . . . . . . Antipattern: Use a Generic Attribute Table . . . . . . . How to Recognize the Antipattern . . . . . . . . . . . . Legitimate Uses of the Antipattern . . . . . . . . . . . . Solution: Model the Subtypes . . . . . . . . . . . . . . . 73
74
80
80
82
7 Polymorphic Associations 89
7.1 7.2 7.3 7.4 7.5 Objective: Reference Multiple Parents . . . . . . . . . . Antipattern: Use Dual-Purpose Foreign Key . . . . . . . How to Recognize the Antipattern . . . . . . . . . . . . Legitimate Uses of the Antipattern . . . . . . . . . . . . Solution: Simplify the Relationship . . . . . . . . . . . . 90
91
94
95
96
8 Multicolumn Attributes 102
8.1 8.2 8.3 8.4 8.5 Objective: Store Multivalue Attributes . . . . . . . . . . Antipattern: Create Multiple Columns . . . . . . . . . . How to Recognize the Antipattern . . . . . . . . . . . . Legitimate Uses of the Antipattern . . . . . . . . . . . . Solution: Create Dependent Table . . . . . . . . . . . . 102
103
106
107
108
9 Metadata Tribbles 110
9.1 9.2 9.3 9.4 9.5 Objective: Support Scalability . . . . . . . . . . . . . . . 111
Antipattern: Clone Tables or Columns . . . . . . . . . . 111
How to Recognize the Antipattern . . . . . . . . . . . . 116
Legitimate Uses of the Antipattern . . . . . . . . . . . . 117
Solution: Partition and Normalize . . . . . . . . . . . . 118
Report erratum
this copy is (P1.0 printing, May 2010)
CONTENTS 9
II Physical Database Design Antipatterns 122
10 Rounding Errors 123
10.1 Objective: Use Fractional Numbers Instead of Integers 124
10.2 Antipattern: Use FLOAT Data Type . . . . . . . . . . . . 124
10.3 How to Recognize the Antipattern . . . . . . . . . . . . 128
10.4 Legitimate Uses of the Antipattern . . . . . . . . . . . . 128
10.5 Solution: Use NUMERIC Data Type . . . . . . . . . . . . 128
11 31 Flavors 131
11.1 Objective: Restrict a Column to Specific Values . . . . 131
11.2 Antipattern: Specify Values in the Column Definition . 132
11.3 How to Recognize the Antipattern . . . . . . . . . . . . 135
11.4 Legitimate Uses of the Antipattern . . . . . . . . . . . . 136
11.5 Solution: Specify Values in Data . . . . . . . . . . . . . 136
12 Phantom Files 139
12.1 Objective: Store Images or Other Bulky Media . . . . . 140
12.2 Antipattern: Assume You Must Use Files . . . . . . . . 140
12.3 How to Recognize the Antipattern . . . . . . . . . . . . 143
12.4 Legitimate Uses of the Antipattern . . . . . . . . . . . . 144
12.5 Solution: Use BLOB Data Types As Needed . . . . . . . 145
13 Index Shotgun 148
13.1 13.3 13.4 13.5 Objective: Optimize Performance . . . . . . . . . . . . . 149
13.2 Antipattern: Using Indexes Without a Plan . . . . . . . 149
How to Recognize the Antipattern . . . . . . . . . . . . 153
Legitimate Uses of the Antipattern . . . . . . . . . . . . 154
Solution: MENTOR Your Indexes . . . . . . . . . . . . . 154
III Query Antipatterns 161
14 Fear of the Unknown 14.1 Objective: Distinguish Missing Values . . . . . . . . . . 14.2 Antipattern: Use Null as an Ordinary Value, or Vice Versa 163
14.3 How to Recognize the Antipattern . . . . . . . . . . . . 14.4 Legitimate Uses of the Antipattern . . . . . . . . . . . . 162
163
166
168
14.5 Solution: Use Null as a Unique Value . . . . . . . . . . 168
Report erratum
this copy is (P1.0 printing, May 2010)
CONTENTS 10
15 Ambiguous Groups 173
15.1 Objective: Get Row with Greatest Value per Group . . . 174
15.2 Antipattern: Reference Nongrouped Columns . . . . . . 174
15.3 How to Recognize the Antipattern . . . . . . . . . . . . 176
15.4 Legitimate Uses of the Antipattern . . . . . . . . . . . . 178
15.5 Solution: Use Columns Unambiguously . . . . . . . . . 179
16 Random Selection 183
16.1 16.2 16.3 16.4 Objective: Fetch a Sample Row . . . . . . . . . . . . . . Antipattern: Sort Data Randomly . . . . . . . . . . . . . How to Recognize the Antipattern . . . . . . . . . . . . Legitimate Uses of the Antipattern . . . . . . . . . . . . 184
184
185
186
16.5 Solution: In No Particular Order. . . . . . . . . . . . . . 186
17 Poor Man’s Search Engine 17.1 Objective: Full-Text Search . . . . . . . . . . . . . . . . 17.2 Antipattern: Pattern Matching Predicates . . . . . . . . 17.3 How to Recognize the Antipattern . . . . . . . . . . . . 17.4 Legitimate Uses of the Antipattern . . . . . . . . . . . . 190
191
191
192
193
17.5 Solution: Use the Right Tool for the Job . . . . . . . . . 193
18 Spaghetti Query 204
18.1 18.3 18.4 18.5 Objective: Decrease SQL Queries . . . . . . . . . . . . . 205
18.2 Antipattern: Solve a Complex Problem in One Step . . 205
How to Recognize the Antipattern . . . . . . . . . . . . 207
Legitimate Uses of the Antipattern . . . . . . . . . . . . 208
Solution: Divide and Conquer . . . . . . . . . . . . . . . 209
19 Implicit Columns 214
19.1 19.3 19.4 19.5 Objective: Reduce Typing . . . . . . . . . . . . . . . . . 215
19.2 Antipattern: a Shortcut That Gets You Lost . . . . . . . 215
How to Recognize the Antipattern . . . . . . . . . . . . 217
Legitimate Uses of the Antipattern . . . . . . . . . . . . 218
Solution: Name Columns Explicitly . . . . . . . . . . . . 219
Report erratum
this copy is (P1.0 printing, May 2010)
CONTENTS 11
IV Application Development Antipatterns 221
20 Readable Passwords 222
20.1 Objective: Recover or Reset Passwords . . . . . . . . . . 222
20.2 Antipattern: Store Password in Plain Text . . . . . . . . 223
20.3 How to Recognize the Antipattern . . . . . . . . . . . . 225
20.4 Legitimate Uses of the Antipattern . . . . . . . . . . . . 225
20.5 Solution: Store a Salted Hash of the Password . . . . . 227
21 SQL Injection 234
21.1 Objective: Write Dynamic SQL Queries . . . . . . . . . 235
21.2 Antipattern: Execute Unverified Input As Code . . . . . 235
21.3 How to Recognize the Antipattern . . . . . . . . . . . . 242
21.4 Legitimate Uses of the Antipattern . . . . . . . . . . . . 243
21.5 Solution: Trust No One . . . . . . . . . . . . . . . . . . . 243
22 Pseudokey Neat-Freak 250
22.1 22.2 22.3 22.4 22.5 Objective: Tidy Up the Data . . . . . . . . . . . . . . . . Antipattern: Filling in the Corners . . . . . . . . . . . . How to Recognize the Antipattern . . . . . . . . . . . . Legitimate Uses of the Antipattern . . . . . . . . . . . . Solution: Get Over It . . . . . . . . . . . . . . . . . . . . 251
251
254
254
254
23 See No Evil 259
23.1 Objective: Write Less Code . . . . . . . . . . . . . . . . . 260
23.2 Antipattern: Making Bricks Without Straw . . . . . . . 260
23.3 How to Recognize the Antipattern . . . . . . . . . . . . 262
23.4 Legitimate Uses of the Antipattern . . . . . . . . . . . . 263
23.5 Solution: Recover from Errors Gracefully . . . . . . . . 264
24 Diplomatic Immunity 266
24.1 Objective: Employ Best Practices . . . . . . . . . . . . . 267
24.2 Antipattern: Make SQL a Second-Class Citizen . . . . . 267
24.3 How to Recognize the Antipattern . . . . . . . . . . . . 268
24.4 Legitimate Uses of the Antipattern . . . . . . . . . . . . 269
24.5 Solution: Establish a Big-Tent Culture of Quality . . . 269
25 Magic Beans 278
25.1 Objective: Simplify Models in MVC . . . . . . . . . . . . 279
25.2 Antipattern: The Model Is an Active Record . . . . . . . 280
25.3 How to Recognize the Antipattern . . . . . . . . . . . . 286
25.4 Legitimate Uses of the Antipattern . . . . . . . . . . . . 287
25.5 Solution: The Model Has an Active Record . . . . . . . 287
Report erratum
this copy is (P1.0 printing, May 2010)
CONTENTS 12
V Appendixes 293
A Rules of Normalization 294
A.1 A.2 A.3 What Does Relational Mean? . . . . . . . . . . . . . . . Myths About Normalization . . . . . . . . . . . . . . . . What Is Normalization? . . . . . . . . . . . . . . . . . . 294
296
298
A.4 Common Sense . . . . . . . . . . . . . . . . . . . . . . . 308
B Bibliography 309
Index 311