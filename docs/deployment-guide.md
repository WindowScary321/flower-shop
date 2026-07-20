# Hướng dẫn Deploy dự án Flower Shop bằng Docker Compose (Khuyên dùng)

Dự án này là một ứng dụng **Java Web (JSP/Servlet)** sử dụng **SQL Server** làm cơ sở dữ liệu. Để đơn giản hóa và tối ưu quá trình vận hành trên môi trường Linux (hay bất kì hệ điều hành nào có Docker), chúng ta sẽ sử dụng **Docker** và **Docker Compose**.

Hệ thống sẽ được chia thành 3 container tự động tương tác với nhau:
1. `sqlserver`: Chạy hệ quản trị cơ sở dữ liệu MS SQL Server 2022.
2. `init-db`: Tự động nạp file SQL tạo Database và tự động tắt (Seed dữ liệu).
3. `webapp`: Chạy Apache Tomcat 9 chứa ứng dụng Java. Ứng dụng này sẽ lấy kết nối DB thông qua Biến môi trường do Docker cung cấp thay vì đọc cấu hình cục bộ.

Dưới đây là các bước siêu tốc để deploy ứng dụng này thông qua Docker Compose:

## Bước 1: Đóng gói dự án (Build WAR file)
Bạn không cần phải thay đổi cấu hình `ConnectDB.properties` vì Docker sẽ tự động chèn Biến môi trường đè lên tệp cấu hình đó.
- **Nếu dùng NetBeans**: Mở dự án, nhấn chuột phải vào Project -> Chọn **Clean and Build**.
- **Nếu dùng Terminal (yêu cầu cài Ant)**: Mở thư mục gốc và chạy lệnh `ant`.
Kết quả: Bạn sẽ thu được tệp `flower-shop.war` nằm bên trong thư mục `dist/`. Đây là tệp ứng dụng mà Dockerfile sẽ nạp vào Tomcat.

## Bước 2: Đưa tệp lên máy chủ Linux
Copy toàn bộ thư mục dự án (hoặc ít nhất các tệp sau) lên Server Linux của bạn:
- `Dockerfile`
- `docker-compose.yml`
- `dist/flower-shop.war`
- `database/FlowerShopDB.sql`

## Bước 3: Chạy Docker Compose
Đăng nhập vào máy chủ Linux, mở terminal tại thư mục chứa tệp `docker-compose.yml` và chạy duy nhất lệnh sau để build ảnh Tomcat cũng như khởi tạo các container ở chế độ nền:
```bash
docker compose up -d --build
```
Hệ thống sẽ tải image SQL Server, chạy container `init-db` chờ 20 giây để nạp Database tự động, và chạy Tomcat image. Toàn bộ quy trình chỉ cần chạy 1 lệnh!

## Bước 4: Kiểm tra kết quả
Tomcat đã được thiết lập chạy trên cổng 8080 và tự động giải nén ứng dụng.
Hãy mở trình duyệt web và truy cập địa chỉ:
```
http://<IP_LINUX_SERVER>:8080/flower-shop
```

> **Lưu ý**: Đảm bảo rằng máy chủ Linux của bạn đã mở cổng `8080` ở tường lửa (UFW) hoặc Security Group trên Cloud để có thể truy cập từ xa. Cổng `1433` cũng đang được mở để bạn có thể kết nối SQL Server Management Studio vào xem nếu cần thiết.
