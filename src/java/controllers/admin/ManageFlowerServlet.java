package controllers.admin;

import dal.CategoryDAO;
import dal.FlowerDAO;
import models.Category;
import models.Flower;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.ActivityLogger;

@WebServlet(name = "ManageFlowerServlet", urlPatterns = {"/admin/manage-flowers"})
public class ManageFlowerServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "delete":
                deleteFlower(request, response);
                break;
            default:
                listFlowers(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            addFlower(request, response);
        } else if ("edit".equals(action)) {
            editFlower(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/manage-flowers");
        }
    }

    private void listFlowers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        
        int categoryId = 0;
        try {
            String categoryIdStr = request.getParameter("categoryId");
            if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
                categoryId = Integer.parseInt(categoryIdStr);
            }
        } catch (NumberFormatException e) {
        }
        
        double minPrice = -1;
        try {
            String minPriceStr = request.getParameter("minPrice");
            if (minPriceStr != null && !minPriceStr.isEmpty()) {
                minPrice = Double.parseDouble(minPriceStr);
            }
        } catch (NumberFormatException e) {
        }
        
        double maxPrice = -1;
        try {
            String maxPriceStr = request.getParameter("maxPrice");
            if (maxPriceStr != null && !maxPriceStr.isEmpty()) {
                maxPrice = Double.parseDouble(maxPriceStr);
            }
        } catch (NumberFormatException e) {
        }

        int page = 1;
        int pageSize = 10; 
        try {
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            }
        } catch (NumberFormatException e) {
        }

        FlowerDAO flowerDAO = new FlowerDAO();
        int totalRecords = flowerDAO.countFlowers(keyword, categoryId, minPrice, maxPrice, false);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }

        List<Flower> flowers = flowerDAO.searchFlowersPaging(keyword, categoryId, minPrice, maxPrice, false, page, pageSize);
        flowerDAO.close();
        
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categories = categoryDAO.getAllCategories();
        categoryDAO.close();
        
        request.setAttribute("flowers", flowers);
        request.setAttribute("categories", categories);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        
        request.setAttribute("keyword", keyword != null ? keyword : "");
        request.setAttribute("categoryId", categoryId);
        request.setAttribute("minPrice", minPrice >= 0 ? minPrice : "");
        request.setAttribute("maxPrice", maxPrice >= 0 ? maxPrice : "");
        
        request.getRequestDispatcher("/admin/manage-flowers.jsp").forward(request, response);
    }

    private void addFlower(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String flowerName = request.getParameter("flowerName");
            if (flowerName == null || flowerName.trim().isEmpty()) {
                throw new IllegalArgumentException("Tên sản phẩm không được để trống!");
            }
            
            String categoryIdStr = request.getParameter("categoryId");
            if (categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Vui lòng chọn danh mục!");
            }

            double price = Double.parseDouble(request.getParameter("price"));
            if (price <= 0) {
                throw new IllegalArgumentException("Giá sản phẩm phải lớn hơn 0!");
            }

            int quantity = Integer.parseInt(request.getParameter("quantity"));
            if (quantity < 0) {
                throw new IllegalArgumentException("Số lượng không được âm!");
            }

            Flower f = new Flower();
            f.setFlowerName(flowerName);
            f.setUnit(request.getParameter("unit"));
            f.setPrice(price);
            f.setQuantity(quantity);
            f.setImage(request.getParameter("image"));
            f.setDescription(request.getParameter("description"));
            f.setCategoryId(Integer.parseInt(categoryIdStr));
            
            String discountStr = request.getParameter("discount");
            int discount = (discountStr != null && !discountStr.trim().isEmpty()) ? Integer.parseInt(discountStr) : 0;
            if (discount < 0 || discount > 100) {
                throw new IllegalArgumentException("Giảm giá phải từ 0 đến 100%!");
            }
            f.setDiscount(discount);
            
            f.setStatus("1".equals(request.getParameter("status")));
            
            FlowerDAO flowerDAO = new FlowerDAO();
            flowerDAO.insertFlower(f);
            flowerDAO.close();
            ActivityLogger.log(request, "FLOWER_CREATE", "Thêm sản phẩm mới: " + flowerName);
            request.getSession().setAttribute("successMsg", "Thêm sản phẩm hoa thành công!");
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMsg", "Giá trị số không hợp lệ!");
        } catch (IllegalArgumentException e) {
            request.getSession().setAttribute("errorMsg", e.getMessage());
        } catch (Exception e) {
            request.getSession().setAttribute("errorMsg", "Đã xảy ra lỗi hệ thống khi thêm hoa.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-flowers");
    }

    private void editFlower(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int flowerId = Integer.parseInt(request.getParameter("flowerId"));
            
            String flowerName = request.getParameter("flowerName");
            if (flowerName == null || flowerName.trim().isEmpty()) {
                throw new IllegalArgumentException("Tên sản phẩm không được để trống!");
            }
            
            String categoryIdStr = request.getParameter("categoryId");
            if (categoryIdStr == null || categoryIdStr.trim().isEmpty()) {
                throw new IllegalArgumentException("Vui lòng chọn danh mục!");
            }

            double price = Double.parseDouble(request.getParameter("price"));
            if (price <= 0) {
                throw new IllegalArgumentException("Giá sản phẩm phải lớn hơn 0!");
            }

            int quantity = Integer.parseInt(request.getParameter("quantity"));
            if (quantity < 0) {
                throw new IllegalArgumentException("Số lượng không được âm!");
            }

            Flower f = new Flower();
            f.setFlowerId(flowerId);
            f.setFlowerName(flowerName);
            f.setUnit(request.getParameter("unit"));
            f.setPrice(price);
            f.setQuantity(quantity);
            f.setImage(request.getParameter("image"));
            f.setDescription(request.getParameter("description"));
            f.setCategoryId(Integer.parseInt(categoryIdStr));
            
            String discountStr = request.getParameter("discount");
            int discount = (discountStr != null && !discountStr.trim().isEmpty()) ? Integer.parseInt(discountStr) : 0;
            if (discount < 0 || discount > 100) {
                throw new IllegalArgumentException("Giảm giá phải từ 0 đến 100%!");
            }
            f.setDiscount(discount);
            
            f.setStatus("1".equals(request.getParameter("status")));
            
            FlowerDAO flowerDAO = new FlowerDAO();
            flowerDAO.updateFlower(f);
            flowerDAO.close();
            ActivityLogger.log(request, "FLOWER_UPDATE", "Cập nhật sản phẩm: " + flowerName);
            request.getSession().setAttribute("successMsg", "Cập nhật sản phẩm hoa thành công!");
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMsg", "Giá trị số không hợp lệ!");
        } catch (IllegalArgumentException e) {
            request.getSession().setAttribute("errorMsg", e.getMessage());
        } catch (Exception e) {
            request.getSession().setAttribute("errorMsg", "Đã xảy ra lỗi hệ thống khi cập nhật hoa.");
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-flowers");
    }

    private void deleteFlower(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            FlowerDAO flowerDAO = new FlowerDAO();
            boolean deleted = flowerDAO.deleteFlower(id);
            flowerDAO.close();
            if (deleted) {
                ActivityLogger.log(request, "FLOWER_DELETE", "Xóa sản phẩm hoa (ID: " + id + ")");
                request.getSession().setAttribute("successMsg", "Xóa sản phẩm hoa thành công!");
            } else {
                ActivityLogger.log(request, "FLOWER_DELETE", "Ẩn sản phẩm hoa (ID: " + id + ") do đang có đơn hàng");
                request.getSession().setAttribute("successMsg", "Sản phẩm đang nằm trong đơn hàng nên đã được ẩn (ngừng kinh doanh) thay vì xóa hoàn toàn.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMsg", "ID không hợp lệ!");
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-flowers");
    }
}
