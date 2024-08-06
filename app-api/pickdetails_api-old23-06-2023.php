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
 
if (isset($_POST['compCode']) && isset($_POST['employeeCode'])  && isset($_POST['category'])   && isset($_POST['pickid'])) {


		if($_POST['category']=='ROUTE'){
 $querycnt = "SELECT * FROM pick_list_master  WHERE  pick_assigned_status='1' AND (pick_category='".$_POST['category']."' OR pick_category='DIRECT')  AND picker_emp_code='".$_POST['employeeCode']."' AND  compcode='".$_POST['compCode']."' AND  pick_id='".$_POST['pickid']."'";
  }
else{
   $querycnt = "SELECT * FROM pick_list_master  WHERE  pick_assigned_status='1' AND pick_category='".$_POST['category']."' AND picker_emp_code='".$_POST['employeeCode']."' AND  compcode='".$_POST['compCode']."' AND  pick_id='".$_POST['pickid']."'";
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
				$response["PickListMaster"][$i] = $results;
				
		$i++;
		}
		if($_POST['category']=='ROUTE'){
		 $querycnt1 = "SELECT pick_list_details.*, (quantity-picked_qty) as pending_qty FROM pick_list_details WHERE (pick_category='".$_POST['category']."' OR pick_category='DIRECT')AND  pick_id='".$_POST['pickid']."' AND pick_status='Active' ORDER BY rackno,pick_status ASC LIMIT 0,3";
		 }
		 else{
		  $querycnt1 = "SELECT pick_list_details.*, (quantity-picked_qty) as pending_qty FROM pick_list_details WHERE pick_category='".$_POST['category']."' AND  pick_id='".$_POST['pickid']."' AND pick_status='Active' ORDER BY rackno,pick_status ASC LIMIT 0,3";
		 
		 }
    $resouter1 = mysql_query($querycnt1)or die('Error:'.mysql_error());
    $total_records1 = mysql_num_rows($resouter1);
	$j = 0;
    $results1='';
    if ($total_records1 >= 1) {
				while ($results1 = mysql_fetch_array($resouter1, MYSQL_ASSOC)){
				$response["PickListDetails"][$j] = $results1;
				$j++;
				}
				}
			else{
				if($_POST['category']=='ROUTE'){
		 $querycnt3 = "SELECT pick_list_details.*, (quantity-picked_qty) as pending_qty FROM pick_list_details WHERE (pick_category='".$_POST['category']."' OR pick_category='DIRECT')AND  pick_id='".$_POST['pickid']."' ORDER BY rackno,pick_status ASC ";
		 }
		 else{
		  $querycnt3 = "SELECT pick_list_details.*, (quantity-picked_qty) as pending_qty FROM pick_list_details WHERE pick_category='".$_POST['category']."' AND  pick_id='".$_POST['pickid']."'  ORDER BY rackno,pick_status ASC";
		 
		 } $resouter3 = mysql_query($querycnt3)or die('Error:'.mysql_error());
    $total_records3 = mysql_num_rows($resouter3);
	$k = 0;
    $results3='';
    if ($total_records3 >= 1) {
				while ($results3 = mysql_fetch_array($resouter3, MYSQL_ASSOC)){
				$response["PickListDetails"][$k] = $results3;
				$k++;
				}
				}
			else{
				$response["is_success"] = true;
        		$response["messages"] = "No Details Record Found";
				$response["PickLisDetails"] = array();
				}
		}
    }
	
	else
	{
        //$results[]={};
        $response["is_success"] = true;
        $response["messages"] = "No Record Found";
		$response["PickListMaster"] = array();
       

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
