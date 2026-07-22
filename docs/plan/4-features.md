# Yêu Cầu Chức Năng Chi Tiết — Flower Shop

## 4.1. Danh sách CRUD cho 5 thực thể nghiệp vụ

Dưới đây là danh sách 5 thực thể cốt lõi của dự án, mỗi thực thể cần triển khai
đầy đủ cả 4 thao tác Create, Read, Update, Delete.

### 4.1.1. Categories (Danh mục hoa)

| Thao tác | Mô tả                                         | Servlet                    | JSP                     |
|----------|------------------------------------------------|----------------------------|--------------------------|
| Create   | Admin thêm danh mục mới (tên + mô tả)         | ManageCategoryServlet      | category-form.jsp        |
| Read     | Hiển thị danh sách danh mục dạng bảng          | ManageCategoryServlet      | manage-categories.jsp    |
| Update   | Admin sửa tên hoặc mô tả danh mục             | ManageCategoryServlet      | category-form.jsp        |
| Delete   | Admin xóa danh mục (hoa thuộc danh mục -> NULL)| ManageCategoryServlet      | manage-categories.jsp    |

### 4.1.2. Flowers (Sản phẩm hoa)

| Thao tác | Mô tả                                         | Servlet                    | JSP                     |
|----------|------------------------------------------------|----------------------------|--------------------------|
| Create   | Admin thêm hoa mới (tên, giá, ảnh, danh mục)  | ManageFlowerServlet        | flower-form.jsp          |
| Read     | Danh sách hoa có phân trang + tìm kiếm         | ManageFlowerServlet        | manage-flowers.jsp       |
| Update   | Admin cập nhật thông tin hoa, thay ảnh          | ManageFlowerServlet        | flower-form.jsp          |
| Delete   | Admin xóa hoa (hoặc chuyển Status = 0)         | ManageFlowerServlet        | manage-flowers.jsp       |

### 4.1.3. Accounts (Tài khoản)

| Thao tác | Mô tả                                         | Servlet                    | JSP                     |
|----------|------------------------------------------------|----------------------------|--------------------------|
| Create   | Admin tạo tài khoản nhân viên / Khách đăng ký  | ManageAccountServlet / RegisterServlet | account-form.jsp / register.jsp |
| Read     | Admin xem danh sách tài khoản, lọc theo role   | ManageAccountServlet       | manage-accounts.jsp      |
| Update   | Admin cập nhật thông tin / khóa tài khoản       | ManageAccountServlet       | account-form.jsp         |
| Delete   | Admin xóa tài khoản (hoặc khóa Status = 0)     | ManageAccountServlet       | manage-accounts.jsp      |

### 4.1.4. Orders (Đơn hàng)

| Thao tác | Mô tả                                         | Servlet                    | JSP                     |
|----------|------------------------------------------------|----------------------------|--------------------------|
| Create   | Customer thanh toán giỏ hàng tạo đơn mới      | CheckoutServlet            | checkout.jsp             |
| Read     | Employee xem đơn cần xử lý / Customer xem lịch sử | ManageOrderServlet / OrderHistoryServlet | manage-orders.jsp / order-history.jsp |
| Update   | Employee cập nhật trạng thái đơn hàng          | ManageOrderServlet         | manage-orders.jsp        |
| Delete   | Employee hủy đơn (chuyển Status = "Đã hủy")   | ManageOrderServlet         | manage-orders.jsp        |

### 4.1.5. OrderDetails (Chi tiết đơn hàng)

| Thao tác | Mô tả                                         | Servlet                    | JSP                     |
|----------|------------------------------------------------|----------------------------|--------------------------|
| Create   | Tự động tạo cùng lúc với đơn hàng (Checkout)  | CheckoutServlet            | —                        |
| Read     | Hiển thị danh sách hoa trong 1 đơn hàng cụ thể | ManageOrderServlet         | order-detail.jsp         |
| Update   | Admin/Employee sửa số lượng (nếu có sai sót)  | ManageOrderServlet         | order-detail.jsp         |
| Delete   | Xóa 1 dòng sản phẩm khỏi đơn hàng            | ManageOrderServlet         | order-detail.jsp         |

