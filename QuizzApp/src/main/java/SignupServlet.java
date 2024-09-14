import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection con = null;
        PreparedStatement psUser = null;

        try {
            // Load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish the database connection
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/javaquizapp", "root", "");
            con.setAutoCommit(false); // Start a transaction

            // Retrieve form parameters
            String user_name = request.getParameter("user_name");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phone_no = request.getParameter("phone_no");

            
           

            // Insert into the user table
            String queryUser = "INSERT INTO user (user_name, email, password, phone_no) VALUES (?, ?, ?, ?)";
            psUser = con.prepareStatement(queryUser);
            psUser.setString(1, user_name);
            psUser.setString(2, email);
            psUser.setString(3, password);
            psUser.setString(4, phone_no);

            int rowsAffected = psUser.executeUpdate();

            if (rowsAffected > 0) {
                con.commit(); // Commit the transaction
                // Redirect to result page with success parameter
                response.sendRedirect("result.jsp?status=success");
            } else {
                con.rollback(); // Rollback if no rows affected
                // Redirect back to result page with error parameter
                response.sendRedirect("result.jsp?status=failure");
            }
        } catch (Exception e) {
            e.printStackTrace();
            try {
                // Rollback the transaction if any error occurs
                if (con != null) {
                    con.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            // Redirect to result page with error parameter
            response.sendRedirect("result.jsp?status=failure");
        } finally {
            try {
                // Close resources
                if (psUser != null) {
                    psUser.close();
                }
                if (con != null) {
                    con.close();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
    }

    
}
