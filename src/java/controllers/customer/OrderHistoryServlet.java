package controllers.customer;

import dal.OrderDAO;
import models.Account;
import models.Order;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// Renamed to OrderHistoryServlet to match 1-project-overview.md spec.
// URL pattern uses "order-history" for customer-facing route.
@WebServlet(name = "OrderHistoryServlet", urlPatterns = {"/customer/order-history"})
public class OrderHistoryServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Account user = (Account) request.getSession(false).getAttribute("user");
        List<Order> orders = orderDAO.getOrdersByAccountId(user.getAccountId());
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/customer/order-history.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        Account user = (Account) request.getSession(false).getAttribute("user");

        if ("cancel".equals(action)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                boolean success = orderDAO.cancelOrder(orderId, user.getAccountId());
                if (success) {
                    request.getSession().setAttribute("successMsg", "Đơn hàng #" + orderId + " đã được hủy thành công.");
                } else {
                    request.getSession().setAttribute("errorMsg", "Không thể hủy đơn hàng này. Chỉ có thể hủy đơn đang ở trạng thái 'Chờ xử lý'.");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMsg", "Yêu cầu không hợp lệ.");
            }
        }
        response.sendRedirect(request.getContextPath() + "/customer/order-history");
    }
}
