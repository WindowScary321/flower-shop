# Bug: Lỗi đồng bộ Giỏ Hàng, Giá Tiền và Tồn Kho (BUG-09, BUG-10, BUG-13)
Date: 2026-07-19

## 1. Mô tả lỗi (Bug Description)
- **BUG-09 (Thiếu kiểm tra tồn kho):** Khi cập nhật số lượng trong giỏ hàng (`CartServlet`), hệ thống cho phép khách hàng nhập số lượng tùy ý (ví dụ 999) vượt quá số lượng sản phẩm đang có thật trong kho.
- **BUG-10 (Price Manipulation):** `CheckoutServlet` tính toán tổng tiền dựa trên bộ đệm giá lưu trong Session. Nếu người quản trị (Admin) thay đổi giá (tăng lên hoặc giảm xuống) trong lúc khách hàng đang giữ giỏ hàng, hệ thống vẫn áp dụng giá cũ khi thanh toán.
- **BUG-13 (Discount Bypass):** Lớp `OrderDAO` ghi nhận `UnitPrice` vào Database cho đơn hàng bằng giá nguyên gốc (chưa áp dụng phần trăm giảm giá). Dẫn đến tình trạng giá từng sản phẩm không khớp với tổng tiền hóa đơn (Total Amount).

## 2. Nguyên nhân (Root Cause)
- Không gọi hàm Database để xác thực lại số lượng thực tế khi nhận request `updateCart` từ người dùng.
- Sử dụng trực tiếp đối tượng `Flower` được nhúng sẵn trong danh sách `CartItem` của Session từ những lần khởi tạo ban đầu, khiến dữ liệu bị lạc hậu so với Database.
- Gọi sai phương thức `.getPrice()` thay vì `.getFinalPrice()` trong hàm tạo `OrderDetails` của `OrderDAO`.

## 3. Cách khắc phục (Resolution)
### Thay đổi trong `CartServlet.java`
- Khởi tạo `FlowerDAO` ở hàm xử lý `updateCart`.
- Truy xuất số lượng thật thông qua `f.getQuantity()`. Sử dụng hàm `Math.min(q, f.getQuantity())` để cắt giảm số lượng người dùng yêu cầu xuống bằng với số lượng tối đa trong kho nếu họ cố tình nhập quá mức. Bổ sung thông báo cảnh báo điều chỉnh giỏ hàng.

### Thay đổi trong `CheckoutServlet.java`
- Tại cả 2 hàm `doGet` (khi load trang Thanh toán) và `doPost` (khi xác nhận Đặt hàng), hệ thống duyệt qua danh sách `CartItem` và tải mới dữ liệu của mỗi sản phẩm (`latestFlower`) từ `FlowerDAO`.
- Ghi đè lại đối tượng hoa cũ bằng dữ liệu vừa refresh, đảm bảo Tổng Tiền (Total Price) được tính toán luôn là giá trị mới nhất.

### Thay đổi trong `OrderDAO.java`
- Cập nhật luồng insert vào `OrderDetails`, đổi `stDetail.setDouble(4, item.getFlower().getPrice())` thành `stDetail.setDouble(4, item.getFlower().getFinalPrice())` để đồng nhất với giá khách hàng thấy.

## 4. Kết quả kiểm tra (Validation Results)
- Giá tiền đơn hàng và chi tiết đơn hàng đồng nhất tuyệt đối, ngăn chặn gian lận thao túng giá.
- Không thể lợi dụng giỏ hàng cũ để mua hàng giá đã hết hạn, hoặc đặt hàng số lượng ảo.
