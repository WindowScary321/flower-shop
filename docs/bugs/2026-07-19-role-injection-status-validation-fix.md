# Bug: Lỗ hổng Role Injection và Validation trạng thái (BUG-06, BUG-07, BUG-08)
Date: 2026-07-19

## 1. Mô tả lỗi (Bug Description)
- **BUG-06 (Role Injection):** Admin có thể tạo tài khoản với role tùy ý mà không bị giới hạn do backend không kiểm tra dữ liệu đầu vào của tham số `role`.
- **BUG-07 (Validation trạng thái đơn hàng):** Admin và Employee có thể cập nhật sai trạng thái của những đơn hàng đã bị hủy hoặc đã hoàn thành giao hàng, dẫn đến sai lệch kho hàng.
- **BUG-08 (Delivery Time Crash):** Nếu chuỗi thời gian giao hàng nhập vào bị sai định dạng, hàm `java.sql.Timestamp.valueOf()` ném ra ngoại lệ `IllegalArgumentException` làm crash ứng dụng (HTTP 500).

## 2. Nguyên nhân (Root Cause)
- Các dữ liệu từ request như `role` hay `newStatus` được truyền thẳng vào Database / DAO mà không qua bước đối chiếu (validate) với danh sách hợp lệ.
- Thiếu khối `try-catch` chuyên biệt để bắt lỗi parse định dạng ngày tháng phía backend.

## 3. Cách khắc phục (Resolution)
### Thay đổi trong `ManageAccountServlet.java`
- Bổ sung kiểm tra cứng danh sách các vai trò (Role): `admin`, `employee`, `customer`. Bất kỳ giá trị nào khác đều bị từ chối và trả về lỗi.

### Thay đổi trong `ManageOrderServlet.java` (Admin và Employee)
- Bọc khối `Timestamp.valueOf` vào trong `try-catch(IllegalArgumentException)`. Trả về thông báo lỗi "Định dạng thời gian giao hàng không hợp lệ" nếu gặp lỗi.
- Kiểm tra trạng thái hiện tại của `Order` trước khi cập nhật. Nếu đơn đang ở trạng thái "Đã giao" hoặc "Đã hủy", từ chối mọi nỗ lực thay đổi trạng thái khác.

## 4. Kết quả kiểm tra (Validation Results)
- Hệ thống chặn đứng các Request sửa đổi độc hại, từ chối tạo role bất hợp pháp.
- Đơn hàng đã hủy không thể bị thao tác nhầm để khôi phục trạng thái.
- Hệ thống hoạt động mượt mà, không gặp lỗi 500 khi Admin/Employee truyền sai định dạng ngày.
