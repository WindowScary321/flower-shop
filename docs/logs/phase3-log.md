## Giai đoạn 3: Nghiệp vụ mua hàng — Ngày 2026-07-14

### Mục tiêu hoàn thành
Triển khai toàn bộ luồng nghiệp vụ mua hàng từ đầu đến cuối, đáp ứng đầy đủ yêu cầu Tuần 3 trong file `6-task-assignment.md`.

### Chi tiết kỹ thuật triển khai

1. **Trang Catalog sản phẩm** (`/flower-catalog`):
   - `FlowerCatalogServlet` + `flower-catalog.jsp`
   - Hiển thị toàn bộ hoa đang bán; hỗ trợ tìm kiếm theo keyword trong FlowerDAO (`LIKE` + PreparedStatement).
   - Hiển thị badge "Hết hàng" dạng overlay trực quan khi `Quantity = 0`.

2. **Trang Chi tiết sản phẩm** (`/detail?id=X`):
   - `FlowerDetailServlet` + `flower-detail.jsp`
   - Bộ tăng/giảm số lượng bằng JavaScript, tự giới hạn trong phạm vi tồn kho.

3. **Giỏ hàng Session** (`/cart`):
   - `CartServlet` xử lý 3 action: `add`, `update`, `remove`.
   - Dữ liệu giỏ hàng lưu dưới dạng `List<CartItem>` trong `HttpSession`.
   - Không yêu cầu đăng nhập để thêm hàng vào giỏ; chỉ yêu cầu khi tiến hành thanh toán.
   - Tự động giới hạn số lượng theo tồn kho thực tế khi thêm hàng.

4. **Thanh toán với Transaction** (`/checkout`):
   - `CheckoutServlet` kiểm tra Session → Validate form → gọi `OrderDAO.createOrder()`.
   - Bổ sung 2 phương thức thanh toán lưu vào Database (`PaymentMethod`, `PaymentStatus`): 
     - **Tiền mặt (COD)**: Checkout thành công chuyển tới `/checkout-success`.
     - **Chuyển khoản QR**: Checkout thành công chuyển tới `/payment-qr` (Trang chuyên biệt hiển thị thông tin chuyển khoản và mã QR). Tại đây có nút "Kiểm tra thanh toán" để giả lập việc cập nhật trạng thái `PaymentStatus = 1`.
   - `OrderDAO.createOrder()`: áp dụng `connection.setAutoCommit(false)`. Ba bước: trừ tồn kho (kiểm tra đủ hàng), INSERT Orders, INSERT OrderDetails theo batch. Nếu bất kỳ bước nào thất bại, toàn bộ bị ROLLBACK.
   - Trả về `-2` nếu hết hàng, hiển thị thông báo lỗi cụ thể cho người dùng.

5. **Hủy đơn hàng + hoàn trả tồn kho**:
   - `OrderHistoryServlet.doPost()` nhận action `cancel`, gọi `OrderDAO.cancelOrder()`.
   - `cancelOrder()` dùng Transaction: Xác minh đơn thuộc về đúng account + đang ở trạng thái `Chờ xử lý` → Hoàn kho qua JOIN UPDATE → Cập nhật Status = `Đã hủy`.

6. **Phân quyền xử lý đơn hàng**:
   - Nhân viên (`/employee/manage-orders`): Chỉ được phép đặt `Đang giao` hoặc `Đã giao`. (Đã xử lý đổi tên Servlet thành `EmployeeManageOrderServlet` để tránh conflict với Admin).
   - Admin (`/admin/manage-orders`): Toàn quyền cập nhật 3 trạng thái hợp lệ.

### File mới được tạo
- `src/java/dal/OrderDAO.java`
- `src/java/dal/OrderDetailDAO.java`
- `src/java/controllers/customer/CartServlet.java`
- `src/java/controllers/customer/FlowerCatalogServlet.java`
- `src/java/controllers/customer/FlowerDetailServlet.java`
- `src/java/controllers/customer/CheckoutServlet.java`
- `src/java/controllers/customer/CheckoutSuccessServlet.java`
- `src/java/controllers/customer/OrderHistoryServlet.java`
- `src/java/controllers/admin/ManageOrderServlet.java`
- `src/java/controllers/customer/PaymentQRServlet.java`
- `src/java/controllers/employee/ManageOrderServlet.java`
- `web/flower-catalog.jsp`
- `web/flower-detail.jsp`
- `web/cart.jsp`
- `web/checkout.jsp`
- `web/payment-qr.jsp`
- `web/checkout-success.jsp`
- `web/customer/order-history.jsp`
- `web/admin/manage-orders.jsp`
- `web/employee/manage-orders.jsp`
- `database/recreate-db.bat`

### Kết quả biên dịch
Toàn bộ 20+ file Java được biên dịch thành công, không có lỗi. Giao diện hiển thị đúng mã hóa UTF-8 tiếng Việt sau khi import dữ liệu với Code Page 65001.

### Khởi tạo lại Database (`recreate-db.bat`)
- Tạo script tự động [recreate-db.bat](file:///c:/Users/tusieumap/Projects/prj302/flower-shop/database/recreate-db.bat) giúp xoá và dựng lại DB nhanh chóng.
- **Sửa lỗi mã hóa:** Sử dụng tùy chọn `-f 65001` trong lệnh `sqlcmd` để ép đọc file SQL theo định dạng UTF-8, khắc phục hoàn toàn lỗi vỡ font tiếng Việt.
- **Sửa lỗi cú pháp CMD:** Thay đổi hiển thị thông tin kết nối tài khoản từ `(sa/123)` sang `[sa/123]` nhằm tránh lỗi đóng ngoặc sớm của khối lệnh `if` gây lỗi cú pháp của tệp `.bat` (lỗi `. was unexpected at this time`).
- **Ngôn ngữ hiển thị:** Đã Việt hóa không dấu để đảm bảo hiển thị chuẩn xác trên cửa sổ Command Prompt của Windows.
