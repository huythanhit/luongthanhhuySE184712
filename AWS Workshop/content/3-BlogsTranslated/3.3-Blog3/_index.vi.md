---
title: "Blog 3"
weight: 1
chapter: false
pre: " <b> 3.3. </b> "
---



# Tăng tốc quá trình di chuyển từ VMware sang AWS với ưu đãi di chuyển nhanh của Trianz và nền tảng Concierto
Bởi Renuka Krishnan và Ciji Joseph vào 31 THÁNG 10 NĂM 2024 trong AWS cho VMware , Quản lý đám mây lai , Di chuyển , Chương trình tăng tốc di chuyển (MAP), Giải pháp di chuyển, Giải pháp đối tác, VMware Cloud trên AWS, Windows trên AWS| Liên kết cố định| Chia sẻ

# Giới thiệu

Trong bài đăng trên blog này, chúng tôi khám phá cách Dịch vụ di chuyển nhanh (RMO) của Trianz hợp tác với Amazon Web Services (AWS) tạo điều kiện thuận lợi cho việc áp dụng đám mây doanh nghiệp liền mạch và hiệu quả bằng cách tận dụng nền tảng Concierto làm công cụ hỗ trợ chính trong việc hợp lý hóa và tự động hóa toàn bộ quy trình di chuyển.
Trong thế giới điện toán đám mây đang không ngừng phát triển, các doanh nghiệp luôn tìm kiếm các giải pháp hiệu quả và đáng tin cậy để hợp lý hóa chiến lược ứng dụng đám mây. Hệ sinh thái VMware từ lâu đã là nền tảng trong lĩnh vực ảo hóa và cơ sở hạ tầng đám mây. Với việc Broadcom mua lại và chi phí cấp phép tăng cao, các doanh nghiệp đang đứng trước thời điểm quan trọng để di chuyển và hiện đại hóa cơ sở hạ tầng CNTT một cách nhanh chóng và an toàn.
Các phương pháp di chuyển truyền thống phức tạp, tốn kém tài nguyên và tiềm ẩn nhiều bất ổn, khiến các tổ chức phải vật lộn với thời gian biểu kéo dài, chi phí vượt mức và gián đoạn hoạt động. Đây chính là lúc các phương pháp di chuyển giá cố định và theo quy định như RMO phát huy tác dụng. Bằng cách cung cấp khả năng dự đoán giá cả, bộ kỹ năng chuyên môn và phương pháp đã được chứng minh cho việc di chuyển có giới hạn thời gian, được hỗ trợ bởi các công cụ và tự động hóa có thể điều phối toàn bộ hành trình di chuyển từ đầu đến cuối, các giải pháp này giúp đơn giản hóa và đẩy nhanh hành trình di chuyển lên đám mây.


## Những thách thức trong quá trình chuyển đổi VMware sang các giải pháp truyền thống
Các phương pháp di chuyển truyền thống đòi hỏi chuyên môn kỹ thuật sâu rộng, làm tăng lỗi và độ trễ. Việc phụ thuộc vào các công cụ dòng lệnh và kịch bản phức tạp có thể gây quá tải cho các chuyên gia CNTT thiếu kỹ năng lập trình. Khả năng tự động hóa hạn chế đòi hỏi sự can thiệp thủ công, làm trầm trọng thêm lỗi của con người. Khả năng kiểm thử không đầy đủ và các quy trình thủ công tốn nhiều tài nguyên có thể dẫn đến chi phí vượt mức và nhu cầu nhân sự cao hơn. Việc thiếu các công cụ khám phá và đánh giá tự động trong việc quản lý các mối quan hệ phụ thuộc giữa các ứng dụng, cơ sở dữ liệu và lưu trữ càng làm tăng thêm độ phức tạp và rủi ro lỗi cho quá trình di chuyển. Những thách thức này nhấn mạnh nhu cầu về một phương pháp tiếp cận hợp lý, mang tính quy định và tự động hơn để tạo điều kiện thuận lợi cho quá trình chuyển đổi sang Đám mây AWS diễn ra suôn sẻ hơn.
# Ưu đãi di cư nhanh chóng
Việc di chuyển lên đám mây quy mô lớn thường phải đối mặt với thời gian thực hiện kéo dài và chi phí vượt mức do thiếu kỹ năng và công cụ chuyên biệt, đòi hỏi phải phát triển, thuê ngoài hoặc thuê ngoài. Các dự án di chuyển thường được xây dựng dựa trên cơ sở "Thời gian và Vật liệu" (T&M), khiến khách hàng phải chịu gánh nặng về chi phí và thời gian thực hiện, đồng thời phải gánh chịu sự chậm trễ và chi phí vượt mức.
Để giải quyết những vấn đề này, nhóm Chương trình Tăng tốc Di chuyển AWS (MAP) đã tạo ra Ưu đãi Di chuyển Nhanh (RMO), một phương pháp di chuyển theo quy định, giá cố định, được thiết kế để giảm thiểu rủi ro và đẩy nhanh quá trình di chuyển toàn doanh nghiệp sang AWS. RMO mang lại một số lợi ích chính.
1. Minh bạch về chi phí – Không giống như các dự án thời gian và vật liệu (T&M) truyền thống, RMO nêu rõ giá di chuyển theo từng máy chủ của khách hàng ngay từ đầu, giúp dự đoán được chi phí.
2. Chiến lược di chuyển đơn giản hóa – RMO cung cấp “nút dễ dàng” để nâng và chuyển các phần của quá trình di chuyển, cho phép khách hàng tập trung vào nỗ lực hiện đại hóa.
3. Cung cấp dịch vụ di chuyển trọn gói – RMO là dịch vụ theo quy định, trọn gói, trong đó các đối tác tư vấn hoặc AWS ProServe sẽ xử lý toàn bộ quá trình di chuyển, bao gồm cả việc đưa khách hàng lên nhà cung cấp dịch vụ được quản lý (MSP) nếu cần.

