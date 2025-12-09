---
title : "Introduction"

weight : 1 
chapter : false
pre : " <b> 5.1. </b> "
---
#### Workshop Overview — LearningHub (2HTD)

This workshop guides participants to deploy and validate the core components of 2HTD-LearningHub as described in the proposal: frontend hosted on Vercel, backend serverless with AWS Lambda + API Gateway, relational data on SQL Server running in EC2 (private subnet), and media stored in S3. The workshop focuses on hands-on tasks: provisioning network (VPC/subnets), configuring EC2 + SQL Server, setting up S3 uploads with presigned URLs, deploying Lambda + API Gateway, configuring Cognito, and accessing EC2 securely via AWS Systems Manager (SSM).

The workshop uses a simple test environment (optionally two VPCs: one cloud VPC for LearningHub resources and an on-prem simulation VPC) to demonstrate network flows and secure access.

<div style="text-align: center; margin: 20px 0;">
	<img src="/images/5-Workshop/5.1-Workshop-overview/diagram1.png" alt="Workshop Overview Diagram" style="max-width: 90%; height: auto; border: 1px solid #ddd; border-radius: 6px;" />
	<p><em>Figure: Workshop diagram — VPC, EC2 (SQL Server), S3, Lambda, API Gateway, Cognito, and SSM</em></p>
</div>

### Learning Objectives

- Understand LearningHub's hybrid architecture (Vercel + Lambda + EC2 + S3).
- Provision VPCs, subnets and configure NAT / endpoints to optimize egress cost.
- Deploy EC2 Windows + SQL Server Express and perform basic administration via SSM.
- Configure an S3 bucket and perform uploads using presigned URLs from the frontend.
- Deploy a Lambda (Node.js) and configure API Gateway (HTTP API) to invoke it.
- Configure Amazon Cognito User Pool and test authenticated API flows.

### Core Labs

1. Basic provisioning: create a VPC with public/private subnets, an Internet Gateway and NAT (or NAT instance for labs).
2. Launch an EC2 Windows instance, install SQL Server Express (or use a prebuilt AMI), and configure security groups for private access.
3. Configure SSM Agent and access EC2 with Session Manager (no public RDP).
4. Create a test S3 bucket, attach an IAM role to Lambda, and test uploads with presigned URLs.
5. Deploy a simple Lambda function (Node.js) and wire it to API Gateway (HTTP API).
6. Configure a Cognito User Pool, register a test user, and call protected APIs.
7. Observability: enable CloudWatch Logs for Lambda, inspect logs, and create a basic dashboard.

### References

- Architecture diagram: `/images/architecture.png` (proposal details)
- Sample code for presigned URL, Lambda handler, and Terraform/CDK snippets will be provided in the workshop repo.

---

If you prefer, I can condense the labs into 4 main exercises, or expand each lab into a step-by-step checklist (commands, IAM policies, Terraform snippets).