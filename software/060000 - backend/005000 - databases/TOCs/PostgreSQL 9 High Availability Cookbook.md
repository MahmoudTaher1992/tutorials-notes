Table of Contents
Preface 1
Chapter 1: Hardware Planning 7
Introduction 7
Planning for redundancy 8
Having enough IOPS 11
Sizing storage 14
Investing in a RAID 18
Picking a processor 21
Making the most of memory 24
Exploring nimble networking 26
Managing motherboards 31
Selecting a chassis 34
Saddling up to a SAN 36
Tallying up 39
Protecting your eggs 41
Chapter 2: Handling and Avoiding Downtime 43
Introduction 43
Determining acceptable losses 44
Configuration – getting it right the first time 46
Configuration – managing scary settings 50
Identifying important tables 53
Defusing cache poisoning 58
Exploring the magic of virtual IPs 62
Terminating rogue connections 64
Reducing contention with concurrent indexes 68
Managing system migrations 70
Managing software upgrades 73
Table of Contents
Mitigating the impact of hardware failure 76
Applying bonus kernel tweaks 81
Chapter 3: Pooling Resources 85
Introduction 86
Determining connection costs and limits 87
Installing PgBouncer 89
Configuring PgBouncer safely 92
Connecting to PgBouncer 96
Listing PgBouncer server connections 97
Listing PgBouncer client connections 99
Evaluating PgBouncer pool health 101
Installing pgpool 105
Configuring pgpool for master/slave mode 108
Testing a write query on pgpool 112
Swapping active nodes with pgpool 114
Combining the power of PgBouncer and pgpool 117
Chapter 4: Troubleshooting 121
Introduction 121
Performing triage 122
Installing common statistics packages 125
Evaluating the current disk performance with iostat 126
Tracking I/O-heavy processes with iotop 129
Viewing past performance with sar 131
Correlating performance with dstat 133
Interpreting /proc/meminfo 136
Examining /proc/net/bonding/bond0 139
Checking the pg_stat_activity view 142
Checking the pg_stat_statements view 145
Debugging with strace 148
Logging checkpoints properly 151
Chapter 5: Monitoring 155
Introduction 156
Figuring out what to monitor 156
Installing and configuring Nagios 158
Configuring Nagios to monitor a database host 162
Enhancing Nagios with check_mk 166
Getting to know check_postgres 169
Installing and configuring collectd 172
Adding a custom PostgreSQL monitor to collectd 175
Installing and configuring Graphite 179
ii
Table of Contents
Adding collectd data to Graphite 182
Building a graph in Graphite 186
Customizing a Graphite graph 188
Creating a Graphite dashboard 191
Chapter 6: Replication 195
Introduction 195
Deciding what to copy 196
Securing the WAL stream 198
Setting up a hot standby 201
Upgrading to asynchronous replication 205
Bulletproofing with synchronous replication 209
Faking replication with pg_receivexlog 212
Setting up Slony 214
Copying a few tables with Slony 217
Setting up Bucardo 221
Copying a few tables with Bucardo 224
Setting up Londiste 227
Copying a few tables with Londiste 230
Chapter 7: Replication Management Tools 233
Introduction 234
Deciding when to use third-party tools 235
Installing and configuring Barman 237
Backing up a database with Barman 240
Restoring a database with Barman 242
Installing and configuring OmniPITR 244
Managing WAL files with OmniPITR 247
Installing and configuring repmgr 250
Cloning a database with repmgr 254
Swapping active nodes with repmgr 257
Installing and configuring walctl 260
Cloning a database with walctl 264
Managing WAL files with walctl 266
Chapter 8: Advanced Stack 269
Introduction 269
Preparing systems for the stack 273
Getting started with the Linux Volume Manager 275
Adding block-level replication 279
Incorporating the second LVM layer 281
Verifying a DRBD filesystem 284
Correcting a DRBD split brain 285
iii
Table of Contents
Formatting an XFS filesystem 288
Tweaking XFS performance 290
Maintaining an XFS filesystem 293
Using LVM snapshots 295
Switching live stack systems 298
Detaching a problematic node 300
Chapter 9: Cluster Control 303
Introduction 303
Installing the components 305
Configuring Corosync 307
Preparing startup services 310
Starting with base options 312
Adding DRBD to cluster management 315
Adding LVM to cluster management 318
Adding XFS to cluster management 321
Adding PostgreSQL to cluster management 323
Adding a virtual IP to hide the cluster 326
Adding an e-mail alert 328
Grouping associated resources 329
Combining and ordering related actions 331
Performing a managed resource migration 333
Using an outage to test migration 336
Chapter 10: Data Distribution 339
Introduction 339
Identifying horizontal candidates 340
Setting up a foreign PostgreSQL server 344
Mapping a remote user 347
Creating a foreign table 349
Using a foreign table in a query 352
Optimizing foreign table access 356
Transforming foreign tables into local tables 358
Creating a scalable nextval replacement 361
Building a sharding API 366
Talking to the right shard 368
Moving a shard to another server 371
Index 375