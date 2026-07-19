# Bug: Thiếu xác nhận thanh toán cho đơn hàng COD và Lỗi cập nhật Đã giao khi thiếu thời gian giao hàng (COD Payment & Delivery Time Validation Bug)
Date: 2026-07-19

## 1. Mô tả lỗi (Bug Description)
Trong quá trình quản lý đơn hàng của hệ thống, phát sinh 2 vấn đề bất cập:
1. Đối với các đơn hàng thanh toán khi nhận hàng (COD), nhân viên và quản trị viên không có cách nào đánh dấu hoặc xác nhận rằng khách hàng đã thanh toán (PaymentStatus) ngay trên giao diện cập nhật trạng thái đơn hàng.
2. Khi nhân viên hoặc Admin chọn cập nhật trạng thái đơn hàng thành "Đã giao", hệ thống vẫn chấp nhận xử lý thành công ngay cả khi người dùng không cung cấp thời gian giao hàng (cố ý xóa trắng DeliveryTime).

## 2. Nguyên nhân (Root Cause)
- **Thiếu giao diện và xử lý cập nhật thanh toán**: Giao diện biểu mẫu cập nhật trạng thái (`manage-orders.jsp`) không có input (Checkbox) để nhận dữ liệu trạng thái thanh toán mới. Kéo theo việc Servlet điều khiển không thể gọi hàm `orderDAO.updatePaymentStatus()`.
- **Thiếu ràng buộc logic thời gian giao hàng**: Hệ thống hiện tại không có điều kiện ràng buộc nào ép buộc thuộc tính `DeliveryTime` phải khác Null/Trống khi thuộc tính `Status` mang giá trị `"Đã giao"`, cả ở tầng cơ sở dữ liệu (`Orders` table) lẫn Backend (`ManageOrderServlet.java`).

## 3. Cách khắc phục (Resolution)
1.  **Cập nhật Cấu trúc Cơ sở dữ liệu**:
    *   Bổ sung thêm `CONSTRAINT CHK_DeliveryTime CHECK (Status != N'Đã giao' OR DeliveryTime IS NOT NULL)` vào bảng `Orders` bên trong tệp lệnh SQL `FlowerShopDB.sql`. Việc này giúp CSDL từ chối các dữ liệu sai lệch.
2.  **Cập nhật Giao diện (JSP)**:
    *   Tích hợp Checkbox **"Đã thanh toán"** (name: `paymentStatus`) vào biểu mẫu cập nhật đơn hàng trong `admin/manage-orders.jsp` và `employee/manage-orders.jsp`. Checkbox này nhận giá trị hiện tại để người dùng tiện theo dõi và thay đổi.
3.  **Cập nhật Controller (Servlet)**:
    *   Sửa `admin/ManageOrderServlet.java` và `employee/ManageOrderServlet.java`:
        - Xử lý checkbox: Đọc giá trị từ checkbox và gọi `orderDAO.updatePaymentStatus(orderId, paymentStatus);` trước khi cập nhật các trạng thái khác.
        - Khóa logic (Validation): Bổ sung kiểm tra nếu `newStatus` là `"Đã giao"` mà `deliveryTime` mang giá trị `null`, hệ thống sẽ trả về lỗi *"Đơn hàng Đã giao bắt buộc phải có thời gian giao hàng."*.

### Các file được thay đổi:
- `database/FlowerShopDB.sql`
- `web/admin/manage-orders.jsp`
- `web/employee/manage-orders.jsp`
- `src/java/controllers/admin/ManageOrderServlet.java`
- `src/java/controllers/employee/ManageOrderServlet.java`

## 4. Kết quả kiểm tra (Validation Results)
- Giao diện Admin/Employee đã hiển thị phần Checkbox "Đã thanh toán" cùng với trạng thái tương ứng với từng đơn hàng.
- Khi người dùng đánh dấu vào ô "Đã thanh toán" và thực hiện cập nhật, nhãn trạng thái của đơn hàng đã chuyển đổi thành công.
- Cố tình chuyển đổi trạng thái một đơn hàng đang chờ hoặc đang giao sang "Đã giao" mà không nhập liệu ngày giờ, hệ thống lập tức từ chối và hiện thông báo lỗi phản hồi tới người dùng.
