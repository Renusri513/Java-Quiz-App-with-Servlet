

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class InsertTopicServlet
 */
@WebServlet("/InsertTopicServlet")
public class InsertTopicServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public InsertTopicServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
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
	            String topic_name = request.getParameter("topic_name");
	            

	            
	           

	            // Insert into the user table
	            String queryTopic = "INSERT INTO topic (topic_name) VALUES (?)";
	            psUser = con.prepareStatement(queryTopic);
	            psUser.setString(1, topic_name);
	            

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

	    // Method to hash the password using SHA-1
	  
	}
