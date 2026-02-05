<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "your_database_name"; // Change this to your actual database name
    
    try {
        $pdo = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        
        $email = $_POST['email'] ?? '';
        $password_input = $_POST['password'] ?? '';
        
        if (empty($email) || empty($password_input)) {
            echo json_encode(['success' => false, 'message' => 'Email and password required']);
            exit;
        }
        
        // Check if user exists
        $stmt = $pdo->prepare("SELECT * FROM users WHERE email = ?");
        $stmt->execute([$email]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($user) {
            // Verify password (assuming it's hashed)
            if (password_verify($password_input, $user['password']) || $user['password'] === $password_input) {
                // Check if email is verified
                if ($user['email_verify'] == 0) {
                    echo json_encode([
                        'success' => false, 
                        'message' => 'Please verify your email first'
                    ]);
                } else {
                    // Generate OTP for this demo
                    $otp = rand(1000, 9999);
                    
                    // Insert OTP into otp table
                    $stmt = $pdo->prepare("INSERT INTO otp (user_id, email, otp, created_at) VALUES (?, ?, ?, NOW()) ON DUPLICATE KEY UPDATE otp = ?, created_at = NOW()");
                    $stmt->execute([$user['id'], $email, $otp, $otp]);
                    
                    echo json_encode([
                        'success' => true,
                        'message' => 'OTP: ' . $otp,
                        'user_id' => $user['id']
                    ]);
                }
            } else {
                echo json_encode(['success' => false, 'message' => 'Invalid password']);
            }
        } else {
            echo json_encode(['success' => false, 'message' => 'User not found']);
        }
        
    } catch(PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
}
?>