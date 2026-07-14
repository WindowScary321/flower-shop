<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/common/header.jsp" />

<div class="row justify-content-center mt-5 mb-5">
    <div class="col-md-6 text-center">
        <div class="card border-0 shadow-sm p-5">
            <div class="mb-4">
                <div class="rounded-circle bg-success d-inline-flex align-items-center justify-content-center mb-3" style="width:90px;height:90px;">
                    <i class="bi bi-check-lg text-white" style="font-size:3rem;"></i>
                </div>
            </div>
            <h2 class="fw-bold text-success mb-2">Đặt hàng thành công!</h2>
            <p class="text-muted mb-1">Mã đơn hàng của bạn:</p>
            <h3 class="text-primary fw-bold mb-3">#${orderId}</h3>
            <p class="text-muted mb-4">
                Cảm ơn bạn đã đặt hàng tại Flower Shop. Chúng tôi sẽ xử lý và giao hàng đến bạn trong thời gian sớm nhất.
            </p>
            <div class="d-flex gap-3 justify-content-center flex-wrap">
                <a href="${pageContext.request.contextPath}/customer/order-history" class="btn btn-primary rounded-pill px-4">
                    <i class="bi bi-receipt me-1"></i> Xem lịch sử đơn hàng
                </a>
                <a href="${pageContext.request.contextPath}/flower-catalog" class="btn btn-outline-secondary rounded-pill px-4">
                    <i class="bi bi-shop me-1"></i> Tiếp tục mua sắm
                </a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/common/footer.jsp" />
