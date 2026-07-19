# Nhật ký tiến trình - Giai đoạn 3 (Nghiệp vụ mua hàng)

## Mục tiêu đã hoàn thành
Giai đoạn 3 tập trung vào việc triển khai toàn bộ luồng nghiệp vụ mua hàng từ đầu đến cuối, đáp ứng đầy đủ yêu cầu Tuần 3 trong file `6-task-assignment.md` (Ngày 2026-07-14):

1. **Trang Catalog sản phẩm (`/flower-catalog`)**:
   - `FlowerCatalogServlet` + `flower-catalog.jsp`.
   - Hiển thị toàn bộ hoa đang bán; hỗ trợ tìm kiếm theo keyword trong FlowerDAO (`LIKE` + PreparedStatement).
   - Hiển thị badge "Hết hàng" dạng overlay trực quan khi `Quantity = 0`.

2. **Trang Chi tiết sản phẩm (`/detail?id=X`)**:
   - `FlowerDetailServlet` + `flower-detail.jsp`.
   - Bộ tăng/giảm số lượng bằng JavaScript, tự giới hạn trong phạm vi tồn kho.

3. **Giỏ hàng Session (`/cart`)**:
   - `CartServlet` xử lý 3 action: `add`, `update`, `remove`.
   - Dữ liệu giỏ hàng lưu dưới dạng `List<CartItem>` trong `HttpSession`.
   - Không yêu cầu đăng nhập để thêm hàng vào giỏ; chỉ yêu cầu khi tiến hành thanh toán.
   - Tự động giới hạn số lượng theo tồn kho thực tế khi thêm hàng.

4. **Thanh toán với Transaction (`/checkout`)**:
   - `CheckoutServlet` kiểm tra Session → Validate form → gọi `OrderDAO.createOrder()`.
   - Bổ sung 2 phương thức thanh toán lưu vào Database (`PaymentMethod`, `PaymentStatus`): 
     - Tiền mặt (COD): Checkout thành công chuyển tới `/checkout-success`.
     - Chuyển khoản QR: Checkout thành công chuyển tới `/payment-qr` (Trang chuyên biệt hiển thị thông tin chuyển khoản và mã QR). Tại đây có nút "Kiểm tra thanh toán" để giả lập việc cập nhật trạng thái `PaymentStatus = 1`.
   - `OrderDAO.createOrder()`: áp dụng `connection.setAutoCommit(false)`. Ba bước: trừ tồn kho (kiểm tra đủ hàng), INSERT Orders, INSERT OrderDetails theo batch. Nếu bất kỳ bước nào thất bại, toàn bộ bị ROLLBACK.
   - Trả về `-2` nếu hết hàng, hiển thị thông báo lỗi cụ thể cho người dùng.

5. **Hủy đơn hàng + hoàn trả tồn kho**:
   - `OrderHistoryServlet.doPost()` nhận action `cancel`, gọi `OrderDAO.cancelOrder()`.
   - `cancelOrder()` dùng Transaction: Xác minh đơn thuộc về đúng account + đang ở trạng thái `Chờ xử lý` → Hoàn kho qua JOIN UPDATE → Cập nhật Status = `Đã hủy`.

6. **Phân quyền xử lý đơn hàng**:
   - Nhân viên (`/employee/manage-orders`): Chỉ được phép đặt `Đang giao` hoặc `Đã giao`. (Đã xử lý tạo `ManageOrderServlet` trong package `employee` riêng biệt để tránh conflict với nhánh Admin).
   - Admin (`/admin/manage-orders`): Toàn quyền cập nhật 3 trạng thái hợp lệ.

7. **File mới được tạo**:
   - `src/java/dal/OrderDAO.java`, `src/java/dal/OrderDetailDAO.java`
   - `src/java/controllers/customer/CartServlet.java`, `FlowerCatalogServlet.java`, `FlowerDetailServlet.java`, `CheckoutServlet.java`, `CheckoutSuccessServlet.java`, `OrderHistoryServlet.java`, `PaymentQRServlet.java`
   - `src/java/controllers/admin/ManageOrderServlet.java`
   - `src/java/controllers/employee/ManageOrderServlet.java`
   - `web/flower-catalog.jsp`, `web/flower-detail.jsp`, `web/cart.jsp`, `web/checkout.jsp`, `web/payment-qr.jsp`, `web/checkout-success.jsp`
   - `web/customer/order-history.jsp`, `web/admin/manage-orders.jsp`, `web/employee/manage-orders.jsp`
   - `database/recreate-db.bat`

8. **Kết quả biên dịch**:
   - Toàn bộ 20+ file Java được biên dịch thành công, không có lỗi. Giao diện hiển thị đúng mã hóa UTF-8 tiếng Việt sau khi import dữ liệu với Code Page 65001.

9. **Khởi tạo lại Database (`recreate-db.bat`)**:
   - Tạo script tự động `recreate-db.bat` giúp xoá và dựng lại DB nhanh chóng.
   - Sửa lỗi mã hóa: Sử dụng tùy chọn `-f 65001` trong lệnh `sqlcmd` để ép đọc file SQL theo định dạng UTF-8, khắc phục hoàn toàn lỗi vỡ font tiếng Việt.
   - Sửa lỗi cú pháp CMD: Thay đổi hiển thị thông tin kết nối tài khoản từ `(sa/123)` sang `[sa/123]` nhằm tránh lỗi đóng ngoặc sớm của khối lệnh `if` gây lỗi cú pháp của tệp `.bat` (lỗi `. was unexpected at this time`).
   - Ngôn ngữ hiển thị: Đã Việt hóa không dấu để đảm bảo hiển thị chuẩn xác trên cửa sổ Command Prompt của Windows.

10. **Quản lý Thời gian giao hàng**:
   - Thêm trường `DeliveryTime (DATETIME)` vào DB.
   - Admin và Nhân viên thiết lập lịch giao hàng (datetime-local) khi cập nhật trạng thái đơn hàng.
   - Khách hàng xem được thời gian dự kiến giao hàng trong Lịch sử đơn hàng; nếu chưa có, sẽ hiển thị "Đang chờ sắp xếp".

11. **Tính năng Giảm giá (Discount)**:
    - Bổ sung cột `Discount` (0-100%) vào bảng `Flowers` và mô hình Java.
    - Cập nhật hàm `getFinalPrice()` trong Model và áp dụng vào `CartItem` để tự động tính tiền khách cần trả.
    - Sửa giao diện quản lý (Admin có thể đặt %) và hiển thị badge ưu đãi đẹp mắt trên Catalog, Detail, Cart.

## Hướng dẫn các bước tiếp theo
- **Giai đoạn 4**: Tiếp tục tối ưu hóa trải nghiệm, thêm phân trang, tìm kiếm động và xây dựng báo cáo thống kê.
