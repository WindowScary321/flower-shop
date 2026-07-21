<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/common/header.jsp" />

<div class="row mt-4 mb-5">
    <div class="col-md-3">
        <jsp:include page="/common/sidebar-admin.jsp" />
    </div>
    
    <div class="col-md-9">
        <h2 class="text-primary fw-bold mb-4">Nhật ký hoạt động</h2>
        
        <!-- Filter Form -->
        <div class="card shadow-sm border-0 mb-4 bg-light">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/activity-logs" method="GET" class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label">Loại hành động</label>
                        <select name="actionType" class="form-select">
                            <option value="">-- Tất cả --</option>
                            <optgroup label="Tài khoản">
                                <option value="LOGIN_SUCCESS" ${actionType == 'LOGIN_SUCCESS' ? 'selected' : ''}>LOGIN_SUCCESS</option>
                                <option value="LOGIN_FAILED" ${actionType == 'LOGIN_FAILED' ? 'selected' : ''}>LOGIN_FAILED</option>
                                <option value="LOGOUT" ${actionType == 'LOGOUT' ? 'selected' : ''}>LOGOUT</option>
                                <option value="REGISTER" ${actionType == 'REGISTER' ? 'selected' : ''}>REGISTER</option>
                                <option value="PROFILE_UPDATE" ${actionType == 'PROFILE_UPDATE' ? 'selected' : ''}>PROFILE_UPDATE</option>
                            </optgroup>
                            <optgroup label="Khách hàng">
                                <option value="ADD_TO_CART" ${actionType == 'ADD_TO_CART' ? 'selected' : ''}>ADD_TO_CART</option>
                                <option value="UPDATE_CART" ${actionType == 'UPDATE_CART' ? 'selected' : ''}>UPDATE_CART</option>
                                <option value="REMOVE_FROM_CART" ${actionType == 'REMOVE_FROM_CART' ? 'selected' : ''}>REMOVE_FROM_CART</option>
                                <option value="CHECKOUT" ${actionType == 'CHECKOUT' ? 'selected' : ''}>CHECKOUT</option>
                                <option value="CHECKOUT_FAILED" ${actionType == 'CHECKOUT_FAILED' ? 'selected' : ''}>CHECKOUT_FAILED</option>
                                <option value="ORDER_CANCEL" ${actionType == 'ORDER_CANCEL' ? 'selected' : ''}>ORDER_CANCEL</option>
                            </optgroup>
                            <optgroup label="Quản lý">
                                <option value="ORDER_STATUS_UPDATE" ${actionType == 'ORDER_STATUS_UPDATE' ? 'selected' : ''}>ORDER_STATUS_UPDATE</option>
                                <option value="FLOWER_CREATE" ${actionType == 'FLOWER_CREATE' ? 'selected' : ''}>FLOWER_CREATE</option>
                                <option value="FLOWER_UPDATE" ${actionType == 'FLOWER_UPDATE' ? 'selected' : ''}>FLOWER_UPDATE</option>
                                <option value="FLOWER_DELETE" ${actionType == 'FLOWER_DELETE' ? 'selected' : ''}>FLOWER_DELETE</option>
                                <option value="CATEGORY_CREATE" ${actionType == 'CATEGORY_CREATE' ? 'selected' : ''}>CATEGORY_CREATE</option>
                                <option value="CATEGORY_UPDATE" ${actionType == 'CATEGORY_UPDATE' ? 'selected' : ''}>CATEGORY_UPDATE</option>
                                <option value="CATEGORY_DELETE" ${actionType == 'CATEGORY_DELETE' ? 'selected' : ''}>CATEGORY_DELETE</option>
                                <option value="ACCOUNT_CREATE" ${actionType == 'ACCOUNT_CREATE' ? 'selected' : ''}>ACCOUNT_CREATE</option>
                                <option value="ACCOUNT_TOGGLE_STATUS" ${actionType == 'ACCOUNT_TOGGLE_STATUS' ? 'selected' : ''}>ACCOUNT_TOGGLE_STATUS</option>
                            </optgroup>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Tài khoản (Username)</label>
                        <input type="text" name="username" class="form-control" value="${username}" placeholder="Nhập username...">
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Từ ngày</label>
                        <input type="date" name="fromDate" class="form-control" value="${fromDate}">
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Đến ngày</label>
                        <input type="date" name="toDate" class="form-control" value="${toDate}">
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary w-100"><i class="bi bi-search me-1"></i> Lọc</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="card shadow-sm border-0">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover mb-0 align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Thời gian</th>
                                <th>Tài khoản</th>
                                <th>Hành động</th>
                                <th>Mô tả chi tiết</th>
                                <th>IP</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${empty logs}">
                                <tr>
                                    <td colspan="5" class="text-center py-4 text-muted">Không tìm thấy nhật ký hoạt động nào.</td>
                                </tr>
                            </c:if>
                            <c:forEach var="log" items="${logs}">
                                <tr>
                                    <td class="text-nowrap text-muted" style="font-size: 0.9rem;">
                                        <fmt:formatDate value="${log.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty log.username}">
                                                <span class="badge bg-secondary">${log.username}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted fst-italic">Khách vãng lai</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="badge ${log.actionType.contains('FAILED') || log.actionType.contains('DELETE') || log.actionType.contains('CANCEL') ? 'bg-danger' : (log.actionType.contains('SUCCESS') || log.actionType.contains('CREATE') || log.actionType.contains('ADD') ? 'bg-success' : 'bg-primary')}">
                                            ${log.actionType}
                                        </span>
                                    </td>
                                    <td>${log.description}</td>
                                    <td class="text-muted" style="font-size: 0.85rem;">${log.ipAddress}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
            
            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <div class="card-footer bg-white py-3">
                    <nav>
                        <ul class="pagination justify-content-center mb-0">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage - 1}&actionType=${actionType}&username=${username}&fromDate=${fromDate}&toDate=${toDate}"><i class="bi bi-chevron-left"></i></a>
                            </li>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="?page=${i}&actionType=${actionType}&username=${username}&fromDate=${fromDate}&toDate=${toDate}">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="?page=${currentPage + 1}&actionType=${actionType}&username=${username}&fromDate=${fromDate}&toDate=${toDate}"><i class="bi bi-chevron-right"></i></a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </c:if>
        </div>
        
    </div>
</div>

<jsp:include page="/common/footer.jsp" />
