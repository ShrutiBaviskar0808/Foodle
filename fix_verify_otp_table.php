<?php
try {
    $pdo = new PDO("mysql:host=localhost;dbname=foodle", "root", "");
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Drop and recreate verify_otp table with proper structure
    $pdo->exec("DROP TABLE IF EXISTS verify_otp");
    echo "✅ Dropped old verify_otp table<br>";
    
    $sql = "CREATE TABLE verify_otp (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_id INT NOT NULL,
        email VARCHAR(100) NOT NULL,
        otp CHAR(6) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )";
    $pdo->exec($sql);
    echo "✅ Created new verify_otp table with CHAR(6) for OTP<br>";
    
    // Show table structure
    $stmt = $pdo->query("DESCRIBE verify_otp");
    $columns = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo "<br><strong>verify_otp table structure:</strong><br>";
    foreach ($columns as $column) {
        echo "- " . $column['Field'] . " (" . $column['Type'] . ")<br>";
    }
    
} catch(PDOException $e) {
    echo "Error: " . $e->getMessage();
}
?>