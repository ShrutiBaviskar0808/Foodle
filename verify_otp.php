<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

$input = json_decode(file_get_contents('php://input'), true);
$email = $input['email'] ?? '';
$otp = $input['otp'] ?? '';

error_log("=== VERIFY OTP (PROJECT ROOT) ===");
error_log("Email: " . $email);
error_log("OTP: " . $otp);

if (empty($email) || empty($otp)) {
    echo json_encode(['success' => false, 'message' => 'Email and OTP are required']);
    exit;
}

$host = 'localhost';
$dbname = 'foodle';
$username = 'root';
$db_password = '';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $db_password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    $stmt = $pdo->prepare("SELECT user_id, otp FROM verify_otp WHERE email = ? ORDER BY created_at DESC LIMIT 1");
    $stmt->execute([$email]);
    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    
    error_log("DB Result: " . json_encode($result));
    
    if ($result && trim($result['otp']) == trim($otp)) {
        $user_id = $result['user_id'];
        
        $updateStmt = $pdo->prepare("UPDATE users SET is_verified = 1 WHERE id = ?");
        $updateStmt->execute([$user_id]);
        
        $deleteStmt = $pdo->prepare("DELETE FROM verify_otp WHERE email = ?");
        $deleteStmt->execute([$email]);
        
        error_log("SUCCESS!");
        echo json_encode(['success' => true, 'message' => 'Email verified successfully!']);
    } else {
        error_log("FAILED - OTP mismatch or not found");
        echo json_encode(['success' => false, 'message' => 'Invalid OTP']);
    }
} catch (PDOException $e) {
    error_log("DB ERROR: " . $e->getMessage());
    echo json_encode(['success' => false, 'message' => 'Database error']);
}
?>