### 4.1.6. ActivityLogs (Nhật ký hệ thống)

| Thao tác | Mô tả                                         | Servlet                    | JSP                     |
|----------|------------------------------------------------|----------------------------|--------------------------|
| Create   | Tự động ghi nhận thông qua ActivityLogger      | —                          | —                        |
| Read     | Admin xem danh sách log có phân trang          | AdminActivityLogServlet    | activity-logs.jsp        |
| Update   | Không hỗ trợ (Log không được phép sửa đổi)     | —                          | —                        |
| Delete   | Không hỗ trợ (Log được giữ nguyên để lưu vết)  | —                          | —                        |

---

## 4.2. Tìm kiếm (Search)

### 4.2.1. Tìm kiếm cơ bản
Áp dụng trên các trang danh sách công khai (Guest + Customer đều dùng được):

| Trang                | Trường tìm kiếm      | Cách hoạt động                          |
|----------------------|----------------------|------------------------------------------|
| Danh sách hoa        | Tên hoa              | `WHERE FlowerName LIKE '%keyword%'`      |
| Quản lý tài khoản    | Tên đăng nhập        | `WHERE Username LIKE '%keyword%'`        |

### 4.2.2. Tìm kiếm nâng cao
Kết hợp nhiều tiêu chí lọc đồng thời:

| Trang                | Tiêu chí lọc                                              |
|----------------------|------------------------------------------------------------|
| Danh sách hoa        | Tên hoa + Danh mục (dropdown) + Khoảng giá (min-max)     |
| Quản lý đơn hàng     | Trạng thái (dropdown) + Khoảng ngày (từ ngày - đến ngày) |
| Quản lý tài khoản    | Vai trò (dropdown) + Trạng thái (hoạt động / bị khóa)    |
| Nhật ký hoạt động    | Loại hành động (dropdown) + Tên tài khoản + Khoảng ngày  |

**Kỹ thuật xây dựng câu truy vấn động:** Sử dụng chuỗi `StringBuilder` để nối
các mệnh đề `WHERE` tùy theo tiêu chí nào được người dùng nhập vào. Luôn dùng
tham số dạng `?` của `PreparedStatement` thay vì cộng chuỗi trực tiếp.

```java
// Ví dụ minh họa truy vấn động
StringBuilder sql = new StringBuilder("SELECT * FROM Flowers WHERE 1=1");
List<Object> params = new ArrayList<>();

if (name != null && !name.isEmpty()) {
    sql.append(" AND FlowerName LIKE ?");
    params.add("%" + name + "%");
}
if (categoryId > 0) {
    sql.append(" AND CategoryId = ?");
    params.add(categoryId);
}
if (minPrice > 0) {
    sql.append(" AND Price >= ?");
    params.add(minPrice);
}
if (maxPrice > 0) {
    sql.append(" AND Price <= ?");
    params.add(maxPrice);
}
```

---

## 4.3. Phân trang (Pagination)

Tất cả các danh sách hiển thị nhiều bản ghi đều phải áp dụng phân trang sử dụng
cú pháp `OFFSET ... ROWS FETCH NEXT ... ROWS ONLY` của SQL Server.

### Các trang cần phân trang

| Trang                    | Số bản ghi / trang | Ghi chú                             |
|--------------------------|--------------------:|--------------------------------------|
| Trang chủ (hoa nổi bật)  | 8                  | Hiển thị dạng lưới (grid 4 cột)     |
| Danh sách hoa (catalog)  | 12                 | Hiển thị dạng lưới (grid 4 cột)     |
| Quản lý hoa (admin)      | 10                 | Hiển thị dạng bảng (table)           |
| Quản lý đơn hàng         | 10                 | Hiển thị dạng bảng                   |
| Quản lý tài khoản        | 10                 | Hiển thị dạng bảng                   |
| Lịch sử đơn hàng (KH)   | 5                  | Hiển thị dạng danh sách (list)       |
| Nhật ký hoạt động (admin)| 20                 | Hiển thị dạng bảng                   |

