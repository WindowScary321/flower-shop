# Triển khai Hệ thống Activity Logging

- **Thời gian**: 2026-07-21
- **Mục tiêu**: Xây dựng hệ thống ghi nhật ký hoạt động của người dùng toàn diện nhằm mục đích giám sát, bảo mật và hỗ trợ quản trị viên.

## Các thay đổi chính

### Cấu trúc cơ sở dữ liệu (Database)
- **Bảng `ActivityLogs`**: Tạo mới bảng lưu trữ dữ liệu log bao gồm: AccountId, Username, ActionType, Description, IpAddress, và CreatedAt.
- **Dữ liệu mẫu**: Bổ sung một số log mẫu vào database phục vụ quá trình phát triển và kiểm thử ban đầu.

### Nền tảng và Cấu hình (Infrastructure)
- **Docker Compose**:
  - Bổ sung môi trường múi giờ `TZ=Asia/Ho_Chi_Minh` cho cả service `webapp` (Tomcat) và `sqlserver`. Đảm bảo thời gian log được ghi nhận theo múi giờ Việt Nam (UTC+7).

### Model và Data Access Layer (DAL)
- **ActivityLog.java**: POJO đại diện cho một bản ghi log.
- **ActivityLogDAO.java**: Class DAO chuyên trách tương tác DB: thêm mới (`insertLog`), đếm và truy vấn phân trang (`searchLogsPaging`).
- **ActivityLogger.java**: Lớp tiện ích tĩnh (Utility class) giúp ghi log dễ dàng từ mọi nơi (controllers, filters) chỉ bằng một hàm gọi duy nhất, tự động trích xuất thông tin người dùng từ session và IP từ request.

### Cập nhật nghiệp vụ Giỏ hàng (Cart)
- **Chặn khách vãng lai**: 
  - Sửa đổi `CartServlet.java` để yêu cầu đăng nhập trước khi thao tác thêm/sửa/xóa giỏ hàng.
  - Redirect về trang đăng nhập với thông báo nếu người dùng chưa có tài khoản.
  - Ghi nhận log cho các hành động thao tác thành công (`ADD_TO_CART`, `UPDATE_CART`, `REMOVE_FROM_CART`).

### Cập nhật các Controller (Servlets)
Đã tích hợp ghi log bằng `ActivityLogger.log()` vào toàn bộ các tiến trình quan trọng:
- **Authentication**: `LoginServlet` (đăng nhập thành công/thất bại), `LogoutServlet`, `RegisterServlet`.
- **Customer**: `CheckoutServlet` (thanh toán thành công/thất bại), `OrderHistoryServlet` (hủy đơn hàng), `ProfileServlet` (cập nhật thông tin/đổi mật khẩu).
- **Employee/Admin**: `ManageOrderServlet` (Ghi rõ trạng thái cũ và mới khi nhân viên hoặc admin thay đổi trạng thái đơn).
- **Admin CRUD**: `ManageFlowerServlet`, `ManageCategoryServlet`, `ManageAccountServlet` (Khóa/mở khóa tài khoản, tạo mới, v.v.).

### Giao diện Quản trị (Admin UI)
- **AdminActivityLogServlet**: Tạo mới servlet xử lý URL `/admin/activity-logs`.
- **activity-logs.jsp**: Trang giao diện mới dành cho admin hiển thị bảng log, form lọc nhiều điều kiện (ActionType, Username, Date) và hỗ trợ phân trang.
- **Bảo mật**: Truy cập vào log chỉ được cho phép đối với tài khoản `admin` thông qua bộ lọc `AuthorizationFilter` sẵn có.
- **Sidebar**: Tích hợp liên kết "Nhật ký hoạt động" vào menu điều hướng `/common/sidebar-admin.jsp`.
