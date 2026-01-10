<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');
include 'dbconnect.php';

if($_SERVER['REQUEST_METHOD'] != 'GET'){
    sendJsonResponse(array("success"=> false, "message" => "Method not allowed"));
    exit();
}

if (!isset($_GET['user_id'])) {
    sendJsonResponse(array('status' => 'failed', 'message' => 'User ID is required'));
}

$user_id = $_GET['user_id'];

//connect donations table with pets table to fetch the pet_name
$sql = "SELECT tbl_donations.*, tbl_pets.pet_name, tbl_pets.image_paths
        FROM tbl_donations 
        JOIN tbl_pets ON tbl_donations.pet_id = tbl_pets.pet_id 
        WHERE tbl_donations.user_id = '$user_id' 
        ORDER BY tbl_donations.donation_date DESC";

$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $rows = array();
    while ($row = $result->fetch_assoc()) {
        $rows[] = $row;
    }
    sendJsonResponse(array('status' => 'success', 'data' => $rows));
} else {
    // Return empty array if no donations found
    sendJsonResponse(array('status' => 'success', 'data' => []));
}

function sendJsonResponse($sentArray) {
    echo json_encode($sentArray);
    exit();
}
?>