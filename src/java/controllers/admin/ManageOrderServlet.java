package controllers.admin;

import dal.OrderDAO;
import models.Order;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ManageOrderServlet", urlPatterns = {"/admin/manage-orders"})
public class ManageOrderServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Order> orders = orderDAO.getAllOrders();
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/admin/manage-orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String action = request.getParameter("action");
        if ("updateStatus".equals(action)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String newStatus = request.getParameter("newStatus");
                if (newStatus != null && (newStatus.equals("Chờ xử lý") || newStatus.equals("Đang giao") || newStatus.equals("Đã giao"))) {
                    orderDAO.updateOrderStatus(orderId, newStatus);
                    request.getSession().setAttribute("successMsg", "Cập nhật trạng thái đơn hàng #" + orderId + " thành công.");
                } else {
                    request.getSession().setAttribute("errorMsg", "Trạng thái không hợp lệ.");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("errorMsg", "ID đơn hàng không hợp lệ.");
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/manage-orders");
    }
}
