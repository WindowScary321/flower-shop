<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Flower Shop</title>
            <!-- Bootstrap 5 CSS CDN -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
            <!-- Bootstrap Icons -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
            <!-- Custom CSS -->
            <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
        </head>

        <body>
            <!-- Pink Top Bar -->
            <div class="py-2" style="background-color: #fce2e8; color: #d63384;">
                <div class="container d-flex flex-column flex-md-row justify-content-between align-items-center">

                    <!-- Left: Logo -->
                    <a class="text-danger fw-bold fs-3 text-decoration-none mb-2 mb-md-0"
                        href="${pageContext.request.contextPath}/">
                        <i class="bi bi-flower1"></i> Flower Shop
                    </a>

                    <!-- Right: User/Login -->
                    <div class="d-flex align-items-center">
                        <ul class="navbar-nav flex-row align-items-center mb-0">
                            <!-- Guest -->
                            <c:if test="${empty sessionScope.user}">
                                <li class="nav-item me-3">
                                    <a class="nav-link text-danger fw-bold py-0"
                                        href="${pageContext.request.contextPath}/login.jsp">Đăng nhập</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link text-danger fw-bold py-0"
                                        href="${pageContext.request.contextPath}/register.jsp">Đăng ký</a>
                                </li>
                            </c:if>

                            <!-- Logged in User -->
                            <c:if test="${not empty sessionScope.user}">
                                <li class="nav-item dropdown me-3">
                                    <a class="nav-link dropdown-toggle text-danger fw-bold py-0" href="#"
                                        id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                                        <i class="bi bi-person-circle"></i> ${sessionScope.user.fullName}
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-end"
                                        style="position: absolute; right: 0; left: auto; z-index: 1050;">
                                        <li><a class="dropdown-item"
                                                href="${pageContext.request.contextPath}/profile">Hồ sơ cá nhân</a></li>
                                        <c:if test="${sessionScope.user.role == 'admin'}">
                                            <li><a class="dropdown-item"
                                                    href="${pageContext.request.contextPath}/admin/dashboard">Quản trị
                                                    viên</a></li>
                                        </c:if>
                                        <c:if test="${sessionScope.user.role == 'employee'}">
                                            <li><a class="dropdown-item"
                                                    href="${pageContext.request.contextPath}/employee/manage-orders">Quản
                                                    lý đơn hàng</a></li>
                                        </c:if>
                                        <c:if test="${sessionScope.user.role == 'customer'}">
                                            <li><a class="dropdown-item"
                                                    href="${pageContext.request.contextPath}/customer/order-history">Lịch
                                                    sử đơn hàng</a></li>
                                        </c:if>
                                        <li>
                                            <hr class="dropdown-divider">
                                        </li>
                                        <li><a class="dropdown-item text-danger"
                                                href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                                    </ul>
                                </li>
                                <c:if test="${sessionScope.user.role == 'customer'}">
                                    <li class="nav-item">
                                        <a class="nav-link text-danger fw-bold py-0"
                                            href="${pageContext.request.contextPath}/cart">
                                            <i class="bi bi-cart3"></i> Giỏ hàng
                                            <span class="badge bg-danger rounded-pill" id="cart-count">${empty
                                                sessionScope.cart ? 0 : sessionScope.cart.size()}</span>
                                        </a>
                                    </li>
                                </c:if>
                            </c:if>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- White Navbar for Categories (Hidden for Admin/Employee) -->
            <c:if test="${empty sessionScope.user or (sessionScope.user.role != 'admin' and sessionScope.user.role != 'employee')}">
            <c:set var="servletPath" value="${pageContext.request.servletPath}" />
            <c:set var="reqCategoryId" value="${requestScope.categoryId != null ? requestScope.categoryId : param.categoryId}" />
            <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm sticky-top">
                <div class="container">
                    <button class="navbar-toggler mx-auto" type="button" data-bs-toggle="collapse"
                        data-bs-target="#navbarNav">
                        <span class="navbar-toggler-icon"></span>
                    </button>

                    <div class="collapse navbar-collapse justify-content-center" id="navbarNav">
                        <ul class="navbar-nav">
                            <li class="nav-item">
                                <a class="nav-link fw-bold me-3 ${servletPath == '/index.jsp' && (empty reqCategoryId || reqCategoryId == 0) ? 'active-tab' : 'text-secondary'}"
                                   href="${pageContext.request.contextPath}/">TRANG CHỦ</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link fw-bold text-nowrap me-3 ${reqCategoryId == 1 ? 'active-tab' : 'text-secondary'}"
                                   href="${pageContext.request.contextPath}/flower-catalog?categoryId=1">HOA CƯỚI</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link fw-bold text-nowrap me-3 ${reqCategoryId == 2 ? 'active-tab' : 'text-secondary'}"
                                   href="${pageContext.request.contextPath}/flower-catalog?categoryId=2">HOA SINH NHẬT</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link fw-bold text-nowrap me-3 ${reqCategoryId == 3 ? 'active-tab' : 'text-secondary'}"
                                   href="${pageContext.request.contextPath}/flower-catalog?categoryId=3">HOA KHAI TRƯƠNG</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link fw-bold text-nowrap me-3 ${reqCategoryId == 4 ? 'active-tab' : 'text-secondary'}"
                                   href="${pageContext.request.contextPath}/flower-catalog?categoryId=4">HOA CHIA BUỒN</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link fw-bold text-nowrap ${reqCategoryId == 5 ? 'active-tab' : 'text-secondary'}"
                                   href="${pageContext.request.contextPath}/flower-catalog?categoryId=5">HOA TRANG TRÍ</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </nav>
            </c:if>
            <main class="container my-4 min-vh-100">