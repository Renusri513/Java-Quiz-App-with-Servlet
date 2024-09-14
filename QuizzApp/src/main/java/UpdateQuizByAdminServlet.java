import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UpdateQuizByAdminServlet")
public class UpdateQuizByAdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        // Get the updated parameters from the request
        String quizIdStr = request.getParameter("quiz_id");
        System.out.println(quizIdStr);
        String questionIdStr = request.getParameter("question_id");
        System.out.println(questionIdStr);
        String questionText = request.getParameter("question_text");
        System.out.println(questionText);
        String questionTypeIdStr = request.getParameter("question_type_id");
        System.out.println(questionTypeIdStr);
        String timeStr = request.getParameter("time");
        System.out.println(timeStr);

        String[] optionIds = request.getParameterValues("option_id");
        System.out.println(optionIds);
        String[] optionTexts = request.getParameterValues("option_text");
        System.out.println(optionTexts);
        String[] correctOptions = request.getParameterValues("is_correct_option");
        System.out.println(correctOptions);

        // Validate input
        if (quizIdStr == null || questionIdStr == null || questionText == null ||
            questionTypeIdStr == null || timeStr == null || optionIds == null || 
            optionTexts == null || correctOptions == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Missing parameters\"}");
            out.flush();
            return;
        }

        try {
            // Convert string inputs to integers where necessary
            int quizId = Integer.parseInt(quizIdStr);
            System.out.println(quizId);
            int questionId = Integer.parseInt(questionIdStr);
            System.out.println(questionId);
            int questionTypeId = Integer.parseInt(questionTypeIdStr);
            System.out.println(questionTypeId);
            int time = Integer.parseInt(timeStr);
            System.out.println(time);

            // Connect to the database
            String url = "jdbc:mysql://localhost:3306/javaquizapp";
            String user = "root";
            String password = "";

            try (Connection conn = DriverManager.getConnection(url, user, password)) {
                // Update the question in the database
                String updateQuestionQuery = "UPDATE question SET question_text = ?, question_type_id = ?, time = ? WHERE question_id = ?";
                try (PreparedStatement stmt = conn.prepareStatement(updateQuestionQuery)) {
                    stmt.setString(1, questionText);
                    stmt.setInt(2, questionTypeId);
                    stmt.setInt(3, time);
                    stmt.setInt(4, questionId);
                    int rowsAffected = stmt.executeUpdate();
                    if (rowsAffected == 0) {
                        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                        out.print("{\"error\":\"Question not found\"}");
                        out.flush();
                        return;
                    }
                }

                // Update the options in the database
                String updateOptionQuery = "UPDATE option SET option_text = ? WHERE option_id = ?";
                String updateAnswerQuery = "INSERT INTO answer (option_id) VALUES (?) ON DUPLICATE KEY UPDATE option_id = VALUES(option_id)";
                String deleteAnswerQuery = "DELETE FROM answer WHERE option_id = ?";

                for (int i = 0; i < optionIds.length; i++) {
                    int optionId = Integer.parseInt(optionIds[i]);
                    String optionText = optionTexts[i];
                    boolean isCorrectOption = "yes".equalsIgnoreCase(correctOptions[i]);

                    try (PreparedStatement optionStmt = conn.prepareStatement(updateOptionQuery)) {
                        optionStmt.setString(1, optionText);
                        optionStmt.setInt(2, optionId);
                        optionStmt.executeUpdate();
                    }

                    // Update the correct option status in the answer table
                    if (isCorrectOption) {
                        try (PreparedStatement answerStmt = conn.prepareStatement(updateAnswerQuery)) {
                            answerStmt.setInt(1, optionId);
                            answerStmt.executeUpdate();
                        }
                    } else {
                        try (PreparedStatement deleteAnswerStmt = conn.prepareStatement(deleteAnswerQuery)) {
                            deleteAnswerStmt.setInt(1, optionId);
                            deleteAnswerStmt.executeUpdate();
                        }
                    }
                }

                // Send success response
                out.print("{\"success\":\"Quiz question and options updated successfully\"}");
                out.flush();

            } catch (Exception e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"error\":\"Server error occurred: " + e.getMessage() + "\"}");
                out.flush();
            } finally {
                out.close();
            }
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\":\"Invalid number format\"}");
            out.flush();
        }
    }
}
