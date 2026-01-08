<?php
    header('Access-Control-Allow-Origin: *');
    header('Content-Type: application/json');
    include 'dbconnect.php';

    // Handle GET request to retrieve all pets
    if ($_SERVER['REQUEST_METHOD'] === 'GET') {
        try {
            // Query to fetch all pets from the database
            $sql = "SELECT * FROM `tbl_pets`";
            $result = $conn->query($sql);
            
            if ($result) {
                $pets = [];
                
                // Fetch all rows from the result
                while ($row = $result->fetch_assoc()) {
                    $row['image_paths'] = json_decode($row['image_paths'], true);
                    $pets[] = $row;
                }
            
                
                // Return success response with pets data
                $response = array(
                    'status' => 'success',
                    'data' => $pets
                );
                
                echo json_encode($response);
            } else {
                // Query failed
                $response = array(
                    'status' => 'failed',
                    'message' => 'Error retrieving pets: ' . $conn->error
                );
                http_response_code(500);
                echo json_encode($response);
            }
        } catch (Exception $e) {
            // Exception handling
            $response = array(
                'status' => 'failed',
                'message' => 'Exception: ' . $e->getMessage()
            );
            http_response_code(500);
            echo json_encode($response);
        }
    } else {
        // Handle invalid request method
        $response = array(
            'status' => 'failed',
            'message' => 'Invalid request'
        );
        http_response_code(405);
        echo json_encode($response);
    }
?>