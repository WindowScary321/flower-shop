# Tính Năng Điểm Thưởng (Bonus Features) — Flower Shop

Đề bài cho phép đạt tối đa 10 điểm thưởng bằng cách triển khai thêm các tính năng
nâng cao. Dưới đây là danh sách các tính năng khả thi cho dự án shop bán hoa,
sắp xếp theo mức độ ưu tiên từ dễ đến khó.

## 5.1. Tổng quan điểm thưởng

| #  | Tính năng                        | Điểm thưởng | Độ khó      | Ưu tiên    |
|----|----------------------------------|:-----------:|:-----------:|:----------:|
| 1  | Upload hình ảnh hoa              | +2          | Trung bình  | Cao        |
| 2  | Tích hợp AJAX (giỏ hàng)        | +2          | Trung bình  | Cao        |
| 3  | Xuất báo cáo ra Excel            | +2          | Dễ          | Cao        |
| 4  | Biểu đồ Dashboard (Chart.js)    | +2          | Trung bình  | Trung bình |
| 5  | Xác thực email đăng ký           | +2          | Khó         | Thấp       |
| 6  | Ghi log hệ thống                | +1          | Dễ          | Thấp       |
| 7  | Xuất hóa đơn PDF (iText)        | +2          | Khó         | Thấp       |

> **Mục tiêu thực tế:** Chọn 3 tính năng đầu tiên (Upload ảnh + AJAX + Excel)
> để đạt +6 điểm thưởng với công sức hợp lý.

---

## 5.2. Hướng dẫn triển khai từng tính năng

### Tính năng 1: Upload hình ảnh sản phẩm hoa (+2đ)

**Mục đích:** Khi Admin thêm hoặc sửa hoa, cho phép tải ảnh lên server thay vì
chỉ nhập đường dẫn bằng text.

**Cách triển khai:**
- Thêm annotation `@MultipartConfig` vào Servlet xử lý form hoa.
- Sử dụng đối tượng `jakarta.servlet.http.Part` để nhận file ảnh từ form.
- Lưu file vào thư mục `web/images/flowers/` với tên file là UUID để tránh trùng.
- Cập nhật đường dẫn tương đối vào cột `Image` trong bảng `Flowers`.

```java
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,     // 1 MB
    maxFileSize = 5 * 1024 * 1024,       // 5 MB
    maxRequestSize = 10 * 1024 * 1024    // 10 MB
)
public class ManageFlowerServlet extends HttpServlet {
    protected void doPost(...) {
        Part filePart = request.getPart("imageFile");
        String fileName = UUID.randomUUID() + "_" + filePart.getSubmittedFileName();
        String uploadDir = getServletContext().getRealPath("/images/flowers/");
        filePart.write(uploadDir + File.separator + fileName);
        // Lưu fileName vào DB
    }
}
```

### Tính năng 2: Tích hợp AJAX cho Giỏ hàng (+2đ)

**Mục đích:** Khi Customer bấm "Thêm vào giỏ", trang không bị tải lại hoàn toàn.
Thay vào đó, badge số lượng giỏ hàng trên header cập nhật ngay bằng JavaScript.

**Cách triển khai:**
- Tạo `CartServlet` trả về dữ liệu JSON (thay vì forward JSP) khi nhận header
  `X-Requested-With: XMLHttpRequest`.
- Sử dụng `fetch()` hoặc `XMLHttpRequest` trên trang JSP để gọi Servlet.

```javascript
// Trong file main.js
function addToCart(flowerId) {
    fetch('/cart?action=add&flowerId=' + flowerId, {
        method: 'GET',
        headers: { 'X-Requested-With': 'XMLHttpRequest' }
    })
    .then(response => response.json())
    .then(data => {
        document.getElementById('cart-count').textContent = data.totalItems;
        // Hiển thị thông báo thành công
    });
}
```

### Tính năng 3: Xuất báo cáo Excel — Apache POI (+2đ)

**Mục đích:** Admin bấm nút "Xuất Excel" trên trang thống kê để tải xuống
file .xlsx chứa dữ liệu báo cáo.

**Thư viện cần thêm:** Tải file JAR `poi-*.jar` và `poi-ooxml-*.jar` vào
thư mục `web/WEB-INF/lib/`.

```java
// Trong DashboardServlet khi nhận action=exportExcel
Workbook workbook = new XSSFWorkbook();
Sheet sheet = workbook.createSheet("Doanh thu theo tháng");

// Tạo header
Row headerRow = sheet.createRow(0);
headerRow.createCell(0).setCellValue("Tháng");
headerRow.createCell(1).setCellValue("Doanh thu");
headerRow.createCell(2).setCellValue("Số đơn hàng");

// Điền dữ liệu
int rowNum = 1;
for (RevenueReport r : reportList) {
    Row row = sheet.createRow(rowNum++);
    row.createCell(0).setCellValue(r.getMonth());
    row.createCell(1).setCellValue(r.getRevenue());
    row.createCell(2).setCellValue(r.getOrderCount());
}

// Trả file về trình duyệt
response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
response.setHeader("Content-Disposition", "attachment; filename=doanhthu.xlsx");
workbook.write(response.getOutputStream());
workbook.close();
```

### Tính năng 4: Biểu đồ Dashboard với Chart.js (+2đ)

**Mục đích:** Hiển thị dữ liệu thống kê dưới dạng biểu đồ trực quan trên
trang Dashboard của Admin.

**Cách triển khai:**
- Nhúng thư viện Chart.js qua CDN trong file `dashboard.jsp`.
- Servlet truyền dữ liệu thống kê sang JSP dưới dạng attribute.
- JSP render dữ liệu vào thẻ `<canvas>` thông qua JavaScript.

```jsp
<!-- Trong dashboard.jsp -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<canvas id="revenueChart"></canvas>
<script>
    const ctx = document.getElementById('revenueChart').getContext('2d');
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: [
                <c:forEach var="r" items="${revenueList}" varStatus="s">
                    'Tháng ${r.month}'<c:if test="${!s.last}">,</c:if>
                </c:forEach>
            ],
            datasets: [{
                label: 'Doanh thu (VNĐ)',
                data: [
                    <c:forEach var="r" items="${revenueList}" varStatus="s">
                        ${r.revenue}<c:if test="${!s.last}">,</c:if>
                    </c:forEach>
                ],
                backgroundColor: 'rgba(75, 192, 192, 0.6)'
            }]
        }
    });
</script>
```

### Tính năng 5: Xác thực Email đăng ký (+2đ)

**Mục đích:** Sau khi đăng ký, hệ thống gửi email xác thực đến địa chỉ email
mà người dùng đã khai báo. Tài khoản chỉ được kích hoạt khi người dùng bấm
vào liên kết xác thực trong email.

**Thư viện:** Jakarta Mail (javax.mail.jar).

### Tính năng 6: Ghi log hệ thống (+1đ)

**Mục đích:** Ghi lại các sự kiện quan trọng của hệ thống (đăng nhập, thay đổi
dữ liệu, lỗi xảy ra) vào file log để phục vụ debug và kiểm toán.

**Cách triển khai:** Sử dụng `java.util.logging.Logger` có sẵn trong JDK,
cấu hình ghi log vào file `flower-shop.log` trong thư mục `logs/`.
