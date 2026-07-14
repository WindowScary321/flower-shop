<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/common/header.jsp" />

<div class="mt-4 mb-5">
    <h2 class="text-primary fw-bold mb-4"><i class="bi bi-clock-history me-2"></i>Lịch Sử Đơn Hàng</h2>
    
    <c:if test="${not empty sessionScope.successMsg}">
        <div class="alert alert-success alert-dismissible fade show">
            ${sessionScope.successMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="successMsg" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMsg}">
        <div class="alert alert-danger alert-dismissible fade show">
            ${sessionScope.errorMsg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="errorMsg" scope="session"/>
    </c:if>
    
    <c:if test="${empty orders}">
        <div class="text-center py-5">
            <i class="bi bi-inbox display-3 text-muted d-block mb-3"></i>
            <h5 class="text-muted mb-3">Bạn chưa có đơn hàng nào.</h5>
            <a href="${pageContext.request.contextPath}/flower-catalog" class="btn btn-primary rounded-pill px-4">Bắt đầu mua sắm</a>
        </div>
    </c:if>
    
    <c:forEach var="order" items="${orders}">
        <div class="card border-0 shadow-sm mb-3">
            <div class="card-header d-flex justify-content-between align-items-center bg-light flex-wrap gap-2">
                <div>
                    <span class="fw-bold text-primary">Đơn hàng #${order.orderId}</span>
                    <span class="text-muted ms-3 small">
                        <i class="bi bi-calendar3 me-1"></i>
                        <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                    </span>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <c:choose>
                        <c:when test="${order.status == 'Chờ xử lý'}"><span class="badge bg-warning text-dark px-3 py-2">${order.status}</span></c:when>
                        <c:when test="${order.status == 'Đang giao'}"><span class="badge bg-info text-dark px-3 py-2">${order.status}</span></c:when>
                        <c:when test="${order.status == 'Đã giao'}"><span class="badge bg-success px-3 py-2">${order.status}</span></c:when>
                        <c:when test="${order.status == 'Đã hủy'}"><span class="badge bg-secondary px-3 py-2">${order.status}</span></c:when>
                        <c:otherwise><span class="badge bg-dark px-3 py-2">${order.status}</span></c:otherwise>
                    </c:choose>
                    
                    <c:if test="${order.status == 'Chờ xử lý'}">
                        <form action="${pageContext.request.contextPath}/customer/order-history" method="POST" class="d-inline"
                              onsubmit="return confirm('Bạn có chắc muốn HỦY đơn hàng #${order.orderId}?');">
                            <input type="hidden" name="action" value="cancel">
                            <input type="hidden" name="orderId" value="${order.orderId}">
                            <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill">
                                <i class="bi bi-x-circle me-1"></i> Hủy đơn
                            </button>
                        </form>
                    </c:if>
                </div>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <small class="text-muted d-block"><i class="bi bi-person me-1"></i>Người nhận: <strong>${order.receiverName}</strong></small>
                        <small class="text-muted d-block"><i class="bi bi-telephone me-1"></i>SĐT: ${order.receiverPhone}</small>
                        <small class="text-muted d-block"><i class="bi bi-geo-alt me-1"></i>Địa chỉ: ${order.receiverAddress}</small>
                    </div>
                    <div class="col-md-6 text-md-end mt-2 mt-md-0">
                        <span class="fs-5 fw-bold text-danger">
                            Tổng: <fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/> đ
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </c:forEach>
</div>

<jsp:include page="/common/footer.jsp" />
