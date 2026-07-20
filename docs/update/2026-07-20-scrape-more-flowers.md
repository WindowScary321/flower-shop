# Bổ Sung Dữ Liệu Sản Phẩm Và Danh Mục Mới

- **Thời gian**: 2026-07-20
- **Mục tiêu**: Làm phong phú kho dữ liệu sản phẩm hoa tươi của cửa hàng bằng cách cào thêm dữ liệu từ các danh mục mới trên trang `flowercorner.vn` bao gồm: Hoa Kỷ Niệm Ngày Cưới, Hoa 8/3, Hoa 20/10, Hoa 20/11, Hoa Khai Trương, Hoa Chúc Mừng, Hoa cưới cầm tay, Hoa Valentine. Các dữ liệu này được chèn trực tiếp vào cơ sở dữ liệu mà không làm thay đổi hay ghi đè lên những sản phẩm hiện có.

## Các thay đổi chính

### Script Cào Dữ Liệu (Python)
- **scripts/compare_and_insert.py**:
  - Tạo script Python sử dụng `requests` và `BeautifulSoup` để quét 8 danh mục hoa theo yêu cầu từ trang đích.
  - Tích hợp logic xử lý mô tả chi tiết: Ưu tiên lấy nội dung mô tả đầy đủ từ CSS selector `#tab-description` thay vì chỉ sử dụng thẻ meta ngắn gọn.
  - Xây dựng chức năng **so sánh thông minh**: tự động đọc file khởi tạo cơ sở dữ liệu gốc (`database/FlowerShopDB.sql`) để trích xuất tên những loại hoa đã tồn tại. Script sẽ so sánh tên hoa vừa cào được với danh sách gốc, loại bỏ những hoa bị trùng lặp và chỉ giữ lại những bông hoa hoàn toàn mới.
  - Tự động sinh ra định dạng lệnh SQL linh hoạt và lưu kết quả vào một tập tin SQL riêng biệt (`database/InsertMoreFlowers.sql`).

### Tự Động Hóa Cơ Sở Dữ Liệu (Database)
- **database/InsertMoreFlowers.sql**:
  - Script được thiết kế chỉ chứa các lệnh `INSERT`, không sử dụng lệnh `DROP` hay tạo mới database nhằm đảm bảo an toàn cho dữ liệu đang chạy.
  - Sử dụng cấu trúc `IF NOT EXISTS` khi thêm danh mục (Categories) mới để tránh lỗi trùng lặp dữ liệu.
  - Áp dụng truy vấn con động `(SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = ...)` để linh hoạt liên kết đúng ID danh mục cho sản phẩm mới mà không cần hardcode ID.
  - File SQL này sau đó được nạp trực tiếp vào cơ sở dữ liệu thông qua lệnh `sqlcmd` (có bật tính năng `-C` Trust Server Certificate), bổ sung thành công 45 sản phẩm hoa mới và các danh mục tương ứng vào hệ thống.
