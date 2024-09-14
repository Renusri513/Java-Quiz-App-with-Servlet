<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
  
   
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Java Quiz App Dashboard</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
   
    
    <link href="css/dashboardcss.css" rel="stylesheet">
    
</head>
<body>

    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="#">QuizzApp</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="dashboard.jsp">Dash board</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="quiz_list.jsp">Quiz List</a>
                    </li>
                    
                    <li class="nav-item">
                        <a class="nav-link" href="LogoutServlet">Logout</a>
                    </li>
                    
                </ul>
            </div>
        </div>
    </nav>

    <!-- Dashboard -->
    <div class="dashboard">
        <!-- Content will be dynamically generated here by JavaScript -->
    </div>

    <!-- Optional JavaScript -->
    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        fetch('http://localhost:8082/QuizzApp/DashboardServlet')
            .then(response => response.json())
            .then(data => {
                const dashboard = document.querySelector('.dashboard');
                dashboard.innerHTML = ''; // Clear existing content
                console.log(data); // Check if data is coming through
                data.forEach(topic => {
                    const topicCard = document.createElement('div');
                    topicCard.className = 'topic-card';
                    
                    // Correct string concatenation here
                    let buttonsHtml = 
                        '<button onclick="toggleDropdown(' + topic.topic_id + ', \'beginner\', event)">Beginner</button>' +
                        '<button onclick="toggleDropdown(' + topic.topic_id + ', \'intermediate\', event)">Intermediate</button>' +
                        '<button onclick="toggleDropdown(' + topic.topic_id + ', \'advanced\', event)">Advanced</button>' +
                        '<div id="dropdown-' + topic.topic_id + '-beginner" class="quiz-dropdown"></div>' +
                        '<div id="dropdown-' + topic.topic_id + '-intermediate" class="quiz-dropdown"></div>' +
                        '<div id="dropdown-' + topic.topic_id + '-advanced" class="quiz-dropdown"></div>';
                    
                    topicCard.innerHTML = 
                        '<h2>' + topic.topic_name + '</h2>' +
                        '<div class="level-buttons">' + buttonsHtml + '</div>';
                    dashboard.appendChild(topicCard);
                });
            })
            .catch(error => console.error('Error fetching data:', error));
    });


        function toggleDropdown(topicId, difficulty, event) {
            event.stopPropagation(); // Prevent event bubbling
            const dropdownId = 'dropdown-' + topicId + '-' + difficulty;
            const dropdown = document.getElementById(dropdownId);

            if (dropdown.style.display === 'block') {
                dropdown.style.display = 'none';
            } else {
                dropdown.style.display = 'block';
                fetchQuizzes(topicId, difficulty, dropdown);
            }
        }

        function fetchQuizzes(topicId, difficulty, dropdown) {
            fetch('http://localhost:8082/QuizzApp/QuizzesbyTopicDiffServlet?topic=' + encodeURIComponent(topicId) + '&difficulty=' + encodeURIComponent(difficulty))
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok: ' + response.statusText);
                    }
                    return response.json();
                })
                .then(data => {
    console.log('Fetched quizzes:', data); // Debugging: check data structure
    let quizzesHtml = '';

    // Add the title outside the loop
    quizzesHtml += "<h3 style='color:black;'>" + "Quizes under " + difficulty + " level" + "</h3>";


    // Loop through the quiz data and append to quizzesHtml
    data.forEach(quiz => {
        quizzesHtml += 
            "<div class='card quiz-card'>" +
                "<div class='card-body'>" +
                    "<h5 class='card-title'>" + quiz.quiz_name + "</h5>" +
                    "<p class='card-text'>Click to start this quiz!</p>" +
                    "<a href='quiz.jsp?quiz_id=" + quiz.quiz_id + "' class='btn btn-primary'>Start Quiz</a>" +
                    
                "</div>" +
            "</div>";
    });

    // Now you can use quizzesHtml as needed
    dropdown.innerHTML = quizzesHtml;
})

                .catch(error => console.error('Error fetching quizzes:', error));
        }

    </script>
</body>
</html>
