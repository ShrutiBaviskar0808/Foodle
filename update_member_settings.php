<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require_once 'db_config.php';

$input = json_decode(file_get_contents('php://input'), true);

$member_id = $input['member_id'] ?? null;
$allow_shared_view = $input['allow_shared_view'] ?? 0;
$show_allergy_warning = $input['show_allergy_warning'] ?? 1;

if (empty($member_id)) {
    echo json_encode(['success' => false, 'message' => 'Member ID is required']);
    exit;
}

try {
    $pdo = getDBConnection();
    
    $stmt = $pdo->prepare("INSERT INTO member_settings (member_id, allow_shared_view, show_allergy_warning) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE allow_shared_view = ?, show_allergy_warning = ?");
    $stmt->execute([$member_id, $allow_shared_view, $show_allergy_warning, $allow_shared_view, $show_allergy_warning]);
    
    echo json_encode(['success' => true, 'message' => 'Settings updated successfully']);
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
}
?>
