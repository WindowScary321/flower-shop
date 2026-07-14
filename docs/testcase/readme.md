# Kịch Bản Kiểm Thử (Test Cases) — Flower Shop

Tài liệu này định nghĩa các kịch bản kiểm thử (Test Cases) thiết yếu để đảm bảo chất lượng và tính chính xác của dự án Flower Shop trước khi nghiệm thu. Các trường hợp được chia theo từng phân hệ chức năng (Module).

---

## 1. Phân hệ Xác thực & Phân quyền (Auth & Authorization)

| Mã TC | Chức năng | Mô tả Kịch bản (Test Scenario) | Kết quả mong đợi | Trạng thái | Ghi chú |
|---|---|---|---|:---:|---|
| AUTH_01 | Đăng ký | Đăng ký với dữ liệu hợp lệ (các trường điền đúng định dạng). | Đăng ký thành công, chuyển hướng đến trang Đăng nhập. Dữ liệu được lưu vào DB. | [ ] | |
| AUTH_02 | Đăng ký | Đăng ký với `Username` hoặc `Email` đã tồn tại trong hệ thống. | Hệ thống báo lỗi trùng lặp dữ liệu, giữ nguyên form. | [ ] | |
| AUTH_03 | Đăng ký | Bỏ trống các trường bắt buộc hoặc nhập sai định dạng email/sdt. | Hệ thống hiển thị lỗi validation tương ứng cho từng trường. | [ ] | |
| AUTH_04 | Đăng nhập | Đăng nhập với tài khoản Admin hợp lệ. | Đăng nhập thành công, chuyển hướng đến `/admin/dashboard`. | [ ] | |
| AUTH_05 | Đăng nhập | Đăng nhập với tài khoản Customer/Employee hợp lệ. | Chuyển hướng đúng: Customer -> Trang chủ, Employee -> Quản lý đơn hàng. | [ ] | |
| AUTH_06 | Đăng nhập | Đăng nhập sai mật khẩu hoặc sai tên đăng nhập. | Báo lỗi "Sai tên đăng nhập hoặc mật khẩu" tại trang đăng nhập. | [ ] | |
| AUTH_07 | Đăng nhập | Đăng nhập bằng tài khoản đang bị khóa (`Status = 0`). | Báo lỗi "Tài khoản đã bị khóa", không cho phép truy cập. | [ ] | |
| AUTH_08 | Phân quyền | Truy cập `/admin/*` bằng tài khoản Customer. | Bị chặn, chuyển hướng đến trang báo lỗi 403 (Không có quyền). | [ ] | |
| AUTH_09 | Phân quyền | Truy cập `/customer/checkout` khi chưa đăng nhập (Guest). | Bị chặn, yêu cầu đăng nhập trước khi tiếp tục. | [ ] | |

---

## 2. Phân hệ Quản trị (Admin)

### 2.1. Quản lý Danh mục (Categories) & Hoa (Flowers)
| Mã TC | Chức năng | Mô tả Kịch bản (Test Scenario) | Kết quả mong đợi | Trạng thái | Ghi chú |
|---|---|---|---|:---:|---|
| CRUD_01 | Thêm Hoa | Thêm sản phẩm hoa mới với đầy đủ thông tin hợp lệ (giá > 0, số lượng >= 0). | Thêm thành công, hoa xuất hiện ở đầu trang danh sách quản lý. | [ ] | |
| CRUD_02 | Thêm Hoa | Nhập giá trị âm cho Giá (Price) hoặc Số lượng (Quantity). | Form báo lỗi dữ liệu không hợp lệ (Validation rules). | [ ] | |
| CRUD_03 | Xóa Hoa | Thực hiện xóa mềm (đổi Status = 0) một sản phẩm hoa đang bán. | Sản phẩm biến mất khỏi giao diện khách hàng (trang chủ/danh mục), nhưng vẫn còn trong DB để phục vụ lịch sử đơn hàng. | [ ] | |
| CRUD_04 | Phân trang | Kiểm tra danh sách hoa có nhiều hơn 10 sản phẩm (1 trang). | Thanh phân trang xuất hiện, chuyển trang dữ liệu hiển thị chính xác. | [ ] | |

### 2.2. Thống kê & Báo cáo (Dashboard)
| Mã TC | Chức năng | Mô tả Kịch bản (Test Scenario) | Kết quả mong đợi | Trạng thái | Ghi chú |
|---|---|---|---|:---:|---|
| REP_01 | Doanh thu | Kiểm tra tổng doanh thu theo tháng của các đơn hàng "Đã giao". | Số liệu khớp hoàn toàn với tổng `TotalAmount` của các đơn "Đã giao" trong tháng đó dưới DB. Các đơn "Đã hủy" không được cộng vào. | [ ] | |
| REP_02 | Tồn kho | Kiểm tra danh sách "Hoa sắp hết hàng" (tồn kho < 10). | Chỉ hiển thị các sản phẩm có `Status = 1` và `Quantity < 10`. | [ ] | |

