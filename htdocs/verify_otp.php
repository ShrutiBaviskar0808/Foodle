<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

$input = json_decode(file_get_contents('php://input'), true);

$email = $input['email'] ?? '';
$otp = $input['otp'] ?? '';

// Log received data
error_log("Received email: " . $email);
error_log("Received OTP: " . $otp);

if (empty($email) || empty($otp)) {
    echo json_encode(['success' => false, 'message' => 'Email and OTP are required']);
    exit;
}

// Database connection
$host = 'localhost';
$dbname = 'foodle';
$username = 'root';
$db_password = '';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $db_password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Check OTP from verify_otp table
    $stmt = $pdo->prepare("SELECT user_id, otp FROM verify_otp WHERE email = ? ORDER BY created_at DESC LIMIT 1");
    $stmt->execute([$email]);
    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    
    error_log("Database result: " . json_encode($result));
    
    if ($result) {
        // Compare OTPs (trim whitespace)
        if (trim($result['otp']) == trim($otp)) {
            $user_id = $result['user_id'];
            
            // Update user as verified
            $updateStmt = $pdo->prepare("UPDATE users SET is_verified = 1 WHERE id = ?");
            $updateStmt->execute([$user_id]);
            
            // Delete used OTP
            $deleteStmt = $pdo->prepare("DELETE FROM verify_otp WHERE email = ?");
            $deleteStmt->execute([$email]);
            
            echo json_encode([
                'success' => true,
                'message' => 'Email verified successfully!'
            ]);
        } else {
            error_log("OTP mismatch - DB: '" . $result['otp'] . "' vs Input: '" . $otp . "'");
            echo json_encode([
                'success' => false,
                'message' => 'Invalid OTP. Please check and try again.'
            ]);
        }
    } else {
        error_log("No OTP found for email: " . $email);
        echo json_encode([
            'success' => false,
            'message' => 'No OTP found for this email. Please request a new OTP.'
        ]);
    }
    
} catch (PDOException $e) {
    error_log("Database error: " . $e->getMessage());
    echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
}
?>
