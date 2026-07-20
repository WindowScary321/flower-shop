# Cải tiến Giao diện Trang chủ và Menu Danh mục

- **Thời gian**: 2026-07-20
- **Mục tiêu**: Hiển thị nhiều danh mục hoa tươi kèm hình ảnh sản phẩm đại diện trên trang chủ để tối ưu trải nghiệm mua sắm của khách hàng. Đồng thời, bổ sung hiệu ứng làm nổi bật (sáng) tab điều hướng khi người dùng duyệt qua từng danh mục cụ thể.

## Các thay đổi chính

### Cấu trúc cơ sở dữ liệu (Database)
- Sử dụng các bảng dữ liệu hiện có bao gồm `Categories` (để lấy danh sách phân loại hoa) và `Flowers` (để lấy các sản phẩm hoa theo danh mục) mà không cần thay đổi cấu trúc bảng.

### Bộ xử lý Back-End (Controllers)
- **HomeServlet.java**:
  - Nhập thêm các thư viện xử lý bản đồ `LinkedHashMap` và `Map`, cùng các DAO điều khiển danh mục `CategoryDAO` và đối tượng `Category`.
  - Nâng cấp phương thức `doGet` để truy xuất toàn bộ danh mục hoa từ database.
  - Sử dụng vòng lặp để lấy danh sách sản phẩm thuộc mỗi danh mục từ `FlowerDAO` thông qua phương thức `getFlowersByCategoryId(categoryId)`.
  - Giới hạn tối đa hiển thị 4 sản phẩm mới nhất trên mỗi danh mục tại trang chủ nhằm giữ bố cục trang cân đối và gọn gàng.
  - Đóng gói dữ liệu vào cấu trúc `LinkedHashMap` và gán vào request scope dưới dạng thuộc tính `categoryMap`.

### Giao diện hiển thị (Front-End)
- **index.jsp**:
  - Tích hợp thêm phần **Danh Mục Hoa Tươi** (Quick Navigation Grid) ở ngay dưới Features Section. Mỗi danh mục được hiển thị dưới dạng card chứa hình ảnh sản phẩm đầu tiên có trong danh mục đó làm ảnh đại diện, đi kèm tên danh mục và mô tả ngắn gọn.
  - Thiết kế lại phần hiển thị giá bán cho hoa giảm giá (gạch ngang giá gốc và tô đỏ giá khuyến mãi) đồng bộ cho cả phần "Hoa nổi bật" và các phần sản phẩm theo danh mục.
  - Lặp qua thuộc tính `categoryMap` để hiển thị các block sản phẩm chi tiết cho từng danh mục ở phía cuối trang kèm theo liên kết "XEM TẤT CẢ" dẫn tới trang lọc danh mục tương ứng.
- **header.jsp**:
  - Khai báo thêm biến `servletPath` và `reqCategoryId` để lấy dữ liệu trang chủ hiện tại cùng mã danh mục đang chọn từ request hoặc URL param.
  - Sử dụng biểu thức JSTL EL để gán lớp CSS `active-tab` cho liên kết trang chủ hoặc danh mục hoa cưới, hoa sinh nhật... tương ứng khi người dùng truy cập.

### Phong cách CSS (Styling)
- **style.css**:
  - Bổ sung hiệu ứng dịch chuyển lên trên và đổ bóng mượt mà cho các card danh mục khi di chuột qua (`.category-card:hover`).
  - Thêm hiệu ứng zoom hình ảnh nhẹ nhàng cho ảnh nền danh mục (`.category-img`).
  - Thiết kế lớp phủ hồng `.category-overlay` kèm nút "Khám phá" nổi lên khi người dùng rê chuột vào card danh mục.
  - Định nghĩa kiểu dáng tiêu đề phần mới `.section-title-premium` với vệt màu hồng đặc trưng của thương hiệu.
  - Thêm hiệu ứng gạch chân và đổi màu hồng đậm cho các liên kết nav-link có lớp `.active-tab`.
