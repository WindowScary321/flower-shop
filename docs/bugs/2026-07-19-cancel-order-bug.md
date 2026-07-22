# Bug: Lỗi không huỷ được đơn hàng (Customer)

- **Thời gian**: 2026-07-19
- **Mức độ**: Nghiêm trọng
- **Commit**: `dbedafa`

## Mô tả lỗi

Khách hàng (`customer1`) không thể huỷ đơn hàng dù đơn hàng đang ở trạng thái "Chờ xử lý" — trạng thái cho phép huỷ theo nghiệp vụ.

## Nguyên nhân gốc

Trong file `OrderDAO.java`, hàm huỷ đơn hàng sử dụng điều kiện kiểm tra sai khiến câu truy vấn SQL không khớp với bản ghi nào cả. Logic so sánh AccountId bị thiếu hoặc sai chuỗi query, dẫn đến hàm `cancelOrder()` luôn trả về `false` (không có dòng nào bị ảnh hưởng).

## File bị ảnh hưởng

- `src/java/dal/OrderDAO.java` — Sửa lại logic query và điều kiện WHERE trong hàm huỷ đơn hàng (10 dòng thêm, 7 dòng xóa).

## Cách khắc phục

Sửa lại câu truy vấn UPDATE trong hàm `cancelOrder()` để đảm bảo:
1. Kiểm tra đúng `AccountId` của khách hàng đang đăng nhập.
2. Chỉ cho phép huỷ đơn ở trạng thái "Chờ xử lý".
3. Hoàn trả số lượng hoa vào kho khi huỷ thành công.
