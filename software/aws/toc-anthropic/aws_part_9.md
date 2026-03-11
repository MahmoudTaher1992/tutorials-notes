# AWS Complete Study Guide - Part 9: DevOps, Cost, Compliance & Edge (Phase 1 — Ideal)

## 12.0 DevOps & Infrastructure as Code

### 12.1 CloudFormation
#### 12.1.1 Template Anatomy
- 12.1.1.1 Sections — AWSTemplateFormatVersion, Description, Parameters, Mappings, Conditions, Resources, Outputs
  - 12.1.1.1.1 Resources — only required section — up to 500 resources per stack
  - 12.1.1.1.2 Outputs — cross-stack references — Export name must be unique per region
- 12.1.1.2 Intrinsic functions — Ref, Fn::GetAtt, Fn::Sub, Fn::If, Fn::Join, Fn::Select
  - 12.1.1.2.1 Fn::Sub — string interpolation — ${AWS::AccountId}, ${AWS::Region}
  - 12.1.1.2.2 Fn::GetAtt — resource attribute — not available until resource created
- 12.1.1.3 Pseudo parameters — AWS::AccountId, AWS::Region, AWS::StackName, AWS::NoValue

#### 12.1.2 Stack Operations
- 12.1.2.1 Change sets — preview changes — identify replacements before apply
  - 12.1.2.1.1 Physical replacement — RequiresReplacement → new resource + delete old
  - 12.1.2.1.2 Execute change set — atomic — rollback on failure by default
- 12.1.2.2 Drift detection — compare live config vs. template — MODIFIED/DELETED/NOT_CHECKED
- 12.1.2.3 Stack policies — prevent accidental updates to critical resources (DB, IAM)
- 12.1.2.4 Stack sets — deploy across multiple accounts/regions simultaneously
  - 12.1.2.4.1 StackSet permissions — service-managed vs. self-managed
  - 12.1.2.4.2 Deployment order — specify order, failure tolerance, max concurrent

#### 12.1.3 CloudFormation Advanced Features
- 12.1.3.1 Custom resources — Lambda-backed — provision non-AWS resources
  - 12.1.3.1.1 ResponseURL — pre-signed S3 URL — must send success/failure
- 12.1.3.2 Macros — Lambda-based template transforms — custom DSL/expansion
- 12.1.3.3 Nested stacks — reference sub-stacks — modular templates
  - 12.1.3.3.1 Cross-stack vs. nested — exports persist; nested destroyed with parent

### 12.2 AWS CDK
#### 12.2.1 CDK Architecture
- 12.2.1.1 Constructs — L1 (raw CFN), L2 (opinionated defaults), L3 (patterns)
  - 12.2.1.1.1 L2 defaults — secure-by-default — TLS enabled, logging on
  - 12.2.1.1.2 L3 constructs — ApplicationLoadBalancedFargateService pattern
- 12.2.1.2 App → Stack → Construct tree — synthesizes to CloudFormation template
  - 12.2.1.2.1 cdk synth — generate template — validate before deploy
  - 12.2.1.2.2 cdk diff — compare deployed vs. local — like CFN change set
- 12.2.1.3 CDK Pipelines — self-mutating pipeline — deploy CDK apps via CodePipeline
  - 12.2.1.3.1 Stages — pre/post checks — manual approval gates

### 12.3 CI/CD (CodePipeline / CodeBuild / CodeDeploy)
#### 12.3.1 CodePipeline
- 12.3.1.1 Stages → Actions — sequential/parallel — Source/Build/Test/Deploy/Approval
  - 12.3.1.1.1 V2 pipelines — variable-based — git tags, branch conditions
  - 12.3.1.1.2 Execution modes — superseded (default) vs. queued vs. parallel
- 12.3.1.2 Artifact store — S3 bucket — encrypted — versioned per execution

#### 12.3.2 CodeBuild
- 12.3.2.1 Buildspec.yml — phases: install/pre_build/build/post_build
  - 12.3.2.1.1 Batch builds — fan-out parallel build matrix — e.g., multi-arch images
  - 12.3.2.1.2 Local builds — CodeBuild local agent — Docker-based local testing
