<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "food_app";
    
    try {
        $pdo = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        
        $json = file_get_contents('php://input');
        $data = json_decode($json, true);
        
        $food_id = $data['food_id'] ?? '';
        $store_name = $data['store_name'] ?? '';
        $food_item = $data['food_item'] ?? '';
        $preferences = $data['preferences'] ?? '';
        $mood = $data['mood'] ?? '';
        $notes = $data['notes'] ?? '';
        $image_path = $data['image_path'] ?? '';
        
        if (empty($food_id)) {
            echo json_encode(['success' => false, 'message' => 'Food ID required']);
            exit;
        }
        
        $stmt = $pdo->prepare("UPDATE foods SET store_name = ?, food_item = ?, preferences = ?, mood = ?, notes = ?, image_path = ? WHERE id = ?");
        $stmt->execute([$store_name, $food_item, $preferences, $mood, $notes, $image_path, $food_id]);
        
        echo json_encode(['success' => true, 'message' => 'Food updated successfully']);
        
    } catch(PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
}
?>
