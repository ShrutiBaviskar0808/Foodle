<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "foodle";

try {
    $pdo = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Add otp column to users table if it doesn't exist
    $pdo->exec("ALTER TABLE users ADD COLUMN IF NOT EXISTS otp VARCHAR(6) NULL");
    echo "✅ OTP column added to users table<br>";
    
    // Show current table structure
    $stmt = $pdo->query("DESCRIBE users");
    $columns = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo "<br><strong>Current users table structure:</strong><br>";
    foreach ($columns as $column) {
        echo "- " . $column['Field'] . " (" . $column['Type'] . ")<br>";
    }
    
    echo "<br><strong>Database structure updated successfully!</strong>";
    
} catch(PDOException $e) {
    echo "Error: " . $e->getMessage();
}
?>