<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require_once 'config.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    
    $name = $input['name'] ?? '';
    $email = $input['email'] ?? '';
    $password = $input['password'] ?? '';
    
    if (empty($name) || empty($email) || empty($password)) {
        echo json_encode(['success' => false, 'message' => 'All fields required']);
        exit;
    }
    
    // Check if email exists
    $stmt = $pdo->prepare("SELECT id FROM users WHERE email = ?");
    $stmt->execute([$email]);
    if ($stmt->fetch()) {
        echo json_encode(['success' => false, 'message' => 'Email already exists']);
        exit;
    }
    
    // Generate OTP
    $otp = rand(1000, 9999);
    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
    
    try {
        // Insert user
        $stmt = $pdo->prepare("INSERT INTO users (name, email, password, email_verify) VALUES (?, ?, ?, 0)");
        $stmt->execute([$name, $email, $hashedPassword]);
        $userId = $pdo->lastInsertId();
        
        // Store OTP
        $stmt = $pdo->prepare("INSERT INTO verify_otp (user_id, email, otp, created_at) VALUES (?, ?, ?, NOW())");
        $stmt->execute([$userId, $email, $otp]);
        
        // Send email (simplified - you'd use a proper email service)
        mail($email, "Foodle Verification", "Your OTP is: $otp");
        
        echo json_encode(['success' => true, 'message' => 'OTP sent to email', 'user_id' => $userId]);
    } catch(Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Registration failed']);
    }
}
?>