<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "foodle";
    
    try {
        $pdo = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        
        $json = file_get_contents('php://input');
        $data = json_decode($json, true);
        
        $user_id = $data['user_id'] ?? '';
        $name = $data['name'] ?? '';
        $nickname = $data['nickname'] ?? '';
        $dob = $data['dob'] ?? '';
        $age = $data['age'] ?? 0;
        $relation = $data['relation'] ?? '';
        $food_name = $data['food_name'] ?? '';
        $allergies = $data['allergies'] ?? '';
        $image_path = $data['image_path'] ?? '';
        $email = $data['email'] ?? '';
        $phone = $data['phone'] ?? '';
        
        if (empty($user_id) || empty($name) || empty($relation)) {
            echo json_encode(['success' => false, 'message' => 'User ID, name and relation required']);
            exit;
        }
        
        // Check if member has an account by email
        $member_user_id = null;
        if (!empty($email)) {
            $stmt = $pdo->prepare("SELECT id, name FROM users WHERE email = ?");
            $stmt->execute([$email]);
            $member_user = $stmt->fetch(PDO::FETCH_ASSOC);
            if ($member_user) {
                $member_user_id = $member_user['id'];
            }
        }
        
        // Get current user's name
        $stmt = $pdo->prepare("SELECT name FROM users WHERE id = ?");
        $stmt->execute([$user_id]);
        $current_user = $stmt->fetch(PDO::FETCH_ASSOC);
        $added_by_name = $current_user['name'] ?? 'Someone';
        
        $stmt = $pdo->prepare("INSERT INTO members (user_id, name, nickname, dob, age, relation, food_name, allergies, image_path, email, phone, member_user_id, added_by_user_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
        $stmt->execute([$user_id, $name, $nickname, $dob, $age, $relation, $food_name, $allergies, $image_path, $email, $phone, $member_user_id, $user_id]);
        
        $member_id = $pdo->lastInsertId();
        
        // Create notification if member has an account
        if ($member_user_id) {
            $stmt = $pdo->prepare("INSERT INTO member_notifications (member_id, user_id, added_by_user_id, added_by_name, relation) VALUES (?, ?, ?, ?, ?)");
            $stmt->execute([$member_id, $member_user_id, $user_id, $added_by_name, $relation]);
        }
        
        echo json_encode(['success' => true, 'message' => 'Member added successfully', 'member_id' => $member_id]);
        
    } catch(PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
}
?>
