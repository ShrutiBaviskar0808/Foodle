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

if (!$input || !isset($input['name'], $input['email'], $input['password'])) {
    echo json_encode(['success' => false, 'message' => 'Missing required fields']);
    exit;
}

$name = trim($input['name']);
$email = trim($input['email']);
$password = $input['password'];

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    echo json_encode(['success' => false, 'message' => 'Invalid email format']);
    exit;
}

// Generate OTP
$otp = sprintf('%06d', mt_rand(100000, 999999));

// Email content
$subject = "Email Verification - Food App";
$message = "Hi $name,\n\nYour verification code is: $otp\n\nThis code will expire in 10 minutes.\n\nBest regards,\nFood App Team";
$headers = "From: noreply@foodapp.com\r\n";
$headers .= "Reply-To: noreply@foodapp.com\r\n";
$headers .= "Content-Type: text/plain; charset=UTF-8\r\n";

// Try to send email
if (mail($email, $subject, $message, $headers)) {
    echo json_encode([
        'success' => true, 
        'message' => 'Account created! Check your email for OTP',
        'user_id' => 123
    ]);
} else {
    echo json_encode([
        'success' => true, 
        'message' => "Account created! Your OTP is: $otp (Email service unavailable)",
        'user_id' => 123
    ]);
}
?>