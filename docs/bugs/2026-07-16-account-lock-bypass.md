# Bug: Account Lock Bypass (Session Invalidation Failure)
Date: 2026-07-16

## 1. Mô tả lỗi (Bug Description)
Trước khi khắc phục, hệ thống gặp phải một vấn đề bảo mật liên quan đến việc kiểm soát phiên đăng nhập. Khi một khách hàng (Customer) đã đăng nhập vào hệ thống, nếu Quản trị viên (Admin) tiến hành khóa tài khoản này (chuyển trạng thái `Status = 0` trong cơ sở dữ liệu), khách hàng vẫn có thể tiếp tục duyệt web, thêm sản phẩm vào giỏ hàng và đặt hàng. Trạng thái khóa chỉ thực sự có tác dụng nếu khách hàng chủ động đăng xuất và cố gắng đăng nhập lại ở lần sau.

## 2. Nguyên nhân (Root Cause)
Các bộ lọc phân quyền `AuthenticationFilter` và `AuthorizationFilter` chỉ kiểm tra sự tồn tại của đối tượng `Account` trong `HttpSession` (`session.getAttribute("user")`). Chúng không có cơ chế đối chiếu lại với cơ sở dữ liệu trên mỗi request để xác nhận xem trạng thái hiện tại của tài khoản có còn hợp lệ hay không.

## 3. Cách khắc phục (Resolution)
Để giải quyết triệt để lỗi này, mã nguồn của các bộ lọc đã được cập nhật nhằm xác minh trạng thái thực tế của tài khoản trực tiếp từ cơ sở dữ liệu trên mỗi yêu cầu cần xác thực.

### Thay đổi trong `AuthenticationFilter.java`
- Đã bổ sung thư viện `dal.AccountDAO`.
- Trong phương thức `doFilter`, đối tượng tài khoản lấy từ session sẽ được dùng để gọi hàm `AccountDAO.getAccountById()`.
- Nếu tài khoản không còn tồn tại hoặc thuộc tính `Status` là `false` (đã bị khóa), hệ thống sẽ lập tức gọi `session.invalidate()`, xóa dữ liệu phiên hiện tại và chuyển hướng người dùng về trang đăng nhập với thông báo lỗi phù hợp.

### Thay đổi trong `AuthorizationFilter.java`
- Logic tương tự như trên cũng đã được áp dụng. Điều này không chỉ bảo vệ các tác vụ của khách hàng mà còn ngăn chặn rủi ro nội bộ, giúp vô hiệu hóa ngay lập tức các phiên đăng nhập của Employee hoặc Admin khác nếu tài khoản của họ bị vô hiệu hóa.

## 4. Kết quả kiểm tra (Validation Results)
- Hệ thống hoạt động ổn định và mã nguồn đã được lưu lại thành công.
- Ngay khi Quản trị viên khóa một tài khoản đang truy cập, người dùng đó sẽ lập tức bị đẩy về trang đăng nhập ở lần tương tác tiếp theo với bất kỳ trang nào yêu cầu xác thực.
