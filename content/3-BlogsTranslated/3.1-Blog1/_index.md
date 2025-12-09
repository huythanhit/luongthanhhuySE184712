---
title: "Blog 1"
weight: 1
chapter: false
pre: " <b> 3.1. </b> "
---

# Accelerate AI development with Amazon Bedrock API keys

by Sofian Hamiti, Ajit Mahareddy, Massimiliano Angelino, Huong Nguyen, and Nakul Vankadari Ramesh on 08 JUL 2025 in Amazon Bedrock, Amazon Machine Learning, Announcements, Artificial Intelligence, Foundation models Permalink  Comments  Share

Today, we’re excited to announce a significant improvement to the developer experience of Amazon Bedrock: API keys. API keys provide a new way to access the Amazon Bedrock APIs, streamlining the authentication process so that developers can focus on building rather than configuration.

CamelAI is an open-source, modular framework for building intelligent multi-agent systems for data generation, world simulation, and task automation.

“As a startup with limited resources, streamlined customer onboarding is critical to our success. The Amazon Bedrock API keys enable us to onboard enterprise customers in minutes rather than hours. With Bedrock, our customers can quickly provision access to leading AI models and seamlessly integrate them into CamelAI,”

said Miguel Salinas, CTO, CamelAI.
In this post, explore how API keys work and how you can start using them today.

---

## API key authentication
Amazon Bedrock now provides API key access to streamline integration with tools and frameworks that expect API key-based authentication. The Amazon Bedrock and Amazon Bedrock runtime SDKs support API key authentication for methods including on-demand inference, provisioned throughput inference, model fine-tuning, distillation, and evaluation.

The diagram compares the default authentication process to Amazon Bedrock (in orange) with the API keys approach (in blue). In the default process, you must create an identity in AWS IAM Identity Center or AWS IAM, attach IAM policies to provide permissions to perform API operations, and generate credentials, which you can then use to make API calls. The grey boxes in the diagram highlight the steps that Amazon Bedrock now streamlines when generating an API key. Developers can now authenticate and access Amazon Bedrock APIs with minimal setup overhead.

You can generate API keys in the Amazon Bedrock console, choosing between two types.

Short-term API keys use the IAM permissions from your current IAM principal and expire when your account’s session ends or can last up to 12 hours, whichever ends first. Short-term API keys use AWS Signature Version 4 for authentication. For continuous application use, you can implement API key refreshing following those examples and using your credential provider of choice.

When you create a long-term API key, Amazon Bedrock automatically creates an IAM user and associates the key with it. You can set expiration times ranging from 1 day to no expiration. Amazon Bedrock attaches the AmazonBedrockLimitedAccess managed policy to the IAM user, and you can modify permissions as needed through the IAM service. These keys are specific to Amazon Bedrock and cannot be used with other AWS services. We recommend using temporary AWS IAM credentials or short-term API keys for setups that require a higher level of security, and long-term keys with expiration dates for exploring Amazon Bedrock.

## Making Your First API Call

Once you have access to foundation models, getting started with Amazon Bedrock API key is straightforward. Here’s how to make your first API call using the AWS SDK for Python (Boto3 SDK) and API keys:
**Generate an API key**
To generate an API key, follow these steps:

1.Sign in to the AWS Management Console and open the Amazon Bedrock console
2.In the left navigation panel, select API keys
3.Choose either Generate short-term API key or Generate long-term API key
4.For long-term keys, set your desired expiration time and optionally configure advanced permissions
5.Choose Generate and copy your API key
**Set Your API Key as Environment Variable**

You can set your API key as an environment variable so that it’s automatically recognized when you make API requests:


```yaml
# To set the API key as an environment variable, you can open a terminal and run the following command:
export AWS_BEARER_TOKEN_BEDROCK=<YOUR API KEY HERE>
---
```



The Boto3 and AWS JavaScript SDKs automatically detect your environment variable when you create an Amazon Bedrock client. Make sure you use the latest SDK version.

**Make Your First API Call**
You can now make API calls to Amazon Bedrock in multiple ways:
1.Using curl
```yaml
curl -X POST "https://bedrock-runtime.us-east-1.amazonaws.com/model/us.anthropic.claude-3-5-haiku-20241022-v1:0/converse" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $AWS_BEARER_TOKEN_BEDROCK" \
  -d '{
    "messages": [
        {
            "role": "user",
            "content": [{"text": "Hello"}]
        }
    ]
  }'
```
2.Using the Boto3 SDK for Amazon Bedrock:
```yaml
import boto3

# Create an Amazon Bedrock client
client = boto3.client(
    service_name="bedrock-runtime",
    region_name="us-east-1"     # If you've configured a default region, you can omit this line
) 

# Define the model and message
model_id = "us.anthropic.claude-3-5-haiku-20241022-v1:0"
messages = [{"role": "user", "content": [{"text": "Hello"}]}]
   
response = client.converse(
    modelId=model_id,
    messages=messages,
)

# Print the response
print(response['output']['message']['content'][0]['text'])
```
3.You can also use native libraries like Python Requests:
```yaml
import requests
import os

url = "https://bedrock-runtime.us-east-1.amazonaws.com/model/us.anthropic.claude-3-5-haiku-20241022-v1:0/converse"

payload = {
    "messages": [
        {
            "role": "user",
            "content": [{"text": "Hello"}]
        }
    ]
}

headers = {
    "Content-Type": "application/json",
    "Authorization": f"Bearer {os.environ['AWS_BEARER_TOKEN_BEDROCK']}"
}

response = requests.request("POST", url, json=payload, headers=headers)

print(response.text)
```
## Bridging developer experience and enterprise security requirements 

As an administrator, you can enable short-term API keys to streamline user onboarding for Amazon Bedrock foundation models while ensuring a higher level of security. These keys leverage AWS Signature Version 4 and existing IAM principals, maintaining your established access controls.

For audit and compliance purposes, all API calls are logged in AWS CloudTrail. API keys are passed as authorization headers to API requests and are not logged.

**Controlling permissions for API keys**
You can use Service Control Policies (SCPs) with Amazon Bedrock condition keys to customize API key generation and usage to meet your organization’s requirements.
```yaml
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Action": "bedrock:CallWithBearerToken",
      "Resource": "*"
    }
  ]
}
```
You can also enforce expiration limits on long-term API keys to ensure regular rotation. The following SCP prevents creation of keys with lifespans exceeding 30 days:

```yaml
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Deny",
            "Action": "iam:CreateServiceSpecificCredential",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:ServiceSpecificCredentialServiceName": "bedrock.amazonaws.com" 
                },
                "NumericGreaterThanEquals": {
                    "iam:ServiceSpecificCredentialAgeDays": "30" 
                }
            }
        }
    ]
}
```
Refer to the Amazon Bedrock documentation for additional SCP examples.
## Conclusion
Amazon Bedrock API keys can be used in the commercial AWS regions Amazon Bedrock is available. To learn more about API keys in Amazon Bedrock, visit the API Keys documentation in the Amazon Bedrock user guide.

Give API keys a try in the Amazon Bedrock console today and send feedback to AWS re:Post for Amazon Bedrock or through your usual AWS Support contacts.


---