---
title: "Tạo và cấu hình Cognito & API Gateway"
weight: 2
chapter: false
pre: " <b> 5.3.1. </b> "
---

## Mục tiêu
Hướng dẫn từng bước tạo và cấu hình Amazon Cognito (User Pool + App Client, tùy chọn Identity Pool) và Amazon API Gateway (HTTP API) sử dụng Cognito làm bộ xác thực JWT. Bao gồm hướng dẫn bằng Console, AWS CLI/PowerShell, lưu ý IAM và ví dụ kiểm thử.

> Giả định kiến trúc: frontend (Vercel) gọi API Gateway (HTTP API) -> Gateway dùng Cognito JWT authorizer để xác thực -> route tới Lambda xử lý nghiệp vụ. SQL Server chạy trên EC2 trong private subnet và Lambda truy cập khi cần.

---

## 1. Tạo Cognito User Pool (Console)
1. Vào AWS Console -> Amazon Cognito -> "Manage User Pools" -> "Create a user pool".
2. Đặt tên, ví dụ `learninghub-userpool`.
3. Chọn "Step through settings" để tùy chỉnh. Khuyến nghị:
   - Attributes: bắt buộc `email`; thêm `name` nếu cần.
   - Policies: cấu hình độ mạnh mật khẩu phù hợp.
   - MFA & verification: bật xác thực email trong demo (tùy chọn).
   - App clients: tạo App client không có secret nếu dùng SPA (bỏ chọn "Generate client secret").
   - Callback URLs: thêm URL frontend (ví dụ `https://learninghub.example.com`) cho Hosted UI.
4. Lưu pool.

Ghi chú:
- Dùng App client không có secret cho SPA. Dùng secret cho backend-to-backend.
- Nếu cần, cấu hình domain cho Hosted UI ở App integration -> Domain name.

---

## 2. Tạo App Client (Console + CLI)
- Console: User Pool -> App clients -> "Add an app client". Đặt tên `learninghub-web-client`. Bỏ chọn "Generate client secret" cho ứng dụng chạy trên trình duyệt.

- CLI (PowerShell):

```powershell
# tạo app client (không có secret)
aws cognito-idp create-user-pool-client --user-pool-id <USER_POOL_ID> --client-name learninghub-web-client --no-generate-secret --output json
```

Ghi lại `ClientId` và `UserPoolId` để dùng sau.

---

## 3. (Tùy chọn) Cấu hình Hosted UI / Domain
1. User Pool -> App integration -> Domain name, tạo domain Cognito (ví dụ `learninghub-demo-<suffix>`).
2. Cấu hình callback và sign-out URLs trong App client settings.
3. Bật OAuth flows cần thiết (Authorization code grant hoặc Implicit). Khuyến nghị Authorization code + PKCE.

---

## 4. Tạo Identity Pool (tùy chọn)
Khi cần cấp credential AWS tạm thời (ví dụ upload S3 từ client) thì dùng Identity Pool:
- Console: Cognito -> Federated Identities -> Create identity pool -> enable "Authenticated identities" -> chọn roles.

CLI (PowerShell):
```powershell
aws cognito-identity create-identity-pool --identity-pool-name learninghub-identitypool --allow-unauthenticated-identities false --cognito-identity-providers ProviderName=cognito-idp.<region>.amazonaws.com/<USER_POOL_ID>,ClientId=<CLIENT_ID>
```

Sẽ trả về IdentityPoolId; cần cấu hình IAM roles và trust policy cho pool.

---

## 5. Tạo IAM roles cho Cognito (Identity Pool) và Lambda
- Nếu dùng Identity Pool, tạo role `CognitoAuthRole` (cho authenticated) và `CognitoUnauthRole` nếu cần. Attach policy tối thiểu (S3 GetObject/PutObject nếu cho phép upload trực tiếp).

- Lambda execution role: cấp quyền Lambda cần (S3, Secrets Manager, EC2 via SSM,...).

