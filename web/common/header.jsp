<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    <nav class="navbar navbar-expand-lg navbar-light bg-light shadow-sm sticky-top">
        <div class="container">
            <a class="navbar-brand text-primary fw-bold" href="${pageContext.request.contextPath}/">
                <i class="bi bi-flower1"></i> Flower Shop
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/">Trang Chủ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/flower-catalog">Sản Phẩm</a>
                    </li>
                </ul>

                <form class="d-flex mx-3" action="${pageContext.request.contextPath}/flower-catalog" method="GET">
                    <input class="form-control me-2" type="search" name="keyword" placeholder="Tìm hoa..." aria-label="Search">
                    <button class="btn btn-outline-primary" type="submit"><i class="bi bi-search"></i></button>
                </form>

                <ul class="navbar-nav">
                    <!-- Guest -->
                    <c:if test="${empty sessionScope.user}">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/login.jsp">Đăng nhập</a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-primary" href="${pageContext.request.contextPath}/register.jsp">Đăng ký</a>
                        </li>
                    </c:if>

                    <!-- Logged in User -->
                    <c:if test="${not empty sessionScope.user}">
                        <c:if test="${sessionScope.user.role == 'customer'}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/cart">
                                    <i class="bi bi-cart3"></i> Giỏ hàng 
                                    <span class="badge bg-danger rounded-pill" id="cart-count">
                                        ${empty sessionScope.cart ? 0 : sessionScope.cart.size()}
                                    </span>
                                </a>
                            </li>
                        </c:if>
                        
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                                <i class="bi bi-person-circle"></i> ${sessionScope.user.fullName}
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <c:if test="${sessionScope.user.role == 'admin'}">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard">Quản trị viên</a></li>
                                </c:if>
                                <c:if test="${sessionScope.user.role == 'employee'}">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/employee/manage-orders">Nhân viên</a></li>
                                </c:if>
                                <c:if test="${sessionScope.user.role == 'customer'}">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/customer/profile">Hồ sơ cá nhân</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/customer/order-history">Lịch sử đơn hàng</a></li>
                                </c:if>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
                            </ul>
                        </li>
                    </c:if>
                </ul>
            </div>
        </div>
    </nav>
    <main class="container my-4 min-vh-100">
