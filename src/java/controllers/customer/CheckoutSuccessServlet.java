package controllers.customer;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// Handles post-checkout success page, clears session tracking attribute.
@WebServlet(name = "CheckoutSuccessServlet", urlPatterns = {"/checkout-success"})
public class CheckoutSuccessServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("lastOrderId") == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        int orderId = (int) session.getAttribute("lastOrderId");
        session.removeAttribute("lastOrderId");
        request.setAttribute("orderId", orderId);
        request.getRequestDispatcher("/checkout-success.jsp").forward(request, response);
    }
}
