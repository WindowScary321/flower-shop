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
import jakarta.servlet.http.HttpSession;
import utils.ActivityLogger;

// Renamed to OrderHistoryServlet to match 1-project-overview.md spec.
// URL pattern uses "order-history" for customer-facing route.
@WebServlet(name = "OrderHistoryServlet", urlPatterns = {"/customer/order-history"})
public class OrderHistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Account user = (session != null) ? (Account) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String status = request.getParameter("status");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");

        int page = 1;
        int pageSize = 5;
        try {
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            }
        } catch (NumberFormatException e) {
        }

        OrderDAO orderDAO = new OrderDAO();
        int totalRecords = orderDAO.countOrders(user.getAccountId(), status, fromDate, toDate);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }

        List<Order> orders = orderDAO.searchOrdersPaging(user.getAccountId(), status, fromDate, toDate, page, pageSize);
        orderDAO.close();
        
        try (dal.OrderDetailDAO orderDetailDAO = new dal.OrderDetailDAO()) {
            for (Order o : orders) {
                o.setDetails(orderDetailDAO.getOrderDetailsByOrderId(o.getOrderId()));
            }
        }
        
        request.setAttribute("orders", orders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("status", status != null ? status : "");
        request.setAttribute("fromDate", fromDate != null ? fromDate : "");
        request.setAttribute("toDate", toDate != null ? toDate : "");

        request.getRequestDispatcher("/customer/order-history.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);
        Account user = (session != null) ? (Account) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if ("cancel".equals(action)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                OrderDAO orderDAO = new OrderDAO();
                boolean success = orderDAO.cancelOrder(orderId, user.getAccountId());
                orderDAO.close();
                if (success) {
                    ActivityLogger.log(request, "ORDER_CANCEL", "Hủy đơn hàng #" + orderId);
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
