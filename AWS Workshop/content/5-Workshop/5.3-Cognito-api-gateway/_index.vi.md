---
title: "Cognito + API Gateway"
weight: 3
chapter: false
pre : " <b> 5.3. </b> "
---


## Tổng quan

Bài lab này hướng dẫn cách bảo vệ HTTP API bằng Amazon Cognito và API Gateway (HTTP API). Học viên sẽ tạo Cognito User Pool, App Client và cấu hình JWT authorizer trên API Gateway để các endpoint Lambda chỉ chấp nhận token Cognito hợp lệ.

## Yêu cầu trước

- Tài khoản AWS có quyền tạo Cognito, API Gateway, Lambda, IAM.
- Truy cập AWS Console hoặc AWS CLI.
- Một Lambda hoặc backend HTTP đơn giản (có thể dùng handler mẫu của workshop).

## Mục tiêu học viên

- Tạo và cấu hình Amazon Cognito User Pool và App Client.
- Cấu hình API Gateway (HTTP API) với JWT authorizer trỏ tới Cognito User Pool.
- Bảo vệ endpoint và kiểm thử truy cập bằng token Cognito.
- Tích hợp luồng đăng nhập từ frontend để gọi API được bảo vệ.

## Các bước lab (tóm tắt)

1. Tạo Cognito User Pool
   - Sử dụng Console hoặc AWS CLI để tạo User Pool (email làm username).
   - Bật đăng ký và tạo một user test.
2. Tạo App Client
   - Tạo App Client (không dùng client secret cho SPA) và cấu hình callback/logout URLs cho frontend.
3. Cấu hình domain (tuỳ chọn)
   - Dùng Cognito hosted domain hoặc custom domain qua Route 53.
4. Triển khai/chuẩn bị backend API
   - Đảm bảo Lambda function(s) có sẵn và có thể được gọi bởi API Gateway.
5. Tạo API Gateway (HTTP API)
   - Tạo HTTP API và thêm integration tới Lambda backend.
   - Thêm route (ví dụ: `POST /upload` hoặc `GET /items`).
6. Thêm JWT Authorizer
   - Trong API Gateway, tạo JWT authorizer tham chiếu issuer của Cognito và audience (App Client ID).
   - Bảo vệ route bằng JWT authorizer.
7. Kiểm thử luồng xác thực
   - Dùng Cognito hosted UI để đăng nhập và lấy ID/Access token, hoặc sử dụng Admin Initiate Auth API cho user test.
   - Gọi endpoint được bảo vệ với header `Authorization: Bearer <access_token>`.
8. Tích hợp từ frontend
   - Dùng `@aws-amplify/auth` hoặc `fetch` để đăng nhập Cognito và đính token vào các request.

## Kiểm thử & xử lý sự cố

- Kiểm tra `aud` (audience) trong token khớp với App Client ID.
- Kiểm tra cấu hình CORS trên API Gateway cho gọi từ trình duyệt.
- Xem CloudWatch Logs cho Lambda và API Gateway để tìm lỗi.

## Dọn dẹp

- Xoá Cognito User Pool, App Client và các tài nguyên API Gateway khi hoàn tất.
