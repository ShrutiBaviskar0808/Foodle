<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require_once 'config.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    
    $userId = $input['user_id'] ?? '';
    $otp = $input['otp'] ?? '';
    
    if (empty($userId) || empty($otp)) {
        echo json_encode(['success' => false, 'message' => 'User ID and OTP required']);
        exit;
    }
    
    // Verify OTP
    $stmt = $pdo->prepare("SELECT * FROM verify_otp WHERE user_id = ? AND otp = ? AND created_at > DATE_SUB(NOW(), INTERVAL 10 MINUTE)");
    $stmt->execute([$userId, $otp]);
    
    if ($stmt->fetch()) {
        // Update user email_verify status
        $stmt = $pdo->prepare("UPDATE users SET email_verify = 1 WHERE id = ?");
        $stmt->execute([$userId]);
        
        // Delete OTP record
        $stmt = $pdo->prepare("DELETE FROM verify_otp WHERE user_id = ?");
        $stmt->execute([$userId]);
        
        echo json_encode(['success' => true, 'message' => 'Email verified successfully']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Invalid or expired OTP']);
    }
}
?>