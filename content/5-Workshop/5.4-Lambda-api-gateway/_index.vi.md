---
title: "Lambda + API Gateway"
weight: 3
chapter: false
pre : " <b> 5.4. </b> "
---

## Tổng quan

Bài lab này hướng dẫn cách xây dựng và triển khai API HTTP dựa trên Lambda sử dụng Amazon API Gateway (HTTP API). Phiên bản nâng cao này bao gồm các chủ đề: đóng gói hàm Lambda (Node.js), cấu hình IAM tối thiểu, chạy Lambda trong VPC để truy cập SQL Server trên EC2 trong private subnet, lưu giữ thông tin đăng nhập bằng AWS Secrets Manager, cấu hình CORS, và quan sát (CloudWatch + X-Ray). Ngoài ra còn có ví dụ sử dụng AWS CLI / PowerShell để thao tác nhanh.

## Yêu cầu trước

- Tài khoản AWS có quyền tạo Lambda, API Gateway, IAM, CloudWatch, VPC/subnet, Security Group, và Secrets Manager.
- AWS CLI v2 hoặc PowerShell đã cấu hình; SAM/Serverless tùy chọn cho kiểm thử cục bộ.
- Node.js (phiên bản LTS) để phát triển và đóng gói hàm.

## Ghi chú kiến trúc

- Frontend (Vercel) gọi API Gateway (HTTP API).
- API Gateway chuyển tiếp request tới Lambda (Node.js). Nếu Lambda cần truy cập SQL Server trên EC2 trong private subnet, cấu hình Lambda chạy trong cùng VPC/subnet và dùng Security Group phù hợp.
- Thông tin nhạy cảm (DB username/password) được lưu trong Secrets Manager; Lambda cần quyền `secretsmanager:GetSecretValue` để truy xuất khi runtime.

## Các bước chi tiết

1) Chuẩn bị IAM role cho Lambda

- Tạo role có trust policy cho Lambda và gán các policy cần thiết.

Ví dụ trust policy (cho phép Lambda assume role):

```json
{
   "Version": "2012-10-17",
   "Statement": [
      {
         "Effect": "Allow",
         "Principal": {"Service": "lambda.amazonaws.com"},
         "Action": "sts:AssumeRole"
      }
   ]
}
```

- Gán policy mẫu:

   - `AWSLambdaBasicExecutionRole` (ghi CloudWatch Logs)
   - Policy inline cho phép truy xuất Secrets Manager và hành động ENI (khi Lambda trong VPC):

```json
{
   "Version": "2012-10-17",
   "Statement": [
      {"Effect":"Allow","Action":["secretsmanager:GetSecretValue","secretsmanager:DescribeSecret"],"Resource":"arn:aws:secretsmanager:<region>:<account-id>:secret:<your-secret>"},
      {"Effect":"Allow","Action":["ec2:CreateNetworkInterface","ec2:DescribeNetworkInterfaces","ec2:DeleteNetworkInterface"],"Resource":"*"}
   ]
}
```

PowerShell / AWS CLI để tạo role và gán policy:

```powershell
# tạo role
$trust = '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"Service":"lambda.amazonaws.com"},"Action":"sts:AssumeRole"}]}'
aws iam create-role --role-name LearningHubLambdaRole --assume-role-policy-document $trust

# gán managed policy
aws iam attach-role-policy --role-name LearningHubLambdaRole --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

# thêm inline policy (lưu file lambda-secrets-policy.json rồi chạy)
aws iam put-role-policy --role-name LearningHubLambdaRole --policy-name LambdaSecretsPolicy --policy-document file://lambda-secrets-policy.json
```

2) Đóng gói hàm Lambda (Node.js)

- Cấu trúc ví dụ:

   lambda/
      package.json
      index.js
      node_modules/

- Dùng bundler (esbuild/webpack) hoặc `npm install --production` rồi nén thành zip.

PowerShell ví dụ:

```powershell
cd lambda
npm install --production
Compress-Archive -Path * -DestinationPath ..\lambda-package.zip
```

3) Tạo hàm Lambda (CLI)

```powershell
aws lambda create-function --function-name learninghub-api-handler \
   --runtime nodejs18.x --handler index.handler \
   --zip-file fileb://lambda-package.zip \
   --role arn:aws:iam::<account-id>:role/LearningHubLambdaRole \
   --timeout 30 --memory-size 512
```

Nếu Lambda cần truy cập DB trong private subnet, cập nhật cấu hình VPC:

```powershell
aws lambda update-function-configuration --function-name learninghub-api-handler --vpc-config SubnetIds=subnet-aaa,subnet-bbb,SecurityGroupIds=sg-xxxx
```

Ghi chú về VPC:

