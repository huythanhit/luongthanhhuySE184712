---
title: "Workshop"
weight: 5
chapter: false
pre: " <b> 5. </b> "
---


# Workshop — LearningHub (2HTD)

#### Tổng quan

Workshop này đi kèm với proposal 2HTD-LearningHub và hướng dẫn học viên triển khai, kiểm thử các thành phần chính: frontend host trên Vercel, backend serverless (AWS Lambda + API Gateway), database quan hệ chạy SQL Server trên EC2 (private subnet) và media lưu trữ trên S3. Các bài lab tập trung vào truy cập hybrid an toàn, thiết kế mạng (VPC/subnets), quản trị EC2 bằng SSM, upload lên S3 bằng presigned URL, API Lambda và cấu hình Cognito.

Workshop được tổ chức thành các lab ngắn, có thể chạy trong môi trường test nhỏ (single VPC) hoặc môi trường mở rộng (cloud VPC + mô phỏng on-prem) để minh hoạ luồng mạng khác nhau và các cân nhắc về NAT/egress.

### Mục tiêu học viên

- Hiểu kiến trúc hybrid của LearningHub (Vercel + Lambda + EC2 + S3).
- Provision VPC, subnets và thiết kế NAT / VPC endpoints để kiểm soát chi phí egress.
- Triển khai EC2 Windows + SQL Server Express và quản trị qua AWS Systems Manager (SSM).
- Thiết lập S3 bucket và upload bằng presigned URL từ frontend.
- Triển khai Lambda (Node.js) và expose qua API Gateway (HTTP API).
- Cấu hình Amazon Cognito cho authentication và kiểm thử API có bảo vệ.


### Kiến trúc dự án

Hệ thống LearningHub được thiết kế theo kiến trúc frontend-hosted + backend serverless kết hợp với một instance EC2 chạy SQL Server trong private subnet để lưu trữ dữ liệu quan hệ. Kiến trúc chính gồm các thành phần sau:

- Frontend: Tĩnh (Next.js / Vercel) hoặc SPA host trên Vercel, tải UI và thực hiện các cuộc gọi API.
- API: Amazon API Gateway (HTTP API) chuyển tiếp tới các AWS Lambda (Node.js) để xử lý nghiệp vụ.
- Storage: Amazon S3 để lưu media; sử dụng presigned URL để upload trực tiếp từ frontend.
- Database: Microsoft SQL Server chạy trên Amazon EC2 trong private subnet (kết nối nội bộ từ Lambda hoặc qua bastion/peering tuỳ triển khai).
- Authentication: Amazon Cognito cung cấp token cho frontend và bảo vệ các endpoint API.
- Network & Security: VPC, subnets, security groups, IAM, VPC Endpoints cho S3 để giảm egress, NAT Gateway cho egress khi cần.
- Ops & Observability: AWS Systems Manager (SSM) cho quản trị EC2, CloudWatch cho logs/metrics, AWS Secrets Manager / Parameter Store cho secrets.

<div style="max-width:100%;text-align:center;margin:1rem 0;">
	<img src="/images/architecture.png" alt="Kiến trúc LearningHub" style="max-width:100%;height:auto;" />
</div>

### Luồng đi chính (data / request flows)

1. Người dùng tải trang frontend từ Vercel; nếu cần xác thực, frontend chuyển hướng đăng nhập Cognito và nhận access token.
2. Khi upload media, frontend gọi API (API Gateway → Lambda) để yêu cầu một presigned URL (kèm token Cognito nếu endpoint yêu cầu).
3. Lambda tạo presigned URL bằng SDK S3 và trả về cho frontend; frontend upload trực tiếp file lên S3 bằng presigned URL.
4. Sau upload, frontend có thể gọi một API xác nhận (API Gateway → Lambda) để ghi metadata vào database hoặc kích hoạt xử lý tiếp theo.
5. Các yêu cầu nghiệp vụ (ví dụ: CRUD dữ liệu người dùng, bài học) đi qua API Gateway → Lambda; Lambda có thể truy vấn/ghi vào SQL Server trên EC2 qua mạng nội bộ (nằm trong cùng VPC hoặc thông qua peering/private route) hoặc lưu tạm vào S3 và trigger xử lý.
6. Quản trị EC2 (cài đặt SQL, vá lỗi) thực hiện qua AWS Systems Manager (SSM Session Manager) — không cần mở RDP/SSH ra internet.
7. Để giảm chi phí egress khi truy cập S3 từ trong VPC, bật VPC Endpoint cho S3; nếu cần gọi ra Internet (cập nhật OS, tải package), cân nhắc sử dụng NAT Gateway (chi phí) hoặc SSM + VPC endpoints.

Các luồng trên tương thích với các lab: presigned S3 upload, truy cập S3 từ VPC (với endpoint), quản trị EC2 qua SSM, và API Lambda kết nối đến EC2/DB.


---

### Các dịch vụ AWS được sử dụng

| Danh mục | Dịch vụ |
|---|---|
| Compute | AWS Lambda (Function / Container), Amazon EC2 (Windows + SQL Server Express) |
| Storage | Amazon S3 |
| API | Amazon API Gateway (HTTP API) |
| Authentication & Bảo mật | Amazon Cognito, AWS IAM, AWS Secrets Manager |
| Giám sát | Amazon CloudWatch Logs & Metrics |
| Mạng | VPC, Subnets, NAT Gateway, Internet Gateway, VPC Endpoints |
| DNS | Amazon Route 53 |
| IaC / CI-CD | Terraform (hoặc CDK), GitHub Actions |
| Vận hành & Backup | AWS Systems Manager (SSM), EBS Snapshots |

### Thời gian & Chi phí ước tính

| Mục | Chi tiết |
|---|---|
| Thời gian | 3-4 giờ (lab ngắn) |
| Cấp độ | Trung cấp |
| Chi phí ước tính | Workshop: rất thấp cho môi trường tạm thời; Hệ thống triển khai đầy đủ: **≈ 60.00 USD / tháng** (tham khảo phần Proposal) |

Lưu ý: Chi phí workshop thực tế phụ thuộc vào số giờ chạy tài nguyên thí nghiệm và cấu hình vùng. Bảng tổng chi phí hệ thống được trình bày chi tiết trong phần Proposal.



### Mục lục lab

1. [Tổng quan về workshop](5.1-Workshop-overview/)
2. [Chuẩn bị & thiết lập môi trường](5.2-Prerequiste/)
3. [Tích hợp Cognito + API Gateway](5.3-Cognito-api-gateway/)
4. [Lambda + API Gateway (API serverless)](5.4-Lambda-api-gateway/)
5. [EC2 Windows + SQL Server (Private Subnet)](5.5-Ec2-PrivateSubnet/)
6.  [Dọn dẹp tài nguyên](5.6-Cleanup/)

---
