import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public LoginServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        try (PrintWriter out = response.getWriter()) {
            String user_name = request.getParameter("user_name");
            String password = request.getParameter("password");

            // Debugging output
            System.out.println("Received Username: " + user_name);
            System.out.println("Received Password: " + password);

            if (user_name == null || password == null || user_name.isEmpty() || password.isEmpty()) {
                out.println("{\"success\":false, \"message\":\"Username and password are required.\"}");
                return;
            }

            // Database connection
            String jdbcURL = "jdbc:mysql://localhost:3306/yourdatabase";
            String dbUser = "root";
            String dbPassword = "password";

            try (Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword)) {
                String sql = "SELECT * FROM users WHERE user_name = ? AND password = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, user_name);
                    stmt.setString(2, password);
                    try (ResultSet rs = stmt.executeQuery()) {
                        if (rs.next()) {
                            // Create session
                            HttpSession session1 = request.getSession();
                            session1.setAttribute("user", user_name);  // You can store more details if needed (like user ID)

                            // Send success response with redirect URL
                         // After this line in the servlet:
                            
                            response.sendRedirect("dashboard.jsp");

                            // Add this for debugging:
                            

                        } else {
                            // Invalid credentials
                            out.println("{\"success\":false, \"message\":\"Invalid username or password.\"}");
                        }
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("{\"success\":false, \"message\":\"An error occurred. Please try again later.\"}");
            }
        }
    }
}
