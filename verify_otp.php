<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

$input = json_decode(file_get_contents('php://input'), true);

$otp = $input['otp'];

// Accept any 6-digit OTP
if (strlen($otp) == 6) {
    echo json_encode([
        'success' => true,
        'message' => 'Email verified successfully!'
    ]);
} else {
    echo json_encode([
        'success' => false,
        'message' => 'Invalid OTP'
    ]);
}
?>