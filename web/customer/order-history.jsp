<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/common/header.jsp" />

<div class="mt-4 mb-5">
    <h2 class="text-primary fw-bold mb-4"><i class="bi bi-clock-history me-2"></i>Lịch Sử Đơn Hàng</h2>

    <!-- Filter Form -->
    <div class="card shadow-sm border-0 mb-4 bg-light">
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/customer/order-history" method="GET" class="row g-3">
                <div class="col-md-3">
                    <label class="form-label fw-bold small text-muted">Trạng thái</label>
                    <select class="form-select" name="status">
                        <option value="">Tất cả</option>
                        <option value="Chờ xử lý" ${status == 'Chờ xử lý' ? 'selected' : ''}>Chờ xử lý</option>
                        <option value="Đang giao" ${status == 'Đang giao' ? 'selected' : ''}>Đang giao</option>
                        <option value="Đã giao" ${status == 'Đã giao' ? 'selected' : ''}>Đã giao</option>
                        <option value="Đã hủy" ${status == 'Đã hủy' ? 'selected' : ''}>Đã hủy</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-bold small text-muted">Từ ngày</label>
                    <input type="date" class="form-control" name="fromDate" value="${fromDate}">
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-bold small text-muted">Đến ngày</label>
                    <input type="date" class="form-control" name="toDate" value="${toDate}">
                </div>
                <div class="col-md-3 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary w-100"><i class="bi bi-search"></i> Lọc</button>
                </div>
            </form>
        </div>
    </div>
    
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
                        
                        <div class="mt-2">
                            <small class="text-muted"><i class="bi bi-credit-card me-1"></i>Thanh toán: 
                                <strong>${order.paymentMethod == 'QR' ? 'Chuyển khoản QR' : 'Tiền mặt (COD)'}</strong>
                                <c:choose>
                                    <c:when test="${order.paymentStatus}">
                                        <span class="badge bg-success ms-1"><i class="bi bi-check-circle me-1"></i>Đã thanh toán</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary ms-1">Chưa thanh toán</span>
                                        <c:if test="${order.paymentMethod == 'QR' && order.status != 'Đã hủy'}">
                                            <a href="${pageContext.request.contextPath}/payment-qr" class="btn btn-sm btn-outline-primary ms-2 py-0" title="Thanh toán ngay" onclick="sessionStorage.setItem('lastOrderId', '${order.orderId}');">Thanh toán lại</a>
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>
                            </small>
                        </div>
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

    <!-- Pagination -->
    <c:if test="${totalPages > 1}">
        <nav aria-label="Page navigation" class="mt-4">
            <ul class="pagination justify-content-center">
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link" href="?page=${currentPage - 1}&status=${status}&fromDate=${fromDate}&toDate=${toDate}">Trang trước</a>
                </li>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                        <a class="page-link" href="?page=${i}&status=${status}&fromDate=${fromDate}&toDate=${toDate}">${i}</a>
                    </li>
                </c:forEach>
                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="?page=${currentPage + 1}&status=${status}&fromDate=${fromDate}&toDate=${toDate}">Trang sau</a>
                </li>
            </ul>
        </nav>
    </c:if>
</div>

<jsp:include page="/common/footer.jsp" />
