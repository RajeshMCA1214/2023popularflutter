<?php
header("Access-Control-Allow-Origin: *");
include_once 'includes/variables.php';

	 
	$mysqli = @mysql_connect (DB_HOST, DB_USER, DB_PASSWORD) OR die ('Could not connect to MySQL');
	@mysql_select_db (DB_NAME) OR die ('Could not select the database');

if (isset($_POST['employeeCode']) ) {

    // receiving the post params
 	$employeecode = $_POST['employeeCode'];
	$query3="UPDATE user_master SET login_status='inactive'  WHERE employee_code = '".$employeecode."' AND record_status=1";	
    $resouter3 = mysql_query($query3)or die(mysql_error());
	
	$response["success"] = TRUE;
    $response["messages"] = "Logout Success";
    echo json_encode($response);

    	
   }
       
 else {
    // required post params is missing
    $response["success"] = FALSE;
    $response["messages"] = "Required parameters Mobile or Password is missing!";
    echo json_encode($response);
}

	
     
    // echo $val= str_replace('\\/', '/', json_encode($set)); 	 
	 
  
	 
?>