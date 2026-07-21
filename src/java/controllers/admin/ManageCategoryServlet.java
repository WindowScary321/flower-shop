package controllers.admin;

import dal.CategoryDAO;
import models.Category;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.ActivityLogger;

@WebServlet(name = "ManageCategoryServlet", urlPatterns = {"/admin/manage-categories"})
public class ManageCategoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";
        switch (action) {
            case "delete": deleteCategory(request, response); break;
            default: listCategories(request, response); break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("add".equals(action)) {
            addCategory(request, response);
        } else if ("edit".equals(action)) {
            editCategory(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/manage-categories");
        }
    }

    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categories = categoryDAO.getAllCategories();
        categoryDAO.close();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/admin/manage-categories.jsp").forward(request, response);
    }

    private void addCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String categoryName = request.getParameter("categoryName");
        if (categoryName == null || categoryName.trim().isEmpty()) {
            request.getSession().setAttribute("errorMsg", "Tên danh mục không được để trống!");
            response.sendRedirect(request.getContextPath() + "/admin/manage-categories");
            return;
        }
        Category c = new Category();
        c.setCategoryName(categoryName);
        c.setDescription(request.getParameter("description"));
        CategoryDAO categoryDAO = new CategoryDAO();
        categoryDAO.insertCategory(c);
        categoryDAO.close();
        ActivityLogger.log(request, "CATEGORY_CREATE", "Thêm danh mục mới: " + categoryName);
        request.getSession().setAttribute("successMsg", "Thêm danh mục thành công!");
        response.sendRedirect(request.getContextPath() + "/admin/manage-categories");
    }

    private void editCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String categoryName = request.getParameter("categoryName");
        if (categoryName == null || categoryName.trim().isEmpty()) {
            request.getSession().setAttribute("errorMsg", "Tên danh mục không được để trống!");
            response.sendRedirect(request.getContextPath() + "/admin/manage-categories");
            return;
        }
        Category c = new Category();
        c.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
        c.setCategoryName(categoryName);
        c.setDescription(request.getParameter("description"));
        CategoryDAO categoryDAO = new CategoryDAO();
        categoryDAO.updateCategory(c);
        categoryDAO.close();
        ActivityLogger.log(request, "CATEGORY_UPDATE", "Cập nhật danh mục: " + categoryName);
        request.getSession().setAttribute("successMsg", "Cập nhật danh mục thành công!");
        response.sendRedirect(request.getContextPath() + "/admin/manage-categories");
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            CategoryDAO categoryDAO = new CategoryDAO();
            boolean deleted = categoryDAO.deleteCategory(id);
            categoryDAO.close();
            if (deleted) {
                ActivityLogger.log(request, "CATEGORY_DELETE", "Xóa danh mục (ID: " + id + ")");
                request.getSession().setAttribute("successMsg", "Xóa danh mục thành công!");
            } else {
                request.getSession().setAttribute("errorMsg", "Danh mục đang chứa sản phẩm hoa, không thể xóa!");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMsg", "ID không hợp lệ!");
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-categories");
    }
}
