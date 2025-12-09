---
title: "EC2 (Private Subnet) — Windows + SQL Server"
weight: 3
chapter: false
pre : " <b> 5.5. </b> "
---

## Tổng quan

Lab này hướng dẫn triển khai và vận hành một instance EC2 chạy Windows + SQL Server Express trong private subnet, nhấn mạnh cấu trúc mạng, quản trị an toàn qua AWS Systems Manager (SSM), cài đặt SQL Server ở chế độ silent, chiến lược backup/restore (EBS snapshot và backup SQL lên S3), giám sát và các thực hành vận hành phù hợp môi trường production.

## Yêu cầu trước

- Tài khoản AWS có quyền tạo VPC/subnet/route table, NAT Gateway, EC2, IAM, Systems Manager, EBS và S3.
- AWS CLI v2 hoặc Console và hiểu biết cơ bản về EC2, VPC, IAM.
- Có VPC hiện có hoặc quyền tạo VPC cho bài lab.

## Mục tiêu học viên

- Thiết kế VPC có public/private subnets có routing phù hợp cho instance DB private.
- Khởi tạo EC2 Windows trong private subnet và cấu hình an toàn cho SQL Server.
- Quản trị qua SSM (Session Manager / Run Command / Patch Manager) mà không cần mở RDP ra Internet.
- Thực hiện backup (EBS snapshots, backup SQL lên S3), giám sát và hardening cơ bản.

## Thiết kế mạng & VPC

- Bố cục subnet đề xuất:
   - Public subnets: chứa NAT Gateway, load balancer, hoặc bastion nếu dùng.
   - Private subnets: chứa DB instances và các dịch vụ nội bộ.
   - Tối thiểu 2 AZ cho High Availability.

- Route table:
   - Public RT: 0.0.0.0/0 -> Internet Gateway (IGW).
   - Private RT: 0.0.0.0/0 -> NAT Gateway (cho update/egress) hoặc không có NAT nếu dùng SSM + VPC Endpoints.

- VPC Endpoints:
   - Thêm interface endpoints cho `com.amazonaws.<region>.ssm`, `com.amazonaws.<region>.ec2messages`, `com.amazonaws.<region>.ssmmessages` để SSM hoạt động nội bộ.
   - Thêm Gateway endpoint cho S3 nếu đẩy backup lên S3.

## Security Group & NACL

- Security Group cho SQL (db-sg):
   - Inbound: TCP 1433 chỉ từ SG ứng dụng / subnet nội bộ (dùng SG ID thay vì CIDR khi có thể).
   - Outbound: giới hạn theo nhu cầu; cho phép trả lời traffic.

- Security Group quản trị (mgmt-sg):
   - Dành cho kết nối SSM và các thao tác quản trị nội bộ.

- NACL: có thể giữ mặc định hoặc thêm quy tắc state-less nếu chính sách yêu cầu; SG vẫn là cơ chế chính.

## IAM & Instance Profile

- Tạo IAM role cho EC2 và gán policy `AmazonSSMManagedInstanceCore` để SSM hoạt động.
- Quyền bổ sung (giới hạn theo least privilege):
   - `ec2:CreateSnapshot`, `ec2:DescribeVolumes` nếu instance tự động tạo snapshot.
   - Quyền ghi lên S3 nếu instance upload backup (hạn chế theo prefix).

## Lựa chọn instance, ổ đĩa và AMI

- Instance type: chọn theo workload (ví dụ dev/test: `t3.medium`; production: `m5`/`r5` hoặc lớn hơn tùy I/O).
- Storage:
   - Tách ổ OS (C:) và Data (D:/E:) – đặt Data, Logs, TempDB trên volumes riêng.
   - Chọn `gp3` hoặc `io2` cho IOPS ổn định.
   - Bật EBS encryption (KMS) nếu dữ liệu nhạy cảm.

## Cài SQL Server (tự động hóa)

- Cài qua SSM Run Command hoặc dùng AMI đã cài sẵn.
- Ví dụ PowerShell (chạy qua SSM hoặc Session Manager) cài SQL Server Express silent:

