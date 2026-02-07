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
        
        $notification_id = $data['notification_id'] ?? '';
        
        if (empty($notification_id)) {
            echo json_encode(['success' => false, 'message' => 'Notification ID required']);
            exit;
        }
        
        $stmt = $pdo->prepare("UPDATE member_notifications SET is_read = TRUE WHERE id = ?");
        $stmt->execute([$notification_id]);
        
        echo json_encode(['success' => true, 'message' => 'Notification marked as read']);
        
    } catch(PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
}
?>
