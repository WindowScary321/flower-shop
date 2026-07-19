# Tính năng Thời gian giao hàng (Delivery Time)

- **Thời gian**: 2026-07-19
- **Mục tiêu**: Bổ sung tính năng thiết lập thời gian giao hàng cho các đơn hàng để cửa hàng chủ động sắp xếp nhân sự và chuẩn bị hoa. Khách hàng không tự chọn thời gian khi đặt hàng, mà chỉ nhận được thông báo thời gian giao từ phía cửa hàng.

## Các thay đổi chính

### CSDL (Database)
- Bổ sung cột `DeliveryTime` kiểu `DATETIME` vào bảng `Orders` trong `FlowerShopDB.sql`.
- Cập nhật các câu lệnh `INSERT` mock data để chứa dữ liệu ngày giờ hợp lệ.

### Models & DAOs
- Thêm trường `deliveryTime` kiểu `java.sql.Timestamp` vào `models/Order.java`.
- Cập nhật hàm `extractOrder` trong `dal/OrderDAO.java` để parse dữ liệu thời gian.
- Thêm phương thức `updateOrderStatusAndDeliveryTime` vào `OrderDAO` nhằm hỗ trợ cập nhật đồng thời cả trạng thái và thời gian.

### Giao diện quản lý (Admin / Employee)
- Sửa đổi `manage-orders.jsp` của cả hai Role.
- Hiển thị thời gian giao nếu đơn hàng đã được ấn định giờ.
- Gắn thẻ `<input type="datetime-local">` bên cạnh nút Submit cập nhật trạng thái để staff dễ dàng chọn ngày giờ.
- Các Servlet tương ứng `ManageOrderServlet` nhận tham số này, chuyển đổi từ String sang `Timestamp` rồi gọi DAO để lưu xuống database.

### Giao diện Khách hàng (Customer)
- Trong trang `order-history.jsp`, bổ sung hiển thị Thời gian giao hàng.
- Nếu DB trả về NULL (chưa được thiết lập), hệ thống hiển thị dòng chữ: "Đang chờ sắp xếp".
