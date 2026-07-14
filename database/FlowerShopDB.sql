USE master;
GO
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'FLOWER_SHOP')
BEGIN
    ALTER DATABASE FLOWER_SHOP SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE FLOWER_SHOP;
END
GO
CREATE DATABASE FLOWER_SHOP;
GO
USE FLOWER_SHOP;
GO

-- ============================================
-- BẢNG 1: Categories (Danh mục hoa)
-- ============================================
CREATE TABLE Categories (
    CategoryId   INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(100)  NOT NULL UNIQUE,
    Description  NVARCHAR(255)  NULL
);

-- ============================================
-- BẢNG 2: Flowers (Sản phẩm hoa)
-- ============================================
CREATE TABLE Flowers (
    FlowerId    INT IDENTITY(1,1) PRIMARY KEY,
    FlowerName  NVARCHAR(150)  NOT NULL,
    Unit        NVARCHAR(50)   DEFAULT N'Bông',
    Price       DECIMAL(18,2)  NOT NULL CHECK (Price >= 0),
    Quantity    INT            NOT NULL CHECK (Quantity >= 0),
    Image       VARCHAR(255)   NULL,
    Description NVARCHAR(MAX)  NULL,
    CategoryId  INT            NULL,
    Status      BIT            DEFAULT 1,
    CONSTRAINT FK_Flowers_Categories
        FOREIGN KEY (CategoryId) REFERENCES Categories(CategoryId)
        ON DELETE SET NULL
);

-- ============================================
-- BẢNG 3: Accounts (Tài khoản người dùng)
-- ============================================
CREATE TABLE Accounts (
    AccountId INT IDENTITY(1,1) PRIMARY KEY,
    Username  VARCHAR(50)    NOT NULL UNIQUE,
    Password  VARCHAR(256)   NOT NULL,
    FullName  NVARCHAR(100)  NOT NULL,
    Email     VARCHAR(100)   NOT NULL UNIQUE,
    Phone     VARCHAR(15)    NOT NULL,
    Role      VARCHAR(20)    NOT NULL
              CHECK (Role IN ('admin', 'employee', 'customer')),
    Status    BIT            DEFAULT 1
);

-- ============================================
-- BẢNG 4: Orders (Đơn đặt hàng)
-- ============================================
CREATE TABLE Orders (
    OrderId         INT IDENTITY(1,1) PRIMARY KEY,
    OrderDate       DATETIME       DEFAULT GETDATE(),
    TotalAmount     DECIMAL(18,2)  NOT NULL CHECK (TotalAmount >= 0),
    ReceiverName    NVARCHAR(100)  NOT NULL,
    ReceiverAddress NVARCHAR(255)  NOT NULL,
    ReceiverPhone   VARCHAR(15)    NOT NULL,
    Status          NVARCHAR(50)   DEFAULT N'Chờ xử lý'
                    CHECK (Status IN (N'Chờ xử lý', N'Đang giao', N'Đã giao', N'Đã hủy')),
    PaymentMethod   VARCHAR(20)    DEFAULT 'COD' CHECK (PaymentMethod IN ('COD', 'QR')),
    PaymentStatus   BIT            DEFAULT 0, -- 0: Chưa thanh toán, 1: Đã thanh toán
    AccountId       INT            NOT NULL,
    CONSTRAINT FK_Orders_Accounts
        FOREIGN KEY (AccountId) REFERENCES Accounts(AccountId)
        ON DELETE CASCADE
);

-- ============================================
-- BẢNG 5: OrderDetails (Chi tiết đơn hàng)
-- ============================================
CREATE TABLE OrderDetails (
    OrderDetailId INT IDENTITY(1,1) PRIMARY KEY,
    OrderId       INT            NOT NULL,
    FlowerId      INT            NOT NULL,
    Quantity      INT            NOT NULL CHECK (Quantity > 0),
    UnitPrice     DECIMAL(18,2)  NOT NULL CHECK (UnitPrice >= 0),
    CONSTRAINT FK_OrderDetails_Orders
        FOREIGN KEY (OrderId) REFERENCES Orders(OrderId)
        ON DELETE CASCADE,
    CONSTRAINT FK_OrderDetails_Flowers
        FOREIGN KEY (FlowerId) REFERENCES Flowers(FlowerId)
);
GO

