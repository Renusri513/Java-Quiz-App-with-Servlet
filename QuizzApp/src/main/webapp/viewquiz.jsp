<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Quiz Details</title>

    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            padding: 2em;
            background-color: #f4f4f4;
        }
        .container {
            max-width: 1200px;
            margin: auto;
        }
        h1 {
            margin-bottom: 40px;
            text-align: center;
            font-weight: bold;
            color: #007bff;
        }
        .card {
            margin-bottom: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .card-header {
            background-color: #007bff;
            color: white;
            font-weight: bold;
        }
        .card-body {
            background-color: #ffffff;
        }
        .card-title {
            color: #333;
        }
        .card-text {
            color: #6c757d;
        }
        .options-list {
            margin-top: 10px;
        }
        .edit-form {
            display: none;
            margin-top: 20px;
        }
        .edit-form input {
            margin-bottom: 10px;
        }
    </style>
</head>
<body>

<div class="container">
 <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <a class="navbar-brand" href="#">Java Quiz App</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                    <a class="nav-link" href="adminhome.jsp">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="createquiz.jsp">Create Quiz <span class="sr-only">(current)</span></a>
                </li>
                <li class="nav-item active">
                    <a class="nav-link" href="allquizes.jsp">View Quizzes</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="LogoutServlet">Logout</a>
                </li>
            </ul>
        </div>
    </nav>
    <h1>Quiz Question Details</h1>

    <div id="quizDetailsContainer">
        <!-- JavaScript will dynamically populate this section with quiz details -->
    </div>
</div>

<!-- Bootstrap JS and dependencies -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Get parameters from URL
        const urlParams = new URLSearchParams(window.location.search);
        const quizId = urlParams.get('quizId');
        const topicName = urlParams.get('topic');
        const difficulty = urlParams.get('difficulty');

        if (quizId) {
            // Display topic and difficulty
            document.querySelector('h1').innerText = 'Quiz Details - ' + quizId;

            var detailsContainer = document.getElementById('quizDetailsContainer');
            detailsContainer.innerHTML = '';

            // Fetch quiz data from the servlet
            fetch('ViewQuizByAdminServlet?quiz_id=' + quizId)
                .then(function(response) {
                    return response.json();
                })
                .then(function(data) {
                    if (data.error) {
                        alert(data.error); // Display error if any
                    } else {
                        // Group questions and options
                        var questionsMap = {};

                        data.forEach(function(item) {
                            if (!questionsMap[item.questionId]) {
                                questionsMap[item.questionId] = {
                                    quizId: item.quizId,
                                    quizName: item.quizName,
                                    questionId: item.questionId,
                                    questionText: item.questionText,
                                    typeName: item.typeName,
                                    time: item.time,
                                    options: []
                                };
                            }
                            questionsMap[item.questionId].options.push({
                                optionId: item.optionId,
                                optionText: item.optionText,
                                isCorrectOption: item.isCorrectOption
                            });
                        });

                        // Populate the container with the grouped data using cards
                        Object.keys(questionsMap).forEach(function(questionId) {
                            var question = questionsMap[questionId];
                            var card =
                                '<div class="card">' +
                                    '<div class="card-header">' +
                                        'Quiz ID: ' + question.quizId +
                                    '</div>' +
                                    '<div class="card-body">' +
                                        '<h5 class="card-title">' + question.quizName + '</h5>' +
                                        '<p class="card-text">Question ID: ' + question.questionId + '</p>' +
                                        '<p class="card-text">Question Text: ' + question.questionText + '</p>' +
                                        '<p class="card-text">Type Name: ' + question.typeName + '</p>' +
                                        '<p class="card-text">Time (seconds): ' + question.time + '</p>' +
                                        '<h6 class="card-subtitle mb-2 text-muted">Options:</h6>' +
                                        '<ul class="list-group options-list">';
                                        
                            question.options.forEach(function(option) {
                                card +=
                                    '<li class="list-group-item">' +
                                        'Option ID: ' + option.optionId + '<br>' +
                                        'Option Text: ' + option.optionText + '<br>' +
                                        'Is Correct: ' + option.isCorrectOption +
                                    '</li>';
                            });

                            card +=
                                '</ul>' +
                                '<button class="btn btn-primary mt-2 edit-btn" data-question-id="' + question.questionId + '">Edit</button>' +
                                '<div class="edit-form" id="edit-form-' + question.questionId + '">' +
                                    '<h6>Edit Question</h6>' +
                                    '<form method="POST" action="UpdateQuizByAdminServlet">' +
                                        '<input type="hidden" name="quiz_id" value="' + question.quizId + '">' +
                                        '<input type="hidden" name="question_id" value="' + question.questionId + '">' +
                                        '<div class="form-group">' +
                                            '<label for="questionText-' + question.questionId + '">Question Text:</label>' +
                                            '<input type="text" class="form-control" id="questionText-' + question.questionId + '" name="question_text" value="' + question.questionText + '">' +
                                        '</div>' +
                                        '<div class="form-group">' +
                                            '<label for="typeName-' + question.questionId + '">Type Name:</label>' +
                                            '<input type="text" class="form-control" id="typeName-' + question.questionId + '" name="question_type_id" value="' + question.typeName + '">' +
                                        '</div>' +
                                        '<div class="form-group">' +
                                            '<label for="time-' + question.questionId + '">Time (seconds):</label>' +
                                            '<input type="number" class="form-control" id="time-' + question.questionId + '" name="time" value="' + question.time + '">' +
                                        '</div>' +
                                        '<h6>Edit Options:</h6>' +
                                        '<div id="options-container-' + question.questionId + '">';
                                        
                            question.options.forEach(function(option) {
                                card +=
                                    '<div class="form-group">' +
                                        '<input type="hidden" name="option_id" value="' + option.optionId + '">' +
                                        '<label for="optionText-' + option.optionId + '">Option Text:</label>' +
                                        '<input type="text" class="form-control" id="optionText-' + option.optionId + '" name="option_text" value="' + option.optionText + '">' +
                                        '<div class="form-check">' +
                                            '<input type="checkbox" class="form-check-input" id="isCorrect-' + option.optionId + '" name="is_correct_option" value="yes"' + (option.isCorrectOption ? ' checked' : '') + '>' +
                                            '<label class="form-check-label" for="isCorrect-' + option.optionId + '">Correct Option</label>' +
                                        '</div>' +
                                    '</div>';
                            });

                            card +=
                                '</div>' +
                                '<button type="submit" class="btn btn-primary mt-2">Save Changes</button>' +
                                    '</form>' +
                                '</div>' +
                            '</div>' +
                        '</div>';
                            detailsContainer.innerHTML += card;
                        });

                        // Add event listeners for edit buttons
                        document.querySelectorAll('.edit-btn').forEach(function(button) {
                            button.addEventListener('click', function() {
                                var questionId = this.getAttribute('data-question-id');
                                var editForm = document.getElementById('edit-form-' + questionId);
                                if (editForm.style.display === 'none' || !editForm.style.display) {
                                    editForm.style.display = 'block';
                                } else {
                                    editForm.style.display = 'none';
                                }
                            });
                        });
                    }
                })
                .catch(function(error) {
                    console.error('Error fetching data:', error);
                });
        } else {
            alert('No Quiz ID provided');
        }
    });
</script>

</body>
</html>
