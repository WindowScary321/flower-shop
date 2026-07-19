<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/common/header.jsp" />

<div class="container mt-4 mb-5">
    <!-- Messages -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show shadow-sm mb-4" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i><c:out value="${error}" />
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    <c:if test="${not empty success}">
        <div class="alert alert-success alert-dismissible fade show shadow-sm mb-4" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i><c:out value="${success}" />
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="row g-4">
        <!-- Left Column: Basic Info Display -->
        <div class="col-md-5 col-lg-4">
            <div class="card shadow-sm border-0 h-100">
                <div class="card-header bg-white text-center py-4 border-bottom-0">
                    <i class="bi bi-person-circle display-1 text-primary"></i>
                    <h4 class="mt-3 fw-bold">${sessionScope.user.fullName}</h4>
                    <span class="badge bg-secondary mb-2">
                        <c:choose>
                            <c:when test="${sessionScope.user.role == 'admin'}">Quản trị viên</c:when>
                            <c:when test="${sessionScope.user.role == 'employee'}">Nhân viên</c:when>
                            <c:otherwise>Khách hàng</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="card-body p-4 pt-0">
                    <h5 class="fw-bold mb-3 border-bottom pb-2">Thông Tin Hiện Tại</h5>
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item px-0 d-flex justify-content-between">
                            <span class="text-muted">Tên đăng nhập</span>
                            <span class="fw-bold">${sessionScope.user.username}</span>
                        </li>
                        <li class="list-group-item px-0 d-flex justify-content-between">
                            <span class="text-muted">Họ và tên</span>
                            <span class="fw-bold">${sessionScope.user.fullName}</span>
                        </li>
                        <li class="list-group-item px-0 d-flex justify-content-between">
                            <span class="text-muted">Email</span>
                            <span class="fw-bold text-break text-end" style="max-width: 60%;">${sessionScope.user.email}</span>
                        </li>
                        <li class="list-group-item px-0 d-flex justify-content-between">
                            <span class="text-muted">Số điện thoại</span>
                            <span class="fw-bold">${sessionScope.user.phone}</span>
                        </li>
                        <li class="list-group-item px-0 d-flex justify-content-between">
                            <span class="text-muted">Địa chỉ</span>
                            <span class="fw-bold text-end text-break" style="max-width: 60%;">${empty sessionScope.user.address ? 'Chưa cập nhật' : sessionScope.user.address}</span>
                        </li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Right Column: Update Forms -->
        <div class="col-md-7 col-lg-8">
            <!-- Form 1: Update Profile Info -->
            <div class="card shadow-sm border-0 mb-4">
                <div class="card-body p-4">
                    <h5 class="fw-bold mb-3 border-bottom pb-2"><i class="bi bi-person-gear me-2"></i>Thay Đổi Thông Tin Cá Nhân</h5>
                    <form action="${pageContext.request.contextPath}/profile" method="POST">
                        <input type="hidden" name="action" value="updateInfo">
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="fullName" class="form-label text-muted fw-bold small">Họ và tên</label>
                                <input type="text" class="form-control" id="fullName" name="fullName" value="${sessionScope.user.fullName}" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="email" class="form-label text-muted fw-bold small">Email</label>
                                <input type="email" class="form-control" id="email" name="email" value="${sessionScope.user.email}" required>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="phone" class="form-label text-muted fw-bold small">Số điện thoại (Không cần mật khẩu xác nhận)</label>
                                <input type="text" class="form-control" id="phone" name="phone" value="${sessionScope.user.phone}" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="address" class="form-label text-muted fw-bold small">Địa chỉ (Không cần mật khẩu xác nhận)</label>
                                <input type="text" class="form-control" id="address" name="address" value="${sessionScope.user.address}" placeholder="Nhập địa chỉ của bạn">
                            </div>
                        </div>

                        <div class="mb-3 pt-2 border-top">
                            <label for="currentPassword" class="form-label text-danger fw-bold small">Mật khẩu xác nhận</label>
                            <input type="password" class="form-control border-danger" id="currentPassword" name="currentPassword" placeholder="Nhập mật khẩu của bạn (chỉ yêu cầu khi thay đổi Họ tên hoặc Email)">
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary rounded-pill shadow-sm">Lưu Thay Đổi</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Form 2: Change Password -->
            <div class="card shadow-sm border-0">
                <div class="card-body p-4">
                    <h5 class="fw-bold mb-3 border-bottom pb-2"><i class="bi bi-key me-2"></i>Đổi Mật Khẩu</h5>
                    <form action="${pageContext.request.contextPath}/profile" method="POST">
                        <input type="hidden" name="action" value="changePassword">
                        
                        <div class="mb-3">
                            <label for="oldPassword" class="form-label text-muted fw-bold small">Mật khẩu cũ</label>
                            <input type="password" class="form-control" id="oldPassword" name="oldPassword" placeholder="Nhập mật khẩu cũ" required>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="newPassword" class="form-label text-muted fw-bold small">Mật khẩu mới</label>
                                <input type="password" class="form-control" id="newPassword" name="newPassword" placeholder="Ít nhất 6 ký tự" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="confirmPassword" class="form-label text-muted fw-bold small">Nhập lại mật khẩu mới</label>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Xác nhận mật khẩu mới" required>
                            </div>
                        </div>

                        <div class="d-grid gap-2 mt-2">
                            <button type="submit" class="btn btn-danger rounded-pill shadow-sm">Đổi Mật Khẩu</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/common/footer.jsp" />
