title : "Các bước chuẩn bị"

weight : 2
chapter : false
pre : " <b> 5.2. </b> "
---

#### Tổng quan
Trang này liệt kê các bước chuẩn bị để theo dõi workshop và các bài thực hành cho dự án 2HTD-LearningHub. Nội dung dưới đây bao gồm quyền AWS cần thiết, region khuyến nghị, dịch vụ AWS sẽ sử dụng, ví dụ policy IAM tối thiểu cho workshop và hướng dẫn PowerShell cho người dùng Windows.

#### Tài khoản AWS & quyền truy cập
- Có tài khoản AWS với quyền tạo và quản lý các tài nguyên workshop (CloudFormation, EC2, VPC, S3, Lambda, API Gateway, Cognito, IAM, CloudWatch, SSM).
- Đối với workshop: dùng tài khoản sandbox và tạo một IAM user riêng cho bạn. Nếu muốn tránh lỗi quyền trong lab, tạm thời gán `AdministratorAccess`.
- Trong môi trường thực tế, tuân thủ nguyên tắc least-privilege. Dùng policy tối thiểu bên dưới làm khởi điểm và giới hạn `Resource` (ARN) trước khi áp dụng.

Xác minh nhanh sau khi cấu hình AWS CLI:

```powershell
aws configure                # nhập Access Key, Secret, default region (ví dụ us-east-1) và output format
aws sts get-caller-identity  # kiểm tra credentials và account
```

#### Region
- Dùng `us-east-1` (N. Virginia) cho các ví dụ và CloudFormation trong repository. Nếu sử dụng region khác, điều chỉnh tên tài nguyên và URL template tương ứng.

#### Dịch vụ AWS cần thiết
- Amazon EC2 (Windows + SQL Server để lưu dữ liệu quan hệ)
- Amazon S3 (lưu trữ media và artifacts)
- AWS Lambda (hàm backend)
- Amazon API Gateway (HTTP API)
- Amazon Cognito (xác thực người dùng)
- AWS IAM (roles và policies)
- Amazon CloudWatch (logs & metrics)
- AWS Systems Manager (Session Manager để truy cập EC2)
- AWS CloudFormation (hoặc Terraform/CDK) để provision
- Route 53 (tùy chọn cho DNS trong demo)

#### Công cụ cục bộ (khuyến nghị)
- Git (clone repository)
- Node.js (LTS, ví dụ 18+) và `npm` (dùng build mã Lambda)
- AWS CLI v2 (cấu hình bằng `aws configure`)
- AWS Session Manager plugin (tùy chọn, tích hợp `aws ssm start-session`)
- Công cụ client SQL: SQL Server Management Studio (SSMS) hoặc Azure Data Studio
- PowerShell (Windows) hoặc shell POSIX (Linux/macOS)
- Docker (tùy chọn nếu cần build Lambda container)

#### Policy IAM tối thiểu (ví dụ cho workshop)
Ví dụ dưới đây liệt kê các hành động thường dùng trong quá trình provision và deploy của workshop. Trước khi sử dụng trong production, hãy giới hạn `Resource` theo ARN thực tế.

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

Ghi chú:
- Policy trên phù hợp cho tài khoản lab/sandbox. Để an toàn, thay `"Resource": "*"` bằng ARN cụ thể cho production.
- Một số template CloudFormation có thể tạo IAM role và yêu cầu `CAPABILITY_NAMED_IAM`; do đó `iam:PassRole` là hành động thường cần.

#### PowerShell (Windows) nhanh
Dưới đây là các đoạn PowerShell để cài AWS CLI, cấu hình credentials, kiểm tra truy cập và chạy các lệnh thường dùng trong workshop.

Cài đặt AWS CLI v2 (tải và cài MSI):

```powershell
# Tải installer và chạy
Invoke-WebRequest -Uri "https://awscli.amazonaws.com/AWSCLIV2.msi" -OutFile "$env:TEMP\AWSCLIV2.msi"
Start-Process msiexec.exe -Wait -ArgumentList "/i $env:TEMP\AWSCLIV2.msi /qn"
```

Cấu hình AWS CLI và kiểm tra identity:

```powershell
aws configure
aws sts get-caller-identity
```

Mở session SSM tới EC2 (ví dụ):

```powershell
# Thay bằng instance id thực tế
$instanceId = 'i-0123456789abcdef0'
aws ssm start-session --target $instanceId
```

Triển khai CloudFormation (ví dụ):

```powershell
aws cloudformation deploy --template-file .\cloudformation\stack.yaml --stack-name MyWorkshopStack --capabilities CAPABILITY_NAMED_IAM
```

Upload artifacts lên S3 (ví dụ):

```powershell
aws s3 mb s3://my-workshop-artifacts-$(Get-Random -Maximum 99999)
aws s3 cp .\lambda\package.zip s3://my-workshop-artifacts-12345/
```

#### Các bước cài đặt ban đầu (tóm tắt)
1. Cài đặt các công cụ liệt kê ở trên.
2. Cấu hình AWS CLI: `aws configure` (đặt `us-east-1`).
3. Kiểm tra: `aws sts get-caller-identity`.
4. (Tùy chọn) Tạo S3 bucket để lưu artifacts.

#### Ghi chú về EC2 & SSM
- Dự án dùng EC2 chạy SQL Server trong private subnet; để quản trị dùng AWS Systems Manager (SSM) Session Manager thay vì RDP. Đảm bảo IAM user có quyền SSM (hoặc dùng AdministratorAccess trong tài khoản lab).

#### Dọn dẹp
- Nếu triển khai bằng CloudFormation hoặc script, xóa stack và S3 buckets tạo ra khi hoàn thành để tránh chi phí phát sinh.

Nếu bạn muốn, tôi có thể mở rộng policy IAM để giới hạn theo ARN của tài khoản bạn, hoặc soạn script PowerShell tự động cài AWS CLI và `aws configure`.