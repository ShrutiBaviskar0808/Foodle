<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require_once 'db_config.php';

$input = json_decode(file_get_contents('php://input'), true);

// Log the raw input
error_log("Raw input: " . json_encode($input));

$owner_user_id = $input['owner_user_id'] ?? null;
$linked_user_id = $input['linked_user_id'] ?? null;
$display_name = $input['display_name'] ?? '';
$nickname = $input['nickname'] ?? null;
$photo_path = $input['photo_path'] ?? null;
$dob_input = $input['dob'] ?? null;
$age = $input['age'] ?? null;
$relation = $input['relation'] ?? '';

// Convert DOB from DD/MM/YYYY to YYYY-MM-DD
$dob = null;
if ($dob_input) {
    $parts = explode('/', $dob_input);
    if (count($parts) == 3) {
        $dob = $parts[2] . '-' . $parts[1] . '-' . $parts[0];
    }
}

if (empty($owner_user_id) || empty($display_name)) {
    echo json_encode(['success' => false, 'message' => 'Owner user ID and display name are required']);
    exit;
}

// Debug log
error_log("Adding member - nickname: $nickname, photo_path: $photo_path, dob: $dob, age: $age");

try {
    $pdo = getDBConnection();
    
    $stmt = $pdo->prepare("INSERT INTO members (owner_user_id, linked_user_id, display_name, nickname, photo_path, dob, age, relation, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())");
    $stmt->execute([$owner_user_id, $linked_user_id, $display_name, $nickname, $photo_path, $dob, $age, $relation]);
    
    $member_id = $pdo->lastInsertId();
    
    echo json_encode(['success' => true, 'message' => 'Member added successfully', 'member_id' => $member_id]);
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
}
?>
