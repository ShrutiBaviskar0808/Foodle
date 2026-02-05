<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

$debug = [];

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    try {
        $input = json_decode(file_get_contents('php://input'), true);
        $debug['received_data'] = $input;
        
        $name = $input['name'] ?? '';
        $email = $input['email'] ?? '';
        $password = $input['password'] ?? '';
        
        $debug['parsed_data'] = ['name' => $name, 'email' => $email, 'password_length' => strlen($password)];
        
        if (empty($name) || empty($email) || empty($password)) {
            echo json_encode(['success' => false, 'message' => 'All fields required', 'debug' => $debug]);
            exit;
        }
        
        // Database connection
        $host = 'localhost';
        $dbname = 'food_app';
        $username = 'root';
        $db_password = '';
        
        $pdo = new PDO("mysql:host=$host;dbname=$dbname", $username, $db_password);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        $debug['database_connected'] = true;
        
        // Check if email already exists
        $stmt = $pdo->prepare("SELECT id FROM users WHERE email = ?");
        $stmt->execute([$email]);
        if ($stmt->fetch()) {
            echo json_encode(['success' => false, 'message' => 'Email already exists', 'debug' => $debug]);
            exit;
        }
        
        // Generate OTP and hash password
        $otp = rand(100000, 999999);
        $hashedPassword = password_hash($password, PASSWORD_DEFAULT);
        $debug['otp'] = $otp;
        $debug['password_hashed'] = true;
        
        // Insert user
        $stmt = $pdo->prepare("INSERT INTO users (name, email, password, otp, is_verified, created_at) VALUES (?, ?, ?, ?, 0, NOW())");
        $result = $stmt->execute([$name, $email, $hashedPassword, $otp]);
        $userId = $pdo->lastInsertId();
        
        $debug['insert_result'] = $result;
        $debug['user_id'] = $userId;
        
        echo json_encode([
            'success' => true,
            'message' => "Account created! Your OTP is: $otp",
            'user_id' => $userId,
            'debug' => $debug
        ]);
        
    } catch (PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage(), 'debug' => $debug]);
    } catch (Exception $e) {
        echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage(), 'debug' => $debug]);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
}
?>