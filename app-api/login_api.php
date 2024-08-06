<?php
header("Access-Control-Allow-Origin: *");
include_once 'includes/variables.php';

	 
	$mysqli = @mysql_connect (DB_HOST, DB_USER, DB_PASSWORD) OR die ('Could not connect to MySQL');
	@mysql_select_db (DB_NAME) OR die ('Could not select the database');

 	//$response = array("error" => FALSE);
 	//mysql_query("SET NAMES 'utf8'"); 
	
	 /**
     * Get user by Mobile and password
     */
  
	//$_POST=json_decode(file_get_contents('php://input'), true);
if (isset($_POST['employeeCode']) && isset($_POST['password'])) {

    // receiving the post params
 	$employeecode = $_POST['employeeCode'];
   	$pwd = $_POST['password'];
//	$usergroup = $_POST['usergroup'];
	//$fcm_token = $_POST['fcm_token'];
    // get the user by email and password
	
    $query="SELECT * FROM user_master WHERE employee_code = '".$employeecode."' AND password = '".$pwd."' AND record_status=1";		
	$resouter = mysql_query($query);

    	$set = array();
		$total_records = mysql_num_rows($resouter);
    if($total_records >= 1){
	
		
	//	 $query1="UPDATE tasca_mobile_number SET firetoken='".$fcm_token."' WHERE mobile = '".$mob."'";	
		
	//	 $resouter1 = mysql_query($query1);
		 $query4="SELECT * FROM user_master WHERE employee_code = '".$employeecode."' AND password = '".$pwd."' AND record_status=1  AND user_group = 'Picker'";		
	  $resouter4 = mysql_query($query4);

	$total_records4 = mysql_num_rows($resouter4);
	if($total_records4 >= 1){
	
	
	 $query2="SELECT * FROM user_master WHERE employee_code = '".$employeecode."' AND password = '".$pwd."' AND record_status=1 AND login_status='inactive' AND user_group = 'Picker'";		
	  $resouter2 = mysql_query($query2);

	$total_records2 = mysql_num_rows($resouter2);
	
    if($total_records2 >= 1){
			 $query3="UPDATE user_master SET login_status='active'  WHERE employee_code = '".$employeecode."' AND password = '".$pwd."' AND record_status=1 AND user_group = 'Picker'";	
	 		 $resouter3 = mysql_query($query3);
		
			  while ($results = mysql_fetch_array($resouter, MYSQL_ASSOC)){
				
				$set['tascaSmartPick'][] = $results;
				$response["status"] = "ok";
				$response["is_success"] = true;
				$response["messages"] = "Sign In Successfully";
				$response["user"]["userID"] = $results["user_id"];
				$response["user"]["userName"] = $results["username"];
				$response["user"]["employeeCode"] = $results["employee_code"];
				$response["user"]["emailId"] = $results["email_id"];
				$response["user"]["userGroup"] = $results["user_group"];
				$response["user"]["companyId"] = $results["company_id"];
				$response["user"]["warehouseId"] = $results["warehouse_id"];
				$response["user"]["designation"] = $results["designation"];
				echo json_encode($response);
			  }
	  	}
		
		else
		{
			$response["status"] = "ok";
			$response["is_success"] = false;
			$response["messages"] = "User Already Logged In. Kindly Choose Other Login Id";
			$response["user"] = array();
			echo json_encode($response, JSON_FORCE_OBJECT);
		}
	  }
	  else
	  {
		//$results[]={};
		$response["status"] = "ok";
		$response["is_success"] = false;
		$response["messages"] = "User Group is not Matched. Kindly Choose Different User Group";
		$response["user"] = array();
		echo json_encode($response, JSON_FORCE_OBJECT);
		}
		}
	  else
	  {
		//$results[]={};
		$response["status"] = "ok";
		$response["is_success"] = false;
		$response["messages"] = "Unauthorized, Invalid Username or Password";
		$response["user"] = array();
		echo json_encode($response, JSON_FORCE_OBJECT);
		 
	  
	 } }
       
 else {
    // required post params is missing
    $response["error"] = TRUE;
    $response["messages"] = "Required parameters Mobile or Password is missing!";
    echo json_encode($response);
}

	
     
    // echo $val= str_replace('\\/', '/', json_encode($set)); 	 
	 
  
	 
?>