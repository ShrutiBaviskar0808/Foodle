<?php
header('Content-Type: text/html; charset=utf-8');
require_once 'db_config.php';

echo "<h2>Database Column Update Script</h2>";

try {
    $pdo = getDBConnection();
    
    // Check current columns
    echo "<h3>Current columns in members table:</h3>";
    $stmt = $pdo->query("DESCRIBE members");
    $columns = $stmt->fetchAll(PDO::FETCH_ASSOC);
    $existingColumns = array_column($columns, 'Field');
    
    echo "<pre>";
    print_r($existingColumns);
    echo "</pre>";
    
    // Add missing columns
    $columnsToAdd = [
        'photo_path' => "ALTER TABLE members ADD COLUMN photo_path VARCHAR(255) DEFAULT NULL AFTER display_name",
        'nickname' => "ALTER TABLE members ADD COLUMN nickname VARCHAR(100) DEFAULT NULL AFTER photo_path",
        'dob' => "ALTER TABLE members ADD COLUMN dob DATE DEFAULT NULL AFTER nickname",
        'age' => "ALTER TABLE members ADD COLUMN age INT(3) DEFAULT NULL AFTER dob"
    ];
    
    echo "<h3>Adding missing columns:</h3>";
    foreach ($columnsToAdd as $columnName => $sql) {
        if (!in_array($columnName, $existingColumns)) {
            try {
                $pdo->exec($sql);
                echo "<p style='color: green;'>✓ Added column: $columnName</p>";
            } catch (PDOException $e) {
                echo "<p style='color: red;'>✗ Error adding $columnName: " . $e->getMessage() . "</p>";
            }
        } else {
            echo "<p style='color: blue;'>- Column $columnName already exists</p>";
        }
    }
    
    // Show final structure
    echo "<h3>Final columns in members table:</h3>";
    $stmt = $pdo->query("DESCRIBE members");
    $columns = $stmt->fetchAll(PDO::FETCH_ASSOC);
    echo "<table border='1' cellpadding='5'>";
    echo "<tr><th>Field</th><th>Type</th><th>Null</th><th>Default</th></tr>";
    foreach ($columns as $col) {
        echo "<tr>";
        echo "<td>{$col['Field']}</td>";
        echo "<td>{$col['Type']}</td>";
        echo "<td>{$col['Null']}</td>";
        echo "<td>{$col['Default']}</td>";
        echo "</tr>";
    }
    echo "</table>";
    
    echo "<h3 style='color: green;'>✓ Database update completed!</h3>";
    
} catch (PDOException $e) {
    echo "<p style='color: red;'>Database error: " . $e->getMessage() . "</p>";
}
?>
