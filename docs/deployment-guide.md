# Hướng dẫn Deploy dự án Flower Shop bằng Docker Compose (Khuyên dùng)

Dự án này là một ứng dụng **Java Web (JSP/Servlet)** sử dụng **SQL Server** làm cơ sở dữ liệu. Để đơn giản hóa và tối ưu quá trình vận hành trên môi trường Linux (hay bất kì hệ điều hành nào có Docker), chúng ta sẽ sử dụng **Docker** và **Docker Compose**.

Hệ thống sẽ được chia thành 3 container tự động tương tác với nhau:
1. `sqlserver`: Chạy hệ quản trị cơ sở dữ liệu MS SQL Server 2022.
2. `init-db`: Tự động nạp file SQL tạo Database và tự động tắt (Seed dữ liệu).
3. `webapp`: Chạy Apache Tomcat 9 chứa ứng dụng Java. Ứng dụng này sẽ lấy kết nối DB thông qua Biến môi trường do Docker cung cấp thay vì đọc cấu hình cục bộ.

Dưới đây là các bước siêu tốc để deploy ứng dụng này thông qua Docker Compose:

## Bước 1: Chuẩn bị tệp tin
Copy toàn bộ thư mục dự án lên Server Linux của bạn (hoặc đơn giản là dùng `git clone`).
Bạn không cần phải chạy công cụ biên dịch hay sửa cấu hình `ConnectDB.properties` vì Dockerfile giờ đây đã sử dụng **Multi-stage Build**, nó sẽ tự động tải JDK, cài Ant, biên dịch mã nguồn Java thành file WAR ngay bên trong container, và tự động truyền Biến môi trường.

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
