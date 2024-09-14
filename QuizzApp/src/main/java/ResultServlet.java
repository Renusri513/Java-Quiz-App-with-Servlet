import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/Result")
public class ResultServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String selectedOption = request.getParameter("option");
        String correctOption = request.getParameter("correct_option");
        
        PrintWriter out = response.getWriter();
        response.setContentType("text/html");
        out.println("<html><body>");
        if (selectedOption.equals(correctOption)) {
            out.println("<h3>Correct Answer!</h3>");
        } else {
            out.println("<h3>Incorrect Answer. Correct answer is " + correctOption + ".</h3>");
        }
        out.println("<a href='TestPapers'>Back to Test Papers</a>");
        out.println("</body></html>");
    }
}
