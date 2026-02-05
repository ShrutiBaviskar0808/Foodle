<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

// Database connection
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "foodle";

try {
    $pdo = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch(PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Database connection failed']);
    exit();
}

$input = json_decode(file_get_contents('php://input'), true);

$email = $input['email'] ?? '';
$otp = $input['otp'] ?? '';

if (empty($email) || empty($otp)) {
    echo json_encode(['success' => false, 'message' => 'Email and OTP are required']);
    exit();
}

// Check if OTP exists and is valid
$stmt = $pdo->prepare("SELECT user_id FROM verify_otp WHERE email = ? AND otp = ?");
$stmt->execute([$email, $otp]);
$result = $stmt->fetch();

if ($result) {
    // Update user as verified
    $updateStmt = $pdo->prepare("UPDATE users SET email_verify = 1 WHERE id = ?");
    $updateStmt->execute([$result['user_id']]);
    
    // Delete the OTP record after successful verification
    $deleteStmt = $pdo->prepare("DELETE FROM verify_otp WHERE email = ? AND otp = ?");
    $deleteStmt->execute([$email, $otp]);
    
    echo json_encode(['success' => true, 'message' => 'Email verified successfully!']);
} else {
    echo json_encode(['success' => false, 'message' => 'Invalid OTP or email']);
}
?>