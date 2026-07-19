import os
import re
import sys
import urllib.parse
import unicodedata
import random
import requests
from bs4 import BeautifulSoup

# Cấu hình stdout sử dụng utf-8 để tránh lỗi hiển thị tiếng Việt trên Windows
if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')

# Headers giả lập trình duyệt để tránh bị chặn
HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
}

CATEGORIES = [
    {"id": 1, "name": "Hoa cưới", "url": "https://www.flowercorner.vn/hoa-cuoi-cam-tay"},
    {"id": 2, "name": "Hoa sinh nhật", "url": "https://www.flowercorner.vn/hoa-chuc-mung-sinh-nhat"},
    {"id": 3, "name": "Hoa khai trương", "url": "https://www.flowercorner.vn/hoa-khai-truong"},
    {"id": 4, "name": "Hoa chia buồn", "url": "https://www.flowercorner.vn/hoa-tang-le"},
    {"id": 5, "name": "Hoa trang trí", "url": "https://www.flowercorner.vn/bo-hoa"}
]

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SQL_FILE_PATH = os.path.join(PROJECT_ROOT, "database", "FlowerShopDB.sql")

def clean_url(url):
    """
    Chuẩn hoá URL bằng cách mã hoá các ký tự đặc biệt và tiếng Việt có dấu trong path (ví dụ: 'ó' -> '%C3%B3').
    """
    try:
        parts = urllib.parse.urlsplit(url)
        # unquote trước để tránh bị double-encode nếu URL đã chứa một phần mã hoá trước đó
        unquoted_path = urllib.parse.unquote(parts.path)
        # quote lại để đảm bảo mọi khoảng trắng và ký tự Unicode được mã hoá chuẩn ASCII
        encoded_path = urllib.parse.quote(unquoted_path)
        return urllib.parse.urlunsplit((parts.scheme, parts.netloc, encoded_path, parts.query, parts.fragment))
    except Exception as e:
        print(f"Lỗi khi chuẩn hoá URL {url}: {e}")
        return url

def clean_price(price_str):
    """
    Chuyển chuỗi giá thành số nguyên.
    """
    price_digits = re.sub(r'\D', '', price_str)
    return int(price_digits) if price_digits else 0

def get_product_description(detail_url):
    """
    Lấy meta description từ trang chi tiết sản phẩm.
    """
    try:
        r = requests.get(detail_url, headers=HEADERS, timeout=10)
        if r.status_code == 200:
            soup = BeautifulSoup(r.text, 'html.parser')
            meta_desc = soup.find('meta', attrs={'name': 'description'})
            if meta_desc and meta_desc.get('content'):
                return meta_desc.get('content').strip()
            
            meta_og_desc = soup.find('meta', attrs={'property': 'og:description'})
            if meta_og_desc and meta_og_desc.get('content'):
                return meta_og_desc.get('content').strip()
    except Exception as e:
        print(f"Lỗi khi lấy mô tả từ {detail_url}: {e}")
    return ""

