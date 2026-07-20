# Hướng dẫn Deploy dự án Flower Shop bằng Docker Compose

Dự án này là một ứng dụng **Java Web (JSP/Servlet)** sử dụng **SQL Server** làm cơ sở dữ liệu. 

Hệ thống sẽ được chia thành 3 container tự động tương tác với nhau:
1. `sqlserver`: Chạy hệ quản trị cơ sở dữ liệu MS SQL Server 2022.
2. `init-db`: Tự động nạp file SQL tạo Database và tự động tắt (Seed dữ liệu).
3. `webapp`: Chạy Apache Tomcat 10 chứa ứng dụng Java. Ứng dụng này sẽ lấy kết nối DB thông qua Biến môi trường do Docker cung cấp thay vì đọc cấu hình cục bộ.

## Bước 1: Chuẩn bị tệp tin
Clone repo này
```
git clone https://github.com/WindowScary321/flower-shop/
```

## Bước 3: Chạy Docker Compose
Chạy docker containers qua compose:
```bash
docker compose up -d --build
```
Hệ thống sẽ tải image SQL Server, chạy container `init-db` chờ 20 giây để nạp Database tự động, và chạy Tomcat image.

## Bước 4: Kiểm tra kết quả
Truy cập địa chỉ:
```
http://localhost:8080/
```
