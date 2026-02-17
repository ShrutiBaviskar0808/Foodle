<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require_once 'db_config.php';

$input = json_decode(file_get_contents('php://input'), true);
$member_id = $input['member_id'] ?? null;

if (empty($member_id)) {
    echo json_encode(['success' => false, 'message' => 'Member ID is required']);
    exit;
}

try {
    $pdo = getDBConnection();
    
    $stmt = $pdo->prepare("SELECT food_name, restaurant, calories, image_path FROM allergies WHERE member_id = ? AND is_custom_food = 1 ORDER BY created_at DESC");
    $stmt->execute([$member_id]);
    $custom_foods = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode(['success' => true, 'custom_foods' => $custom_foods]);
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
}
?>
