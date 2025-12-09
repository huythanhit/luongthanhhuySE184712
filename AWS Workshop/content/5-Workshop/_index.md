---
title: "Workshop"
weight: 5
chapter: false
pre: " <b> 5. </b> "
---


# Workshop — LearningHub (2HTD)

#### Overview

This workshop accompanies the 2HTD-LearningHub proposal and provides step-by-step labs to deploy and validate the project's main components: frontend hosted on Vercel, serverless backend with AWS Lambda + API Gateway, relational data stored in SQL Server on EC2 (private subnet), and media stored in Amazon S3. The labs focus on secure hybrid access patterns, VPC design, EC2 administration via AWS Systems Manager (SSM), presigned S3 uploads, Lambda-based APIs, and Cognito authentication.

Labs are short and focused; they can run in a compact test environment (single VPC) or in an expanded setup (cloud VPC + on-prem simulation) to demonstrate different network flows and NAT/egress trade-offs.

### Learning objectives

- Understand the LearningHub hybrid architecture (Vercel + Lambda + EC2 + S3).
- Provision VPCs and subnets, and design NAT / VPC endpoints to control egress costs.
- Deploy EC2 Windows + SQL Server Express and manage it securely using AWS Systems Manager (SSM).
- Configure S3 buckets and implement uploads using presigned URLs from the frontend.
- Deploy Lambda (Node.js) functions and expose them via API Gateway (HTTP API).
- Configure Amazon Cognito for authentication and test protected API flows.

### Project Architecture

The LearningHub system uses a frontend-hosted + serverless backend pattern with a Microsoft SQL Server running on an EC2 instance inside a private subnet for relational data. Key components:

- Frontend: Static or SSR Next.js app hosted on Vercel, serving the UI and calling APIs.
- API: Amazon API Gateway (HTTP API) forwarding requests to AWS Lambda (Node.js) for business logic.
- Storage: Amazon S3 for media storage; uploads use presigned URLs from the frontend.
- Database: Microsoft SQL Server on Amazon EC2 in a private subnet (accessed from Lambda via private networking or via approved routes).
- Authentication: Amazon Cognito issues tokens for frontend authentication and protects API endpoints.
- Network & Security: VPC, subnets, security groups, IAM roles, and VPC Endpoints for S3 to reduce egress; NAT Gateway for egress where required.
- Ops & Observability: AWS Systems Manager (SSM) for EC2 administration, CloudWatch for logs/metrics, and AWS Secrets Manager / Parameter Store for secrets.

<div style="max-width:100%;text-align:center;margin:1rem 0;">
	<img src="/images/architecture.png" alt="LearningHub architecture" style="max-width:100%;height:auto;" />
</div>

### Main Request / Data Flows

1. The user loads the frontend from Vercel; if authentication is required the frontend redirects to Cognito and receives an access token.
2. For media upload, the frontend requests a presigned URL from an API endpoint (API Gateway → Lambda), passing the user's token where required.
3. The Lambda function generates a presigned S3 URL using the SDK and returns it; the frontend uploads directly to S3 with the presigned URL.
4. After upload, the frontend may call a confirmation API (API Gateway → Lambda) to record metadata or trigger downstream processing.
5. Business requests (CRUD operations, user data) go through API Gateway → Lambda; Lambdas may query or update the SQL Server on EC2 over the private network or use S3 as an intermediary for large objects.
6. EC2 management tasks (SQL setup, patching) are performed via AWS Systems Manager (SSM Session Manager) without opening RDP/SSH to the internet.
7. To minimize egress costs when accessing S3 from inside the VPC, enable an S3 VPC Endpoint; for external package downloads or other internet egress, consider a NAT Gateway (cost trade-off) or use SSM + endpoints.

These flows map directly to the workshop labs: presigned S3 upload, S3 access from VPC (with endpoints), EC2 management via SSM, and Lambda APIs connecting to EC2/DB.

### AWS Services Used

| Category | Service |
|---|---|
| Compute | AWS Lambda (Function / Container), Amazon EC2 (Windows + SQL Server Express) |
| Storage | Amazon S3 |
| API | Amazon API Gateway (HTTP API) |
| Authentication & Security | Amazon Cognito, AWS IAM, AWS Secrets Manager |
| Monitoring | Amazon CloudWatch Logs & Metrics |
| Network | VPC, Subnets, NAT Gateway, Internet Gateway, VPC Endpoints |
| DNS | Amazon Route 53 |
| IaC / CI-CD | Terraform (or CDK), GitHub Actions |
| Ops & Backup | AWS Systems Manager (SSM), EBS Snapshots |

### Time & Cost Estimate

| Item | Detail |
|---|---|
| Time | 3–4 hours (short lab) |
| Level | Intermediate |
| Estimated Cost | Workshop: minimal (temporary lab resources); Full deployment (production): **≈ 60.00 USD / month** (see Proposal) |

Note: Workshop costs depend on runtime hours and resource choices. The full-system monthly estimate is available in the Proposal section.


### Lab index

1. [Workshop overview](5.1-Workshop-overview/)
2. [Prerequisite & environment setup](5.2-Prerequiste/)
3. [Integration Cognito + API Gateway](5.3-Cognito-api-gateway/)
4. [Lambda + API Gateway (Serverless API)](5.4-Lambda-api-gateway/)
5. [EC2 Windows + SQL Server (Private Subnet)](5.5-Ec2-PrivateSubnet/)
6.  [Cleanup](5.6-Cleanup/)

---


