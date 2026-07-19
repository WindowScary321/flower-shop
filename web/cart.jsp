<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/common/header.jsp" />

<div class="mt-4 mb-5">
    <h2 class="text-primary fw-bold mb-4"><i class="bi bi-cart3 me-2"></i>Giỏ Hàng Của Bạn</h2>
    
    <c:choose>
        <c:when test="${empty sessionScope.cart}">
            <div class="text-center py-5">
                <i class="bi bi-cart-x display-3 text-muted d-block mb-3"></i>
                <h4 class="text-muted mb-3">Giỏ hàng đang trống</h4>
                <a href="${pageContext.request.contextPath}/flower-catalog" class="btn btn-primary rounded-pill px-4">
                    <i class="bi bi-shop me-1"></i> Bắt đầu mua hàng
                </a>
            </div>
        </c:when>
        
        <c:otherwise>
            <form action="${pageContext.request.contextPath}/cart" method="POST">
                <input type="hidden" name="action" value="update">
                
                <div class="row">
                    <div class="col-lg-8">
                        <div class="card border-0 shadow-sm mb-3">
                            <div class="card-body p-0">
                                <table class="table align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th class="ps-4">Sản phẩm</th>
                                            <th>Đơn giá</th>
                                            <th style="width: 140px;">Số lượng</th>
                                            <th>Thành tiền</th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${sessionScope.cart}">
                                            <tr>
                                                <td class="ps-4">
                                                    <div class="d-flex align-items-center gap-3">
                                                        <c:set var="imgUrl" value="${pageContext.request.contextPath}/images/flowers/${empty item.flower.image ? 'placeholder.jpg' : item.flower.image}" />
                                                        <c:if test="${not empty item.flower.image and (item.flower.image.startsWith('http://') or item.flower.image.startsWith('https://'))}">
                                                            <c:set var="imgUrl" value="${item.flower.image}" />
                                                        </c:if>
                                                        <img src="${imgUrl}"
                                                             class="rounded" style="width:60px;height:60px;object-fit:cover;"
                                                             onerror="this.src='https://placehold.co/100x100/f8f9fa/ff6b81?text=Flower'"
                                                             alt="${item.flower.flowerName}">
                                                        <div>
                                                            <div class="fw-bold">${item.flower.flowerName}</div>
                                                            <small class="text-muted"><span class="badge bg-secondary">${item.flower.unit}</span></small>
                                                        </div>
                                                    </div>
                                                    <input type="hidden" name="flowerId" value="${item.flower.flowerId}">
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${item.flower.discount > 0}">
                                                            <div class="text-muted text-decoration-line-through small"><fmt:formatNumber value="${item.flower.price}" pattern="#,###"/> đ</div>
                                                            <div class="text-danger fw-bold"><fmt:formatNumber value="${item.flower.finalPrice}" pattern="#,###"/> đ</div>
                                                            <span class="badge bg-warning text-dark mt-1">-${item.flower.discount}%</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="text-danger fw-bold"><fmt:formatNumber value="${item.flower.price}" pattern="#,###"/> đ</div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <input type="number" name="quantity" class="form-control form-control-sm text-center fw-bold"
                                                           value="${item.quantity}" min="0" max="${item.flower.quantity}" style="width:80px;">
                                                </td>
                                                <td class="fw-bold text-dark">
                                                    <fmt:formatNumber value="${item.totalPrice}" pattern="#,###"/> đ
                                                </td>
                                                <td>
                                                    <a href="${pageContext.request.contextPath}/cart?action=remove&id=${item.flower.flowerId}" 
                                                       class="btn btn-sm btn-outline-danger"
                                                       onclick="return confirm('Xoá sản phẩm này khỏi giỏ?');">
                                                        <i class="bi bi-trash"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        
                        <div class="d-flex justify-content-between">
                            <a href="${pageContext.request.contextPath}/flower-catalog" class="btn btn-outline-secondary rounded-pill">
                                <i class="bi bi-arrow-left me-1"></i> Tiếp tục mua
                            </a>
                            <button type="submit" class="btn btn-outline-primary rounded-pill">
                                <i class="bi bi-arrow-clockwise me-1"></i> Cập nhật giỏ
                            </button>
                        </div>
                    </div>
                    
                    <!-- Summary panel -->
                    <div class="col-lg-4">
                        <div class="card border-0 shadow-sm">
                            <div class="card-body">
                                <h5 class="fw-bold mb-4">Tóm Tắt Đơn Hàng</h5>
                                
                                <c:set var="subtotal" value="0" />
                                <c:forEach var="item" items="${sessionScope.cart}">
                                    <c:set var="subtotal" value="${subtotal + item.totalPrice}" />
                                </c:forEach>
                                
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Tạm tính</span>
                                    <span class="fw-bold"><fmt:formatNumber value="${subtotal}" pattern="#,###"/> đ</span>
                                </div>
                                <div class="d-flex justify-content-between mb-2">
                                    <span class="text-muted">Phí giao hàng</span>
                                    <span class="text-success fw-bold">Miễn phí</span>
                                </div>
                                <hr>
                                <div class="d-flex justify-content-between mb-4">
                                    <span class="fs-5 fw-bold">Tổng cộng</span>
                                    <span class="fs-5 fw-bold text-danger"><fmt:formatNumber value="${subtotal}" pattern="#,###"/> đ</span>
                                </div>
                                
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user}">
                                        <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary w-100 btn-lg rounded-pill">
                                            <i class="bi bi-credit-card me-2"></i> Tiến hành thanh toán
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary w-100 btn-lg rounded-pill">
                                            <i class="bi bi-person-check me-2"></i> Đăng nhập để thanh toán
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/common/footer.jsp" />
