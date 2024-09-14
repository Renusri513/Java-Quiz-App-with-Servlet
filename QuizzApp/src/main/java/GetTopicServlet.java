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

/**
 * Servlet implementation class GetTopicServlet
 */
@WebServlet("/GetTopicServlet")
public class GetTopicServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public GetTopicServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();

		// Database connection details
		String url = "jdbc:mysql://localhost:3306/javaquizapp";
		String user = "root";
		String password = "";

		// Prepare a JSON response
		StringBuilder json = new StringBuilder();

		try (Connection conn = DriverManager.getConnection(url, user, password)) {
			// Query to fetch topics
			String query = "SELECT topic_id, topic_name FROM topic";
			PreparedStatement stmt = conn.prepareStatement(query);
			ResultSet rs = stmt.executeQuery();

			json.append("[");
			boolean firstTopic = true;
			while (rs.next()) {
				if (!firstTopic) {
					json.append(",");
				}
				json.append("{\"topic_id\":").append(rs.getInt("topic_id"))
					.append(",\"topic_name\":\"").append(rs.getString("topic_name"))
					.append("\"}");
				firstTopic = false;
			}
			json.append("]");
			
			// Send the JSON response
			out.print(json.toString());

		} catch (SQLException e) {
			// Log the exception and send an error response
			e.printStackTrace();
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			out.print("{\"error\":\"An error occurred while fetching topics\"}");
		} finally {
			// Ensure the writer is closed after the response is sent
			out.close();
		}
	}
}