```powershell
# Tải installer
$url = "https://download.microsoft.com/.../SQLEXPR_x64_ENU.exe"
Invoke-WebRequest -Uri $url -OutFile C:\Temp\sqlexpr.exe

# Tạo file cấu hình
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

# Chạy cài đặt silent
& C:\Temp\sqlexpr.exe /Q /ACTION=Install /IACCEPTSQLSERVERLICENSETERMS /ConfigurationFile=C:\Temp\ConfigurationFile.ini
```

- Sau cài đặt, bật TCP/IP trong SQL Server Configuration Manager (có thể script được) và khởi động lại dịch vụ SQL.
- Tạo tài khoản SQL riêng cho ứng dụng, đặt quyền tối thiểu cần thiết.

## Firewall & Windows Defender

- Cấu hình Windows Firewall chỉ cho phép TCP 1433 từ nguồn tin cậy hoặc SG nội bộ.

## Quản trị bằng SSM

- Dùng Session Manager để mở shell tương tác và port-forwarding để tránh mở RDP.

Ví dụ bắt đầu session (local):

```powershell
aws ssm start-session --target i-0123456789abcdef0
```

Ví dụ port forwarding RDP:

```powershell
Start-SSMSession -Target i-0123456789abcdef0 -DocumentName AWS-StartPortForwardingSession -Parameters @{"portNumber"=["3389"];"localPortNumber"=["13389"]}
```

## Kết nối từ Lambda / ứng dụng nội bộ

- Nếu Lambda chạy trong cùng VPC, cấu hình `vpcConfig` với subnet private và SG cho phép kết nối tới `db-sg` trên port 1433. Lưu ý Lambda tạo ENI và có ảnh hưởng tới cold-start.

- Kiểm tra kết nối:
   - Từ EC2/bastion trong cùng VPC: `Test-NetConnection -ComputerName 10.0.x.10 -Port 1433`

## Backup & Restore

- Chiến lược 2 lớp:
   1. Backup SQL (full/diff/log) lưu thành file .bak và upload sang S3.
   2. Snapshot EBS cho điểm phục hồi nhanh.

- Tự động snapshot bằng AWS Data Lifecycle Manager (DLM) hoặc Lambda theo lịch.

- Kiểm tra phục hồi: tạo volume từ snapshot, attach vào instance phục hồi, mount và kiểm tra dữ liệu hoặc khôi phục .bak lên SQL mới.

## Giám sát, logging và patching

- Cài CloudWatch Agent để thu Windows performance counters và logs.
- Kết hợp CloudWatch Logs cho SSM/EC2; cấu hình retention và alarm cho metrics quan trọng.
- Dùng SSM Patch Manager để cập nhật OS theo maintenance window.

## Hardening & bảo mật

- Áp dụng least privilege cho IAM và prefix S3.
- Dùng Security Group ID làm nguồn thay vì CIDR khi có thể.
- Dùng EBS encryption với KMS riêng khi cần.
- Loại bỏ account admin không cần thiết; cân nhắc tích hợp AD/SSO cho môi trường enterprise.

## Troubleshooting nhanh

- SSM: kiểm tra SSM agent, IAM role, VPC endpoints (ssm, ec2messages, ssmmessages) và CloudWatch logs.
- Mạng: kiểm tra route table, NACL, Security Group, và source/destination check nếu dùng NAT instance.
- SQL: kiểm tra SQL error log (`C:\Program Files\Microsoft SQL Server\...\Log`), chắc chắn TCP/IP bật và service SQL đang chạy.

## Dọn dẹp

- Terminate instance, xóa snapshots, xóa objects tạm trên S3, xoá role IAM và chính sách DLM nếu đã tạo.

## Tài liệu tham khảo

- AWS Systems Manager Session Manager
- Amazon VPC design và NAT Gateway
- Hướng dẫn cài silent SQL Server Express
- AWS Data Lifecycle Manager (DLM)
