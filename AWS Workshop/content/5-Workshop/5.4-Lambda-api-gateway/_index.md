---
title: "Lambda + API Gateway"
weight: 4
chapter: false
pre : " <b> 5.4. </b> "
---

Overview

This lab demonstrates how to build and deploy Lambda-backed HTTP APIs using Amazon API Gateway (HTTP API). Students will create a production-representative Lambda service (Node.js), integrate it with HTTP API routes, configure networking so Lambda can access an EC2-hosted SQL Server in a private subnet, secure credentials with Secrets Manager, and add observability (CloudWatch + X-Ray). The lab also covers IAM roles, CORS, payload format versions, cold-start considerations and deployment examples using AWS CLI / PowerShell.

Prerequisites

- AWS account with permission to create Lambda, API Gateway, IAM roles, CloudWatch, VPC resources and Secrets Manager.
- AWS CLI v2 (or PowerShell configured) and optional SAM/Serverless framework for local testing.
- Node.js (LTS) for function development and bundling.

Architecture notes

- Frontend (Vercel) calls API Gateway (HTTP API) endpoints.
- API Gateway routes requests to Lambda functions (Node.js). When Lambdas need to access SQL Server on EC2 (private subnet), configure Lambda to run in the same VPC subnets and allow network access via Security Groups and SSM if needed.
- Credentials (DB user/password) are stored in Secrets Manager; Lambda retrieves them at runtime (with IAM permission `secretsmanager:GetSecretValue`).

Detailed steps

1) Prepare Lambda execution role (IAM)

- Create a role with a trust policy for Lambda and attach the following minimal managed policies or inline policies:

Example trust policy (lambda assume role):

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

Attach policies (examples):

- `AWSLambdaBasicExecutionRole` (CloudWatch Logs)
- Inline policy for Secrets Manager + ENI/VPC actions (example):

```json
{
   "Version": "2012-10-17",
   "Statement": [
      {"Effect":"Allow","Action":["secretsmanager:GetSecretValue","secretsmanager:DescribeSecret"],"Resource":"arn:aws:secretsmanager:<region>:<account-id>:secret:<your-secret>"},
      {"Effect":"Allow","Action":["ec2:CreateNetworkInterface","ec2:DescribeNetworkInterfaces","ec2:DeleteNetworkInterface"],"Resource":"*"}
   ]
}
```

PowerShell / AWS CLI example to create role and attach policy (PowerShell):

```powershell
# create role
$trust = '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"Service":"lambda.amazonaws.com"},"Action":"sts:AssumeRole"}]}'
aws iam create-role --role-name LearningHubLambdaRole --assume-role-policy-document $trust

# attach managed policy
aws iam attach-role-policy --role-name LearningHubLambdaRole --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

# put inline policy for secrets + ENI
# save the inline JSON to lambda-secrets-policy.json locally then run:
aws iam put-role-policy --role-name LearningHubLambdaRole --policy-name LambdaSecretsPolicy --policy-document file://lambda-secrets-policy.json
```

2) Build and package Lambda (Node.js)

- Project layout (example):

   lambda/
      package.json
      index.js
      node_modules/

- Use a bundler (esbuild/webpack) or `npm install --production` and zip the folder.

PowerShell example to package:

```powershell
cd lambda
npm install --production
Compress-Archive -Path * -DestinationPath ..\lambda-package.zip
```

3) Create Lambda function (CLI)

```powershell
aws lambda create-function --function-name learninghub-api-handler \
   --runtime nodejs18.x --handler index.handler \
   --zip-file fileb://lambda-package.zip \
   --role arn:aws:iam::<account-id>:role/LearningHubLambdaRole \
   --timeout 30 --memory-size 512
```

If Lambda needs DB access in private subnet, update function configuration to include VPC config (subnet IDs + security group IDs):

```powershell
aws lambda update-function-configuration --function-name learninghub-api-handler --vpc-config SubnetIds=subnet-aaa,subnet-bbb,SecurityGroupIds=sg-xxxx
```

Notes on VPC:

- When Lambda runs in a VPC it creates ENIs in the subnets; this can increase cold-start time. Keep at least two ENI-capable subnets (private) available.
- If Lambda needs internet access (e.g., to call external APIs), ensure private subnets have a route to a NAT Gateway in a public subnet.

