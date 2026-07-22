# Cập nhật: Hạ tầng Docker & Deployment

- **Thời gian**: 2026-07-20
- **Commits**: Chuỗi ~15 commits từ `a55d746` đến `85a51c2`

## Tổng quan

Triển khai toàn bộ hạ tầng containerization cho dự án bằng Docker và Docker Compose, cho phép deploy ứng dụng "1-chạm" trên bất kỳ máy chủ Linux nào có Docker mà không cần cài đặt JDK, Ant, hay SQL Server thủ công.

## Các thay đổi chính

### File mới được tạo

| File | Mô tả |
|---|---|
| `Dockerfile` | Multi-stage build: Stage 0 lấy Tomcat libs, Stage 1 biên dịch Java bằng `javac`, Stage 2 deploy WAR lên Tomcat 10 |
| `docker-compose.yml` | Định nghĩa 3 services: `sqlserver`, `init-db`, `webapp` |
| `database/Dockerfile` | Build image cho `init-db`, bake file SQL trực tiếp vào image |
| `.dockerignore` | Loại trừ `docs/`, `database/`, `scripts/`, `*.md` khỏi build context |

### Kiến trúc Docker Compose (3 Services)

```
┌─────────────────────────────────────────────────────┐
│                  Docker Network                     │
│                                                     │
│  ┌─────────────┐  ┌──────────┐  ┌───────────────┐  │
│  │  sqlserver   │  │ init-db  │  │    webapp      │  │
│  │  MSSQL 2022  │←─│ sqlcmd   │  │  Tomcat 10    │  │
│  │  Port: 1433  │  │ (seed)   │  │  Port: 8080   │  │
│  └─────────────┘  └──────────┘  └───────────────┘  │
└─────────────────────────────────────────────────────┘
```

### Các lỗi đã phát sinh và khắc phục trong quá trình triển khai

1. **Thiếu Servlet API khi biên dịch**: Ant build thất bại do không tìm thấy `servlet-api.jar` trong container builder. Giải pháp: Thêm Stage 0 copy thư viện từ image Tomcat.

2. **Lỗi NetBeans CopyLibs**: Ant cần thư viện `CopyLibs` của NetBeans để đóng gói WAR. Giải pháp: Bypass Ant hoàn toàn, dùng `javac` + `jar` trực tiếp.

3. **Tên Database sai (`FlowerShop` vs `FLOWER_SHOP`)**: Biến môi trường `DB_URL` trong docker-compose dùng tên `FlowerShop` trong khi file SQL tạo database tên `FLOWER_SHOP`. Giải pháp: Đổi `databaseName` về `FLOWER_SHOP`.

4. **Race condition giữa init-db và webapp**: Tomcat khởi động nhanh hơn quá trình nạp DB, gây lỗi kết nối. Giải pháp: Dùng `condition: service_completed_successfully` trong `depends_on`.

5. **Lỗi phân quyền `0x80070005` (Access Denied)**: Container `init-db` dùng user mặc định `mssql` không có quyền đọc file SQL mount từ host. Giải pháp: Bake file SQL vào image thay vì dùng bind mount.

6. **Sleep cố định không đủ cho Homelab**: Lệnh `sleep 20` quá ngắn cho máy chủ phần cứng yếu. Giải pháp: Thay bằng vòng lặp `until sqlcmd -Q 'SELECT 1'` kiểm tra kết nối liên tục mỗi 3 giây.

7. **Context Path `/flower-shop` thay vì `/`**: WAR file đặt tên `flower-shop.war` khiến Tomcat phục vụ ở path `/flower-shop`. Giải pháp: Đổi tên destination thành `ROOT.war`.

### Cải tiến bổ sung
- Thêm **Cloudflare Tunnel** vào docker-compose để expose ứng dụng ra internet qua domain riêng.
- Thêm biến môi trường `TZ=Asia/Ho_Chi_Minh` cho cả `webapp` và `sqlserver`.
- Hỗ trợ deploy qua **Portainer** (Git Repository mode).

### Tài liệu liên quan
- `docs/deployment-guide.md` — Hướng dẫn deploy cho người dùng cuối.
