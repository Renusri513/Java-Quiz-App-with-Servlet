import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/QuizServlet")
public class QuizServlet extends HttpServlet {
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

        Map<Integer, Question> questionsMap = new HashMap<>();
        StringBuilder json = new StringBuilder("[");

        try (Connection conn = DriverManager.getConnection(url, user, password)) {
            String questionQuery = "SELECT q.question_id, q.question_text, q.quiz_id, q.question_type_id, q.time, qt.type_name " +
                "FROM question q " +
                "JOIN question_type qt ON q.question_type_id = qt.question_type_id " +
                "WHERE q.quiz_id = ?";
            try (PreparedStatement questionStmt = conn.prepareStatement(questionQuery)) {
                questionStmt.setInt(1, quizId);
                ResultSet rs = questionStmt.executeQuery();

                while (rs.next()) {
                    int questionId = rs.getInt("question_id");
                    String questionText = escapeJson(rs.getString("question_text"));  // Escape special characters
                    String typeName = escapeJson(rs.getString("type_name"));
                    int time = rs.getInt("time");

                    Question question = new Question(quizId, questionId, questionText, typeName, time);
                    questionsMap.put(questionId, question);
                }
            }

            String optionsQuery = "SELECT o.question_id, o.option_id, o.option_text, " +
                "IF(a.option_id IS NOT NULL, TRUE, FALSE) AS is_correct " +
                "FROM option o " +
                "LEFT JOIN answer a ON o.option_id = a.option_id AND o.question_id = a.question_id " +
                "WHERE o.question_id IN (SELECT question_id FROM question WHERE quiz_id = ?)";
            try (PreparedStatement optionsStmt = conn.prepareStatement(optionsQuery)) {
                optionsStmt.setInt(1, quizId);
                ResultSet rs = optionsStmt.executeQuery();

                while (rs.next()) {
                    int questionId = rs.getInt("question_id");
                    int optionId = rs.getInt("option_id");
                    String optionText = escapeJson(rs.getString("option_text"));
                    boolean isCorrect = rs.getBoolean("is_correct");

                    Option option = new Option(optionId, optionText, isCorrect);

                    Question question = questionsMap.get(questionId);
                    if (question != null) {
                        question.getOptions().add(option);
                    }
                }
            }

            boolean firstQuestion = true;
            for (Question question : questionsMap.values()) {
                if (!firstQuestion) {
                    json.append(",");
                }
                json.append(question.toString());
                firstQuestion = false;
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
