<?php
error_reporting(0); 
ini_set('display_errors', 0);

header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

include 'dbconnect.php';

$response = array('status' => 'failed', 'message' => 'Unknown error');

try {
    if ($_SERVER['REQUEST_METHOD'] != 'POST') {
        throw new Exception('Method not allowed');
    }

    $user_id = $_POST['user_id'] ?? '';
    $name = isset($_POST['name']) ? addslashes($_POST['name']) : '';
    $phone = isset($_POST['phone']) ? addslashes($_POST['phone']) : '';
    $image = $_POST['profile_image'] ?? '';

    if (empty($user_id) || empty($name) || empty($phone)) {
        throw new Exception('Missing required fields');
    }

    // Base SQL
    $sql = "UPDATE tbl_users SET name = '$name', phone = '$phone'";
    $db_path = null;

    if (!empty($image)) {
        if (strpos($image, 'base64,') !== false) {
            $image = explode('base64,', $image)[1];
        }
        
        $decoded_string = base64_decode($image);
        
        if ($decoded_string === false) {
            throw new Exception('Invalid image data');
        }

        $base_dir = realpath(__DIR__ . "/../../../");
        
        if ($base_dir === false) {
            throw new Exception("Cannot determine base directory");
        }

        $path = $base_dir . "/assets/images/profile/";
        
        if (!is_dir($path)) {
            if (!mkdir($path, 0777, true)) {
                throw new Exception("Failed to create directory: $path");
            }
        }

        if (!is_writable($path)) {
            throw new Exception("Directory is not writable: $path");
        }

        $filename = "profile_" . $user_id . "_" . time() . ".jpg";
        $fullpath = $path . $filename;

        // Save the file
        if (file_put_contents($fullpath, $decoded_string) === false) {
            throw new Exception("Failed to write image file to: $fullpath");
        }

        $db_path = "assets/images/profile/" . $filename;
        $sql .= ", profile_image = '$db_path'"; 
    }

    $sql .= " WHERE user_id = '$user_id'";

    error_log("SQL Query: " . $sql);

    if ($conn->query($sql) === TRUE) {
        $response = array(
            'status' => 'success', 
            'message' => 'Profile updated successfully',
            'new_image' => $db_path
        );
    } else {
        throw new Exception("Database Error: " . $conn->error);
    }

} catch (Exception $e) {
    $response = array('status' => 'failed', 'message' => $e->getMessage());
}

echo json_encode($response);
exit();
?>