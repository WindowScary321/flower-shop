import os
import re
import sys
import urllib.parse
import requests
from bs4 import BeautifulSoup

if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')

HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
}

CATEGORIES = [
    {"name": "Hoa khai trương", "url": "https://www.flowercorner.vn/hoa-khai-truong"},
    {"name": "Hoa Chúc Mừng", "url": "https://www.flowercorner.vn/hoa-chuc-mung"},
    {"name": "Hoa cưới", "url": "https://www.flowercorner.vn/hoa-cuoi-cam-tay"},
    {"name": "Hoa Valentine", "url": "https://www.flowercorner.vn/hoa-valentine"},
    {"name": "Hoa Kỷ Niệm Ngày Cưới", "url": "https://www.flowercorner.vn/hoa-ky-niem-ngay-cuoi"},
    {"name": "Hoa 8/3", "url": "https://www.flowercorner.vn/hoa-chuc-mung-8-3"},
    {"name": "Hoa 20/10", "url": "https://www.flowercorner.vn/hoa-chuc-mung-20-10"},
    {"name": "Hoa 20/11", "url": "https://www.flowercorner.vn/hoa-chuc-mung-ngay-nha-giao-viet-nam-20-11"}
]

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DB_SQL_PATH = os.path.join(PROJECT_ROOT, "database", "FlowerShopDB.sql")
NEW_SQL_PATH = os.path.join(PROJECT_ROOT, "database", "InsertMoreFlowers.sql")

