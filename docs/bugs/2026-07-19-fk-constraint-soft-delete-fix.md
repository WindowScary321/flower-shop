# Bug: Quản lý Ngoại Lệ Xóa Dữ Liệu Ràng Buộc (FK Constraint) (BUG-12)
Date: 2026-07-19

## 1. Mô tả lỗi (Bug Description)
Trước khi khắc phục, tính năng xóa Sản phẩm Hoa (`Flower`) và Danh mục (`Category`) trên trang Quản lý (Admin) gây ra sự hiểu lầm lớn. 
Nếu một sản phẩm hoa đã từng được mua (nằm trong `OrderDetails`), hành động xóa sẽ bị khóa bởi SQL Server do ràng buộc khóa ngoại (Foreign Key Constraint). Tuy nhiên, `FlowerDAO` lại chọn cách "nuốt" lỗi (in ra console thay vì bắn exception lên). Do đó, giao diện Servlet vẫn hiển thị dòng chữ "Xóa sản phẩm hoa thành công" khiến người quản trị lầm tưởng rằng hàng hóa đã bị gỡ.

## 2. Nguyên nhân (Root Cause)
Khối `catch (SQLException e)` trong các hàm `deleteFlower` và `deleteCategory` bị lỗi thiết kế. Chúng chỉ gọi `System.out.println(e)` mà không trả về kết quả lỗi `false` hay ném (throw) lỗi ra ngoài để tầng Controller (Servlet) có thể phản ứng.

## 3. Cách khắc phục (Resolution)
Để mang lại trải nghiệm người dùng chính xác, lỗi này đã được xử lý bằng giải pháp xóa mềm (soft-delete) dành cho Hoa và cảnh báo nghiêm ngặt dành cho Danh mục.

### Thay đổi trong `FlowerDAO.java` và `ManageFlowerServlet.java`
- Chuyển kiểu trả về của `deleteFlower` từ `void` thành `boolean`.
- Trong khối `catch`, nếu phát hiện chuỗi lỗi SQL chứa từ khóa "FOREIGN KEY" hoặc "REFERENCE", hệ thống sẽ tự động thực thi thêm một truy vấn UPDATE để đổi `Status` của sản phẩm đó về `0` (ẩn/ngừng kinh doanh). Trả về `false`.
- Giao diện JSP sẽ hiển thị: "Sản phẩm đang nằm trong đơn hàng nên đã được ẩn (ngừng kinh doanh) thay vì xóa hoàn toàn."

### Thay đổi trong `CategoryDAO.java` và `ManageCategoryServlet.java`
- Chuyển `deleteCategory` từ `void` thành `boolean`. Bắt ngoại lệ và trả về `false`.
- Giao diện Servlet trả về cảnh báo màu đỏ: "Danh mục đang chứa sản phẩm hoa, không thể xóa!" thay vì báo thành công giả.

## 4. Kết quả kiểm tra (Validation Results)
- Dữ liệu hóa đơn không bị phá vỡ (vi phạm FK).
- Admin nhận được phản hồi chính xác, không còn thông báo gây nhầm lẫn.
- Hoa dính constraint tự động được gỡ khỏi trang bán hàng chính (Status = 0) đúng theo logic nghiệp vụ được mong đợi.
