# Phân Công Nhóm & Tiến Độ — Flower Shop

## 6.1. Phân bổ điểm theo đề bài (Tổng: 100 + 10 bonus)

Bảng dưới đây tổng hợp cách đề bài chấm điểm, giúp nhóm ưu tiên hoàn thành
đúng thứ tự những phần có trọng số lớn nhất trước.

| STT | Tiêu chí                              | Điểm | Trạng thái   |
|-----|---------------------------------------|:----:|:------------:|
| 1   | Thiết kế Database (ERD, 5+ bảng, 3NF) | 10   | ⬜ Chưa làm  |
| 2   | Kiến trúc MVC đúng chuẩn              | 10   | ⬜ Chưa làm  |
| 3   | CRUD đầy đủ 5 thực thể               | 15   | ⬜ Chưa làm  |
| 4   | Tìm kiếm cơ bản + nâng cao           | 10   | ⬜ Chưa làm  |
| 5   | Phân trang (Pagination)               | 10   | ⬜ Chưa làm  |
| 6   | Validation dữ liệu                   | 10   | ⬜ Chưa làm  |
| 7   | Phân quyền (3 roles + Filter)        | 10   | ⬜ Chưa làm  |
| 8   | 5 Báo cáo thống kê                   | 10   | ⬜ Chưa làm  |
| 9   | Giao diện (responsive, Bootstrap)     | 5    | ⬜ Chưa làm  |
| 10  | Bảo vệ / Thuyết trình                | 10   | ⬜ Chưa làm  |
|     | **Tổng điểm chính**                   | **100** |           |
| 11  | Bonus: Upload ảnh                     | +2   | ⬜ Chưa làm  |
| 12  | Bonus: AJAX                           | +2   | ⬜ Chưa làm  |
| 13  | Bonus: Xuất Excel                     | +2   | ⬜ Chưa làm  |
| 14  | Bonus: Biểu đồ Chart.js              | +2   | ⬜ Chưa làm  |
| 15  | Bonus: Khác (email, log, PDF)         | +2   | ⬜ Chưa làm  |

---

## 6.2. Gợi ý phân công theo module

> **Ghi chú:** Điền tên thành viên phụ trách vào cột "Người phụ trách" bên dưới.
> Mỗi người nên làm xuyên suốt từ DAO → Servlet → JSP cho module mình phụ trách
> để đảm bảo tính nhất quán.

| Module                              | Người phụ trách | Ghi chú                                     |
|--------------------------------------|:---------------:|----------------------------------------------|
| **Database** (thiết kế + script SQL) | ___             | Làm đầu tiên, cả nhóm cùng review           |
| **Layout chung** (header, footer, sidebar) | ___       | CSS, Bootstrap, responsive                   |
| **Auth** (Login, Register, Logout)   | ___             | Bao gồm Filter phân quyền                   |
| **CRUD Categories**                  | ___             | Module đơn giản, phù hợp để bắt đầu         |
| **CRUD Flowers** (+ upload ảnh)      | ___             | Module lớn nhất phía Admin                   |
| **CRUD Accounts**                    | ___             | Quản lý tài khoản, khóa/mở tài khoản        |
| **Giỏ hàng + Checkout**             | ___             | Phần phức tạp nhất phía Customer             |
| **Xử lý đơn hàng** (Employee)       | ___             | Cập nhật trạng thái + hủy đơn hoàn kho      |
| **Lịch sử đơn hàng** (Customer)     | ___             | Xem đơn đã đặt + chi tiết                   |
| **5 Báo cáo thống kê + Dashboard**  | ___             | Viết SQL gom nhóm + hiển thị                 |
| **Validation**                       | ___             | Xem lại toàn bộ form, bổ sung kiểm tra      |
| **Tìm kiếm + Phân trang**           | ___             | Áp dụng cho tất cả trang danh sách           |
| **Bonus features**                   | ___             | Chỉ làm sau khi hoàn tất phần chính          |

---

## 6.3. Gợi ý lộ trình triển khai (Timeline)

### Giai đoạn 1 — Nền tảng (Tuần 1)
- [x] Thiết kế và tạo Database trên SQL Server
- [x] Thiết lập dự án NetBeans, cấu hình Tomcat
- [x] Viết DBContext.java + ConnectDB.properties
- [x] Tạo toàn bộ lớp Model (Java Beans)
- [x] Dựng layout giao diện chung (header, footer, CSS)
- [x] Triển khai Login, Register, Logout + Session

### Giai đoạn 2 — CRUD cốt lõi (Tuần 2)
- [x] CRUD Categories (DAO + Servlet + JSP)
- [x] CRUD Flowers (DAO + Servlet + JSP)
- [x] CRUD Accounts (DAO + Servlet + JSP)
- [x] Triển khai Filter phân quyền (Authentication + Authorization)
- [x] Áp dụng Validation cho toàn bộ form đã có

### Giai đoạn 3 — Nghiệp vụ mua hàng (Tuần 3)
- [ ] Giỏ hàng (Session-based Cart)
- [ ] Thanh toán (Checkout + Transaction)
- [ ] Xử lý đơn hàng (Employee cập nhật trạng thái)
- [ ] Hủy đơn hàng + hoàn trả tồn kho
- [ ] Lịch sử đơn hàng của Customer

### Giai đoạn 4 — Tìm kiếm, Phân trang, Thống kê (Tuần 4)
- [ ] Tìm kiếm cơ bản + nâng cao cho tất cả danh sách
- [ ] Phân trang cho tất cả danh sách
- [ ] Viết 5 câu truy vấn thống kê
- [ ] Xây dựng trang Dashboard hiển thị 5 báo cáo

### Giai đoạn 5 — Hoàn thiện & Bonus (Tuần 5)
- [ ] Upload hình ảnh hoa (Bonus +2đ)
- [ ] AJAX giỏ hàng (Bonus +2đ)
- [ ] Xuất Excel (Bonus +2đ)
- [ ] Kiểm tra toàn bộ Validation lần cuối
- [ ] Kiểm tra SQL Injection (không dùng cộng chuỗi)
- [ ] Kiểm tra responsive trên mobile
- [ ] Viết tài liệu, chuẩn bị slide thuyết trình
- [ ] Chuẩn bị ERD, Database Diagram để nộp kèm

---

## 6.4. Checklist trước khi nộp bài

- [ ] Database có tối thiểu 5 bảng, đạt chuẩn 3NF
- [ ] Có đầy đủ script SQL tạo bảng + dữ liệu mẫu
- [ ] Có sơ đồ ERD và Database Diagram
- [ ] Dự án chạy được trên Tomcat (không lỗi khi khởi động)
- [ ] Có ít nhất 3 vai trò đăng nhập được (admin, employee, customer)
- [ ] Filter phân quyền hoạt động đúng (admin không truy cập /customer, ngược lại)
- [ ] Tất cả 5 thực thể có CRUD đầy đủ
- [ ] Tìm kiếm cơ bản + nâng cao hoạt động
- [ ] Phân trang hiển thị đúng trên tất cả danh sách
- [ ] Validation bắt đúng lỗi: trống, sai định dạng, trùng dữ liệu
- [ ] 5 báo cáo thống kê hiển thị dữ liệu chính xác
- [ ] Không còn câu lệnh SQL nào cộng chuỗi trực tiếp (dùng PreparedStatement)
- [ ] Giao diện responsive cơ bản, menu điều hướng rõ ràng
- [ ] Mã nguồn sạch, không chứa code thừa hoặc code copy từ nhóm khác
