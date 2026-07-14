# Luồng Xử Lý Nghiệp Vụ & Phân Quyền — Flower Shop

## 3.1. Sơ đồ tương tác giữa các vai trò

```mermaid
graph TD
    subgraph "Khách vãng lai (Guest)"
        G1["Xem danh sách hoa"]
        G2["Tìm kiếm hoa"]
        G3["Xem chi tiết hoa"]
        G4["Đăng ký / Đăng nhập"]
    end

    subgraph "Khách hàng (Customer)"
        C1["Thêm hoa vào giỏ"]
        C2["Quản lý giỏ hàng"]
        C3["Thanh toán (Checkout)"]
        C4["Xem lịch sử đơn hàng"]
        C5["Cập nhật hồ sơ cá nhân"]
    end

    subgraph "Nhân viên (Employee)"
        E1["Xem đơn hàng mới"]
        E2["Cập nhật trạng thái đơn"]
        E3["Hủy đơn & hoàn kho"]
        E4["Cập nhật tồn kho"]
    end

    subgraph "Quản trị viên (Admin)"
        A1["CRUD Danh mục hoa"]
        A2["CRUD Sản phẩm hoa"]
        A3["Quản lý tài khoản"]
        A4["Xem thống kê / Dashboard"]
        A5["Xem tổng quan đơn hàng"]
    end

    G4 -->|Đăng nhập thành công| C1
    C3 -->|Tạo đơn hàng| E1
    E2 -->|Đơn hoàn thành| C4
    A3 -->|Tạo tài khoản nhân viên| E1
    A4 -->|Dữ liệu từ| E2
```

## 3.2. Ma trận phân quyền (Permission Matrix)

Bảng dưới đây liệt kê rõ ràng từng chức năng mà mỗi vai trò có quyền truy cập.
Đây là cơ sở để cấu hình `AuthorizationFilter` trong tệp `web.xml`.

| Chức năng / Trang              | Guest | Customer | Employee | Admin |
|---------------------------------|:-----:|:--------:|:--------:|:-----:|
| Xem trang chủ, danh sách hoa   |  ✅   |    ✅    |    ✅    |  ✅   |
| Tìm kiếm sản phẩm hoa          |  ✅   |    ✅    |    ✅    |  ✅   |
| Xem chi tiết sản phẩm hoa      |  ✅   |    ✅    |    ✅    |  ✅   |
| Đăng ký tài khoản               |  ✅   |    ❌    |    ❌    |  ❌   |
| Đăng nhập                       |  ✅   |    ❌    |    ❌    |  ❌   |
| Thêm hoa vào giỏ hàng          |  ❌   |    ✅    |    ❌    |  ❌   |
| Xem / sửa giỏ hàng             |  ❌   |    ✅    |    ❌    |  ❌   |
| Thanh toán đặt đơn             |  ❌   |    ✅    |    ❌    |  ❌   |
| Xem lịch sử đơn hàng cá nhân  |  ❌   |    ✅    |    ❌    |  ❌   |
| Cập nhật hồ sơ cá nhân         |  ❌   |    ✅    |    ✅    |  ✅   |
| Xem danh sách đơn cần xử lý   |  ❌   |    ❌    |    ✅    |  ✅   |
| Cập nhật trạng thái đơn hàng   |  ❌   |    ❌    |    ✅    |  ✅   |
| Hủy đơn hàng & hoàn trả kho   |  ❌   |    ❌    |    ✅    |  ✅   |
| Cập nhật số lượng tồn kho      |  ❌   |    ❌    |    ✅    |  ✅   |
| CRUD Danh mục hoa              |  ❌   |    ❌    |    ❌    |  ✅   |
| CRUD Sản phẩm hoa              |  ❌   |    ❌    |    ❌    |  ✅   |
| Quản lý tài khoản người dùng   |  ❌   |    ❌    |    ❌    |  ✅   |
| Xem Dashboard thống kê         |  ❌   |    ❌    |    ❌    |  ✅   |

### Cấu hình URL Pattern cho Filter

