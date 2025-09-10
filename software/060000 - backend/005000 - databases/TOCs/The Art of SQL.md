Symbols
@@IDENTITY system variable (Transact-
SQL), 235
10% of rows rule of thumb, 103
1NF (first normal form), 8
2NF (second normal form), 9
3NF (third normal form), 4, 9
data warehousing and, 265
5NF (fifth normal form), 5
A
absence of data, result sets predicated
on, 161–166
abstract layers, 202–205
accesses to the database (see database
accesses)
ad hoc queries, 270
addresses, 109, 300–301
atomicity and, 7
adjacency model (SQL trees), 172, 174, 197
aggregating values stored in leaf
nodes, 191
computing head counts at every
level, 192
bottom-up tree walk, 185
top-down walk, 178–182
aggregation
consolidating multiple rows into
one, 282–284
double conversion, using, 302
on dates, 156
by range (bands), 297–299
result sets obtained from, 150–156
in transformations, 268
values from trees, 190–198
propagating percentages across
levels, 194–198
values stored in leaf nodes, 190–194
aggressive coding, 49
analytical functions (Oracle), 52
ANSI SQL query (example), 91
architectural solutions for contention, 242
architecture (global), choice of, 249
archival data
purging, 263
putting into production, 249
archives, location of, 170, 171
array interface, communicating between
program and DBMS kernel, 31
art of SQL, governing factors, 84–88
number of tables, 85
number of users, 88
result set criteria, 84
result set size, 85
total quantity of data, 84
art, science vs., xi
associative table, resolving many-to-many
relationship between tables, 69
asynchronous processing, 22
atomic attributes, 6, 64
atomicity, 5
business requirements and, 7
function applied to a column, 64
attributes
atomic, 6, 64
dealing with varying numbers of, 281
excessive flexibility in, 18
independence of, 9
auto-incremented columns, 235
not using in order to limit
contention, 245
axioms, 3
335
www.it-ebooks.info
B
backup databases, 24
bad SQL queries, 311
bands, aggregating by, 297–299
batch programs, 22
queries returning large amounts of
data, 102
queries satisfied by data from an
index, 111
BCNF (Boyce-Codd normal form), 5
Bill of Materials (BOM) problem, 168
bind variables, 162
bind_param( ) method, 218
binding variables, 294, 296
PHP, 218–222
bitmap indexes, 273
blanket views, performance impact on
queries, 117
blocks, 108
contention for access, 88
locking, 232
minimizing accesses to, 146
pre-joined tables and, 124
BOM (Bill of Materials) problem, 168
book indexes, table of contents vs., 59
Boolean columns, qualifying, 14
bottom-up tree walk, 178, 185–189
adjacency model, 185
materialized path model, 186
nested set model, 188
performance, comparing for various
models, 188
boundaries of ranges, defining well, 262
Boyce-Codd normal form (BCNF), 5
bridge tables, 270
Building the Data Warehouse, 264
business logic, mirrored by SQL
statements, 42
business processes, physical design and, 109
business requirements, 2
atomicity and, 7
database modeling and, 2
business tasks, focusing on, 317–319
C
C# code, 202
cache, SQL engine, 314
cardinality (low), 109
Cartesian joins, 285, 286
case expression, 42
case-insensitive searches with function-
based index, 66
CBOs (cost-based optimizers), 36
Celko, Joe, 172, 176
centralizing data, 23
changing data, concurrency and, 231–246
contention, 240–246
architectural solutions, 242
DBA solutions for, 241
developmental solutions, 243
insertion and, 240
results from measures limiting,
243–246
locking, 232–239
committing and, 236
granularity of, 232
lock handling, 234–236
scalability and, 238
child with multiple parents, 169
classic SQL patterns, 128–166
large result set, 146
nine common situations, listed, 128
result set obtained by aggregation,
150–156
result set predicated on absence of
data, 161–166
self-joins on one table, 147–150
simple or range searching on
dates, 156–161
small intersection of broad criteria,
138–140
small intersection, indirect broad
criteria, 140–145
small result set, direct specific
criteria, 129–137
criterion indexability, 132–137
data dispersion, 130–132
index usability, 129
query efficiency and index
usage, 130
small result set, indirect criteria, 137
client/server environment, database
connections, 30
clustered indexes, 114, 130
drawbacks of, 114
clustering data with partitioning, 120
clustering index, 114
coalesce( ) function, 300
coarse (granularity), 34
Codd, E.F., 76
coding offensively with SQL, 48
columns, 2
auto-incremented, 235
effects on contention, 245
Boolean, qualifying, 14
3 3 6 I N D E X
www.it-ebooks.info
locking, 232
rows that should have been, 281–284
single, that should have been something
else, 289–294
that should have been rows, 284–289
comments, identifying programs and critical
modules, 28
commercial off-the-shelf (COTS) software
package, 323
commit statements, 34
committing, locking and, 236
comparisons, 43
complexity
degree for the request, performance
and, 230
introduced by storage options other
than the default, 124
sources of hidden complexity, 329
composite primary keys, 70
order of columns in, 158
concurrency, 226–246
considering in SQL code design, 88
data modifications, 231–246
contention, 240–246
locking, 232–239
database engine as service
provider, 226–231
increasing load revealing
performance problems, 227
indexes, virtues of, 226
data-driven partitioning and, 119
increased, with partitioning, 115
concurrent updates, foreign key indexing
for, 69
conditional logic, 42
conditions
applied at the wrong place, 98
order of evaluation, 89
(see also criteria; filtering conditions)
connect by operator (Oracle), 172, 178, 181
propagating percentages across different
tree levels, 196
substituting materialized path model
for, 189
constraints
implicit, unsoundness of, 17
major impact of, 17
violation of, 50
containers, contention when trying to
access, 241
content lists, indexes and, 59
contention, 88, 240–246
architectural solutions, 242
DBA solutions for, 241
developmental solutions, 243
indexing system-generated primary
keys, 71
insertion and, 240
physical layout of data and, 108
results from measures limiting,
243–246
correctness of data, 6
correlated subqueries, 94, 100
determining when to use, 137
looking for rows with no matching
data, 162
performance effects when processing
huge numbers of rows, 147
testing for existence without other
search criteria, 207
un-correlating, 100, 158
volume increases and, 256–261
corruption of data, 10
(see also data corruption)
cost-based optimizers (CBOs), 36
COTS (commercial off-the-shelf) software
package, 323
counts
redundant, 41, 49, 310
using as test for existence, 163
CPU, excessive use of, 312
CPU-intensive operations, high level of
concurrency for, 88
credit card validation procedures, 200–202
criteria
defining result sets, 84
dynamic search criteria, 208–223
quality of, 330
(see also classic SQL patterns;
conditions; filtering
conditions), 223
current table and historical table, using, 21
(see also tables)
current values, 160
cursor loops, 310
customer, defining, 7
D
data containers, contention when trying to
access, 241
data corruption, 10
data definition language (DDL), 33
data duplication
detection of duplicate primary keys, 50
minimizing with normalization, 10
data entry errors, 6
data flow, 22
data manipulation language (DML), commit
statements, 34
I N D E X 337
www.it-ebooks.info
data manipulation operations, ranking in
terms of overall cost, 263
data modeling, 4, 25
historical data, 19
data pages
accessed by database engine, keeping as
low as possible, 108
number visited by DBMS during a
query, 103
number you are hitting, 312
data purges, 263
data redundancy, 8
data volumes (large), coping with,
248–278
data warehousing, 264–278
increasing volumes, 248–264
partitioning as solution, 262
sensitivity of operations to,
250–261
sudden increase in volume, 309
Data Warehouse Toolkit, The, 264
data warehousing, 264–278
cautions about, 277
data extraction, 268
integrity constraints and indexes, 270
loading data, 269
querying dimensions and facts, 270–273
star transformation, 273
emulating, 274–276
transformation, 268
database access libraries, 202–205
database accesses
maximizing usefulness of, 36
minimizing, 317–319
multiplying, 310
database connections, managing use of, 29
database links, 205
performance and, 205
database optimizers (see optimizers)
databases
conflicting goals in optimizing physical
layout of data, 108
locking entire database, 232
reorganizations of, 132
SQL and, 76–79
structural types, 106–107
data-driven partitioning, 116, 262
concurrency problems and, 119
true partitioning, 118
date arithmetic, 45
date type, 64
dates and times, 64
comparing dates, 43
partitioning, 262
partitioning historical data tables by
date, 116
simple or range searching on
dates, 156–161
datetime type, 64
DB2
call to get new sequence value, 236
clustering index, 114
range-clustering, 118
recursive with statement, 172, 179
DBA (database administrator), solutions to
contention, 241, 244
DBMS
closeness to kernel, 37–40
partition, different meanings of, 115
dbms_application_info package (Oracle), 28
DDL (data definition language), 33
decision support systems (DSS)
interaction with production
databases, 265
query tools, 266
(see also data warehousing)
declarative language, 79
declarative processing, procedural vs., 35
decode( ) function, 42
delete operations, 263
against a database, 34
ranking in terms of overall cost, 263
denormalization, 20
caused by ready-made solutions, 32
dependencies, analyzing, 8–11
Boolean columns, 14
checking attribute independence, 9
checking dependence on whole key, 8
data replications and, 13
depth, hierarchical data, 169, 179, 294
design
irredeemable failure caused by, 249
performance and, 21
developmental solutions to contention, 243
dimension tables, 265
joining dimensions to fact tables, 273
querying, 270
dimensional modeling, 265
caution with, 277
facts and dimensions, 265
querying dimensions and facts, 270–273
SQL implications, 270
(see also data warehousing)
directives to the optimizer, 144–145, 305, 329
disk addresses, indexes referring to, 80
distinct, 91
avoiding at the top level, 93
implicit, 95
regular join with, 137
3 3 8 I N D E X
www.it-ebooks.info
distributed systems, 205–208
DML (data manipulation language), commit
statements, 34
double conversion, 302, 303
DSS (see decision support systems)
duplicate data
detection of duplicate primary keys, 50
minimizing with normalization, 10
duration, determining without dedicated
interval data type, 66
dynamic queries, 117, 309
dynamic search criteria, 208–223
defining movie database and main
query, 209–216
mistakes common in queries with, 223
redesigning main query to fit criteria
tightly, 216
wrapping SQL in PHP, 217–222
E
efficiency
of filtering conditions, 84, 90
of searches, descriptions and, 6
use of SQL, x
(see also performance)
ELSE logic, obtaining, 42
encapsulation of database accesses, how not
to, 202–205
entry points, identifying, 56–59
errors, data entry, 6
evaluating filtering conditions, 90–98
evolutionary database model, 107
except operator, 163, 164
exception handling
cost of, 52
forcing use of procedural logic, 53
exceptions, judicious use of, 50–53
excessive flexibility, dangers of, 18
execution plans, 319–330
forcing the right plan, 323–328
identifying the fastest, 320–322
using properly, 328–330
existence test, 93
correlated subquery without other
search criteria, 207
within subquery, 95
explain command, 142
explode( ) operator, 169
exploding a materialized path, 293
explosion of links, 193
expressions, complex SQL expressions, 88
extending DBMS products, 37
extraction of data, 268
F
fact dimension, 281
fact tables, 265
joining to dimensions, 273
querying, 270
querying star schema through, 276
federated systems, 205
fifth normal form (5NF), 5
filtering conditions, 84, 89–103
dynamically concatenated, 216
evaluation of, 90–98
large quantities of data, 98–102
meaning of, 89
proportions of retrieved data, 103
queries returning a few rows from
direct, specific criteria, 129
financial structures, risk exposure
calculations, 170
fine (granularity), 34
first normal form (1NF), 8
fixed, inflexible database model, 106
flexibility (excessive), dangers of, 18
foreign keys, 17
indexes and, 67–69
integrity constraint in master/detail
relationship, 169
multiple indexing of the same
columns, 69
referencing underlying tables in
partitioned view, 117
(see also primary keys)
free lists, 242
from clauses
nested queries in, 144
uncorrelated subqueries rewritten as
inline views, 96
uncorrelated subquery in, 138
full table scans, 135, 146
indexes vs., 109
on tables expected to grow, 102
functions
added to DBMS products, 37
aggregate, 150–156
built-in, advantages over external
functions, 37
indexes with, 62–66, 129
appropriate use of, 66
implicit conversions and, 64
OLAP, operating on sliding
windows, 149–150
user-defined, 44, 146
I N D E X 339
www.it-ebooks.info
G
global architecture, choice of, 249
good performance, defining, 311–317
checking against standards, 315–316
knowing what you get, 312–314
knowing what you spend, 312
performance goals, 316
granularity, 34
of locking, 232, 239
required by decision support
systems, 268
table of contents vs. index, 59
greatest( ) function, 43
group by clauses
filtering and, 99
use in aggregate statements, 156
H
hardcoding, 203, 310
hardware
balancing programming mistakes with
power, 248
failures of, 24
hash indexes, 72
hash joins, 140, 147, 164, 262, 272
hash-partitioning, 118
having clause
filtering after group by clause, 99
use in aggregate statements, 155
head counts, modeling, 190
computing head counts at every
level, 192–194
heap-organized table, index-organized table
vs., 112
hierarchical data
depth (see depth, hierarchical data)
practical example of hierarchies, 170
suggested explode( ) operator, 169
walking a tree in SQL, 177–189
aggregating values from trees,
190–198
bottom-up walk, 185–189
top-down walk, 178–185
walking hierarchies, 173
hierarchical databases, 168
hierarchical ordering of tables with IOTs and
clustered indexes, 114
hints to the optimizer, 144–145
historical data, 156–161
current values, obtaining, 160
design of tables storing, 157
difficulties of working with, 19–21
many historical values per item, 160
many items with few historical
values, 157
partitioning tables by date, 116
historical table, using, 21
(see also tables)
host language, SQL statements embedded
in, 42
hot spot in an index tree, 72
I
I/Os (increased), relieving over-worked
CPUs, 88
implicit constraints on data, 17
implicit rules, 13
implicit type conversions, 129
indexes and, 64
inconsistency of data, 10, 13
incorrect results, difficulty of spotting, 93
increasing data volumes (see large data
volumes, coping with)
indeterminate condition, 11
index range scan, 64
indexes, 330
adding to DMBS to tune it, 248
bitmap, 273
clustered vs. non-clustered index
performance, 114
completing queries with data returned
from, 146
content lists and, 59
contention within, improving, 244
correlated subqueries and, 94
costs of, 56
costs of maintaining, 108
as data repositories, 109–113
full table scans vs., 109
storing maximum data possible, 110
data access at atomic level of
granularity, 60
data loading and, 270
data warehousing, 276
defining row order in tables, 114
dimension tables, 271
dimensional model, 277
finding physical location of a row, 62
foreign keys and, 67–69
with functions, 62–66, 129
appropriate situations for use, 66
implicit conversions and, 64
maintenance costs, 57
3 4 0 I N D E X
www.it-ebooks.info
making them work, 60
location of rows associated with
index key, 61
multiple indexing of a column, 69
necessity of using, despite costs, 59
optimizer and, 79
partitioning, 115
performance and, 309
physical design of, 109
production database tuning and, 22
proportions of retrieved data, 103
queries returning small result set from
very specific criteria, 129–137
criterion indexability, 132–137
data dispersion, 130–132
index usability, 129
query efficiency and index
usage, 130
reference to disk addresses, 80
reverse, 71
solving contention problems, 243
searching, 92
system-generated keys, 70
temporary tables, 34
transactional databases, 59
variability of accesses, 72
virtues of, 226
index-organized tables (IOTs), 112
drawbacks of, 114
forcing row ordering, 113
solving contention problems with, 243
indirect criterion, 140
ingredients, identifying, 170
names and proportions in various
products, 195–198
inline views, 135
rewriting uncorrelated subqueries
as, 96
rewriting uncorrelated subqueries as
joins in, 101
Inmon, Bill, 264
inner queries, 94
input, primitive, 130
insensitivity to volume increases, 250
insert statements
dynamic, built for varying table
names, 117
returning ... into ... clause, 236
insertion rates
obtained with contention-limiting
measures, 243
regular table vs. index-organized
table, 112
insertions
contention and, 240
into referencing tables, preventing, 68
ranking in terms of overall cost, 263
integrity checking, taken out of DBMS
kernel, 117
integrity constraints
data loading and, 270
foreign key constraint in master/detail
relationship, 169
partitioned view and, 117
validation performed through, 206
inter-process communications, caused by use
of procedural logic, 35
inter-process database link, 205
intersect operator, 164
intersection of result sets
final result set, small intersection of
broad criteria, 138–140
intermediate result sets, 85
interval data type, 66
IOTs (see index-organized tables)
IP address database link, 205
J
joins
Cartesian, 285, 286
delaying till query end, 254–256
filtering conditions, 89, 92
older join syntax, 92
overlooked join condition, hidden by
distinct, 93
pattern of, deciding factor, 93
performance and, 266
pre-joining tables, 123
problems with, 86
regular join with a distinct, 137
rewriting uncorrelated subqueries as
joins in inline views, 101
self-joins on one table, 147–150
of two remote tables, 208
unions of complex joins, 98
(see also hash joins; nested loops)
K
Kent, William, 147
key values (index), querying indexes
without full key, 110
Kimball, Ralph, 264
I N D E X 341
www.it-ebooks.info
L
lag( ) OLAP function, 150
large data volumes, coping with, 248–278
data warehousing, 264–278
increasing volumes, 248–264
partitioning as solution, 262
sensitivity of operations to,
250–261
sudden increase in volume, 309
last_insert_id( ) (MySQL), 235
latching, 88
(see also locking)
LDAP (Lightweight Directory Access
Protocol), 168
leading bytes, using for index queries, 110
leaf nodes, 168
aggregation of values stored in, 190–194
computing head counts at all
levels, 192–194
modeling head counts, 190
least( ) function, 43
legacy system data, 248
putting into production, 249
levels in trees, 171
Lightweight Directory Access Protocol
(LDAP), 168
like operator, 201
limitation criteria, 80
linear sensitivity to data volume
increases, 251
linked server, 205
listener program, contacting in database
connections, 30
list-partitioning, 119
lists
content lists, indexes and, 59
querying a list variable, 294–297
selecting rows matching several
items, 301–303
load, 310
database load, main indicators of, 312
increase in server load, 316
relating to execution of SQL
statements, 313
loading data, 269
locking, 88, 232–239
causing sudden localized slowness, 309
committing and, 236
granularity of, 232
lock handling, 234–236
scalability and, 238
logic, programming into queries, 42
loop-back database link, 205
loops, 42
not executing queries in, 227
SQL statements executed in, 314
low cardinality, 109
M
many-to-many relationship resolving
between two tables, 69
master/detail relationships, 168
matching, finding the best match, 304
materialized path model (SQL trees), 172,
175
aggregating values stored in leaf
nodes, 191
computing head counts at every
level, 193
bottom-up tree walk, 186
path explosion, 293
substituting for connect by or recursive
with, 189
top-down walk, 182–183
materialized views, 33
pre-joining vs., 123
measurement values, storage of, 265
memory
addresses for data storage, 109
corrupting by mishandling pointers, 37
merge statement, Oracle 9i, 41
merge table (MySQL), 116
meta-design, 281
mini-dimensions, 270
modeling, 4
head counts, 190
computing at every level, 192–194
(see also data modeling; dimensional
model; relational model)
modifying data (see changing data,
concurrency and)
modularity, database programming and, 45
monitoring performance, 308–331
defining good performance, 311–317
checking against standards,
315–316
defining performance goals, 316
knowing what you get, 312–314
knowing what you spend, 312
execution plans, 319–330
forcing the right plan, 323–328
identifying the fastest, 320–322
using properly, 328–330
server load, 310
3 4 2 I N D E X
www.it-ebooks.info
slow database, 308–310
statements currently being executed, 42
thinking in business tasks, 317–319
what really matters in improving
queries, 330
“more-flexible-than-thou” construct, 18
movie database, 209–223
designing database and main search
query, 209–216
redesigning main search query for tight
fit, 216
wrapping SQL in PHP, 217–222
MySQL
last_insert_id( ), 235
merge table, 116
PHP, using with, 209
N
nested “containers”, 170
nested interval model (SQL trees), 173
nested loops, 24, 140, 142, 144
nested queries, 135
in from clause, 144
nested set model (SQL trees), 172, 176–177
aggregating values stored in leaf
nodes, 190
bottom-up tree walk, 188
top-down walk, 183
network problems, 308
insufficient speed or bandwidth, 310
“next value to use” table, 235
nine situations, 128
(see also classic SQL patterns)
nodes
relational view of a tree, 169
tree representing a hierarchy, 168
(see also leaf nodes)
non-linear sensitivity to data volume
increases, 251–254
non-relational layer of SQL
applying last, 331
limiting thickness of, 256
OLAP functions, 159
normalization, 4–11
atomicity, 5
checking attribute independence, 9
checking dependence on the whole
key, 8
data warehousing and 3NF design, 265
ensuring atomicity, 5
not exists ( ), using with a correlated
subquery, 162
not in ( ), using with uncorrelated
subquery, 161, 165, 166
null returns, 85
null values, 11–14, 166
indicating need for subtypes, 16
numerical values, comparing, 43
O
object-oriented (OO) practice, relational
database processing vs., 37
offensive coding with SQL, 48
OLAP functions
current value for an item at a given
date, 159
operating on sliding windows, 149–150
row_number( ), 180
“one size fits all” philosophy, 223
online analytical processing (OLAP),
DB2, 52
online transaction processing (OLTP), 22
operating mode, 22
operating systems, contention issues
and, 108
operational data stores, 265
operations (data manipulation), ranking in
terms of overall cost, 263
operations, sensitivity to data volume
increases, 250–261
disentangling subqueries, 256–261
insensitivity to, 250
linear sensitivity to, 251
non-linear sensitivity to, 251–254
optimistic concurrency control method, 49
optimizers, 77, 79
causing to take a different course, 329
checking execution plan, 142
circumstances not allowing efficient
working of, 330
data distributions and, 161
directives, 305
directives or hints to, 144–145
heterogeneous, on distributed
systems, 207
join filtering conditions and, 89
joins and filtering conditions, 92
limits of, 83
queries and, 79
rewriting of queries, 98
views and, 87
I N D E X 343
www.it-ebooks.info
Oracle
connect by operator, 172, 178, 181
propagating percentages across tree
levels, 196
substituting materialized path
model for, 189
dbms_application_info package, 28
rownums, 80, 87
tablespace referred to as a partition, 115
Oracle 9i Database, merge statement, 41
order of evaluation, filtering conditions, 89
ordering criteria, 80
ordering information, relations vs., 81
(see also sorts)
orders/order_detail relationship, 168
outer joins
expressing nonexistence with, 165
using in dynamically defined search
query, 216
outer queries, 94
outriggers, 270
P
pages, 108
locking, 232
pre-joined tables and, 124
parallelism
adjusting to solve contention
problems, 243
increased, with partitioning, 115
processing very large volumes of
information, 147
parallelized queries, 207
parent/child link, master/detail relationship
vs., 168
parents, multiple, 169
Parkinson’s Law, 310
partition clause, 149
partition key, 118
partition pruning, 118
partitioned view, 116
partitioning, 115–123, 330
archival and data purges, 263
data distribution and, 120
data-driven, 116
determining best way to partition
data, 121–123
methods of, 118
round-robin, 116
scattering or clustering data, 119
solution for contention, 242
solving data volume problems, 262
partitions, 130
varying meanings among DBMS
systems, 115
Pascal, Fabian, 169
patterns (see classic SQL patterns)
percentages, propagating across different tree
levels, 194–198
performance
bottom-up tree walk, comparing for
various models, 188
clustered vs. non-clustered indexes, 114
committing and, 237
computing head counts from
aggregation of information in
leaf nodes, 194
costs of excess flexibility, 18
database connections, minimizing, 29
database engine, hardware, and I/O
subsystems, 230
database links, costs of, 205
design and, 21
improving queries, what really
matters, 330
joins and, 266
monitoring (see monitoring
performance)
non-relational layer of queries, 82
procedural logic and, 36
request complexity and, 230
results from contention-limiting
measures, 243–246
solving problems with, 280–306
aggregating by range (bands),
297–299
columns that should have been
rows, 284–289
columns that should have been
something else, 289–294
finding the best match, 304
optimizer directives, 305
querying a list variable, 294–297
rows that should have been
columns, 281–284
selecting rows matching several list
items, 301–303
superseding a general case, 299–301
statements arriving faster than they are
serviced, 231
top-down query, comparing various
models, 184
transparent references to remote
data, 23
tuning vs., x
3 4 4 I N D E X
www.it-ebooks.info
persistency layers, abstract, 202–205
PHP, 209
wrapping SQL in, 217–222
physical layout of data
conflicting goals in optimization
attempts, 108
forcing row ordering, 113
index performance and, 130–132
indexes as data repositories, 109–113
partitioning, 115–123
best way to partition,
determining, 121–123
data distribution and, 120
scattering or clustering data, 119
pre-joining tables, 123
process requirements and physical
design, 109
sacrificing simplicity with strong
structuring, 124
pivot operator, 288
pivot tables
binding a list, 303
creating, 285
multiplying rows, 286
passing list of values as single string to a
statement, 294–297
using values, 286
place-holders (bind variables), 162
pointers, manipulation of, 37
Practical Issues in Database Management, 169
primary key index
clustering index, using as, 114
insertion rate for IOT vs. regular
table, 112
limiting contention within, 245
primary keys
composite, 70
order of columns, 158
defining, 7
detection of duplicates, 50
indexing of, 59
subtype relationships, 16
system-generated, indexing of, 70
values in operational database vs.
dimension identifiers, 269
whole key dependence and, 8
(see also foreign keys)
primitive input, 130
principles, 3
probabilistic basis, coding on, 48
problems, defining before solution, 32
procedural logic
achieving in database applications, 42
exception handling and, 53
in SQL, reasons for shunning, 35
procedural processes within a business,
paying too much attention to, 31
procedural processing, declarative vs., 35
processes
contention between (see contention)
physical database layout and, 35
spawned by listener in database
connections, 30
processing flow, 22
production databases, 265
program variable for sequence value, 236
purging data, 263
Q
queries, 3, 76–103
answered by returning index data, 110
blanket views, performance impact
of, 117
complex, and complex views, 86
distributed, 206
distributed and parallelized, 207
dynamic, 309
for variable number of search
criteria, 214–216
mistakes commonly made in, 223
estimating behavior with increased data
volumes, 254
expression of, association with implicit
assumptions about data, 98
functionally equivalent, comparison to
synonyms, 96
identifying, 28
improving, what really matters, 330
limits of the optimizer, 83
making as fast as possible, 108
nested, 135
non-relational aspects of, 81
number of data page hits by DBMS
during performance of, 103
order of evaluation of conditions, 90
performance, whole key dependence
and, 9
programming logic into, 42
relational component, 80
relational layer, doing maximum work
in, 82
returning a very large amount of
data, 102
rewriting by the optimizer, 98
size of result set, 85
SQL expression of, 77
tuning, 22
various layers of, 78
query tools, 266
I N D E X 345
www.it-ebooks.info
3 4 6 R
random numbers, using instead of system-
generated values, 243, 244
range scans, 130
on clustered data, 113
converting variable-length comparison
to common case, 200–202
reverse indexes and, 71
simple or range searching on
dates, 156–161
range-clustering (DB2), 118
range-partitioning, 118
ranges
aggregating by range (bands), 297–299
importance of well-defined
boundaries, 262
ranking functions (SQL Server), 52
recovering databases, 24
recursive with statement, 172, 179
adjacency model, top-down tree
walk, 180
propagating percentages across different
tree levels, 196
substituting materialized path model
for, 189
redundant data, 8
reference data in dimension tables, 265
referencing tables, preventing insertions
into, 68
relational databases, 76
hierarchical databases vs., 114
processing, confusing with object-
oriented methods, 37
SQL and, 76
relational model, 2
coherence of, 3
flexibility of, sacrificing by strongly
structured data, 125
two-valued logic, 11
view of a tree, 169
relational operations, reporting requirements
vs., 78
relational theory, 77
relations, 3
associating large numbers of possible
characteristics in, 11
ordering information vs., 81
remote data
querying, 24
transparent references to, 23
remote data sources, 205–208
remote validation checks, 206
reorganizations of databases, 132
I N D E X
reporting requirements, 77
request type, partitioning by, 122
requirements, evolution of, 10
response times, 147
(see also performance)
result sets
criteria defining, 84
difficulty of spotting incorrect data, 93
filtering conditions, 89–103
evaluation of, 90–98
large quantities of data, 98–102
meaning of, 89
proportions of retrieved data, 103
large, 146
obtained by aggregation, 150–156
predicated on absence of data,
161–166
size of, 85, 330
small intersection of broad criteria,
138–140
small intersection, indirect broad
criteria, 140–145
small result set, indirect criteria, 137
small, from direct, specific criteria,
129–137
retrieval ratios, 60
returning ... into ... clause, 236
reverse indexes, 71
solving contention problems, 243
right-padding function (rpad( )), 202
risk exposure in a financial structure, 170
round-robin partitioning, 116
row_number( ) OLAP function, 149, 159,
180
rownums (Oracle), 80, 87
rows, 330
associated with index key, physical
closeness of, 61
columns that should have been
rows, 284–289
emptying a table of all rows, 33
locking, 232, 238
matching several list items,
selecting, 301–303
ordering of, forcing, 113
physical location, finding with an
index, 62
primary key, defining, 7
proportions of retrieved data, 103
that should have been columns,
281–284
updating and inserting, dedicated
statements for, 41
rpad( ) function (right-padding), 202
www.it-ebooks.info
S
scalability, locking and, 238
scattering data with partitioning, 120
schemas
classical order schema, 91
movie database (example), 210
(see also star schema)
science, art vs., xi
searches
dynamically defined criteria, 208–223
designing movie database and main
query, 209–216
mistakes common in queries, 223
redesigning query for tight fit with
criteria, 216
wrapping SQL in PHP, 217–222
efficiency, descriptions and, 6
second normal form (2NF), 9
select distinct queries, 9
select operator, filtering conditions, 89
selectivity of an index, 61
self-joins, 147, 282
performance and, 282, 284
semantic inconsistency, 13
sensitivity of operations to volume
increases, 250–261
disentangling subqueries, 256–261
insensitivity to, 250
linear sensitivity to, 251
non-linear sensitivity to, 251–254
sequences
call to database for new value, 236
not using in order to limit
contention, 245
server load, 310
increase in, 316
servers, 205
set operators, 163–165
assembling data from several
sources, 268
getting rid of unwanted data quickly, 98
sets
nested set model, SQL trees, 172,
176–177
bottom-up walk, 188
top-down walk, 183
processing in SQL, 34
relational theory and, 78
slow database, 308–310
it’s not the database, 308
particularly slow query, 309
slow performance degradation reaching
a threshold, 309
sudden global sluggishness, 308
sudden localized slowness, 309
snapshots, 33, 314
solutions (ready-made), problems caused
by, 32
sorts, 80
volume increases and, 251–253
delaying joins to end of query,
254–256
spreading data across many servers, 23
SQL
art of, governing factors, 84–88
number of tables, 85
number of users, 88
result set criteria, 84
result set size, 85
total quantity of data, 84
classic patterns (see classic SQL
patterns)
efficient use of, x
general characteristics of, 76–83
relational and non-relational
aspects, 80
SQL and databases, 76–79
SQL and the optimizer, 79
wrapping in PHP, 217–222
SQL Communication Area (SQLCA), 41
SQL engine cache, 314
SQL Server
clustered index, 114
pivot and unpivot operators, 288
recursive with statement, 172
star schema, 265
querying tables, 271
querying through facts and
dimensions, 276
star transformation, 273
emulating, 274–276
statements
action-packed, 35
first questions to consider when
writing, 90
mirroring business logic, 42
relating load to execution of, 313
succinct, 46
statistical functions, 77
statistics, automated collection of, 34
status, partitioning by, 122
storage
options other than default, introducing
complexity with, 124
peculiarities in, 330
temporary, 82
stored procedures, 10, 310
I N D E X 347
www.it-ebooks.info
strategy, defining tactics with, 31
strings
comparing, 43
extracting individual characters and
returning them on separate
rows, 290–293
structural types, databases, 106–107
subqueries
correlated or uncorrelated, deciding
between, 137
sensitivity of operations to data volume
increases, 254
use in processing massive numbers of
rows, 147
value of an item on a given date, 157
where clauses, 84
(see also correlated subqueries;
uncorrelated subqueries)
subtypes, 15
defining to deal with varying numbers
of attributes, 281
succinct statements, 46
summary tables, pre-joining vs., 123
Sybase, clustered index, 114
syllogisms, 328
synchronization of databases after
recovery, 25
synchronous processing, 22
synonyms, comparison to functionally
equivalent queries, 96
system
changes in, causing sudden global
slowness, 309
complexity of, 24
database connections, 30
distributed, 205–208
tuning, 21
system-generated keys, 70
system-generated values, 235
not using in order to prevent
contention, 243, 244
T
table of contents, index vs., 59
tables, 2
current table and historical table, using,
21
enabling data retrieval as with table of
contents, 60
forcing row ordering, 113
improving contention within
indexes, 244
index-organized table (IOT), 112
locking, 232, 238
number involved in a query, 85
partitioning, 115
physical design of, 109
pre-joining, 123
remote, joins, 208
single table in hierarchical tree
structure, 168
tables that are views, 106
valuation, 19–21
tablespace (Oracle), referred to as a
partition, 115
tactics, defined by strategy, 31
target volumes for database systems, 249
temporary storage, 82
temporary tables, 264
disadvantages of using, 34
third normal form (3NF), 4, 9
data warehousing and, 265
threads spawned by listener in database
connections, 30
three-valued logic (implied by nulls), 12
“tight-fit” query, 216
time information, 64
timestamps, 148
reverse indexing and, 72
top-down tree walk, 178–185
adjacency model, 178–182
aggregating values stored in leaf
nodes, 190
materialized path model, 182–183
nested set model, 183
performance for various models, 184
transaction space, 242
transactional databases
indexes, 109
indexing requirements, 59
transactions
good practices in, 234
across heterogeneous systems, 206
locking and committing, 236
Transact-SQL, @@IDENTITY system
variable, 235
transformations, 268
mathematical equivalence of, 83
star transformation, 273
emulating, 274–276
transparent references to remote data, 23
tree structures, 168–171
aggregating values from trees, 190–198
propagating percentages across
levels, 194–198
values stored in leaf nodes,
190–194
3 4 8 I N D E X
www.it-ebooks.info
hierarchies, practical examples of, 170
of indexes, 62
master/detail relationships vs., 168
materialized path model,
exploding, 293
practical implementation of trees,
174–177
adjacency model, 174
materialized path model, 175
nested set model, 176–177
representing trees in SQL
database, 172–174
walking a tree in SQL, 177–189
bottom-up walk, 185–189
top-down walk, 178–185
triggers, 10, 330
index maintenance costs vs., 58
Tropashko, Vadim, 173
truncate operations, 33
delete vs., 263
truths, 3
freedom in the choice of, 4
tuning, 21
adding indexes, 248
performance vs., x
two-valued logic, 11
types
implicit conversions, 129
partitioning by, 122
U
uncorrelated subqueries, 94, 158
in classic style or in from clause, 138
not in ( ), using with, 162
rewriting as a join in an inline
view, 101
rewriting as inline views in from
clause, 96
sensitivity of operations to data volume
increase, 254
testing for existence without other
search criteria, 207
union operator, 164
querying large quantities of data, 98
unions
of complex joins, 98
of intermediate result sets, 85
overhead of querying large union
view, 117
partitioned tables, 116
uniqueness, enforcement of, 50, 117
unnecessary coding, avoiding, 41
unpivot operator, 288
update statement, returning ... into ...
clause, 236
updates
against a database, 34
combining multiple into one, 43
concurrent
foreign key indexing, 69
costly massive updates, 314
locking and scalability, 238
making as fast as possible, 108
multiple massive updates to a table, 268
optimistic concurrency control, 49
ranking in terms of overall cost, 263
(see changing data, concurrency and)
useless queries, 310
user-defined functions, 44, 146
users
not complaining about
performance, 315
number of, concurrency and, 88
perception of performance
improvement, 316
V
valuation, 19
valuation tables, 19–21
variable number of search criteria, mistakes
in queries containing, 223
variables, binding, 294, 296
PHP, 218–222
views, 3, 329
complex, 86
partitioned view, 116
tables as, 106
where clauses, 84
volume of data (see large data volumes,
coping with)
W
warehousing data (see data warehousing)
where clauses
in aggregate statements, 156
atomic attributes, 6, 64
filtering conditions, 84, 89
filtering conditions independent of the
aggregate, 99
join operator, 89
two-valued logic, 11
with statement, recursive (see recursive with
statement)
X
XML, 168, 290
I N D E X 349
www.it-ebooks.info