def scrape_category(category):
    """
    Cào tối đa 12 sản phẩm từ một danh mục (để đạt tổng cộng > 50 sản phẩm).
    """
    print(f"\nBắt đầu cào danh mục: {category['name']} ({category['url']})")
    products = []
    
    try:
        r = requests.get(category['url'], headers=HEADERS, timeout=15)
        if r.status_code != 200:
            print(f"Không thể truy cập danh mục {category['name']}. Status code: {r.status_code}")
            return products
        
        soup = BeautifulSoup(r.text, 'html.parser')
        thumbs = soup.select('.product-thumb')
        if not thumbs:
            thumbs = soup.select('[class*="product-thumb"]')
            
        print(f"Tìm thấy {len(thumbs)} sản phẩm. Tiến hành lấy tối đa 12 sản phẩm...")
        
        for thumb in thumbs[:12]:
            try:
                # 1. Tên hoa
                title_elem = thumb.select_one('.product-item-title')
                if not title_elem:
                    title_elem = thumb.select_one('h3 a')
                if not title_elem:
                    continue
                name = title_elem.text.strip()
                
                # 2. Link chi tiết
                detail_link = title_elem.get('href')
                if detail_link and not detail_link.startswith('http'):
                    detail_link = urllib.parse.urljoin("https://www.flowercorner.vn", detail_link)
                
                # 3. Giá bán
                price_new_elem = thumb.select_one('.price-new')
                price_str = price_new_elem.text.strip() if price_new_elem else ""
                price = clean_price(price_str)
                if price == 0:
                    price_elem = thumb.select_one('.price')
                    if price_elem:
                        price = clean_price(price_elem.text.strip())
                
                # 4. Tính % giảm giá (Discount)
                discount = 0
                percent_elem = thumb.select_one('.percent-off-rounded')
                if percent_elem:
                    discount_match = re.search(r'(\d+)', percent_elem.text)
                    if discount_match:
                        discount = int(discount_match.group(1))
                else:
                    price_old_elem = thumb.select_one('.price-old')
                    if price_old_elem and price_new_elem:
                        old_price = clean_price(price_old_elem.text.strip())
                        if old_price > price:
                            discount = int(round((old_price - price) / old_price * 100))
                
                # 5. Link ảnh CDN (Đã chuẩn hoá URL để không bị lỗi ký tự Unicode)
                img_elem = thumb.select_one('.image img')
                img_url = ""
                if img_elem:
                    img_url = img_elem.get('data-src') or img_elem.get('src') or ""
                if img_url and not img_url.startswith('http'):
                    img_url = urllib.parse.urljoin("https://www.flowercorner.vn", img_url)
                
                if img_url:
                    img_url = clean_url(img_url)
                
                # 6. Lấy mô tả chi tiết từ trang con
                description = ""
                if detail_link:
                    description = get_product_description(detail_link)
                if not description:
                    description = f"Bó hoa tươi {name} thiết kế sang trọng ý nghĩa"
                
                products.append({
                    "name": name,
                    "price": price,
                    "discount": discount,
                    "image_url": img_url,
                    "description": description,
                    "category_id": category['id']
                })
                print(f" Đã cào: {name} - Giá: {price:,}đ - Giảm: {discount}% - Ảnh: {img_url}")
                
            except Exception as inner_e:
                print(f"Lỗi khi cào sản phẩm lẻ: {inner_e}")
                
    except Exception as e:
        print(f"Lỗi khi tải trang danh mục {category['name']}: {e}")
        
    return products

