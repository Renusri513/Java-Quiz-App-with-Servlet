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

@WebServlet("/AllQuizServlet")
public class AllQuizServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        // Database connection details
        String url = "jdbc:mysql://localhost:3306/javaquizapp";
        String user = "root";
        String password = "";

        // Prepare a JSON response
        StringBuilder json = new StringBuilder("[");

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            // Query to fetch quizzes along with topic details
            String query = "SELECT t.topic_id, t.topic_name, q.quiz_id, q.quiz_name, q.difficulty " +
                           "FROM topic t " +
                           "JOIN quiz q ON q.topic_id = t.topic_id";
            PreparedStatement stmt = conn.prepareStatement(query);
            ResultSet rs = stmt.executeQuery();

            boolean firstQuiz = true;
            while (rs.next()) {
                if (!firstQuiz) {
                    json.append(",");
                }
                json.append("{\"topic_id\":").append(rs.getInt("topic_id"))
                    .append(",\"topic_name\":\"").append(rs.getString("topic_name"))
                    .append("\",\"quiz_id\":").append(rs.getInt("quiz_id"))
                    .append(",\"quiz_name\":\"").append(rs.getString("quiz_name"))
                    .append("\",\"difficulty\":\"").append(rs.getString("difficulty"))
                    .append("\"}");
                firstQuiz = false;
            }
            json.append("]");

            out.print(json.toString());

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"An error occurred while fetching data\"}");
        } finally {
            out.close();
        }
    }
}
