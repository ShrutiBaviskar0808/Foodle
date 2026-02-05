<?php
// Files to keep (essential ones)
$keep_files = [
    'login.php',
    'signup.php', 
    'verify_otp.php'
];

// Files to delete (all the duplicates and test files)
$delete_files = [
    'login_fixed.php',
    'login_foodle.php', 
    'login_working.php',
    'signup_basic.php',
    'signup_debug.php',
    'signup_foodle.php',
    'signup_simple.php',
    'signup_working.php',
    'verify_otp_working.php',
    'verify_otp_database.php',
    'setup_database.php',
    'setup_foodle_db.php',
    'show_users.php',
    'test_db.php',
    'test_connection.php',
    'test_signup.php',
    'test_verify_otp.php',
    'test.php',
    'simple_email_signup.php',
    'email_signup.php',
    'update_test_user.php'
];

echo "<h2>Cleaning up PHP files...</h2>";

// Delete files from project directory
foreach ($delete_files as $file) {
    if (file_exists($file)) {
        if (unlink($file)) {
            echo "✅ Deleted from project: $file<br>";
        } else {
            echo "❌ Failed to delete: $file<br>";
        }
    }
}

echo "<br><strong>Cleanup completed!</strong><br>";
echo "Only essential files remain: " . implode(', ', $keep_files);
?>