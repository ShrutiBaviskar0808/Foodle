<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

$input = json_decode(file_get_contents('php://input'), true);

$name = $input['name'];
$email = $input['email'];
$password = $input['password'];

// Database connection
$host = 'localhost';
$dbname = 'food_app';
$username = 'root';
$db_password = '';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $db_password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Check if user already exists
    $checkStmt = $pdo->prepare("SELECT id FROM users WHERE email = ?");
    $checkStmt->execute([$email]);
    if ($checkStmt->fetch()) {
        echo json_encode(['success' => false, 'message' => 'Email already registered']);
        exit;
    }
    
    // Generate OTP
    $otp = rand(1000, 9999);
    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
    
    // Insert user
    $stmt = $pdo->prepare("INSERT INTO users (name, email, password, created_at) VALUES (?, ?, ?, NOW())");
    $stmt->execute([$name, $email, $hashedPassword]);
    $userId = $pdo->lastInsertId();
    
    // Delete old OTPs for this email
    $deleteStmt = $pdo->prepare("DELETE FROM verify_otp WHERE email = ?");
    $deleteStmt->execute([$email]);
    
    // Insert OTP into verify_otp table
    $otpStmt = $pdo->prepare("INSERT INTO verify_otp (user_id, email, otp, created_at) VALUES (?, ?, ?, NOW())");
    $otpStmt->execute([$userId, $email, $otp]);
    
    echo json_encode([
        'success' => true,
        'message' => "Account created! Your OTP is: $otp",
        'user_id' => $userId,
        'otp' => $otp
    ]);
    
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
}
?>