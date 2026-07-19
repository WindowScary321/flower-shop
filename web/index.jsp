<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <jsp:include page="/common/header.jsp" />

            <!-- Hero Banner -->
            <div class="mb-5 position-relative text-white">
                <img src="${pageContext.request.contextPath}/images/main_wallpaper.webp" class="img-fluid w-100"
                    alt="Banner" style="object-fit: cover; max-height: 500px; filter: brightness(0.85);">
                <div class="position-absolute top-50 start-50 translate-middle text-center w-100 px-3">
                    <h1 class="display-4 fw-bold"
                        style="text-shadow: 2px 2px 8px rgba(0,0,0,0.7); font-family: 'Playfair Display', Georgia, serif; color: #fff;">
                        FlowerShop <br>
                        Trao đi cảm xúc, gửi trọn yêu thương
                    </h1>
                </div>
            </div>

            <!-- Features Section -->
            <div class="container mb-5">
                <div class="text-center mb-4 position-relative">
                    <hr class="position-absolute top-50 w-100" style="z-index: -1;">
                </div>
                <div class="row text-center mt-4">
                    <div class="col-md-3">
                        <div class="rounded-circle border border-danger border-2 d-inline-flex align-items-center justify-content-center mb-3"
                            style="width: 80px; height: 80px;">
                            <i class="bi bi-truck text-danger" style="font-size: 2.5rem;"></i>
                        </div>
                        <h6 class="fw-bold">MIỄN PHÍ GIAO HOA</h6>
                        <p class="small text-muted mb-0">NỘI THÀNH CÁC TỈNH</p>
                    </div>
                    <div class="col-md-3">
                        <div class="rounded-circle border border-danger border-2 d-inline-flex align-items-center justify-content-center mb-3"
                            style="width: 80px; height: 80px;">
                            <i class="bi bi-shield-check text-danger" style="font-size: 2.5rem;"></i>
                        </div>
                        <h6 class="fw-bold">0% RỦI RO KHI</h6>
                        <p class="small text-muted mb-0">MUA HOA ONLINE</p>
                    </div>
                    <div class="col-md-3">
                        <div class="rounded-circle border border-danger border-2 d-inline-flex align-items-center justify-content-center mb-3"
                            style="width: 80px; height: 80px;">
                            <i class="bi bi-camera text-danger" style="font-size: 2.5rem;"></i>
                        </div>
                        <h6 class="fw-bold">GỬI HÌNH ẢNH</h6>
                        <p class="small text-muted mb-0">TRƯỚC & SAU GIAO HOA</p>
                    </div>
                    <div class="col-md-3">
                        <div class="rounded-circle border border-danger border-2 d-inline-flex align-items-center justify-content-center mb-3"
                            style="width: 80px; height: 80px;">
                            <i class="bi bi-flower1 text-danger" style="font-size: 2.5rem;"></i>
                        </div>
                        <h6 class="fw-bold">HOA LUÔN TƯƠI ĐẸP</h6>
                        <p class="small text-muted mb-0">HOA MỚI MỖI NGÀY</p>
                    </div>
                </div>
            </div>

            <div class="row mt-5">
                <div class="col-12 mb-4">
                    <h5 class="fw-bold text-danger border-bottom pb-2">
                        <i class="bi bi-basket2 text-danger me-2"></i> HOA NỔI BẬT
                        <a href="${pageContext.request.contextPath}/flower-catalog"
                            class="float-end text-decoration-none text-secondary fs-6 fw-normal mt-1">XEM THÊM <i
                                class="bi bi-chevron-right"></i></a>
                    </h5>
                </div>
                <!-- Real data from HomeServlet -->
                <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
                    <c:forEach var="f" items="${featuredFlowers}">
                        <div class="col">
                            <div class="card h-100 flower-card shadow-sm border-0">
                                <div class="flower-image-container position-relative">
                                    <c:set var="imgUrl"
                                        value="${pageContext.request.contextPath}/images/flowers/${empty f.image ? 'placeholder.jpg' : f.image}" />
                                    <c:if
                                        test="${not empty f.image and (f.image.startsWith('http://') or f.image.startsWith('https://'))}">
                                        <c:set var="imgUrl" value="${f.image}" />
                                    </c:if>
                                    <img src="${imgUrl}" class="card-img-top" alt="${f.flowerName}"
                                        onerror="this.src='https://placehold.co/400x400/f8f9fa/ff6b81?text=Flower'">
                                    <span
                                        class="position-absolute top-0 end-0 badge bg-danger m-2 px-2 py-1">${f.unit}</span>
                                </div>
                                <div class="card-body text-center">
                                    <h5 class="card-title text-truncate" title="${f.flowerName}">${f.flowerName}</h5>
                                    <p class="card-text text-danger fw-bold fs-5">
                                        <fmt:formatNumber value="${f.price}" pattern="#,###" /> đ
                                    </p>
                                </div>
                                <div class="card-footer bg-white border-top-0 pb-3 text-center">
                                    <a href="${pageContext.request.contextPath}/detail?id=${f.flowerId}"
                                        class="btn btn-outline-primary btn-sm rounded-pill px-3">
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
            </div>

            <jsp:include page="/common/footer.jsp" />