def get_existing_flowers():
    existing = set()
    if not os.path.exists(DB_SQL_PATH):
        print("Không tìm thấy FlowerShopDB.sql")
        return existing
    
    with open(DB_SQL_PATH, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Tìm các chuỗi kiểu (N'Tên hoa', N'Bó', ... hoặc (N'Tên hoa', N'Cây', ...
    matches = re.findall(r"\(N'(.*?)',\s*N'(?:Bó|Cây)'", content)
    for m in matches:
        existing.add(m.strip().lower())
        
    return existing

def clean_url(url):
    try:
        parts = urllib.parse.urlsplit(url)
        unquoted_path = urllib.parse.unquote(parts.path)
        encoded_path = urllib.parse.quote(unquoted_path)
        return urllib.parse.urlunsplit((parts.scheme, parts.netloc, encoded_path, parts.query, parts.fragment))
    except Exception as e:
        return url

def clean_price(price_str):
    price_digits = re.sub(r'\D', '', price_str)
    return int(price_digits) if price_digits else 0

def get_product_description(detail_url):
    try:
        r = requests.get(detail_url, headers=HEADERS, timeout=10)
        if r.status_code == 200:
            soup = BeautifulSoup(r.text, 'html.parser')
            # 1. Ưu tiên lấy inner HTML từ #tab-description để giữ nguyên các thẻ bold (strong), danh sách (ul, li)
            tab_desc = soup.find(id='tab-description')
            if tab_desc:
                desc_html = tab_desc.decode_contents().strip()
                if desc_html:
                    return desc_html
            
            # 2. Fallback sang thẻ meta
            meta_desc = soup.find('meta', attrs={'name': 'description'})
            if meta_desc and meta_desc.get('content'):
                return meta_desc.get('content').strip()
            
            meta_og_desc = soup.find('meta', attrs={'property': 'og:description'})
            if meta_og_desc and meta_og_desc.get('content'):
                return meta_og_desc.get('content').strip()
    except Exception as e:
        pass
    return ""

def scrape_category(category):
    print(f"\nBắt đầu cào danh mục: {category['name']}")
    products = []
    
    try:
        r = requests.get(category['url'], headers=HEADERS, timeout=15)
        if r.status_code != 200:
            print(f"Không thể truy cập. Status: {r.status_code}")
            return products
        
        soup = BeautifulSoup(r.text, 'html.parser')
        thumbs = soup.select('.product-thumb')
        if not thumbs:
            thumbs = soup.select('[class*="product-thumb"]')
            
        print(f"Tìm thấy {len(thumbs)} sản phẩm ở trang đầu. Tiến hành lấy 10 sản phẩm...")
        
        for thumb in thumbs[:10]:
            try:
                title_elem = thumb.select_one('.product-item-title') or thumb.select_one('h3 a')
                if not title_elem:
                    continue
                name = title_elem.text.strip()
                
                detail_link = title_elem.get('href')
                if detail_link and not detail_link.startswith('http'):
                    detail_link = urllib.parse.urljoin("https://www.flowercorner.vn", detail_link)
                
                price_new_elem = thumb.select_one('.price-new')
                price_str = price_new_elem.text.strip() if price_new_elem else ""
                price = clean_price(price_str)
                if price == 0:
                    price_elem = thumb.select_one('.price')
                    if price_elem:
                        price = clean_price(price_elem.text.strip())
                
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
                
                img_elem = thumb.select_one('.image img')
                img_url = ""
                if img_elem:
                    img_url = img_elem.get('data-src') or img_elem.get('src') or ""
                if img_url and not img_url.startswith('http'):
                    img_url = urllib.parse.urljoin("https://www.flowercorner.vn", img_url)
                if img_url:
                    img_url = clean_url(img_url)
                
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
                    "category": category['name']
                })
                print(f" - {name} (Giá: {price})")
                
            except Exception as inner_e:
                pass
                
    except Exception as e:
        print(f"Lỗi khi tải trang: {e}")
        
    return products

def main():
    print("1. Đọc dữ liệu hoa hiện tại từ DB script...")
    existing = get_existing_flowers()
    print(f"Đã tìm thấy {len(existing)} hoa trong DB.")
    
    print("\n2. Bắt đầu scrape dữ liệu mới...")
    all_new_products = []
    skipped = 0
    
    for cat in CATEGORIES:
        products = scrape_category(cat)
        for p in products:
            if p['name'].strip().lower() in existing:
                skipped += 1
            else:
                all_new_products.append(p)
                existing.add(p['name'].strip().lower())
                
    print(f"\n3. So sánh hoàn tất:")
    print(f" - Đã bỏ qua {skipped} sản phẩm (đã tồn tại).")
    print(f" - Số lượng sản phẩm mới: {len(all_new_products)}")
    
    if not all_new_products:
        print("Không có hoa mới để chèn.")
        return
        
    print("\n4. Tạo file InsertMoreFlowers.sql...")
    
    sql_lines = [
        "USE FLOWER_SHOP;",
        "GO",
        "",
        "-- Thêm các danh mục nếu chưa tồn tại"
    ]
    
    for cat in CATEGORIES:
        c_name = cat['name'].replace("'", "''")
        sql_lines.append(
            f"IF NOT EXISTS (SELECT 1 FROM Categories WHERE CategoryName = N'{c_name}')\n"
            f"    INSERT INTO Categories (CategoryName, Description) VALUES (N'{c_name}', N'Danh mục {c_name}');"
        )
        
    sql_lines.append("\nGO\n")
    sql_lines.append("-- Thêm các sản phẩm hoa mới")
    sql_lines.append("INSERT INTO Flowers (FlowerName, Unit, Price, Quantity, Image, Description, CategoryId, Discount) VALUES")
    
    values = []
    for i, p in enumerate(all_new_products):
        safe_name = p['name'].replace("'", "''")
        safe_desc = p['description'].replace("'", "''")
        if len(safe_desc) > 3000:
            safe_desc = safe_desc[:3000] + "..."
            
        c_name = p['category'].replace("'", "''")
        cat_id_subquery = f"(SELECT TOP 1 CategoryId FROM Categories WHERE CategoryName = N'{c_name}')"
        
        row = f"(N'{safe_name}', N'Bó', {p['price']}, 30, '{p['image_url']}', N'{safe_desc}', {cat_id_subquery}, {p['discount']})"
        values.append(row)
        
    sql_lines.append(",\n".join(values) + ";")
    sql_lines.append("GO\n")
    
    try:
        with open(NEW_SQL_PATH, 'w', encoding='utf-8') as f:
            f.write("\n".join(sql_lines))
        print(f"Đã lưu thành công vào {NEW_SQL_PATH}")
    except Exception as e:
        print(f"Lỗi ghi file SQL: {e}")

if __name__ == "__main__":
    main()
