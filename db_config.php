<?php
// Database configuration
$servername = "auth-db1927.hstgr.io";
$username = "u196786599_foodle";
$password = "Shruti@0808";
$dbname = "u196786599_foodle";

// Create connection
function getDBConnection() {
    global $servername, $username, $password, $dbname;
    
    try {
        $pdo = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        return $pdo;
    } catch(PDOException $e) {
        throw new Exception("Connection failed: " . $e->getMessage());
    }
}
?>
