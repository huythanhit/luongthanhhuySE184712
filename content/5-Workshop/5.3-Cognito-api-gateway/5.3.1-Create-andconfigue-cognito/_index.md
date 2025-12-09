---
title: "Create and configure Cognito & API Gateway"
weight: 2
chapter: false

---

## Purpose
This guide shows step-by-step how to create and configure Amazon Cognito (User Pool + App Client, optional Identity Pool) and an Amazon API Gateway HTTP API that uses Cognito as a JWT authorizer. It includes console steps, AWS CLI/PowerShell commands, IAM notes and examples for testing.

> Architecture assumption: frontend (Vercel) calls API Gateway (HTTP API) -> Gateway authorizer validates Cognito JWTs -> routes to Lambda (business logic). SQL Server runs on EC2 in a private subnet and is accessed by Lambda when needed.

---

## 1. Create a Cognito User Pool (Console)
1. Sign in to AWS Console -> Amazon Cognito -> "Manage User Pools" -> "Create a user pool".
2. Choose a name, e.g. `learninghub-userpool`.
3. Choose **Review defaults** or **Step through settings** for custom options. Recommended custom settings:
   - Attributes: keep `email` as required; add `name` if you need display names.
   - Policies: password strength as required for your environment.
   - MFA & verifications: Email verification enabled for workshop demos (optional).
   - App clients: create at least one App client with *no secret* if used by SPA or mobile (uncheck "Generate client secret").
   - App client callback URLs: add your frontend URL(s) (e.g., `https://learninghub.example.com`) for Hosted UI flows.
4. Save pool.

Notes:
- For SPAs use an App client without a secret. For backend-to-backend you may use a client secret.
- Hosted UI: you can configure a domain under "App integration -> Domain name" to use Cognito's Hosted UI.

---

## 2. Create an App Client (Console + CLI)
- Console: In User Pool -> App clients -> "Add an app client". Name it like `learninghub-web-client`. Uncheck "Generate client secret" for browser-based apps.

- AWS CLI (PowerShell):

```powershell
# create app client (no secret)
aws cognito-idp create-user-pool-client --user-pool-id <USER_POOL_ID> --client-name learninghub-web-client --no-generate-secret --output json
```

Record the `ClientId` and `UserPoolId` for later.

---

## 3. (Optional) Configure a Hosted UI / Domain
1. In User Pool -> App integration -> Domain name, create a Cognito domain (e.g. `learninghub-demo-<suffix>`).
2. Configure callback and sign-out URLs under App client settings.
3. Enable OAuth flows needed (Authorization code grant or Implicit). For SPAs you may use implicit (but Authorization code grant + PKCE is recommended).

---

## 4. Create a Cognito Identity Pool (optional)
Use an identity pool when you need AWS temporary credentials (e.g., direct S3 access from client). Steps:
- Console: Cognito -> Federated Identities -> Create identity pool -> enable "Authenticated identities" -> choose roles for authenticated/unauthenticated.

CLI example (PowerShell):
```powershell
aws cognito-identity create-identity-pool --identity-pool-name learninghub-identitypool --allow-unauthenticated-identities false --cognito-identity-providers ProviderName=cognito-idp.<region>.amazonaws.com/<USER_POOL_ID>,ClientId=<CLIENT_ID>
```

You'll receive an IdentityPoolId; configure IAM roles and trust policies to allow the pool to assume roles.

---

## 5. Create IAM roles for Cognito (Identity Pool) and Lambda
- If you use Identity Pool, create two roles: `CognitoAuthRole` (for authenticated users) and `CognitoUnauthRole` (for unauthenticated, if enabled). Attach minimal policies (S3 GetObject/PutObject if you use direct S3 uploads).

- Lambda execution role: create an IAM role that allows Lambda to access S3, Secrets Manager, EC2 (via SSM) or other services required by your backend.

Example trust policy for a role assumed by Cognito identity pool (snippet):

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

## 6. Create API Gateway (HTTP API) and configure Cognito Authorizer
We use HTTP API (faster, lower-cost). Configure a JWT authorizer that validates Cognito tokens.

