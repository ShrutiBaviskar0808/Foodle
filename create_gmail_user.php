<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "food_app";

try {
    $pdo = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Delete old test user and create new one with Gmail
    $pdo->prepare("DELETE FROM users WHERE email = ?")->execute(['test@example.com']);
    
    $stmt = $pdo->prepare("INSERT INTO users (name, email, password, is_verified) VALUES (?, ?, ?, ?)");
    $stmt->execute(['Test User', 'test@gmail.com', '123456', true]);
    
    echo "Test user created with Gmail!<br>";
    echo "<strong>Email:</strong> test@gmail.com<br>";
    echo "<strong>Password:</strong> 123456<br>";
    echo "<br>You can now login with these credentials in your app.";
    
} catch(PDOException $e) {
    if (strpos($e->getMessage(), 'Duplicate entry') !== false) {
        echo "Gmail test user already exists!<br>";
        echo "<strong>Email:</strong> test@gmail.com<br>";
        echo "<strong>Password:</strong> 123456";
    } else {
        echo "Error: " . $e->getMessage();
    }
}
?>