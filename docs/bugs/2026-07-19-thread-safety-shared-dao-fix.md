# Bug: Lỗi Thread Safety vì chia sẻ chung kết nối DAO trong Servlet (BUG-04)
Date: 2026-07-19

## 1. Mô tả lỗi (Bug Description)
Trước khi khắc phục, các chức năng lõi của hệ thống (như Giỏ hàng, Đặt hàng, Quản lý sản phẩm, Quản lý danh mục) gặp rủi ro liên quan đến sự an toàn của luồng thực thi (Thread Safety). Khi có nhiều người dùng cùng truy cập và thực hiện thao tác (chẳng hạn nhiều khách cùng đặt hàng một lúc), sẽ có rủi ro xảy ra lỗi sai dữ liệu, lỗi Deadlock hoặc `SQLException` vì nhiều luồng cùng tranh chấp một kết nối duy nhất.

## 2. Nguyên nhân (Root Cause)
Trong cấu trúc của Java Servlet, mỗi Servlet được tải dưới dạng một Singleton, nghĩa là chỉ có một đối tượng Servlet duy nhất phục vụ tất cả các luồng HTTP Request.
Hầu hết các class Controller (như `CartServlet`, `CheckoutServlet`, `ManageFlowerServlet`, v.v.) lại khai báo các Data Access Object (chẳng hạn `private final FlowerDAO flowerDAO = new FlowerDAO();`) ở cấp độ biến của lớp (instance field).
Vì `DBContext` cấp phát sẵn `Connection` ngay khi DAO được khởi tạo, biến instance này vô tình khiến hàng ngàn yêu cầu mạng chia sẻ chung duy nhất một `Connection` JDBC - vốn là một đối tượng **không Thread-Safe**.

## 3. Cách khắc phục (Resolution)
Để giải quyết triệt để lỗi thiết kế này, toàn bộ các Servlet Controller trong hệ thống đã được tái cấu trúc luồng dữ liệu.

### Thay đổi trong tất cả các Servlet
- Loại bỏ hoàn toàn các trường khai báo instance cho DAO.
- Tại mỗi phương thức xử lý (`doGet`, `doPost`, hoặc các phương thức private nội bộ), các đối tượng DAO sẽ được khởi tạo riêng lẻ như một biến cục bộ (local variable) của phương thức.
- Mô hình này đảm bảo mỗi một HTTP Request sẽ tạo ra một DAO mới (mang theo 1 Connection riêng biệt) hoạt động độc lập không bị ảnh hưởng bởi các phiên giao dịch khác.
- Sau khi DAO hoàn tất vai trò, lệnh `.close()` được gọi để dọn dẹp theo cập nhật từ `DBContext`.

## 4. Kết quả kiểm tra (Validation Results)
- Các tác vụ tạo DAO và đóng kết nối được quản lý độc lập tại từng Request. Không còn tình trạng nhiều thread tranh chấp quyền truy cập trên cùng một luồng dữ liệu của JDBC.
- Tăng tính toàn vẹn và mức độ an toàn cho các tác vụ thay đổi dữ liệu nhạy cảm.
