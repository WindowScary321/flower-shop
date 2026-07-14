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

@WebServlet(name = "FlowerServlet", urlPatterns = {"/admin/manage-flowers"})
public class FlowerServlet extends HttpServlet {

    private final FlowerDAO flowerDAO = new FlowerDAO();
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
        List<Flower> flowers = flowerDAO.getAllFlowers();
        List<Category> categories = categoryDAO.getAllCategories();
        
        request.setAttribute("flowers", flowers);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/admin/manage-flowers.jsp").forward(request, response);
    }

    private void addFlower(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Flower f = new Flower();
        f.setFlowerName(request.getParameter("flowerName"));
        f.setUnit(request.getParameter("unit"));
        f.setPrice(Double.parseDouble(request.getParameter("price")));
        f.setQuantity(Integer.parseInt(request.getParameter("quantity")));
        f.setImage(request.getParameter("image"));
        f.setDescription(request.getParameter("description"));
        f.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
        f.setStatus("1".equals(request.getParameter("status")));
        
        flowerDAO.insertFlower(f);
        request.getSession().setAttribute("successMsg", "Thêm sản phẩm hoa thành công!");
        response.sendRedirect(request.getContextPath() + "/admin/manage-flowers");
    }

    private void editFlower(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Flower f = new Flower();
        f.setFlowerId(Integer.parseInt(request.getParameter("flowerId")));
        f.setFlowerName(request.getParameter("flowerName"));
        f.setUnit(request.getParameter("unit"));
        f.setPrice(Double.parseDouble(request.getParameter("price")));
        f.setQuantity(Integer.parseInt(request.getParameter("quantity")));
        f.setImage(request.getParameter("image"));
        f.setDescription(request.getParameter("description"));
        f.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
        f.setStatus("1".equals(request.getParameter("status")));
        
        flowerDAO.updateFlower(f);
        request.getSession().setAttribute("successMsg", "Cập nhật sản phẩm hoa thành công!");
        response.sendRedirect(request.getContextPath() + "/admin/manage-flowers");
    }

    private void deleteFlower(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            flowerDAO.deleteFlower(id);
            request.getSession().setAttribute("successMsg", "Xóa sản phẩm hoa thành công!");
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMsg", "ID không hợp lệ!");
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-flowers");
    }
}
