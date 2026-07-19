# Bug: Rủi ro XSS & Lỗi Filter Phân Trang (BUG-11, BUG-14)
Date: 2026-07-19

## 1. Mô tả lỗi (Bug Description)
- **BUG-11 (Tiềm ẩn XSS):** Tại các màn hình `login.jsp`, `register.jsp` và `checkout.jsp`, các chuỗi báo lỗi (error message) và thành công (success message) được kết xuất (render) trực tiếp bằng mã EL cơ bản (`${error}`) mà không thông qua bất kỳ cơ chế làm sạch mã HTML nào (escaping). Điều này tạo ra rủi ro chèn ép mã độc (Cross-Site Scripting - XSS).
- **BUG-14 (URL Param Encoding):** Tại màn hình Quản lý đơn hàng (`manage-orders.jsp`), thanh phân trang (pagination) chứa các đường link cứng kèm theo bộ lọc (`status`, `fromDate`, `toDate`). Nếu trạng thái có dấu cách hoặc ký tự tiếng Việt (như `Chờ xử lý`), trình duyệt có thể mã hóa sai đường link, làm người dùng bị rớt bộ lọc (mất filter) khi chuyển qua trang thứ 2.

## 2. Nguyên nhân (Root Cause)
- Mã nguồn JSP cũ không sử dụng thư viện JSTL Core tiêu chuẩn `<c:out>` cho việc in chuỗi an toàn.
- Link phân trang trong thẻ `<a>` ghép trực tiếp biến `$ {}` vào URL mà không encode (mã hóa URL tiêu chuẩn).

## 3. Cách khắc phục (Resolution)
### Khắc phục XSS (BUG-11)
- Xóa bỏ việc in trực tiếp thông điệp (`${error}`).
- Thay thế toàn bộ bằng cú pháp `<c:out value="${error}" />` tại `login.jsp`, `register.jsp` và `checkout.jsp`. JSTL sẽ tự động chuyển đổi các ký tự `<, >, &, "` thành mã thực thể HTML (`&lt;`, `&gt;`, v.v), biến mã độc thành chuỗi text thuần túy.

### Khắc phục Encoding (BUG-14)
- Sửa lại đoạn lặp `c:forEach` tạo thanh phân trang trong `manage-orders.jsp`.
- Áp dụng cấu trúc `<c:url>` và `<c:param>` để JSTL tự động bóc tách và mã hóa các biến chứa dấu cách và ký tự UTF-8 thành định dạng URL an toàn (ví dụ: `Ch%E1%BB%9D%20x%E1%BB%AD%20l%C3%BD`) trước khi chèn vào `href`.

## 4. Kết quả kiểm tra (Validation Results)
- Hệ thống miễn nhiễm với các payload XSS chèn vào chuỗi báo lỗi từ backend.
- Phân trang đơn hàng hoạt động chính xác bất kể bộ lọc tìm kiếm có phức tạp hay chứa từ khóa tiếng Việt đến đâu.
