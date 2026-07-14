package filter;

import models.Account;
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
 * Kiểm tra quyền truy cập (Authorization) dựa trên Role.
 * - /admin/*  -> chỉ role 'admin'
 * - /employee/* -> role 'employee' hoặc 'admin'
 */
@WebFilter(filterName = "AuthorizationFilter", urlPatterns = {"/admin/*", "/employee/*", "/customer/*"})
public class AuthorizationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        Account user = (session != null) ? (Account) session.getAttribute("user") : null;

        if (user == null) {
            req.setAttribute("error", "Bạn cần đăng nhập để truy cập chức năng này.");
            req.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        String role = user.getRole();
        String path = req.getRequestURI().substring(req.getContextPath().length());

        if (path.startsWith("/admin") && !role.equals("admin")) {
            req.setAttribute("error", "Bạn không có quyền truy cập trang quản trị.");
            req.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        if (path.startsWith("/employee") && !(role.equals("employee") || role.equals("admin"))) {
            req.setAttribute("error", "Bạn không có quyền truy cập trang nhân viên.");
            req.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        if (path.startsWith("/customer") && !role.equals("customer")) {
            req.setAttribute("error", "Bạn không có quyền truy cập chức năng của khách hàng.");
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
