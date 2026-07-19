# Nhật ký Cập nhật: Giới hạn Đơn vị tính Sản phẩm (Cây và Bó)

*Ngày thực hiện: 2026-07-19*

## 1. Yêu cầu Thay đổi
- Thay đổi cấu trúc và dữ liệu trong cơ sở dữ liệu để giới hạn đơn vị tính (`Unit`) của sản phẩm hoa chỉ còn lại 2 đơn vị là **Cây** (cho hoa lẻ) và **Bó** (cho các bó hoa cắm nhiều bông).
- Loại bỏ hoàn toàn các đơn vị cũ khác như `Bông`, `Đóa`, `Nhành`, `Giỏ`, `Lẵng`, `Vòng`, `Chậu`.
- Cập nhật giao diện quản lý hoa phía Admin để hạn chế nhập tay, bắt buộc chọn 1 trong 2 đơn vị mới.
- Cập nhật tài liệu thiết kế hệ thống tương ứng.

## 2. Các thay đổi chi tiết

### 2.1. Cấu trúc Database & Dữ liệu mẫu (`FlowerShopDB.sql`)
- Cập nhật thuộc tính mặc định của cột `Unit` trong bảng `Flowers`:
  ```sql
  Unit NVARCHAR(50) DEFAULT N'Cây'
  ```
- Thực hiện ánh xạ (migration) toàn bộ dữ liệu hoa mẫu sang 2 đơn vị mới theo nguyên tắc:
  - Các loại hoa lẻ bán lẻ từng bông/cành (ví dụ: *Hoa hồng lẻ (1 bông)*, *Nhành lan hồ điệp*, *Hoa cẩm chướng*) chuyển đơn vị tính thành **Cây**.
  - Các loại giỏ hoa, lẵng hoa, vòng hoa, bó hoa, chậu hoa cắm sẵn chuyển đơn vị tính thành **Bó**.
- Sơ đồ ánh xạ cụ thể cho 18 sản phẩm hoa mẫu:
  | Tên hoa gốc | Đơn vị cũ | Đơn vị mới | Trạng thái / Tên mới |
  |---|---|---|---|
  | Bó hồng đỏ 20 bông | Bó | Bó | Giữ nguyên |
  | Giỏ hoa hướng dương | Giỏ | Bó | Chuyển đổi |
  | Bó hoa cưới cầm tay | Bó | Bó | Giữ nguyên |
  | Lẵng hoa khai trương | Lẵng | Bó | Chuyển đổi |
  | Bó hoa ly trắng | Bó | Bó | Giữ nguyên |
  | Hoa cúc vàng chia buồn | Vòng | Bó | Chuyển đổi |
  | Bó hoa tulip hỗn hợp | Bó | Bó | Giữ nguyên |
  | Hoa cưới pastel | Bó | Bó | Giữ nguyên |
  | Giỏ hoa chúc mừng | Giỏ | Bó | Chuyển đổi |
  | Bó hoa lan hồ điệp | Bó | Bó | Giữ nguyên |
  | Hoa hồng lẻ (1 bông) | Bông | Cây | Đổi tên thành: *Hoa hồng lẻ (1 cây)* |
  | Nhành lan hồ điệp | Nhành | Cây | Chuyển đổi |
  | Hoa cẩm chướng | Bông | Cây | Chuyển đổi |
  | Giỏ hoa sen trắng | Giỏ | Bó | Chuyển đổi |
  | Bó hoa cẩm tú cầu | Bó | Bó | Giữ nguyên |
  | Hoa đồng tiền đỏ | Lẵng | Bó | Chuyển đổi |
  | Chậu lan hồ điệp | Chậu | Cây | Chuyển đổi |
  | Bó hoa baby trắng | Bó | Bó | Giữ nguyên |

### 2.2. Giao diện Quản trị viên (`manage-flowers.jsp`)
- **Modal Thêm mới sản phẩm:**
  - Thay thế trường nhập liệu tự do `<input type="text" name="unit" class="form-control" value="Bông">` thành thẻ `<select>` dropdown cố định:
    ```html
    <select name="unit" class="form-select" required>
        <option value="Cây" selected>Cây</option>
        <option value="Bó">Bó</option>
    </select>
    ```
- **Modal Cập nhật sản phẩm:**
  - Thay thế `<input>` text tương tự thành thẻ `<select name="unit" id="edit-unit" class="form-select">`.
  - Bộ gán giá trị tự động bằng Javascript (`document.getElementById('edit-unit').value = unit;`) tiếp tục hoạt động bình thường nhờ giá trị được đồng bộ hóa.

### 2.3. Tài liệu Hệ thống (`docs/`)
- **[docs/2-database-design.md](./docs/2-database-design.md):** Cập nhật mô tả kiểu dữ liệu mặc định của cột `Unit` từ `N'Bông'` sang `N'Cây'`, và thay đổi giải thích các tùy chọn đơn vị thành `Cây hoặc Bó`.
- **[docs/3-business-logic.md](./docs/3-business-logic.md):** Cập nhật nội dung câu hỏi đáp của Giảng viên về nghiệp vụ mua cùng lúc "1 bông hoa hồng" và "1 đóa hoa hồng" thành mua cùng lúc "1 cây hoa hồng" và "1 bó hoa hồng".

---
*Ghi chú: Sau khi cập nhật, script database đã được thực thi lại thành công thông qua file `database/recreate-db.bat`.*
