<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="/common/header.jsp" />

<div class="row mt-4 mb-5">
    <div class="col-md-3">
        <jsp:include page="/common/sidebar-admin.jsp" />
    </div>
    
    <div class="col-md-9">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-primary fw-bold">Quản Lý Sản Phẩm Hoa</h2>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addModal">
                <i class="bi bi-plus-circle"></i> Thêm sản phẩm
            </button>
        </div>

        <!-- Filter Form -->
        <div class="card shadow-sm border-0 mb-4">
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/admin/manage-flowers" method="GET" class="row g-3">
                    <div class="col-md-3">
                        <input type="text" name="keyword" class="form-control" placeholder="Tìm tên hoa..." value="${keyword}">
                    </div>
                    <div class="col-md-3">
                        <select class="form-select" name="categoryId">
                            <option value="">Tất cả danh mục</option>
                            <c:forEach var="c" items="${categories}">
                                <option value="${c.categoryId}" ${categoryId == c.categoryId ? 'selected' : ''}>${c.categoryName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <input type="number" name="minPrice" class="form-control" placeholder="Giá từ" value="${minPrice}" min="0">
                    </div>
                    <div class="col-md-2">
                        <input type="number" name="maxPrice" class="form-control" placeholder="Đến giá" value="${maxPrice}" min="0">
                    </div>
                    <div class="col-md-2 d-grid">
                        <button type="submit" class="btn btn-primary"><i class="bi bi-search"></i> Lọc</button>
                    </div>
                </form>
            </div>
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
            <div class="card-body p-0 table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-4">Ảnh</th>
                            <th>Tên sản phẩm</th>
                            <th>Đơn vị tính</th>
                            <th>Danh mục</th>
                            <th>Giá bán</th>
                            <th>Giảm giá</th>
                            <th>Kho</th>
                            <th>Trạng thái</th>
                            <th class="text-center">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="f" items="${flowers}">
                            <tr>
                                <td class="ps-4">
                                    <c:set var="imgUrl" value="${pageContext.request.contextPath}/images/flowers/${empty f.image ? 'placeholder.jpg' : f.image}" />
                                    <c:if test="${not empty f.image and (f.image.startsWith('http://') or f.image.startsWith('https://'))}">
                                        <c:set var="imgUrl" value="${f.image}" />
                                    </c:if>
                                    <img src="${imgUrl}" 
                                         class="rounded" style="width: 50px; height: 50px; object-fit: cover;" alt="hoa"
                                         onerror="this.src='https://placehold.co/100x100/f8f9fa/ff6b81?text=Flower'">
                                </td>
                                <td class="fw-bold">${f.flowerName}</td>
                                <td><span class="badge bg-secondary">${f.unit}</span></td>
                                <td>
                                    <c:forEach var="c" items="${categories}">
                                        <c:if test="${c.categoryId == f.categoryId}">${c.categoryName}</c:if>
                                    </c:forEach>
                                </td>
                                <td class="text-danger fw-bold"><fmt:formatNumber value="${f.price}" pattern="#,###"/> đ</td>
                                <td>
                                    <c:if test="${f.discount > 0}"><span class="badge bg-warning text-dark">-${f.discount}%</span></c:if>
                                    <c:if test="${f.discount == 0}"><span class="text-muted">-</span></c:if>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${f.quantity > 0}"><span class="badge bg-success">${f.quantity}</span></c:when>
                                        <c:otherwise><span class="badge bg-danger">Hết hàng</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${f.status}"><span class="badge bg-primary">Đang bán</span></c:if>
                                    <c:if test="${!f.status}"><span class="badge bg-secondary">Ngừng bán</span></c:if>
                                </td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-outline-primary edit-btn" 
                                            data-bs-toggle="modal" data-bs-target="#editModal"
                                            data-id="${f.flowerId}"
                                            data-name="<c:out value='${f.flowerName}'/>"
                                            data-unit="<c:out value='${f.unit}'/>"
                                            data-price="${f.price}"
                                            data-quantity="${f.quantity}"
                                            data-image="<c:out value='${f.image}'/>"
                                            data-desc="<c:out value='${f.description}'/>"
                                            data-category="${f.categoryId}"
                                            data-discount="${f.discount}"
                                            data-status="${f.status}">
                                        <i class="bi bi-pencil"></i>
                                    </button>
                                    <a href="${pageContext.request.contextPath}/admin/manage-flowers?action=delete&id=${f.flowerId}" 
                                       class="btn btn-sm btn-outline-danger"
                                       onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này?');">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty flowers}">
                            <tr>
                                <td colspan="8" class="text-center py-4 text-muted">Chưa có sản phẩm nào.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
        
        <!-- Pagination -->
        <c:if test="${totalPages > 1}">
            <nav aria-label="Page navigation" class="mt-4">
                <ul class="pagination justify-content-center">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="?page=${currentPage - 1}&keyword=${keyword}&categoryId=${categoryId}&minPrice=${minPrice}&maxPrice=${maxPrice}">Trang trước</a>
                    </li>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link" href="?page=${i}&keyword=${keyword}&categoryId=${categoryId}&minPrice=${minPrice}&maxPrice=${maxPrice}">${i}</a>
                        </li>
                    </c:forEach>
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="?page=${currentPage + 1}&keyword=${keyword}&categoryId=${categoryId}&minPrice=${minPrice}&maxPrice=${maxPrice}">Trang sau</a>
                    </li>
                </ul>
            </nav>
        </c:if>
    </div>
</div>

<!-- Add Modal -->
<div class="modal fade" id="addModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/manage-flowers" method="POST">
                <input type="hidden" name="action" value="add">
                <div class="modal-header">
                    <h5 class="modal-title">Thêm Sản Phẩm Mới</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Tên sản phẩm <span class="text-danger">*</span></label>
                            <input type="text" name="flowerName" class="form-control" required maxlength="150">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Đơn vị tính <span class="text-danger">*</span></label>
                            <select name="unit" class="form-select" required>
                                <option value="Cây" selected>Cây</option>
                                <option value="Bó">Bó</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Giá bán (VNĐ) <span class="text-danger">*</span></label>
                            <input type="number" name="price" class="form-control" min="0" step="1000" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Số lượng kho <span class="text-danger">*</span></label>
                            <input type="number" name="quantity" class="form-control" min="0" required>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Danh mục <span class="text-danger">*</span></label>
                            <select name="categoryId" class="form-select" required>
                                <c:forEach var="c" items="${categories}">
                                    <option value="${c.categoryId}">${c.categoryName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Giảm giá (%)</label>
                            <input type="number" name="discount" class="form-control" min="0" max="100" value="0">
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Trạng thái</label>
                            <select name="status" class="form-select">
                                <option value="1">Đang bán</option>
                                <option value="0">Ngừng bán</option>
                            </select>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Tên file ảnh (đặt trong thư mục images/flowers/)</label>
                        <input type="text" name="image" class="form-control" placeholder="vd: rose.jpg">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Mô tả chi tiết</label>
                        <textarea name="description" class="form-control" rows="3"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn btn-primary">Lưu sản phẩm</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Modal -->
<div class="modal fade" id="editModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <form action="${pageContext.request.contextPath}/admin/manage-flowers" method="POST">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="flowerId" id="edit-id">
                <div class="modal-header">
                    <h5 class="modal-title">Cập Nhật Sản Phẩm</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Tên sản phẩm <span class="text-danger">*</span></label>
                            <input type="text" name="flowerName" id="edit-name" class="form-control" required maxlength="150">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Đơn vị tính <span class="text-danger">*</span></label>
                            <select name="unit" id="edit-unit" class="form-select" required>
                                <option value="Cây">Cây</option>
                                <option value="Bó">Bó</option>
                            </select>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Giá bán (VNĐ) <span class="text-danger">*</span></label>
                            <input type="number" name="price" id="edit-price" class="form-control" min="0" step="1" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Số lượng kho <span class="text-danger">*</span></label>
                            <input type="number" name="quantity" id="edit-quantity" class="form-control" min="0" required>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Danh mục <span class="text-danger">*</span></label>
                            <select name="categoryId" id="edit-categoryId" class="form-select" required>
                                <c:forEach var="c" items="${categories}">
                                    <option value="${c.categoryId}">${c.categoryName}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Giảm giá (%)</label>
                            <input type="number" name="discount" id="edit-discount" class="form-control" min="0" max="100">
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label">Trạng thái</label>
                            <select name="status" id="edit-status" class="form-select">
                                <option value="1">Đang bán</option>
                                <option value="0">Ngừng bán</option>
                            </select>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Tên file ảnh</label>
                        <input type="text" name="image" id="edit-image" class="form-control">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Mô tả chi tiết</label>
                        <textarea name="description" id="edit-desc" class="form-control" rows="3"></textarea>
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
    document.addEventListener('DOMContentLoaded', function() {
        const editButtons = document.querySelectorAll('.edit-btn');
        editButtons.forEach(btn => {
            btn.addEventListener('click', function() {
                document.getElementById('edit-id').value = this.getAttribute('data-id');
                document.getElementById('edit-name').value = this.getAttribute('data-name');
                document.getElementById('edit-unit').value = this.getAttribute('data-unit');
                document.getElementById('edit-price').value = this.getAttribute('data-price');
                document.getElementById('edit-quantity').value = this.getAttribute('data-quantity');
                
                let img = this.getAttribute('data-image');
                document.getElementById('edit-image').value = (img === 'null' || !img) ? '' : img;
                
                let desc = this.getAttribute('data-desc');
                document.getElementById('edit-desc').value = (desc === 'null' || !desc) ? '' : desc;
                
                document.getElementById('edit-categoryId').value = this.getAttribute('data-category');
                document.getElementById('edit-discount').value = this.getAttribute('data-discount');
                document.getElementById('edit-status').value = this.getAttribute('data-status') === 'true' ? "1" : "0";
            });
        });
    });
</script>

<jsp:include page="/common/footer.jsp" />
