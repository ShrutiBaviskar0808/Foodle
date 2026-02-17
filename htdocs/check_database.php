<?php
header('Content-Type: application/json');
require_once 'db_config.php';

try {
    $pdo = getDBConnection();
    
    // Get all records for member_id 23
    $stmt = $pdo->prepare("SELECT id, member_id, food_name, restaurant, calories, LENGTH(image_path) as image_length, is_custom_food, created_at FROM allergies WHERE member_id = 23 ORDER BY id DESC");
    $stmt->execute();
    $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode([
        'success' => true,
        'count' => count($results),
        'data' => $results
    ], JSON_PRETTY_PRINT);
} catch (PDOException $e) {
    echo json_encode([
        'success' => false,
        'error' => $e->getMessage()
    ]);
}
?>
