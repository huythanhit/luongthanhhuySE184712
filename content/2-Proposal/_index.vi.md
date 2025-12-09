---
title: "Proposal 2HTD-LearningHub"
linkTitle: "Proposal"
weight: 2
chapter: false
pre: " <b> 2. </b> "
---

## 1. Tóm tắt dự án

2HTD-LearningHub là một nền tảng web tích hợp phục vụ việc học tập, luyện tập, soạn đề và thi trực tuyến. Mục tiêu là cung cấp trải nghiệm một cửa cho học viên và giảng viên: ngân hàng đề, bài tập thực hành, kỳ thi mô phỏng và báo cáo kết quả.

 Hệ thống tập trung vào tính năng authoring (soạn đề), submission, grading tự động và phân phối nội dung học liệu.

Kiến trúc hệ thống là hybrid: frontend được host trên Vercel; backend xử lý nghiệp vụ bằng AWS Lambda (được gọi qua API Gateway); dữ liệu quan trọng về quan hệ (schema SQL) được lưu trên SQL Server chạy trong Amazon EC2 đặt trong private subnet; file media và tài liệu được lưu trên Amazon S3.

Thiết kế ưu tiên an toàn và vận hành: mạng được tách biệt bằng VPC/subnet, quản lý truy cập bằng IAM và Cognito, quản sát và logging bằng CloudWatch, và sử dụng SSM để quản trị EC2 mà không cần RDP.

## 2. Bài toán cần giải quyết

- Người học và giáo viên đang phải dùng nhiều công cụ rời rạc (quiz tools, video call, storage), dẫn đến trải nghiệm phân mảnh và khó quản lý nội dung.
- Giáo viên tốn nhiều thời gian soạn đề, duyệt và phân phối bài kiểm tra; thiếu công cụ tự động hóa chấm bài và báo cáo tiến độ học tập.
- Khi có sự kiện lớn (thi thử), hệ thống hiện tại khó đảm bảo hiệu suất và độ trễ thấp cho tất cả học viên.
- Thiếu hệ thống thông báo & báo cáo thời gian thực để hỗ trợ giảng dạy và theo dõi học viên.
- Yêu cầu bảo mật đáp án và dữ liệu người dùng, tránh rò rỉ thông tin và gian lận.

## 3. Giải pháp & Kiến trúc

Giải pháp dựa trên sơ đồ kiến trúc:

- Frontend: Vercel (hosting website, SPA/static), domain quản lý bởi Route 53.
- Authentication: Amazon Cognito cho user pool (signup/login) và token-based auth.
- API layer: Amazon API Gateway (HTTP API) làm public endpoint, routing tới Lambda (Lambda proxy).
- Backend: AWS Lambda (Node.js) xử lý business logic.
- Database: Amazon EC2 (Windows + SQL Server Express) đặt trong private subnet, lưu dữ liệu chính (users, courses, quizzes, tests, metadata).
- Storage: Amazon S3 lưu trữ file bài giảng, video, hình ảnh; database chỉ lưu metadata và link tới S3.
- Network: VPC gồm public/private subnet, NAT Gateway, Internet Gateway; EC2 nằm trong private subnet; Lambda có thể đặt trong VPC khi cần truy cập DB.
- Operations & Security: IAM roles, CloudWatch logs, AWS SSM (Session Manager) để truy cập EC2 mà không cần RDP.

Thiết kế tập trung vào: an toàn kết nối DB (private subnet + security groups), tách lưu trữ file ra S3 để tối ưu chi phí và backup, và giữ backend serverless để tối ưu chi phí vận hành.

### Sơ đồ kiến trúc

<div style="text-align: center; margin: 20px 0;">
	<img src="/images/architecture.png" alt="Architecture Diagram - Kiến trúc 2HTD-LearningHub" style="max-width: 90%; height: auto; border: 1px solid #ddd; border-radius: 6px;" />
	<p><em>Hình 1: Kiến trúc 2HTD-LearningHub </em></p>
</div>

### Các dịch vụ AWS được sử dụng

- Amazon EC2 (Windows + SQL Server Express): Chạy SQL Server (SQLEXPRESS) để lưu dữ liệu chính của hệ thống (users, courses, quizzes, tests, results).

- Amazon S3: Lưu trữ file bài giảng, video, PDF, hình ảnh; database chỉ lưu metadata.

- AWS Lambda: Chạy backend Node.js (API handlers, background tasks).

- Amazon API Gateway (HTTP API): Public HTTPS endpoint để frontend (Vercel) gọi về backend.

- Amazon Cognito: Quản lý đăng ký / đăng nhập, gửi email xác thực, cung cấp AccessToken/IdToken.

- AWS IAM: Cấp quyền cho Lambda truy cập S3, EC2, SSM

- Amazon CloudWatch Logs: Lưu log từ Lambda và API Gateway để debug và giám sát.

- AWS Systems Manager (SSM): Session Manager để truy cập EC2 mà không cần RDP; chạy PowerShell/ trực tiếp.

- Amazon Route 53: Quản lý DNS cho domain và trỏ về Vercel.

- VPC, Subnets, NAT Gateway, Internet Gateway: Mạng private/public cho tài nguyên, bảo vệ DB.

### Thiết Kế Thành Phần

