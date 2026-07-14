<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/common/header.jsp" />

<div class="row mt-4 mb-5">
    <!-- Sidebar -->
    <div class="col-md-3">
        <jsp:include page="/common/sidebar-admin.jsp" />
    </div>
    
    <!-- Main Content -->
    <div class="col-md-9">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-primary fw-bold">Quản Lý Danh Mục</h2>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addModal">
                <i class="bi bi-plus-circle"></i> Thêm danh mục
            </button>
        </div>

        <c:if test="${not empty sessionScope.successMsg}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${sessionScope.successMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="successMsg" scope="session"/>
        </c:if>
        
        <c:if test="${not empty sessionScope.errorMsg}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${sessionScope.errorMsg}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <c:remove var="errorMsg" scope="session"/>
        </c:if>

        <div class="card shadow-sm border-0">
            <div class="card-body p-0">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-4">ID</th>
                            <th>Tên danh mục</th>
                            <th>Mô tả</th>
                            <th class="text-center" style="width: 150px;">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${categories}">
                            <tr>
                                <td class="ps-4 fw-bold text-secondary">#${c.categoryId}</td>
                                <td><span class="badge bg-info text-dark fs-6">${c.categoryName}</span></td>
                                <td class="text-muted">${c.description}</td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-outline-primary me-1" 
                                            data-bs-toggle="modal" data-bs-target="#editModal"
                                            onclick="fillEditModal(${c.categoryId}, '${c.categoryName}', '${c.description}')">
                                        <i class="bi bi-pencil"></i>
                                    </button>
                                    <a href="${pageContext.request.contextPath}/admin/manage-categories?action=delete&id=${c.categoryId}" 
                                       class="btn btn-sm btn-outline-danger"
                                       onclick="return confirm('Bạn có chắc chắn muốn xóa danh mục này? Các hoa thuộc danh mục này sẽ bị mất liên kết.');">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty categories}">
                            <tr>
                                <td colspan="4" class="text-center py-4 text-muted">Chưa có danh mục nào.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Add Modal -->
<div class="modal fade" id="addModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/manage-categories" method="POST">
                <input type="hidden" name="action" value="add">
                <div class="modal-header">
                    <h5 class="modal-title">Thêm Danh Mục Mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Tên danh mục <span class="text-danger">*</span></label>
                        <input type="text" name="categoryName" class="form-control" required maxlength="100">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Mô tả</label>
                        <textarea name="description" class="form-control" rows="3" maxlength="255"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">Lưu</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Modal -->
<div class="modal fade" id="editModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/manage-categories" method="POST">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="categoryId" id="edit-id">
                <div class="modal-header">
                    <h5 class="modal-title">Sửa Danh Mục</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">Tên danh mục <span class="text-danger">*</span></label>
                        <input type="text" name="categoryName" id="edit-name" class="form-control" required maxlength="100">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Mô tả</label>
                        <textarea name="description" id="edit-desc" class="form-control" rows="3" maxlength="255"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">Cập nhật</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function fillEditModal(id, name, desc) {
        document.getElementById('edit-id').value = id;
        document.getElementById('edit-name').value = name;
        document.getElementById('edit-desc').value = desc;
    }
</script>

<jsp:include page="/common/footer.jsp" />
