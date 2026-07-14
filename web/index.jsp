<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/common/header.jsp" />

<!-- Hero Banner -->
<div class="p-5 mb-4 bg-light rounded-3 shadow-sm border text-center" style="background: linear-gradient(to right, rgba(255, 107, 129, 0.1), rgba(255, 255, 255, 0.5));">
    <div class="container-fluid py-5">
        <h1 class="display-5 fw-bold text-primary mb-3">Chào mừng đến với Flower Shop</h1>
        <p class="col-md-8 mx-auto fs-4 text-secondary">Khám phá những bó hoa tuyệt đẹp dành cho mọi dịp. Giao hàng nhanh chóng, hoa luôn tươi mới.</p>
        <a href="${pageContext.request.contextPath}/flower-catalog" class="btn btn-primary btn-lg mt-3 px-5 rounded-pill shadow">
            Khám phá ngay <i class="bi bi-arrow-right ms-2"></i>
        </a>
    </div>
</div>

<div class="row mt-5">
    <div class="col-12 text-center mb-4">
        <h2 class="fw-bold text-primary border-bottom border-2 border-primary d-inline-block pb-2">Hoa Nổi Bật</h2>
    </div>
    <!-- Real data from HomeServlet -->
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
        <c:forEach var="f" items="${featuredFlowers}">
            <div class="col">
                <div class="card h-100 flower-card shadow-sm border-0">
                    <div class="flower-image-container position-relative">
                        <img src="${pageContext.request.contextPath}/images/flowers/${empty f.image ? 'placeholder.jpg' : f.image}" 
                             class="card-img-top" alt="${f.flowerName}" 
                             onerror="this.src='https://placehold.co/400x400/f8f9fa/ff6b81?text=Flower'">
                        <span class="position-absolute top-0 end-0 badge bg-danger m-2 px-2 py-1">${f.unit}</span>
                    </div>
                    <div class="card-body text-center">
                        <h5 class="card-title text-truncate" title="${f.flowerName}">${f.flowerName}</h5>
                        <p class="card-text text-danger fw-bold fs-5">
                            <fmt:formatNumber value="${f.price}" pattern="#,###"/> đ
                        </p>
                    </div>
                    <div class="card-footer bg-white border-top-0 pb-3 text-center">
                        <a href="${pageContext.request.contextPath}/detail?id=${f.flowerId}" class="btn btn-outline-primary btn-sm rounded-pill px-3">
                            Xem chi tiết
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
        
        <c:if test="${empty featuredFlowers}">
            <div class="col-12 text-center py-5 text-muted">
                <i class="bi bi-emoji-frown fs-1 d-block mb-3"></i>
                <p>Hiện chưa có sản phẩm hoa nào được bày bán.</p>
            </div>
        </c:if>
    </div>
</div>

<jsp:include page="/common/footer.jsp" />
