import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ServletForAdminLogin")
public class ServletForAdminLogin extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database connection parameters
    private static final String DB_URL = "jdbc:mysql://localhost:3306/javaquizapp";
    private static final String DB_USER = "root"; // Replace with your database username
    private static final String DB_PASSWORD = ""; // Replace with your database password

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set response content type
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        // Retrieve username and password from the form
        String username = request.getParameter("user_name");
        String password = request.getParameter("password");
        System.out.println(username);
        System.out.println(password);

        // Initialize response JSON
        String jsonResponse;

        try {
            // Load database driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish connection
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Prepare SQL query to check login credentials
            String sql = "SELECT * FROM admin WHERE user_name = ? AND password = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);

            // Execute query
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                // Login successful
                jsonResponse = "{\"success\":true, \"message\":\"Login successful!\"}";
            } else {
                // Login failed
                jsonResponse = "{\"success\":false, \"message\":\"Invalid username or password.\"}";
            }

            // Close resources
            rs.close();
            pstmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse = "{\"success\":false, \"message\":\"An error occurred. Please try again later.\"}";
        }

        // Send response
        out.print(jsonResponse);
        out.flush();
    }
}
