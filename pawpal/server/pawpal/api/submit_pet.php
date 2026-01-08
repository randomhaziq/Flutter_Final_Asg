<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    http_response_code(405);
    echo json_encode(array('status' => 'failed', 'error' => 'Method Not Allowed'));
    exit();
}

$user_id = isset($_POST['user_id']) ? $_POST['user_id'] : '';
$pet_name = isset($_POST['pet_name']) ? addslashes($_POST['pet_name']) : '';
$pet_type = isset($_POST['pet_type']) ? $_POST['pet_type'] : '';
$category = isset($_POST['category']) ? $_POST['category'] : '';
$description = isset($_POST['description']) ? addslashes($_POST['description']) : '';
$lat = isset($_POST['latitude']) ? $_POST['latitude'] : '';
$lng = isset($_POST['longitude']) ? $_POST['longitude'] : '';

// Validate required fields
if (empty($user_id) || empty($pet_name) || empty($lat) || empty($lng)) {
    echo json_encode(array('status' => 'failed', 'message' => 'Missing required fields'));
    exit();
}

$image_paths = [];

$sqlinsertpet = "INSERT INTO `tbl_pets`(`user_id`, `pet_name`, `pet_type`, `category`, `description`, `lat`, `lng`) VALUES ('$user_id', '$pet_name', '$pet_type', '$category', '$description', '$lat', '$lng')";

try {
    if ($conn->query($sqlinsertpet) === TRUE) {
        $pet_id = $conn->insert_id;

        // Process images if any
        for ($i = 1; $i <= 3; $i++) {
            $image_key = 'image' . $i;
            
            if (isset($_POST[$image_key]) && !empty($_POST[$image_key])) {
                $encodedimage = base64_decode($_POST[$image_key], true);
                
                if ($encodedimage !== false) {
                    // Ensure uploads directory exists
                    $uploads_dir = "../assets/images/uploads";
                    if (!is_dir($uploads_dir)) {
                        mkdir($uploads_dir, 0755, true);
                    }
                    
                    $filename = "pet_" . $pet_id . "_" . $i . ".jpg";
                    $path = $uploads_dir . "/" . $filename;
                    $result = file_put_contents($path, $encodedimage);
                    
                    if ($result !== false) {
                        // Store URL-friendly path (relative to server root)
                        $image_paths[] = "pawpal/assets/images/uploads/" . $filename;
                    }
                }
            }
        }
        
        // Update the record with image paths
        if (!empty($image_paths)) {
            $image_paths_json = json_encode($image_paths);
            $sqlupdate = "UPDATE `tbl_pets` SET `image_paths` = '$image_paths_json' WHERE `pet_id` = '$pet_id'";
            $conn->query($sqlupdate);
        }
        
        $response = array('status' => 'success', 'message' => 'Pet submitted successfully', 'pet_id' => $pet_id);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'message' => 'Pet not added: ' . $conn->error);
        sendJsonResponse($response);
    }
} catch(Exception $e) {
    $response = array('status' => 'failed', 'message' => 'Exception: ' . $e->getMessage());
    sendJsonResponse($response);
}

// Function to send JSON response
function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
    exit();
}
?>