Ví dụ trust policy cho role do Cognito identity pool assume:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {"Federated": "cognito-identity.amazonaws.com"},
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {"cognito-identity.amazonaws.com:aud": "<IDENTITY_POOL_ID>"},
        "ForAnyValue:StringLike": {"cognito-identity.amazonaws.com:amr": "authenticated"}
      }
    }
  ]
}
```

---

## 6. Tạo API Gateway (HTTP API) và cấu hình Cognito Authorizer
Dùng HTTP API. Cấu hình JWT authorizer để xác thực Cognito token.

### Bước trên Console
1. API Gateway -> HTTP APIs -> Create -> Build.
2. Add integration -> Lambda -> chọn Lambda function (hoặc tạo placeholder).
3. Tạo routes (ví dụ `GET /courses`, `POST /exams`) và attach integration.
4. Authorization -> Add authorizer -> JWT. Điền:
   - **Issuer**: `https://cognito-idp.<region>.amazonaws.com/<USER_POOL_ID>`
   - **Audience**: App Client ID (client_id)
5. Gán authorizer cho các route cần bảo vệ.

### CLI (PowerShell) ví dụ
```powershell
$api=$(aws apigatewayv2 create-api --name learninghub-api --protocol-type HTTP --target arn:aws:lambda:<region>:<account-id>:function:YourFunction --output json)
$apiId=$(echo $api | ConvertFrom-Json).ApiId

aws apigatewayv2 create-authorizer --api-id $apiId --authorizer-type JWT --name CognitoJWTAuth --identity-source "$request.header.Authorization" --jwt-configuration "{\"Issuer\":\"https://cognito-idp.<region>.amazonaws.com/<USER_POOL_ID>\",\"Audience\":[\"<CLIENT_ID>\"]}"
```

Gán authorizer cho route:
```powershell
aws apigatewayv2 update-route --api-id $apiId --route-key "GET /courses" --authorization-type JWT --authorizer-id <AUTHORZER_ID>
```

Lưu ý: HTTP API chấp nhận header `Authorization: Bearer <id_token>`.

---

## 7. Cấp quyền API Gateway invoke Lambda
```powershell
aws lambda add-permission --function-name YourFunction --statement-id apigw-invoke --action lambda:InvokeFunction --principal apigateway.amazonaws.com --source-arn arn:aws:execute-api:<region>:<account-id>:${apiId}/*/*/*
```

---

## 8. CORS
- Cấu hình CORS cho HTTP API trong console hoặc trả headers `Access-Control-Allow-Origin` từ integration.
- Với frontend `https://learninghub.example.com`, thêm origin này vào CORS allow list (production không nên dùng `*`).

---

## 9. Kiểm thử (Đăng ký, Đăng nhập, gọi API)
1. Tạo user thử trong User Pool (Console -> Users -> Create user) hoặc bật self-sign-up.
2. Dùng Hosted UI hoặc CLI để lấy token.

CLI (PowerShell) ví dụ để lấy token:
```powershell
aws cognito-idp admin-initiate-auth --user-pool-id <USER_POOL_ID> --client-id <CLIENT_ID> --auth-flow ADMIN_NO_SRP_AUTH --auth-parameters USERNAME="testuser",PASSWORD="P@ssw0rd" --output json
```
Kết quả chứa `AuthenticationResult.IdToken` và `AccessToken`.

Gọi API:
```powershell
$token = "<ID_TOKEN_FROM_AUTH>"
Invoke-RestMethod -Method Get -Uri "https://<api-id>.execute-api.<region>.amazonaws.com/courses" -Headers @{ Authorization = "Bearer $token" }
```

Nếu nhận 401: kiểm tra issuer, audience, token (chưa hết hạn) và route đã gán authorizer chưa.

---

## 10. Khắc phục sự cố nhanh
- 401: xác nhận `Issuer` chính xác và `Audience` chứa client id.
- 403 Invoke Lambda: kiểm tra Lambda resource policy (`aws lambda add-permission`).
- Token: kiểm tra token bằng jwt.io.
- CORS: kiểm tra header `Access-Control-Allow-Origin`.


## 11. Bảo mật
- SPAs: dùng Authorization Code Grant + PKCE thay vì Implicit.
- Không lưu client secret trong ứng dụng trình duyệt.
- Scope `Resource` trong IAM policies cho production.
- Thiết lập thời gian sống token phù hợp và rotation khi cần.

---


