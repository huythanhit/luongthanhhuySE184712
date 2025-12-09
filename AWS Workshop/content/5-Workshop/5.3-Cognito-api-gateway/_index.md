---
title: "Cognito + API Gateway"
weight: 3
chapter: false
pre : " <b> 5.3. </b> "
---


Overview

This lab shows how to secure HTTP APIs using Amazon Cognito and API Gateway (HTTP API). Students will create a Cognito User Pool, an App Client, and configure a JWT authorizer in API Gateway so Lambda-backed endpoints require a valid Cognito token.

Prerequisites

- AWS account with permission to create Cognito, API Gateway, Lambda, IAM roles.
- AWS CLI or Console access.
- A simple Lambda or HTTP backend (the workshop provides a sample handler).

Learning objectives

- Create and configure an Amazon Cognito User Pool and App Client.
- Configure an API Gateway HTTP API with JWT authorizer pointing to the Cognito User Pool.
- Protect endpoints and test access using Cognito tokens.
- Integrate login flow from frontend to call protected APIs.

Lab steps (high level)

1. Create a Cognito User Pool
   - Use the Console or AWS CLI to create a User Pool with email as username.
   - Enable sign-up and create a test user.
2. Create an App Client
   - Create an App Client (no client secret for single-page apps) and configure callback/logout URLs for the frontend.
3. Configure a domain (optional)
   - Use a Cognito hosted domain or bring your own via Route 53.
4. Deploy or identify your API backend
   - Ensure Lambda function(s) exist and are callable by API Gateway.
5. Create an API Gateway (HTTP API)
   - Create HTTP API and add an integration to the Lambda backend.
   - Add a route (e.g. `POST /upload` or `GET /items`).
6. Add JWT Authorizer
   - In API Gateway, create a JWT authorizer referencing the Cognito User Pool issuer and audience (App Client ID).
   - Protect the route using the JWT authorizer.
7. Test authentication flow
   - Use the Cognito hosted UI to sign in and obtain an ID/Access token, or use the Admin Initiate Auth API for a test user.
   - Call the protected endpoint with `Authorization: Bearer <access_token>`.
8. Integrate from frontend
   - Use `@aws-amplify/auth` or `fetch` to call Cognito login and attach the token to requests.

Testing & troubleshooting

- Verify token audience (aud) matches the App Client ID.
- Check CORS settings on API Gateway for browser calls.
- Inspect CloudWatch Logs for Lambda and API Gateway execution errors.

Cleanup

- Delete the Cognito User Pool, App Client, and API Gateway resources when finished.

References

- AWS Cognito Console
- API Gateway (HTTP API) JWT authorizers

