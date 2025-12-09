---
title: "EC2 (Private Subnet) — Windows + SQL Server"
weight: 5
chapter: false
pre : " <b> 5.5. </b> "
---


Overview

This lab covers deploying and operating a Windows EC2 instance running SQL Server Express in a private subnet designed for internal-only database access. The document focuses on network design (VPC, route tables, NAT, VPC endpoints), secure administration via AWS Systems Manager (SSM), SQL Server silent installation and hardening, backup/restore (EBS snapshots and SQL backups to S3), monitoring, and production-ready operational practices.

Prerequisites

- AWS account with permissions to create VPCs, subnets, route tables, NAT Gateways, EC2, IAM roles, Systems Manager, EBS, and S3.
- AWS CLI v2 or Console access and basic familiarity with EC2, VPC and IAM concepts.
- An existing VPC or permission to create one for the lab.

Learning objectives

- Design a VPC with public and private subnets and correct routing for private DB instances.
- Launch a Windows EC2 instance in private subnets and configure it securely for SQL Server.
- Use AWS Systems Manager (Session Manager / Run Command / Patch Manager) for administration without exposing RDP.
- Implement backups (EBS snapshots and SQL backups), monitoring, and basic hardening.

Network & VPC design

- Recommended subnet layout:
   - Public subnets: NAT Gateway, load balancers, bastion (if used).
   - Private subnets: database instances, application services (Lambda or ECS tasks in private subnets).
   - At least two AZs with private subnets for resilience.

- Route tables:
   - Public route table: route 0.0.0.0/0 -> Internet Gateway (IGW).
   - Private route table: route 0.0.0.0/0 -> NAT Gateway (for OS updates/outbound), or no NAT if using SSM/VPC endpoints for patching.

- VPC Endpoints:
   - Add Interface endpoints for `com.amazonaws.<region>.ssm`, `com.amazonaws.<region>.ec2messages`, `com.amazonaws.<region>.ssmmessages` to allow SSM traffic without Internet.
   - Consider Gateway endpoint for S3 if you push backups to S3 (reduces public egress).

Security groups & NACLs

- Security Group for SQL Server (db-sg):
   - Inbound: TCP 1433 from application subnets/SGs only (use Security Group IDs for source when possible).
   - Outbound: restrict as needed; at minimum allow response traffic.

