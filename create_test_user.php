<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "food_app";

try {
    $pdo = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Insert test user
    $stmt = $pdo->prepare("INSERT INTO users (name, email, password, is_verified) VALUES (?, ?, ?, ?)");
    $stmt->execute(['Test User', 'test@example.com', 'Test123!', true]);
    
    echo "Test user created successfully!<br>";
    echo "<strong>Email:</strong> test@example.com<br>";
    echo "<strong>Password:</strong> Test123!<br>";
    echo "<br>You can now login with these credentials in your app.";
    
} catch(PDOException $e) {
    if (strpos($e->getMessage(), 'Duplicate entry') !== false) {
        echo "Test user already exists!<br>";
        echo "<strong>Email:</strong> test@example.com<br>";
        echo "<strong>Password:</strong> Test123!";
    } else {
        echo "Error: " . $e->getMessage();
    }
}
?>