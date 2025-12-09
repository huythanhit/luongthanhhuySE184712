 
---
title: "Prerequiste"
weight: 2
chapter: false
pre: " <b> 5.2. </b> "
---

#### Overview
This page lists the prerequisites to run the workshop and to follow the hands-on exercises for the 2HTD-LearningHub project. The content below covers required AWS permissions, recommended region, AWS services used, a minimal workshop IAM policy example, and PowerShell steps for Windows users.

#### AWS account & permissions
- An AWS account with permission to create and manage resources used by the workshop (CloudFormation, EC2, VPC, S3, Lambda, API Gateway, Cognito, IAM, CloudWatch, SSM).
- For workshops: use a sandbox account and create an IAM user for yourself. Assign `AdministratorAccess` if you prefer a frictionless experience during the lab.
- For real environments: follow the least-privilege principle. Use the minimal IAM policy below as a starting point and scope resources (ARNs) before applying in production.

Quick verification after configuring the AWS CLI:

```powershell
aws configure                # enter Access Key, Secret, default region (e.g. us-east-1) and output format
aws sts get-caller-identity  # verify credentials and account
```

#### Region
- Use `us-east-1` (N. Virginia) for the workshop demos and CloudFormation examples. If you choose another region, adjust resource names and template URLs accordingly.

#### Required AWS services
- Amazon EC2 (Windows + SQL Server as the project DB)
- Amazon S3 (media and artifact storage)
- AWS Lambda (backend functions)
- Amazon API Gateway (HTTP API)
- Amazon Cognito (authentication)
- AWS IAM (roles and policies)
- Amazon CloudWatch (logs & metrics)
- AWS Systems Manager (Session Manager for EC2 access)
- AWS CloudFormation (or Terraform/CDK) for provisioning
- Route 53 (optional for DNS during demos)

#### Local tools (recommended)
- Git (clone repository)
- Node.js (LTS, e.g. 18+) and `npm` (build Lambda code)
- AWS CLI v2 (configure with `aws configure`)
- AWS Session Manager plugin (optional, to enable `aws ssm start-session` integration)
- SQL client: SQL Server Management Studio (SSMS) or Azure Data Studio (connect to SQL Server on EC2)
- PowerShell (Windows) or a POSIX shell (Linux/macOS)
- Docker (optional — only if building containerized Lambdas)

#### Minimal IAM policy (workshop example)
This example covers common actions used by provisioning templates and deployment flows in this workshop. Review and scope resource ARNs before using in production.

```json
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": [
				"cloudformation:CreateStack",
				"cloudformation:DeleteStack",
				"cloudformation:DescribeStacks",
				"cloudformation:ListStacks",
				"s3:CreateBucket",
				"s3:PutObject",
				"s3:GetObject",
				"s3:DeleteObject",
				"ec2:Describe*",
				"ec2:CreateTags",
				"ec2:DeleteTags",
				"lambda:CreateFunction",
				"lambda:DeleteFunction",
				"iam:PassRole",
				"apigateway:POST",
				"cognito-idp:CreateUserPool",
				"cognito-idp:DeleteUserPool",
				"ssm:StartSession",
				"ssm:SendCommand",
				"logs:CreateLogGroup",
				"logs:CreateLogStream",
				"logs:PutLogEvents"
			],
			"Resource": "*"
		}
	]
}
```

Notes:
- The policy above is suitable for a lab/sandbox account. Replace `"Resource": "*"` with specific ARNs to narrow scope in production.
- Some CloudFormation templates create IAM roles and require `CAPABILITY_NAMED_IAM` when deploying; the `iam:PassRole` action is commonly necessary.

#### PowerShell (Windows) quick-start
Use the following PowerShell snippets to install the AWS CLI, configure credentials, verify access, and run common workshop commands.

Install AWS CLI v2 (download & install MSI):

```powershell
# Download installer and run
Invoke-WebRequest -Uri "https://awscli.amazonaws.com/AWSCLIV2.msi" -OutFile "$env:TEMP\AWSCLIV2.msi"
Start-Process msiexec.exe -Wait -ArgumentList "/i $env:TEMP\AWSCLIV2.msi /qn"
```

Configure AWS CLI and verify identity:

```powershell
aws configure
aws sts get-caller-identity
```

Start an SSM Session (example):

```powershell
# Replace with your EC2 instance id
$instanceId = 'i-0123456789abcdef0'
aws ssm start-session --target $instanceId
```

Deploy a CloudFormation template:

```powershell
aws cloudformation deploy --template-file .\cloudformation\stack.yaml --stack-name MyWorkshopStack --capabilities CAPABILITY_NAMED_IAM
```

Upload artifacts to S3 (example):

```powershell
aws s3 mb s3://my-workshop-artifacts-$(Get-Random -Maximum 99999)
aws s3 cp .\lambda\package.zip s3://my-workshop-artifacts-12345/
```

#### Local setup steps (recap)
1. Install the tools listed above.
2. Configure the AWS CLI with your IAM user: `aws configure` (set default region to `us-east-1`).
3. Verify access: `aws sts get-caller-identity`.
4. (Optional) Create an S3 bucket to store deployment artifacts.

#### Notes on EC2 & SSM
- The project stores relational data on an EC2 instance running SQL Server in a private subnet. For administration we rely on AWS Systems Manager (SSM) Session Manager instead of RDP. Ensure your IAM user has SSM permissions (or use AdministratorAccess in a lab account).

#### Clean-up guidance
- If you deploy using CloudFormation or scripts, delete the stack and any created S3 buckets when finished to avoid ongoing charges.

If you want, I can scope the minimal IAM policy to exact ARNs for your account, or produce a PowerShell script that automates AWS CLI install + `aws configure` with prompts.