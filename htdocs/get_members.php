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
        
        if (empty($owner_user_id)) {
            echo json_encode(['success' => false, 'message' => 'Owner user ID required']);
            exit;
        }
        
        $stmt = $pdo->prepare("SELECT m.*, u.name as linked_user_name FROM members m LEFT JOIN users u ON m.linked_user_id = u.id WHERE m.owner_user_id = ? ORDER BY m.created_at DESC");
        $stmt->execute([$owner_user_id]);
        $members = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        echo json_encode(['success' => true, 'members' => $members]);
        
    } catch(PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
}
?>
