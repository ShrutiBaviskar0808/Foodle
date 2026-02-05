<?php
$servername = "localhost";
$username = "root";
$password = "";

try {
    $pdo = new PDO("mysql:host=$servername", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Drop food_app database
    $pdo->exec("DROP DATABASE IF EXISTS food_app");
    echo "✅ Database 'food_app' deleted successfully<br>";
    
    echo "<br><strong>Cleanup completed!</strong><br>";
    echo "Only 'foodle' database remains.";
    
} catch(PDOException $e) {
    echo "Error: " . $e->getMessage();
}
?>