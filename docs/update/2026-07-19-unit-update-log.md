# Giới hạn Đơn vị tính Sản phẩm (Cây và Bó)

- **Thời gian**: 2026-07-19
- **Mục tiêu**: Thay đổi cấu trúc và dữ liệu trong cơ sở dữ liệu để giới hạn đơn vị tính (`Unit`) của sản phẩm hoa chỉ còn lại 2 đơn vị là **Cây** (cho hoa lẻ) và **Bó** (cho các bó hoa cắm nhiều bông). Loại bỏ hoàn toàn các đơn vị cũ khác như `Bông`, `Đóa`, `Nhành`, `Giỏ`, `Lẵng`, `Vòng`, `Chậu`.

## Các thay đổi chính

### CSDL (Database)
- Cập nhật thuộc tính mặc định của cột `Unit` trong bảng `Flowers`: `Unit NVARCHAR(50) DEFAULT N'Cây'`.
- Ánh xạ (migration) toàn bộ dữ liệu hoa mẫu sang 2 đơn vị mới:
  - Hoa lẻ chuyển thành **Cây** (VD: *Hoa hồng lẻ (1 bông)* đổi tên thành *Hoa hồng lẻ (1 cây)*).
  - Giỏ, lẵng, bó, chậu chuyển thành **Bó**.

### Views (Giao diện Quản trị viên)
- `admin/manage-flowers.jsp`: Thay thế trường nhập liệu tự do `<input type="text" name="unit">` thành thẻ `<select name="unit" class="form-select">` với 2 tùy chọn cố định là `Cây` và `Bó` ở cả modal Thêm và modal Cập nhật sản phẩm.

### Tài liệu (Docs)
- `docs/2-database-design.md`: Cập nhật mô tả kiểu dữ liệu mặc định của cột `Unit` thành `N'Cây'`, thay đổi tùy chọn đơn vị thành `Cây hoặc Bó`.
- `docs/3-business-logic.md`: Cập nhật nội dung câu hỏi đáp liên quan đến việc mua cùng lúc "cây" và "bó" hoa hồng.
