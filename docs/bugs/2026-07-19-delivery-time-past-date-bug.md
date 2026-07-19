# Lỗi thiết lập Thời gian giao hàng trong quá khứ

## Triệu chứng
Người dùng (Admin hoặc Employee) có thể tuỳ ý nhập thời gian giao hàng (Delivery Time) là một ngày trong quá khứ (ví dụ: ngày hôm qua, hoặc tuần trước) mà hệ thống không có cảnh báo hay ngăn chặn.

## Nguyên nhân
1. **Phía Giao diện (Frontend)**: Thẻ `<input type="datetime-local">` chưa được thiết lập thuộc tính `min` để giới hạn thời gian nhỏ nhất có thể chọn. Do đó trình duyệt cho phép chọn bất kỳ ngày nào.
2. **Phía Máy chủ (Backend)**: Servlet xử lý cập nhật trạng thái đơn hàng (`ManageOrderServlet`) không có logic kiểm tra tính hợp lệ của biến `deliveryTime` so với thời gian tạo đơn (`orderDate`).

## Cách khắc phục
1. **Frontend (JSP)**:
   - Trong `web/admin/manage-orders.jsp` và `web/employee/manage-orders.jsp`, sử dụng thẻ `<fmt:formatDate>` của JSTL để lấy `order.orderDate` theo định dạng `yyyy-MM-dd'T'HH:mm`.
   - Bổ sung thuộc tính `min="${minOrderDate}"` vào thẻ `<input type="datetime-local">`. Thay đổi này giúp trình duyệt HTML5 tự động chặn người dùng chọn ngày/giờ trước thời điểm khách hàng đặt đơn.
2. **Backend (Java Controller)**:
   - Trong `ManageOrderServlet` (của cả `admin` và `employee`), bổ sung logic kiểm tra:
   ```java
   Order order = orderDAO.getOrderById(orderId);
   if (order != null && deliveryTime != null && deliveryTime.before(order.getOrderDate())) {
       request.getSession().setAttribute("errorMsg", "Thời gian giao hàng không được thiết lập trước thời gian đặt hàng.");
       response.sendRedirect(...);
       return;
   }
   ```
   - Điều này đảm bảo rằng ngay cả khi người dùng can thiệp vào mã HTML để vượt qua thuộc tính `min`, server vẫn từ chối cập nhật thời gian không hợp lệ.
