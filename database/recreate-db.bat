@echo off
echo ====================================================
echo   KHOI TAO LAI DATABASE FLOWER_SHOP
echo ====================================================
echo.
echo Dang thuc thi script FlowerShopDB.sql...
echo.

sqlcmd -S localhost -U sa -P 123 -C -f 65001 -i "%~dp0FlowerShopDB.sql"

if %errorlevel% neq 0 (
    echo.
    echo [LOI] Co loi xay ra trong qua trinh khoi tao database!
    echo Vui long kiem tra lai dich vu SQL Server va thong tin ket noi [sa/123].
    echo.
    pause
    exit /b %errorlevel%
)

echo.
echo [THANH CONG] Da khoi tao va import du lieu thanh cong!
echo.
pause
