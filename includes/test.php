<?php
$conn = new mysqli("localhost", "root", "", "StockWise");

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

echo "Connected successfully!";
?>