### Console steps
1. API Gateway -> HTTP APIs -> Create -> Build.
2. Select "Add integration" -> Lambda -> choose your Lambda function (or create placeholder).
3. Create routes (e.g., `GET /courses`, `POST /exams`). Attach integration.
4. Under "Authorization" -> Add authorizer -> choose JWT. Fill these fields:
   - **Identity provider**: choose Cognito.
   - **Issuer**: `https://cognito-idp.<region>.amazonaws.com/<USER_POOL_ID>`
   - **Audience**: your App Client ID (client_id) — for ID tokens use `client_id` as audience. Some setups use the user pool's `aud` claim.
5. Attach the JWT authorizer to routes that require authentication.
6. Deploy (Auto-deploy for HTTP API is default). Note the invoke URL (e.g., `https://<api-id>.execute-api.<region>.amazonaws.com`).

### CLI example (create authorizer)
```powershell
# create an HTTP API
$api=$(aws apigatewayv2 create-api --name learninghub-api --protocol-type HTTP --target arn:aws:lambda:<region>:<account-id>:function:YourFunction --output json)
$apiId=$(echo $api | ConvertFrom-Json).ApiId

# create JWT authorizer
aws apigatewayv2 create-authorizer --api-id $apiId --authorizer-type JWT --name CognitoJWTAuth --identity-source "$request.header.Authorization" --jwt-configuration "{\"Issuer\":\"https://cognito-idp.<region>.amazonaws.com/<USER_POOL_ID>\",\"Audience\":[\"<CLIENT_ID>\"]}"
```

Attach the authorizer to a route (replace routeId as necessary):
```powershell
aws apigatewayv2 update-route --api-id $apiId --route-key "GET /courses" --authorization-type JWT --authorizer-id <AUTHORZER_ID>
```

Notes:
- HTTP API expects JWT `Authorization` header: `Authorization: Bearer <id_token>`.
- Use `id_token` for user info (claims). Access tokens may also be acceptable depending on configuration.

---

## 7. API Gateway -> Lambda permissions
Add permission for API Gateway to invoke the Lambda:

```powershell
aws lambda add-permission --function-name YourFunction --statement-id apigw-invoke --action lambda:InvokeFunction --principal apigateway.amazonaws.com --source-arn arn:aws:execute-api:<region>:<account-id>:${apiId}/*/*/*
```

---

## 8. CORS
If your frontend is hosted on `https://learninghub.example.com`, add CORS to your routes:
- For HTTP API you can configure CORS in console or set `Access-Control-Allow-Origin` header in integration responses.
- Example allowed origins: `https://learninghub.example.com` or `*` for quick demos (not recommended for production).

---

## 9. Test flow (Sign-up, Sign-in, call API)
1. Create a test user in the User Pool (Console -> Users -> Create user) or use self-sign-up if enabled.
2. Use Hosted UI or AWS CLI to authenticate and get tokens.

CLI example (AdminInitiateAuth) to get tokens (PowerShell):
```powershell
aws cognito-idp admin-initiate-auth --user-pool-id <USER_POOL_ID> --client-id <CLIENT_ID> --auth-flow ADMIN_NO_SRP_AUTH --auth-parameters USERNAME="testuser",PASSWORD="P@ssw0rd" --output json
```
Response contains `AuthenticationResult.IdToken` and `AccessToken`.

3. Call API with bearer token:
```powershell
$token = "<ID_TOKEN_FROM_AUTH>"
Invoke-RestMethod -Method Get -Uri "https://<api-id>.execute-api.<region>.amazonaws.com/courses" -Headers @{ Authorization = "Bearer $token" }
```

If you receive 401: check authorizer configuration (issuer/audience), ensure token is not expired and your route has the authorizer attached.

---

## 10. Troubleshooting tips
- 401 Unauthorized: verify `Issuer` URL exactly matches `https://cognito-idp.<region>.amazonaws.com/<USER_POOL_ID>` and `Audience` contains the client id used to get the token.
- 403 Forbidden when invoking Lambda: check Lambda resource policy and `add-permission` invocation.
- Token issues: verify token type (ID token vs Access token) and its claims using jwt.io.
- CORS errors: ensure API returns proper `Access-Control-Allow-Origin` header.



---

## 11. Security considerations
- Use Authorization Code Grant + PKCE for SPAs to avoid implicit flow security issues.
- Do not embed client secrets in browser apps.
- Scope `Resource` ARNs in IAM policies in production.
- Set appropriate token expiration and rotation policies.

---


