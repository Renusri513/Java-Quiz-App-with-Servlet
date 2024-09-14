<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Java Quiz App</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
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
        /* Styling for the active navigation link */
.nav-link.active {
    background-color: rgba(52, 58, 64, 0.8); /* Background color for the active link */
    color: #ffffff !important; /* Text color for the active link */
    border-radius: 5px; /* Rounded corners */
    padding: 8px 16px; /* Padding for the active link */
    transition: background-color 0.3s ease, color 0.3s ease; /* Smooth transition for background and text color */
}

/* Add some hover effects for the active link */
.nav-link:hover {
    background-color: #d3d3d3; /* Darker background color on hover */
    color: #ffffff !important; /* Ensure text color stays white */
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
    </style>
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="#">Java Quiz App</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                        <a class="nav-link" href="index.jsp">Home</a>
                    </li>
                
                    <li class="nav-item">
                        <a class="nav-link" href="signup.jsp">Sign Up</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="login.jsp">Login</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="about.jsp">About</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <div class="hero">
        <img src="css/Design 1.png" alt="Background Image">
        <div class="hero-content">
            <h1>Welcome to Java Quiz App</h1>
            <p>
                Welcome to Java Quiz App, the ultimate platform for enhancing your Java programming skills through interactive quizzes!
                
                Whether you're a beginner just starting out, an intermediate learner looking to refine your skills, or an advanced developer seeking to challenge yourself, Java Quiz App has something for everyone. Our goal is to provide a fun, educational experience that makes learning Java both engaging and effective.</p>
            <a href="signup.jsp" class="btn btn-primary btn-lg">Get Started</a>
        </div>
    </div>

    <!-- Optional JavaScript -->
    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
