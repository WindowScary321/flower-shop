<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/common/header.jsp" />

<div class="row mt-4 mb-5">
    <div class="col-md-3">
        <jsp:include page="/common/sidebar-admin.jsp" />
    </div>
    
    <div class="col-md-9">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-primary fw-bold">Quản Lý Tài Khoản</h2>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addAccountModal">
                <i class="bi bi-person-plus-fill"></i> Thêm tài khoản
            </button>
        </div>

        <c:if test="${not empty sessionScope.successMsg}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${sessionScope.successMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="successMsg" scope="session"/>
        </c:if>
        
        <c:if test="${not empty sessionScope.errorMsg}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${sessionScope.errorMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="errorMsg" scope="session"/>
        </c:if>

        <div class="card shadow-sm border-0">
            <div class="card-body p-0 table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-4">Username</th>
                            <th>Họ và tên</th>
                            <th>Email</th>
                            <th>Số điện thoại</th>
                            <th>Phân quyền</th>
                            <th>Trạng thái</th>
                            <th class="text-center">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="a" items="${accounts}">
                            <tr>
                                <td class="ps-4 fw-bold text-secondary">${a.username}</td>
                                <td>${a.fullName}</td>
                                <td>${a.email}</td>
                                <td>${a.phone}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${a.role == 'admin'}"><span class="badge bg-danger">Admin</span></c:when>
                                        <c:when test="${a.role == 'employee'}"><span class="badge bg-info text-dark">Nhân viên</span></c:when>
                                        <c:otherwise><span class="badge bg-secondary">Khách hàng</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${a.status}"><span class="badge bg-success">Hoạt động</span></c:if>
                                    <c:if test="${!a.status}"><span class="badge bg-secondary">Đã khóa</span></c:if>
                                </td>
                                <td class="text-center">
                                    <c:if test="${a.accountId != sessionScope.user.accountId}">
                                        <a href="${pageContext.request.contextPath}/admin/manage-accounts?action=toggleStatus&id=${a.accountId}" 
                                           class="btn btn-sm ${a.status ? 'btn-outline-danger' : 'btn-outline-success'}"
                                           onclick="return confirm('Bạn có chắc chắn muốn ${a.status ? 'KHÓA' : 'MỞ KHÓA'} tài khoản này?');">
                                            <i class="bi ${a.status ? 'bi-lock-fill' : 'bi-unlock-fill'}"></i>
                                            ${a.status ? 'Khóa' : 'Mở khóa'}
                                        </a>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Add Account Modal -->
<div class="modal fade" id="addAccountModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/manage-accounts" method="POST">
                <input type="hidden" name="action" value="add">
                <div class="modal-header">
                    <h5 class="modal-title">Thêm Tài Khoản Mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Tên đăng nhập <span class="text-danger">*</span></label>
                        <input type="text" name="username" class="form-control" required maxlength="50" pattern="^[a-zA-Z0-9]+$" title="Không chứa ký tự đặc biệt và khoảng trắng">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Họ và tên <span class="text-danger">*</span></label>
                        <input type="text" name="fullName" class="form-control" required maxlength="100">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Email <span class="text-danger">*</span></label>
                        <input type="email" name="email" class="form-control" required maxlength="100">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Số điện thoại</label>
                        <input type="text" name="phone" class="form-control" maxlength="20">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Phân quyền</label>
                        <select name="role" class="form-select">
                            <option value="employee">Nhân viên</option>
                            <option value="admin">Quản trị viên (Admin)</option>
                            <option value="customer">Khách hàng</option>
                        </select>
                    </div>
                    <div class="alert alert-info py-2 mb-0">
                        <i class="bi bi-info-circle-fill"></i> Mật khẩu mặc định sẽ là: <strong>password123</strong>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">Tạo tài khoản</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/common/footer.jsp" />
