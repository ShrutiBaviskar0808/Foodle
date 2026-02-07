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
        $allow_shared_view = $data['allow_shared_view'] ?? true;
        $show_allergy_warning = $data['show_allergy_warning'] ?? true;
        
        if (empty($member_id)) {
            echo json_encode(['success' => false, 'message' => 'Member ID required']);
            exit;
        }
        
        $stmt = $pdo->prepare("INSERT INTO member_settings (member_id, allow_shared_view, show_allergy_warning) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE allow_shared_view = ?, show_allergy_warning = ?");
        $stmt->execute([$member_id, $allow_shared_view, $show_allergy_warning, $allow_shared_view, $show_allergy_warning]);
        
        echo json_encode(['success' => true, 'message' => 'Settings updated successfully']);
        
    } catch(PDOException $e) {
        echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
}
?>
