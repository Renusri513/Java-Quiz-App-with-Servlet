<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Java Quiz App</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Existing styles remain unchanged */
        body, html {
            height: 100%;
            margin: 0;
            font-family: Arial, sans-serif;
            color: #ffffff;
            position: relative;
            overflow: hidden; /* Prevents scrolling when animations move content out of view */
        }

        .navbar {
            background-color: rgba(52, 58, 64, 0.8); /* Slightly transparent background */
            z-index: 1000; /* Ensures navbar stays on top of the background image */
            animation: fadeIn 2s ease-in-out; /* Fade-in animation for navbar */
        }

        .navbar-brand, .nav-link {
            color: #ffffff !important;
        }

        .hero {
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;
            padding: 20px;
            position: relative;
            z-index: 1;
            animation: zoomIn 2s ease-in-out; /* Zoom-in animation for the hero section */
        }

        .hero img {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            z-index: -1; /* Sends the image behind the content */
            opacity: 0.5; /* Adjusts visibility of the image */
            animation: scaleUp 20s infinite alternate ease-in-out; /* Slow zoom effect for background */
        }

        .hero-content {
            background-color: rgba(0, 0, 0, 0.7); /* Dark transparent background */
            padding: 40px;
            border-radius: 10px;
            animation: slideInFromBottom 1.5s ease-out; /* Slide-in animation for the hero content */
        }

        .hero h1 {
            font-size: 3rem;
            animation: fadeIn 3s ease-in-out; /* Fade-in animation for the heading */
        }

        .hero p {
            font-size: 1.25rem;
            margin-bottom: 30px;
            animation: fadeIn 3.5s ease-in-out; /* Fade-in animation for the paragraph */
        }

        .btn-primary {
            background-color: #ffffff;
            color: rgba(52, 58, 64, 0.8); /* Correct property is 'color' instead of 'text-color' */
            border: none;
            animation: bounceIn 4s ease-in-out; /* Bounce-in animation for the button */
        }

        .btn-primary:hover {
            background-color: #242424;
            animation: pulse 1s infinite; /* Pulse animation on hover */
        }

        /* Keyframes for animations */
        @keyframes fadeIn {
            0% { opacity: 0; }
            100% { opacity: 1; }
        }

        @keyframes zoomIn {
            0% { transform: scale(0.8); }
            100% { transform: scale(1); }
        }

        @keyframes slideInFromBottom {
            0% { transform: translateY(100%); }
            100% { transform: translateY(0); }
        }

        @keyframes scaleUp {
            0% { transform: scale(1); }
            100% { transform: scale(1.1); }
        }

        @keyframes bounceIn {
            0%, 20%, 40%, 60%, 80%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        /* Additional styling for the Insert Topic form */
        #insertTopicForm {
            display: none; /* Hidden by default */
            margin-top: 20px;
            animation: fadeIn 1s ease-in-out; /* Fade-in animation */
        }
    </style>
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
                        <a class="nav-link active" href="adminhome.jsp">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="createquiz.jsp">Create Quiz</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="allquizes.jsp">View Quizzes</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="LogoutServlet">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <div class="hero">
        <img src="images/Design 1.png" alt="Background Image">
        <div class="hero-content">
            <h1>Welcome</h1>
            <p>Start creating Quiz.</p>
            <a href="createquiz.jsp" class="btn btn-primary btn-lg">Get Started</a><br><br>
            <button class="btn btn-primary btn-lg" onclick="toggleTopicForm()">Insert Topic</button>

            <!-- Insert Topic Form (Hidden initially) -->
            <div id="insertTopicForm">
                <input type="text" id="topic_name" class="form-control" placeholder="Enter Topic Name"><br>
                <button class="btn btn-success" onclick="saveTopic()">Save</button>
            </div>
        </div>
    </div>

    <!-- Optional JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Function to toggle the Insert Topic form visibility
        function toggleTopicForm() {
            const form = document.getElementById('insertTopicForm');
            form.style.display = (form.style.display === 'none' || form.style.display === '') ? 'block' : 'none';
        }

        // Function to save the topic via AJAX
        function saveTopic() {
            const topicName = document.getElementById('topic_name').value;

            if (!topicName) {
                alert('Please enter a topic name.');
                return;
            }

            // Create an XMLHttpRequest object
            const xhr = new XMLHttpRequest();

            // Configure it: POST-request for the URL /InsertTopicServlet
            xhr.open('POST', 'InsertTopicServlet', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');

            // Define a callback function
            xhr.onload = function() {
                if (xhr.status === 200) {
                    // Handle the response from the servlet
                    const response = xhr.responseText;
                    if (response.includes('success')) {
                        alert('Topic inserted successfully!');
                        // Clear the input field and hide the form
                        document.getElementById('topic_name').value = '';
                        toggleTopicForm();
                    } else {
                        alert('Failed to insert topic: ' + response);
                    }
                } else {
                    alert('An error occurred while saving the topic.');
                }
            };

            // Send the request
            xhr.send('topic_name=' + encodeURIComponent(topicName));
        }
    </script>
</body>
</html>
