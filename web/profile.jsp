<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/common/header.jsp" />

<div class="container mt-4 mb-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-white text-center py-4">
                    <i class="bi bi-person-circle display-1 text-primary"></i>
                    <h3 class="mt-3 fw-bold">${sessionScope.user.fullName}</h3>
                    <span class="badge bg-secondary">
                        <c:choose>
                            <c:when test="${sessionScope.user.role == 'admin'}">Quản trị viên</c:when>
                            <c:when test="${sessionScope.user.role == 'employee'}">Nhân viên</c:when>
                            <c:otherwise>Khách hàng</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="card-body p-4">
                    <h5 class="fw-bold mb-3">Thông Tin Cá Nhân</h5>
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item px-0">
                            <strong>Tên đăng nhập:</strong> <span class="float-end">${sessionScope.user.username}</span>
                        </li>
                        <li class="list-group-item px-0">
                            <strong>Họ và tên:</strong> <span class="float-end">${sessionScope.user.fullName}</span>
                        </li>
                        <li class="list-group-item px-0">
                            <strong>Email:</strong> <span class="float-end">${sessionScope.user.email}</span>
                        </li>
                        <li class="list-group-item px-0">
                            <strong>Số điện thoại:</strong> <span class="float-end">${sessionScope.user.phone}</span>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/common/footer.jsp" />
