<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        </main>

        <footer class="bg-light pt-5 mt-auto border-top">
            <div class="container pb-4">
                <div class="row text-muted small">
                    <!-- Column 1: Kết nối -->
                    <div class="col-md-4 mb-3">
                        <h6 class="fw-bold text-secondary mb-4">KẾT NỐI FLOWER SHOP</h6>
                        <ul class="list-unstyled">
                            <li class="mb-3"><i class="bi bi-clock-fill text-success me-2 fs-5 align-middle"></i> 07:00
                                – 22:30</li>
                            <li class="mb-3"><img src="https://placehold.co/24x24/00a8e8/fff?text=Zalo"
                                    class="rounded-circle me-2 align-middle" alt="Zalo"> 0937.87.87.38</li>
                            <li class="mb-3"><i class="bi bi-telephone-fill text-primary me-2 fs-5 align-middle"></i>
                                0987.654.321</li>
                            <li class="mb-3"><i class="bi bi-geo-alt-fill text-success me-2 fs-5 align-middle"></i>
                                108-E2 Phuong Mai Street, Dong Da, Hanoi</li>
                        </ul>
                        <div class="mt-3">
                            <a href="#" class="text-secondary border rounded-circle p-2 me-2"><i
                                    class="bi bi-facebook"></i></a>
                            <a href="#" class="text-secondary border rounded-circle p-2 me-2"><i
                                    class="bi bi-twitter"></i></a>
                            <a href="#" class="text-secondary border rounded-circle p-2 me-2"><i
                                    class="bi bi-pinterest"></i></a>
                            <a href="#" class="text-secondary border rounded-circle p-2"><i
                                    class="bi bi-youtube"></i></a>
                        </div>
                    </div>

                    <!-- Column 2: Tài khoản -->
                    <div class="col-md-4 mb-3">
                        <h6 class="fw-bold text-secondary mb-4">TÀI KHOẢN CỦA BẠN</h6>
                        <ul class="list-unstyled">
                            <c:choose>
                                <c:when test="${empty sessionScope.user}">
                                    <li class="mb-3"><a
                                            href="${pageContext.request.contextPath}/login.jsp?error=Vui lòng đăng nhập để truy cập tài khoản"
                                            class="text-muted text-decoration-none"><span
                                                class="text-warning me-2">»</span>Tài khoản Của Bạn</a></li>
                                    <li class="mb-3"><a
                                            href="${pageContext.request.contextPath}/login.jsp?error=Vui lòng đăng nhập để xem đơn hàng"
                                            class="text-muted text-decoration-none"><span
                                                class="text-warning me-2">»</span>Đơn hàng của bạn</a></li>
                                    <li class="mb-3"><a
                                            href="${pageContext.request.contextPath}/login.jsp?error=Vui lòng đăng nhập để chỉnh sửa tài khoản"
                                            class="text-muted text-decoration-none"><span
                                                class="text-warning me-2">»</span>Chỉnh sửa tài khoản</a></li>
                                </c:when>
                                <c:otherwise>
                                    <li class="mb-3"><a href="${pageContext.request.contextPath}/profile"
                                            class="text-muted text-decoration-none"><span
                                                class="text-warning me-2">»</span>Tài khoản Của Bạn</a></li>
                                    <c:choose>
                                        <c:when test="${sessionScope.user.role == 'admin'}">
                                            <li class="mb-3"><a
                                                    href="${pageContext.request.contextPath}/admin/manage-orders"
                                                    class="text-muted text-decoration-none"><span
                                                        class="text-warning me-2">»</span>Đơn hàng của bạn</a></li>
                                        </c:when>
                                        <c:when test="${sessionScope.user.role == 'employee'}">
                                            <li class="mb-3"><a
                                                    href="${pageContext.request.contextPath}/employee/manage-orders"
                                                    class="text-muted text-decoration-none"><span
                                                        class="text-warning me-2">»</span>Đơn hàng của bạn</a></li>
                                        </c:when>
                                        <c:otherwise>
                                            <li class="mb-3"><a
                                                    href="${pageContext.request.contextPath}/customer/order-history"
                                                    class="text-muted text-decoration-none"><span
                                                        class="text-warning me-2">»</span>Đơn hàng của bạn</a></li>
                                        </c:otherwise>
                                    </c:choose>
                                    <li class="mb-3"><a href="${pageContext.request.contextPath}/profile"
                                            class="text-muted text-decoration-none"><span
                                                class="text-warning me-2">»</span>Chỉnh sửa tài khoản</a></li>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                    </div>

                    <!-- Column 3: Danh mục -->
                    <div class="col-md-4 mb-3">
                        <h6 class="fw-bold text-secondary mb-4">DANH MỤC SẢN PHẨM</h6>
                        <ul class="list-unstyled">
                            <li class="mb-3"><a href="${pageContext.request.contextPath}/flower-catalog?categoryId=2"
                                    class="text-muted text-decoration-none"><span class="text-warning me-2">»</span>Hoa
                                    Sinh Nhật</a></li>
                            <li class="mb-3"><a href="${pageContext.request.contextPath}/flower-catalog?categoryId=3"
                                    class="text-muted text-decoration-none"><span class="text-warning me-2">»</span>Hoa
                                    Khai Trương</a></li>
                            <li class="mb-3"><a href="${pageContext.request.contextPath}/flower-catalog?categoryId=4"
                                    class="text-muted text-decoration-none"><span class="text-warning me-2">»</span>Hoa
                                    Chia Buồn</a></li>
                            <li class="mb-3"><a href="${pageContext.request.contextPath}/flower-catalog?categoryId=5"
                                    class="text-muted text-decoration-none"><span class="text-warning me-2">»</span>Hoa
                                    Trang Trí</a></li>
                            <li class="mb-3"><a href="${pageContext.request.contextPath}/"
                                    class="text-muted text-decoration-none"><span class="text-warning me-2">»</span>Tiệm
                                    Hoa Gần Đây</a></li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Bottom Bar -->
            <div class="bg-white py-3 border-top">
                <div class="container d-flex justify-content-between align-items-center flex-wrap small text-muted">
                    <div>
                        <p class="mb-0">Copyright 2026 &copy; <strong>Flowershop.com.vn</strong></p>
                        <p class="mb-0">Địa Chỉ: 108-E2 Phuong Mai Street, Dong Da District, Hanoi</p>
                    </div>
                    <div>
                        <img src="https://placehold.co/40x25?text=VISA" alt="VISA" class="mx-1 border rounded">
                        <img src="https://placehold.co/40x25?text=PayPal" alt="PayPal" class="mx-1 border rounded">
                        <img src="https://placehold.co/40x25?text=Stripe" alt="Stripe" class="mx-1 border rounded">
                        <img src="https://placehold.co/40x25?text=Mastercard" alt="Mastercard"
                            class="mx-1 border rounded">
                        <img src="https://placehold.co/40x25?text=COD" alt="COD" class="mx-1 border rounded">
                    </div>
                </div>
            </div>
        </footer>

        <!-- Bootstrap 5 JS Bundle with Popper -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/main.js"></script>
        </body>

        </html>