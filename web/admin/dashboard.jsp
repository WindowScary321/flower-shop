<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/common/header.jsp" />

<div class="row mt-4 mb-5">
    <div class="col-md-3">
        <jsp:include page="/common/sidebar-admin.jsp" />
    </div>
    
    <div class="col-md-9">
        <h2 class="text-primary fw-bold mb-4">Dashboard Quản Trị</h2>
        
        <div class="row g-4">
            <div class="col-md-4">
                <div class="card bg-primary text-white h-100 shadow-sm border-0">
                    <div class="card-body text-center">
                        <i class="bi bi-flower1 display-4 mb-3 d-block"></i>
                        <h4 class="card-title">Sản Phẩm Hoa</h4>
                        <a href="${pageContext.request.contextPath}/admin/manage-flowers" class="btn btn-light mt-2 rounded-pill px-4">Quản lý</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card bg-success text-white h-100 shadow-sm border-0">
                    <div class="card-body text-center">
                        <i class="bi bi-tags display-4 mb-3 d-block"></i>
                        <h4 class="card-title">Danh Mục</h4>
                        <a href="${pageContext.request.contextPath}/admin/manage-categories" class="btn btn-light mt-2 rounded-pill px-4">Quản lý</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card bg-warning text-dark h-100 shadow-sm border-0">
                    <div class="card-body text-center">
                        <i class="bi bi-people display-4 mb-3 d-block"></i>
                        <h4 class="card-title">Tài Khoản</h4>
                        <a href="${pageContext.request.contextPath}/admin/manage-accounts" class="btn btn-dark mt-2 rounded-pill px-4">Quản lý</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/common/footer.jsp" />
