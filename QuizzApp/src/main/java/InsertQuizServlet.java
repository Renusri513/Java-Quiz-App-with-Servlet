import java.io.IOException;
import java.sql.*;
import java.util.*;
import java.util.regex.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/InsertQuizServlet")
public class InsertQuizServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        PreparedStatement psQuiz = null, psQuestion = null, psOption = null, psAnswer = null;

        try {
            // Load the MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish the database connection
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/javaquizapp", "root", "");
            conn.setAutoCommit(false); // Disable auto-commit for transaction management

            // Get form data
            String topicId = request.getParameter("topic");
            String quizName = request.getParameter("quizName");
            String difficulty = request.getParameter("difficulty");

            // Insert into quiz table
            String quizSQL = "INSERT INTO quiz (topic_id, quiz_name, difficulty) VALUES (?, ?, ?)";
            psQuiz = conn.prepareStatement(quizSQL, PreparedStatement.RETURN_GENERATED_KEYS);
            psQuiz.setString(1, topicId);
            psQuiz.setString(2, quizName);
            psQuiz.setString(3, difficulty);
            psQuiz.executeUpdate();

            // Get generated quiz_id
            int quizId = DBUtil.getGeneratedKey(psQuiz);

            // Get all question indexes
            Enumeration<String> parameterNames = request.getParameterNames();
            Set<Integer> questionIndexes = new HashSet<>();

            while (parameterNames.hasMoreElements()) {
                String paramName = parameterNames.nextElement();
                // Check if the parameter name matches the pattern for questions
                if (paramName.matches("questions\\[(\\d+)\\]\\[question\\]")) {
                    // Extract the index
                    Matcher matcher = Pattern.compile("questions\\[(\\d+)\\]\\[question\\]").matcher(paramName);
                    if (matcher.find()) {
                        int index = Integer.parseInt(matcher.group(1));
                        questionIndexes.add(index);
                    }
                }
            }

            // Iterate over each question index
            for (Integer i : questionIndexes) {
                String questionText = request.getParameter("questions[" + i + "][question]");
                String questionType = request.getParameter("questions[" + i + "][questionType]");
                String timeStr = request.getParameter("questions[" + i + "][time]");

                // Parse time if available, default to 0 if not present
                int time = (timeStr != null && !timeStr.isEmpty()) ? Integer.parseInt(timeStr) : 0;

                // Map questionType to questionTypeId
                String questionTypeId = "1"; // Default to '1' for single
                if ("multiple".equalsIgnoreCase(questionType)) {
                    questionTypeId = "2"; // Set to '2' for multiple
                }

                // Insert into question table
                String questionSQL = "INSERT INTO question (quiz_id, question_text, question_type_id, time) VALUES (?, ?, ?, ?)";
                psQuestion = conn.prepareStatement(questionSQL, PreparedStatement.RETURN_GENERATED_KEYS);
                psQuestion.setInt(1, quizId);
                psQuestion.setString(2, questionText);
                psQuestion.setString(3, questionTypeId);
                psQuestion.setInt(4, time);
                psQuestion.executeUpdate();

                // Get generated question_id
                int questionId = DBUtil.getGeneratedKey(psQuestion);

                // Retrieve options and correct options
                String[] options = request.getParameterValues("questions[" + i + "][options][]");
                String[] correctOptions = request.getParameterValues("questions[" + i + "][correctOptions][]");

                if (options != null) {
                    for (int j = 0; j < options.length; j++) {
                        String optionText = options[j];
                        String optionSQL = "INSERT INTO `option` (question_id, option_text) VALUES (?, ?)";
                        psOption = conn.prepareStatement(optionSQL, PreparedStatement.RETURN_GENERATED_KEYS);
                        psOption.setInt(1, questionId);
                        psOption.setString(2, optionText);
                        psOption.executeUpdate();

                        // Get generated option_id
                        int optionId = DBUtil.getGeneratedKey(psOption);

                        // Check if this option is a correct option
                        if (correctOptions != null && Arrays.asList(correctOptions).contains(optionText)) {
                            // Insert into answer table with option_id
                            String answerSQL = "INSERT INTO answer (question_id, option_id) VALUES (?, ?)";
                            psAnswer = conn.prepareStatement(answerSQL);
                            psAnswer.setInt(1, questionId);
                            psAnswer.setInt(2, optionId); // Use option_id as the correct option
                            psAnswer.executeUpdate();
                        }
                    }
                }
            }

            // Commit transaction
            conn.commit();

            
         // Redirect to a success page or show a success message
            response.sendRedirect("createquiz.jsp?status=success");


        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback transaction if any error occurs
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            // Close resources
            try { if (psQuiz != null) psQuiz.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (psQuestion != null) psQuestion.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (psOption != null) psOption.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (psAnswer != null) psAnswer.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}
