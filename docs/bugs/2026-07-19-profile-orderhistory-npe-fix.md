# Bug: NullPointerException trong các Endpoint gọi Session (BUG-05)
Date: 2026-07-19

## 1. Mô tả lỗi (Bug Description)
Trước khi khắc phục, người dùng truy cập trực tiếp bằng đường dẫn chưa đăng nhập vào các trang như `/profile` hoặc các POST request có thể gặp lỗi crash màn hình ứng dụng 500 do ngoại lệ `NullPointerException`. 

## 2. Nguyên nhân (Root Cause)
Trong `ProfileServlet` và `OrderHistoryServlet`, đoạn mã lấy thông tin người dùng được gọi thẳng tắp và chuỗi hóa theo mẫu:
`Account user = (Account) request.getSession(false).getAttribute("user");`
Vì phương thức `getSession(false)` có thể trả về `null` nếu phiên làm việc chưa từng được khởi tạo, việc gọi chuỗi `.getAttribute("user")` đằng sau ngay lập tức sẽ làm phát sinh NPE. Mặc dù bộ lọc `AuthenticationFilter` có chức năng bảo vệ các tuyến đường nhất định, `ProfileServlet` có đường dẫn mở `/profile` nằm ngoài phạm vi bảo vệ, dẫn tới việc bất kỳ ai truy cập cũng sẽ gặp sự cố crash.

## 3. Cách khắc phục (Resolution)
Lỗi này được giải quyết bằng cách áp dụng phương pháp lập trình phòng vệ.

### Thay đổi trong `ProfileServlet` và `OrderHistoryServlet`
- Tách thao tác thành 2 bước rõ ràng.
- Gắn biến trung gian cho session: `HttpSession session = request.getSession(false);`.
- Áp dụng biểu thức tam phân để kiểm tra tính tồn tại của session trước khi lấy attribute: `Account user = (session != null) ? (Account) session.getAttribute("user") : null;`.
- Kiểm tra lại biến `user` một lần nữa, nếu là `null` thì đẩy người dùng về trang `/login`.

## 4. Kết quả kiểm tra (Validation Results)
- Endpoint `/profile` có thể được truy cập trực tiếp từ trạng thái ẩn danh mà không làm chết hệ thống, thay vào đó điều hướng người dùng một cách an toàn.
- Cấu trúc phòng vệ chặn các lỗi ngoài ý muốn.
