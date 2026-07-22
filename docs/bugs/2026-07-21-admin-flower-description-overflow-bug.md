# Bug: Mô tả sản phẩm bị tràn trang quản trị (Admin)

- **Thời gian**: 2026-07-21
- **Mức độ**: Trung bình (UI/UX)
- **Commit**: `d9f91ab`

## Mô tả lỗi

Trên trang quản lý sản phẩm hoa (`/admin/manage-flowers`), khi một sản phẩm có trường Mô tả chứa ký tự đặc biệt (dấu nháy đơn `'`, xuống dòng, hoặc thẻ HTML), toàn bộ nội dung mô tả bị tràn ra ngoài bảng và phá vỡ giao diện trang.

## Nguyên nhân gốc

Nút "Chỉnh sửa" sử dụng thuộc tính `onclick` để gọi trực tiếp hàm JavaScript với dữ liệu mô tả được nối chuỗi thô:

```jsp
onclick="fillEditModal(${f.flowerId}, '${f.flowerName}', '${f.description}', ...)"
```

Khi `${f.description}` chứa dấu `'` hoặc ký tự xuống dòng, chuỗi JavaScript bị bẻ gãy cú pháp. Trình duyệt hiểu phần còn lại của tham số là nội dung HTML thuần, khiến text bị render trực tiếp ra ngoài nút bấm và tràn ra ngoài bảng.

## File bị ảnh hưởng

- `web/admin/manage-flowers.jsp` — 33 dòng thêm, 14 dòng xóa.

## Cách khắc phục

1. **Chuyển sang dùng HTML5 `data-*` attributes**: Thay vì truyền dữ liệu qua `onclick`, gán dữ liệu vào các thuộc tính `data-id`, `data-name`, `data-desc`,... trên thẻ `<button>`.
2. **Dùng `<c:out>` để escape**: Bọc giá trị bằng `<c:out value='${f.description}'/>` để tự động mã hóa ký tự đặc biệt thành HTML entities an toàn.
3. **Sửa JavaScript**: Thay hàm `fillEditModal()` bằng event listener đọc dữ liệu từ `this.getAttribute('data-*')`.
