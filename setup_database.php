<?php
// Create database and tables
$servername = "localhost";
$username = "root";
$password = "";

try {
    // Connect without database first
    $pdo = new PDO("mysql:host=$servername", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Create database
    $pdo->exec("CREATE DATABASE IF NOT EXISTS food_app");
    echo "Database 'food_app' created successfully<br>";
    
    // Use the database
    $pdo->exec("USE food_app");
    
    // Create users table
    $sql = "CREATE TABLE IF NOT EXISTS users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        email VARCHAR(100) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL,
        otp VARCHAR(6) NULL,
        is_verified BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    )";
    
    $pdo->exec($sql);
    echo "Table 'users' created successfully<br>";
    
    // Create indexes
    $pdo->exec("CREATE INDEX IF NOT EXISTS idx_email ON users(email)");
    $pdo->exec("CREATE INDEX IF NOT EXISTS idx_otp ON users(otp)");
    echo "Indexes created successfully<br>";
    
    echo "<br><strong>Database setup complete!</strong><br>";
    echo "You can now use the login and signup features.";
    
} catch(PDOException $e) {
    echo "Error: " . $e->getMessage();
}
?>