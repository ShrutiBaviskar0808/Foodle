<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

$input = json_decode(file_get_contents('php://input'), true);

$email = $input['email'] ?? '';
$otp = $input['otp'] ?? '';

// Database connection
$host = 'localhost';
$dbname = 'food_app';
$username = 'root';
$db_password = '';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $db_password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Check OTP from database
    $stmt = $pdo->prepare("SELECT user_id, otp FROM verify_otp WHERE email = ? ORDER BY created_at DESC LIMIT 1");
    $stmt->execute([$email]);
    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if ($result && $result['otp'] == $otp) {
        // Update user as verified
        $updateStmt = $pdo->prepare("UPDATE users SET is_verified = 1 WHERE id = ?");
        $updateStmt->execute([$result['user_id']]);
        
        // Delete used OTP
        $deleteStmt = $pdo->prepare("DELETE FROM verify_otp WHERE email = ?");
        $deleteStmt->execute([$email]);
        
        echo json_encode([
            'success' => true,
            'message' => 'Email verified successfully!'
        ]);
    } else {
        echo json_encode([
            'success' => false,
            'message' => 'Invalid OTP'
        ]);
    }
    
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
}
?>