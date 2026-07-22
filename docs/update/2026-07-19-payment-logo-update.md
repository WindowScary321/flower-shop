# Cập nhật: Đổi logo cổng thanh toán trong Footer

- **Thời gian**: 2026-07-19
- **Commit**: `2e5bff7`

## Các thay đổi chính

### Footer (`web/common/footer.jsp`)
- **Xóa** logo các cổng thanh toán quốc tế gốc (Visa, MasterCard, PayPal,...) vốn không phù hợp với thị trường Việt Nam.
- **Thay thế** bằng logo **MoMo** và **VietQR** — hai phương thức thanh toán phổ biến tại Việt Nam.

## Lý do thay đổi

Dự án hướng đến thị trường nội địa Việt Nam. Việc hiển thị logo thanh toán quốc tế gây hiểu nhầm cho người dùng về khả năng thanh toán thực tế của hệ thống. Logo MoMo và VietQR phản ánh chính xác hơn phương thức thanh toán QR mà ứng dụng hỗ trợ.
