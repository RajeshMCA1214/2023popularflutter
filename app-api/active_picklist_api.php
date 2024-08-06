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
 
	if (isset($_POST['compCode']) && ($_POST['employeeCode']!="")  && isset($_POST['category'])) {
	
	if($_POST['category']=='PRO COURIER'){
  $querycnt = "SELECT total_item_count, pick_id, billno, billdate, custcode, custname, picklisttime,r_timestamp, remarks,pick_status, total_amt FROM pick_list_master WHERE  pick_assigned_status='1' AND (pick_category='".$_POST['category']."'  OR pick_category='DIRECT')AND picker_emp_code='".$_POST['employeeCode']."' AND pick_status='Active'  AND  compcode='".$_POST['compCode']."'";
  }
  else{
   $querycnt = "SELECT total_item_count, pick_id, billno, billdate, custcode, custname, picklisttime,r_timestamp, remarks,pick_status, total_amt FROM pick_list_master WHERE  pick_assigned_status='1' AND pick_category='".$_POST['category']."' AND picker_emp_code='".$_POST['employeeCode']."' AND pick_status='Active'  AND  compcode='".$_POST['compCode']."'";
  }
    $resouter = mysql_query($querycnt)or die('Error:'.mysql_error());
    $set = array();
    $total_records = mysql_num_rows($resouter);
	$i = 0;
    $results='';
    if ($total_records >= 1) {
        //$results[]={};
		$set['tascaSmartPick'][] = $results;
        $response["is_success"] = true;
        $response["messages"] = "Record Found";
		while ($results = mysql_fetch_array($resouter, MYSQL_ASSOC)){
				$response["AssignedPickList"][$i] = $results;
		$i++;
		}
    
    }
	else
	{
        //$results[]={};
        $response["is_success"] = true;
        $response["messages"] = "No Record Found";
		$response["AssignedPickList"] = array();
       

    }

   
		
                      
	 echo json_encode($response);
	
} 
else {
    // required post params is missing
    $response["error"] = true;
    $response["error_msg"] = "Required Parameters Missing!";
    echo json_encode($response);
}

// echo $val= str_replace('\\/', '/', json_encode($set));
