<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "food_app"; // Correct database name
    
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
        $stmt = $pdo->prepare("SELECT id, name, email, password, is_verified FROM users WHERE email = ?");
        $stmt->execute([$email]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($user) {
            // Check password (both hashed and plain text)
            $password_match = false;
            
            // Try password_verify first (for hashed passwords)
            if (password_verify($password_input, $user['password'])) {
                $password_match = true;
            }
            // Try direct comparison (for plain text passwords)
            else if ($user['password'] === $password_input) {
                $password_match = true;
            }
            
            if ($password_match) {
                // Login successful
                echo json_encode([
                    'success' => true,
                    'message' => 'Login successful',
                    'user_id' => $user['id'],
                    'user_name' => $user['name']
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