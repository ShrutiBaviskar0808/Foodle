<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "food_app";

try {
    $pdo = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Update test user with simple password
    $stmt = $pdo->prepare("UPDATE users SET password = ? WHERE email = ?");
    $stmt->execute(['123456', 'test@example.com']);
    
    echo "Test user password updated!<br>";
    echo "<strong>Email:</strong> test@example.com<br>";
    echo "<strong>New Password:</strong> 123456<br>";
    echo "<br>Try logging in with these simple credentials.";
    
} catch(PDOException $e) {
    echo "Error: " . $e->getMessage();
}
?>