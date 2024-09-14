<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quiz Creation Form</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/createquiz.css">
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <a class="navbar-brand" href="#">Quiz App</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                    <a class="nav-link" href="adminhome.jsp">Home</a>
                </li>
                <li class="nav-item active">
                    <a class="nav-link" href="createquiz.jsp">Create Quiz <span class="sr-only">(current)</span></a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="allquizes.jsp">View Quizzes</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="LogoutServlet">Logout</a>
                </li>
            </ul>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container mt-5">
        <h1 class="text-center mb-4">Create a Quiz</h1>
        <form id="quizForm" method="POST" action="http://localhost:8082/QuizzApp/InsertQuizServlet">
            <div class="form-group">
                <label for="topic">Select Topic:</label>
                <select id="topic" name="topic" class="form-control" required>
                    <!-- Topics will be loaded dynamically -->
                </select>
            </div>
            <div class="form-group">
                <label for="quizName">Quiz Name:</label>
                <input type="text" id="quizName" name="quizName" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="difficulty">Select Difficulty:</label>
                <select id="difficulty" name="difficulty" class="form-control" required>
                    <option value="">Select difficulty</option>
                    <option value="beginner">Easy</option>
                    <option value="intermediate">Medium</option>
                    <option value="advanced">Hard</option>
                </select>
            </div>
            <div id="additionalFields" class="mt-4" style="display: none;">
                <div id="questionsContainer"></div>
                <div class="form-group mt-3">
                    <button type="button" id="addQuestionButton" class="btn btn-secondary btn-block">Add Question</button>
                </div>
            </div>
            
            <div class="form-group mt-4">
                <button type="submit" class="btn btn-primary btn-block">Submit Quiz</button>
            </div>
        </form>
    </div>
    <script>
    // Check if the status is 'success' in the URL and show an alert
    document.addEventListener('DOMContentLoaded', function() {
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('status') === 'success') {
            alert("Quiz inserted successfully!");
        }
    });
</script>
    

    <!-- Bootstrap JS and dependencies -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="createquiz.js"></script>
</body>
</html>
