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
                        <c:out value="${error}" />
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
                        <div class="col-md-6 mb-3 position-relative">
                            <label for="password" class="form-label text-muted">Mật khẩu <span class="text-danger">*</span></label>
                            <input type="password" class="form-control" id="password" name="password" required pattern="^(?=.*[A-Za-z])(?=.*\d).{8,}$" title="Mật khẩu phải có ít nhất 8 ký tự, bao gồm cả chữ và số">
                            <div id="password-tooltip" class="d-none position-absolute p-2 bg-light border rounded shadow-sm text-start" style="top: 100%; left: 15px; right: 15px; z-index: 1000; font-size: 0.85rem;">
                                <div id="password-req-len" class="text-danger"><i class="bi bi-x-circle me-1"></i>Ít nhất 8 ký tự</div>
                                <div id="password-req-char" class="text-danger"><i class="bi bi-x-circle me-1"></i>Có cả chữ và số</div>
                            </div>
                        </div>
                        <div class="col-md-6 mb-4">
                            <label for="confirm" class="form-label text-muted">Xác nhận mật khẩu <span class="text-danger">*</span></label>
                            <input type="password" class="form-control" id="confirm" name="confirm" required pattern="^(?=.*[A-Za-z])(?=.*\d).{8,}$" title="Mật khẩu phải có ít nhất 8 ký tự, bao gồm cả chữ và số">
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

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const passwordInput = document.getElementById('password');
        const tooltip = document.getElementById('password-tooltip');
        const reqLen = document.getElementById('password-req-len');
        const reqLenIcon = reqLen.querySelector('i');
        const reqChar = document.getElementById('password-req-char');
        const reqCharIcon = reqChar.querySelector('i');

        const validatePassword = () => {
            const val = passwordInput.value;
            const hasLetter = /[a-zA-Z]/.test(val);
            const hasNumber = /\d/.test(val);

            if (val.length >= 8) {
                reqLen.classList.remove('text-danger');
                reqLen.classList.add('text-success');
                reqLenIcon.classList.remove('bi-x-circle');
                reqLenIcon.classList.add('bi-check-circle');
            } else {
                reqLen.classList.remove('text-success');
                reqLen.classList.add('text-danger');
                reqLenIcon.classList.remove('bi-check-circle');
                reqLenIcon.classList.add('bi-x-circle');
            }

            if (hasLetter && hasNumber) {
                reqChar.classList.remove('text-danger');
                reqChar.classList.add('text-success');
                reqCharIcon.classList.remove('bi-x-circle');
                reqCharIcon.classList.add('bi-check-circle');
            } else {
                reqChar.classList.remove('text-success');
                reqChar.classList.add('text-danger');
                reqCharIcon.classList.remove('bi-check-circle');
                reqCharIcon.classList.add('bi-x-circle');
            }
        };

        passwordInput.addEventListener('mouseenter', () => {
            tooltip.classList.remove('d-none');
            validatePassword();
        });

        passwordInput.addEventListener('mouseleave', () => {
            if (document.activeElement !== passwordInput) {
                tooltip.classList.add('d-none');
            }
        });

        passwordInput.addEventListener('focus', () => {
            tooltip.classList.remove('d-none');
            validatePassword();
        });

        passwordInput.addEventListener('blur', () => {
            tooltip.classList.add('d-none');
        });

        passwordInput.addEventListener('input', validatePassword);

        // Customize HTML5 Validation Messages in Vietnamese
        const usernameInput = document.getElementById('username');
        const fullnameInput = document.getElementById('fullname');
        const emailInput = document.getElementById('email');
        const phoneInput = document.getElementById('phone');
        const confirmInput = document.getElementById('confirm');

        usernameInput.addEventListener('invalid', function(e) {
            e.target.setCustomValidity("");
            if (!e.target.validity.valid) {
                if (e.target.value === "") {
                    e.target.setCustomValidity("Vui lòng nhập tên đăng nhập.");
                } else {
                    e.target.setCustomValidity("Tên đăng nhập từ 4-50 ký tự, chỉ gồm chữ và số.");
                }
            }
        });
        usernameInput.addEventListener('input', function(e) {
            e.target.setCustomValidity("");
        });

        fullnameInput.addEventListener('invalid', function(e) {
            e.target.setCustomValidity("");
            if (!e.target.validity.valid) {
                if (e.target.value === "") {
                    e.target.setCustomValidity("Vui lòng nhập họ và tên.");
                } else {
                    e.target.setCustomValidity("Họ và tên phải có ít nhất 2 ký tự.");
                }
            }
        });
        fullnameInput.addEventListener('input', function(e) {
            e.target.setCustomValidity("");
        });

        emailInput.addEventListener('invalid', function(e) {
            e.target.setCustomValidity("");
            if (!e.target.validity.valid) {
                if (e.target.value === "") {
                    e.target.setCustomValidity("Vui lòng nhập email của bạn.");
                } else {
                    e.target.setCustomValidity("Email không đúng định dạng (ví dụ: example@gmail.com).");
                }
            }
        });
        emailInput.addEventListener('input', function(e) {
            e.target.setCustomValidity("");
        });

        phoneInput.addEventListener('invalid', function(e) {
            e.target.setCustomValidity("");
            if (!e.target.validity.valid) {
                if (e.target.value === "") {
                    e.target.setCustomValidity("Vui lòng nhập số điện thoại.");
                } else {
                    e.target.setCustomValidity("Số điện thoại không hợp lệ (Bắt đầu bằng 0, độ dài 10-11 số).");
                }
            }
        });
        phoneInput.addEventListener('input', function(e) {
            e.target.setCustomValidity("");
        });

        passwordInput.addEventListener('invalid', function(e) {
            e.target.setCustomValidity("");
            if (!e.target.validity.valid) {
                if (e.target.value === "") {
                    e.target.setCustomValidity("Vui lòng nhập mật khẩu.");
                } else {
                    e.target.setCustomValidity("Mật khẩu phải có ít nhất 8 ký tự, bao gồm cả chữ và số.");
                }
            }
        });
        passwordInput.addEventListener('input', function(e) {
            e.target.setCustomValidity("");
        });

        confirmInput.addEventListener('invalid', function(e) {
            e.target.setCustomValidity("");
            if (!e.target.validity.valid) {
                if (e.target.value === "") {
                    e.target.setCustomValidity("Vui lòng xác nhận mật khẩu.");
                } else {
                    e.target.setCustomValidity("Mật khẩu xác nhận phải có ít nhất 8 ký tự, bao gồm cả chữ và số.");
                }
            }
        });
        confirmInput.addEventListener('input', function(e) {
            e.target.setCustomValidity("");
        });

        // Check if confirm password matches password
        const validateConfirm = () => {
            if (confirmInput.value !== passwordInput.value) {
                confirmInput.setCustomValidity("Mật khẩu xác nhận không khớp.");
            } else {
                confirmInput.setCustomValidity("");
            }
        };
        confirmInput.addEventListener('input', validateConfirm);
        passwordInput.addEventListener('input', validateConfirm);
    });
</script>

<jsp:include page="/common/footer.jsp" />
