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
    
    // Generate OTP
    $otp = rand(100000, 999999);
    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
    
    // Insert user with OTP
    $stmt = $pdo->prepare("INSERT INTO users (name, email, password, otp, is_verified, created_at) VALUES (?, ?, ?, ?, 0, NOW())");
    $stmt->execute([$name, $email, $hashedPassword, $otp]);
    $userId = $pdo->lastInsertId();
    
    echo json_encode([
        'success' => true,
        'message' => "Account created! Your OTP is: $otp",
        'user_id' => $userId
    ]);
    
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
}
?>