---
title : "Giới thiệu"

weight : 1
chapter : false
pre : " <b> 5.1. </b> "
---

#### Tổng quan workshop — LearningHub (2HTD)

Mục tiêu workshop này là hướng dẫn triển khai và kiểm thử các thành phần chính của 2HTD-LearningHub theo kiến trúc trong proposal: frontend host trên Vercel, backend serverless bằng Lambda + API Gateway, database quan hệ chạy trên SQL Server trong EC2 (private subnet) và media lưu trên S3. Workshop tập trung vào các thao tác hands-on để provision mạng (VPC/subnets), cấu hình EC2 + SQL Server, thiết lập S3 upload với presigned URL, triển khai Lambda + API Gateway, cấu hình Cognito, và truy cập EC2 an toàn bằng AWS Systems Manager (SSM).

Workshop sử dụng một môi trường test đơn giản (có thể là 2 VPC: một VPC cloud để chứa tài nguyên LearningHub và một VPC mô phỏng on-prem nếu cần) để minh hoạ các luồng mạng và truy cập an toàn.

<div style="text-align: center; margin: 20px 0;">
	<img src="/images/5-Workshop/5.1-Workshop-overview/diagram1.png" alt="Workshop Overview Diagram" style="max-width: 90%; height: auto; border: 1px solid #ddd; border-radius: 6px;" />
	<p><em>Hình: Sơ đồ workshop — thiết lập VPC, EC2 (SQL Server), S3, Lambda, API Gateway, Cognito, và SSM</em></p>
</div>

### Mục tiêu học viên

- Hiểu kiến trúc hybrid của LearningHub (Vercel + Lambda + EC2 + S3).
- Provision VPC, subnets và cấu hình NAT / endpoints để tối ưu chi phí egress.
- Triển khai EC2 Windows + SQL Server Express và quản trị cơ bản qua SSM.
- Thiết lập S3 bucket và upload bằng presigned URL từ frontend.
- Triển khai Lambda (Node.js) và cấu hình API Gateway (HTTP API) để xử lý API.
- Cấu hình Amazon Cognito cho authentication và thử nghiệm luồng đăng nhập.

### Bài tập chính (lab)

1. Provision cơ bản: tạo VPC với public/private subnets, Internet Gateway và NAT (hoặc NAT instance cho lab).
2. Tạo EC2 Windows instance, cài đặt SQL Server Express (hoặc sử dụng AMI có sẵn), cấu hình security group cho private access.
3. Cấu hình SSM Agent và truy cập EC2 bằng Session Manager (không mở RDP công khai).
4. Tạo S3 bucket test, cấp quyền IAM role cho Lambda và thử upload bằng presigned URL.
5. Triển khai Lambda function đơn giản (Node.js) và cấu hình API Gateway (HTTP API) để gọi Lambda.
6. Cấu hình Cognito User Pool, đăng ký user test và thử gọi API có xác thực.
7. Giám sát: cấu hình CloudWatch logs cho Lambda, kiểm tra log và tạo dashboard đơn giản.

### Tài liệu & Tham khảo

- Sơ đồ kiến trúc: `/images/architecture.png` (chi tiết proposal)
- Mã mẫu presigned URL, Lambda handler và Terraform/CDK sample sẽ được cung cấp trong repo workshop.

---

Nếu bạn muốn, tôi có thể rút ngắn các lab thành 4 bài tập chính, hoặc thêm checklist cài đặt chi tiết từng bước (commands, IAM policies, Terraform snippets). 
