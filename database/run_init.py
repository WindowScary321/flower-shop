# ./database/run_init.py
import pyodbc, time, sys, os

print("Kiểm tra file SQL...")
if not os.path.isfile("/FlowerShopDB.sql"):
    sys.exit("LỖI: /FlowerShopDB.sql không tồn tại hoặc là thư mục!")
print(f"File tồn tại, kích thước: {os.path.getsize('/FlowerShopDB.sql')} bytes")

conn_str = "DRIVER={ODBC Driver 18 for SQL Server};SERVER=sqlserver;UID=sa;PWD=2DS9WDJRYv4pK2WUXu6;Encrypt=no"
for i in range(60):
    try:
        conn = pyodbc.connect(conn_str, autocommit=True)
        print("Kết nối SQL Server thành công")
        break
    except Exception as e:
        print(f"Đang chờ SQL Server... ({i+1}/60): {e}")
        time.sleep(3)
else:
    sys.exit("LỖI: Không kết nối được SQL Server sau 3 phút")

with open("/FlowerShopDB.sql", "r", encoding="utf-8-sig") as f:
    sql = f.read()

cursor = conn.cursor()
for batch in sql.split("\nGO\n"):
    batch = batch.strip()
    if batch:
        cursor.execute(batch)

print("Database FLOWER_SHOP initialized successfully!")