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
        
        $food_id = $data['food_id'] ?? '';
        $food_name = $data['food_name'] ?? '';
        $notes = $data['notes'] ?? '';
        $visibility = $data['visibility'] ?? 'private';
        
        if (empty($food_id)) {
            echo json_encode(['success' => false, 'message' => 'Food ID required']);
            exit;
        }
        
        $stmt = $pdo->prepare("UPDATE foods SET food_name = ?, notes = ?, visibility = ? WHERE id = ?");
        $stmt->execute([$food_name, $notes, $visibility, $food_id]);
        
        echo json_encode(['success' => true, 'message' => 'Food updated successfully']);
        
    } catch(PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
}
?>
