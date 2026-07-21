package controllers.customer;

import dal.FlowerDAO;
import models.CartItem;
import models.Flower;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import utils.ActivityLogger;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            request.getRequestDispatcher("/cart.jsp").forward(request, response);
            return;
        }

        switch (action) {
            case "remove":
                removeFromCart(request, response);
                break;
            default:
                request.getRequestDispatcher("/cart.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "add":
                addToCart(request, response);
                break;
            case "update":
                updateCart(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/cart");
        }
    }

    @SuppressWarnings("unchecked")
    private void addToCart(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            request.getSession(true).setAttribute("errorMsg", "Bạn cần đăng nhập để thêm sản phẩm vào giỏ hàng.");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int flowerId;
        int qty;
        try {
            flowerId = Integer.parseInt(request.getParameter("flowerId"));
            qty = Integer.parseInt(request.getParameter("quantity"));
            if (qty <= 0) qty = 1;
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        FlowerDAO flowerDAO = new FlowerDAO();
        Flower flower = flowerDAO.getFlowerById(flowerId);
        flowerDAO.close();
        if (flower == null || !flower.isStatus()) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
        }

        boolean found = false;
        for (CartItem item : cart) {
            if (item.getFlower().getFlowerId() == flowerId) {
                int newQty = item.getQuantity() + qty;
                if (newQty > flower.getQuantity()) newQty = flower.getQuantity();
                item.setQuantity(newQty);
                found = true;
                break;
            }
        }

        if (!found) {
            int safeQty = Math.min(qty, flower.getQuantity());
            cart.add(new CartItem(flower, safeQty));
        }

        session.setAttribute("cart", cart);
        
        ActivityLogger.log(request, "ADD_TO_CART", "Thêm sản phẩm " + flower.getFlowerName() + " (x" + qty + ") vào giỏ hàng");

        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }

    @SuppressWarnings("unchecked")
    private void updateCart(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            request.getSession(true).setAttribute("errorMsg", "Bạn cần đăng nhập để sử dụng giỏ hàng.");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        String[] flowerIds = request.getParameterValues("flowerId");
        String[] quantities = request.getParameterValues("quantity");

        if (flowerIds != null && quantities != null) {
            FlowerDAO flowerDAO = new FlowerDAO();
            boolean overQuantity = false;
            for (int i = 0; i < flowerIds.length; i++) {
                int fid = Integer.parseInt(flowerIds[i]);
                int q = Integer.parseInt(quantities[i]);
                if (q <= 0) {
                    cart.removeIf(item -> item.getFlower().getFlowerId() == fid);
                } else {
                    Flower f = flowerDAO.getFlowerById(fid);
                    if (f != null) {
                        int finalQ = Math.min(q, f.getQuantity());
                        if (q > f.getQuantity()) {
                            overQuantity = true;
                        }
                        for (CartItem item : cart) {
                            if (item.getFlower().getFlowerId() == fid) {
                                item.setQuantity(finalQ);
                                break;
                            }
                        }
                    }
                }
            }
            flowerDAO.close();
            if (overQuantity) {
                request.getSession().setAttribute("errorMsg", "Một số sản phẩm không đủ số lượng tồn kho nên đã được điều chỉnh lại.");
            }
        }

        session.setAttribute("cart", cart);
        ActivityLogger.log(request, "UPDATE_CART", "Cập nhật giỏ hàng thành công");
        response.sendRedirect(request.getContextPath() + "/cart");
    }

    @SuppressWarnings("unchecked")
    private void removeFromCart(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            request.getSession(true).setAttribute("errorMsg", "Bạn cần đăng nhập để sử dụng giỏ hàng.");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        if (session != null) {
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
            if (cart != null) {
                try {
                    int flowerId = Integer.parseInt(request.getParameter("id"));
                    cart.removeIf(item -> item.getFlower().getFlowerId() == flowerId);
                    session.setAttribute("cart", cart);
                    ActivityLogger.log(request, "REMOVE_FROM_CART", "Xóa sản phẩm có ID: " + flowerId + " khỏi giỏ hàng");
                } catch (NumberFormatException ignored) {}
            }
        }
        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
