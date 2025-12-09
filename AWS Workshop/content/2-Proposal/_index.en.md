---
title: "Proposal 2HTD-LearningHub"
linkTitle: "Proposal"
weight: 2
chapter: false
pre: " <b> 2. </b> "
---


## 1. Project Summary

2HTD-LearningHub is a web platform for studying, practice, exam creation and online testing. The goal is to provide a one-stop experience for students and instructors: question bank, practice exercises, mock exams and reporting.

The current release removes the live-class component; instead the product focuses on authoring (exam creation), submissions, automated grading and content distribution.

The architecture is hybrid: frontend hosted on Vercel; backend business logic runs on AWS Lambda (invoked via API Gateway); relational data is stored in SQL Server running on Amazon EC2 in a private subnet; media and documents are stored in Amazon S3.

The design emphasizes security and operability: network isolation with VPC/subnets, access control with IAM and Cognito, observability via CloudWatch, and EC2 administration through SSM rather than RDP.

## 2. Problem Statement

- Learners and instructors currently rely on multiple disconnected tools (quiz builders, video calls, storage), causing fragmented workflows and management overhead.
- Instructors need more efficient, controlled ways to author, review and distribute exam content.
- Systems can degrade during peak events (mock exams) and struggle to keep latency low for all users.
- Real-time notifications and reporting are limited for course management and student tracking.
- Exam content and user data must be protected against leaks and abuse.

## 3. Solution & Architecture

The solution maps to the architecture diagram and includes:

- Frontend: Vercel (hosting SPA/static), DNS managed in Route 53.
- Authentication: Amazon Cognito for user pools (signup/login) and token-based authentication.
- API layer: Amazon API Gateway (HTTP API) as the public endpoint, routing to AWS Lambda (proxy).
- Backend: AWS Lambda (Node.js) for business logic.
- Database: Amazon EC2 (Windows + SQL Server Express) in a private subnet as the primary datastore for users, courses, quizzes and results.
- Storage: Amazon S3 for media and large files; the database stores metadata and S3 links.
- Network: VPC with public/private subnets, NAT Gateway and Internet Gateway; EC2 sits in private subnet; Lambda may run in VPC when DB access is required.
- Operations & Security: IAM roles, CloudWatch logs, and AWS Systems Manager (SSM) for accessing EC2 without RDP.


### Architecture Diagram

<div style="text-align: center; margin: 20px 0;">
  <img src="/images/architecture.png" alt="Architecture Diagram - 2HTD-LearningHub System Architecture" style="max-width: 90%; height: auto; border: 1px solid #ddd; border-radius: 6px;" />
  <p><em>Figure 1: 2HTD-LearningHub — Frontend (Vercel), API Gateway → Lambda, EC2 (SQL Server) in private subnet, S3 for storage</em></p>
</div>

### AWS Services Used

- Amazon EC2 (Windows + SQL Server Express): Run SQL Server (SQLEXPRESS) as the primary database for the system (users, courses, quizzes, tests, results).

- Amazon S3: Store lecture files, videos, PDFs and images; the database stores metadata and S3 links.

- AWS Lambda: Run backend Node.js processes (API handlers, background tasks).

- Amazon API Gateway (HTTP API): Public HTTPS endpoint for the frontend (Vercel) to call into the backend.

- Amazon Cognito: User sign-up / sign-in, email verification, provides AccessToken/IdToken.

- AWS IAM: Permissions for Lambda to access S3, EC2, SSM.

- Amazon CloudWatch Logs: Store logs from Lambda and API Gateway for debugging and monitoring.

- AWS Systems Manager (SSM): Session Manager to access EC2 without RDP and run PowerShell/sqlcmd.

- Amazon Route 53: DNS for pointing to Vercel deployment.

- VPC, Subnets, NAT Gateway, Internet Gateway: Network isolation and secure access to resources.

### Component Design

