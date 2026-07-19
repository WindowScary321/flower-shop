# Bug: Lỗi hiển thị ảnh sản phẩm với URL ngoài (External Image URL Display Bug)
Date: 2026-07-19

## 1. Mô tả lỗi (Bug Description)
Khi Quản trị viên (hoặc Nhân viên) thêm một sản phẩm mới (ví dụ: hoa test) và cung cấp đường dẫn URL trực tiếp đến một hình ảnh trên mạng (bắt đầu bằng `http://` hoặc `https://`), khách hàng sẽ không thể nhìn thấy hình ảnh của sản phẩm đó. Thay vào đó, hệ thống chỉ hiển thị ảnh mặc định dự phòng (placeholder) có chữ "Flower".

## 2. Nguyên nhân (Root Cause)
Các trang giao diện (JSP) được cấu hình cứng để luôn nối thêm đường dẫn thư mục gốc (`${pageContext.request.contextPath}/images/flowers/`) vào trước tên file ảnh của sản phẩm. Điều này khiến cho các URL hợp lệ bắt đầu bằng `http://` hoặc `https://` bị ghép thành một đường dẫn sai định dạng (ví dụ: `/flower-shop/images/flowers/https://example.com/image.jpg`), dẫn đến việc trình duyệt không thể tải được ảnh và kích hoạt sự kiện `onerror` để hiển thị ảnh dự phòng mặc định.

## 3. Cách khắc phục (Resolution)
Để giải quyết lỗi này, mã nguồn hiển thị ảnh đã được cập nhật để kiểm tra thông minh định dạng của chuỗi hình ảnh. Nếu hình ảnh chứa URL đầy đủ (bắt đầu bằng `http://` hoặc `https://`), hệ thống sẽ sử dụng trực tiếp URL đó. Ngược lại, hệ thống mới tự động thêm đường dẫn thư mục `/images/flowers/` vào trước tên file.

### Các file được thay đổi:
- `web/index.jsp` (Trang chủ)
- `web/flower-catalog.jsp` (Trang tất cả sản phẩm)
- `web/flower-detail.jsp` (Trang chi tiết sản phẩm)
- `web/cart.jsp` (Giỏ hàng)
- `web/admin/manage-flowers.jsp` (Trang quản lý kho của admin)

**Chi tiết đoạn code thay đổi (sử dụng JSTL):**
```jsp
<c:set var="imgUrl" value="${pageContext.request.contextPath}/images/flowers/${empty f.image ? 'placeholder.jpg' : f.image}" />
<c:if test="${not empty f.image and (f.image.startsWith('http://') or f.image.startsWith('https://'))}">
    <c:set var="imgUrl" value="${f.image}" />
</c:if>
<img src="${imgUrl}" ...>
```

## 4. Kết quả kiểm tra (Validation Results)
- Hệ thống hoạt động chính xác cho cả 2 trường hợp: Ảnh cục bộ tải vào bằng tên file (ví dụ: `rose.jpg`) và ảnh từ URL ngoài (ví dụ: `https://.../rose.jpg`).
- Khi thêm sản phẩm "hoa test" bằng link mạng, hình ảnh sản phẩm đã hiển thị bình thường trên mọi mặt của trang web.
