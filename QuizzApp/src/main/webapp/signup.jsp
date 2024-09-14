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
        /* Keyframe Animations */
        @keyframes fadeIn {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }

        @keyframes slideIn {
            from {
                transform: translateX(-100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        body, html {
            height: 100%;
            margin: 0;
            animation: fadeIn 1s ease-in-out;
        }

        .navbar {
            background-color: rgba(52, 58, 64, 0.9); /* Slightly transparent background */
            z-index: 1000; /* Ensures navbar stays on top of the background image */
            width: 100%;
            animation: fadeIn 1s ease-in-out;
        }

        .navbar-brand, .nav-link {
            color: #ffffff !important;
        }

        .nav-link.active {
            background-color: rgba(52, 58, 64, 0.8); /* Background color for the active link */
            color: #ffffff !important; /* Text color for the active link */
            border-radius: 5px; /* Rounded corners */
            padding: 8px 16px; /* Padding for the active link */
            transition: background-color 0.3s ease, color 0.3s ease; /* Smooth transition for background and text color */
        }

        .nav-link:hover {
            background-color: #d3d3d3; /* Background color on hover */
            color: #ffffff !important; /* Ensure text color stays white */
        }

        .container-fluid {
            display: flex;
            flex-wrap: wrap;
            height: 100vh;
            align-items: center;
            animation: slideIn 1.2s ease-in-out;
        }

        .form-container {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .image-container {
            flex: 1;
            background: url('images/Design 2.png') no-repeat center center;
            background-size: cover;
            height: 100%;
            position: relative;
            z-index: -1; /* Sends the image behind the content */
            opacity: 0.5; /* Adjusts visibility of the image */
        }

        .card {
            background-color: rgba(255, 255, 255, 0.9); /* Light transparent background */
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.5);
            width: 100%;
            max-width: 500px;
            animation: fadeInUp 1s ease-in-out;
        }

        .card-title {
            text-align: center;
            color: #333333;
            font-size: 2.5rem;
            margin-bottom: 20px;
        }

        .form-label {
            color: #333333;
        }

        .form-control {
            background-color: rgba(255, 255, 255, 0.8);
            color: #333333;
            border-radius: 5px;
            margin-bottom: 15px;
        }

        .form-control:focus {
            background-color: rgba(255, 255, 255, 1);
            color: #333333;
        }

        .btn-primary {
            background-color:  rgba(52, 58, 64, 0.8);
            border: none;
            width: 100%;
            transition: background-color 0.3s ease-in-out;
        }

        .btn-primary:hover {
            background-color: #242424;
        }

        .footer-text {
            text-align: center;
            margin-top: 15px;
            color: #ffffff;
        }
    </style>
</head>

<body>
    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container">
            <a class="navbar-brand" href="#">Java Quiz App</a>
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
                        <a class="nav-link active" href="signup.jsp">Sign Up</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="login.jsp">Login</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="about.jsp">About</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container-fluid">
        <!-- Form Container -->
        <div class="form-container">
            <div class="card">
                <h2 class="card-title">Create Your Account</h2>
                <form id="register" action="SignupServlet" method="post">
                    <div class="mb-3">
                        <label for="username" class="form-label">User Name</label>
                        <input type="text" class="form-control" id="username" name="user_name" placeholder="Enter your username" required>
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email" required>
                    </div>
                    <div class="mb-3">
                        <label for="phone" class="form-label">Phone Number</label>
                        <input type="tel" class="form-control" id="phone" name="phone_no" placeholder="Enter your phone number" required pattern="[0-9]{10}"
                            title="Enter a valid 10-digit phone number">
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label">Password</label>
                        <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" required
                            pattern="(?=.*\d)(?=.*[!@#$%^&*])(?=.*[a-zA-Z]).{6,}"
                            title="Password must be at least 6 characters long, contain at least one number, and one special character">
                    </div>
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">Confirm Password</label>
                        <input type="password" class="form-control" id="confirmPassword" placeholder="Confirm your password" required>
                        <div id="confirmPasswordError" class="invalid-feedback">
                            Passwords do not match.
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary">Sign Up</button>
                </form>
                <div class="footer-text">
                    <p>Already have an account? <a href="login.jsp" class="text-primary">Login here</a>.</p>
                </div>
            </div>
        </div>

        <!-- Image Container -->
        <div class="image-container"></div>
    </div>

    <!-- Optional JavaScript -->
    <!-- Bootstrap Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Form Validation
        const form = document.getElementById('register');
        const password = document.getElementById('password');
        const confirmPassword = document.getElementById('confirmPassword');
        const confirmPasswordError = document.getElementById('confirmPasswordError');

        form.addEventListener('submit', function (event) {
            if (password.value !== confirmPassword.value) {
                confirmPassword.classList.add('is-invalid');
                event.preventDefault();
            } else {
                confirmPassword.classList.remove('is-invalid');
            }
        });
    </script>
</body>

</html>
