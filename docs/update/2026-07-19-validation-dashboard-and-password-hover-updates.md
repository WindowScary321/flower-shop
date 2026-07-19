# Sửa lỗi Validation, Bổ sung Dashboard & Việt hóa Hover Menu Password

- **Thời gian**: 2026-07-19
- **Mục tiêu**: Giải quyết các khuyến nghị ưu tiên trong bảng đánh giá dự án (project_evaluation.md) bao gồm: bẫy lỗi (try-catch) khi nhập liệu quản lý hoa/danh mục tại Admin, bổ sung các thống kê chuyên sâu vào Dashboard, thiết lập sơ đồ ERD, bổ sung hover menu kiểm tra mật khẩu và việt hóa hoàn toàn thông báo lỗi validation trên form Đăng ký.

## Các thay đổi chính

### CSDL (Database)
- Đã chạy script `database/FlowerShopDB.sql` để khởi tạo lại toàn bộ cơ sở dữ liệu `FLOWER_SHOP` và nạp dữ liệu mẫu trên SQL Server cục bộ, giải quyết triệt để lỗi kết nối cơ sở dữ liệu (NullPointerException - Connection is null).

### Models & DAOs
- **Tạo Model mới**: `models/RevenueByCategory` để lưu thông tin doanh thu theo từng danh mục hoa.
- **Cập nhật `ReportDAO.java`**:
  - Viết thêm method `getRevenueByCategory()` thực hiện truy vấn kết hợp nhiều bảng (`Categories`, `Flowers`, `OrderDetails`, `Orders`) để tính doanh thu thực tế (đã trừ chiết khấu) theo danh mục.
  - Viết thêm method `getCancelledOrderRatio()` để tính toán tỷ lệ đơn hàng bị hủy trên tổng số đơn.

### Controllers
- **`ManageFlowerServlet.java`**: Bọc logic ép kiểu dữ liệu `Double.parseDouble` và `Integer.parseInt` trong khối `try-catch` tại `addFlower` và `editFlower` để tránh lỗi sập server (500) khi nhập dữ liệu trống hoặc sai định dạng.
- **`ManageCategoryServlet.java`**: Kiểm tra dữ liệu tên danh mục trống trước khi thêm hoặc sửa.
- **`RegisterServlet.java`**: Thêm kiểm tra định dạng email (Regex), định dạng số điện thoại (10-11 số bắt đầu bằng 0) và định dạng mật khẩu bằng Regex (tối thiểu 8 ký tự, bao gồm cả chữ và số) tại Backend để đảm bảo an toàn dữ liệu.
- **`DashboardServlet.java`**: Truy vấn thêm dữ liệu doanh thu theo danh mục và tỷ lệ hủy đơn từ `ReportDAO` để chuyển tiếp sang View hiển thị.

### Views
- **`web/register.jsp`**:
  - Bổ sung các thuộc tính HTML5 (`required`, `pattern`, `minlength`, `maxlength`).
  - Thiết kế bảng thông báo hover (Tooltip) động hiển thị điều kiện mật khẩu (bao gồm 2 điều kiện: "Ít nhất 8 ký tự" và "Có cả chữ và số" tự động kiểm tra và cập nhật trạng thái xanh/đỏ thời gian thực).
  - Tích hợp JavaScript tùy biến phương thức `setCustomValidity` để chuyển ngữ toàn bộ thông báo lỗi mặc định của trình duyệt sang Tiếng Việt thân thiện (bao gồm thông báo yêu cầu mật khẩu 8 ký tự có chữ và số).
  - Thêm kiểm tra mật khẩu xác nhận trùng khớp realtime.
- **`web/index.jsp`**:
  - Tái cấu trúc lại phân lớp (stacking context) của Banner Features: di chuyển thẻ `<hr>` vào trong thẻ row, sử dụng CSS `position-relative` và `z-index: 1` cho các cột chứa icon (đã có `bg-white`) để hiển thị đè lên trên thanh kẻ ngang, tăng tính thẩm mỹ của giao diện.
- **`web/admin/dashboard.jsp`**:
  - Bổ sung thẻ thông tin thống kê thứ 5: Tỷ lệ hủy đơn hàng (`cancelledRatio`).
  - Bổ sung biểu đồ tròn (Doughnut chart) hiển thị trực quan tỷ lệ doanh thu theo danh mục hoa sử dụng thư viện Chart.js.

### Tài liệu (Docs)
- **Tạo sơ đồ ERD**: Viết file sơ đồ quan hệ cơ sở dữ liệu thực tế [docs/erd.md](./erd.md) sử dụng cú pháp Mermaid JS để hiển thị trực quan trực tiếp trên Markdown.
