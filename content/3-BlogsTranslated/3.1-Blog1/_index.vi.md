---
title: "Blog 1"
weight: 1
chapter: false
pre: " <b> 3.1. </b> "
---

# Tăng tốc phát triển AI với khóa API Amazon Bedrock


Bởi Sofian Hamiti , Ajit Mahareddy , Massimiliano Angelino , Hương Nguyễn , và Nakul Vankadari Ramesh trên08 THÁNG 7 NĂM 2025 trong Amazon Bedrock , Amazon Machine Learning , Thông báo , Trí tuệ nhân tạo , Mô hình Foundation, Liên kết cố định| Bình luận |Chia sẻ.
Hôm nay, chúng tôi vui mừng thông báo về một cải tiến đáng kể cho trải nghiệm nhà phát triển trên Amazon Bedrock : Khóa API. Khóa API cung cấp một cách mới để truy cập API Amazon Bedrock, đơn giản hóa quy trình xác thực để các nhà phát triển có thể tập trung vào việc xây dựng thay vì cấu hình.
CamelAI là một framework mô-đun, mã nguồn mở để xây dựng các hệ thống đa tác nhân thông minh cho việc tạo dữ liệu, mô phỏng thế giới và tự động hóa tác vụ. 
“Là một công ty khởi nghiệp với nguồn lực hạn chế, việc hợp lý hóa quy trình tiếp nhận khách hàng đóng vai trò then chốt cho thành công của chúng tôi. Khóa API Amazon Bedrock cho phép chúng tôi tiếp nhận khách hàng doanh nghiệp chỉ trong vài phút thay vì hàng giờ. Với Bedrock, khách hàng của chúng tôi có thể nhanh chóng cung cấp quyền truy cập vào các mô hình AI hàng đầu và tích hợp chúng một cách liền mạch vào CamelAI.”  Miguel Salinas, CTO, CamelAI cho biết.
Trong bài đăng này, hãy khám phá cách thức hoạt động của khóa API và cách bạn có thể bắt đầu sử dụng chúng ngày hôm nay .


---

## Xác thực bằng khóa API


Amazon Bedrock hiện cung cấp quyền truy cập bằng khóa API để hợp lý hóa việc tích hợp với các công cụ và framework mong đợi xác thực dựa trên khóa API . Các SDK Amazon Bedrock và Amazon Bedrock runtime hỗ trợ xác thực bằng khóa API cho các phương thức bao gồm suy luận theo yêu cầu (on-demand inference), suy luận thông lượng được cung cấp (provisioned throughput inference), tinh chỉnh mô hình (model fine-tuning), chưng cất (distillation), và đánh giá (evaluation) .
Sơ đồ so sánh quy trình xác thực mặc định của Amazon Bedrock (màu cam) với phương pháp khóa API (màu xanh). Trong quy trình mặc định, bạn phải tạo danh tính trong AWS IAM Identity Center hoặc AWS IAM , đính kèm các chính sách IAM để cấp quyền thực hiện các thao tác API và tạo thông tin xác thực, sau đó bạn có thể sử dụng thông tin này để thực hiện các lệnh gọi API. Các ô màu xám trong sơ đồ làm nổi bật các bước mà Amazon Bedrock hiện đã đơn giản hóa khi tạo khóa API. Giờ đây, các nhà phát triển có thể xác thực và truy cập API Amazon Bedrock với chi phí thiết lập tối thiểu.

Bạn có thể tạo khóa API trong bảng điều khiển Amazon Bedrock bằng cách chọn giữa hai loại.
Khóa API ngắn hạn  sử dụng quyền IAM từ chủ thể IAM hiện tại của bạn và hết hạn khi phiên làm việc của tài khoản kết thúc hoặc có thể kéo dài tối đa 12 giờ, tùy điều kiện nào kết thúc trước. Khóa API ngắn hạn sử dụng  AWS Signature Phiên bản 4  để xác thực. Để ứng dụng hoạt động liên tục, bạn có thể thực hiện làm mới khóa API theo các ví dụ đó và sử dụng nhà cung cấp thông tin xác thực bạn chọn .
Khi bạn tạo khóa API dài hạn , Amazon Bedrock sẽ tự động tạo một người dùng IAM và liên kết khóa đó với người dùng đó. Bạn có thể đặt thời gian hết hạn từ 1 ngày đến không hết hạn. Amazon Bedrock sẽ gắn chính sách được quản lý AmazonBedrockLimitedAccess vào người dùng IAM, và bạn có thể sửa đổi quyền khi cần thông qua dịch vụ IAM. Các khóa này dành riêng cho Amazon Bedrock và không thể sử dụng với các dịch vụ AWS khác. Chúng tôi khuyên bạn nên sử dụng thông tin xác thực AWS IAM tạm thời hoặc khóa API ngắn hạn cho các thiết lập yêu cầu mức độ bảo mật cao hơn, và khóa dài hạn có ngày hết hạn để khám phá Amazon Bedrock.
 ## Thực hiện cuộc gọi API đầu tiên của bạn