- VPC: với public & private subnets. EC2 DB nằm trong private subnet; NAT Gateway cho outbound từ private.
- EC2 (DB): Windows Server + SQL Server Express cài trên EC2 instance (private), lưu dữ liệu chính (users, courses, quizzes, test results). Backup bằng snapshot & policy bảo trì.
- Lambda (Backend): Xử lý request từ API Gateway; có thể đặt Lambda trong VPC để truy cập DB nếu cần.
- API Gateway: HTTP API, routing đến Lambda (proxy). Bật CORS cho frontend Vercel.
- S3: Lưu trữ file, video, attachments; presigned URL cho upload/download từ frontend.
- Cognito: User Pool cho auth, xác thực email/OTP.
- IAM & Roles: để gán quyền theo nguyên tắc least-privilege.
- SSM: Dùng Session Manager để connect vào EC2, chạy sqlcmd hoặc PowerShell để quản trị SQL Server.
- CloudWatch: Logs từ Lambda/API Gateway, metrics và dashboard để giám sát.


## 4. Triển khai Kỹ thuật

1) IaC & Provisioning: Dùng Terraform hoặc AWS CDK để provision VPC, subnets, NAT/IGW, EC2 (Windows + SQL Server), S3 bucket, API Gateway, Lambda, Cognito, IAM roles, SSM và CloudWatch.
2) CI/CD: GitHub Actions để build & deploy frontend (Vercel), deploy Lambda packages/containers, và apply IaC changes cho staging/production.
3) API & Data: API Gateway (HTTP API) → Lambda (Node.js) xử lý CRUD cho courses/quizzes/tests; Lambda kết nối đến EC2 SQL Server trên private network. Database trên EC2 được quản trị qua SSM cho migration/backup.
4) File Storage: Teacher upload → backend tạo presigned URL → frontend upload trực tiếp lên S3; database lưu metadata và link.
5) Security & Operations: IAM (least-privilege), KMS khi cần, Secrets Manager/SSM Parameter Store cho credentials; CloudWatch logs & metrics, runbooks và snapshot backup cho EC2.
6) SSM (Systems Manager): Dùng Session Manager để truy cập EC2 an toàn (chạy PowerShell / sqlcmd cho migration, kiểm tra kết nối, backup/restore và troubleshooting) mà không cần mở RDP hay cổng mạng bổ sung.

## 5. Lịch trình & Các cột mốc

- Tuần 1-2: Thiết kế chi tiết, mô hình dữ liệu, scaffold IaC, provision EC2 DB.
- Tuần 3-4: Triển khai Cognito, API Gateway + Lambda cơ bản, kết nối tới DB (test kết nối via SSM).
- Tuần 5-6: Implement chức năng soạn đề, submit, grading pipeline; triển khai storage S3 (upload/download với presigned URL).
- Tuần 7: Test toàn hệ thống, backup/restore DB, security review.
- Tuần 8: Load testing, observability dashboards, hoàn thiện docs và handover.

## 6. Ước tính ngân sách

| Dịch vụ AWS | Yếu tố Tính phí Chính | Chi phí Ướ tính (USD) |
|---|---|---:|
| EC2 + EBS (Database) | Windows + SQL Server Express (instance + EBS storage, snapshots) | 23.00 |
| Amazon S3 | Lưu trữ (GB) và request (PUT/GET) | 1.30 |
| AWS Lambda | Invocations và compute (ước tính thấp cho môi trường starter) | 1.00 |
| Amazon API Gateway (HTTP API) | Request charges (per-request pricing) | 2.50 |
| Amazon CloudWatch Logs | Log ingestion & storage cho Lambda/API | 1.50 |
| NAT Gateway | Hourly + data processing (egress) — thường là chi phí lớn nhất | 30.00 |
| Route 53 | Hosted zone + DNS queries | 1.00 |
| Cognito + IAM + SSM | Authentication, IAM management, SSM Session Manager (không phát sinh chi phí trực tiếp) | 0.00 |
| **TỔNG CỘNG** |  | **≈ 60.00** |

Lưu ý: Chi phí thực tế phụ thuộc vào lưu lượng, vùng (region) và cấu hình môi trường; có thể giảm thêm khi tắt môi trường dev/test hoặc tối ưu egress. 

## 7. Đánh giá rủi ro

| Rủi ro | Tác động | Chiến lược giảm thiểu |
|---|---|---|
| Chi phí EC2 / egress lớn | Cao | Giám sát usage, chọn kích thước instance phù hợp, schedules/auto-stop cho dev instances.
| Rò rỉ dữ liệu/credentials | Rất cao | Sử dụng Secrets Manager, KMS, least-privilege IAM, periodic review và pentest.
| Kết nối Lambda ↔ EC2 (network) | Trung bình | Thiết kế security group rõ ràng, kiểm thử kết nối trong staging, sử dụng proxy nếu cần.
| Quản trị DB (backup/restore) | Cao | Snapshot tự động, backup policy, kiểm thử recovery định kỳ.

## Phương án dự phòng 

- Nếu EC2 gặp lỗi: fallback read-only từ cache hoặc copy read-replica (nếu có), restore từ snapshot.
- Nếu S3 không khả dụng (rất hiếm): tạm thời phục vụ nội dung static từ Vercel hoặc CDN cache.
- Nếu Lambda bị quá tải: throttle không quan trọng, tăng concurrency hoặc mở rộng logic sang container/ECS nếu cần.

## 8. Kết quả Dự kiến

 - Một nền tảng tích hợp cho học tập, ôn luyện, tạo đề và thi trực tuyến, giảm fragmentation công cụ cho học viên và giáo viên.
 - Tự động hóa quy trình soạn đề, phân phối bài kiểm tra và chấm điểm, giúp giáo viên tiết kiệm thời gian.
 - Hệ thống ổn định, bảo mật và có khả năng mở rộng; database SQL Server trên EC2 đảm bảo tương thích với requirement cũ.
 - S3 lưu trữ file lớn, giảm chi phí và tối ưu backup; Lambda giúp giảm chi phí vận hành cho phần backend.
 - Observability & logging (CloudWatch) giúp debug và theo dõi hiệu năng.
