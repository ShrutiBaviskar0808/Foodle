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

if (empty($member_id) || empty($food_name)) {
    echo json_encode(['success' => false, 'message' => 'Member ID and food name are required']);
    exit;
}

try {
    $pdo = getDBConnection();
    
    $image_path = null;
    if ($image_base64) {
        $image_path = $image_base64;
    }
    
    $stmt = $pdo->prepare("INSERT INTO allergies (member_id, food_name, restaurant, calories, image_path, is_custom_food, created_at) VALUES (?, ?, ?, ?, ?, 1, NOW())");
    $stmt->execute([$member_id, $food_name, $restaurant, $calories, $image_path]);
    
    $custom_food_id = $pdo->lastInsertId();
    
    echo json_encode(['success' => true, 'message' => 'Custom food saved successfully', 'custom_food_id' => $custom_food_id]);
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
}
?>
