<?php
header('Content-Type: text/html');

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "food_app";

try {
    $pdo = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Get all users
    $stmt = $pdo->prepare("SELECT id, name, email, password, is_verified FROM users");
    $stmt->execute();
    $users = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo "<h2>All Users in Database:</h2>";
    echo "<table border='1' style='border-collapse: collapse;'>";
    echo "<tr><th>ID</th><th>Name</th><th>Email</th><th>Password</th><th>Verified</th></tr>";
    
    foreach ($users as $user) {
        echo "<tr>";
        echo "<td>" . $user['id'] . "</td>";
        echo "<td>" . $user['name'] . "</td>";
        echo "<td>" . $user['email'] . "</td>";
        echo "<td>" . substr($user['password'], 0, 20) . "...</td>";
        echo "<td>" . ($user['is_verified'] ? 'Yes' : 'No') . "</td>";
        echo "</tr>";
    }
    echo "</table>";
    
    echo "<br><strong>Total users: " . count($users) . "</strong>";
    
} catch(PDOException $e) {
    echo "Error: " . $e->getMessage();
}
?>