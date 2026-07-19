<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/common/header.jsp" />

<div class="row mt-4 mb-5">
    <!-- Sidebar / Filter -->
    <div class="col-md-3">
        <div class="card border-0 shadow-sm mb-3">
            <div class="card-body">
                <h6 class="fw-bold text-primary mb-3"><i class="bi bi-filter-circle"></i> Bộ lọc tìm kiếm</h6>
                <form action="${pageContext.request.contextPath}/flower-catalog" method="GET">
                    <input type="hidden" name="keyword" value="${keyword}">
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">Danh mục</label>
                        <select class="form-select" name="categoryId">
                            <option value="">Tất cả danh mục</option>
                            <c:forEach var="c" items="${categories}">
                                <option value="${c.categoryId}" ${categoryId == c.categoryId ? 'selected' : ''}>${c.categoryName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">Giá từ (VNĐ)</label>
                        <input type="number" class="form-control" name="minPrice" value="${minPrice}" min="0" step="1000" placeholder="VD: 100000">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Đến giá (VNĐ)</label>
                        <input type="number" class="form-control" name="maxPrice" value="${maxPrice}" min="0" step="1000" placeholder="VD: 500000">
                    </div>
                    
                    <button type="submit" class="btn btn-primary w-100">Áp dụng bộ lọc</button>
                    <a href="${pageContext.request.contextPath}/flower-catalog" class="btn btn-outline-secondary w-100 mt-2">Xóa bộ lọc</a>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Product List -->
    <div class="col-md-9">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-primary fw-bold mb-0">
                <c:choose>
                    <c:when test="${not empty keyword}">Kết quả tìm kiếm: "${keyword}"</c:when>
                    <c:otherwise>Tất Cả Sản Phẩm Hoa</c:otherwise>
                </c:choose>
            </h2>
            <span class="text-muted">${flowers.size()} sản phẩm</span>
        </div>
        
        <c:if test="${empty flowers}">
            <div class="text-center py-5">
                <i class="bi bi-emoji-frown display-4 text-muted d-block mb-3"></i>
                <p class="text-muted fs-5">Không tìm thấy sản phẩm nào.</p>
                <a href="${pageContext.request.contextPath}/flower-catalog" class="btn btn-outline-primary mt-2">Xem tất cả sản phẩm</a>
            </div>
        </c:if>
        
        <div class="row row-cols-1 row-cols-md-3 g-4">
            <c:forEach var="f" items="${flowers}">
                <div class="col">
                    <div class="card h-100 flower-card shadow-sm border-0">
                        <div class="flower-image-container position-relative">
                            <a href="${pageContext.request.contextPath}/detail?id=${f.flowerId}">
                                <c:set var="imgUrl" value="${pageContext.request.contextPath}/images/flowers/${empty f.image ? 'placeholder.jpg' : f.image}" />
                                <c:if test="${not empty f.image and (f.image.startsWith('http://') or f.image.startsWith('https://'))}">
                                    <c:set var="imgUrl" value="${f.image}" />
                                </c:if>
                                <img src="${imgUrl}"
                                     class="card-img-top" alt="${f.flowerName}"
                                     onerror="this.src='https://placehold.co/400x400/f8f9fa/ff6b81?text=Flower'">
                            </a>
                            <span class="position-absolute top-0 end-0 badge bg-danger m-2">${f.unit}</span>
                            <c:if test="${f.discount > 0}">
                                <span class="position-absolute top-0 start-0 badge bg-warning text-dark m-2 shadow-sm fs-6">-${f.discount}%</span>
                            </c:if>
                            <c:if test="${f.quantity == 0}">
                                <div class="position-absolute top-0 start-0 w-100 h-100 d-flex align-items-center justify-content-center" style="background:rgba(0,0,0,0.45);">
                                    <span class="badge bg-dark fs-6 px-3 py-2">Hết hàng</span>
                                </div>
                            </c:if>
                        </div>
                        <div class="card-body text-center">
                            <h5 class="card-title text-truncate" title="${f.flowerName}">
                                <a href="${pageContext.request.contextPath}/detail?id=${f.flowerId}" class="text-decoration-none text-dark">${f.flowerName}</a>
                            </h5>
                            <div class="mb-1">
                                <c:choose>
                                    <c:when test="${f.discount > 0}">
                                        <span class="text-muted text-decoration-line-through me-2"><fmt:formatNumber value="${f.price}" pattern="#,###"/> đ</span>
                                        <span class="text-danger fw-bold fs-5"><fmt:formatNumber value="${f.finalPrice}" pattern="#,###"/> đ</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-danger fw-bold fs-5"><fmt:formatNumber value="${f.price}" pattern="#,###"/> đ</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <small class="text-muted">Còn lại: ${f.quantity} ${f.unit}</small>
                        </div>
                        <div class="card-footer bg-white border-top-0 pb-3 text-center">
                            <a href="${pageContext.request.contextPath}/detail?id=${f.flowerId}" class="btn btn-outline-primary btn-sm rounded-pill px-3 me-1">
                                <i class="bi bi-eye"></i> Chi tiết
                            </a>
                            <c:if test="${f.quantity > 0}">
                                <form action="${pageContext.request.contextPath}/cart" method="POST" class="d-inline">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="flowerId" value="${f.flowerId}">
                                    <input type="hidden" name="quantity" value="1">
                                    <button type="submit" class="btn btn-primary btn-sm rounded-pill px-3">
                                        <i class="bi bi-cart-plus"></i> Thêm giỏ
                                    </button>
                                </form>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
        
        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <nav aria-label="Page navigation" class="mt-5">
                <ul class="pagination justify-content-center">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="?page=${currentPage - 1}&keyword=${keyword}&categoryId=${categoryId}&minPrice=${minPrice}&maxPrice=${maxPrice}">Trang trước</a>
                    </li>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link" href="?page=${i}&keyword=${keyword}&categoryId=${categoryId}&minPrice=${minPrice}&maxPrice=${maxPrice}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="?page=${currentPage + 1}&keyword=${keyword}&categoryId=${categoryId}&minPrice=${minPrice}&maxPrice=${maxPrice}">Trang sau</a>
                    </li>
                </ul>
            </nav>
        </c:if>
    </div>
</div>

<jsp:include page="/common/footer.jsp" />