```
/admin/*        → Chỉ role = "admin"
/employee/*     → Chỉ role = "employee" hoặc "admin"
/customer/*     → Chỉ role = "customer" (đã đăng nhập)
/cart, /checkout → Chỉ role = "customer" (đã đăng nhập)
/*              → Tất cả (public)
```

## 3.3. Luồng nghiệp vụ chi tiết

### Luồng 1: Đăng ký tài khoản

```mermaid
sequenceDiagram
    actor Guest
    participant JSP as register.jsp
    participant Servlet as RegisterServlet
    participant DAO as AccountDAO
    participant DB as SQL Server

    Guest->>JSP: Điền form đăng ký
    JSP->>Servlet: POST (username, password, email, phone, fullname)
    Servlet->>Servlet: Validate dữ liệu (trống, định dạng, độ dài)
    alt Dữ liệu không hợp lệ
        Servlet->>JSP: Forward lại form + thông báo lỗi
    else Dữ liệu hợp lệ
        Servlet->>DAO: checkUsernameExists(username)
        Servlet->>DAO: checkEmailExists(email)
        alt Username hoặc Email bị trùng
            Servlet->>JSP: Forward lại form + thông báo trùng
        else Không trùng
            Servlet->>Servlet: Băm mật khẩu SHA-256
            Servlet->>DAO: insertAccount(account)
            DAO->>DB: INSERT INTO Accounts ...
            Servlet->>JSP: Redirect -> login.jsp (đăng ký thành công)
        end
    end
```

### Luồng 2: Đăng nhập & Phân quyền

```mermaid
sequenceDiagram
    actor User
    participant JSP as login.jsp
    participant Servlet as LoginServlet
    participant DAO as AccountDAO
    participant DB as SQL Server
    participant Session as HttpSession

    User->>JSP: Nhập username + password
    JSP->>Servlet: POST (username, password)
    Servlet->>Servlet: Băm password nhập vào
    Servlet->>DAO: getAccountByUsernameAndPassword(username, hashedPwd)
    DAO->>DB: SELECT * FROM Accounts WHERE ...
    alt Không tìm thấy tài khoản
        Servlet->>JSP: Forward login.jsp + "Sai tên đăng nhập hoặc mật khẩu"
    else Tài khoản bị khóa (Status = 0)
        Servlet->>JSP: Forward login.jsp + "Tài khoản đã bị khóa"
    else Đăng nhập thành công
        Servlet->>Session: setAttribute("user", account)
        alt role = admin
            Servlet->>JSP: Redirect -> /admin/dashboard
        else role = employee
            Servlet->>JSP: Redirect -> /employee/manage-orders
        else role = customer
            Servlet->>JSP: Redirect -> /index.jsp (trang chủ)
        end
    end
```

### Luồng 3: Mua hàng (Giỏ hàng → Thanh toán)

```mermaid
sequenceDiagram
    actor Customer
    participant CatalogJSP as flower-catalog.jsp
    participant CartServlet as CartServlet
    participant Session as HttpSession
    participant CheckoutServlet as CheckoutServlet
    participant OrderDAO as OrderDAO
    participant DB as SQL Server

    Customer->>CatalogJSP: Bấm "Thêm vào giỏ"
    CatalogJSP->>CartServlet: GET /cart?action=add&flowerId=3&qty=1
    CartServlet->>Session: Lấy Map<Integer, CartItem> từ session
    CartServlet->>Session: Thêm/cập nhật CartItem vào Map
    CartServlet->>CatalogJSP: Redirect lại trang danh mục

    Customer->>CartServlet: Xem giỏ hàng (/cart?action=view)
    CartServlet->>Session: Đọc giỏ hàng
    CartServlet->>CatalogJSP: Forward -> cart.jsp

    Customer->>CheckoutServlet: POST (receiverName, address, phone)
    CheckoutServlet->>CheckoutServlet: Validate thông tin giao hàng
    CheckoutServlet->>DB: BEGIN TRANSACTION
    CheckoutServlet->>OrderDAO: insertOrder(order)
    OrderDAO->>DB: INSERT INTO Orders ...
    loop Mỗi CartItem trong giỏ hàng
        CheckoutServlet->>OrderDAO: insertOrderDetail(detail)
        OrderDAO->>DB: INSERT INTO OrderDetails ...
        CheckoutServlet->>DB: UPDATE Flowers SET Quantity = Quantity - ? WHERE FlowerId = ?
    end
    CheckoutServlet->>DB: COMMIT TRANSACTION
    CheckoutServlet->>Session: Xóa giỏ hàng khỏi session
    CheckoutServlet->>CatalogJSP: Redirect -> success.jsp
```

