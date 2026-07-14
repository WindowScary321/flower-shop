# Flower shop 
## Công nghệ 
#### Front-End
- HTML5
- CSS
- Bootstrap

#### Back-End
- Tomcat 10
- JST, JSTL + EL
- JDBC

#### Hệ thống quản lý Database
- MS SQL

## Tính năng chính
- Log in / sign up
- Delegation of rights
- Manage orders / Customers / Orders
- Payment: COD, VietQR (fake thôi)
- Cart
- Purchase, Shipping info
- Account Management
- Contact Info
- Admin Dashboard
- Pages & Categorys
- blah, blah, ...

## Hướng dẫn Chạy Liveserver

### Bước 1: Khởi tạo Database
- Mở **SQL Server Management Studio**.
- Bạn có 2 cách để tạo DB:
   - **Cách 1:** Execute script [``database/FlowerShopDB.sql``](./database/FlowerShopDB.sql) trong SSMS.
   - **Cách 2 (Khuyên dùng):** Chạy file batch [``database/recreate-db.bat``](./database/recreate-db.bat).
- Hệ thống sẽ tạo ra database `FlowerShopDB` cùng với một số tài khoản và dữ liệu mẫu.

### Bước 2: Cấu hình kết nối
Mở file [``src/java/ConnectDB.properties``](./src/java/ConnectDB.properties) và chỉnh sửa lại các thông tin `user` và `password` cho khớp với tài khoản SQL Server của máy bạn:
```properties
server=localhost
port=1433
databaseName=FlowerShopDB
user=sa
password=your_password
```

### Bước 3: Mở và chạy dự án trên Netbeans
1. Mở phần mềm **Apache Netbeans**.
2. Chọn **File** -> **Open Project...** (Hoặc nhấn `Ctrl + Shift + O`).
3. Trỏ đường dẫn tới thư mục gốc của dự án `flower-shop` và nhấn Open.
4. Đảm bảo bạn đã cấu hình Server **Apache Tomcat 10+** trong Netbeans (vào Tools -> Servers để kiểm tra).
5. Chuột phải vào tên dự án `flower-shop` trong tab Projects, chọn **Run** (hoặc nhấn nút Play màu xanh trên thanh công cụ).
6. Netbeans sẽ tự động biên dịch, deploy lên Tomcat và mở trình duyệt web.

### Tài khoản đăng nhập mẫu (Sample Accounts)
Tất cả các tài khoản mặc định đều có mật khẩu là: `123456`
- **Quản trị viên (Admin):** `admin`
- **Nhân viên (Employee):** `staff1`
- **Khách hàng (Customer):** `customer1`, `customer2`