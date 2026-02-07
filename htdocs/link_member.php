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
        $user_name = $data['user_name'] ?? '';
        
        if (empty($user_id) || empty($user_name)) {
            echo json_encode(['success' => false, 'message' => 'User ID and name required']);
            exit;
        }
        
        // Find members with matching display_name and link them
        $stmt = $pdo->prepare("UPDATE members SET linked_user_id = ? WHERE display_name = ? AND linked_user_id IS NULL");
        $stmt->execute([$user_id, $user_name]);
        
        $linked_count = $stmt->rowCount();
        
        // Get who added this user
        $stmt = $pdo->prepare("SELECT DISTINCT u.name as added_by_name, m.relation FROM members m JOIN users u ON m.owner_user_id = u.id WHERE m.linked_user_id = ?");
        $stmt->execute([$user_id]);
        $added_by = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        echo json_encode(['success' => true, 'linked_count' => $linked_count, 'added_by' => $added_by]);
        
    } catch(PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
}
?>
