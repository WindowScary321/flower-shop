package controllers.customer;

import dal.OrderDAO;
import models.Order;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "PaymentQRServlet", urlPatterns = {"/payment-qr"})
public class PaymentQRServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("lastOrderId") == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        int orderId = (int) session.getAttribute("lastOrderId");
        OrderDAO orderDAO = new OrderDAO();
        Order order = orderDAO.getOrderById(orderId);
        orderDAO.close();
        
        if (order == null || !"QR".equals(order.getPaymentMethod())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        request.setAttribute("order", order);
        request.getRequestDispatcher("/payment-qr.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("lastOrderId") == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        int orderId = (int) session.getAttribute("lastOrderId");
        String action = request.getParameter("action");
        
        if ("checkPayment".equals(action)) {
            // Cập nhật trạng thái thanh toán thành công
            OrderDAO orderDAO = new OrderDAO();
            orderDAO.updatePaymentStatus(orderId, true);
            orderDAO.close();
            // Sau khi thanh toán xong, chuyển về trang checkout-success
            response.sendRedirect(request.getContextPath() + "/checkout-success");
        } else {
            response.sendRedirect(request.getContextPath() + "/payment-qr");
        }
    }
}
