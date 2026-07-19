package filter;

import models.Account;
import dal.AccountDAO;
import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Kiểm tra người dùng đã đăng nhập chưa (Authentication).
 * Áp dụng cho: /customer/*, /cart, /checkout*
 */
@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {"/customer/*", "/cart", "/checkout", "/checkout-success", "/payment-qr"})
public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        Account user = (session != null) ? (Account) session.getAttribute("user") : null;

        if (user != null) {
            AccountDAO accountDAO = new AccountDAO();
            Account dbUser = accountDAO.getAccountById(user.getAccountId());
            accountDAO.close();
            if (dbUser == null || !dbUser.isStatus()) {
                session.invalidate();
                user = null;
            }
        }

        if (user == null) {
            req.setAttribute("error", "Tài khoản của bạn đã bị khóa hoặc bạn chưa đăng nhập.");
            req.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}