-- ============================================
-- DỮ LIỆU MẪU
-- ============================================

-- Danh mục hoa
INSERT INTO Categories (CategoryName, Description) VALUES
(N'Hoa cưới',       N'Hoa trang trí và hoa cầm tay dành cho lễ cưới'),
(N'Hoa sinh nhật',  N'Bó hoa và giỏ hoa chúc mừng sinh nhật'),
(N'Hoa khai trương', N'Hoa chúc mừng khai trương, khánh thành'),
(N'Hoa chia buồn',  N'Vòng hoa, lẵng hoa chia buồn, tang lễ'),
(N'Hoa trang trí',  N'Hoa cắm bàn, hoa trang trí nội thất');

-- Sản phẩm hoa
INSERT INTO Flowers (FlowerName, Unit, Price, Quantity, Image, Description, CategoryId) VALUES
(N'Bó hồng đỏ 20 bông',     N'Bó',    350000,  50, 'rose_red.jpg',     N'Bó hoa hồng đỏ 20 bông kèm baby trắng',   2),
(N'Giỏ hoa hướng dương',     N'Giỏ',   280000,  35, 'sunflower.jpg',    N'Giỏ hoa hướng dương tươi sáng',             2),
(N'Bó hoa cưới cầm tay',     N'Bó',    500000,  20, 'bridal.jpg',       N'Bó hoa cưới cầm tay phong cách châu Âu',   1),
(N'Lẵng hoa khai trương',    N'Lẵng',  800000,  15, 'grand_open.jpg',   N'Lẵng hoa khai trương 2 tầng',               3),
(N'Bó hoa ly trắng',         N'Bó',    420000,  30, 'white_lily.jpg',   N'Bó hoa ly trắng thanh lịch 10 cành',        5),
(N'Hoa cúc vàng chia buồn',  N'Vòng',  200000,  40, 'chrysanthemum.jpg', N'Vòng hoa cúc vàng chia buồn',              4),
(N'Bó hoa tulip hỗn hợp',    N'Bó',    600000,  25, 'tulip_mix.jpg',    N'Bó tulip hỗn hợp nhập khẩu Hà Lan',        5),
(N'Hoa cưới pastel',         N'Bó',    650000,  18, 'pastel_bridal.jpg', N'Bó hoa cưới tông màu pastel nhẹ nhàng',    1),
(N'Giỏ hoa chúc mừng',       N'Giỏ',   350000,  28, 'congrats.jpg',     N'Giỏ hoa hỗn hợp chúc mừng',                3),
(N'Bó hoa lan hồ điệp',      N'Bó',    750000,  12, 'orchid.jpg',       N'Bó lan hồ điệp nhập khẩu cao cấp',         5),
(N'Hoa hồng lẻ (1 bông)',    N'Bông',  20000,   100, 'single_rose.jpg', N'Hoa hồng đỏ bán lẻ theo từng bông',         2),
(N'Nhành lan hồ điệp',       N'Nhành', 150000,  50, 'single_orchid.jpg', N'Lan hồ điệp cắt cành lẻ, đa dạng màu sắc',  5),
(N'Hoa cẩm chướng',          N'Bông',  15000,   80, 'carnation.jpg',    N'Cẩm chướng đơn bông nhiều màu',             5),
(N'Giỏ hoa sen trắng',       N'Giỏ',   450000,  20, 'lotus.jpg',        N'Giỏ hoa sen trắng tinh khiết',              5),
(N'Bó hoa cẩm tú cầu',       N'Bó',    550000,  15, 'hydrangea.jpg',    N'Bó cẩm tú cầu xanh biển',                   2),
(N'Hoa đồng tiền đỏ',        N'Lẵng',  320000,  25, 'gerbera.jpg',      N'Lẵng hoa đồng tiền chúc mừng',              3),
(N'Chậu lan hồ điệp',        N'Chậu', 1200000,  10, 'orchid_pot.jpg',   N'Chậu lan hồ điệp 3 cành loại A',            5),
(N'Bó hoa baby trắng',       N'Bó',    250000,  40, 'baby_breath.jpg',  N'Bó hoa baby trắng bọc giấy kraft',          2);

