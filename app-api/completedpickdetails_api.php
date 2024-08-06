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

  $querycnt = "SELECT * FROM pick_list_master  WHERE pick_assigned_status='1' AND pick_category='".$_POST['category']."' AND picker_emp_code='".$_POST['employeeCode']."' AND  compcode='".$_POST['compCode']."' AND  pick_id='".$_POST['pickid']."'";
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
		 $querycnt1 = "SELECT pick_list_details.*, (quantity-picked_qty) as pending_qty FROM pick_list_details WHERE pick_category='".$_POST['category']."' AND  pick_id='".$_POST['pickid']."' ORDER BY rackno ASC";
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
