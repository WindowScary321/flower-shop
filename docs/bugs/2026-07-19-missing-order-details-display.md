# Bug: Lỗi thiếu hiển thị chi tiết danh sách hoa trong đơn đặt hàng (Missing Order Details Display Bug)
Date: 2026-07-19

## 1. Mô tả lỗi (Bug Description)
Trên giao diện quản lý đơn đặt hàng của Nhân viên, Quản trị viên và trang Lịch sử đơn hàng của Khách hàng, hệ thống chỉ hiển thị các thông tin chung của đơn hàng như Mã ĐH, Người nhận, SĐT, Địa chỉ và Tổng tiền. Cả người bán và người mua đều không có cách nào biết được chính xác đơn hàng đó gồm những sản phẩm hoa cụ thể nào.

## 2. Nguyên nhân (Root Cause)
- Lớp dữ liệu [Order.java](file:///c:/Users/tusieumap/Projects/prj302/flower-shop/src/java/models/Order.java) chưa định nghĩa thuộc tính danh sách chi tiết đơn hàng để truyền dữ liệu.
- Các Servlet Controller (`ManageOrderServlet` cho cả employee/admin và `OrderHistoryServlet` cho customer) sau khi lấy danh sách `Order` từ cơ sở dữ liệu đã không gọi lớp truy xuất dữ liệu `OrderDetailDAO` để nạp các dòng chi tiết sản phẩm.
- Các tệp giao diện (JSP) chưa thiết kế cấu trúc vòng lặp để hiển thị danh sách sản phẩm.

## 3. Cách khắc phục (Resolution)
Để khắc phục lỗi này, hệ thống đã được tái cấu trúc toàn diện từ mô hình dữ liệu đến giao diện:

1.  **Cập nhật Mô hình dữ liệu (Model)**:
    *   Bổ sung thêm 3 thuộc tính hiển thị `flowerName`, `unit`, `image` vào [OrderDetail.java](file:///c:/Users/tusieumap/Projects/prj302/flower-shop/src/java/models/OrderDetail.java).
    *   Bổ sung thêm thuộc tính danh sách `List<OrderDetail> details` cùng getter/setter vào [Order.java](file:///c:/Users/tusieumap/Projects/prj302/flower-shop/src/java/models/Order.java).
2.  **Cập nhật DAL**:
    *   Cập nhật hàm `getOrderDetailsByOrderId` trong [OrderDetailDAO.java](file:///c:/Users/tusieumap/Projects/prj302/flower-shop/src/java/dal/OrderDetailDAO.java) để gán đầy đủ tên hoa, đơn vị tính và liên kết ảnh từ câu truy vấn `JOIN`.
3.  **Cập nhật Controller (Servlet)**:
    *   Trong các lớp [ManageOrderServlet (Nhân viên)](file:///c:/Users/tusieumap/Projects/prj302/flower-shop/src/java/controllers/employee/ManageOrderServlet.java), [ManageOrderServlet (Quản trị)](file:///c:/Users/tusieumap/Projects/prj302/flower-shop/src/java/controllers/admin/ManageOrderServlet.java) và [OrderHistoryServlet (Khách hàng)](file:///c:/Users/tusieumap/Projects/prj302/flower-shop/src/java/controllers/customer/OrderHistoryServlet.java), tiến hành dùng `OrderDetailDAO` truy vấn nạp thuộc tính `details` cho từng đơn hàng trước khi chuyển tiếp dữ liệu đến JSP.
4.  **Cập nhật giao diện (JSP)**:
    *   Thêm nút xem chi tiết biểu tượng con mắt và cấu trúc Collapse trong [manage-orders.jsp (nhân viên)](file:///c:/Users/tusieumap/Projects/prj302/flower-shop/web/employee/manage-orders.jsp) và [manage-orders.jsp (admin)](file:///c:/Users/tusieumap/Projects/prj302/flower-shop/web/admin/manage-orders.jsp).
    *   Tái cấu trúc giao diện hiển thị 2 cột trong [order-history.jsp](file:///c:/Users/tusieumap/Projects/prj302/flower-shop/web/customer/order-history.jsp) để liệt kê trực quan danh sách sản phẩm của đơn hàng.

### Các file được thay đổi:
- `src/java/models/OrderDetail.java`
- `src/java/models/Order.java`
- `src/java/dal/OrderDetailDAO.java`
- `src/java/controllers/employee/ManageOrderServlet.java`
- `src/java/controllers/admin/ManageOrderServlet.java`
- `src/java/controllers/customer/OrderHistoryServlet.java`
- `web/employee/manage-orders.jsp`
- `web/admin/manage-orders.jsp`
- `web/customer/order-history.jsp`

## 4. Kết quả kiểm tra (Validation Results)
- Biên dịch thành công dự án mà không có lỗi.
- Đăng nhập với các vai trò khác nhau và kiểm tra giao diện đơn đặt hàng:
  - Khách hàng thấy danh sách hoa, số lượng, hình ảnh trực quan ngay trên mỗi thẻ đơn hàng của trang lịch sử đơn hàng.
  - Nhân viên và Admin có nút bấm xem chi tiết từng đơn hàng trên danh sách quản lý đơn hàng, hoạt động mượt mà không làm vỡ bố cục chung.
