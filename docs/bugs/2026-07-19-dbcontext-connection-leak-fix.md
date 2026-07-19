# Bug: Rò rỉ kết nối cơ sở dữ liệu (JDBC Connection Leak) (BUG-03)
Date: 2026-07-19

## 1. Mô tả lỗi (Bug Description)
Trước khi khắc phục, toàn bộ hệ thống gặp vấn đề rò rỉ kết nối cơ sở dữ liệu rất nghiêm trọng. Theo thời gian, nếu số lượng người truy cập tăng lên, ứng dụng sẽ có khả năng làm cạn kiệt tài nguyên kết nối (Connection Pool Exhaustion) trên SQL Server dẫn đến ứng dụng bị treo hoặc báo lỗi không thể kết nối tới cơ sở dữ liệu.

## 2. Nguyên nhân (Root Cause)
Lớp cơ sở `dal.DBContext` mở một kết nối (Connection) trong hàm khởi tạo (constructor) nhưng lại không hề có phương thức nào để đóng (`close()`) kết nối này lại. Do đó, mỗi khi một đối tượng DAO mới được tạo (ví dụ `new OrderDAO()`), một kết nối mới sẽ được cấp phát và giữ nguyên trạng thái mở vĩnh viễn vì không bao giờ được trả về hoặc giải phóng.
Tình trạng này càng nghiêm trọng khi các bộ lọc phân quyền như `AuthorizationFilter` và `AuthenticationFilter` cũng khởi tạo đối tượng `AccountDAO` trên mỗi luồng request đến.

## 3. Cách khắc phục (Resolution)
Để giải quyết lỗi này, mã nguồn đã được cập nhật để bổ sung cơ chế đóng kết nối cơ sở dữ liệu một cách an toàn.

### Thay đổi trong `DBContext.java`
- Lớp `DBContext` đã được sửa đổi để implement interface `AutoCloseable`.
- Bổ sung phương thức `close()` kiểm tra kết nối hợp lệ và gọi `connection.close()` để trả tài nguyên lại hệ thống.

### Cập nhật ở các tầng Controller và Filter
- Xóa bỏ việc tái sử dụng chung đối tượng DAO ở tầng Servlet (được mô tả chi tiết ở file bug thread-safety).
- Tại mỗi vị trí hàm hoặc phương thức khởi tạo DAO (bao gồm cả `AuthorizationFilter.java` và `AuthenticationFilter.java`), sau khi kết thúc truy vấn, lệnh `dao.close()` đã được thêm vào một cách tường minh để đảm bảo kết nối bị hủy và dọn dẹp khỏi bộ nhớ.

## 4. Kết quả kiểm tra (Validation Results)
- Hệ thống giải phóng tài nguyên một cách chuẩn xác sau mỗi chu kỳ thao tác dữ liệu. Không còn tình trạng tăng số lượng session mở không thể kiểm soát ở cơ sở dữ liệu.
