<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    
    $name = $input['name'] ?? '';
    $email = $input['email'] ?? '';
    $password = $input['password'] ?? '';
    
    if (empty($name) || empty($email) || empty($password)) {
        echo json_encode(['success' => false, 'message' => 'All fields required']);
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
        
        // Check if email already exists
        $stmt = $pdo->prepare("SELECT id FROM users WHERE email = ?");
        $stmt->execute([$email]);
        if ($stmt->fetch()) {
            echo json_encode(['success' => false, 'message' => 'Email already exists']);
            exit;
        }
        
        // Generate OTP
        $otp = rand(100000, 999999);
        $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
        
        // Insert user WITHOUT otp column
        $stmt = $pdo->prepare("INSERT INTO users (name, email, password, is_verified, created_at) VALUES (?, ?, ?, 0, NOW())");
        $stmt->execute([$name, $email, $hashedPassword]);
        $userId = $pdo->lastInsertId();
        
        // Insert into verify_otp table
        $stmt2 = $pdo->prepare("INSERT INTO verify_otp (user_id, email, otp, created_at) VALUES (?, ?, ?, NOW())");
        $stmt2->execute([$userId, $email, $otp]);
        
        echo json_encode([
            'success' => true,
            'message' => "Account created! Your OTP is: $otp",
            'user_id' => $userId
        ]);
        
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
}
?>