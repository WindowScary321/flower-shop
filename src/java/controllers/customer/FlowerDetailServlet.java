package controllers.customer;

import dal.FlowerDAO;
import models.Flower;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "FlowerDetailServlet", urlPatterns = {"/detail"})
public class FlowerDetailServlet extends HttpServlet {

    private final FlowerDAO flowerDAO = new FlowerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Flower flower = flowerDAO.getFlowerById(id);

            if (flower == null || !flower.isStatus()) {
                response.sendRedirect(request.getContextPath() + "/flower-catalog");
                return;
            }

            request.setAttribute("flower", flower);
            request.getRequestDispatcher("/flower-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/flower-catalog");
        }
    }
}
