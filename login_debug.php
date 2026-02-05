<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

// Debug: Log all incoming data
$debug_info = [];

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "food_app";
    
    try {
        // Get JSON input
        $json = file_get_contents('php://input');
        $data = json_decode($json, true);
        
        $debug_info['received_json'] = $json;
        $debug_info['parsed_data'] = $data;
        
        $email = $data['email'] ?? '';
        $password_input = $data['password'] ?? '';
        
        $debug_info['email'] = $email;
        $debug_info['password_length'] = strlen($password_input);
        
        // Connect to database
        $pdo = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        
        $debug_info['database_connected'] = true;
        
        // Check if user exists
        $stmt = $pdo->prepare("SELECT id, name, email, password, is_verified FROM users WHERE email = ?");
        $stmt->execute([$email]);
        $user = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($user) {
            $debug_info['user_found'] = true;
            $debug_info['user_id'] = $user['id'];
            $debug_info['stored_password'] = $user['password'];
            $debug_info['input_password'] = $password_input;
            $debug_info['passwords_match_direct'] = ($user['password'] === $password_input);
            $debug_info['passwords_match_verify'] = password_verify($password_input, $user['password']);
            
            // Simple direct comparison for now
            if ($user['password'] === $password_input) {
                echo json_encode([
                    'success' => true,
                    'message' => 'Login successful',
                    'debug' => $debug_info
                ]);
            } else {
                echo json_encode([
                    'success' => false,
                    'message' => 'Password mismatch',
                    'debug' => $debug_info
                ]);
            }
        } else {
            $debug_info['user_found'] = false;
            echo json_encode([
                'success' => false,
                'message' => 'User not found',
                'debug' => $debug_info
            ]);
        }
        
    } catch(PDOException $e) {
        echo json_encode([
            'success' => false,
            'message' => 'Database error: ' . $e->getMessage(),
            'debug' => $debug_info
        ]);
    }
} else {
    echo json_encode([
        'success' => false,
        'message' => 'Method not allowed',
        'debug' => ['method' => $_SERVER['REQUEST_METHOD']]
    ]);
}
?>