# Nhật ký tiến trình - Giai đoạn 2 (CRUD Cốt lõi & Phân quyền)

## Mục tiêu đã hoàn thành
Giai đoạn 2 tập trung vào việc biến ứng dụng từ giao diện tĩnh (HTML/CSS) thành một ứng dụng web động thực sự với khả năng thao tác dữ liệu từ DB, kết hợp với các cơ chế bảo mật cốt lõi:

1. **Hiển thị dữ liệu thực ra Trang chủ**:
   - Khởi tạo `HomeServlet` để query dữ liệu sản phẩm hoa (có status đang bán) từ CSDL.
   - Forward dữ liệu sang `index.jsp` và dùng JSTL `<c:forEach>` để in ra các thẻ sản phẩm một cách linh hoạt, thay vì code cứng tĩnh. Hỗ trợ hiển thị trường `Unit` vừa bổ sung.

2. **Quản trị Danh mục (Categories)**:
   - Viết `CategoryDAO` với các phương thức CRUD đầy đủ.
   - Thiết kế `ManageCategoryServlet` cho đường dẫn `/admin/manage-categories`.
   - Xây dựng giao diện `admin/manage-categories.jsp` sử dụng Bootstrap Modal cho thao tác Thêm/Sửa ngay trên cùng một trang, giúp UX mượt mà.

3. **Quản trị Sản phẩm Hoa (Flowers)**:
   - Cập nhật `FlowerDAO` và mô hình `Flower.java` để tương thích hoàn toàn với trường `Unit` mới thiết kế.
   - Xây dựng `ManageFlowerServlet` hỗ trợ nhận toàn bộ dữ liệu form (Bao gồm Tên, Đơn vị tính, Giá, Số lượng, Ảnh, Danh mục, Trạng thái).
   - Xây dựng giao diện `admin/manage-flowers.jsp` với bảng hiển thị đẹp mắt, tự tự động đổi màu badge cho số lượng và trạng thái.

4. **Quản trị Tài khoản (Accounts)**:
   - Bổ sung hàm lấy tất cả user và hàm UpdateStatus vào `AccountDAO`.
   - Viết `ManageAccountServlet` xử lý Toggle Status (Khóa/Mở khóa) với logic bảo vệ: Admin không thể tự khóa tài khoản của chính mình.
   - Trang `admin/manage-accounts.jsp` hiển thị danh sách người dùng với nhãn phân quyền và nút Toggle Status tiện dụng.

5. **Phân quyền Bảo mật (Authorization)**:
   - Áp dụng `AuthFilter` sử dụng annotation `@WebFilter`.
   - Lọc tất cả request truy cập vào chuỗi `/admin/*`, `/employee/*`.
   - Tiến hành check Session: Nếu chưa đăng nhập hoặc Role không hợp lệ -> Redirect về trang Login kèm Error Message từ chối quyền truy cập.

6. **Cấu trúc file đã thay đổi**:
   - **DAL**: `CategoryDAO.java`, `FlowerDAO.java`, update `AccountDAO.java`.
   - **Controllers**: `HomeServlet.java`, `admin/ManageCategoryServlet.java`, `admin/ManageFlowerServlet.java`, `admin/ManageAccountServlet.java`, `admin/DashboardServlet.java`.
   - **Filter**: `AuthFilter.java`.
   - **Views**: Update `web/index.jsp`. Thêm `web/admin/dashboard.jsp`, `web/admin/manage-categories.jsp`, `web/admin/manage-flowers.jsp`, `web/admin/manage-accounts.jsp`.

7. **Kinh nghiệm rút ra & Ghi chú**:
   - Các JSP bên trong thư mục `/admin/` sẽ không thể truy cập trực tiếp nếu người dùng cố gõ URL tay nhờ lớp bảo vệ vững chắc từ `AuthFilter`.
   - Giao diện Admin quản trị được dùng chung một Sidebar (`sidebar-admin.jsp`), đảm bảo tính đồng nhất UI/UX.
   - Việc xử lý luồng `Unit` linh hoạt cho sản phẩm hoa đã đáp ứng hoàn hảo bài toán 1 bông/1 đóa từ giảng viên, trong khi không làm phình to kiến trúc Database.

## Hướng dẫn các bước tiếp theo
- **Giai đoạn 3**: Chuyển hướng sang xây dựng luồng mua hàng (Nghiệp vụ cốt lõi) bao gồm Giỏ hàng (Cart) và Thanh toán (Checkout) dành cho Customer.