-- Tài khoản (mật khẩu mẫu: "123456" đã băm SHA-256)
INSERT INTO Accounts (Username, Password, FullName, Email, Phone, Role) VALUES
('admin',    '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92',
    N'Nguyễn Quản Trị',   'admin@flowershop.vn',    '0901000001', 'admin'),
('staff1',   '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92',
    N'Trần Nhân Viên',    'nv1@flowershop.vn',      '0901000002', 'employee'),
('customer1','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92',
    N'Lê Khách Hàng',     'kh1@gmail.com',          '0901000003', 'customer'),
('customer2','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92',
    N'Phạm Minh Anh',     'minhanh@gmail.com',      '0901000004', 'customer'),
('customer3','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92',
    N'Hoàng Gia Bảo',     'giabao@gmail.com',       '0901000005', 'customer'),
('customer4','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92',
    N'Vũ Thanh Thảo',     'thanhthao@gmail.com',    '0901000006', 'customer'),
('customer5','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92',
    N'Đặng Hoàng Long',   'hoanglong@gmail.com',    '0901000007', 'customer');

-- Đơn hàng mẫu
INSERT INTO Orders (TotalAmount, ReceiverName, ReceiverAddress, ReceiverPhone, Status, PaymentMethod, PaymentStatus, AccountId) VALUES
(700000,  N'Nguyễn Văn A', N'123 Nguyễn Huệ, Q.1, TP.HCM',   '0909111222', N'Đã giao', 'COD', 1, 3),
(800000,  N'Trần Thị B',   N'456 Lê Lợi, Q.3, TP.HCM',       '0909333444', N'Đang giao', 'QR', 1, 3),
(350000,  N'Phạm Văn C',   N'789 Hai Bà Trưng, Q.1, TP.HCM',  '0909555666', N'Chờ xử lý', 'QR', 0, 4),
(1200000, N'Hoàng Gia Bảo',N'101 Hoàng Sa, Q.3, TP.HCM',     '0901000005', N'Đã giao',   'COD', 1, 5),
(550000,  N'Vũ Thanh Thảo',N'202 Trường Sa, Q.Phú Nhuận, TP.HCM','0901000006', N'Đang giao', 'QR', 1, 6),
(900000,  N'Đặng Hoàng Long',N'303 Cách Mạng Tháng 8, Q.10, TP.HCM','0901000007', N'Đã hủy', 'COD', 0, 7),
(700000,  N'Trần Minh Đức',N'404 Võ Văn Tần, Q.3, TP.HCM',   '0909999888', N'Chờ xử lý', 'QR', 0, 3),
(450000,  N'Lê Khách Hàng',N'505 Điện Biên Phủ, Q.Bình Thạnh, TP.HCM','0901000003', N'Đã giao', 'COD', 1, 3);

-- Chi tiết đơn hàng
INSERT INTO OrderDetails (OrderId, FlowerId, Quantity, UnitPrice) VALUES
(1, 1, 2, 350000),    -- Đơn 1: 2 bó hồng đỏ
(2, 4, 1, 800000),    -- Đơn 2: 1 lẵng hoa khai trương
(3, 2, 1, 280000),    -- Đơn 3: 1 giỏ hoa hướng dương
(3, 6, 1, 200000),    -- Đơn 3: thêm 1 hoa cúc chia buồn
(4, 17, 1, 1200000),  -- Đơn 4: 1 chậu lan hồ điệp (Id = 17)
(5, 15, 1, 550000),   -- Đơn 5: 1 bó hoa cẩm tú cầu (Id = 15)
(6, 14, 2, 450000),   -- Đơn 6: 2 giỏ hoa sen trắng (Id = 14) -> 900000
(7, 1, 2, 350000),    -- Đơn 7: 2 bó hồng đỏ (Id = 1) -> 700000
(8, 14, 1, 450000);   -- Đơn 8: 1 giỏ hoa sen trắng (Id = 14) -> 450000
GO
