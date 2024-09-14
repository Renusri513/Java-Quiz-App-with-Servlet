import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/QuizzesbyTopicDiffServlet")
public class QuizzesbyTopicDiffServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        // Extract parameters
        String topicIdParam = request.getParameter("topic");
        String difficulty = request.getParameter("difficulty");

        // Validate and parse the topic ID
        int topicId = -1;
        try {
            topicId = Integer.parseInt(topicIdParam);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Invalid topic ID\"}");
            return;
        }

        // Database connection details
        String url = "jdbc:mysql://localhost:3306/javaquizapp";
        String user = "root";
        String password = "";

        // Prepare a JSON response
        StringBuilder json = new StringBuilder("[");

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            // Fetch quizzes based on topic and difficulty
            String query = "SELECT quiz_id, quiz_name FROM quiz WHERE topic_id = ? AND difficulty = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, topicId);
            stmt.setString(2, difficulty);
            ResultSet rs = stmt.executeQuery();
            
            boolean firstQuiz = true;
            while (rs.next()) {
                if (!firstQuiz) {
                    json.append(",");
                }
                json.append("{\"quiz_id\":").append(rs.getInt("quiz_id"))
                    .append(",\"quiz_name\":\"").append(rs.getString("quiz_name"))
                    .append("\"}");
                firstQuiz = false;
            }
            json.append("]");

            out.print(json.toString());

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"An error occurred\"}");
        } finally {
            out.close();
        }
    }
}