Sau khi bạn đã có quyền truy cập vào các mô hình nền tảng, việc bắt đầu sử dụng khóa API Amazon Bedrock rất đơn giản. Sau đây là cách thực hiện lệnh gọi API đầu tiên bằng AWS SDK cho Python (Boto3 SDK) và khóa API:

**Tạo khóa API**
Để tạo khóa API, hãy làm theo các bước sau :
1.Đăng nhập vào AWS Management Console và mở bảng điều khiển Amazon Bedrock
2.Trong bảng điều hướng bên trái, chọn API keys .
3.Chọn Generate short-term API key hoặc Generate long-term API key .
4.Đối với khóa dài hạn, đặt thời gian hết hạn mong muốn của bạn và tùy chọn cấu hình các quyền nâng cao .
5.Chọn Generate và sao chép khóa API của bạn .
**Đặt khóa API của bạn làm biến môi trường**
Bạn có thể đặt khóa API của mình làm biến môi trường để nó được tự động nhận dạng khi bạn thực hiện các yêu cầu API :
```yaml
# To set the API key as an environment variable, you can open a terminal and run the following command:
export AWS_BEARER_TOKEN_BEDROCK=<YOUR API KEY HERE>

```
Boto3 và AWS JavaScript SDK sẽ tự động phát hiện biến môi trường của bạn khi bạn tạo ứng dụng khách Amazon Bedrock. Hãy đảm bảo bạn sử dụng phiên bản SDK mới nhất.
**Thực hiện cuộc gọi API đầu tiên của bạn**
Bây giờ bạn có thể thực hiện các cuộc gọi API tới Amazon Bedrock theo nhiều cách :
1.Sử dụng curl:
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
2.Sử dụng Boto3 SDK cho Amazon Bedrock
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
3.Bạn cũng có thể sử dụng các thư viện gốc như Python Requests
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
## Kết nối trải nghiệm nhà phát triển và yêu cầu bảo mật doanh nghiệp
Với tư cách là quản trị viên, bạn có thể kích hoạt khóa API ngắn hạn để đơn giản hóa quy trình tích hợp người dùng cho các mô hình nền tảng Amazon Bedrock, đồng thời đảm bảo mức độ bảo mật cao hơn. Các khóa này tận dụng AWS Signature Phiên bản 4 và các nguyên tắc IAM hiện có, duy trì các biện pháp kiểm soát truy cập đã thiết lập của bạn.
Vì mục đích kiểm tra và tuân thủ, tất cả các lệnh gọi API đều được ghi lại trong AWS CloudTrail . Khóa API được truyền dưới dạng tiêu đề ủy quyền cho các yêu cầu API và không được ghi lại.
**Kiểm soát quyền đối với khóa API**
Bạn có thể sử dụng Chính sách kiểm soát dịch vụ (SCP) với khóa điều kiện Amazon Bedrock để tùy chỉnh việc tạo và sử dụng khóa API nhằm đáp ứng các yêu cầu của tổ chức bạn.
Ví dụ: bạn có thể từ chối sử dụng khóa API bằng chính sách sau:
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
Bạn cũng có thể thực thi giới hạn hết hạn đối với khóa API dài hạn để đảm bảo xoay vòng thường xuyên. SCP sau ngăn việc tạo khóa có thời gian tồn tại vượt quá 30 ngày.
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
Tham khảo tài liệu Amazon Bedrock để biết thêm ví dụ về SCP.
## Kết luận
hóa API Amazon Bedrock có thể được sử dụng trong các khu vực AWS thương mại. Amazon Bedrock hiện đã có sẵn. Để tìm hiểu thêm về khóa API trong Amazon Bedrock, hãy truy cập tài liệu Khóa API trong  hướng dẫn sử dụng Amazon Bedrock.
Hãy thử sử dụng khóa API trong bảng điều khiển Amazon Bedrock ngay hôm nay và gửi phản hồi tới AWS re:Post cho Amazon Bedrock hoặc thông qua các liên hệ hỗ trợ AWS thông thường của bạn.