- VPC: learninghub-vpc with public & private subnets. EC2 DB in private subnet; NAT Gateway for outbound from private.
- EC2 (DB): Windows Server + SQL Server Express on EC2 instance (private), storing primary data. Backups via snapshots and maintenance policies.
- Lambda (Backend): Handle API requests from API Gateway; may be placed in VPC for DB access.
- API Gateway: HTTP API routing to Lambda (proxy). Enable CORS for the frontend.
- S3: Store files and provide presigned URLs for uploads/downloads.
- Cognito: User Pool for authentication and email/OTP verification.
- IAM & Roles: following least-privilege principle.
- SSM: Use Session Manager to connect to EC2, run sqlcmd or PowerShell for DB administration.
- CloudWatch: Collect logs and metrics; dashboards and alerts for operations.


## 4. Technical Implementation

1) IaC & Provisioning: Use Terraform or AWS CDK to provision VPC, subnets, NAT/IGW, EC2 (Windows + SQL Server), S3 bucket, API Gateway, Lambda, Cognito, IAM roles, SSM and CloudWatch.
2) CI/CD: GitHub Actions to build & deploy frontend (Vercel), deploy Lambda packages/containers, and apply IaC changes to staging/production.
3) API & Data: API Gateway (HTTP API) → Lambda (Node.js) handles CRUD for courses/quizzes/tests; Lambda connects to EC2 SQL Server on the private network. EC2 database is managed via SSM for migrations and backups.
4) File Storage: Teacher upload flow — backend issues presigned URL → frontend uploads directly to S3; DB stores metadata and link.
5) Security & Operations: Least-privilege IAM, KMS encryption as needed, Secrets Manager/SSM Parameter Store for credentials; CloudWatch logs & alarms, backup snapshots for EC2, and runbooks for incident response.
6) AWS Systems Manager (SSM): Use Session Manager to access and administer EC2 instances securely (run PowerShell/sqlcmd for migrations, connectivity checks, backups/restores and troubleshooting) without opening extra network ports.

## 5. Timeline & Milestones

- Week 1-2: Detailed design, data model and IaC scaffold; provision EC2 DB.
- Week 3-4: Implement Cognito, API Gateway + Lambda, test DB connectivity via SSM.
- Week 5-6: Implement authoring, submission and grading; integrate S3 upload flow.
- Week 7: System testing, backups and security review.
- Week 8: Load testing, observability dashboards, documentation and handover.


## 6. Budget Estimation

| AWS Service | Key Billing Factors | Estimated Cost (USD) |
|---|---|---:|
| EC2 + EBS (Database) | Windows + SQL Server Express (instance + EBS storage, snapshots) | 23.00 |
| Amazon S3 | Storage (GB) and requests (PUT/GET) | 1.30 |
| AWS Lambda | Invocations and compute (low starter estimate) | 1.00 |
| Amazon API Gateway (HTTP API) | Request charges (per-request pricing) | 2.50 |
| Amazon CloudWatch Logs | Log ingestion & storage for Lambda/API | 1.50 |
| NAT Gateway | Hourly + data processing (egress) — often the largest cost driver | 30.00 |
| Route 53 | Hosted zone + DNS queries | 1.00 |
| Amazon Cognito + IAM + SSM | Authentication, IAM operations, SSM Session Manager (no direct charge) | 0.00 |
| **TOTAL** |  | **≈ 60.00** |

Note: Actual costs depend on traffic, region and configuration; costs can be reduced further by turning off dev/test environments or optimizing egress.

## 7. Risk Assessment

| Risk | Impact | Mitigation |
|---|---|---|
| EC2 / egress costs | High | Monitor usage, choose right instance size, schedule/auto-stop dev instances.
| Data leaks / credentials exposure | Very High | Use Secrets Manager, KMS, least-privilege IAM, periodic pentests.
| Lambda ↔ EC2 connectivity issues | Medium | Proper security groups, test in staging, consider a proxy if needed.
| DB backup/recovery failures | High | Automated snapshots, tested restore procedures.

## 8. Expected Outcomes

- An integrated platform for studying, practice, exam creation and online testing that reduces tool fragmentation for learners and instructors.
- Automation of authoring, distribution and grading to improve instructor productivity.
- A stable, secure, and scalable infrastructure; EC2-hosted SQL Server ensures compatibility with existing database requirements.
- S3-based storage for large files to reduce DB load and simplify backups; Lambda reduces operational overhead for business logic.
- Observability (CloudWatch) and logging to support troubleshooting and performance monitoring.


