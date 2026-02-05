<?php
try {
    $pdo = new PDO("mysql:host=localhost;dbname=foodle", "root", "");
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Remove unwanted columns
    $pdo->exec("ALTER TABLE users DROP COLUMN IF EXISTS otp");
    echo "✅ Removed otp column<br>";
    
    $pdo->exec("ALTER TABLE users DROP COLUMN IF EXISTS email_verify");
    echo "✅ Removed email_verify column<br>";
    
    // Show final table structure
    $stmt = $pdo->query("DESCRIBE users");
    $columns = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo "<br><strong>Final users table:</strong><br>";
    foreach ($columns as $column) {
        echo "- " . $column['Field'] . " (" . $column['Type'] . ")<br>";
    }
    
} catch(PDOException $e) {
    echo "Error: " . $e->getMessage();
}
?>