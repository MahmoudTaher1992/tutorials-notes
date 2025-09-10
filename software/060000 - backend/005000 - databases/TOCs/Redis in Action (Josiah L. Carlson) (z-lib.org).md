ok.com>
brief contents
PART 1 GETTING STARTED. ..........................................................1
1 ■ Getting to know Redis 3
2 ■ Anatomy of a Redis web application 24
PART 2 CORE CONCEPTS.............................................................37
3 ■ Commands in Redis 39
4 ■ Keeping data safe and ensuring performance 63
5 ■ Using Redis for application support 90
6 ■ Application components in Redis 110
7 ■ Search-based applications 154
8 ■ Building a simple social network 185
PART 3 NEXT STEPS.................................................................207
9 ■ Reducing memory use 209
10 ■ Scaling Redis 228
11 ■ Scripting Redis with Lua 249
vii
Download from Wow! eBook <www.wowebook.com>
Download from Wow! eBook <www.wowebook.com>
contents
foreword xv
preface xvii
acknowledgments xix
about this book xxi
about the cover illustration xxv
PART 1 GETTING STARTED..................................................1
1 Getting to know Redis 3
1.1 What is Redis? 4
Redis compared to other databases and software 4■ Other
features 6■ Why Redis? 6
1.2 What Redis data structures look like 7
Strings in Redis 9■ Lists in Redis 10■ Sets in Redis 11
Hashes in Redis 12■ Sorted sets in Redis 13
1.3 Hello Redis 15
Voting on articles 15■ Posting and fetching articles 19
Grouping articles 20
1.4 Getting help 22
1.5 Summary 22
ix
Download from Wow! eBook <www.wowebook.com>
x
CONTENTS
2 Anatomy of a Redis web application 24
2.1 Login and cookie caching 25
2.2 Shopping carts in Redis 29
2.3 Web page caching 30
2.4 Database row caching 31
2.5 Web page analytics 34
2.6 Summary 36
PART 2 CORE CONCEPTS...................................................37
3 Commands in Redis 39
3.1 Strings 40
3.2 Lists 43
3.3 Sets 46
3.4 Hashes 48
3.5 Sorted sets 50
3.6 Publish/subscribe 54
3.7 Other commands 57
Sorting 57■ Basic Redis transactions 58■ Expiring keys 61
3.8 Summary 62
4 Keeping data safe and ensuring performance 63
4.1 Persistence options 64
Persisting to disk with snapshots 65■ Append-only file
persistence 68■ Rewriting/compacting append-only files 70
4.2 Replication 70
Configuring Redis for replication 71■ Redis replication startup
process 72■ Master/slave chains 73■ Verifying disk writes 74
4.3 Handling system failures 75
Verifying snapshots and append-only files 76■ Replacing a failed
master 77
4.4 Redis transactions 78
Defining users and their inventory 79■ Listing items in the
marketplace 80■ Purchasing items 82
4.5 Non-transactional pipelines 84
Download from Wow! eBook <www.wowebook.com>
CONTENTS xi
4.6 Performance considerations 87
4.7 Summary 89
5 Using Redis for application support 90
5.1 Logging to Redis 91
Recent logs 91■ Common logs 92
5.2 Counters and statistics 93
Storing counters in Redis 94■ Storing statistics in Redis 98
Simplifying our statistics recording and discovery 100
5.3 IP-to-city and -country lookup 102
Loading the location tables 102■ Looking up cities 104
5.4 Service discovery and configuration 104
Using Redis to store configuration information 105■ One Redis server
per application component 106■ Automatic Redis connection
management 107
5.5 Summary 109
6 Application components in Redis 110
6.1 Autocomplete 111
Autocomplete for recent contacts 111■ Address book autocomplete 113
6.2 Distributed locking 116
Why locks are important 117■ Simple locks 119■ Building a lock in
Redis 120■ Fine-grained locking 123■ Locks with timeouts 126
6.3 Counting semaphores 127
Building a basic counting semaphore 127■ Fair semaphores 129
Refreshing semaphores 132■ Preventing race conditions 132
6.4 Task queues 134
First-in, first-out queues 134■ Delayed tasks 137
6.5 Pull messaging 140
Single-recipient publish/subscribe replacement 140■ Multiple-recipient
publish/subscribe replacement 141
6.6 Distributing files with Redis 146
Aggregating users by location 146■ Sending files 148
Receiving files 149■ Processing files 150
6.7 Summary 152
Download from Wow! eBook <www.wowebook.com>
xii
CONTENTS
7 Search-based applications 154
7.1 Searching in Redis 155
Basic search theory 155■ Sorting search results 161
7.2 Sorted indexes 163
Sorting search results with ZSETs 163■ Non-numeric sorting with ZSETs 165
7.3 Ad targeting 167
What’s an ad server? 168■ Indexing ads 168■ Targeting ads 171
Learning from user behavior 175
7.4 Job search 181
Approaching the problem one job at a time 181■ Approaching the
problem like search 182
7.5 Summary 183
8 Building a simple social network 185
8.1 Users and statuses 186
User information 186■ Status messages 187
8.2 Home timeline 188
8.3 Followers/following lists 190
8.4 Posting or deleting a status update 192
8.5 Streaming API 196
Data to be streamed 196■ Serving the data 197■ Filtering streamed
messages 200
8.6 Summary 206
PART 3 NEXT STEPS.......................................................207
9 Reducing memory use 209
9.1 Short structures 210
The ziplist representation 210■ The intset encoding for
SETs 212■ Performance issues for long ziplists and intsets 213
9.2 Sharded structures 215
HASHes 216■ SETs 219
9.3 Packing bits and bytes 222
What location information should we store? 222■ Storing packed
data 224■ Calculating aggregates over sharded STRINGs 225
9.4 Summary 227
Download from Wow! eBook <www.wowebook.com>
CONTENTS xiii
10 Scaling Redis 228
10.1 Scaling reads 228
10.2 Scaling writes and memory capacity 232
Handling shard configuration 233■ Creating a server-sharded
connection decorator 234
10.3 Scaling complex queries 236
Scaling search query volume 236■ Scaling search index size 236
Scaling a social network 241
10.4 Summary 248
11 Scripting Redis with Lua 249
11.1 Adding functionality without writing C 250
Loading Lua scripts into Redis 250■ Creating a new status
message 252
11.2 Rewriting locks and semaphores with Lua 255
Why locks in Lua? 255■ Rewriting our lock 256
Counting semaphores in Lua 258
11.3 Doing away with WATCH/MULTI/EXEC 260
Revisiting group autocomplete 260■ Improving the marketplace,
again 262
11.4 Sharding LISTs with Lua 265
Structuring a sharded LIST 265■ Pushing items onto the sharded
LIST 266■ Popping items from the sharded LIST 268
Performing blocking pops from the sharded LIST 269
11.5 Summary 271
appendix A Quick and dirty setup 273
appendix B Other resources and references 281
index 284
Download from Wow! eBook <www.wowebook.com>
Download from Wow! eBook <www.wowebook.com>