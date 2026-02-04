<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    $email = $input['email'] ?? '';
    
    if (empty($email)) {
        echo json_encode(['success' => false, 'message' => 'Email is required']);
        exit;
    }
    
    // Generate 4-digit OTP
    $otp = rand(1000, 9999);
    
    // Store OTP in session or database (using session for simplicity)
    session_start();
    $_SESSION['otp'] = $otp;
    $_SESSION['email'] = $email;
    $_SESSION['otp_time'] = time();
    
    // In production, send actual email here
    // For demo, just return the OTP
    echo json_encode([
        'success' => true, 
        'message' => 'OTP sent successfully',
        'otp' => $otp // Remove this in production
    ]);
} else {
    echo json_encode(['success' => false, 'message' => 'Invalid request method']);
}
?>