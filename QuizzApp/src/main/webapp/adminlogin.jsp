<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>QuizzApp - Login</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body, html {
            height: 100%;
            margin: 0;
            font-family: Arial, sans-serif;
            color: #ffffff;
            position: relative;
            overflow: hidden;
        }

        .navbar {
            background-color: rgba(52, 58, 64, 0.8);
            z-index: 1000;
            animation: fadeIn 2s ease-in-out;
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
            animation: zoomIn 2s ease-in-out;
        }

        .nav-link.active {
            background-color: rgba(52, 58, 64, 0.8);
            color: #ffffff !important;
            border-radius: 5px;
            padding: 8px 16px;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .nav-link:hover {
            background-color: #d3d3d3;
            color: #ffffff !important;
        }

        .hero img {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            z-index: -1;
            opacity: 0.5;
            animation: scaleUp 20s infinite alternate ease-in-out;
        }

        .hero-content {
            background-color: rgba(0, 0, 0, 0.7);
            padding: 40px;
            border-radius: 10px;
            animation: slideInFromBottom 1.5s ease-out;
            max-width: 500px;
        }

        .hero h1 {
            font-size: 3rem;
            animation: fadeIn 3s ease-in-out;
        }

        .hero p {
            font-size: 1.25rem;
            margin-bottom: 30px;
            animation: fadeIn 3.5s ease-in-out;
        }

        .btn-primary {
            background-color: #ffffff;
            color: rgba(52, 58, 64, 0.8);
            border: none;
            animation: bounceIn 4s ease-in-out;
        }

        .btn-primary:hover {
            background-color: #242424;
            animation: pulse 1s infinite;
        }

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
            <a class="navbar-brand" href="#">QuizzApp</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
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
                        <a class="nav-link active" href="login.jsp">Login</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="about.html">About</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <div class="hero">
        <img src="images/Design 3.png" alt="Background Image">
        <div class="hero-content">
            <h1>Admin Login to Java Quiz App</h1>
            <p>Enter your username and password to log in.</p>
            <form id="loginForm" method="post">
                <div class="mb-3">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" class="form-control" id="username" name="user_name" required>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" id="password" name="password" required>
                </div>
                <button type="submit" class="btn btn-primary">Login</button>
            </form>
            <div id="loginMessage" class="mt-3"></div>
        </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
    <!-- JavaScript for handling login -->
    <script>
    document.getElementById('loginForm').addEventListener('submit', function(event) {
        event.preventDefault(); // Prevent the default form submission

        // Gather form data
        var formData = new FormData(this);
        var data = {};
        formData.forEach((value, key) => {
            data[key] = value;
        });

        // Debugging: Log the form data to console
        console.log('Form Data:', data);

        // Make AJAX request
        fetch('ServletForAdminLogin', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: new URLSearchParams(data).toString()
        })
        .then(response => response.json())
        .then(data => {
            var messageDiv = document.getElementById('loginMessage');
            if (data.success) {
                messageDiv.innerHTML = '<div class="alert alert-success">' + data.message + '</div>';
                // Optionally, redirect to another page on successful login
                window.location.href = 'adminhome.jsp';
            } else {
                messageDiv.innerHTML = '<div class="alert alert-danger">' + data.message + '</div>';
            }
        })
        .catch(error => {
            console.error('Error:', error);
            document.getElementById('loginMessage').innerHTML = '<div class="alert alert-danger">An error occurred. Please try again later.</div>';
        });
    });

    </script>
</body>

</html>
