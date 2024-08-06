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
 
if (isset($_POST['compCode']) && ($_POST['employeeCode']!="")) {

	$i = 0;
    $results='';

	$totalPic1 = "SELECT COUNT(*) As PickedQty FROM pick_list_master WHERE pick_status='Not Assigned' AND record_status='1' AND pick_assigned_status='0' AND  (pick_category='PRO COURIER' OR  pick_category='DIRECT') ";
    $totalPicRes1 = mysql_query($totalPic1)or die('Error:'.mysql_error());
	$totalpicget1=mysql_fetch_assoc($totalPicRes1);
	
	$totalPic2 = "SELECT COUNT(*) As PickedQty FROM pick_list_master WHERE  pick_status='Not Assigned' AND record_status='1' AND pick_assigned_status='0' AND pick_category='ROUTE'";
    $totalPicRes2 = mysql_query($totalPic2)or die('Error:'.mysql_error());
	$totalpicget2=mysql_fetch_assoc($totalPicRes2);
	
	
	$totalPic3 = "SELECT COUNT(*) As PickedQty FROM pick_list_master WHERE  pick_status='Not Assigned' AND record_status='1' AND pick_assigned_status='0' AND pick_category='BOOKING' ";
    $totalPicRes3 = mysql_query($totalPic3)or die('Error:'.mysql_error());
	$totalpicget3=mysql_fetch_assoc($totalPicRes3);
	
	$totalPic4 = "SELECT COUNT(*) As PickedQty FROM pick_list_master WHERE  pick_status='Not Assigned' AND record_status='1' AND pick_assigned_status='0' AND  pick_category='TOWN BOOKING' ";
    $totalPicRes4 = mysql_query($totalPic4)or die('Error:'.mysql_error());
	$totalpicget4=mysql_fetch_assoc($totalPicRes4);
	
	
	$selectactive = "SELECT pick_id,pick_category,pick_status FROM pick_list_master WHERE picker_emp_code='".$_POST['employeeCode']."' AND pick_assigned_status='1' AND record_status='1' AND pick_status='Active' ";
    $selectactiveRes = mysql_query($selectactive)or die('Error:'.mysql_error());
	$selectactiveget=mysql_fetch_assoc($selectactiveRes);
	$selectactivecnt=mysql_num_rows($selectactiveRes);
	
	
	$set = array();
  		 //$results[]={};
        $response["is_success"] = true;
        $response["messages"] = "Record Found";
		$response["Courier"] = $totalpicget1["PickedQty"];
		$response["Local"] = $totalpicget2["PickedQty"];
		$response["Outstation"]= $totalpicget3["PickedQty"];
		$response["Town"] = $totalpicget4["PickedQty"];
		if($selectactivecnt>=1){
		$response["Active"][] = $selectactiveget;
		}
		else{
		//$response["Active"]=array();
		$response["Active"][0]["pick_id"] = "";
		$response["Active"][0]["pick_category"]= "";
    	$response["Active"][0]["pick_status"]= "";
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
