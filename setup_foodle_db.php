<?php
$servername = "localhost";
$username = "root";
$password = "";

try {
    // Connect without database first
    $pdo = new PDO("mysql:host=$servername", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Create foodle database
    $pdo->exec("CREATE DATABASE IF NOT EXISTS foodle");
    echo "Database 'foodle' created successfully<br>";
    
    // Use the database
    $pdo->exec("USE foodle");
    
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
    
    // Create verify_otp table
    $sql2 = "CREATE TABLE IF NOT EXISTS verify_otp (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_id INT NOT NULL,
        email VARCHAR(100) NOT NULL,
        otp VARCHAR(6) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users(id)
    )";
    $pdo->exec($sql2);
    echo "Table 'verify_otp' created successfully<br>";
    
    // Create indexes
    $pdo->exec("CREATE INDEX IF NOT EXISTS idx_email ON users(email)");
    $pdo->exec("CREATE INDEX IF NOT EXISTS idx_otp ON users(otp)");
    $pdo->exec("CREATE INDEX IF NOT EXISTS idx_verify_otp_user ON verify_otp(user_id)");
    echo "Indexes created successfully<br>";
    
    echo "<br><strong>Foodle database setup complete!</strong><br>";
    echo "Tables: users, verify_otp<br>";
    echo "You can now use the login and signup features.";
    
} catch(PDOException $e) {
    echo "Error: " . $e->getMessage();
}
?>