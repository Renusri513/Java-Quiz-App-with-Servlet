import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ViewQuizByAdminServlet")
public class ViewQuizByAdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        String quizIdStr = request.getParameter("quiz_id");
        if (quizIdStr == null || quizIdStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Missing or empty quiz_id\"}");
            out.flush();
            return;
        }

        int quizId;
        try {
            quizId = Integer.parseInt(quizIdStr);
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Invalid quiz_id format\"}");
            out.flush();
            return;
        }

        String url = "jdbc:mysql://localhost:3306/javaquizapp";
        String user = "root";
        String password = "";

        List<QuizQuestionDetails> quizDetails = new ArrayList<>();
        StringBuilder json = new StringBuilder("[");

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            String query = "SELECT * FROM quiz_questions WHERE quiz_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1, quizId);
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    int questionId = rs.getInt("question_id");
                    String quizName = escapeJson(rs.getString("quiz_name"));
                    String questionText = escapeJson(rs.getString("question_text"));
                    String typeName = escapeJson(rs.getString("type_name"));
                    int time = rs.getInt("time");
                    int optionId = rs.getInt("option_id");
                    String optionText = escapeJson(rs.getString("option_text"));
                    String isCorrect = rs.getString("is_correct_option");

                    QuizQuestionDetails detail = new QuizQuestionDetails(
                        quizId, quizName, questionId, questionText, typeName, time, optionId, optionText, isCorrect
                    );
                    quizDetails.add(detail);
                }
            }

            boolean firstDetail = true;
            for (QuizQuestionDetails detail : quizDetails) {
                if (!firstDetail) {
                    json.append(",");
                }
                json.append(detail.toString());
                firstDetail = false;
            }
            json.append("]");

            out.print(json.toString());
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"Server error occurred: " + e.getMessage() + "\"}");
            out.flush();
        } finally {
            out.close();
        }
    }

    // Helper method to escape special characters for JSON strings
    private String escapeJson(String text) {
        if (text == null) {
            return null;
        }
        return text.replace("\\", "\\\\")  // Escape backslashes
                   .replace("\"", "\\\"")  // Escape double quotes
                   .replace("\b", "\\b")   // Escape backspace
                   .replace("\f", "\\f")   // Escape form feed
                   .replace("\n", "\\n")   // Escape newlines
                   .replace("\r", "\\r")   // Escape carriage return
                   .replace("\t", "\\t")   // Escape tabs
                   .replace("{", "\\{")    // Escape curly braces
                   .replace("}", "\\}")    // Escape curly braces
                   .replace("[", "\\[")    // Escape square brackets
                   .replace("]", "\\]");   // Escape square brackets
    }
}

class QuizQuestionDetails {
    private int quizId;
    private String quizName;
    private int questionId;
    private String questionText;
    private String typeName;
    private int time;
    private int optionId;
    private String optionText;
    private String isCorrectOption;

    public QuizQuestionDetails(int quizId, String quizName, int questionId, String questionText, 
            String typeName, int time, int optionId, String optionText, String isCorrectOption) {
        this.quizId = quizId;
        this.quizName = quizName;
        this.questionId = questionId;
        this.questionText = questionText;
        this.typeName = typeName;
        this.time = time;
        this.optionId = optionId;
        this.optionText = optionText;
        this.isCorrectOption = isCorrectOption;
    }

    @Override
    public String toString() {
        return "{ \"quizId\": " + quizId +
                ", \"quizName\": \"" + quizName + "\"" +
                ", \"questionId\": " + questionId +
                ", \"questionText\": \"" + questionText + "\"" +
                ", \"typeName\": \"" + typeName + "\"" +
                ", \"time\": " + time +
                ", \"optionId\": " + optionId +
                ", \"optionText\": \"" + optionText + "\"" +
                ", \"isCorrectOption\": \"" + isCorrectOption + "\" }";
    }
}
