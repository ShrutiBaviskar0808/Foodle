<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require_once 'db_config.php';

$input = json_decode(file_get_contents('php://input'), true);

$member_id = $input['member_id'] ?? null;
$display_name = $input['display_name'] ?? null;
$relation = $input['relation'] ?? null;
$image_path = $input['image_path'] ?? null;

if (empty($member_id)) {
    echo json_encode(['success' => false, 'message' => 'Member ID is required']);
    exit;
}

try {
    $pdo = getDBConnection();
    
    // Build update query dynamically based on provided fields
    $updates = [];
    $params = [];
    
    if ($display_name !== null) {
        $updates[] = "display_name = ?";
        $params[] = $display_name;
    }
    
    if ($relation !== null) {
        $updates[] = "relation = ?";
        $params[] = $relation;
    }
    
    if ($image_path !== null) {
        $updates[] = "image_path = ?";
        $params[] = $image_path;
    }
    
    if (empty($updates)) {
        echo json_encode(['success' => false, 'message' => 'No fields to update']);
        exit;
    }
    
    $params[] = $member_id;
    $sql = "UPDATE members SET " . implode(", ", $updates) . " WHERE id = ?";
    
    $stmt = $pdo->prepare($sql);
    $stmt->execute($params);
    
    echo json_encode(['success' => true, 'message' => 'Member updated successfully']);
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
}
?>
