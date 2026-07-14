package filters;

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

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/admin/*", "/employee/*", "/customer/*", "/cart", "/checkout"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        
        String loginURI = req.getContextPath() + "/login.jsp";
        String path = req.getRequestURI().substring(req.getContextPath().length());
        
        Account user = (session != null) ? (Account) session.getAttribute("user") : null;
        
        if (user == null) {
            // Not logged in -> redirect to login
            req.setAttribute("error", "Bạn cần đăng nhập để truy cập chức năng này.");
            req.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        String role = user.getRole();
        
        // Authorization rules based on URL path
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
        
        // Let it proceed
        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}
