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

@WebServlet(name = "CategoryServlet", urlPatterns = {"/admin/manage-categories"})
public class CategoryServlet extends HttpServlet {

    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "delete":
                deleteCategory(request, response);
                break;
            default:
                listCategories(request, response);
                break;
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
        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/admin/manage-categories.jsp").forward(request, response);
    }

    private void addCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String name = request.getParameter("categoryName");
        String description = request.getParameter("description");
        
        Category c = new Category();
        c.setCategoryName(name);
        c.setDescription(description);
        
        categoryDAO.insertCategory(c);
        request.getSession().setAttribute("successMsg", "Thêm danh mục thành công!");
        response.sendRedirect(request.getContextPath() + "/admin/manage-categories");
    }

    private void editCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("categoryId"));
        String name = request.getParameter("categoryName");
        String description = request.getParameter("description");
        
        Category c = new Category();
        c.setCategoryId(id);
        c.setCategoryName(name);
        c.setDescription(description);
        
        categoryDAO.updateCategory(c);
        request.getSession().setAttribute("successMsg", "Cập nhật danh mục thành công!");
        response.sendRedirect(request.getContextPath() + "/admin/manage-categories");
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            categoryDAO.deleteCategory(id);
            request.getSession().setAttribute("successMsg", "Xóa danh mục thành công!");
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMsg", "ID không hợp lệ!");
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-categories");
    }
}
