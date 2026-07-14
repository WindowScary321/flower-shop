## Giai đoạn 4: Phân trang, Tìm kiếm động và Báo cáo — Ngày 2026-07-14

### Mục tiêu hoàn thành
Tối ưu hóa trải nghiệm người dùng và hiệu năng bằng việc áp dụng phân trang, bổ sung bộ lọc tìm kiếm động, đồng thời xây dựng trang Dashboard báo cáo thống kê trực quan cho Admin.

### Chi tiết kỹ thuật triển khai

1. **Phân trang & Tìm kiếm động: Sản phẩm Hoa**
   - Cập nhật `FlowerDAO`: Thêm hàm `countFlowers` và `searchFlowersPaging` dùng mệnh đề `OFFSET ? ROWS FETCH NEXT ? ROWS ONLY`.
   - Cập nhật `FlowerCatalogServlet` và `ManageFlowerServlet` để nhận các tham số phân trang (`page`) và lọc (`keyword`, `categoryId`, `minPrice`, `maxPrice`, `statusOnly`).
   - Cập nhật giao diện `flower-catalog.jsp` và `manage-flowers.jsp` với thanh điều hướng phân trang và form lọc.

2. **Phân trang & Tìm kiếm động: Tài khoản**
   - Cập nhật `AccountDAO`: Thêm hàm `countAccounts` và `searchAccountsPaging` để lọc theo `keyword`, `role`, `status`.
   - Cập nhật `ManageAccountServlet` để xử lý logic lấy trang và tính toán số trang.
   - Cập nhật giao diện `manage-accounts.jsp` thêm bộ lọc.

3. **Phân trang & Tìm kiếm động: Đơn hàng**
   - Cập nhật `OrderDAO`: Thêm hàm `countOrders` và `searchOrdersPaging` để lọc đơn hàng theo `status` và khoảng thời gian (`fromDate`, `toDate`).
   - Cập nhật các Servlet (`ManageOrderServlet` cho Admin, `ManageOrderServlet` cho Nhân viên, `OrderHistoryServlet` cho Khách hàng).
   - Cập nhật giao diện `manage-orders.jsp` và `order-history.jsp` với Form lọc ngày tháng và trạng thái đơn hàng.

4. **Dashboard Báo cáo Thống kê**
   - **Model báo cáo:** Tạo các DTO mới `ReportSummary`, `RevenueByMonth`, `TopSellingFlower` phục vụ truyền tải dữ liệu.
   - **Tầng Data Access (`ReportDAO`):** 
     - Lấy doanh thu trong ngày/trong tháng (chỉ đơn hàng hợp lệ).
     - Tổng số đơn hàng và tổng lượng khách hàng.
     - Lấy doanh thu theo từng tháng của năm và gom nhóm Top 5 sản phẩm bán chạy nhất.
   - **Controller (`DashboardServlet`):** Gọi `ReportDAO`, truyền dữ liệu xuống view, cho phép người dùng chọn xem báo cáo theo Năm (`year`).
   - **Giao diện (`dashboard.jsp`):** 
     - 4 thẻ (Widgets) hiển thị số liệu kinh doanh.
     - Tích hợp thư viện **Chart.js** thông qua CDN để hiển thị biểu đồ cột (Bar Chart) tương tác cho báo cáo doanh thu theo tháng.
     - Danh sách Top 5 sản phẩm hoa bán chạy.

### File mới được tạo
- `src/java/models/ReportSummary.java`
- `src/java/models/RevenueByMonth.java`
- `src/java/models/TopSellingFlower.java`
- `src/java/dal/ReportDAO.java`
- `src/java/controllers/admin/DashboardServlet.java`
- `src/java/controllers/ProfileServlet.java`
- `web/admin/dashboard.jsp`
- `web/profile.jsp`

### File được cập nhật
- `src/java/dal/FlowerDAO.java`
- `src/java/dal/AccountDAO.java`
- `src/java/dal/OrderDAO.java`
- `src/java/controllers/customer/FlowerCatalogServlet.java`
- `src/java/controllers/admin/ManageFlowerServlet.java`
- `src/java/controllers/admin/ManageAccountServlet.java`
- `src/java/controllers/admin/ManageOrderServlet.java`
- `src/java/controllers/employee/ManageOrderServlet.java`
- `src/java/controllers/customer/OrderHistoryServlet.java`
- `src/java/filter/AuthorizationFilter.java`
- `web/common/header.jsp`
- `web/flower-catalog.jsp`
- `web/admin/manage-flowers.jsp`
- `web/admin/manage-accounts.jsp`
- `web/admin/manage-orders.jsp`
- `web/employee/manage-orders.jsp`
- `web/customer/order-history.jsp`

### Cải tiến Quality of Life (QoL)
- Thêm trang Hồ sơ cá nhân dùng chung cho mọi vai trò (`ProfileServlet` và `profile.jsp`).
- Thay đổi nhãn "Nhân viên" thành "Quản lý đơn hàng" trên menu điều hướng (Dropdown Menu) nhằm phản ánh đúng nghiệp vụ hơn.

### Fix Bug
- Đã khắc phục lỗi cú pháp thiếu dấu `}` đóng khối lệnh trong `FlowerDAO.java` để đảm bảo hệ thống dịch thành công trên Netbeans và javac command.
- Thay thế các chuỗi ký tự cứng tiếng Việt có dấu (`Chờ xử lý`, `Đã hủy`) trong `OrderDAO.java` bằng mã unicode escapes (vd: `\u0043\u0068\u1EDD...`) để ngăn chặn lỗi sai lệch encoding khi biên dịch Java và thực thi câu lệnh SQL. Khắc phục triệt để lỗi không thể hủy đơn hàng (không so sánh được chuỗi trạng thái).
- Khắc phục lỗ hổng phân quyền trong `AuthorizationFilter.java`: Bổ sung thêm rule chặn URL `/customer/*` để ngăn chặn triệt để Admin truy cập nhầm vào khu vực của Khách hàng.
