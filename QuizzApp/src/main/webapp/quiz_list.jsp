<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Java Quiz List</title>
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f4f4;
        }
        .card-container {
            margin: 50px auto;
            max-width: 80%;
            display: flex;
            flex-wrap: wrap;
            justify-content: space-around;
        }
        .card {
            background-color: #f8f9fa;
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            margin: 15px;
            padding: 20px;
            transition: transform 0.3s ease;
            width: 300px;
        }
        .card:hover {
            transform: translateY(-10px);
            background-color: #e9ecef;
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #007bff;
        }
        .card-title {
            font-size: 1.5rem;
            color: #333;
        }
        .card-subtitle {
            font-size: 1.2rem;
            color: #6c757d;
        }
        .difficulty {
            font-weight: bold;
            color: #007bff;
            font-size: 1rem;
        }
        .filter-container {
            margin: 20px auto;
            max-width: 80%;
            text-align: center;
        }
        .filter-container input,
        .filter-container select {
            margin: 5px;
            padding: 10px;
            width: 200px;
        }
    </style>
</head>
<body>
 <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <a class="navbar-brand" href="#">Java Quiz App</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                     <a class="nav-link" href="dashboard.jsp">Dash Board</a>
                </li>
               
                <li class="nav-item active">
                    <a class="nav-link" href="quiz_list.jsp">Quiz List</a>
                </li>
                <li class="nav-item">
                        <a class="nav-link" href="LogoutServlet">Logout</a>
                    </li>
            </ul>
        </div>
    </nav>
    <div class="container">
        <h2>Quiz List</h2>

        <!-- Filter Form -->
        <div class="filter-container">
            <input type="text" id="filterQuizName" placeholder="Filter by Quiz Name">
            <input type="text" id="filterTopicName" placeholder="Filter by Topic Name">
            <select id="filterDifficulty">
                <option value="">Filter by Difficulty</option>
                <option value="Beginner">Easy</option>
                <option value="Intermediate">Medium</option>
                <option value="Advanced">Hard</option>
            </select>
            <button class="btn btn-primary" onclick="applyFilters()">Apply Filters</button>
        </div>

        <div class="card-container" id="quiz-list">
            <%-- The card container will be dynamically populated by JavaScript --%>
        </div>
    </div>

    <!-- JavaScript to fetch data from the servlet and populate the cards -->
    <script>
        var quizzes = [];  // To store all quizzes fetched from the server

        window.onload = function() {
            fetch('http://localhost:8082/QuizzApp/AllQuizServlet')
                .then(function(response) {
                    return response.json();
                })
                .then(function(data) {
                    quizzes = data;  // Store fetched quizzes
                    displayQuizzes(quizzes);  // Display all quizzes initially
                })
                .catch(function(error) {
                    console.error('Error fetching data:', error);
                });
        }

        
        function displayQuizzes(quizData) {
            var quizContainer = document.getElementById('quiz-list');
            quizContainer.innerHTML = '';  // Clear any existing content
            quizData.forEach(function(quiz) {
                var card = 
                    '<div class="card">' +
                        '<h5 class="card-title">' + quiz.quiz_name + '</h5>' +
                        '<h6 class="card-subtitle mb-2 text-muted">Topic: ' + quiz.topic_name + '</h6>' +
                        '<p class="difficulty">Difficulty: ' + quiz.difficulty + '</p>' +
                       
                        		'<a href="quiz.jsp?quiz_id=' + quiz.quiz_id + '" class="btn btn-primary mt-2">View Quiz</a>' +
                    '</div>';
                quizContainer.innerHTML += card;
            });
        }
    


        function applyFilters() {
            var filterQuizName = document.getElementById('filterQuizName').value.toLowerCase();
            var filterTopicName = document.getElementById('filterTopicName').value.toLowerCase();
            var filterDifficulty = document.getElementById('filterDifficulty').value;

            // Filter quizzes based on user input
            var filteredQuizzes = quizzes.filter(function(quiz) {
                var matchesQuizName = quiz.quiz_name.toLowerCase().includes(filterQuizName);
                var matchesTopicName = quiz.topic_name.toLowerCase().includes(filterTopicName);
                var matchesDifficulty = filterDifficulty === "" || quiz.difficulty === filterDifficulty;

                return matchesQuizName && matchesTopicName && matchesDifficulty;
            });

            // Display filtered quizzes
            displayQuizzes(filteredQuizzes);
        }
    </script>

    <!-- Bootstrap JS and dependencies -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
