# Nhật ký tiến trình - Giai đoạn 1 (Nền tảng)

## Mục tiêu đã hoàn thành
Giai đoạn 1 tập trung vào việc thiết lập các thành phần cốt lõi của dự án Flower Shop:

1. **Thiết kế Cơ sở dữ liệu**:
   - Đã tạo script SQL `database/FlowerShopDB.sql` chứa 5 bảng (Categories, Flowers, Accounts, Orders, OrderDetails) đạt chuẩn 3NF.
   - Thêm các ràng buộc khoá ngoại (FOREIGN KEY) và CHECK constraints.
   - Đã chèn dữ liệu mẫu (Sample Data) để tiện cho việc test sau này.

2. **Cấu hình dự án**:
   - Tái sử dụng cấu trúc chuẩn MVC của NetBeans (`src/java`, `web`, `WEB-INF`).
   - Cấu hình file `ConnectDB.properties` (bạn đã cấu hình khớp thông tin).
   - Class `dal/DBContext.java` kết nối SQL Server thông qua JDBC đã sẵn sàng.

3. **Lớp Model (Java Beans)**:
   - Đã tạo toàn bộ 6 class Model trong package `models`: `Category`, `Flower`, `Account`, `Order`, `OrderDetail`, `CartItem`.
   - Các class đều có thuộc tính map với DB, Constructors và Getter/Setter đầy đủ.

4. **Tiện ích chung (Utils)**:
   - Tạo class `utils.PasswordHasher` hỗ trợ băm mật khẩu SHA-256 cho việc xác thực bảo mật.

5. **Giao diện & Bố cục (Layout)**:
   - Tích hợp Bootstrap 5 (thông qua CDN) và file `css/style.css` tùy chỉnh.
   - Tạo các thành phần dùng chung bằng thẻ `jsp:include`: `common/header.jsp`, `common/footer.jsp`, `common/sidebar-admin.jsp`.
   - Cập nhật `index.jsp` sử dụng layout chung và tạo trang chủ dạng Hero banner kèm lưới sản phẩm nổi bật.

6. **Chức năng Xác thực (Auth)**:
   - Viết `dal.AccountDAO` xử lý truy vấn: get user (login), kiểm tra username/email trùng, và insert user mới.
   - Tạo 3 Servlet điều khiển: `LoginServlet`, `RegisterServlet`, `LogoutServlet`.
   - Tạo 2 view: `login.jsp` và `register.jsp` với form thiết kế bằng Bootstrap, kèm theo tính năng validation bằng HTML5 (`pattern`, `minlength`, `required`) và hiển thị thông báo lỗi.

## Hướng dẫn các bước tiếp theo
- **Deploy**: Bạn có thể deploy dự án lên Tomcat, chạy `database/FlowerShopDB.sql` trên SQL Server.
- **Login thử**: Sử dụng tài khoản admin (`admin`/`1234`) hoặc khách (`customer1`/`1234`) (Lưu ý: hiện tại hash SHA-256 của `123456` đang lưu ở CSDL mẫu, nếu bạn đã đổi mật khẩu db là `1234` hãy chú ý mật khẩu của các accounts lúc insert vào DB).
- Chuyển sang **Giai đoạn 2** để làm các chức năng CRUD cho danh mục, sản phẩm, và tài khoản.
