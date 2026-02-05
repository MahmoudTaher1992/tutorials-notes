# 34. Security Audit Profiling

## 34.1 Authentication Profiling
- 34.1.1 Authentication attempt metrics
- 34.1.1.1 Success rate
- 34.1.1.2 Failure rate
- 34.1.1.3 Failure reasons
- 34.1.2 Authentication latency
- 34.1.3 Authentication method analysis
- 34.1.3.1 Password authentication
- 34.1.3.2 Certificate authentication
- 34.1.3.3 LDAP/AD integration overhead
- 34.1.3.4 Kerberos authentication
- 34.1.3.5 OAuth/OIDC integration
- 34.1.4 Brute force detection
- 34.1.5 Account lockout patterns

## 34.2 Authorization Profiling
- 34.2.1 Permission check overhead
- 34.2.2 Role evaluation complexity
- 34.2.3 Row-level security impact
- 34.2.4 Column-level security impact
- 34.2.5 Dynamic data masking overhead
- 34.2.6 Policy evaluation caching

## 34.3 Audit Log Profiling
- 34.3.1 Audit log generation overhead
- 34.3.2 Audit log volume analysis
- 34.3.3 Audit log storage requirements
- 34.3.4 Audit granularity trade-offs
- 34.3.4.1 Statement-level auditing
- 34.3.4.2 Object-level auditing
- 34.3.4.3 Row-level auditing
- 34.3.5 Audit log query performance

## 34.4 Compliance Profiling
- 34.4.1 Data access pattern analysis
- 34.4.2 Sensitive data access tracking
- 34.4.3 Privilege usage analysis
- 34.4.4 Data export/extraction monitoring
- 34.4.5 Compliance report generation
