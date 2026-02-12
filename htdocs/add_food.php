<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require_once 'db_config.php';

$input = json_decode(file_get_contents('php://input'), true);

$member_id = $input['member_id'] ?? null;
$food_name = $input['food_name'] ?? '';
$preference_type = $input['preference_type'] ?? 'like';
$mood_tag = $input['mood_tag'] ?? null;
$photo_path = $input['photo_path'] ?? null;
$notes = $input['notes'] ?? null;
$visibility = $input['visibility'] ?? 'private';
$created_by_user_id = $input['created_by_user_id'] ?? null;

if (empty($member_id) || empty($food_name)) {
    echo json_encode(['success' => false, 'message' => 'Member ID and food name are required']);
    exit;
}

try {
    $pdo = getDBConnection();
    
    $stmt = $pdo->prepare("INSERT INTO foods (member_id, food_name, preference_type, mood_tag, photo_path, notes, visibility, created_by_user_id, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())");
    $stmt->execute([$member_id, $food_name, $preference_type, $mood_tag, $photo_path, $notes, $visibility, $created_by_user_id]);
    
    $food_id = $pdo->lastInsertId();
    
    echo json_encode(['success' => true, 'message' => 'Food added successfully', 'food_id' => $food_id]);
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
}
?>
