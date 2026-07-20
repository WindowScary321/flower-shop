package controllers;

import dal.CategoryDAO;
import dal.FlowerDAO;
import models.Category;
import models.Flower;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home", ""})
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Lấy danh sách các hoa đang được bán (Status = 1) làm hoa nổi bật
        FlowerDAO flowerDAO = new FlowerDAO();
        List<Flower> activeFlowers = flowerDAO.getActiveFlowers();
        
        // Nếu số lượng hoa nhiều, ta có thể giới hạn lấy top 8 hoa mới nhất làm hoa nổi bật
        List<Flower> featuredFlowers = activeFlowers;
        if (featuredFlowers.size() > 8) {
            featuredFlowers = featuredFlowers.subList(0, 8);
        }
        request.setAttribute("featuredFlowers", featuredFlowers);
        
        // Lấy danh sách các danh mục và các sản phẩm tương ứng trong từng danh mục
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categories = categoryDAO.getAllCategories();
        categoryDAO.close();
        
        Map<Category, List<Flower>> categoryMap = new LinkedHashMap<>();
        for (Category cat : categories) {
            List<Flower> flowersInCat = flowerDAO.getFlowersByCategoryId(cat.getCategoryId());
            // Giới hạn hiển thị tối đa 4 hoa mỗi danh mục trên trang chủ
            if (flowersInCat.size() > 4) {
                flowersInCat = flowersInCat.subList(0, 4);
            }
            categoryMap.put(cat, flowersInCat);
        }
        flowerDAO.close();
        
        request.setAttribute("categoryMap", categoryMap);
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
