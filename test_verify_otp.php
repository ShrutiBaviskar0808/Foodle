<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['success' => false, 'message' => 'Method not allowed']);
    exit;
}

$input = json_decode(file_get_contents('php://input'), true);

if (!$input || !isset($input['user_id'], $input['otp'])) {
    echo json_encode(['success' => false, 'message' => 'Missing user_id or otp']);
    exit;
}

$userId = $input['user_id'];
$otp = trim($input['otp']);

// For testing - accept any 6-digit OTP
if (strlen($otp) === 6 && is_numeric($otp)) {
    echo json_encode([
        'success' => true, 
        'message' => 'Email verified successfully! Welcome to Food App'
    ]);
} else {
    echo json_encode([
        'success' => false, 
        'message' => 'Invalid OTP. Please enter a 6-digit number.'
    ]);
}
?>