### Luồng 4: Nhân viên xử lý đơn hàng

```mermaid
sequenceDiagram
    actor Employee
    participant JSP as manage-orders.jsp
    participant Servlet as ManageOrderServlet
    participant DAO as OrderDAO
    participant DB as SQL Server

    Employee->>Servlet: GET /employee/manage-orders
    Servlet->>DAO: getOrdersByStatus("Chờ xử lý")
    DAO->>DB: SELECT * FROM Orders WHERE Status = N'Chờ xử lý'
    Servlet->>JSP: Forward danh sách đơn hàng

    Employee->>Servlet: POST /employee/manage-orders (action=updateStatus, orderId=2, newStatus="Đang giao")
    Servlet->>DAO: updateOrderStatus(orderId, newStatus)
    DAO->>DB: UPDATE Orders SET Status = ? WHERE OrderId = ?
    Servlet->>JSP: Redirect lại trang quản lý

    Note over Employee,DB: Trường hợp hủy đơn
    Employee->>Servlet: POST (action=cancel, orderId=3)
    Servlet->>DAO: getOrderDetails(orderId)
    loop Mỗi OrderDetail
        Servlet->>DB: UPDATE Flowers SET Quantity = Quantity + ? WHERE FlowerId = ?
    end
    Servlet->>DAO: updateOrderStatus(orderId, "Đã hủy")
    Servlet->>JSP: Redirect lại
```

### Luồng 5: Admin quản lý sản phẩm hoa (CRUD)

```mermaid
sequenceDiagram
    actor Admin
    participant ListJSP as manage-flowers.jsp
    participant FormJSP as flower-form.jsp
    participant Servlet as ManageFlowerServlet
    participant DAO as FlowerDAO
    participant DB as SQL Server

    Note over Admin,DB: READ - Xem danh sách
    Admin->>Servlet: GET /admin/manage-flowers
    Servlet->>DAO: getAllFlowersPaging(page)
    DAO->>DB: SELECT ... OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
    Servlet->>ListJSP: Forward danh sách + phân trang

    Note over Admin,DB: CREATE - Thêm hoa mới
    Admin->>Servlet: GET /admin/manage-flowers?action=add
    Servlet->>FormJSP: Forward form rỗng
    Admin->>Servlet: POST (flowerName, price, qty, categoryId, image)
    Servlet->>Servlet: Validate dữ liệu
    Servlet->>DAO: insertFlower(flower)
    DAO->>DB: INSERT INTO Flowers ...
    Servlet->>ListJSP: Redirect -> danh sách

    Note over Admin,DB: UPDATE - Sửa thông tin hoa
    Admin->>Servlet: GET /admin/manage-flowers?action=edit&id=3
    Servlet->>DAO: getFlowerById(3)
    Servlet->>FormJSP: Forward form đã điền sẵn dữ liệu
    Admin->>Servlet: POST (cập nhật thông tin)
    Servlet->>DAO: updateFlower(flower)
    DAO->>DB: UPDATE Flowers SET ... WHERE FlowerId = ?
    Servlet->>ListJSP: Redirect -> danh sách

    Note over Admin,DB: DELETE - Xóa sản phẩm hoa
    Admin->>Servlet: GET /admin/manage-flowers?action=delete&id=5
    Servlet->>DAO: deleteFlower(5)
    DAO->>DB: DELETE FROM Flowers WHERE FlowerId = ?
    Servlet->>ListJSP: Redirect -> danh sách
```
