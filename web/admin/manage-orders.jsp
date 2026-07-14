<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/common/header.jsp" />

<div class="row mt-4 mb-5">
    <div class="col-md-3">
        <jsp:include page="/common/sidebar-admin.jsp" />
    </div>
    <div class="col-md-9">
        <h2 class="text-primary fw-bold mb-4">Quản Lý Đơn Hàng</h2>
        
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
                            <th>SĐT</th>
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
                                <td>${order.receiverName}</td>
                                <td>${order.receiverPhone}</td>
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
                                    <c:if test="${order.status != 'Đã giao' && order.status != 'Đã hủy'}">
                                        <form action="${pageContext.request.contextPath}/admin/manage-orders" method="POST" class="d-inline-flex gap-1">
                                            <input type="hidden" name="action" value="updateStatus">
                                            <input type="hidden" name="orderId" value="${order.orderId}">
                                            <select name="newStatus" class="form-select form-select-sm" style="width:130px;">
                                                <option value="Chờ xử lý" ${order.status == 'Chờ xử lý' ? 'selected' : ''}>Chờ xử lý</option>
                                                <option value="Đang giao" ${order.status == 'Đang giao' ? 'selected' : ''}>Đang giao</option>
                                                <option value="Đã giao" ${order.status == 'Đã giao' ? 'selected' : ''}>Đã giao</option>
                                            </select>
                                            <button type="submit" class="btn btn-sm btn-primary">
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
</div>

<jsp:include page="/common/footer.jsp" />
