<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quiz</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <style>
        @charset "UTF-8";

        /* General Styles */
        body, html {
            height: 100%;
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #d5d5d5; /* Darker text color for better readability */
            background-image: url('images/Design 3.png');
            background-color: #f8f9fa; /* Light background color for better contrast */
            overflow-x: hidden; /* Prevent horizontal scrolling */
        }

        #quiz {
            max-width: 800px;
            margin: 40px auto;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.2);
            padding: 30px;
            box-sizing: border-box;
             /* Set background image */
            background-size: cover; /* Ensure the background image covers the container */
            background-position: center; /* Center the background image */
        }

        h2 {
            font-size: 2.5rem;
            color: #007bff; /* Blue color for the heading */
        }

        .question {
            display: none;
        }

        .question.active {
            display: block;
        }

        .result {
            display: none;
            font-size: 1.25rem;
            font-weight: 500;
            margin-top: 30px;
            text-align: center;
            color: #333;
            background: #ffffff; /* White background for result section */
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }

        .result p {
            margin: 0;
            padding: 10px 0;
        }

        .question h3 {
            font-size: 1.75rem;
            margin-bottom: 20px;
            line-height: 1.4;
            color: #007bff; /* Blue color for question text */
        }

        .question p {
            font-size: 1.125rem;
            margin-bottom: 20px;
            line-height: 1.6;
        }

        .btn-custom {
            width: 100%;
            margin-top: 10px;
            padding: 14px;
            font-size: 1.125rem;
            border-radius: 8px;
            border: 1px solid transparent;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s ease, border-color 0.3s ease;
        }

        .btn-custom:hover {
            transform: translateY(-2px);
        }

        .btn-custom.correct {
            background-color: #28a745;
            color: #ffffff;
        }

        .btn-custom.wrong {
            background-color: #dc3545;
            color: #ffffff;
        }

        /* Additional Styling for Buttons */
        .btn-custom.correct:hover {
            background-color: #218838;
        }

        .btn-custom.wrong:hover {
            background-color: #c82333;
        }

        /* Timer Style */
        #timer {
            font-size: 1.5rem;
            font-weight: 600;
            color: #dc3545; /* Red color for timer */
        }
    </style>
