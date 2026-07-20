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
                <div class="row text-center mt-4 position-relative">
                    <hr class="position-absolute w-100" style="top: 40px; left: 0; z-index: 0; margin: 0; border: 0; border-top: 1px solid #dee2e6; opacity: 1;">
                    <div class="col-md-3 position-relative" style="z-index: 1;">
                        <div class="rounded-circle border border-danger border-2 d-inline-flex align-items-center justify-content-center mb-3 bg-white"
                            style="width: 80px; height: 80px;">
                            <i class="bi bi-truck text-danger" style="font-size: 2.5rem;"></i>
                        </div>
                        <h6 class="fw-bold">MIỄN PHÍ GIAO HOA</h6>
                        <p class="small text-muted mb-0">NỘI THÀNH CÁC TỈNH</p>
                    </div>
                    <div class="col-md-3 position-relative" style="z-index: 1;">
                        <div class="rounded-circle border border-danger border-2 d-inline-flex align-items-center justify-content-center mb-3 bg-white"
                            style="width: 80px; height: 80px;">
                            <i class="bi bi-shield-check text-danger" style="font-size: 2.5rem;"></i>
                        </div>
                        <h6 class="fw-bold">0% RỦI RO KHI</h6>
                        <p class="small text-muted mb-0">MUA HOA ONLINE</p>
                    </div>
                    <div class="col-md-3 position-relative" style="z-index: 1;">
                        <div class="rounded-circle border border-danger border-2 d-inline-flex align-items-center justify-content-center mb-3 bg-white"
                            style="width: 80px; height: 80px;">
                            <i class="bi bi-camera text-danger" style="font-size: 2.5rem;"></i>
                        </div>
                        <h6 class="fw-bold">GỬI HÌNH ẢNH</h6>
                        <p class="small text-muted mb-0">TRƯỚC & SAU GIAO HOA</p>
                    </div>
                    <div class="col-md-3 position-relative" style="z-index: 1;">
                        <div class="rounded-circle border border-danger border-2 d-inline-flex align-items-center justify-content-center mb-3 bg-white"
                            style="width: 80px; height: 80px;">
                            <i class="bi bi-flower1 text-danger" style="font-size: 2.5rem;"></i>
                        </div>
                        <h6 class="fw-bold">HOA LUÔN TƯƠI ĐẸP</h6>
                        <p class="small text-muted mb-0">HOA MỚI MỖI NGÀY</p>
                    </div>
                </div>
            </div>

            <!-- Categories Navigation Section -->
            <div class="container mb-5">
                <div class="text-center mb-4">
                    <h3 class="fw-bold text-dark section-title-premium d-inline-block">Danh Mục Hoa Tươi</h3>
                    <p class="text-muted small">Khám phá các bộ sưu tập hoa tươi thiết kế độc đáo cho mọi dịp ý nghĩa</p>
                </div>
                <div class="row row-cols-2 row-cols-md-3 row-cols-lg-5 g-4 justify-content-center">
                    <c:forEach var="entry" items="${categoryMap}">
                        <c:set var="cat" value="${entry.key}" />
                        <c:set var="flowersInCat" value="${entry.value}" />
                        <c:set var="repFlowerImg" value="${pageContext.request.contextPath}/images/flowers/placeholder.jpg" />
                        <c:if test="${not empty flowersInCat}">
                            <c:set var="firstFlower" value="${flowersInCat[0]}" />
                            <c:set var="repFlowerImg" value="${firstFlower.image}" />
                            <c:if test="${not empty firstFlower.image and !firstFlower.image.startsWith('http://') and !firstFlower.image.startsWith('https://')}">
                                <c:set var="repFlowerImg" value="${pageContext.request.contextPath}/images/flowers/${firstFlower.image}" />
                            </c:if>
                        </c:if>
                        <div class="col">
                            <a href="${pageContext.request.contextPath}/flower-catalog?categoryId=${cat.categoryId}" 
                               class="text-decoration-none text-dark card h-100 border-0 shadow-sm category-card text-center overflow-hidden">
                                <div class="category-image-container position-relative">
                                    <img src="${repFlowerImg}" class="category-img" alt="${cat.categoryName}"
                                         onerror="this.src='https://placehold.co/400x400/f8f9fa/ff6b81?text=Flower'">
                                    <div class="category-overlay">
                                        <span class="btn btn-sm btn-light rounded-pill px-3 py-1 fw-bold shadow-sm">Khám phá</span>
                                    </div>
                                </div>
                                <div class="card-body py-3">
                                    <h6 class="fw-bold mb-1 text-truncate">${cat.categoryName}</h6>
                                    <p class="small text-muted mb-0 text-truncate" title="${cat.description}">${cat.description}</p>
                                </div>
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Featured Flowers Section -->
            <div class="row mt-4 mb-5">
                <div class="col-12 mb-4">
                    <h4 class="fw-bold text-danger section-title-premium d-inline-block">
                        <i class="bi bi-star-fill text-danger me-2"></i> HOA NỔI BẬT
                    </h4>
                    <a href="${pageContext.request.contextPath}/flower-catalog"
                       class="float-end text-decoration-none text-secondary fs-6 fw-normal mt-2">XEM THÊM <i
                            class="bi bi-chevron-right"></i></a>
                </div>
                <!-- Real data from HomeServlet -->
                <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
                    <c:forEach var="f" items="${featuredFlowers}">
                        <div class="col">
                            <div class="card h-100 flower-card shadow-sm border-0 position-relative overflow-hidden" style="border-radius: 12px;">
                                <!-- Discount Badge if any -->
                                <c:if test="${f.discount > 0}">
                                    <span class="position-absolute top-0 start-0 badge bg-danger m-2 px-2 py-1" style="z-index: 1;">-${f.discount}%</span>
                                </c:if>
                                
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
                                    <h6 class="card-title text-truncate fw-bold mb-2" title="${f.flowerName}">${f.flowerName}</h6>
                                    <div class="price-container">
                                        <c:choose>
                                            <c:when test="${f.discount > 0}">
                                                <span class="text-muted text-decoration-line-through small me-2">
                                                    <fmt:formatNumber value="${f.price}" pattern="#,###" /> đ
                                                </span>
                                                <span class="text-danger fw-bold fs-5">
                                                    <fmt:formatNumber value="${f.getFinalPrice()}" pattern="#,###" /> đ
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-danger fw-bold fs-5">
                                                    <fmt:formatNumber value="${f.price}" pattern="#,###" /> đ
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="card-footer bg-white border-top-0 pb-3 text-center">
                                    <a href="${pageContext.request.contextPath}/detail?id=${f.flowerId}"
                                        class="btn btn-outline-danger btn-sm rounded-pill px-3">
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

            <!-- Products by Category Sections -->
            <c:forEach var="entry" items="${categoryMap}">
                <c:set var="cat" value="${entry.key}" />
                <c:set var="flowers" value="${entry.value}" />
                
                <c:if test="${not empty flowers}">
                    <div class="row mt-5 mb-5">
                        <div class="col-12 mb-4">
                            <h4 class="fw-bold text-danger section-title-premium d-inline-block">
                                <i class="bi bi-flower2 text-danger me-2"></i> ${cat.categoryName}
                            </h4>
                            <a href="${pageContext.request.contextPath}/flower-catalog?categoryId=${cat.categoryId}"
                                class="float-end text-decoration-none text-secondary fs-6 fw-normal mt-2">XEM TẤT CẢ <i
                                    class="bi bi-chevron-right"></i></a>
                        </div>
                        
                        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
                            <c:forEach var="f" items="${flowers}">
                                <div class="col">
                                    <div class="card h-100 flower-card shadow-sm border-0 position-relative overflow-hidden" style="border-radius: 12px;">
                                        <!-- Discount Badge if any -->
                                        <c:if test="${f.discount > 0}">
                                            <span class="position-absolute top-0 start-0 badge bg-danger m-2 px-2 py-1" style="z-index: 1;">-${f.discount}%</span>
                                        </c:if>
                                        
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
                                            <h6 class="card-title text-truncate fw-bold mb-2" title="${f.flowerName}">${f.flowerName}</h6>
                                            <div class="price-container">
                                                <c:choose>
                                                    <c:when test="${f.discount > 0}">
                                                        <span class="text-muted text-decoration-line-through small me-2">
                                                            <fmt:formatNumber value="${f.price}" pattern="#,###" /> đ
                                                        </span>
                                                        <span class="text-danger fw-bold fs-5">
                                                            <fmt:formatNumber value="${f.getFinalPrice()}" pattern="#,###" /> đ
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-danger fw-bold fs-5">
                                                            <fmt:formatNumber value="${f.price}" pattern="#,###" /> đ
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        <div class="card-footer bg-white border-top-0 pb-3 text-center">
                                            <a href="${pageContext.request.contextPath}/detail?id=${f.flowerId}"
                                                class="btn btn-outline-danger btn-sm rounded-pill px-3">
                                                Xem chi tiết
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
            </c:forEach>
            </div>

            <jsp:include page="/common/footer.jsp" />