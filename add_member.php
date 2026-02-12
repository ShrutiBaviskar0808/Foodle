<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require_once 'db_config.php';

$input = json_decode(file_get_contents('php://input'), true);

$owner_user_id = $input['owner_user_id'] ?? null;
$linked_user_id = $input['linked_user_id'] ?? null;
$display_name = $input['display_name'] ?? '';
$relation = $input['relation'] ?? '';

if (empty($owner_user_id) || empty($display_name)) {
    echo json_encode(['success' => false, 'message' => 'Owner user ID and display name are required']);
    exit;
}

try {
    $pdo = getDBConnection();
    
    $stmt = $pdo->prepare("INSERT INTO members (owner_user_id, linked_user_id, display_name, relation, created_at) VALUES (?, ?, ?, ?, NOW())");
    $stmt->execute([$owner_user_id, $linked_user_id, $display_name, $relation]);
    
    $member_id = $pdo->lastInsertId();
    
    echo json_encode(['success' => true, 'message' => 'Member added successfully', 'member_id' => $member_id]);
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
}
?>