4) Store DB credentials in Secrets Manager and grant Lambda access

Create secret (PowerShell):

```powershell
aws secretsmanager create-secret --name learninghub/sqlserver --secret-string '{"username":"dbuser","password":"P@ssw0rd","host":"10.0.1.10","port":"1433"}'
```

Attach IAM permission (see step 1) so Lambda can `GetSecretValue` for that secret.

5) Create API Gateway (HTTP API) and integrate with Lambda

Create HTTP API (CLI):

```powershell
$api=$(aws apigatewayv2 create-api --name learninghub-api --protocol-type HTTP --output json)
$apiId=(ConvertFrom-Json $api).ApiId

# create integration to Lambda
$lambdaArn = "arn:aws:lambda:<region>:<account-id>:function:learninghub-api-handler"
$integration=$(aws apigatewayv2 create-integration --api-id $apiId --integration-type AWS_PROXY --integration-uri $lambdaArn --payload-format-version 2.0 --output json)
$integrationId=(ConvertFrom-Json $integration).IntegrationId

# create a route
aws apigatewayv2 create-route --api-id $apiId --route-key "GET /status" --target "integrations/$integrationId"

# add permission so API Gateway can invoke Lambda
aws lambda add-permission --function-name learninghub-api-handler --statement-id apigw-invoke --action lambda:InvokeFunction --principal apigateway.amazonaws.com --source-arn arn:aws:execute-api:<region>:<account-id>:$apiId/*/*

# deploy
aws apigatewayv2 create-stage --api-id $apiId --stage-name prod --auto-deploy
```

Notes:

- Use `payload-format-version` 2.0 for HTTP API; event shape differs from REST API.
- `integration-type AWS_PROXY` maps the entire HTTP request to Lambda event.

6) Configure CORS (HTTP API)

You can enable CORS in console or with CLI using `update-api` to set `CorsConfiguration`:

```powershell
$cors='{"AllowOrigins":["https://learninghub.example.com"],"AllowMethods":["GET","POST","OPTIONS"],"AllowHeaders":["Content-Type","Authorization"],"MaxAge":3600}'
aws apigatewayv2 update-api --api-id $apiId --cors-configuration $cors
```

7) Test the endpoint

PowerShell example:

```powershell
Invoke-RestMethod -Method Get -Uri "https://$apiId.execute-api.<region>.amazonaws.com/status"
```

If your route is protected (e.g., by Cognito authorizer) attach token header: `-Headers @{ Authorization = "Bearer $token" }`.

8) Observability & best practices

- CloudWatch Logs: set log retention, enable structured logging (JSON) from Lambda.
- X-Ray: enable active tracing on the Lambda function for distributed tracing.
- Metrics & Alarms: create alarms for Errors, Throttles, Duration.
- API access logs: configure stage-level access logging for HTTP API via `accessLogSettings` in `create-stage`/`update-stage`.

9) Security

- Use Secrets Manager for DB credentials; avoid environment variables with plaintext secrets.
- Scope IAM policies to least privilege and specific ARNs when possible.
- When running Lambda in VPC, ensure security group rules allow outbound to the DB (port 1433) and inbound rules on the DB EC2 allow only Lambda SGs.

10) Cleanup

```powershell
# delete stage and API
aws apigatewayv2 delete-api --api-id $apiId
# delete lambda
aws lambda delete-function --function-name learninghub-api-handler
# delete role inline policy, detach managed, then delete role
aws iam delete-role-policy --role-name LearningHubLambdaRole --policy-name LambdaSecretsPolicy
aws iam detach-role-policy --role-name LearningHubLambdaRole --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
aws iam delete-role --role-name LearningHubLambdaRole
```

Appendix: sample minimal Lambda (Node.js)

```js
// index.js
const sql = require('mssql'); // if using mssql package
exports.handler = async (event) => {
   // parse request, read secret, connect to SQL Server, run query
   return {
      statusCode: 200,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ message: 'OK', request: event })
   };
};
```

References

- AWS Lambda Developer Guide
- Amazon API Gateway (HTTP API) Developer Guide
- AWS Secrets Manager Developer Guide

