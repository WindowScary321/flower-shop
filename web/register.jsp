<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/common/header.jsp" />

<div class="row justify-content-center mt-5 mb-5">
    <div class="col-md-8 col-lg-6">
        <div class="card shadow-sm border-0 rounded-3">
            <div class="card-body p-4">
                <h3 class="text-center text-primary mb-4 fw-bold">Đăng Ký Tài Khoản</h3>
                
                <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">
                        ${error}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/register" method="POST">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="username" class="form-label text-muted">Tên đăng nhập <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="username" name="username" value="${username}" required pattern="[A-Za-z0-9]{4,50}" title="4-50 ký tự, chỉ gồm chữ và số">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="fullname" class="form-label text-muted">Họ và tên <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="fullname" name="fullname" value="${fullname}" required minlength="2" maxlength="100">
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="email" class="form-label text-muted">Email <span class="text-danger">*</span></label>
                            <input type="email" class="form-control" id="email" name="email" value="${email}" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label for="phone" class="form-label text-muted">Số điện thoại <span class="text-danger">*</span></label>
                            <input type="tel" class="form-control" id="phone" name="phone" value="${phone}" required pattern="0[0-9]{9,10}" title="Bắt đầu bằng 0, độ dài 10-11 số">
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="password" class="form-label text-muted">Mật khẩu <span class="text-danger">*</span></label>
                            <input type="password" class="form-control" id="password" name="password" required minlength="6">
                        </div>
                        <div class="col-md-6 mb-4">
                            <label for="confirm" class="form-label text-muted">Xác nhận mật khẩu <span class="text-danger">*</span></label>
                            <input type="password" class="form-control" id="confirm" name="confirm" required minlength="6">
                        </div>
                    </div>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary btn-lg rounded-pill shadow-sm">Đăng Ký</button>
                    </div>
                </form>
                
                <div class="text-center mt-4">
                    <p class="text-muted mb-0">Đã có tài khoản? <a href="${pageContext.request.contextPath}/login.jsp" class="text-primary text-decoration-none fw-bold">Đăng nhập</a></p>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/common/footer.jsp" />