- 12.3.2.2 Compute types — Small/Medium/Large/X-Large/2X-Large — GPU option
- 12.3.2.3 VPC integration — private subnets — access internal resources

#### 12.3.3 CodeDeploy
- 12.3.3.1 Deployment types — In-place (EC2), Blue/Green (EC2/Lambda/ECS)
  - 12.3.3.1.1 Deployment groups — EC2 tags or ASG — lifecycle hooks
  - 12.3.3.1.2 Deployment configurations — AllAtOnce, HalfAtATime, OneAtATime, custom%
- 12.3.3.2 AppSpec file — hooks — BeforeInstall/AfterInstall/ApplicationStart/ValidateService
  - 12.3.3.2.1 Lambda AppSpec — BeforeAllowTraffic/AfterAllowTraffic — canary validation

### 12.4 Blue/Green & Canary Deployments
#### 12.4.1 Blue/Green Strategies
- 12.4.1.1 DNS cutover — Route 53 weighted routing — instant rollback
  - 12.4.1.1.1 Blue keeps running — warm rollback — no cold start
- 12.4.1.2 ALB weighted target groups — shift % over time — fine-grained
  - 12.4.1.2.1 Canary analysis — CloudWatch metrics check between shift increments

---

## 13.0 Cost Management & FinOps

### 13.1 Pricing Models
#### 13.1.1 On-Demand vs. Reserved vs. Spot
- 13.1.1.1 On-Demand — per-second billing (Linux) — no commitment
- 13.1.1.2 Reserved Instances — 1yr/3yr — All/Partial/No Upfront — up to 72% savings
  - 13.1.1.2.1 Standard RI — fixed size, region, OS — sellable on Marketplace
  - 13.1.1.2.2 Convertible RI — exchange for different instance — lower discount
- 13.1.1.3 Savings Plans — flexible — EC2 Instance SP, Compute SP, SageMaker SP
  - 13.1.1.3.1 Compute SP — applies to EC2/Fargate/Lambda — most flexible

#### 13.1.2 Spot Instance Savings
- 13.1.2.1 Interruption-tolerant workloads — batch, ML training, CI/CD
- 13.1.2.2 Spot instance diversification — 10+ pools — <5% interruption rate target

### 13.2 Cost Allocation & Tagging
#### 13.2.1 Tagging Strategy
- 13.2.1.1 Required tags — team, environment, project, cost-center — enforce via SCP
  - 13.2.1.1.1 Tag policy enforcement — AWS Config rule — non-compliant resource alert
- 13.2.1.2 Cost allocation tags — activate in Billing console — appear in CUR

#### 13.2.2 Cost and Usage Report (CUR)
- 13.2.2.1 Most granular billing data — hourly/daily/monthly — delivered to S3
  - 13.2.2.1.1 Parquet format — Athena query — cost analysis SQL
  - 13.2.2.1.2 Resource-level — individual EC2 instance hourly usage
- 13.2.2.2 CUR 2.0 — replacement — Data Exports in Billing and Cost Management

### 13.3 Rightsizing & Compute Optimizer
#### 13.3.1 AWS Compute Optimizer
- 13.3.1.1 ML-based recommendations — EC2, ASG, Lambda, EBS, ECS/Fargate
  - 13.3.1.1.1 Risk assessment — over-provisioned/under-provisioned classification
  - 13.3.1.1.2 Enhanced infrastructure metrics — 3-month lookback — opt-in paid tier

---

## 14.0 Compliance & Governance

### 14.1 AWS Organizations & SCPs
#### 14.1.1 Organizations Structure
- 14.1.1.1 Management account → OUs → Member accounts hierarchy
  - 14.1.1.1.1 Maximum depth — 5 levels of OUs nested
- 14.1.1.2 SCPs — deny guardrails — preventive controls
  - 14.1.1.2.1 Deny leaving organization — prevent rogue account detachment
  - 14.1.1.2.2 Deny root user actions — enforce role-based access

### 14.2 AWS Control Tower
#### 14.2.1 Landing Zone
- 14.2.1.1 Account Factory — vending machine — standard account baseline
  - 14.2.1.1.1 Account Factory for Terraform (AFT) — GitOps account provisioning
