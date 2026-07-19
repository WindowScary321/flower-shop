<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/common/header.jsp" />

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<div class="row mt-4 mb-5">
    <div class="col-md-3">
        <jsp:include page="/common/sidebar-admin.jsp" />
    </div>
    
    <div class="col-md-9">
        <h2 class="text-primary fw-bold mb-4">Dashboard Báo Cáo & Thống Kê</h2>
        
        <!-- Summary Cards -->
        <div class="row g-3 mb-4 row-cols-1 row-cols-md-5">
            <div class="col">
                <div class="card bg-primary text-white h-100 shadow-sm border-0">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h6 class="card-title mb-0">Doanh thu hôm nay</h6>
                            <i class="bi bi-cash-stack fs-4"></i>
                        </div>
                        <h4 class="fw-bold mb-0"><fmt:formatNumber value="${summary.revenueToday}" pattern="#,###"/> đ</h4>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card bg-success text-white h-100 shadow-sm border-0">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h6 class="card-title mb-0">Doanh thu tháng này</h6>
                            <i class="bi bi-graph-up-arrow fs-4"></i>
                        </div>
                        <h4 class="fw-bold mb-0"><fmt:formatNumber value="${summary.revenueThisMonth}" pattern="#,###"/> đ</h4>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card bg-warning text-dark h-100 shadow-sm border-0">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h6 class="card-title mb-0">Tổng đơn hàng</h6>
                            <i class="bi bi-bag-check fs-4"></i>
                        </div>
                        <h4 class="fw-bold mb-0">${summary.totalOrders}</h4>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card bg-info text-dark h-100 shadow-sm border-0">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h6 class="card-title mb-0">Tổng khách hàng</h6>
                            <i class="bi bi-people fs-4"></i>
                        </div>
                        <h4 class="fw-bold mb-0">${summary.totalCustomers}</h4>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card bg-danger text-white h-100 shadow-sm border-0">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h6 class="card-title mb-0">Tỷ lệ hủy đơn</h6>
                            <i class="bi bi-x-octagon fs-4"></i>
                        </div>
                        <h4 class="fw-bold mb-0"><fmt:formatNumber value="${cancelledRatio}" pattern="#,##0.0"/>%</h4>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- Revenue Chart -->
            <div class="col-md-8 mb-4">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-header bg-white d-flex justify-content-between align-items-center">
                        <h5 class="mb-0 fw-bold">Biểu Đồ Doanh Thu ${selectedYear}</h5>
                        <form action="${pageContext.request.contextPath}/admin/dashboard" method="GET" class="d-flex gap-2">
                            <select name="year" class="form-select form-select-sm" onchange="this.form.submit()">
                                <c:forEach begin="${selectedYear - 2}" end="${selectedYear + 1}" var="y">
                                    <option value="${y}" ${y == selectedYear ? 'selected' : ''}>${y}</option>
                                </c:forEach>
                            </select>
                        </form>
                    </div>
                    <div class="card-body">
                        <canvas id="revenueChart" style="max-height: 300px;"></canvas>
                    </div>
                </div>
            </div>
            
            <!-- Top Selling Flowers -->
            <div class="col-md-4 mb-4">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-header bg-white">
                        <h5 class="mb-0 fw-bold">Top 5 Hoa Bán Chạy</h5>
                    </div>
                    <div class="card-body p-0">
                        <ul class="list-group list-group-flush">
                            <c:forEach var="flower" items="${topFlowers}" varStatus="loop">
                                <li class="list-group-item d-flex justify-content-between align-items-center py-3">
                                    <div class="d-flex align-items-center">
                                        <span class="badge ${loop.index == 0 ? 'bg-warning' : (loop.index == 1 ? 'bg-secondary' : (loop.index == 2 ? 'bg-danger' : 'bg-light text-dark'))} rounded-circle me-3 p-2" style="width: 32px; height: 32px; display: flex; align-items: center; justify-content: center;">
                                            ${loop.index + 1}
                                        </span>
                                        <div>
                                            <span class="fw-bold d-block">${flower.flowerName}</span>
                                            <small class="text-muted">Mã: #${flower.flowerId}</small>
                                        </div>
                                    </div>
                                    <span class="badge bg-primary rounded-pill px-3 py-2">
                                        ${flower.totalQuantitySold} <small>Đã bán</small>
                                    </span>
                                </li>
                            </c:forEach>
                            <c:if test="${empty topFlowers}">
                                <li class="list-group-item text-center text-muted py-4">Chưa có dữ liệu bán hàng.</li>
                            </c:if>
                        </ul>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <!-- Revenue By Category Chart -->
            <div class="col-md-6 mb-4">
                <div class="card shadow-sm border-0 h-100">
                    <div class="card-header bg-white">
                        <h5 class="mb-0 fw-bold">Doanh Thu Theo Danh Mục</h5>
                    </div>
                    <div class="card-body d-flex justify-content-center">
                        <canvas id="categoryChart" style="max-height: 300px; max-width: 300px;"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Prepare Data for Chart
    const labels = [];
    const dataPoints = [];
    
    <c:forEach var="item" items="${revenueData}">
        labels.push('Tháng ' + ${item.month});
        dataPoints.push(${item.totalRevenue});
    </c:forEach>

    // Render Chart
    const ctx = document.getElementById('revenueChart').getContext('2d');
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Doanh Thu (VNĐ)',
                data: dataPoints,
                backgroundColor: 'rgba(54, 162, 235, 0.6)',
                borderColor: 'rgba(54, 162, 235, 1)',
                borderWidth: 1,
                borderRadius: 4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: function(value, index, values) {
                            return new Intl.NumberFormat('vi-VN').format(value) + ' đ';
                        }
                    }
                }
            },
            plugins: {
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            let label = context.dataset.label || '';
                            if (label) {
                                label += ': ';
                            }
                            if (context.parsed.y !== null) {
                                label += new Intl.NumberFormat('vi-VN').format(context.parsed.y) + ' đ';
                            }
                            return label;
                        }
                    }
                }
            }
        }
    });

    // Prepare Data for Category Chart
    const catLabels = [];
    const catDataPoints = [];
    
    <c:forEach var="catItem" items="${revByCategory}">
        catLabels.push('${catItem.categoryName}');
        catDataPoints.push(${catItem.totalRevenue});
    </c:forEach>

    // Render Category Chart
    const ctxCat = document.getElementById('categoryChart').getContext('2d');
    new Chart(ctxCat, {
        type: 'doughnut',
        data: {
            labels: catLabels,
            datasets: [{
                label: 'Doanh Thu',
                data: catDataPoints,
                backgroundColor: [
                    'rgba(255, 99, 132, 0.7)',
                    'rgba(54, 162, 235, 0.7)',
                    'rgba(255, 206, 86, 0.7)',
                    'rgba(75, 192, 192, 0.7)',
                    'rgba(153, 102, 255, 0.7)',
                    'rgba(255, 159, 64, 0.7)'
                ],
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            let label = context.label || '';
                            if (label) {
                                label += ': ';
                            }
                            if (context.parsed !== null) {
                                label += new Intl.NumberFormat('vi-VN').format(context.parsed) + ' đ';
                            }
                            return label;
                        }
                    }
                }
            }
        }
    });
</script>

<jsp:include page="/common/footer.jsp" />