### Công thức tính phân trang

```java
// Trong DAO
int offset = (page - 1) * pageSize;
String sql = "SELECT * FROM Flowers ORDER BY FlowerId "
           + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

// Trong Servlet
int totalRecords = flowerDAO.countAllFlowers();
int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
request.setAttribute("currentPage", page);
request.setAttribute("totalPages", totalPages);
```

### Hiển thị thanh phân trang trên JSP

```jsp
<nav>
    <c:if test="${currentPage > 1}">
        <a href="?page=${currentPage - 1}">Trang trước</a>
    </c:if>

    <c:forEach begin="1" end="${totalPages}" var="i">
        <a href="?page=${i}"
           class="${i == currentPage ? 'active' : ''}">${i}</a>
    </c:forEach>

    <c:if test="${currentPage < totalPages}">
        <a href="?page=${currentPage + 1}">Trang sau</a>
    </c:if>
</nav>
```

---

## 4.4. Kiểm tra dữ liệu (Validation)

### 4.4.1. Quy tắc Validation cho từng Form

#### Form Đăng ký tài khoản (register.jsp)

| Trường     | Quy tắc kiểm tra                                                |
|------------|------------------------------------------------------------------|
| Username   | Bắt buộc, 4-50 ký tự, chỉ chữ cái và số, không được trùng DB   |
| Password   | Bắt buộc, tối thiểu 6 ký tự                                     |
| Confirm    | Phải trùng khớp với trường Password                              |
| FullName   | Bắt buộc, 2-100 ký tự                                           |
| Email      | Bắt buộc, đúng định dạng email (regex), không được trùng DB     |
| Phone      | Bắt buộc, 10-11 chữ số, bắt đầu bằng 0                         |

#### Form Thêm/Sửa hoa (flower-form.jsp)

| Trường       | Quy tắc kiểm tra                                              |
|--------------|----------------------------------------------------------------|
| FlowerName   | Bắt buộc, 2-150 ký tự                                         |
| Price        | Bắt buộc, là số dương, tối thiểu 1000 (VNĐ)                   |
| Quantity     | Bắt buộc, là số nguyên >= 0                                   |
| CategoryId   | Bắt buộc, phải chọn 1 danh mục từ dropdown                    |
| Image        | Tùy chọn, nếu có phải là file ảnh (.jpg, .png, .webp) hoặc URL|
| Discount     | Tùy chọn, số nguyên từ 0 đến 100 (phần trăm giảm giá)         |
| Description  | Tùy chọn, tối đa 2000 ký tự                                   |

#### Form Thanh toán (checkout.jsp)

| Trường          | Quy tắc kiểm tra                                           |
|-----------------|-------------------------------------------------------------|
| ReceiverName    | Bắt buộc, 2-100 ký tự                                      |
| ReceiverAddress | Bắt buộc, 5-255 ký tự                                      |
| ReceiverPhone   | Bắt buộc, 10-11 chữ số, bắt đầu bằng 0                    |
| Giỏ hàng        | Phải có ít nhất 1 sản phẩm, số lượng <= tồn kho            |

#### Form Thêm/Sửa danh mục (category-form.jsp)

| Trường       | Quy tắc kiểm tra                                              |
|--------------|----------------------------------------------------------------|
| CategoryName | Bắt buộc, 2-100 ký tự, không được trùng tên danh mục khác    |
| Description  | Tùy chọn, tối đa 255 ký tự                                    |

### 4.4.2. Cách thức hiển thị lỗi Validation

