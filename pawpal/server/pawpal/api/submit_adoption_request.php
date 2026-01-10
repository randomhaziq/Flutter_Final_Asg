<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    sendJsonResponse(array('status' => 'failed', 'message' => 'Method Not Allowed'));
}

$user_id = isset($_POST['user_id']) ? $_POST['user_id'] : '';
$pet_id = isset($_POST['pet_id']) ? $_POST['pet_id'] : '';
$message = isset($_POST['message']) ? addslashes($_POST['message']) : '';  

if (empty($user_id) || empty($pet_id) || empty($message)) {
    sendJsonResponse(array('status' => 'failed', 'message' => 'Missing required fields'));
}

//check for duplicate request
$check_sql = "SELECT * FROM tbl_adoptions WHERE user_id = '$user_id' AND pet_id = '$pet_id'";
$result = $conn->query($check_sql);
if ($result->num_rows > 0) {
    sendJsonResponse(array('status' => 'failed', 'message' => 'You have already requested to adopt this pet'));
}

$sql = "INSERT INTO `tbl_adoptions` (`user_id`, `pet_id`, `message`) 
        VALUES ('$user_id', '$pet_id', '$message')";

//execute query
if ($conn->query($sql) === TRUE) {
    sendJsonResponse(array('status' => 'success', 'message' => 'Adoption request submitted successfully'));
} else {
    sendJsonResponse(array('status' => 'failed', 'message' => 'Adoption request not added: ' . $conn->error));
}

function sendJsonResponse($sentArray) {
    echo json_encode($sentArray);
    exit();
}
?>