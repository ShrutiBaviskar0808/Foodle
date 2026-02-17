<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

require_once 'db_config.php';

$input = json_decode(file_get_contents('php://input'), true);

$member_id = $input['member_id'] ?? null;
$food_name = $input['food_name'] ?? '';
$restaurant = $input['restaurant'] ?? 'Custom';
$calories = $input['calories'] ?? '0';
$image_base64 = $input['image_base64'] ?? null;

error_log("Save Custom Food - Member ID: $member_id, Food: $food_name, Has Image: " . ($image_base64 ? 'YES (' . strlen($image_base64) . ' chars)' : 'NO'));

if (empty($member_id) || empty($food_name)) {
    echo json_encode(['success' => false, 'message' => 'Member ID and food name are required']);
    exit;
}

try {
    $pdo = getDBConnection();
    
    // Check if column exists and its type
    $checkColumn = $pdo->query("SHOW COLUMNS FROM allergies LIKE 'image_path'");
    $columnInfo = $checkColumn->fetch(PDO::FETCH_ASSOC);
    error_log("Column info: " . json_encode($columnInfo));
    
    // Delete any existing custom food with the same name for this member
    $deleteStmt = $pdo->prepare("DELETE FROM allergies WHERE member_id = ? AND food_name = ? AND is_custom_food = 1");
    $deleteStmt->execute([$member_id, $food_name]);
    error_log("Deleted " . $deleteStmt->rowCount() . " existing rows with same food name");
    
    $image_path = null;
    if ($image_base64) {
        $image_path = $image_base64;
        error_log("Image data length: " . strlen($image_path) . " characters");
        
        // If image is too large, truncate or skip
        if (strlen($image_path) > 16777215) { // MEDIUMTEXT limit
            error_log("WARNING: Image too large, truncating");
            $image_path = substr($image_path, 0, 16777215);
        }
    }
    
    $stmt = $pdo->prepare("INSERT INTO allergies (member_id, food_name, restaurant, calories, image_path, is_custom_food, created_at) VALUES (?, ?, ?, ?, ?, 1, NOW())");
    $result = $stmt->execute([$member_id, $food_name, $restaurant, $calories, $image_path]);
    
    if ($result) {
        $custom_food_id = $pdo->lastInsertId();
        
        // Verify the data was actually saved
        $verify = $pdo->prepare("SELECT id, food_name, restaurant, calories, LENGTH(image_path) as img_len FROM allergies WHERE id = ?");
        $verify->execute([$custom_food_id]);
        $saved = $verify->fetch(PDO::FETCH_ASSOC);
        error_log("Verified saved data: " . json_encode($saved));
        
        echo json_encode([
            'success' => true, 
            'message' => 'Custom food saved successfully', 
            'custom_food_id' => $custom_food_id,
            'debug' => [
                'member_id' => $member_id,
                'food_name' => $food_name,
                'restaurant' => $restaurant,
                'calories' => $calories,
                'image_saved' => $image_path ? true : false,
                'image_length_saved' => $saved['img_len'] ?? 0
            ]
        ]);
    } else {
        error_log("Failed to execute insert statement");
        echo json_encode(['success' => false, 'message' => 'Failed to save custom food']);
    }
} catch (PDOException $e) {
    error_log("Database error: " . $e->getMessage());
    echo json_encode(['success' => false, 'message' => 'Database error: ' . $e->getMessage()]);
}
?>
