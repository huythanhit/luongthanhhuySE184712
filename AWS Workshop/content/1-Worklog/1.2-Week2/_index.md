title: "Week 2 Worklog"
weight: 1
chapter: false
pre: " <b> 1.2. </b> "

### Week 2 — Objectives

* Get hands-on with S3 static website hosting, RDS (MySQL) and Route53 basics.
* Learn how to connect an EC2 client to an RDS instance and configure IAM/Security Groups for DB access.

### Planned tasks this week
| Day | Task                                                                                                                                                                                                 | Start Date | Completion Date | Reference Material                        |
| --- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- | --------------- | ----------------------------------------- |
| 2   | - Create an S3 bucket to host a static website<br>- Upload demo HTML/CSS files to the bucket                                                                                                        | 15/09/2025 | 15/09/2025      | [AWS Journey](https://cloudjourney.awsstudygroup.com/)                               |
| 3   | - Enable Static Website Hosting on the S3 bucket<br>- Configure bucket policy to allow public read for site assets<br>- Access the site via the S3 website endpoint                               | 16/09/2025 | 16/09/2025      | [AWS Journey](https://cloudjourney.awsstudygroup.com/)                               |
| 4   | - Launch an RDS MySQL instance (Free Tier for lab)<br>- Configure VPC Security Group to allow connections from application subnets/EC2<br>- Record endpoint and credentials                         | 17/09/2025 | 17/09/2025      | [AWS Journey](https://cloudjourney.awsstudygroup.com/)                               |
| 5   | - Launch an EC2 instance and install MySQL client/tools<br>- From EC2, connect to the RDS endpoint using CLI/mysql client and create a test database/table                                    | 18/09/2025 | 18/09/2025      | [AWS Journey](https://cloudjourney.awsstudygroup.com/)                               |
| 6   | - Learn Route53 basics and create a Hosted Zone<br>- Create A / CNAME records to point a domain to the S3 static site<br>- Verify domain access to the website                                   | 19/09/2025 | 19/09/2025      | [AWS Journey](https://cloudjourney.awsstudygroup.com/)                               |


### Week 2 — Outcomes

* Built and hosted a static website in S3 and verified public access via the S3 endpoint.
* Configured Route53 to map a domain to the S3 site (A/CNAME) and validated domain access.
* Created an RDS MySQL instance and connected to it from an EC2 client; recorded endpoint and credentials for testing.
* Learned to configure Security Groups and minimal IAM roles relevant to RDS and S3.
* Recommended next topics for Week 3: CloudFront, DynamoDB, and ElastiCache for caching and scale testing.

***

