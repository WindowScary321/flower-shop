# Bug: NullPointerException khi đăng nhập và đăng ký (BUG-01 & BUG-02)
Date: 2026-07-19

## 1. Mô tả lỗi (Bug Description)
Trước khi khắc phục, `LoginServlet` và `RegisterServlet` đều gặp lỗi nghiêm trọng (crash 500 error) với ngoại lệ `NullPointerException` nếu người dùng gửi yêu cầu HTTP POST mà không kèm theo các tham số bắt buộc (như `password` hoặc `username`). 
Trong `LoginServlet`, việc truyền `password` bằng `null` vào hàm `PasswordHasher.hash(p)` gây ra NPE. 
Tương tự trong `RegisterServlet`, việc gọi `password.equals(confirm)` khi `password` là `null` cũng gây crash ứng dụng.

## 2. Nguyên nhân (Root Cause)
Các phương thức xử lý yêu cầu (doPost) không thực hiện kiểm tra `null` hoặc rỗng cho các tham số lấy từ `request.getParameter()`. Các biến này được đưa trực tiếp vào các hàm băm mật khẩu hoặc so sánh chuỗi, dẫn đến ngoại lệ.

## 3. Cách khắc phục (Resolution)
Để giải quyết lỗi này, mã nguồn đã được cập nhật để bổ sung kiểm tra hợp lệ của dữ liệu đầu vào.

### Thay đổi trong `LoginServlet.java`
- Bổ sung kiểm tra `null` và chuỗi rỗng (`trim().isEmpty()`) cho `username` và `password`.
- Nếu dữ liệu không hợp lệ, hệ thống sẽ trả về lỗi `Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu.` và chuyển hướng lại trang `login.jsp`.

### Thay đổi trong `RegisterServlet.java`
- Bổ sung kiểm tra `null` và chuỗi rỗng cho tất cả các trường bắt buộc (`username`, `fullname`, `email`, `phone`, `password`, `confirm`).
- Ngăn chặn lỗi khi gọi `.equals()` trên đối tượng null.
- Nếu thiếu trường nào, hệ thống báo lỗi `Vui lòng điền đầy đủ tất cả các trường bắt buộc.` và trả về trang đăng ký.

## 4. Kết quả kiểm tra (Validation Results)
- Hệ thống hoạt động ổn định và không còn bị crash khi bỏ trống các tham số hoặc cố tình gửi request độc hại thiếu tham số.
- Thông báo lỗi hiển thị rõ ràng cho người dùng cuối.
