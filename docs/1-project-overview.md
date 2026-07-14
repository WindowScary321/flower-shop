# Tổng Quan Dự Án — Flower Shop

## 1.1. Mô tả dự án

Flower Shop là ứng dụng web quản lý cửa hàng bán hoa trực tuyến, được xây dựng theo mô hình
Pure MVC (Model - View - Controller) sử dụng Java Servlet, JSP, JSTL + EL, JDBC và MS SQL Server.
Hệ thống cho phép khách hàng duyệt danh mục hoa, đặt hàng trực tuyến, đồng thời cung cấp
bảng điều khiển quản trị cho nhân viên và quản trị viên vận hành cửa hàng.

## 1.2. Công nghệ sử dụng

| Thành phần       | Công nghệ                                      |
|------------------|-------------------------------------------------|
| Backend          | Java Servlet, JSP, JSTL + EL                    |
| Database         | Microsoft SQL Server + JDBC (PreparedStatement)  |
| Frontend         | HTML, CSS (Bootstrap), JavaScript                |
| Web Server       | Apache Tomcat 10.x                               |
| Kết nối DB       | DBContext + ConnectDB.properties                  |
| Quản lý phiên    | HttpSession                                      |
| Phân quyền       | Servlet Filter                                   |
| Mã hóa mật khẩu | SHA-256 (java.security.MessageDigest)             |

> **Lưu ý:** Dự án KHÔNG được phép sử dụng Spring, Hibernate/JPA, Maven/Gradle,
> hoặc bất kỳ frontend framework nào (React, Angular, Vue).

## 1.3. Vai trò người dùng (Roles)

### Khách vãng lai (Guest)
Là nhóm người dùng chưa đăng nhập vào hệ thống. Họ được phép:
- Xem trang chủ với danh sách hoa nổi bật
- Duyệt danh mục hoa theo từng loại (hoa cưới, sinh nhật, khai trương, v.v.)
- Tìm kiếm hoa theo tên hoặc danh mục
- Xem trang chi tiết từng sản phẩm hoa
- Đăng ký tài khoản mới và đăng nhập

### Khách hàng (Customer)
Là người dùng đã đăng nhập với vai trò `customer`. Ngoài các quyền của Guest, họ có thể:
- Thêm sản phẩm hoa vào giỏ hàng cá nhân
- Điều chỉnh số lượng hoa hoặc xóa hoa khỏi giỏ hàng
- Tiến hành thanh toán đơn hàng (checkout) với thông tin người nhận
- Theo dõi trạng thái và lịch sử các đơn hàng đã đặt
- Chỉnh sửa thông tin cá nhân (hồ sơ tài khoản)

### Nhân viên cửa hàng (Employee)
Là người dùng được Admin tạo tài khoản với vai trò `employee`. Họ có nhiệm vụ:
- Xem danh sách các đơn hàng mới cần xử lý
- Cập nhật trạng thái đơn hàng: Chờ xử lý → Đang giao → Đã giao
- Xử lý hủy đơn hàng và hoàn trả số lượng hoa tồn kho
- Cập nhật số lượng hoa tồn kho khi nhập hàng mới

### Quản trị viên (Administrator)
Vai trò có quyền hạn cao nhất, đăng nhập với vai trò `admin`. Admin có quyền:
- Quản trị toàn bộ danh mục hoa (CRUD Categories)
- Quản trị sản phẩm hoa (CRUD Flowers) bao gồm upload hình ảnh
- Quản lý tài khoản nhân viên và khách hàng (tạo, khóa, cập nhật)
- Xem tổng quan đơn hàng toàn hệ thống
- Truy cập 5 báo cáo thống kê doanh thu và kinh doanh

## 1.4. Cấu trúc thư mục dự án

