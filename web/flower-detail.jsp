<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/common/header.jsp" />

<div class="row mt-4 mb-5">
    <div class="col-md-5 mb-4 mb-md-0">
        <div class="position-relative">
            <c:set var="imgUrl" value="${pageContext.request.contextPath}/images/flowers/${empty flower.image ? 'placeholder.jpg' : flower.image}" />
            <c:if test="${not empty flower.image and (flower.image.startsWith('http://') or flower.image.startsWith('https://'))}">
                <c:set var="imgUrl" value="${flower.image}" />
            </c:if>
            <img src="${imgUrl}"
                 class="img-fluid rounded-3 shadow w-100" alt="${flower.flowerName}"
                 style="max-height: 420px; object-fit: cover;"
                 onerror="this.src='https://placehold.co/600x500/f8f9fa/ff6b81?text=Flower'">
            <span class="position-absolute top-0 end-0 badge bg-danger m-3 fs-6 px-3 py-2">${flower.unit}</span>
            <c:if test="${flower.discount > 0}">
                <span class="position-absolute top-0 start-0 badge bg-warning text-dark m-3 fs-5 px-3 py-2 shadow">-${flower.discount}%</span>
            </c:if>
        </div>
    </div>
    
    <div class="col-md-7">
        <nav aria-label="breadcrumb" class="mb-3">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/flower-catalog">Sản phẩm</a></li>
                <li class="breadcrumb-item active">${flower.flowerName}</li>
            </ol>
        </nav>
        
        <h1 class="fw-bold text-dark mb-2">${flower.flowerName}</h1>
        <p class="text-muted mb-3"><i class="bi bi-tag"></i> Đơn vị bán: <strong>${flower.unit}</strong></p>
        
        <div class="mb-3">
            <c:choose>
                <c:when test="${flower.discount > 0}">
                    <span class="fs-4 text-muted text-decoration-line-through me-3"><fmt:formatNumber value="${flower.price}" pattern="#,###"/> đ</span>
                    <span class="display-6 fw-bold text-danger"><fmt:formatNumber value="${flower.finalPrice}" pattern="#,###"/> đ / ${flower.unit}</span>
                </c:when>
                <c:otherwise>
                    <span class="display-6 fw-bold text-danger"><fmt:formatNumber value="${flower.price}" pattern="#,###"/> đ / ${flower.unit}</span>
                </c:otherwise>
            </c:choose>
        </div>
        
        <c:if test="${flower.quantity > 0}">
            <p class="text-success fw-semibold"><i class="bi bi-check-circle-fill"></i> Còn hàng: ${flower.quantity} ${flower.unit}</p>
        </c:if>
        <c:if test="${flower.quantity == 0}">
            <p class="text-danger fw-semibold"><i class="bi bi-x-circle-fill"></i> Hết hàng</p>
        </c:if>
        
        <p class="text-secondary mb-4">${flower.description}</p>
        
        <c:if test="${flower.quantity > 0 and (empty sessionScope.user or sessionScope.user.role == 'customer')}">
            <form action="${pageContext.request.contextPath}/cart" method="POST" class="d-flex align-items-center gap-3 flex-wrap">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="flowerId" value="${flower.flowerId}">
                
                <div class="input-group" style="max-width: 140px;">
                    <button type="button" class="btn btn-outline-secondary" onclick="changeQty(-1)">-</button>
                    <input type="number" name="quantity" id="qty-input" class="form-control text-center fw-bold" value="1" min="1" max="${flower.quantity}">
                    <button type="button" class="btn btn-outline-secondary" onclick="changeQty(1)">+</button>
                </div>
                
                <button type="submit" class="btn btn-primary btn-lg rounded-pill px-5">
                    <i class="bi bi-cart-plus me-2"></i> Thêm vào giỏ hàng
                </button>
            </form>
        </c:if>
        
        <hr class="my-4">
        
        <div class="d-flex gap-3">
            <a href="${pageContext.request.contextPath}/flower-catalog" class="btn btn-outline-secondary rounded-pill">
                <i class="bi bi-arrow-left me-1"></i> Tiếp tục mua
            </a>
            <c:if test="${not empty sessionScope.cart and (empty sessionScope.user or sessionScope.user.role == 'customer')}">
                <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline-primary rounded-pill">
                    <i class="bi bi-cart3 me-1"></i> Xem giỏ hàng
                </a>
            </c:if>
        </div>
    </div>
</div>

<script>
function changeQty(delta) {
    const input = document.getElementById('qty-input');
    const max = parseInt(input.getAttribute('max'));
    let val = parseInt(input.value) + delta;
    if (val < 1) val = 1;
    if (val > max) val = max;
    input.value = val;
}
</script>

<jsp:include page="/common/footer.jsp" />
