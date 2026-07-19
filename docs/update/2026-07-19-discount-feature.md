# Tính năng Giảm giá (Discount)

- **Thời gian**: 2026-07-19
- **Mục tiêu**: Bổ sung phần trăm giảm giá cho các loại hoa để phục vụ cho các chiến dịch bán hàng và khuyến mãi. Giá bán hiển thị trên UI và thanh toán sẽ tự động tính dựa vào phần trăm này.

## Các thay đổi chính

### CSDL (Database)
- Đã thêm cột `Discount INT DEFAULT 0 CHECK (Discount >= 0 AND Discount <= 100)` vào bảng `Flowers`.
- Cập nhật các dòng `INSERT` giả lập dữ liệu ban đầu với các sản phẩm có `Discount > 0`.

### Models & DAOs
- Thêm trường `discount` vào mô hình `Flower`.
- Thêm phương thức `getFinalPrice()` trong mô hình `Flower` để tính giá sau khi giảm (`price * (100 - discount) / 100.0`).
- Sửa hàm `getTotalPrice()` của `CartItem` để sử dụng `flower.getFinalPrice()`.
- Cập nhật `insertFlower`, `updateFlower` và `extractFlower` trong `FlowerDAO` để đọc/ghi cột `Discount` với CSDL.

### Controller
- Chỉnh sửa `ManageFlowerServlet.java` trong phân hệ admin để tiếp nhận và lưu tham số `discount`.

### Views
- `admin/manage-flowers.jsp`: 
  - Bổ sung ô nhập `Giảm giá (%)` trong chức năng thêm và sửa sản phẩm.
  - Hiển thị phần trăm giảm giá trong bảng danh sách sản phẩm.
- `flower-catalog.jsp`: Thêm badge hiển thị % giảm giá, giá cũ gạch ngang và giá sau giảm với thiết kế bắt mắt.
- `flower-detail.jsp`: Tương tự như trang danh mục, trình bày mức giá mới và giá cũ cho sản phẩm chi tiết.
- `cart.jsp`: Trong giỏ hàng, thông tin giá được hiển thị theo mức giá đã giảm (final price).
