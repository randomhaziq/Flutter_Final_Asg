<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');
include("dbconnect.php");

if ($_SERVER["REQUEST_METHOD"] != "POST") {
    http_response_code(405);
    echo json_encode(array('status' => 'failed', 'error' => 'Method Not Allowed'));
    exit();
}

$user_id = isset($_POST['user_id']) ? $_POST['user_id'] : '';
$pet_id = isset($_POST['pet_id']) ? $_POST['pet_id'] : '';
$donation_type = isset($_POST['donation_type']) ? $_POST['donation_type'] : '';

if (empty($user_id) || empty($pet_id) || empty($donation_type)) {
    sendJsonResponse(array('status' => 'failed', 'message' => 'Missing required fields'));
}

if ($donation_type == 'Money') {
    //valudate amount
    if (!isset($_POST['amount']) || empty($_POST['amount'])) {
        sendJsonResponse(array('status' => 'failed', 'message' => 'Amount is required'));
    }
    $amount = $_POST['amount'];

    $sql = "INSERT INTO `tbl_donations` (`user_id`, `pet_id`, `donation_type`, `amount`) 
            VALUES ('$user_id', '$pet_id', '$donation_type', '$amount')";
} else {
    if (!isset($_POST["description"]) || empty($_POST["description"])) {
            sendJsonResponse(array("status"=> "failed", "message" => "Description is required"));
    }
    $description = addslashes($_POST["description"]);

    $sql = "INSERT INTO `tbl_donations` (`user_id`, `pet_id`, `donation_type`, `description`) 
            VALUES ('$user_id', '$pet_id', '$donation_type', '$description')";
}

if ($conn->query($sql) === TRUE) {
    sendJsonResponse(array("status"=> "success", "message" => "Donation submitted successfully"));
} else {
    sendJsonResponse(array("status"=> "failed", "message" => "Donation not added: " . $conn->error));
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
    exit();
}
?>