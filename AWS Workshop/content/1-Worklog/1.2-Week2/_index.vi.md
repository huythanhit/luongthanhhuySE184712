---
title: "Worklog Tuần 2"
weight: 1
chapter: false
pre: " <b> 1.2. </b> "
---



### Mục tiêu Tuần 2

* Thực hành hosting website tĩnh trên S3, làm quen RDS (MySQL) và Route53.
* Kiểm thử kết nối từ EC2 đến RDS và cấu hình Security Group / IAM liên quan.

### Công việc trong tuần
| Thứ | Công việc                                                                                                                                                                                   | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu                            |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ | --------------- | ----------------------------------------- |
| 2   | - Tạo S3 bucket để chứa website tĩnh<br>- Upload file HTML/CSS demo lên S3                                                                                                                  | 15/09/2025   | 15/09/2025      | [AWS Journey](https://cloudjourney.awsstudygroup.com/)                               |
| 3   | - Kích hoạt Static Website Hosting trên S3<br>- Cấu hình bucket policy cho phép public read cho file tĩnh<br>- Truy cập thử website qua endpoint S3                                           | 16/09/2025   | 16/09/2025      | [AWS Journey](https://cloudjourney.awsstudygroup.com/)                               |
| 4   | - Tạo RDS MySQL instance (Free Tier cho lab)<br>- Cấu hình VPC Security Group cho phép kết nối từ subnet/EC2 ứng dụng<br>- Ghi nhận endpoint và credential                                    | 17/09/2025   | 17/09/2025      | [AWS Journey](https://cloudjourney.awsstudygroup.com/)                               |
| 5   | - Tạo EC2 instance và cài MySQL client/tools<br>- Từ EC2 kết nối tới RDS bằng mysql client/CLI và tạo database/table kiểm thử                                                           | 18/09/2025   | 18/09/2025      | [AWS Journey](https://cloudjourney.awsstudygroup.com/)                               |
| 6   | - Tìm hiểu Route53, tạo Hosted Zone<br>- Thêm record A / CNAME để trỏ domain về S3 static site<br>- Kiểm tra truy cập website bằng domain                                                          | 19/09/2025   | 19/09/2025      | [AWS Journey](https://cloudjourney.awsstudygroup.com/)                               |


### Kết quả đạt được Tuần 2

* Xây dựng thành công website tĩnh trên S3 và kiểm tra truy cập công khai qua endpoint S3.
* Cấu hình Route53 để trỏ domain về S3 (A/CNAME) và xác minh truy cập bằng domain.
* Tạo RDS MySQL và kết nối từ EC2; ghi nhận endpoint và thông tin credential phục vụ testing.
* Nắm được cách cấu hình Security Group và IAM tối thiểu liên quan đến RDS & S3.
* Gợi ý chủ đề cho Tuần 3: CloudFront, DynamoDB và ElastiCache để mở rộng và tối ưu hiệu năng.

***


