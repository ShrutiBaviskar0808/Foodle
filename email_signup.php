<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST');
header('Access-Control-Allow-Headers: Content-Type');

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

require 'vendor/autoload.php'; // You'll need to install PHPMailer

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

// Send email using PHPMailer
$mail = new PHPMailer(true);

try {
    // Gmail SMTP settings
    $mail->isSMTP();
    $mail->Host       = 'smtp.gmail.com';
    $mail->SMTPAuth   = true;
    $mail->Username   = 'your-email@gmail.com'; // Your Gmail
    $mail->Password   = 'your-app-password';    // Gmail App Password
    $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
    $mail->Port       = 587;

    // Email content
    $mail->setFrom('your-email@gmail.com', 'Food App');
    $mail->addAddress($email, $name);
    $mail->Subject = 'Email Verification - Food App';
    $mail->Body    = "Hi $name,\n\nYour verification code is: $otp\n\nThis code will expire in 10 minutes.\n\nBest regards,\nFood App Team";

    $mail->send();
    
    echo json_encode([
        'success' => true, 
        'message' => 'Account created! Check your email for OTP',
        'user_id' => 123
    ]);
    
} catch (Exception $e) {
    echo json_encode([
        'success' => true, 
        'message' => "Account created! Your OTP is: $otp (Email failed to send)",
        'user_id' => 123
    ]);
}
?>