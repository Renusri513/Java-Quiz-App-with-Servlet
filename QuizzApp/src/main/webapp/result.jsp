<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Result</title>
    <script>
        window.onload = function() {
            var urlParams = new URLSearchParams(window.location.search);
            var status = urlParams.get('status');

            if (status === 'success') {
                alert('Registered successfully!');
                setTimeout(function() {
                    window.location.href = 'login.jsp';
                }, 1000); // Wait for 1 second before redirecting
            } else {
                alert('Registration failed. Please try again.');
                setTimeout(function() {
                    window.location.href = 'signup.jsp';
                }, 1000); // Wait for 1 second before redirecting
            }
        }
    </script>
</head>
<body>
</body>
</html>
