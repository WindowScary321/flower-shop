package controllers.customer;

import dal.FlowerDAO;
import models.Flower;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "FlowerDetailServlet", urlPatterns = {"/detail"})
public class FlowerDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            FlowerDAO flowerDAO = new FlowerDAO();
            Flower flower = flowerDAO.getFlowerById(id);

            if (flower == null || !flower.isStatus()) {
                flowerDAO.close();
                response.sendRedirect(request.getContextPath() + "/flower-catalog");
                return;
            }

            // Lấy 10 sản phẩm liên quan
            List<Flower> relatedFlowers = new ArrayList<>();
            List<Flower> sameCatFlowers = flowerDAO.getFlowersByCategoryId(flower.getCategoryId());
            for (Flower f : sameCatFlowers) {
                if (f.getFlowerId() != flower.getFlowerId() && f.isStatus()) {
                    relatedFlowers.add(f);
                }
                if (relatedFlowers.size() >= 10) {
                    break;
                }
            }

            if (relatedFlowers.size() < 10) {
                List<Flower> allActive = flowerDAO.getActiveFlowers();
                for (Flower f : allActive) {
                    if (f.getFlowerId() != flower.getFlowerId() && f.isStatus()) {
                        boolean alreadyAdded = false;
                        for (Flower rf : relatedFlowers) {
                            if (rf.getFlowerId() == f.getFlowerId()) {
                                alreadyAdded = true;
                                break;
                            }
                        }
                        if (!alreadyAdded) {
                            relatedFlowers.add(f);
                        }
                    }
                    if (relatedFlowers.size() >= 10) {
                        break;
                    }
                }
            }

            flowerDAO.close();

            request.setAttribute("flower", flower);
            request.setAttribute("relatedFlowers", relatedFlowers);
            request.getRequestDispatcher("/flower-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/flower-catalog");
        }
    }
}