Trianz đã hợp tác với AWS để cung cấp RMO như một giải pháp toàn diện giúp đẩy nhanh quá trình di chuyển toàn doanh nghiệp sang AWS. Bằng cách tận dụng Concierto, một nền tảng SaaS không mã siêu tự động, kết hợp với phương pháp luận quy định của RMO, các tổ chức có thể giảm đáng kể thời gian chu kỳ di chuyển. Ví dụ: Concierto gần đây đã hoàn thành một dự án di chuyển VMware và Windows quy mô lớn cho một khách hàng, liên quan đến hơn 1.400 máy ảo (VM) trong vòng 4 tháng, bao gồm khám phá nhanh chóng, đánh giá tự động và thực hiện di chuyển bằng khuôn khổ RMO.

# Phương pháp tiếp cận của Trianz đối với RMO và di chuyển lên đám mây
Dịch vụ RMO giá cố định của Trianz tận dụng đội ngũ chuyên gia di chuyển lành nghề, phương pháp di chuyển đã được chứng minh sử dụng các biện pháp di chuyển tốt nhất của AWS và giải pháp di chuyển của Concierto (Concierto Migrate) để cung cấp lộ trình tự động hóa cao và tăng tốc lên đám mây, qua ba giai đoạn chính.
1. **Đánh giá và huy động**
Giai đoạn này giúp rút ngắn quá trình khám phá, đánh giá và lập kế hoạch từ vài tháng xuống còn vài ngày. Phương pháp tiếp cận toàn diện này giúp giảm thiểu rủi ro, tối ưu hóa chiến lược và đảm bảo việc áp dụng đám mây hiệu quả và tiết kiệm chi phí cho doanh nghiệp.
Đánh giá tự động – Quá trình di chuyển bắt đầu bằng việc khám phá toàn diện bối cảnh CNTT, xác định tất cả tài sản và các mối quan hệ phụ thuộc. Nền tảng tự động tạo ra các đánh giá chi tiết về cơ sở hạ tầng và ứng dụng CNTT, xác định các khoảng trống bằng Khung Áp dụng Đám mây AWS (Hình 1). Điều này cung cấp các đề xuất đám mây mục tiêu, chi phí và các tác động cấp phép để hỗ trợ việc ra quyết định sáng suốt.

**Lập kế hoạch đợt di chuyển** – Các tác vụ di chuyển được nhóm theo ứng dụng và cơ sở hạ tầng liên quan để tạo ra các đợt di chuyển dựa trên mức độ ưu tiên và phụ thuộc của doanh nghiệp. Nền tảng này tạo ra các nhóm di chuyển một cách thông minh dựa trên sự phụ thuộc của ứng dụng, cho phép sắp xếp thứ tự, ước tính nỗ lực và lập lịch trình thời gian để có một kế hoạch thực hiện rõ ràng.
Concierto tích hợp việc tạo vùng hạ cánh , cấu hình môi trường đám mây mục tiêu với các cấu trúc tài khoản, thiết kế mạng và kiểm soát bảo mật cần thiết

2. **Di cư và hiện đại hóa**
Giai đoạn này cho phép di chuyển với ít gián đoạn nhất, với khả năng hiển thị và kiểm soát rõ ràng. Quy trình làm việc tự động giúp giảm thiểu thời gian di chuyển, giảm lỗi và tối ưu hóa hiệu suất cũng như chi phí sau di chuyển. Concierto cho phép di chuyển theo lịch trình với thời gian chết gần như bằng không và đồng bộ hóa dữ liệu liên tục, cho phép giám sát và điều chỉnh theo thời gian thực thông qua bảng điều khiển di chuyển, đảm bảo kiểm soát mọi giai đoạn di chuyển (Hình 4).

