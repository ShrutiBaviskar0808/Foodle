<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

require_once 'db_config.php';

try {
    $pdo = getDBConnection();
    
    // Get all members
    $stmt = $pdo->query("SELECT id, owner_user_id, display_name, relation FROM members ORDER BY created_at DESC LIMIT 10");
    $members = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Get all foods
    $stmt2 = $pdo->query("SELECT id, member_id, food_name FROM foods ORDER BY created_at DESC LIMIT 10");
    $foods = $stmt2->fetchAll(PDO::FETCH_ASSOC);
    
    // Get all users
    $stmt3 = $pdo->query("SELECT id, name, email FROM users LIMIT 10");
    $users = $stmt3->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode([
        'success' => true,
        'members' => $members,
        'foods' => $foods,
        'users' => $users
    ], JSON_PRETTY_PRINT);
} catch (PDOException $e) {
    echo json_encode(['success' => false, 'error' => $e->getMessage()]);
}
?>