Khi dữ liệu không hợp lệ, Servlet sẽ:
1. Đặt thông báo lỗi vào `request.setAttribute("error", "Nội dung lỗi")`.
2. Đặt lại các giá trị đã nhập vào `request.setAttribute("oldValues", ...)` để
   người dùng không phải nhập lại từ đầu.
3. Forward ngược lại trang form.

```jsp
<!-- Hiển thị lỗi trên JSP -->
<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<!-- Giữ lại giá trị đã nhập -->
<input type="text" name="flowerName"
       value="${oldValues.flowerName}" />
```

---

## 4.5. Năm báo cáo thống kê (Statistics/Reports)

### Báo cáo 1: Doanh thu theo tháng

Hiển thị tổng tiền thu được từ các đơn hàng có trạng thái "Đã giao",
được gom nhóm theo từng tháng trong năm.

```sql
SELECT
    MONTH(OrderDate) AS Thang,
    YEAR(OrderDate) AS Nam,
    SUM(TotalAmount) AS TongDoanhThu,
    COUNT(OrderId) AS SoDonHang
FROM Orders
WHERE Status = N'Đã giao'
  AND YEAR(OrderDate) = @Year
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Nam, Thang;
```

### Báo cáo 2: Top 5 sản phẩm hoa bán chạy nhất

Liệt kê 5 loại hoa có tổng số lượng bán ra cao nhất dựa trên bảng OrderDetails,
chỉ tính các đơn hàng đã giao thành công.

```sql
SELECT TOP 5
    f.FlowerId,
    f.FlowerName,
    SUM(od.Quantity) AS TongSoLuongBan,
    SUM(od.Quantity * od.UnitPrice) AS TongDoanhThu
FROM OrderDetails od
JOIN Flowers f ON od.FlowerId = f.FlowerId
JOIN Orders o ON od.OrderId = o.OrderId
WHERE o.Status = N'Đã giao'
GROUP BY f.FlowerId, f.FlowerName
ORDER BY TongSoLuongBan DESC;
```

### Báo cáo 3: Thống kê đơn hàng theo trạng thái

Hiển thị số lượng đơn hàng ở mỗi trạng thái để nắm tình hình vận hành.

```sql
SELECT
    Status AS TrangThai,
    COUNT(OrderId) AS SoLuongDon,
    SUM(TotalAmount) AS TongGiaTri
FROM Orders
GROUP BY Status
ORDER BY
    CASE Status
        WHEN N'Chờ xử lý' THEN 1
        WHEN N'Đang giao'  THEN 2
        WHEN N'Đã giao'    THEN 3
        WHEN N'Đã hủy'     THEN 4
    END;
```

### Báo cáo 4: Top 5 khách hàng chi tiêu cao nhất (VIP)

Liệt kê những khách hàng có tổng giá trị đơn hàng đã giao lớn nhất.

```sql
SELECT TOP 5
    a.AccountId,
    a.FullName,
    a.Email,
    COUNT(o.OrderId) AS SoDonHang,
    SUM(o.TotalAmount) AS TongChiTieu
FROM Accounts a
JOIN Orders o ON a.AccountId = o.AccountId
WHERE o.Status = N'Đã giao'
GROUP BY a.AccountId, a.FullName, a.Email
ORDER BY TongChiTieu DESC;
```

### Báo cáo 5: Cảnh báo hoa tồn kho thấp

Liệt kê các sản phẩm hoa đang bán có số lượng tồn kho dưới ngưỡng tối thiểu
(mặc định 10 cành) để quản lý kịp thời nhập thêm hàng.

```sql
SELECT
    f.FlowerId,
    f.FlowerName,
    f.Quantity AS TonKhoHienTai,
    c.CategoryName AS DanhMuc
FROM Flowers f
LEFT JOIN Categories c ON f.CategoryId = c.CategoryId
WHERE f.Status = 1
  AND f.Quantity < 10
ORDER BY f.Quantity ASC;
```