3. **Vận hành và tối ưu hóa**
Giai đoạn vận hành và tối ưu hóa giúp tối đa hóa đầu tư vào đám mây bằng cách cân bằng giữa hiệu quả chi phí và hiệu suất cao. Giai đoạn này bao gồm việc giám sát và tối ưu hóa chi phí để đảm bảo cơ sở hạ tầng AWS vừa tiết kiệm chi phí vừa hiệu suất cao 

**Những gì bạn nhận được từ điều này**
  **Di chuyển AWS nhanh hơn** – Tăng tốc di chuyển hàng loạt lên đám mây lên 40% hoặc hơn thông qua danh mục được xây dựng sẵn và quy trình làm việc được đơn giản hóa.
**Tự động hóa và điều phối đám mây lai** – Quản lý hoạt động trên đám mây và tại chỗ thông qua một nền tảng duy nhất với hàng trăm tính năng tự động hóa tích hợp sẵn.
**Quản lý hoạt động đám mây lai hợp nhất** – Quản lý vòng đời tập trung thông qua giao diện thân thiện với người dùng, loại bỏ nhu cầu sử dụng phần mềm cũ và giảm độ phức tạp.
**Giảm tổng chi phí sở hữu (TCO)** – Giảm tới 30% TCO thông qua quy trình hợp lý hóa và tăng cường tự động hóa.
 **Các chương trình và dịch vụ chiến lược**
Hợp tác với AWS, Concierto cung cấp một bộ chương trình và dịch vụ dành cho khách hàng:
1. Đánh giá và huy động kết hợp miễn phí
2. Di chuyển không mất phí trả trước với Concierto MIGRATE
3. iá cố định (cho mỗi VM) Concierto MANAGE dành cho hoạt động đám mây lai.
4. Cấp phép không mất phí ròng thông qua Ưu đãi công cụ di chuyển ISV của AWS.
# Phần kết luận
Trong bài đăng trên blog này, chúng tôi đã khám phá cách sự hợp tác giữa AWS và Trianz mang đến một lộ trình đáng tin cậy, hiệu quả và đơn giản hóa cho các tổ chức nhằm tối ưu hóa đầu tư CNTT trong bối cảnh VMware đang không ngừng biến đổi. Trianz RMO tận dụng Concierto để giải quyết các thách thức di chuyển bằng cách loại bỏ sự phức tạp, ngăn ngừa chi phí vượt mức và giảm thiểu lỗi thủ công. Nền tảng hợp nhất này đơn giản hóa hoạt động và hợp lý hóa việc quản lý phụ thuộc, tập trung kiểm soát để nâng cao khả năng hiển thị và cho phép chuyển đổi mượt mà hơn với hiệu suất được tối ưu hóa.

AWS sở hữu nhiều dịch vụ và tính năng hơn đáng kể so với bất kỳ nhà cung cấp dịch vụ đám mây nào khác, giúp việc di chuyển các ứng dụng hiện có của bạn lên đám mây và xây dựng gần như mọi thứ bạn có thể tưởng tượng trở nên nhanh chóng, dễ dàng và tiết kiệm chi phí hơn. Hãy trang bị cho các ứng dụng Microsoft của bạn cơ sở hạ tầng cần thiết để thúc đẩy kết quả kinh doanh mong muốn. Truy cập  blog .NET on AWS  và  AWS Database của chúng tôi  để được hướng dẫn thêm và lựa chọn cho khối lượng công việc Microsoft của bạn.  Liên hệ với chúng tôi  để bắt đầu hành trình di chuyển và hiện đại hóa ngay hôm nay.
# Giới thiệu về tác giả

**Renuka Krishnan**
Renuka Krishnan là Kiến trúc sư Giải pháp Đối tác tại Amazon Web Services ở Atlanta, GA. Cô có hơn 15 năm kinh nghiệm thiết kế và triển khai các giải pháp tập trung vào công nghệ Microsoft. Cô tâm huyết với việc hỗ trợ các đối tác và khách hàng di chuyển, hiện đại hóa và tối ưu hóa khối lượng công việc Microsoft của họ trên AWS.

**Ciji Joseph**
Ciji Joseph là một chuyên gia CNTT dày dạn kinh nghiệm với 22 năm kinh nghiệm, hiện đang làm việc tại Herndon, VA. Chuyên môn của ông trải rộng trên các lĩnh vực điện toán đám mây, cơ sở hạ tầng và bảo mật, nơi ông đã thể hiện xuất sắc với vai trò là nhà phát triển, kiến ​​trúc sư, cố vấn và nhà lãnh đạo tư tưởng. Ciji phụ trách Hệ sinh thái Dịch vụ Chuyên nghiệp & Đối tác của Concierto, nơi ông tận dụng kiến ​​thức sâu rộng của mình để cung cấp các giải pháp tiên tiến, liên tục thúc đẩy đổi mới cho nền tảng.


