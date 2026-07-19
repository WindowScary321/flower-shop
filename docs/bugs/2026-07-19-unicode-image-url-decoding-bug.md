# Bug: Lỗi hiển thị ảnh hoa chứa ký tự Unicode tiếng Việt có dấu (Unicode Image URL Decoding Bug)
Date: 2026-07-19

## 1. Mô tả lỗi (Bug Description)
Khi cào dữ liệu từ trang web Flower Corner, một số sản phẩm hoa bị lỗi không hiển thị được hình ảnh trên giao diện. Thay vào đó, hệ thống chỉ hiển thị hình ảnh dự phòng mặc định kèm chữ "Flower".

## 2. Nguyên nhân (Root Cause)
Các liên kết hình ảnh cào về từ trang nguồn được lưu trực tiếp dưới dạng ký tự Unicode tiếng Việt có dấu (ví dụ: `https://.../Bó Hoa/...` hoặc `https://.../Hoa Chia Buồn/...`). Khi lưu chuỗi thô này vào cơ sở dữ liệu và chuyển tiếp lên trình duyệt, trình duyệt web không thể tự động phân giải các ký tự có dấu và khoảng trắng chưa được chuẩn hóa, dẫn đến lỗi HTTP 400 hoặc HTTP 404.

## 3. Cách khắc phục (Resolution)
Kịch bản cào dữ liệu [scripts/scrape.py](file:///c:/Users/tusieumap/Projects/prj302/flower-shop/scripts/scrape.py) đã được nâng cấp và sửa đổi bằng cách thêm hàm xử lý chuẩn hóa `clean_url(url)`. Hàm này sử dụng mô-đun `urllib.parse` để chuyển đổi và mã hóa URL thô (ví dụ: chuyển khoảng trắng thành `%20`, chuyển ký tự có dấu `ó` thành `%C3%B3`, `uồ` thành `%E1%BB%93`) thành chuẩn ASCII an toàn trước khi ghi vào cơ sở dữ liệu.

### Các file được thay đổi:
- `scripts/scrape.py` (Kịch bản cào dữ liệu và sinh mã SQL)
- `database/FlowerShopDB.sql` (Cập nhật lại đường dẫn hình ảnh đã mã hóa chuẩn của 60 sản phẩm)

**Chi tiết xử lý chuẩn hóa URL trong Python:**
```python
def clean_url(url):
    try:
        parts = urllib.parse.urlsplit(url)
        unquoted_path = urllib.parse.unquote(parts.path)
        encoded_path = urllib.parse.quote(unquoted_path)
        return urllib.parse.urlunsplit((parts.scheme, parts.netloc, encoded_path, parts.query, parts.fragment))
    except Exception as e:
        return url
```

## 4. Kết quả kiểm tra (Validation Results)
- Chạy lại kịch bản cào dữ liệu và cập nhật cơ sở dữ liệu.
- Toàn bộ liên kết hình ảnh trong bảng `Flowers` của cơ sở dữ liệu đã được chuẩn hóa ASCII thành công.
- Không còn bất kỳ sản phẩm nào bị lỗi hiển thị hình ảnh trên trang chủ và danh mục sản phẩm.
