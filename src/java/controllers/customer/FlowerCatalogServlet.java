package controllers.customer;

import dal.FlowerDAO;
import models.Flower;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "FlowerCatalogServlet", urlPatterns = {"/flower-catalog"})
public class FlowerCatalogServlet extends HttpServlet {

    private final FlowerDAO flowerDAO = new FlowerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String categoryIdStr = request.getParameter("categoryId");

        List<Flower> flowers;
        if (keyword != null && !keyword.trim().isEmpty()) {
            flowers = flowerDAO.searchFlowers(keyword.trim());
        } else if (categoryIdStr != null && !categoryIdStr.isEmpty()) {
            try {
                int categoryId = Integer.parseInt(categoryIdStr);
                flowers = flowerDAO.getFlowersByCategoryId(categoryId);
            } catch (NumberFormatException e) {
                flowers = flowerDAO.getActiveFlowers();
            }
        } else {
            flowers = flowerDAO.getActiveFlowers();
        }

        request.setAttribute("flowers", flowers);
        request.setAttribute("keyword", keyword);
        request.getRequestDispatcher("/flower-catalog.jsp").forward(request, response);
    }
}
