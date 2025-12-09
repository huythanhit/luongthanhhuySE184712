---
title: "Worklog Tuần 4"
weight: 1
chapter: false
pre: " <b> 1.4. </b> "
---
{{% notice warning %}}
⚠️ **Lưu ý:** Các thông tin dưới đây chỉ nhằm mục đích tham khảo, vui lòng **không sao chép nguyên văn** cho bài báo cáo của bạn kể cả warning này.
{{% /notice %}}


### Mục tiêu tuần 4:

* Hiểu quy trình Migration (di chuyển hệ thống lên AWS) và Disaster Recovery (khôi phục sau thảm họa).
* Thực hành dịch vụ AWS Database Migration Service (DMS) và Elastic Disaster Recovery (EDR).
* Biết cách sao lưu, phục hồi dữ liệu và tạo kế hoạch khẩn cấp cho hạ tầng.

### Các công việc cần triển khai trong tuần này:
| Thứ | Công việc                                                                                                                                                                        | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu                            |
| --- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ | --------------- | ----------------------------------------- |
| 2   | - Tìm hiểu các khái niệm Migration (Lift & Shift, Replatform, Refactor) <br> - Giới thiệu công cụ AWS Database Migration Service (DMS)                                       | 29/09/2025   | 29/09/2025      | [AWS Journey](https://cloudjourney.awsstudygroup.com/) |
| 3   | - Thực hành tạo Replication Instance trong DMS <br> - Cấu hình nguồn dữ liệu (on-premise) và đích (RDS) <br> - Thực hiện di chuyển dữ liệu thử nghiệm                        | 30/09/2025   | 30/09/2025      | [AWS Journey](https://cloudjourney.awsstudygroup.com/) |
| 4   | - Giới thiệu Elastic Disaster Recovery (EDR) <br> - Học cách thiết lập replication server và recovery instance                                                               | 01/10/2025   | 01/10/2025      | [AWS Journey](https://cloudjourney.awsstudygroup.com/) |
| 5   | - Thực hành mô phỏng sự cố: tắt EC2 chính và khởi động instance khôi phục từ EDR <br> - Đánh giá thời gian khôi phục (RTO/RPO)                                                | 02/10/2025   | 02/10/2025      | [AWS Journey](https://cloudjourney.awsstudygroup.com/) |
| 6   | - Tạo kế hoạch Disaster Recovery cơ bản (backup, restore, failover) <br> - Viết tài liệu tóm tắt quy trình Migration + DR <br> - Tổng kết kiến thức tuần 4                      | 03/10/2025   | 03/10/2025      | [AWS Journey](https://cloudjourney.awsstudygroup.com/) |


### Kết quả đạt được tuần 4:

* Hiểu toàn bộ quy trình Migration ứng dụng hoặc cơ sở dữ liệu lên AWS.

* Tạo và cấu hình thành công DMS Replication Instance, thực hiện migration dữ liệu mẫu.

* Thiết lập được Elastic Disaster Recovery (EDR) để bảo vệ hệ thống trước sự cố.

* Mô phỏng thành công tình huống failover và khôi phục dịch vụ.

* Hoàn thành bản kế hoạch Disaster Recovery cơ bản, làm nền cho tuần 5 (Infrastructure as Code & Systems Manager).

---
title: "Worklog Tuần 4"
weight: 1
chapter: false
pre: " <b> 1.4. </b> "
---
{{% notice warning %}}
⚠️ **Lưu ý:** Các thông tin dưới đây chỉ nhằm mục đích tham khảo, vui lòng **không sao chép nguyên văn** cho bài báo cáo của bạn kể cả warning này.
{{% /notice %}}


### Mục tiêu tuần 4:

* Kết nối, làm quen với các thành viên trong First Cloud Journey.
* Hiểu dịch vụ AWS cơ bản, cách dùng console & CLI.

### Các công việc cần triển khai trong tuần này:
| Thứ | Công việc                                                                                                                                                                                   | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu                            |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ | --------------- | ----------------------------------------- |
| 2   | - Làm quen với các thành viên FCJ <br> - Đọc và lưu ý các nội quy, quy định tại đơn vị thực tập                                                                                             | 11/08/2025   | 11/08/2025      |
| 3   | - Tìm hiểu AWS và các loại dịch vụ <br>&emsp; + Compute <br>&emsp; + Storage <br>&emsp; + Networking <br>&emsp; + Database <br>&emsp; + ... <br>                                            | 12/08/2025   | 12/08/2025      | <https://cloudjourney.awsstudygroup.com/> |
| 4   | - Tạo AWS Free Tier account <br> - Tìm hiểu AWS Console & AWS CLI <br> - **Thực hành:** <br>&emsp; + Tạo AWS account <br>&emsp; + Cài AWS CLI & cấu hình <br> &emsp; + Cách sử dụng AWS CLI | 13/08/2025   | 13/08/2025      | <https://cloudjourney.awsstudygroup.com/> |
| 5   | - Tìm hiểu EC2 cơ bản: <br>&emsp; + Instance types <br>&emsp; + AMI <br>&emsp; + EBS <br>&emsp; + ... <br> - Các cách remote SSH vào EC2 <br> - Tìm hiểu Elastic IP   <br>                  | 14/08/2025   | 15/08/2025      | <https://cloudjourney.awsstudygroup.com/> |
| 6   | - **Thực hành:** <br>&emsp; + Tạo EC2 instance <br>&emsp; + Kết nối SSH <br>&emsp; + Gắn EBS volume                                                                                         | 15/08/2025   | 15/08/2025      | <https://cloudjourney.awsstudygroup.com/> |


### Kết quả đạt được tuần 4:

* Hiểu AWS là gì và nắm được các nhóm dịch vụ cơ bản: 
  * Compute
  * Storage
  * Networking 
  * Database
  * ...

* Đã tạo và cấu hình AWS Free Tier account thành công.

* Làm quen với AWS Management Console và biết cách tìm, truy cập, sử dụng dịch vụ từ giao diện web.

* Cài đặt và cấu hình AWS CLI trên máy tính bao gồm:
  * Access Key
  * Secret Key
  * Region mặc định
  * ...

* Sử dụng AWS CLI để thực hiện các thao tác cơ bản như:

  * Kiểm tra thông tin tài khoản & cấu hình
  * Lấy danh sách region
  * Xem dịch vụ EC2
  * Tạo và quản lý key pair
  * Kiểm tra thông tin dịch vụ đang chạy
  * ...

* Có khả năng kết nối giữa giao diện web và CLI để quản lý tài nguyên AWS song song.
* ...


