# Tính năng Trang chủ, Cập nhật thông tin cá nhân và Điều chỉnh giao diện Header/Footer

- **Thời gian**: 2026-07-19
- **Mục tiêu**: Cải tiến giao diện Trang chủ (Landing page) bám sát mẫu Flowershop.com.vn, cập nhật bố cục Header và Footer theo yêu cầu, bổ sung tính năng quản lý địa chỉ của tài khoản và cho phép khách hàng tự chỉnh sửa thông tin cá nhân/mật khẩu có cơ chế bắt lỗi nghiêm ngặt.

## Các thay đổi chính

### CSDL (Database)
- Bổ sung cột `Address` kiểu `NVARCHAR(255) NULL` vào bảng `Accounts` để lưu thông tin địa chỉ người dùng.
- Cập nhật định nghĩa bảng `Accounts` trong file kịch bản CSDL `database/FlowerShopDB.sql`.

### Models & DAOs
- **`models/Account.java`**:
  - Thêm thuộc tính `address` kiểu `String`.
  - Bổ sung các phương thức getter/setter cho `address`.
  - Cập nhật hàm tạo (Constructor) mới chứa đầy đủ tham số bao gồm địa chỉ.
- **`dal/AccountDAO.java`**:
  - Cập nhật ánh xạ dữ liệu trong các phương thức: `getAccountByUsernameAndPassword`, `getAccountById`, `getAllAccounts`, `searchAccountsPaging`, `insertAccount` để hỗ trợ lưu và lấy cột `Address`.
  - Thay đổi phương thức `updateProfile` để cập nhật Họ tên, Email, SĐT và Địa chỉ của người dùng.
  - Thêm phương thức `updatePassword` phục vụ việc đổi mật khẩu riêng biệt.
  - Thêm phương thức `checkEmailExistsExcept` để kiểm tra tính duy nhất của email khi người dùng thay đổi email cá nhân.

### Giao diện Điều hướng & Chân trang (Header & Footer)
- **`web/common/header.jsp`**:
  - Tách giao diện làm 2 thanh: Thanh trên màu hồng chứa logo Flower Shop ở góc trái, thông tin liên hệ và các nút Đăng nhập / Đăng ký ở góc trên bên phải.
  - Thanh dưới màu trắng chứa menu các danh mục sản phẩm từ DB: Trang chủ, Hoa cưới, Hoa sinh nhật, Hoa khai trương, Hoa chia buồn, Hoa trang trí.
  - Bổ sung điều kiện JSTL `<c:if>` ẩn hoàn toàn thanh danh mục màu trắng nếu người dùng đăng nhập dưới vai trò Admin hoặc Staff (Employee).
- **`web/common/footer.jsp`**:
  - Khai báo thư viện thẻ JSTL core ở đầu trang để xử lý hiển thị có điều kiện chính xác.
  - Xóa cột "QUY ĐỊNH & HƯỚNG DẪN", chia lại Footer làm 3 cột cân đối (`col-md-4`).
  - Trong cột "Tài khoản của bạn", loại bỏ dòng "Đăng xuất tài khoản" và "Tải xuống đơn hàng".
  - Định tuyến đúng các nút: "Tài khoản của bạn" và "Chỉnh sửa tài khoản" trỏ về `/profile`, "Đơn hàng của bạn" trỏ về đúng trang lịch sử đơn hàng tương ứng với vai trò của tài khoản đã đăng nhập.
  - Bắt lỗi khi chưa đăng nhập: Nếu người dùng chưa đăng nhập, khi click các mục này sẽ chuyển hướng về `/login.jsp` kèm tham số báo lỗi hiển thị trên giao diện.

### Giao diện Trang chủ (Landing Page)
- **`web/index.jsp`**:
  - Thay thế Hero Banner placeholder bằng ảnh thực tế từ tệp `/images/main_wallpaper.webp` và tạo dải chữ hiển thị nổi bật trên nền ảnh: *"Trao trọn cảm xúc, gửi trọn yêu thương"*.
  - Thêm khu vực "MUA HÀNG TẠI FLOWERSHOP.COM.VN" chứa các tiện ích cam kết chất lượng.
  - Loại bỏ các bài viết mẫu (về ý nghĩa các loại hoa) và băng chuyền logo đối tác ở cuối trang để làm tinh gọn giao diện theo yêu cầu.

### Giao diện & Logic Trang Cá Nhân (Profile Updates)
- **`web/profile.jsp`**:
  - Tái cấu trúc giao diện thành 2 cột: Cột bên trái hiển thị tĩnh thông tin hiện tại, cột bên phải chứa các form thay đổi thông tin.
  - Tách biệt thành Form thay đổi thông tin cá nhân và Form đổi mật khẩu riêng biệt.
- **`controllers/ProfileServlet.java`**:
  - Cập nhật phương thức `doPost` để xử lý 2 hành động (`action`): `updateInfo` (Cập nhật thông tin) và `changePassword` (Đổi mật khẩu).
  - Tăng cường kiểm tra dữ liệu đầu vào (Bắt buộc điền họ tên, kiểm tra định dạng email và kiểm tra trùng lặp email, kiểm tra số điện thoại bắt đầu bằng số 0 có 10-11 số, mật khẩu mới từ 6 ký tự).
  - Đối với Form cập nhật thông tin cá nhân, chỉ yêu cầu điền mật khẩu xác nhận khi người dùng có thay đổi *Họ và tên* hoặc *Email*. Nếu chỉ thay đổi *Số điện thoại* hoặc *Địa chỉ*, hệ thống cho phép bỏ qua xác nhận mật khẩu và cập nhật trực tiếp xuống CSDL.