- Management Security Group (mgmt-sg):
   - Allow SSM related traffic (SSM uses agent outbound to AWS endpoints; with VPC endpoints you don't need IGW/NAT for SSM).

- Network ACLs: keep default permissive rules or implement stateless filters if required by policy; Security Groups are primary control.

IAM & instance profile

- Create an IAM role for EC2 with the following managed policy to enable SSM:

   - `AmazonSSMManagedInstanceCore`

- Additional policies (add least privilege scope):
   - Permission to create & describe EBS snapshots if instance will trigger snapshots: `ec2:CreateSnapshot`, `ec2:DescribeVolumes`, etc.
   - Permission to upload backups to S3 if using instance-based uploads (consider using a separate S3 role/policy limited to a prefix).

Instance type, storage, and AMI choices

- Instance type: choose based on SQL Server workloads (t3.medium or t3.large for light dev/test; r5/ m5 for heavier loads). For production, consider dedicated RDS or EC2 with provisioned IOPS.
- Storage:
   - Separate volumes: OS (C:) and Data (E: or D:) volumes. Put SQL Data, Logs, TempDB on separate EBS volumes for performance and snapshot granularity.
   - Use gp3 or io2 for consistent IOPS depending on workload.
   - Enable EBS encryption (KMS) for sensitive data.

Windows & SQL Server installation (automation)

- Install via SSM Run Command or using a pre-baked AMI with SQL Server/agents installed.
- Example PowerShell sequence (SSM Run Command or Session Manager):

PowerShell (on instance) - silent install example for SQL Server Express:

```powershell
# Download installer
$url = "https://download.microsoft.com/.../SQLEXPR_x64_ENU.exe"
Invoke-WebRequest -Uri $url -OutFile C:\Temp\sqlexpr.exe

# Create configuration file (simple example)
$config = @"
[OPTIONS]
ACTION=Install
FEATURES=SQLENGINE
INSTANCENAME=SQLEXPRESS
SECURITYMODE=SQL
SAPWD="P@ssw0rd"
SQLSVCACCOUNT="NT AUTHORITY\SYSTEM"
TCPENABLED=1
NPENABLED=0
"@
$config | Out-File C:\Temp\ConfigurationFile.ini -Encoding ascii

# Run silent installer
& C:\Temp\sqlexpr.exe /Q /ACTION=Install /IACCEPTSQLSERVERLICENSETERMS /ConfigurationFile=C:\Temp\ConfigurationFile.ini
```

- After install, enable TCP/IP protocol in SQL Server Configuration Manager (can be scripted via PowerShell/registry) and restart SQL Server service.
- Configure SQL Server Mixed Mode if you need SQL authentication; create a dedicated SQL login for app access.

Firewall & Windows Defender

- Configure Windows Firewall to allow inbound TCP 1433 only from trusted source ranges or SGs (if using security group references via AWS-managed firewall integration, still set host firewall).

Administration via SSM

- Use Session Manager for interactive shell access and port forwarding to avoid exposing RDP. Example to start a session:

```powershell
aws ssm start-session --target i-0123456789abcdef0
```

- Port forwarding example (local RDP tunneled over Session Manager):

```powershell
Start-SSMSession -Target i-0123456789abcdef0 -DocumentName AWS-StartPortForwardingSession -Parameters @{"portNumber"=["3389"];"localPortNumber"=["13389"]}
```

Connectivity from Lambda or app

- If using Lambda in the same VPC, ensure Lambda's `vpcConfig` includes private subnet IDs and security group IDs that allow outbound to `db-sg` on 1433. Remember Lambda will create ENIs in the subnets which affects cold-start.

- Testing connectivity:
   - From a bastion or EC2 in same subnet: `Test-NetConnection -ComputerName 10.0.x.10 -Port 1433` (PowerShell)
   - Or use `tcping`/`telnet` for TCP checks.

Backups and restore

- Two layers of backups recommended:
   1. SQL-native backups: full/diff/log backups scheduled and stored to disk, then copied to S3 (use SSM or custom backup agent/script).
   2. Infrastructure backups: EBS snapshots for volume-level recovery (fast restore).

- Automate snapshots with AWS Data Lifecycle Manager (DLM) or Lambda triggered by CloudWatch Events.

- Restore test: create volume from snapshot, attach to a recovery instance, mount and verify SQL files or restore .bak files to a new SQL Server instance.

Monitoring, logging, and patching

- Install and configure CloudWatch agent to collect Windows performance counters and custom logs.
- Enable CloudWatch Logs for SSM and EC2; set log retention and metric filters for alerts.
- Use SSM Patch Manager to apply OS updates on a maintenance window without opening internet-facing management ports.

Hardening & security

- Principle of least privilege for IAM roles and S3 prefixes.
- Use Security Group references (SG ID) rather than CIDR when restricting DB access.
- Enable EBS encryption and consider using a customer-managed KMS key when required.
- Disable unnecessary Windows features and remove local admin accounts where possible; use AWS IAM Identity Center or AD integration for enterprise setups.

Troubleshooting checklist

- SSM connectivity: check SSM agent, instance role, VPC endpoints for SSM, and CloudWatch logs for agent errors.
- Network: verify route tables, NACLs, SG rules, and source/destination checks for NAT instances.
- SQL: check SQL Server error logs (in `C:\Program Files\Microsoft SQL Server\MSSQL..\MSSQL\Log`), verify TCP/IP enabled and SQL service running.

Cleanup

- Terminate EC2 instance, delete EBS snapshots and any temporary S3 objects, remove IAM role/policies and DLM lifecycle policies created for snapshots.

References & further reading

- AWS Systems Manager Session Manager
- Amazon VPC design and NAT Gateway documentation
- SQL Server Express silent install and configuration guidance
- AWS Data Lifecycle Manager (DLM) for EBS snapshots
