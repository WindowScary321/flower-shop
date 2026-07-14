package controllers.customer;

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

@WebServlet(name = "FlowerCatalogServlet", urlPatterns = {"/flower-catalog"})
public class FlowerCatalogServlet extends HttpServlet {

    private final FlowerDAO flowerDAO = new FlowerDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
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
        int pageSize = 12; 
        try {
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            }
        } catch (NumberFormatException e) {
        }

        int totalRecords = flowerDAO.countFlowers(keyword, categoryId, minPrice, maxPrice, true);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }

        List<Flower> flowers = flowerDAO.searchFlowersPaging(keyword, categoryId, minPrice, maxPrice, true, page, pageSize);
        List<Category> categories = categoryDAO.getAllCategories();

        request.setAttribute("flowers", flowers);
        request.setAttribute("categories", categories);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        
        request.setAttribute("keyword", keyword != null ? keyword : "");
        request.setAttribute("categoryId", categoryId);
        request.setAttribute("minPrice", minPrice >= 0 ? minPrice : "");
        request.setAttribute("maxPrice", maxPrice >= 0 ? maxPrice : "");
        
        request.getRequestDispatcher("/flower-catalog.jsp").forward(request, response);
    }
}
