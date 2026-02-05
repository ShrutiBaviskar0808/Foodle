<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "foodle"; // Change this to your actual database name
    
    try {
        $pdo = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        
        // Get JSON input
        $json = file_get_contents('php://input');
        $data = json_decode($json, true);
        
        $email = $data['email'] ?? '';
        $password_input = $data['password'] ?? '';
        
        if (empty($email) || empty($password_input)) {
            echo json_encode(['success' => false, 'message' => 'Email and password required']);
            exit;
        }
        
        // Check if user exists
        $stmt = $pdo->prepare("SELECT * FROM users WHERE email = ?");
        $stmt->execute([$email]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($user) {
            // Verify password (check both hashed and plain text for compatibility)
            if (password_verify($password_input, $user['password']) || $user['password'] === $password_input) {
                // Login successful - go directly to home (no OTP for login)
                echo json_encode([
                    'success' => true,
                    'message' => 'Login successful',
                    'user_id' => $user['id']
                ]);
            } else {
                echo json_encode(['success' => false, 'message' => 'Invalid password']);
            }
        } else {
            echo json_encode(['success' => false, 'message' => 'User not found. Please register yourself.']);
        }
        
    } catch(PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
}
?>