---

## 3. Phân hệ Khách hàng (Customer - Giỏ hàng & Mua hàng)

| Mã TC | Chức năng | Mô tả Kịch bản (Test Scenario) | Kết quả mong đợi | Trạng thái | Ghi chú |
|---|---|---|---|:---:|---|
| CART_01 | Thêm vào giỏ | Thêm 1 sản phẩm hoa vào giỏ hàng từ trang danh sách (Guest). | Yêu cầu đăng nhập. (Hoặc nếu cho phép Guest thêm, thì session phải lưu lại sau khi login). | [ ] | |
| CART_02 | Thêm vào giỏ | Thêm cùng 1 sản phẩm (cùng `FlowerId`) 2 lần khác nhau vào giỏ. | Số lượng của sản phẩm đó trong giỏ hàng tăng lên thành 2, không tạo ra 2 dòng riêng biệt. | [ ] | |
| CART_03 | Thêm vào giỏ | Thêm 1 bông hoa hồng (`FlowerId=1`) và 1 bó hoa hồng (`FlowerId=2`). | Giỏ hàng hiển thị 2 dòng riêng biệt do khác `FlowerId`. | [ ] | |
| CART_04 | Cập nhật giỏ | Tăng số lượng mua lớn hơn số lượng tồn kho (`Quantity`) hiện có. | Hệ thống chặn và báo lỗi vượt quá số lượng cho phép. | [ ] | |
| CART_05 | Thanh toán | Tiến hành đặt hàng với thông tin người nhận hợp lệ. | Đơn hàng chuyển sang trạng thái "Chờ xử lý". Số lượng tồn kho của các hoa trong đơn lập tức bị trừ đi tương ứng. Giỏ hàng trống. | [ ] | |
| CART_06 | Lịch sử | Khách hàng xem lịch sử đơn hàng vừa đặt. | Đơn hàng xuất hiện trong danh sách kèm chi tiết các hoa đã mua và giá tiền được đóng băng tại thời điểm đó (`UnitPrice`). | [ ] | |

---

## 4. Phân hệ Nhân viên (Employee - Xử lý đơn)

| Mã TC | Chức năng | Mô tả Kịch bản (Test Scenario) | Kết quả mong đợi | Trạng thái | Ghi chú |
|---|---|---|---|:---:|---|
| EMP_01 | Cập nhật đơn | Chuyển trạng thái đơn hàng từ "Chờ xử lý" sang "Đang giao" rồi "Đã giao". | Cập nhật thành công, khách hàng xem lịch sử sẽ thấy trạng thái mới. | [ ] | |
| EMP_02 | Hủy đơn | Nhân viên hủy một đơn hàng đang "Chờ xử lý" (khách không nhận hàng). | Đơn chuyển sang "Đã hủy". Số lượng hoa tương ứng lập tức được cộng trả lại vào bảng tồn kho (`Flowers`). | [ ] | |

---

## 5. Tìm kiếm (Search & Filter)

| Mã TC | Chức năng | Mô tả Kịch bản (Test Scenario) | Kết quả mong đợi | Trạng thái | Ghi chú |
|---|---|---|---|:---:|---|
| SRCH_01 | Tìm kiếm | Khách hàng tìm hoa theo từ khóa có dấu tiếng Việt (vd: "Hoa hồng"). | Hệ thống trả về kết quả chính xác không bị lỗi font nhờ `UTF8Filter`. | [ ] | |
| SRCH_02 | Lọc nâng cao | Kết hợp tìm kiếm: Danh mục "Hoa cưới" + Khoảng giá "500k - 1000k". | Danh sách trả về chỉ chứa hoa cưới có giá nằm trong khoảng chỉ định. Các điều kiện lọc kết hợp qua mệnh đề AND chính xác. | [ ] | |
| SRCH_03 | SQL Injection | Nhập chuỗi `' OR '1'='1` vào ô tìm kiếm tên hoa. | Hệ thống coi đây là chuỗi văn bản bình thường (nhờ `PreparedStatement`), không trả về toàn bộ DB, không bị lỗi cú pháp. | [ ] | |

---

## Lưu ý khi thực thi (Execution Note):
- Trong quá trình test giỏ hàng, nên thao tác song song bằng 2 trình duyệt (hoặc 1 trình duyệt thường + 1 trình duyệt ẩn danh) để giả lập 2 khách hàng mua hàng cùng lúc xem số lượng tồn kho bị trừ có chính xác không.
