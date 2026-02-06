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
        $store_name = $data['store_name'] ?? '';
        $food_item = $data['food_item'] ?? '';
        $preferences = $data['preferences'] ?? '';
        $mood = $data['mood'] ?? '';
        $notes = $data['notes'] ?? '';
        $image_path = $data['image_path'] ?? '';
        
        if (empty($user_id) || empty($store_name)) {
            echo json_encode(['success' => false, 'message' => 'User ID and store name required']);
            exit;
        }
        
        $stmt = $pdo->prepare("INSERT INTO foods (user_id, store_name, food_item, preferences, mood, notes, image_path) VALUES (?, ?, ?, ?, ?, ?, ?)");
        $stmt->execute([$user_id, $store_name, $food_item, $preferences, $mood, $notes, $image_path]);
        
        echo json_encode(['success' => true, 'message' => 'Food added successfully', 'food_id' => $pdo->lastInsertId()]);
        
    } catch(PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
}
?>
