// Test this URL in browser: http://localhost/test.php
<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');
header('Access-Control-Allow-Headers: Content-Type');

echo json_encode([
    'success' => true,
    'message' => 'XAMPP is working!',
    'timestamp' => date('Y-m-d H:i:s')
]);
?>