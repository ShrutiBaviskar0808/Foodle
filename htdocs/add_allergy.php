<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require_once 'db_config.php';

$input = json_decode(file_get_contents('php://input'), true);

$member_id = $input['member_id'] ?? null;
$allergy_name = $input['allergy_name'] ?? '';
$severity = $input['severity'] ?? 'mild';
$notes = $input['notes'] ?? null;
$visibility = $input['visibility'] ?? 'private';
$created_by_user_id = $input['created_by_user_id'] ?? null;

if (empty($member_id) || empty($allergy_name)) {
    echo json_encode(['success' => false, 'message' => 'Member ID and allergy name are required']);
    exit;
}

try {
    $pdo = getDBConnection();
    
    $stmt = $pdo->prepare("INSERT INTO allergies (member_id, allergy_name, severity, notes, visibility, created_by_user_id, created_at) VALUES (?, ?, ?, ?, ?, ?, NOW())");
    $stmt->execute([$member_id, $allergy_name, $severity, $notes, $visibility, $created_by_user_id]);
    
    $allergy_id = $pdo->lastInsertId();
    
    echo json_encode(['success' => true, 'message' => 'Allergy added successfully', 'allergy_id' => $allergy_id]);
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
}
?>
