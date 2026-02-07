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
        
        $owner_user_id = $data['owner_user_id'] ?? '';
        $display_name = $data['display_name'] ?? '';
        $relation = $data['relation'] ?? '';
        
        if (empty($owner_user_id) || empty($display_name) || empty($relation)) {
            echo json_encode(['success' => false, 'message' => 'Owner user ID, display name and relation required']);
            exit;
        }
        
        $stmt = $pdo->prepare("INSERT INTO members (owner_user_id, display_name, relation) VALUES (?, ?, ?)");
        $stmt->execute([$owner_user_id, $display_name, $relation]);
        
        echo json_encode(['success' => true, 'message' => 'Member added successfully', 'member_id' => $pdo->lastInsertId()]);
        
    } catch(PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
}
?>
