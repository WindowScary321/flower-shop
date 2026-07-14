package controllers.customer;

import dal.OrderDAO;
import models.Account;
import models.CartItem;
import models.Order;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    @SuppressWarnings("unchecked")
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            request.getSession(true).setAttribute("redirectAfterLogin", request.getContextPath() + "/checkout");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        Account user = (Account) session.getAttribute("user");
        request.setAttribute("user", user);
        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    @Override
    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        Account user = (Account) session.getAttribute("user");

        String receiverName = request.getParameter("receiverName");
        String receiverAddress = request.getParameter("receiverAddress");
        String receiverPhone = request.getParameter("receiverPhone");
        String paymentMethod = request.getParameter("paymentMethod");

        if (receiverName == null || receiverName.trim().isEmpty()
                || receiverAddress == null || receiverAddress.trim().isEmpty()
                || receiverPhone == null || receiverPhone.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin nhận hàng.");
            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
            return;
        }

        double total = 0;
        for (CartItem item : cart) {
            total += item.getTotalPrice();
        }

        Order order = new Order();
        order.setReceiverName(receiverName.trim());
        order.setReceiverAddress(receiverAddress.trim());
        order.setReceiverPhone(receiverPhone.trim());
        order.setTotalAmount(total);
        order.setAccountId(user.getAccountId());
        order.setPaymentMethod(paymentMethod != null && paymentMethod.equals("QR") ? "QR" : "COD");

        int orderId = orderDAO.createOrder(order, cart);

        if (orderId == -2) {
            request.setAttribute("error", "Một hoặc nhiều sản phẩm trong giỏ đã hết hàng. Vui lòng kiểm tra lại giỏ hàng.");
            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
            return;
        }

        if (orderId < 0) {
            request.setAttribute("error", "Đặt hàng thất bại do lỗi hệ thống. Vui lòng thử lại.");
            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
            return;
        }

        session.removeAttribute("cart");
        session.setAttribute("lastOrderId", orderId);
        
        if ("QR".equals(order.getPaymentMethod())) {
            response.sendRedirect(request.getContextPath() + "/payment-qr");
        } else {
            response.sendRedirect(request.getContextPath() + "/checkout-success");
        }
    }
}
