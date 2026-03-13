# Data Observability Complete Study Guide - Part 10: OpenMetadata & Apache Atlas

## 19.0 OpenMetadata

### 19.1 Architecture
#### 19.1.1 Core Services
- 19.1.1.1 OpenMetadata server — Spring Boot — REST API — metadata store — MySQL/PostgreSQL backend
  - 19.1.1.1.1 Entity model — Table / Pipeline / Dashboard / Topic / ML Model / Container
  - 19.1.1.1.2 Change events — every metadata change emits event — audit log — activity feed
- 19.1.1.2 Ingestion framework — Python-based — modular — same connector library as DataHub
  - 19.1.1.2.1 Workflow types — metadata / usage / lineage / profiler / data quality — separate runs
  - 19.1.1.2.2 Profiler workflow — runs SQL profiling queries — DatasetProfile — column stats
- 19.1.1.3 Search — Elasticsearch — entity search — lineage graph — hybrid metadata store

#### 19.1.2 Data Quality in OpenMetadata
- 19.1.2.1 Test suites — group of data quality tests per table — scheduled execution
  - 19.1.2.1.1 Table tests — tableRowCountToEqual / tableRowCountToBeBetween / tableCustomSQLQuery
  - 19.1.2.1.2 Column tests — columnValuesToBeNotNull / columnValuesToBeUnique / columnValuesMean
  - 19.1.2.1.3 Custom SQL test — arbitrary SQL — SELECT count(*) WHERE fail_condition → result
- 19.1.2.2 Test result history — per-test trend — pass/fail over time — detect regression
  - 19.1.2.2.1 Incident manager — auto-create incident on test failure — assign owner — track
  - 19.1.2.2.2 Notification rules — webhook / Slack / email on failure — configurable per suite

### 19.2 Lineage & Collaboration
#### 19.2.1 Lineage Support
- 19.2.1.1 Automatic lineage — dbt / Spark / Airflow / SQL parsers — multi-source aggregation
  - 19.2.1.1.1 Column-level lineage — dbt manifest import — field-to-field tracing — complete
  - 19.2.1.1.2 Pipeline lineage — Airflow operator mapping → dataset in/out — process lineage
- 19.2.1.2 Manual lineage — add lineage edges in UI — fill gaps where automated fails
  - 19.2.1.2.1 Bidirectional — add upstream + downstream — both sides captured — complete graph

#### 19.2.2 Collaboration Features
- 19.2.2.1 Conversations — per entity discussions — @mention teammates — context-aware chat
  - 19.2.2.1.1 Tasks — request description / ownership / review — assigned + tracked in UI
- 19.2.2.2 Data insights — usage analytics — top tables / top users / data coverage score
  - 19.2.2.2.1 Coverage score — % of tables with description + owner + tier — governance KPI
- 19.2.2.3 Announcements — broadcast to all users — deprecation / migration / outage notices

---

## 20.0 Apache Atlas

### 20.1 Architecture
#### 20.1.1 Core Components
- 20.1.1.1 Type system — define entity types + relationships + classifications — extensible model
  - 20.1.1.1.1 Entity — hive_table / hive_column / spark_process / kafka_topic — predefined types
  - 20.1.1.1.2 Relationship — hive_table_columns — hive_process_dataset — typed edges
  - 20.1.1.1.3 Business attribute — custom metadata — attach to entities — key-value extensible
- 20.1.1.2 Repository — JanusGraph — graph DB — stores entities + relationships — Elasticsearch index
  - 20.1.1.2.1 JanusGraph + Cassandra — production backend — scalable — Hadoop ecosystem native
  - 20.1.1.2.2 Embedded HBase — lightweight — single-node dev — not for production scale
- 20.1.1.3 Hooks — process-side instrumentation — emit events to Atlas Kafka topic — auto lineage
  - 20.1.1.3.1 HiveHook — intercept Hive queries — emit pre/post execute events — DDL + DML
  - 20.1.1.3.2 SparkAtlasEventTracker — Spark listener — track dataset read/write — lineage
  - 20.1.1.3.3 StormAtlasHook / Sqoop hook — topology + job lineage — broad ecosystem coverage

#### 20.1.2 Classifications & Propagation
- 20.1.2.1 Classification — tag applied to entity/attribute — PII / Confidential / Finance
  - 20.1.2.1.1 Attribute-level classification — column-level tag — fine-grained sensitivity
  - 20.1.2.1.2 Auto-classification — business rules on column name patterns — AI-assisted
- 20.1.2.2 Classification propagation — lineage-aware — source classification flows downstream
  - 20.1.2.2.1 Propagation rules — PROPAGATE / OWNER / NONE — control spread — per classification
  - 20.1.2.2.2 Blocking propagation — stop PII from propagating to anonymized table — explicit
- 20.1.2.3 Ranger integration — Atlas tags → Ranger policies — tag-based access control — ABAC
  - 20.1.2.3.1 Tag-based masking — Atlas: column = PII → Ranger: mask for non-PII-readers — auto
  - 20.1.2.3.2 Row-level filtering — Atlas classification drives Ranger row filter policy — dynamic

### 20.2 Atlas Lineage
#### 20.2.1 Lineage Features
- 20.2.1.1 Process entity — links input datasets to output datasets — represents transformation
  - 20.2.1.1.1 hive_process — inputs: [table_A] → outputs: [table_B] — Hive CTAS captured
  - 20.2.1.1.2 Spark process — SparkApplication entity + SparkProcess — fine-grained Spark lineage
- 20.2.1.2 Lineage UI — upstream / downstream view — expand hops — impact traversal
  - 20.2.1.2.1 Lineage depth control — expand N hops — collapse irrelevant branches — usable
