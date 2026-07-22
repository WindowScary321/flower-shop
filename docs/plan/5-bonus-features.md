# Tính Năng Điểm Thưởng (Bonus Features) — Flower Shop

Đề bài cho phép đạt tối đa 10 điểm thưởng bằng cách triển khai thêm các tính năng nâng cao. Dự án hiện tại đã thực hiện thành công các tính năng điểm thưởng sau đây, mang lại sự chuyên nghiệp và bám sát thực tế thương mại điện tử.

## 5.1. Tổng quan điểm thưởng đã triển khai

| #  | Tính năng                        | Điểm thưởng | Độ khó      | Trạng thái |
|----|----------------------------------|:-----------:|:-----------:|:----------:|
| 1  | Biểu đồ Dashboard (Chart.js)    | +2          | Trung bình  | ✅ Đã làm |
| 2  | Ghi log hệ thống vào DB         | +2          | Dễ          | ✅ Đã làm |
| 3  | Thanh toán qua mã QR            | +2          | Trung bình  | ✅ Đã làm |

> **Tổng điểm thưởng ước tính:** +6 điểm.

---

## 5.2. Chi tiết triển khai từng tính năng

### Tính năng 1: Biểu đồ Dashboard với Chart.js (+2đ)

**Mục đích:** Hiển thị dữ liệu thống kê dưới dạng biểu đồ trực quan (Bar chart, Line chart, v.v.) trên trang Dashboard của Admin. Giúp quản trị viên dễ dàng nắm bắt biến động doanh thu thay vì chỉ xem bảng số liệu.

**Cách triển khai:**
- Nhúng thư viện Chart.js qua CDN (`https://cdn.jsdelivr.net/npm/chart.js`) trong tệp `dashboard.jsp`.
- Lấy dữ liệu thống kê từ `OrderDAO.java` trong `DashboardServlet` (ví dụ lấy danh sách doanh thu theo tháng).
- Truyền dữ liệu sang JSP dưới dạng danh sách các object (`request.setAttribute`).
- Tại JSP, sử dụng thẻ `<c:forEach>` của JSTL để chuyển các cấu trúc dữ liệu Java thành mảng dữ liệu JavaScript, sau đó nạp mảng dữ liệu này vào đối tượng cấu hình của `new Chart(ctx, {...})`.

### Tính năng 2: Ghi log hệ thống đa chiều (Activity Logs) (+2đ)

**Mục đích:** Ghi lại mọi sự kiện quan trọng (đăng nhập, thay đổi thông tin sản phẩm, xử lý đơn hàng, v.v.) để phục vụ cho việc kiểm toán hệ thống. Thay vì log ra file văn bản sơ sài, dự án lưu trực tiếp vào cơ sở dữ liệu để dễ dàng truy vấn.

**Cách triển khai:**
- Thiết kế bảng `ActivityLogs` trong SQL Server với đầy đủ các trường: `LogId`, `AccountId` (nullable), `ActionType`, `Description`, `IpAddress`, `CreatedAt`.
- Viết tiện ích đa năng `ActivityLogger.java` chứa hàm tĩnh `log(HttpServletRequest request, String actionType, String description)` để dễ dàng tái sử dụng ở bất kỳ Servlet nào. Hàm này tự động trích xuất IP và User ID từ Session/Request.
- Cung cấp giao diện quản lý Log cho Admin với bộ lọc mạnh mẽ (theo tên tài khoản, loại hành động, khoảng thời gian) bằng `AdminActivityLogServlet.java`.
- Tính năng này rất thiết thực trong việc truy vết nếu xảy ra thay đổi dữ liệu hoặc hành vi phá hoại (VD: nhân viên thao tác sai làm hỏng dữ liệu).

### Tính năng 3: Thanh toán bằng mã QR (QR Code Payment) (+2đ)

**Mục đích:** Hỗ trợ xu hướng thanh toán không dùng tiền mặt (Cashless). Khi Customer đặt hàng và chọn "Thanh toán QR", hệ thống chuyển hướng người dùng đến giao diện quét mã QR để chuyển khoản.

**Cách triển khai:**
- Trong `CheckoutServlet.java`, sau khi tạo đơn hàng (Transaction) thành công với phương thức thanh toán là `QR`, hệ thống gọi `response.sendRedirect(request.getContextPath() + "/payment-qr")`.
- Cấu hình `PaymentQRServlet.java` để tiếp nhận và đọc `orderId` từ Session (lưu tại lúc Checkout). Lấy thông tin chi tiết đơn hàng từ DB và chuyển qua form hiển thị `payment-qr.jsp`.
- Giao diện có nút "Xác nhận đã thanh toán" để thực hiện `POST` request về Servlet, cho phép cập nhật trạng thái thanh toán sang Thành công (`PaymentStatus = 1`) trong Database và đánh dấu đơn hàng sẵn sàng để xử lý.

