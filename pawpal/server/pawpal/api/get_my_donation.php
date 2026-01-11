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

// SQL JOIN: Connect donations table with pets table to fetch the pet_name
$sql = "SELECT tbl_donations.*, tbl_pets.pet_name, tbl_pets.image_paths
        FROM tbl_donations 
        JOIN tbl_pets ON tbl_donations.pet_id = tbl_pets.pet_id 
        WHERE tbl_donations.user_id = '$user_id' 
        ORDER BY tbl_donations.donation_date DESC";

// $sql = "SELECT
//         d.donation_id,
//         d.donation_type,
//         d.amount,
//         d.description,
//         d.donation_date,
//         p.pet_name,
//         p.image_paths
//         FROM tbl_donations d
//         LEFT JOIN tbl_pets p ON d.pet_id = p.pet_id
//         WHERE d.user_id = '$user_id'
//         ORDER BY d.donation_date DESC";

$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $rows = array();
    while ($row = $result->fetch_assoc()) {
        $rows[] = $row;
    }
    sendJsonResponse(array('status' => 'success', 'data' => $rows));
    print(json_encode($rows));
} else {
    // Return empty array if no donations found (not an error, just empty history)
    sendJsonResponse(array('status' => 'success', 'data' => []));
    $log = "No donations found for user ID: " . $user_id; 
}

function sendJsonResponse($sentArray) {
    echo json_encode($sentArray);
    exit();
}
?>