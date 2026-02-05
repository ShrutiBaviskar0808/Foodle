<?php
$htdocs_path = 'C:/xampp/htdocs/';

// List of unwanted files to delete
$unwanted_files = [
    'setup_database.php',
    'create_test_user.php',
    'create_gmail_user.php', 
    'update_test_user.php',
    'login_debug.php',
    'signup_debug.php',
    'test_db.php',
    'show_users.php',
    'login_fixed.php',
    'login_foodle.php',
    'signup_foodle.php',
    'signup_simple.php',
    'fix_otp_column.php'
];

echo "<h2>Cleaning up unwanted PHP files...</h2>";

foreach ($unwanted_files as $file) {
    $file_path = $htdocs_path . $file;
    if (file_exists($file_path)) {
        if (unlink($file_path)) {
            echo "✅ Deleted: $file<br>";
        } else {
            echo "❌ Failed to delete: $file<br>";
        }
    } else {
        echo "⚪ Not found: $file<br>";
    }
}

echo "<br><h3>Remaining files in htdocs:</h3>";
$files = scandir($htdocs_path);
foreach ($files as $file) {
    if ($file != '.' && $file != '..' && pathinfo($file, PATHINFO_EXTENSION) == 'php') {
        echo "📄 $file<br>";
    }
}

echo "<br><strong>Cleanup completed!</strong>";
?>