- Lambda khi chạy trong VPC sẽ tạo ENI trong các subnet; điều này làm tăng thời gian cold-start.
- Luôn có ít nhất hai subnet private để Lambda có thể tạo ENI.
- Nếu Lambda cần truy cập Internet, đảm bảo private subnet route đến NAT Gateway.

4) Lưu credentials vào Secrets Manager và cấp quyền cho Lambda

Tạo secret (PowerShell):

```powershell
aws secretsmanager create-secret --name learninghub/sqlserver --secret-string '{"username":"dbuser","password":"P@ssw0rd","host":"10.0.1.10","port":"1433"}'
```

Đảm bảo IAM role của Lambda có quyền `secretsmanager:GetSecretValue` cho ARN secret tương ứng.

5) Tạo API Gateway (HTTP API) và tích hợp với Lambda

Tạo API (CLI):

```powershell
$api=$(aws apigatewayv2 create-api --name learninghub-api --protocol-type HTTP --output json)
$apiId=(ConvertFrom-Json $api).ApiId

# tạo integration tới Lambda
$lambdaArn = "arn:aws:lambda:<region>:<account-id>:function:learninghub-api-handler"
$integration=$(aws apigatewayv2 create-integration --api-id $apiId --integration-type AWS_PROXY --integration-uri $lambdaArn --payload-format-version 2.0 --output json)
$integrationId=(ConvertFrom-Json $integration).IntegrationId

# tạo route
aws apigatewayv2 create-route --api-id $apiId --route-key "GET /status" --target "integrations/$integrationId"

# cho phép API Gateway invoke Lambda
aws lambda add-permission --function-name learninghub-api-handler --statement-id apigw-invoke --action lambda:InvokeFunction --principal apigateway.amazonaws.com --source-arn arn:aws:execute-api:<region>:<account-id>:$apiId/*/*

# deploy
aws apigatewayv2 create-stage --api-id $apiId --stage-name prod --auto-deploy
```

Ghi chú:

- Dùng `payload-format-version` 2.0 cho HTTP API; event gửi đến Lambda có cấu trúc khác so với REST API.
- `integration-type AWS_PROXY` chuyển toàn bộ HTTP request tới Lambda.

6) Cấu hình CORS (HTTP API)

Kích hoạt CORS trong Console hoặc dùng CLI:

```powershell
$cors='{"AllowOrigins":["https://learninghub.example.com"],"AllowMethods":["GET","POST","OPTIONS"],"AllowHeaders":["Content-Type","Authorization"],"MaxAge":3600}'
aws apigatewayv2 update-api --api-id $apiId --cors-configuration $cors
```

7) Kiểm thử endpoint

PowerShell ví dụ:

```powershell
Invoke-RestMethod -Method Get -Uri "https://$apiId.execute-api.<region>.amazonaws.com/status"
```

Nếu route được bảo vệ (ví dụ Cognito), thêm header token: `-Headers @{ Authorization = "Bearer $token" }`.

8) Quan sát & thực hành tốt

- CloudWatch Logs: đặt retention, dùng structured logging (JSON).
- X-Ray: bật tracing cho Lambda để theo dõi phân tán.
- Metrics & Alarms: tạo alarm cho Errors, Throttles, Duration.
- API access logs: cấu hình access log cho stage via `accessLogSettings`.

9) Bảo mật

- Dùng Secrets Manager để quản lý mật khẩu DB; tránh lưu plaintext trong biến môi trường.
- Giới hạn IAM policy theo nguyên tắc least privilege (tốt nhất là theo ARN cụ thể).
- Khi Lambda chạy trong VPC, đảm bảo Security Group cho phép outbound tới DB (port 1433) và EC2 DB chỉ cho phép inbound từ SG của Lambda.

10) Dọn dẹp

```powershell
# xóa API
aws apigatewayv2 delete-api --api-id $apiId
# xóa lambda
aws lambda delete-function --function-name learninghub-api-handler
# xóa policy inline, detach managed, rồi xóa role
aws iam delete-role-policy --role-name LearningHubLambdaRole --policy-name LambdaSecretsPolicy
aws iam detach-role-policy --role-name LearningHubLambdaRole --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
aws iam delete-role --role-name LearningHubLambdaRole
```

Appendix: ví dụ Lambda minimal (Node.js)

```js
// index.js
const sql = require('mssql'); // nếu dùng package mssql
exports.handler = async (event) => {
   // parse request, đọc secret, kết nối SQL Server, chạy query
   return {
      statusCode: 200,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ message: 'OK', request: event })
   };
};
```

Tài liệu tham khảo

- AWS Lambda Developer Guide
- Amazon API Gateway (HTTP API) Developer Guide
- AWS Secrets Manager Developer Guide
