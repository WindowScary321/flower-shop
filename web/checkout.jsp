<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/common/header.jsp" />

<div class="row justify-content-center mt-4 mb-5">
    <div class="col-lg-8">
        <h2 class="text-primary fw-bold mb-4"><i class="bi bi-credit-card me-2"></i>Thông Tin Đặt Hàng</h2>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger mb-3"><i class="bi bi-exclamation-triangle-fill me-2"></i>${error}</div>
        </c:if>
        
        <div class="row">
            <!-- Receiver Info Form -->
            <div class="col-md-7">
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-header bg-primary text-white fw-bold">
                        <i class="bi bi-person-lines-fill me-2"></i>Thông tin người nhận hàng
                    </div>
                    <div class="card-body">
                        <form id="checkout-form" action="${pageContext.request.contextPath}/checkout" method="POST">
                            <div class="mb-3">
                                <label class="form-label">Tên người nhận <span class="text-danger">*</span></label>
                                <input type="text" name="receiverName" class="form-control" required
                                       value="${not empty sessionScope.user ? sessionScope.user.fullName : ''}">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                                <input type="text" name="receiverPhone" class="form-control" required
                                       value="${not empty sessionScope.user ? sessionScope.user.phone : ''}"
                                       placeholder="0912345678">
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Địa chỉ giao hàng <span class="text-danger">*</span></label>
                                <textarea name="receiverAddress" class="form-control" rows="3" required
                                          placeholder="Số nhà, tên đường, phường/xã, quận/huyện, tỉnh/thành..."></textarea>
                            </div>
                            
                            <hr class="my-4">
                            
                            <h5 class="fw-bold mb-3"><i class="bi bi-wallet2 me-2"></i>Phương thức thanh toán</h5>
                            <div class="mb-3">
                                <div class="form-check mb-2">
                                    <input class="form-check-input" type="radio" name="paymentMethod" id="paymentCOD" value="COD" checked>
                                    <label class="form-check-label" for="paymentCOD">
                                        Thanh toán khi nhận hàng (COD)
                                    </label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="paymentMethod" id="paymentQR" value="QR">
                                    <label class="form-check-label" for="paymentQR">
                                        Chuyển khoản qua mã QR
                                    </label>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            
            <!-- Order Summary -->
            <div class="col-md-5">
                <div class="card border-0 shadow-sm mb-4">
                    <div class="card-header bg-light fw-bold">
                        <i class="bi bi-receipt me-2"></i>Tóm tắt đơn hàng
                    </div>
                    <div class="card-body p-0">
                        <ul class="list-group list-group-flush">
                            <c:set var="total" value="0" />
                            <c:forEach var="item" items="${sessionScope.cart}">
                                <c:set var="total" value="${total + item.totalPrice}" />
                                <li class="list-group-item">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="text-truncate me-2" style="max-width:160px;" title="${item.flower.flowerName}">
                                            ${item.flower.flowerName}
                                        </span>
                                        <span class="text-nowrap text-muted small">${item.quantity} ${item.flower.unit}</span>
                                    </div>
                                    <div class="text-end text-danger fw-bold small">
                                        <fmt:formatNumber value="${item.totalPrice}" pattern="#,###"/> đ
                                    </div>
                                </li>
                            </c:forEach>
                            <li class="list-group-item">
                                <div class="d-flex justify-content-between fw-bold">
                                    <span>Tổng cộng</span>
                                    <span class="text-danger fs-5"><fmt:formatNumber value="${total}" pattern="#,###"/> đ</span>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>
                
                <button type="submit" form="checkout-form" class="btn btn-primary w-100 btn-lg rounded-pill">
                    <i class="bi bi-bag-check-fill me-2"></i> Xác nhận đặt hàng
                </button>
                <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-secondary w-100 mt-2 rounded-pill">
                    <i class="bi bi-arrow-left me-1"></i> Quay lại giỏ hàng
                </a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/common/footer.jsp" />
