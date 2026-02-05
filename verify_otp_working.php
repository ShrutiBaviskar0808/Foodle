<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    
    $user_id = $input['user_id'] ?? '';
    $otp = $input['otp'] ?? '';
    
    if (empty($user_id) || empty($otp)) {
        echo json_encode(['success' => false, 'message' => 'User ID and OTP required']);
        exit;
    }
    
    try {
        $pdo = new PDO("mysql:host=localhost;dbname=foodle", "root", "");
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        
        // Check if OTP exists and matches
        $stmt = $pdo->prepare("SELECT * FROM verify_otp WHERE user_id = ? AND otp = ?");
        $stmt->execute([$user_id, $otp]);
        $otpRecord = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($otpRecord) {
            // Update user as verified
            $stmt = $pdo->prepare("UPDATE users SET is_verified = 1 WHERE id = ?");
            $stmt->execute([$user_id]);
            
            // Delete used OTP
            $stmt = $pdo->prepare("DELETE FROM verify_otp WHERE user_id = ? AND otp = ?");
            $stmt->execute([$user_id, $otp]);
            
            echo json_encode([
                'success' => true,
                'message' => 'Email verified successfully!'
            ]);
        } else {
            echo json_encode(['success' => false, 'message' => 'Invalid OTP']);
        }
        
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
    }
}
?>