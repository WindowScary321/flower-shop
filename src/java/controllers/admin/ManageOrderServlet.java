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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String status = request.getParameter("status");
        String fromDate = request.getParameter("fromDate");
        String toDate = request.getParameter("toDate");

        int page = 1;
        int pageSize = 10;
        try {
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            }
        } catch (NumberFormatException e) {
        }

        OrderDAO orderDAO = new OrderDAO();
        int totalRecords = orderDAO.countOrders(0, status, fromDate, toDate);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }

        List<Order> orders = orderDAO.searchOrdersPaging(0, status, fromDate, toDate, page, pageSize);
        orderDAO.close();
        
        request.setAttribute("orders", orders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("status", status != null ? status : "");
        request.setAttribute("fromDate", fromDate != null ? fromDate : "");
        request.setAttribute("toDate", toDate != null ? toDate : "");

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
                String deliveryTimeStr = request.getParameter("deliveryTime");
                
                java.sql.Timestamp deliveryTime = null;
                try {
                    if (deliveryTimeStr != null && !deliveryTimeStr.trim().isEmpty()) {
                        deliveryTime = java.sql.Timestamp.valueOf(deliveryTimeStr.replace("T", " ") + ":00");
                    }
                } catch (IllegalArgumentException e) {
                    request.getSession().setAttribute("errorMsg", "Định dạng thời gian giao hàng không hợp lệ.");
                    response.sendRedirect(request.getContextPath() + "/admin/manage-orders");
                    return;
                }
                
                OrderDAO orderDAO = new OrderDAO();
                Order order = orderDAO.getOrderById(orderId);
                if (order != null && deliveryTime != null && deliveryTime.before(order.getOrderDate())) {
                    orderDAO.close();
                    request.getSession().setAttribute("errorMsg", "Thời gian giao hàng không được thiết lập trước thời gian đặt hàng.");
                    response.sendRedirect(request.getContextPath() + "/admin/manage-orders");
                    return;
                }
                
                if (order != null && (order.getStatus().equals("Đã giao") || order.getStatus().equals("Đã hủy"))) {
                    orderDAO.close();
                    request.getSession().setAttribute("errorMsg", "Không thể cập nhật đơn hàng đã giao hoặc đã hủy.");
                    response.sendRedirect(request.getContextPath() + "/admin/manage-orders");
                    return;
                }
                
                if (newStatus != null && (newStatus.equals("Chờ xử lý") || newStatus.equals("Đang giao") || newStatus.equals("Đã giao"))) {
                    orderDAO.updateOrderStatusAndDeliveryTime(orderId, newStatus, deliveryTime);
                    orderDAO.close();
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
