<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/common/header.jsp" />

<div class="row justify-content-center mt-5">
    <div class="col-md-6 col-lg-4">
        <div class="card shadow-sm border-0 rounded-3">
            <div class="card-body p-4">
                <h3 class="text-center text-primary mb-4 fw-bold">Đăng Nhập</h3>
                
                <c:if test="${not empty error or not empty param.error}">
                    <div class="alert alert-danger" role="alert">
                        <c:out value="${not empty error ? error : param.error}" />
                    </div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="alert alert-success" role="alert">
                        <c:out value="${success}" />
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/login" method="POST">
                    <div class="mb-3">
                        <label for="username" class="form-label text-muted">Tên đăng nhập</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0"><i class="bi bi-person text-primary"></i></span>
                            <input type="text" class="form-control border-start-0 ps-0" id="username" name="username" required autofocus>
                        </div>
                    </div>
                    <div class="mb-4">
                        <label for="password" class="form-label text-muted">Mật khẩu</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0"><i class="bi bi-lock text-primary"></i></span>
                            <input type="password" class="form-control border-start-0 ps-0" id="password" name="password" required>
                        </div>
                    </div>
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary btn-lg rounded-pill shadow-sm">Đăng Nhập</button>
                    </div>
                </form>
                
                <div class="text-center mt-4">
                    <p class="text-muted mb-0">Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register.jsp" class="text-primary text-decoration-none fw-bold">Đăng ký ngay</a></p>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/common/footer.jsp" />
