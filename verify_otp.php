<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require_once 'db_config.php';

$input = json_decode(file_get_contents('php://input'), true);
$email = $input['email'] ?? '';
$otp = $input['otp'] ?? '';

if (empty($email) || empty($otp)) {
    echo json_encode(['success' => false, 'message' => 'Email and OTP are required']);
    exit;
}

try {
    $pdo = getDBConnection();
    
    $stmt = $pdo->prepare("SELECT user_id, otp FROM verify_otp WHERE email = ? ORDER BY created_at DESC LIMIT 1");
    $stmt->execute([$email]);
    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if ($result && trim($result['otp']) == trim($otp)) {
        $user_id = $result['user_id'];
        
        $updateStmt = $pdo->prepare("UPDATE users SET status = 'active' WHERE id = ?");
        $updateStmt->execute([$user_id]);
        
        $deleteStmt = $pdo->prepare("DELETE FROM verify_otp WHERE email = ?");
        $deleteStmt->execute([$email]);
        
        echo json_encode(['success' => true, 'message' => 'Email verified successfully!']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Invalid OTP']);
    }
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Database error']);
}
?>
