<?php
// Test file to verify which verify_otp.php is being used
echo json_encode([
    'test' => true,
    'message' => 'This is the NEW verify_otp.php file',
    'file_path' => __FILE__,
    'timestamp' => date('Y-m-d H:i:s')
]);
?>