</head>
<body>

    <div id="quiz" class="container">
        <h2 class="text-center mb-4">Quiz Time!</h2>
        <div id="questions-container"></div>
        <div id="timer" class="text-center mb-4" style="font-size: 24px; color: red;"></div>
        <div id="result" class="result">
            <p id="scoreText"></p>
            <button class="btn btn-primary" onclick="resetQuiz()">Restart Quiz</button>
            <br>
            <a href='dashboard.jsp'>Explore More Quizzes</a>
        </div>
    </div>

    
        <script>
        let score = 0;
        let currentQuestion = 0;
        let questions = [];
        let timer;
        const timeLimitDefault = 30;

        function getQueryParameter(name) {
            const urlParams = new URLSearchParams(window.location.search);
            return urlParams.get(name);
        }

        function loadQuestions() {
            const quizId = getQueryParameter('quiz_id'); // Get quiz_id from URL
            if (quizId) {
                fetch('http://localhost:8082/QuizzApp/QuizServlet?quiz_id=' + encodeURIComponent(quizId))
                    .then(response => response.json())
                    .then(data => {
                        questions = data;
                        console.log('Fetched questions:', questions);
                        displayQuestion();
                    })
                    .catch(error => console.error('Error fetching questions:', error));
            } else {
                console.error('No quiz_id found in URL');
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            loadQuestions();
        });


        function startTimer(timeLimit) {
            clearInterval(timer);
            if (isNaN(timeLimit) || timeLimit <= 0) {
                timeLimit = timeLimitDefault;
            }
            let timeLeft = timeLimit;
            document.getElementById('timer').textContent = 'Time left: ' + timeLeft + 's';

            timer = setInterval(() => {
                timeLeft--;
                document.getElementById('timer').textContent = 'Time left: ' + timeLeft + 's';

                if (timeLeft <= 0) {
                    clearInterval(timer);
                    currentQuestion++;
                    displayQuestion();
                }
            }, 1000);
        }

        function displayQuestion() {
            if (currentQuestion < questions.length) {
                const questionData = questions[currentQuestion];

                if (!questionData) {
                    console.error('Invalid question data at index:', currentQuestion, questionData);
                    currentQuestion++;
                    displayQuestion();
                    return;
                }

                const timeLimit = parseInt(questionData.time, 10);
                const questionDiv = document.createElement('div');
                questionDiv.className = 'question active';
                questionDiv.id = 'question' + questionData.question_id;

                const questionHeading = document.createElement('h3');
                questionHeading.textContent = questionData.question_text || 'No question text available';
                questionDiv.appendChild(questionHeading);

                if (!Array.isArray(questionData.options) || questionData.options.length === 0) {
                    console.error('No options available for question:', questionData);
                } else {
                    questionData.options.forEach((option, index) => {
                        const optionText = option.option_text || 'No option text';
                        const correctOption = option.is_correct;
                        const optionLetter = String.fromCharCode(65 + index);
                        const button = createButton(optionText, correctOption, optionLetter, questionData.type_name);
                        questionDiv.appendChild(button);
                    });
                }

                // Add submit button for each question
                const submitButton = document.createElement('button');
submitButton.className = 'btn btn-primary mt-3';
submitButton.textContent = 'Next';
submitButton.style.backgroundColor = '#6c757d'; // Grey color
submitButton.style.borderColor = '#6c757d'; // Grey border color


                submitButton.onclick = () => checkAnswer(questionDiv, questionData.type_name);
                questionDiv.appendChild(submitButton);

                const questionsContainer = document.getElementById('questions-container');
                questionsContainer.innerHTML = '';
                questionsContainer.appendChild(questionDiv);

                startTimer(timeLimit);
            } else {
                showResult();
            }
        }


        function createButton(optionText, correctOption, optionLetter, typeName) {
            const buttonContainer = document.createElement('div');
            buttonContainer.className = 'd-flex align-items-center mb-2';

            const checkbox = document.createElement('input');
            checkbox.type = 'checkbox';
            checkbox.className = 'me-2';
            checkbox.style.display = typeName === 'multi selection' ? 'block' : 'none';
            checkbox.disabled = typeName !== 'multi selection';

            const button = document.createElement('button');
            button.className = 'btn btn-outline-primary btn-custom';
            button.textContent = optionText;
            button.dataset.option = optionLetter;
            button.dataset.correct = correctOption;

            button.onclick = () => {
                if (typeName === "single selection") {
                    selectSingleOption(button);
                } else {
                    button.classList.toggle('selected');
                    checkbox.checked = !checkbox.checked;
                }
            };

            buttonContainer.appendChild(checkbox);
            buttonContainer.appendChild(button);

            return buttonContainer;
        }

        function selectSingleOption(selectedButton) {
            const buttons = selectedButton.parentElement.parentElement.querySelectorAll('button');

            buttons.forEach(btn => {
                // Disable other options but not the "Next" button
                if (btn !== selectedButton && !btn.classList.contains('btn-primary')) {
                    btn.disabled = true;
                }
            });

            selectedButton.classList.add('selected');
            selectedButton.classList.add(selectedButton.dataset.correct === "true" ? 'correct' : 'wrong');
            selectedButton.disabled = true; // Disable the selected button as well
        }

        function checkAnswer(questionDiv, typeName) {
            if (typeName === "single selection") {
                const selectedButton = questionDiv.querySelector('button.selected');
                if (selectedButton) {
                    const isCorrect = selectedButton.dataset.correct === "true";
                    selectedButton.classList.add(isCorrect ? 'correct' : 'wrong');

                    if (isCorrect) {
                        score++;
                    }

                    // Move to the next question
                    currentQuestion++;
                    setTimeout(() => {
                        displayQuestion();
                    }, 1000); // Delay of 1 second before moving to the next question
                } else {
                    alert("Please select an option before proceeding!");
                }
            } else if (typeName === "multi selection") {
                // Multi-selection answer checking logic
                const selectedButtons = questionDiv.querySelectorAll('button.selected');
                const correctButtons = questionDiv.querySelectorAll('button[data-correct="true"]');
                let allCorrect = true;
                let hasIncorrect = false;

                selectedButtons.forEach(btn => {
                    const correct = btn.dataset.correct === "true";
                    if (correct) {
                        btn.classList.add('correct');
                    } else {
                        btn.classList.add('wrong');
                        hasIncorrect = true;
                    }
                    allCorrect = allCorrect && correct;
                });

                if (selectedButtons.length !== correctButtons.length) {
                    allCorrect = false;
                }

                if (hasIncorrect || !allCorrect) {
                    const feedbackMessage = hasIncorrect 
                        ? "You have selected incorrect options." 
                        : "There are more correct options to select.";
                    
                    alert(feedbackMessage);

                    selectedButtons.forEach(btn => {
                        if (!btn.classList.contains('correct')) {
                            btn.classList.add('wrong');
                        }
                    });
                } else {
                    score++;
                }

                // Disable all buttons after submission
                const buttons = questionDiv.querySelectorAll('button');
                buttons.forEach(btn => btn.disabled = true);

                // Move to the next question
                currentQuestion++;
                setTimeout(() => {
                    displayQuestion();
                }, 1000); // Delay of 1 second before moving to the next question
            }
        }



        function showResult() {
            document.getElementById('questions-container').style.display = 'none';
            document.getElementById('result').style.display = 'block';
            document.getElementById('timer').style.display = 'none';

            const percentage = ((score / questions.length) * 100).toFixed(2);
            let feedback;
            if (percentage == 100) {
                feedback = "You're excellent! Keep up the amazing work!";
            } else if (percentage > 70) {
                feedback = "You're doing great! You're on the path to mastery.";
            } else if (percentage > 50) {
                feedback = "You're making good progress! Keep pushing, and you'll achieve even more.";
            } else {
                feedback = "Keep your head up! Every step forward is a step closer to success.";
            }

            const scoreText = "Great job! You scored " + score + " out of " + questions.length + " (" + percentage + "%) in the quiz." + feedback;
            
            document.getElementById('scoreText').textContent = scoreText;
        }

        function resetQuiz() {
            score = 0;
            currentQuestion = 0;
            document.getElementById('result').style.display = 'none';
            document.getElementById('questions-container').style.display = 'block';
            document.getElementById('timer').style.display = 'block';
            loadQuestions();
        }

        loadQuestions();
    </script>
    
</body>
</html>
