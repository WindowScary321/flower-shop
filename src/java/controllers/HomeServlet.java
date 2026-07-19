package controllers;

import dal.FlowerDAO;
import models.Flower;
import java.io.IOException;
import java.util.List;
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
        
        // Lấy danh sách các hoa đang được bán (Status = 1)
        FlowerDAO flowerDAO = new FlowerDAO();
        List<Flower> activeFlowers = flowerDAO.getActiveFlowers();
        flowerDAO.close();
        
        // Nếu số lượng hoa nhiều, ta có thể giới hạn lấy top 8 hoa mới nhất
        if (activeFlowers.size() > 8) {
            activeFlowers = activeFlowers.subList(0, 8);
        }
        
        request.setAttribute("featuredFlowers", activeFlowers);
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
