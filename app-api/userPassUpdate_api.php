<?php
header("Access-Control-Allow-Origin: *");
include_once 'includes/variables.php';



$mysqli = @mysql_connect(DB_HOST, DB_USER, DB_PASSWORD) or die('Could not connect to MySQL');
@mysql_select_db(DB_NAME) or die('Could not select the database');

//$response = array("error" => FALSE);
//mysql_query("SET NAMES 'utf8'");

/**
 * Get user by Mobile and password
 */

//$_POST=json_decode(file_get_contents('php://input'), true);
    // receiving the post params
 
if (isset($_POST['password']) && ($_POST['employeeCode']!="")) {

  $querycnt = "UPDATE  user_master
                      SET password='".$_POST['password']."'
					 WHERE employee_code='".$_POST['employeeCode']."'  AND  record_status='1'";
    $resouter = mysql_query($querycnt)or die('Error:'.mysql_error());
	$response["is_success"] = true;
	 $response["messages"] = "Update Success";
    echo json_encode($response);
	
} 
else {
    // required post params is missing
    $response["error"] = false;
    $response["error_msg"] = "Required Parameters Missing!";
    echo json_encode($response);
}

// echo $val= str_replace('\\/', '/', json_encode($set));
