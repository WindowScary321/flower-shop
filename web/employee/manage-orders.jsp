<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/common/header.jsp" />

<div class="mt-4 mb-5">
    <div class="d-flex align-items-center mb-4">
        <h2 class="text-primary fw-bold mb-0"><i class="bi bi-bag-check me-2"></i>Xử Lý Đơn Hàng</h2>
        <span class="text-muted ms-3 small">(Nhân viên chỉ được cập nhật trạng thái giao hàng)</span>
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
    
    <div class="card border-0 shadow-sm">
        <div class="card-body p-0 table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th class="ps-4">Mã ĐH</th>
                        <th>Ngày đặt</th>
                        <th>Người nhận</th>
                        <th>Địa chỉ</th>
                        <th>Thanh toán</th>
                        <th>Tổng tiền</th>
                        <th>Trạng thái</th>
                        <th class="text-center">Cập nhật</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="order" items="${orders}">
                        <tr>
                            <td class="ps-4 fw-bold text-primary">#${order.orderId}</td>
                            <td class="small text-muted">
                                <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                            </td>
                            <td>
                                <div class="fw-semibold">${order.receiverName}</div>
                                <small class="text-muted">${order.receiverPhone}</small>
                            </td>
                            <td class="small">${order.receiverAddress}</td>
                            <td>
                                <small class="d-block fw-bold">${order.paymentMethod == 'QR' ? 'QR' : 'COD'}</small>
                                <c:choose>
                                    <c:when test="${order.paymentStatus}"><span class="badge bg-success" style="font-size:0.7em;">Đã thanh toán</span></c:when>
                                    <c:otherwise><span class="badge bg-secondary" style="font-size:0.7em;">Chưa thanh toán</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="fw-bold text-danger">
                                <fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/> đ
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${order.status == 'Chờ xử lý'}"><span class="badge bg-warning text-dark">${order.status}</span></c:when>
                                    <c:when test="${order.status == 'Đang giao'}"><span class="badge bg-info text-dark">${order.status}</span></c:when>
                                    <c:when test="${order.status == 'Đã giao'}"><span class="badge bg-success">${order.status}</span></c:when>
                                    <c:when test="${order.status == 'Đã hủy'}"><span class="badge bg-secondary">${order.status}</span></c:when>
                                    <c:otherwise><span class="badge bg-dark">${order.status}</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">
                                <c:if test="${order.status == 'Chờ xử lý' || order.status == 'Đang giao'}">
                                    <form action="${pageContext.request.contextPath}/employee/manage-orders" method="POST" class="d-inline-flex gap-1">
                                        <input type="hidden" name="action" value="updateStatus">
                                        <input type="hidden" name="orderId" value="${order.orderId}">
                                        <select name="newStatus" class="form-select form-select-sm" style="width:130px;">
                                            <option value="Đang giao" ${order.status == 'Đang giao' ? 'selected' : ''}>Đang giao</option>
                                            <option value="Đã giao" ${order.status == 'Đã giao' ? 'selected' : ''}>Đã giao</option>
                                        </select>
                                        <button type="submit" class="btn btn-sm btn-success">
                                            <i class="bi bi-check-lg"></i>
                                        </button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty orders}">
                        <tr>
                            <td colspan="8" class="text-center py-4 text-muted">Chưa có đơn hàng nào.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="/common/footer.jsp" />
