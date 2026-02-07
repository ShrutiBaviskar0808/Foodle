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
        
        if (empty($user_id) || empty($name) || empty($relation)) {
            echo json_encode(['success' => false, 'message' => 'User ID, name and relation required']);
            exit;
        }
        
        $stmt = $pdo->prepare("INSERT INTO members (user_id, name, nickname, dob, age, relation, food_name, allergies, image_path) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
        $stmt->execute([$user_id, $name, $nickname, $dob, $age, $relation, $food_name, $allergies, $image_path]);
        
        echo json_encode(['success' => true, 'message' => 'Member added successfully', 'member_id' => $pdo->lastInsertId()]);
        
    } catch(PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
}
?>
