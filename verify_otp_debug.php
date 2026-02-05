<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    
    $user_id = $input['user_id'] ?? '';
    $otp = $input['otp'] ?? '';
    
    $debug = [
        'received_user_id' => $user_id,
        'received_otp' => $otp,
        'otp_length' => strlen($otp)
    ];
    
    if (empty($user_id) || empty($otp)) {
        echo json_encode(['success' => false, 'message' => 'User ID and OTP required', 'debug' => $debug]);
        exit;
    }
    
    try {
        $pdo = new PDO("mysql:host=localhost;dbname=foodle", "root", "");
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        
        // Get all OTPs for this user to debug
        $stmt = $pdo->prepare("SELECT * FROM verify_otp WHERE user_id = ?");
        $stmt->execute([$user_id]);
        $allOtps = $stmt->fetchAll(PDO::FETCH_ASSOC);
        $debug['all_otps_for_user'] = $allOtps;
        
        // Check if OTP exists and matches
        $stmt = $pdo->prepare("SELECT * FROM verify_otp WHERE user_id = ? AND otp = ?");
        $stmt->execute([$user_id, $otp]);
        $otpRecord = $stmt->fetch(PDO::FETCH_ASSOC);
        $debug['matching_otp_record'] = $otpRecord;
        
        if ($otpRecord) {
            // Update user as verified
            $stmt = $pdo->prepare("UPDATE users SET is_verified = 1 WHERE id = ?");
            $stmt->execute([$user_id]);
            
            // Delete used OTP
            $stmt = $pdo->prepare("DELETE FROM verify_otp WHERE user_id = ? AND otp = ?");
            $stmt->execute([$user_id, $otp]);
            
            echo json_encode([
                'success' => true,
                'message' => 'Email verified successfully!',
                'debug' => $debug
            ]);
        } else {
            echo json_encode([
                'success' => false, 
                'message' => 'Invalid OTP',
                'debug' => $debug
            ]);
        }
        
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage(), 'debug' => $debug]);
    }
}
?>