```text
flower-shop/
├── src/
│   ├── conf/
│   │   └── MANIFEST.MF
│   └── java/
│       ├── ConnectDB.properties           # Cấu hình kết nối SQL Server
│       ├── controllers/                   # Tầng điều khiển (Servlet)
│       │   ├── HomeServlet.java           # Servlet xử lý trang chủ
│       │   ├── ProfileServlet.java        # Servlet xử lý hồ sơ cá nhân
│       │   ├── auth/
│       │   │   ├── LoginServlet.java      # Xử lý đăng nhập
│       │   │   ├── LogoutServlet.java     # Hủy session, đăng xuất
│       │   │   └── RegisterServlet.java   # Xử lý đăng ký
│       │   ├── admin/
│       │   │   ├── DashboardServlet.java         # Trang thống kê
│       │   │   ├── ManageAccountServlet.java     # CRUD tài khoản
│       │   │   ├── ManageCategoryServlet.java    # CRUD danh mục
│       │   │   ├── ManageFlowerServlet.java      # CRUD hoa
│       │   │   └── ManageOrderServlet.java       # Xử lý đơn hàng cho Admin
│       │   ├── employee/
│       │   │   └── ManageOrderServlet.java       # Xử lý đơn hàng cho Employee
│       │   └── customer/
│       │       ├── CartServlet.java              # Thao tác giỏ hàng
│       │       ├── CheckoutServlet.java          # Thanh toán
│       │       ├── CheckoutSuccessServlet.java   # Màn hình thanh toán thành công
│       │       ├── FlowerCatalogServlet.java     # Duyệt danh mục hoa
│       │       ├── FlowerDetailServlet.java      # Xem chi tiết hoa
│       │       ├── OrderHistoryServlet.java      # Lịch sử đơn hàng
│       │       └── PaymentQRServlet.java         # Hỗ trợ thanh toán QR
│       ├── dal/                           # Tầng truy xuất dữ liệu
│       │   ├── AccountDAO.java
│       │   ├── CategoryDAO.java
│       │   ├── DBContext.java             # Kết nối cơ sở dữ liệu
│       │   ├── FlowerDAO.java
│       │   ├── OrderDAO.java
│       │   ├── OrderDetailDAO.java
│       │   └── ReportDAO.java             # Xử lý các query thống kê
│       ├── models/                        # Lớp thực thể (Java Beans)
│       │   ├── Account.java
│       │   ├── CartItem.java              # Đối tượng giỏ hàng (Session)
│       │   ├── Category.java
│       │   ├── Flower.java
│       │   ├── Order.java
│       │   ├── OrderDetail.java
│       │   ├── ReportSummary.java         # Model cho Dashboard
│       │   ├── RevenueByMonth.java        # Model thống kê doanh thu
│       │   └── TopSellingFlower.java      # Model thống kê hoa bán chạy
│       ├── filter/                        # Bộ lọc
│       │   ├── AuthenticationFilter.java  # Kiểm tra đăng nhập
│       │   ├── AuthorizationFilter.java   # Kiểm tra phân quyền
│       │   └── UTF8Filter.java            # Xử lý encoding tiếng Việt
│       └── utils/
│           └── PasswordHasher.java        # Băm mật khẩu SHA-256
└── web/                                   # Tầng hiển thị
    ├── META-INF/
    │   └── context.xml
    ├── WEB-INF/
    │   └── web.xml (nếu có)
    ├── admin/
    │   ├── dashboard.jsp                  # Trang thống kê tổng quan
    │   ├── manage-accounts.jsp
    │   ├── manage-categories.jsp
    │   ├── manage-flowers.jsp             # Danh sách hoa
    │   └── manage-orders.jsp              # Quản lý đơn hàng (Admin)
    ├── common/                            # Thành phần dùng chung
    │   ├── footer.jsp
    │   ├── header.jsp                     # Header + Navigation
    │   └── sidebar-admin.jsp              # Sidebar quản trị
    ├── css/
    │   └── style.css
    ├── customer/
    │   ├── my-orders.jsp                  # Danh sách đơn của KH
    │   └── order-history.jsp              # Lịch sử đơn hàng cá nhân
    ├── employee/
    │   └── manage-orders.jsp              # Danh sách đơn hàng
    ├── resources/
    │   └── qrcode-placeholder.png         # Ảnh giả lập QR Code
    ├── cart.jsp                           # Giỏ hàng
    ├── checkout-success.jsp               # Thông báo thành công
    ├── checkout.jsp                       # Trang thanh toán
    ├── flower-catalog.jsp                 # Trang danh sách hoa
    ├── flower-detail.jsp                  # Trang chi tiết hoa
    ├── index.jsp                          # Trang chủ
    ├── login.jsp                          # Đăng nhập
    ├── payment-qr.jsp                     # Trang quét mã QR
    ├── profile.jsp                        # Trang hồ sơ cá nhân
    └── register.jsp                       # Đăng ký
```
