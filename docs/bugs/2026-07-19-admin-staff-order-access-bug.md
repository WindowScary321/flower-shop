# Bug: Lỗi Nhân viên và Quản trị viên có thể tiếp cận chức năng đặt hàng (Admin and Staff Order Access Bug)
Date: 2026-07-19

## 1. Mô tả lỗi (Bug Description)
Trên hệ thống, các tài khoản Nhân viên (Staff/Employee) và Quản trị viên (Admin) vẫn có thể nhìn thấy nút "Thêm vào giỏ hàng" hoặc "Xem giỏ hàng" ở các trang danh mục và chi tiết hoa. Đồng thời, các tài khoản này vẫn có thể truy cập trực tiếp vào các đường dẫn đặt hàng như `/cart` hoặc `/checkout` thông qua thanh địa chỉ trình duyệt, dẫn đến việc họ có thể thực hiện thao tác đặt hàng vốn chỉ dành cho Khách hàng (Customer) hoặc khách vãng lai.

## 2. Nguyên nhân (Root Cause)
- **Giao diện (Frontend)**: Trong các file `flower-catalog.jsp` và `flower-detail.jsp`, điều kiện để hiển thị các form và nút bấm thêm giỏ hàng chỉ xét dựa vào số lượng tồn kho (`quantity > 0`), mà không kiểm tra quyền (role) của phiên đăng nhập hiện tại.
- **Hệ thống (Backend)**: Bộ lọc phân quyền (`AuthorizationFilter.java`) chưa được đăng ký để kiểm tra các đường dẫn liên quan đến chức năng đặt mua hàng (`/cart`, `/checkout`, `/checkout-success`, `/payment-qr`). Dẫn đến việc bất kì ai đăng nhập xong cũng có thể truy cập nếu gõ URL.

## 3. Cách khắc phục (Resolution)
1.  **Cập nhật Giao diện (JSP)**:
    *   Trong [flower-catalog.jsp](file:///c:/Users/tusieumap/Projects/prj302/flower-shop/web/flower-catalog.jsp) và [flower-detail.jsp](file:///c:/Users/tusieumap/Projects/prj302/flower-shop/web/flower-detail.jsp): Bổ sung thêm điều kiện hiển thị nút thêm giỏ hàng, bằng cách kiểm tra tài khoản chưa đăng nhập hoặc có quyền là `customer` (`empty sessionScope.user or sessionScope.user.role == 'customer'`).
2.  **Cập nhật Filter phân quyền**:
    *   Tại [AuthorizationFilter.java](file:///c:/Users/tusieumap/Projects/prj302/flower-shop/src/java/filter/AuthorizationFilter.java): Thêm các URL của giỏ hàng và thanh toán vào mảng `urlPatterns`.
    *   Bổ sung logic chặn truy cập: Nếu tài khoản cố truy cập các trang mua hàng nhưng có vai trò không phải `customer`, hệ thống sẽ điều hướng người dùng về trang đăng nhập với thông báo lỗi *"Tài khoản của bạn không có quyền thực hiện chức năng mua hàng."*.

### Các file được thay đổi:
- `web/flower-catalog.jsp`
- `web/flower-detail.jsp`
- `src/java/filter/AuthorizationFilter.java`

## 4. Kết quả kiểm tra (Validation Results)
- Giao diện mua hàng đối với Khách vãng lai và Khách hàng đã đăng nhập (`Customer`) hoạt động bình thường như mong đợi.
- Đăng nhập với tư cách Nhân viên (`Employee`) hoặc Quản trị viên (`Admin`), toàn bộ nút chức năng liên quan đến giỏ hàng ở các trang hoa đều bị ẩn đi.
- Khi sử dụng tài khoản `Admin` hoặc `Employee` cố ý truy cập qua URL `/cart` hoặc `/checkout`, hệ thống lập tức từ chối và đẩy về trang đăng nhập.
