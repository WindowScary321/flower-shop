# Nâng Cấp Trang Chi Tiết Sản Phẩm & Định Dạng Mô Tả

- **Thời gian**: 2026-07-20
- **Mục tiêu**: Khắc phục lỗi hiển thị văn bản mô tả sản phẩm (giữ nguyên in đậm, danh sách và ngắt dòng từ dữ liệu nguồn), đồng thời tối ưu hóa không gian trống bên dưới trang chi tiết bằng cách thêm phần đề xuất 10 sản phẩm liên quan để tăng tính tiện ích (QoL) cho khách hàng.

## Các thay đổi chính

### 1. Định Dạng Mô Tả Hoa (Bold, Italic, Newlines)
- **Flower.java**:
  - Thêm phương thức `getFormattedDescription()` để chuyển đổi văn bản mô tả hoa.
  - Sử dụng biểu thức chính quy (Regex) để tìm và chuyển đổi cú pháp Markdown `**chữ in đậm**` sang `<strong>chữ in đậm</strong>`, và `*chữ in nghiêng*` sang `<em>chữ in nghiêng</em>`.
  - Hỗ trợ cả dữ liệu thô (tách dòng bằng `\n` thành `<br/>`) và dữ liệu dạng HTML mới (giữ nguyên cấu trúc để tránh giãn dòng ngoài ý muốn).
- **flower-detail.jsp**:
  - Thay thế việc hiển thị mô tả từ `${flower.description}` sang `${flower.formattedDescription}` để render trực tiếp HTML mà không bị escape ký tự.
  - Đưa mô tả vào thẻ `<div>` thay vì `<p>` để tránh lồng thẻ sai chuẩn HTML.

### 2. Sửa Lỗi Font Tiếng Việt & Giữ Định Dạng Khi Scrape Dữ Liệu
- **compare_and_insert.py**:
  - Sửa phương thức lấy mô tả từ `get_text()` thành `decode_contents()` để trích xuất nguyên bản các thẻ định dạng HTML gốc (`<strong>`, `<ul>`, `<li>`, etc.) từ trang FlowerCorner.
- **Quy trình nạp cơ sở dữ liệu**:
  - Cập nhật file [recreate-db.bat](../../database/recreate-db.bat) để tự động chạy cả 2 script `FlowerShopDB.sql` (khởi tạo) và `InsertMoreFlowers.sql` (thêm hoa) theo trình tự, bổ sung kiểm tra mã lỗi `errorlevel` và cấu hình UTF-8 `-f 65001`.
  - Cập nhật [docker-compose.yml](../../docker-compose.yml): Gắn thêm volume mount `/InsertMoreFlowers.sql` và điều chỉnh chuỗi lệnh trong service `init-db` chạy tuần tự cả 2 file SQL để đồng bộ dữ liệu khi khởi động container Docker.
  - Chạy script Python cào dữ liệu mới có định dạng HTML và import thành công.

### 3. Đề Xuất 10 Sản Phẩm Khác Ở Trang Chi Tiết
- **FlowerDetailServlet.java**:
  - Thêm logic lấy 10 sản phẩm liên quan: ưu tiên các hoa đang hoạt động (`Status = 1`) trong cùng danh mục (`CategoryId`) với sản phẩm đang xem (loại bỏ chính nó).
  - Nếu số lượng hoa cùng danh mục nhỏ hơn 10, servlet tự động lấy thêm các sản phẩm hoạt động khác trong hệ thống để bổ sung cho đủ 10 hoa.
  - Gán danh sách vào request attribute tên là `relatedFlowers`.
- **flower-detail.jsp**:
  - Thêm phần **SẢN PHẨM KHÁC** ở phía dưới trang sử dụng hợp phần **Bootstrap Carousel** để hiển thị dạng thanh trượt (slider).
  - Phân chia 10 sản phẩm liên quan thành 2 trang slide (mỗi slide gồm 5 card sản phẩm, hỗ trợ responsive thích ứng tốt trên cả mobile và desktop).
  - Bổ sung nút mũi tên chuyển trang Trái / Phải được thiết kế dạng hình tròn màu hồng nhạt mềm mại, nổi bật ở 2 bên rìa trang và tự động ẩn khi danh sách có từ 5 sản phẩm trở xuống.
  - Mỗi card sản phẩm liên quan hiển thị đầy đủ thông tin: Ảnh sản phẩm (có logic dự phòng placeholder), nhãn giảm giá (nếu có), đơn vị bán, tên hoa, giá bán khuyến mãi / giá gốc (đồng bộ phong cách trang chủ), cùng nút "Xem chi tiết".
