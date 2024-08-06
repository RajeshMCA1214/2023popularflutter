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
 
if (isset($_POST['compCode']) && isset($_POST['employeeCode'])  && isset($_POST['category'])) {

	$checkEmCode="SELECT * FROM pick_list_master WHERE picker_emp_code='".$_POST['employeeCode']."' AND pick_assigned_status ='1' AND pick_status ='Active'";
	$checkEmCodeRes=mysql_query($checkEmCode)or die('Error:'.mysql_error());
	$checkEmCodeRow=mysql_num_rows($checkEmCodeRes);
	//print_r($checkEmCodeRow);exit;
	if($checkEmCodeRow <=0){
if($_POST['category']=='PRO COURIER'){

 $querycnt0 = "SELECT * FROM pick_list_master
                      WHERE pick_assigned_status='0' AND (pick_category='".$_POST['category']."' OR pick_category='DIRECT')
					  AND pick_status='Not Assigned'  AND  compcode='".$_POST['compCode']."' ORDER BY priority ASC LIMIT 0,1";
    $resouter0 = mysql_query($querycnt0)or die('Error:'.mysql_error());
}
else {
 $querycnt0 = "SELECT * FROM pick_list_master
                      WHERE pick_assigned_status='0' AND pick_category='".$_POST['category']."'
					  AND pick_status='Not Assigned'  AND  compcode='".$_POST['compCode']."' ORDER BY priority ASC LIMIT 0,1";
    $resouter0 = mysql_query($querycnt0)or die('Error:'.mysql_error());
	}
    $total_records0 = mysql_num_rows($resouter0);
	    $results='';
	 if ($total_records0 > 0) {
  
				$set['tascaSmartPick'][] = $results;
				$response["is_success"] = true;
				$response["messages"] = "New Pick List Assigned";
				while ($results = mysql_fetch_array($resouter0, MYSQL_ASSOC)){
				
date_default_timezone_set("Asia/Kolkata");
$nowtime=date("H.i");
						 $queryupdate = "UPDATE pick_list_master SET picker_emp_code='".$_POST['employeeCode']."', pick_assigned_status='1', pick_status='Active', 					  pick_assign_date=DATE(NOW()),  pick_assign_time='".$nowtime."'
							  WHERE  pick_id='".$results['pick_id']."' AND pick_category='".$results['pick_category']."'
							   AND  compcode='".$results['compcode']."'";
					$upresult = mysql_query($queryupdate)or die('Error:'.mysql_error());
					$queryupdate1 = "UPDATE pick_list_details SET  pick_status='Active'
							  WHERE pick_id='".$results['pick_id']."' AND pick_category='".$results['pick_category']."'";
					$upresult1 = mysql_query($queryupdate1)or die('Error:'.mysql_error());
				}
			
			}
			else
			{
				//$results[]={};
				$response["is_success"] = true;
				$response["messages"] = "Sorry No Pick List Available !!!";
				$response["AssignedPickList"] = array();
			   
		
			}
	                     
	 echo json_encode($response);
}	
else{

 	$response["is_success"] = false;
    $response["messages"] = "Have Pending Pick List. Please Check Other Category Also!";
    echo json_encode($response);
}
} 
else {
    // required post params is missing
    $response["is_success"] = false;
    $response["messages"] = "Required Parameters Missing!";
    echo json_encode($response);
}

// echo $val= str_replace('\\/', '/', json_encode($set));
