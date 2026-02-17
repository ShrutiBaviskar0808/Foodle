<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require_once 'db_config.php';

$input = json_decode(file_get_contents('php://input'), true);

$member_id = $input['member_id'] ?? null;
$food_name = $input['food_name'] ?? '';
$restaurant = $input['restaurant'] ?? 'Custom';
$calories = $input['calories'] ?? '0';
$image_base64 = $input['image_base64'] ?? null;

error_log("Save Custom Food - Member ID: $member_id, Food: $food_name, Has Image: " . ($image_base64 ? 'YES (' . strlen($image_base64) . ' chars)' : 'NO'));

if (empty($member_id) || empty($food_name)) {
    echo json_encode(['success' => false, 'message' => 'Member ID and food name are required']);
    exit;
}

try {
    $pdo = getDBConnection();
    
    // Check if columns exist
    $columns = $pdo->query("SHOW COLUMNS FROM allergies")->fetchAll(PDO::FETCH_COLUMN);
    $hasCustomColumn = in_array('is_custom_food', $columns);
    $hasCreatedAt = in_array('created_at', $columns);
    
    // Build INSERT query based on available columns
    $fields = "member_id, food_name, restaurant, calories, image_path";
    $placeholders = "?, ?, ?, ?, ?";
    $values = [$member_id, $food_name, $restaurant, $calories, $image_base64];
    
    if ($hasCustomColumn) {
        $fields .= ", is_custom_food";
        $placeholders .= ", 1";
    }
    if ($hasCreatedAt) {
        $fields .= ", created_at";
        $placeholders .= ", NOW()";
    }
    
    $stmt = $pdo->prepare("INSERT INTO allergies ($fields) VALUES ($placeholders)");
    $result = $stmt->execute($values);
    
    if ($result) {
        echo json_encode(['success' => true, 'message' => 'Custom food saved successfully', 'id' => $pdo->lastInsertId()]);
    } else {
        echo json_encode(['success' => false, 'message' => 'Failed to save']);
    }
} catch (PDOException $e) {
    error_log("Database error: " . $e->getMessage());
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
}
?>
