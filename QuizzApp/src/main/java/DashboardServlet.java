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
import java.util.HashMap;
import java.util.Map;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {
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
        Map<Integer, String> topicsMap = new HashMap<>();

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            // Fetch topics
            String topicQuery = "SELECT topic_id, topic_name FROM topic";
            PreparedStatement topicStmt = conn.prepareStatement(topicQuery);
            ResultSet topicRs = topicStmt.executeQuery();
            while (topicRs.next()) {
                int topicId = topicRs.getInt("topic_id");
                String topicName = topicRs.getString("topic_name");
                topicsMap.put(topicId, topicName);
            }
            
            boolean firstTopic = true;
            for (Map.Entry<Integer, String> entry : topicsMap.entrySet()) {
                if (!firstTopic) {
                    json.append(",");
                }
                int topicId = entry.getKey();
                String topicName = entry.getValue();
                json.append("{\"topic_id\":").append(topicId)
                    .append(",\"topic_name\":\"").append(topicName)
                    .append("\",\"quizzes\":[");
                
                // Fetch quizzes for each topic
                String quizQuery = "SELECT quiz_id, quiz_name, difficulty FROM quiz WHERE topic_id = ?";
                PreparedStatement quizStmt = conn.prepareStatement(quizQuery);
                quizStmt.setInt(1, topicId);
                ResultSet quizRs = quizStmt.executeQuery();
                
                boolean firstQuiz = true;
                while (quizRs.next()) {
                    if (!firstQuiz) {
                        json.append(",");
                    }
                    json.append("{\"quiz_id\":").append(quizRs.getInt("quiz_id"))
                        .append(",\"quiz_name\":\"").append(quizRs.getString("quiz_name"))
                        .append("\",\"difficulty\":\"").append(quizRs.getString("difficulty"))
                        .append("\"}");
                    firstQuiz = false;
                }
                json.append("]}");
                firstTopic = false;
            }
            json.append("]");

            out.print(json.toString());

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } finally {
            out.close();
        }
    }
}
