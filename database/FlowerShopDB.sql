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
    Unit        NVARCHAR(50)   DEFAULT N'Cây',
    Price       DECIMAL(18,2)  NOT NULL CHECK (Price >= 0),
    Quantity    INT            NOT NULL CHECK (Quantity >= 0),
    Image       VARCHAR(255)   NULL,
    Description NVARCHAR(MAX)  NULL,
    CategoryId  INT            NULL,
    Discount    INT            DEFAULT 0 CHECK (Discount >= 0 AND Discount <= 100),
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
    Address   NVARCHAR(255)  NULL,
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
    DeliveryTime    DATETIME       NULL,
    AccountId       INT            NOT NULL,
    CONSTRAINT FK_Orders_Accounts
        FOREIGN KEY (AccountId) REFERENCES Accounts(AccountId)
        ON DELETE CASCADE,
    CONSTRAINT CHK_DeliveryTime
        CHECK (Status != N'Đã giao' OR DeliveryTime IS NOT NULL)
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
INSERT INTO Flowers (FlowerName, Unit, Price, Quantity, Image, Description, CategoryId, Discount) VALUES
(N'Hoa cưới Elysian Rose Garden', N'Bó', 970000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/hoa-cuoi-elysianrose-garden.jpg.webp', N'Bó hoa tươi Hoa cưới Elysian Rose Garden thiết kế sang trọng ý nghĩa', 1, 0),
(N'Hoa Cưới Together', N'Bó', 1490000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/hoa-cuoi-together.jpg.webp', N'Bó hoa cưới Together được thiết kế theo tone màu đỏ rực rỡ từ các loài hoa mao lương, cẩm chướng và thanh liễu đỏ, những loài hoa mang ý nghĩa may mắn và tình yêu. Bó hoa là lựa chọn hoàn hảo cho cô dâu mặc váy cưới màu trắng.', 1, 0),
(N'Diamond Love', N'Bó', 2190000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/hoa-cuoi-diamond-love.jpg.webp', N'Bó hoa tươi Diamond Love thiết kế sang trọng ý nghĩa', 1, 0),
(N'Beautiful In White', N'Bó', 2390000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/bo-hoa-cuoi-rum-trang.jpg.webp', N'Bó hoa cưới Beautiful In White được thiết kế từ 10 bông calla lily trắng loài hoa tượng trưng cho tình yêu thuần khiết và chân thành. Nếu bạn đang tìm một bó hoa nhập khẩu cho lễ cưới, thì Beautiful In White là gợi ý không thể bỏ qua.', 1, 0),
(N'Whispers Of The Heart', N'Bó', 2490000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/bo-hoa-cuoi-whisper-of-the-heart.jpg.webp', N'Bó hoa cưới Whispers Of The Heart được thiết kế từ 10 bông calla lily trắng loài hoa tượng trưng cho tình yêu thuần khiết và chân thành. Bó hoa được trang trí thêm bằng hoa sao xanh tạo thêm điểm nhấn.', 1, 0),
(N'Ngày Hạnh Phúc', N'Bó', 2390000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/hoa-cuoi-ngay-hanh-phuc-26.jpg.webp', N'Bó hoa tươi Ngày Hạnh Phúc thiết kế sang trọng ý nghĩa', 1, 0),
(N'Hoa Cưới Thanh Khiết', N'Bó', 850000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/hoa-cuoi-thanh-khiet.jpg.webp', N'Bó hoa tươi Hoa Cưới Thanh Khiết thiết kế sang trọng ý nghĩa', 1, 0),
(N'Hoa Cầm Tay Sao Xanh', N'Bó', 1100000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/bo-hoa-cuoi-sao-xanh.jpg.webp', N'Bó hoa cưới Sao Xanh được thiết kế từ hoa sao xanh mang thông điệp hy vọng về một cuộc hôn nhân hạnh phúc viên mãn và tràn ngập niềm vui, hạnh phúc.', 1, 20),
(N'Heart To Heart', N'Bó', 2370000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/hoa-cuoi-tulip-heart-to-heart.jpg.webp', N'Bó hoa cưới Heart To Heart được thiết kế từ hoa Tulip hồng nhập khẩu từ Hà Lan. Bó hoa sẽ là sự kết hợp hoàn hảo với những mẫu váy cưới màu trắng.', 1, 0),
(N'Hoa Cưới Happy Ending', N'Bó', 2370000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/hoa-cuoi-tulip-happy-ending.jpg.webp', N'Bó hoa tươi Hoa Cưới Happy Ending thiết kế sang trọng ý nghĩa', 1, 0),
(N'Phút Yêu Đầu', N'Bó', 580000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/hoa-cuoi-cam-tay-phut-yeu-dau.jpg.webp', N'Bó hoa cưới cầm tay Phút Yêu Đầu được thiết kế với tone màu trắng tinh khôi từ hoa cát tường, hồng trắng và baby trắng. Bó hoa là sự lựa chọn hoàn hảo nếu bạn đang tìm một mẫu hoa cưới giá rẻ cho lễ cưới của mình.', 1, 0),
(N'Ngày Hạnh Phúc Nhất', N'Bó', 670000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/bo-hoa-cuoi-ngay-hanh-phuc-nhat.jpg.webp', N'Bó hoa tươi Ngày Hạnh Phúc Nhất thiết kế sang trọng ý nghĩa', 1, 0),
(N'Cầu Vồng Ngọt Ngào', N'Bó', 1570000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/hop-hoa-baby-cau-vong-ngot-ngao.jpg.webp', N'Cầu Vồng Ngọt Ngào', 2, 0),
(N'Bó Tú Cầu Xanh Bơ', N'Bó', 720000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/bo-hoa-cam-tu-cau-xanh-bo.jpg.webp', N'Bó hoa tươi Bó Tú Cầu Xanh Bơ thiết kế sang trọng ý nghĩa', 2, 0),
(N'Tươi Sắc Màu', N'Bó', 1060000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/tuoi-sac-mau.jpg.webp', N'Bó hoa tươi Tươi Sắc Màu thiết kế sang trọng ý nghĩa', 2, 16),
(N'Spring Time', N'Bó', 860000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/bo-hoa-cam-tu-cau-spring-time.jpg.webp', N'Bó hoa tươi Spring Time thiết kế sang trọng ý nghĩa', 2, 19),
(N'Lời Hứa', N'Bó', 950000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/Autumn_2024/loi-hua.jpg.webp', N'Bó hoa tươi Lời Hứa thiết kế sang trọng ý nghĩa', 2, 0),
(N'Just Love', N'Bó', 450000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/bo-hoa-cam-tu-cau-just-love.jpg.webp', N'Bó hoa tươi Just Love thiết kế sang trọng ý nghĩa', 2, 8),
(N'Hoa Lam Tinh', N'Bó', 690000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/hoa-lam-tinh.jpg.webp', N'Bó hoa tươi Hoa Lam Tinh thiết kế sang trọng ý nghĩa', 2, 0),
(N'Mẫu Đơn Hồng', N'Bó', 1890000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/mau-don-cho-em-26.jpg.webp', N'Bó hoa tươi Mẫu Đơn Hồng thiết kế sang trọng ý nghĩa', 2, 18),
(N'For you', N'Bó', 2950000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/bo-hoa-mau-don-for-you-26.jpg.webp', N'Bó hoa tươi For you thiết kế sang trọng ý nghĩa', 2, 0),
(N'Forever Young', N'Bó', 810000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/forever-young-26.jpg.webp', N'Bó hoa tươi Forever Young thiết kế sang trọng ý nghĩa', 2, 0),
(N'Tình Yêu Màu Xanh', N'Bó', 2510000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/tinh-yeu-mau-xanh-26.jpg.webp', N'Bó hoa tươi Tình Yêu Màu Xanh thiết kế sang trọng ý nghĩa', 2, 0),
(N'First Date', N'Bó', 520000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/bo-hoa-baby-hong-first-date-26.jpg.webp', N'Bó hoa tươi First Date thiết kế sang trọng ý nghĩa', 2, 10),
(N'Đơm Hoa Kết Trái', N'Bó', 2980000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/Hoa%20Khai%20Tr%C6%B0%C6%A1ng/dom-hoa-ket-trai.jpg.webp', N'Bó hoa tươi Đơm Hoa Kết Trái thiết kế sang trọng ý nghĩa', 3, 0),
(N'Kệ Hoa Khai Trương Hưng Thịnh', N'Bó', 3250000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/hoa-khai-truong-hung-thinh-26.jpg.webp', N'Mẫu Kệ Hoa Khai Trương Hưng Thịnh mang một lời chúc đầy ý nghĩa và to lớn: “ Chúc quý công ty luôn phát đạt và thịnh vượng”, chiếc kệ này sẽ là một sự lựa chọn đúng đắn và sáng suốt để dành tặng cho những đối tác quan trọng của mình. Không những thế sắc đ', 3, 0),
(N'Giỏ Hoa Vũ Điệu Sắc Màu', N'Bó', 860000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/lang-hoa-dong-tien-vu-dieu-sac-mau.jpg.webp', N'Bó hoa tươi Giỏ Hoa Vũ Điệu Sắc Màu thiết kế sang trọng ý nghĩa', 3, 0),
(N'May Mắn', N'Bó', 550000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/gio-hoa-may-man.jpg.webp', N'Bó hoa tươi May Mắn thiết kế sang trọng ý nghĩa', 3, 7),
(N'Kệ Hoa Khai Trương Vững tiến', N'Bó', 2890000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/Hoa%20Khai%20Tr%C6%B0%C6%A1ng/hoa-khai-truong-vung-tien-n.jpg.webp', N'Bó hoa tươi Kệ Hoa Khai Trương Vững tiến thiết kế sang trọng ý nghĩa', 3, 5),
(N'Đại Phúc Khải Nguyên', N'Bó', 2880000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/dai-khuc-dai-nguyen.jpg.webp', N'Bó hoa tươi Đại Phúc Khải Nguyên thiết kế sang trọng ý nghĩa', 3, 0),
(N'Công Thành Danh Toại', N'Bó', 2350000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/hoa-khai-truong-cong-thanh-danh-toai.jpg.webp', N'Bó hoa tươi Công Thành Danh Toại thiết kế sang trọng ý nghĩa', 3, 9),
(N'Khúc Ca Chiến Thắng', N'Bó', 1850000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/Hoa%20Khai%20Tr%C6%B0%C6%A1ng/khuc-ca-chien-thang-2.jpg.webp', N'Bó hoa tươi Khúc Ca Chiến Thắng thiết kế sang trọng ý nghĩa', 3, 10),
(N'Kệ Hoa Chúc Mừng Vững Tin', N'Bó', 1190000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/Hoa%20Khai%20Tr%C6%B0%C6%A1ng/hoa-chuc-mung-vung-tin.jpg.webp', N'Bó hoa tươi Kệ Hoa Chúc Mừng Vững Tin thiết kế sang trọng ý nghĩa', 3, 13),
(N'Kệ Hoa Chúc Mừng Bước Thành Công', N'Bó', 2090000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/hoa-khai-truong-buoc-thanh-cong.jpg.webp', N'Bó hoa tươi Kệ Hoa Chúc Mừng Bước Thành Công thiết kế sang trọng ý nghĩa', 3, 28),
(N'Cheerful Success', N'Bó', 1650000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/APR_2024/cheerful-success.png.webp', N'Bó hoa tươi Cheerful Success thiết kế sang trọng ý nghĩa', 3, 4),
(N'Hoa Chúc Mừng Bước Tiến Vững Chắc', N'Bó', 1850000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/APR_2024/hoa-chuc-mung-buoc-tien-vung-chac-1.jpg.webp', N'Bó hoa tươi Hoa Chúc Mừng Bước Tiến Vững Chắc thiết kế sang trọng ý nghĩa', 3, 27),
(N'Kệ Hoa Chia Buồn Hư Vô', N'Bó', 3490000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/hoa-tang-le-hu-vo.jpg.webp', N'Bó hoa tươi Kệ Hoa Chia Buồn Hư Vô thiết kế sang trọng ý nghĩa', 4, 0),
(N'Hoa Chia Buồn Hồi Ức', N'Bó', 1050000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/Hoa%20Chia%20Bu%E1%BB%93n/hoa-chia-buon-hoi-uc.jpg.webp', N'Bó hoa tươi Hoa Chia Buồn Hồi Ức thiết kế sang trọng ý nghĩa', 4, 0),
(N'Hoa Chia Buồn Cõi Lành', N'Bó', 1600000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/Hoa%20Chia%20Bu%E1%BB%93n/hoa-tang-le-coi-lanh-26.jpg.webp', N'Bó hoa tươi Hoa Chia Buồn Cõi Lành thiết kế sang trọng ý nghĩa', 4, 0),
(N'Hoa Tang Lễ An Nghỉ 2', N'Bó', 970000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/hoa-tang-le-an-nghi.jpg.webp', N'Bó hoa tươi Hoa Tang Lễ An Nghỉ 2 thiết kế sang trọng ý nghĩa', 4, 0),
(N'Hoa Chia Buồn Lặng Yên', N'Bó', 1660000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/Hoa%20Chia%20Bu%E1%BB%93n/vong-hoa-lang-yen.jpg.webp', N'Bó hoa tươi Hoa Chia Buồn Lặng Yên thiết kế sang trọng ý nghĩa', 4, 0),
(N'Lời Giã Từ', N'Bó', 1410000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/Hoa%20Chia%20Bu%E1%BB%93n/loi-gia-tu-v3.jpg.webp', N'Bó hoa tươi Lời Giã Từ thiết kế sang trọng ý nghĩa', 4, 27),
(N'Hoa Chia Buồn Trọn Vẹn', N'Bó', 1450000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/Hoa%20Chia%20Bu%E1%BB%93n/hoa-chia-buon-tron-ven.jpg.webp', N'Bó hoa tươi Hoa Chia Buồn Trọn Vẹn thiết kế sang trọng ý nghĩa', 4, 0),
(N'Hoa Tang Lễ - Chia Xa', N'Bó', 1150000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/vong-hoa-tang-le-chia-xa.jpg.webp', N'Bó hoa tươi Hoa Tang Lễ - Chia Xa thiết kế sang trọng ý nghĩa', 4, 5),
(N'Kệ Hoa Chia Buồn Vĩnh Hằng 2', N'Bó', 6340000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/Hoa%20Chia%20Bu%E1%BB%93n/ke-hoa-chia-buon-3-tang.jpg.webp', N'Bó hoa tươi Kệ Hoa Chia Buồn Vĩnh Hằng 2 thiết kế sang trọng ý nghĩa', 4, 0),
(N'Hoa Chia Buồn Một Kiếp Người', N'Bó', 1860000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/August%202023/hoa-chia-buon-mot-kiep-nguoi.jpg.webp', N'Bó hoa tươi Hoa Chia Buồn Một Kiếp Người thiết kế sang trọng ý nghĩa', 4, 0),
(N'Lời Tạm Biệt', N'Bó', 1140000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/Hoa%20Chia%20Bu%E1%BB%93n/hoa-tang-le-loi-tam-biet.jpg.webp', N'Bó hoa tươi Lời Tạm Biệt thiết kế sang trọng ý nghĩa', 4, 0),
(N'Hoa Chia Buồn Thành kính 2', N'Bó', 2840000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/Hoa%20Chia%20Bu%E1%BB%93n/thanh-kinh-2.jpg.webp', N'Bó hoa tươi Hoa Chia Buồn Thành kính 2 thiết kế sang trọng ý nghĩa', 4, 8),
(N'Tươi Sắc Màu', N'Bó', 1060000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/tuoi-sac-mau.jpg.webp', N'Bó hoa tươi Tươi Sắc Màu thiết kế sang trọng ý nghĩa', 5, 16),
(N'Spring Time', N'Bó', 860000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/bo-hoa-cam-tu-cau-spring-time.jpg.webp', N'Bó hoa tươi Spring Time thiết kế sang trọng ý nghĩa', 5, 19),
(N'Lời Hứa', N'Bó', 950000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/Autumn_2024/loi-hua.jpg.webp', N'Bó hoa tươi Lời Hứa thiết kế sang trọng ý nghĩa', 5, 0),
(N'Just Love', N'Bó', 450000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/bo-hoa-cam-tu-cau-just-love.jpg.webp', N'Bó hoa tươi Just Love thiết kế sang trọng ý nghĩa', 5, 8),
(N'Hoa Lam Tinh', N'Bó', 690000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/hoa-lam-tinh.jpg.webp', N'Bó hoa tươi Hoa Lam Tinh thiết kế sang trọng ý nghĩa', 5, 0),
(N'For you', N'Bó', 2950000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/bo-hoa-mau-don-for-you-26.jpg.webp', N'Bó hoa tươi For you thiết kế sang trọng ý nghĩa', 5, 0),
(N'Forever Young', N'Bó', 810000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/forever-young-26.jpg.webp', N'Bó hoa tươi Forever Young thiết kế sang trọng ý nghĩa', 5, 0),
(N'Tình Yêu Màu Xanh', N'Bó', 2510000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/tinh-yeu-mau-xanh-26.jpg.webp', N'Bó hoa tươi Tình Yêu Màu Xanh thiết kế sang trọng ý nghĩa', 5, 0),
(N'First Date', N'Bó', 520000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/bo-hoa-baby-hong-first-date-26.jpg.webp', N'Bó hoa tươi First Date thiết kế sang trọng ý nghĩa', 5, 10),
(N'Niềm Vui Tràn Đầy', N'Bó', 880000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/niem-vui-tran-day-26.jpg.webp', N'Bó hoa tươi Niềm Vui Tràn Đầy thiết kế sang trọng ý nghĩa', 5, 0),
(N'Chớm Nở', N'Bó', 390000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/chom-no-26.jpg.webp', N'Bó hoa tươi Chớm Nở thiết kế sang trọng ý nghĩa', 5, 5),
(N'Lời Nhắn', N'Bó', 360000, 30, 'https://flowercorner.b-cdn.net/image/cache/catalog/products/B%C3%B3%20Hoa/bo-hoa-dong-tien-loi-nhan.jpg.webp', N'Bó hoa tươi Lời Nhắn thiết kế sang trọng ý nghĩa', 5, 8);

-- Tài khoản (mật khẩu mẫu của customer1-5: "123456" đã băm SHA-256)
-- Tài khoản admin và staff1 đã được đổi hash để tăng tính bảo mật
INSERT INTO Accounts (Username, Password, FullName, Email, Phone, Role) VALUES
('admin',    'c3a2591c22ef2e0dec9bede5681a7671eba91ae82dfa8bb96a0d6b7901590c64', 
    N'Nguyễn Quản Trị',   'admin-flowershop@thenoob.eu.org',    '0901000001', 'admin'),
('staff1',   'fad240b23b16e79d14e91fdbb2b481d3a3c4900e58c9482e2f2d90a673ed245f',
    N'Trần Nhân Viên',    'staff1@thenoob.eu.org',      '0901000002', 'employee'),
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
INSERT INTO Orders (TotalAmount, ReceiverName, ReceiverAddress, ReceiverPhone, Status, PaymentMethod, PaymentStatus, DeliveryTime, AccountId) VALUES
(2980000, N'Nguyễn Văn A', N'123 Nguyễn Huệ, Q.1, TP.HCM', '0909111222', N'Đã giao', 'COD', 1, '2026-07-21 14:30:00', 3),
(1060000, N'Trần Thị B', N'456 Lê Lợi, Q.3, TP.HCM', '0909333444', N'Đang giao', 'QR', 1, '2026-07-20 09:00:00', 3),
(1150000, N'Phạm Văn C', N'789 Hai Bà Trưng, Q.1, TP.HCM', '0909555666', N'Chờ xử lý', 'QR', 0, NULL, 4),
(3680000, N'Hoàng Gia Bảo', N'101 Hoàng Sa, Q.3, TP.HCM', '0901000005', N'Đã giao', 'COD', 1, '2026-07-18 10:15:00', 5),
(1190000, N'Vũ Thanh Thảo', N'202 Trường Sa, Q.Phú Nhuận, TP.HCM', '0901000006', N'Đang giao', 'QR', 1, '2026-07-22 15:00:00', 6),
(3720000, N'Đặng Hoàng Long', N'303 Cách Mạng Tháng 8, Q.10, TP.HCM', '0901000007', N'Đã hủy', 'COD', 0, NULL, 7),
(5780000, N'Trần Minh Đức', N'404 Võ Văn Tần, Q.3, TP.HCM', '0909999888', N'Chờ xử lý', 'QR', 0, NULL, 3),
(1060000, N'Lê Khách Hàng', N'505 Điện Biên Phủ, Q.Bình Thạnh, TP.HCM', '0901000003', N'Đã giao', 'COD', 1, '2026-07-17 08:30:00', 3);

-- Chi tiết đơn hàng
INSERT INTO OrderDetails (OrderId, FlowerId, Quantity, UnitPrice) VALUES
(1, 2, 2, 1490000),
(2, 15, 1, 1060000),
(3, 44, 1, 1150000),
(4, 3, 1, 2190000),
(4, 2, 1, 1490000),
(5, 33, 1, 1190000),
(6, 46, 2, 1860000),
(7, 29, 2, 2890000),
(8, 49, 1, 1060000);
GO

-- ============================================
-- BẢNG 6: ActivityLogs (Nhật ký hoạt động)
-- ============================================
CREATE TABLE ActivityLogs (
    LogId        INT IDENTITY(1,1) PRIMARY KEY,
    AccountId    INT           NULL,
    Username     NVARCHAR(50)  NULL,
    ActionType   VARCHAR(50)   NOT NULL,
    Description  NVARCHAR(500) NOT NULL,
    IpAddress    VARCHAR(45)   NULL,
    CreatedAt    DATETIME      DEFAULT GETDATE(),
    CONSTRAINT FK_ActivityLogs_Accounts
        FOREIGN KEY (AccountId) REFERENCES Accounts(AccountId)
        ON DELETE SET NULL
);
GO

-- Log mẫu
INSERT INTO ActivityLogs (AccountId, Username, ActionType, Description, IpAddress, CreatedAt) VALUES
(1, 'admin', 'LOGIN_SUCCESS', N'Đăng nhập thành công với vai trò admin', '127.0.0.1', '2026-07-21 08:00:00'),
(2, 'employee', 'ORDER_STATUS_UPDATE', N'Cập nhật trạng thái đơn hàng #1 từ Chờ xử lý sang Đang giao', '127.0.0.1', '2026-07-21 08:15:00'),
(3, 'customer', 'ADD_TO_CART', N'Thêm sản phẩm Bó hoa Hồng Dâu (x2) vào giỏ hàng', '192.168.1.100', '2026-07-21 09:30:00'),
(3, 'customer', 'CHECKOUT', N'Thanh toán thành công đơn hàng #10 (Tổng tiền: 2,980,000 đ) qua COD', '192.168.1.100', '2026-07-21 09:45:00'),
(NULL, 'admin', 'LOGIN_FAILED', N'Đăng nhập thất bại do sai mật khẩu', '192.168.1.50', '2026-07-21 10:00:00'),
(1, 'admin', 'FLOWER_CREATE', N'Thêm sản phẩm mới: Hoa hồng xanh', '127.0.0.1', '2026-07-21 10:15:00'),
(3, 'customer', 'ORDER_CANCEL', N'Hủy đơn hàng #3', '192.168.1.100', '2026-07-21 11:00:00');
GO