def generate_orders_and_details(products):
    """
    Sinh ngẫu nhiên dữ liệu đơn hàng và chi tiết đơn hàng dựa trên danh sách sản phẩm mới,
    đảm bảo nhất quán về FlowerId, UnitPrice và TotalAmount.
    """
    customers = [
        {"id": 3, "name": "Nguyễn Văn A", "address": "123 Nguyễn Huệ, Q.1, TP.HCM", "phone": "0909111222"},
        {"id": 3, "name": "Trần Thị B", "address": "456 Lê Lợi, Q.3, TP.HCM", "phone": "0909333444"},
        {"id": 4, "name": "Phạm Văn C", "address": "789 Hai Bà Trưng, Q.1, TP.HCM", "phone": "0909555666"},
        {"id": 5, "name": "Hoàng Gia Bảo", "address": "101 Hoàng Sa, Q.3, TP.HCM", "phone": "0901000005"},
        {"id": 6, "name": "Vũ Thanh Thảo", "address": "202 Trường Sa, Q.Phú Nhuận, TP.HCM", "phone": "0901000006"},
        {"id": 7, "name": "Đặng Hoàng Long", "address": "303 Cách Mạng Tháng 8, Q.10, TP.HCM", "phone": "0901000007"},
        {"id": 3, "name": "Trần Minh Đức", "address": "404 Võ Văn Tần, Q.3, TP.HCM", "phone": "0909999888"},
        {"id": 3, "name": "Lê Khách Hàng", "address": "505 Điện Biên Phủ, Q.Bình Thạnh, TP.HCM", "phone": "0901000003"}
    ]
    
    random.seed(42) # Giữ kết quả cố định khi chạy lại
    order_inserts = []
    detail_inserts = []
    
    for i, customer in enumerate(customers):
        order_id = i + 1
        # Chọn ngẫu nhiên 1 hoặc 2 hoa
        selected_indices = random.sample(range(len(products)), k=random.randint(1, 2))
        
        total_amount = 0
        for idx in selected_indices:
            flower_id = idx + 1
            flower = products[idx]
            qty = random.randint(1, 2)
            unit_price = flower['price']
            total_amount += qty * unit_price
            
            detail_inserts.append(
                f"({order_id}, {flower_id}, {qty}, {unit_price})"
            )
            
        status = "Đã giao" if order_id in [1, 4, 8] else ("Đang giao" if order_id in [2, 5] else ("Đã hủy" if order_id == 6 else "Chờ xử lý"))
        pay_method = "COD" if order_id in [1, 4, 6, 8] else "QR"
        pay_status = 1 if status in ["Đã giao", "Đang giao"] else 0
        deliv_time = "'2026-07-21 14:30:00'" if order_id == 1 else ("'2026-07-20 09:00:00'" if order_id == 2 else ("'2026-07-18 10:15:00'" if order_id == 4 else ("'2026-07-22 15:00:00'" if order_id == 5 else ("'2026-07-17 08:30:00'" if order_id == 8 else "NULL"))))
        
        order_insert = f"({total_amount}, N'{customer['name']}', N'{customer['address']}', '{customer['phone']}', N'{status}', '{pay_method}', {pay_status}, {deliv_time}, {customer['id']})"
        order_inserts.append(order_insert)
        
    return order_inserts, detail_inserts

def main():
    all_products = []
    for cat in CATEGORIES:
        products = scrape_category(cat)
        all_products.extend(products)
        
    if not all_products:
        print("Không cào được sản phẩm nào.")
        return
        
    print(f"\nTổng kết: Cào thành công {len(all_products)} sản phẩm.")
    
    # 1. Tạo SQL INSERT cho sản phẩm hoa
    flower_values = []
    for p in all_products:
        safe_name = p['name'].replace("'", "''")
        safe_desc = p['description'].replace("'", "''")
        db_image_value = p['image_url']
        
        flower_values.append(
            f"(N'{safe_name}', N'Bó', {p['price']}, 30, '{db_image_value}', N'{safe_desc}', {p['category_id']}, {p['discount']})"
        )
    flower_sql = "INSERT INTO Flowers (FlowerName, Unit, Price, Quantity, Image, Description, CategoryId, Discount) VALUES\n" + ",\n".join(flower_values) + ";"

    # 2. Sinh đơn hàng và chi tiết đơn hàng
    order_values, detail_values = generate_orders_and_details(all_products)
    
    order_sql = "INSERT INTO Orders (TotalAmount, ReceiverName, ReceiverAddress, ReceiverPhone, Status, PaymentMethod, PaymentStatus, DeliveryTime, AccountId) VALUES\n" + ",\n".join(order_values) + ";"
    detail_sql = "INSERT INTO OrderDetails (OrderId, FlowerId, Quantity, UnitPrice) VALUES\n" + ",\n".join(detail_values) + ";"
    
    # 3. Tạo toàn bộ nội dung file SQL hoàn chỉnh (chứa định nghĩa bảng tĩnh và dữ liệu mẫu mới)
    sql_content = f"""USE master;
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
{flower_sql}

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
{order_sql}

-- Chi tiết đơn hàng
{detail_sql}
GO
"""

    # 4. Ghi đè vào file SQL
    try:
        with open(SQL_FILE_PATH, 'w', encoding='utf-8') as f:
            f.write(sql_content)
        print(f"Đã cập nhật file SQL thành công tại {SQL_FILE_PATH}")
    except Exception as e:
        print(f"Lỗi khi ghi file SQL: {e}")

if __name__ == "__main__":
    main()