- 14.2.1.2 Controls (Guardrails) — preventive (SCP) + detective (Config) + proactive
  - 14.2.1.2.1 Mandatory controls — cannot disable — baseline security
  - 14.2.1.2.2 Elective controls — opt-in — 300+ available

### 14.3 Audit Trail (CloudTrail)
#### 14.3.1 CloudTrail Events
- 14.3.1.1 Management events — control plane — CreateVPC, AssumeRole, RunInstances
  - 14.3.1.1.1 Read vs. write events — filter to write-only — reduce volume
- 14.3.1.2 Data events — S3 object access, Lambda invokes, DynamoDB operations
  - 14.3.1.2.1 Selector-based filtering — resource ARN, event name pattern
- 14.3.1.3 Insights events — anomalous API call rates — ML-detected
  - 14.3.1.3.1 Baseline established over 7 days — deviation triggers Insight

#### 14.3.2 Trail Configuration
- 14.3.2.1 Organization trail — single trail captures all member accounts
  - 14.3.2.1.1 Log file integrity validation — SHA-256 + RSA signing — tamper detection
  - 14.3.2.1.2 S3 + CloudWatch Logs dual delivery — real-time + archive

### 14.4 AWS Config
#### 14.4.1 Config Rules
- 14.4.1.1 Managed rules — 200+ pre-built — s3-bucket-public-read-prohibited
  - 14.4.1.1.1 Evaluation trigger — config change, periodic, or hybrid
- 14.4.1.2 Custom rules — Lambda-backed — evaluate any resource config
- 14.4.1.3 Conformance packs — YAML — bundle multiple rules + remediation actions
  - 14.4.1.3.1 AWS Security Hub integration — Config findings → Hub

---

## 15.0 Edge & Hybrid Cloud

### 15.1 Multi-Region Architecture
#### 15.1.1 Active-Active vs. Active-Passive
- 15.1.1.1 Active-active — traffic in both regions — Global Accelerator routing
  - 15.1.1.1.1 DynamoDB Global Tables — multi-master — conflict resolution (last write wins)
  - 15.1.1.1.2 Aurora Global Database — 1s replication — secondary promotion in <1min
- 15.1.1.2 Active-passive — primary + standby — Route 53 failover routing policy
  - 15.1.1.2.1 RPO vs. RTO matrix — Backup/Restore (hours/days) → Active-Active (<1min/s)

### 15.2 AWS Outposts
#### 15.2.1 Outposts Architecture
- 15.2.1.1 AWS-managed rack in customer DC — extends VPC to on-prem
  - 15.2.1.1.1 Local gateway (LGW) — route between Outpost and on-prem network
  - 15.2.1.1.2 Service link — private connectivity to AWS region — AWS managed
- 15.2.1.2 Available services — EC2, ECS, EKS, RDS, ElastiCache, ALB, S3 on Outposts

### 15.3 AWS Global Accelerator
#### 15.3.1 Anycast Routing
- 15.3.1.1 Two static anycast IPs — edge-to-backbone routing — 60% better tail latency
  - 15.3.1.1.1 Traffic dials — per endpoint group — gradual regional shift
  - 15.3.1.1.2 Client affinity — source IP stickiness — 5-minute window default
- 15.3.1.2 Endpoint types — ALB, NLB, EC2, Elastic IP — weighted routing

### 15.4 Disaster Recovery Patterns
#### 15.4.1 DR Strategies (AWS Well-Architected)
- 15.4.1.1 Backup & Restore — RTO hours, RPO hours — cheapest — S3 + AWS Backup
- 15.4.1.2 Pilot Light — minimal standby — core infra running — RTO hours/minutes
  - 15.4.1.2.1 AMI replication cross-region — quick scale-out on failover
- 15.4.1.3 Warm Standby — scaled-down active — RTO minutes — Route 53 failover
- 15.4.1.4 Multi-Region Active-Active — RTO near-zero — highest cost
  - 15.4.1.4.1 Data synchronization latency — replication lag = RPO minimum
