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
        
        $member_id = $data['member_id'] ?? '';
        $food_name = $data['food_name'] ?? '';
        $notes = $data['notes'] ?? '';
        $visibility = $data['visibility'] ?? 'private';
        $user_id = $data['user_id'] ?? '';
        
        if (empty($member_id) || empty($food_name) || empty($user_id)) {
            echo json_encode(['success' => false, 'message' => 'Member ID, food name, and user ID required']);
            exit;
        }
        
        $stmt = $pdo->prepare("INSERT INTO foods (member_id, food_name, notes, visibility, created_by_user_id, created_at) VALUES (?, ?, ?, ?, ?, NOW())");
        $stmt->execute([$member_id, $food_name, $notes, $visibility, $user_id]);
        
        echo json_encode(['success' => true, 'message' => 'Food added successfully', 'food_id' => $pdo->lastInsertId()]);
        
    } catch(PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
}
?>
