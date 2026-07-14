<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/common/header.jsp" />

<div class="row justify-content-center mt-5 mb-5">
    <div class="col-md-6 text-center">
        <div class="card border-0 shadow-sm p-4 p-md-5">
            <h3 class="fw-bold text-primary mb-4">Thanh toán đơn hàng #${order.orderId}</h3>
            
            <p class="text-muted mb-4">Vui lòng quét mã QR dưới đây hoặc chuyển khoản theo thông tin để hoàn tất đặt hàng.</p>
            
            <div class="bg-light p-4 rounded-3 d-inline-block w-100 mb-4" style="max-width: 350px; margin: 0 auto;">
                <img src="${pageContext.request.contextPath}/resources/qrcode-placeholder.png" alt="Mã QR Thanh Toán" class="img-fluid rounded shadow-sm mb-3">
                
                <div class="text-start">
                    <p class="mb-1"><span class="text-muted small">Ngân hàng:</span> <strong>Vietcombank</strong></p>
                    <p class="mb-1"><span class="text-muted small">Chủ tài khoản:</span> <strong>FLOWER SHOP</strong></p>
                    <p class="mb-1"><span class="text-muted small">Số tài khoản:</span> <strong>0912345678</strong></p>
                    <p class="mb-1"><span class="text-muted small">Số tiền:</span> <strong class="text-danger fs-5"><fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/> đ</strong></p>
                    <p class="mb-0"><span class="text-muted small">Nội dung CK:</span> <strong class="text-primary">THANHTOAN DH ${order.receiverPhone}</strong></p>
                </div>
            </div>
            
            <form action="${pageContext.request.contextPath}/payment-qr" method="POST">
                <input type="hidden" name="action" value="checkPayment">
                <button type="submit" class="btn btn-success btn-lg rounded-pill px-5 shadow-sm">
                    <i class="bi bi-check-circle me-2"></i> Đã chuyển khoản (Kiểm tra thanh toán)
                </button>
            </form>
            
            <div class="mt-3">
                <small class="text-muted">Nhấn nút bên trên để giả lập thanh toán thành công.</small>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/common/footer.jsp" />
