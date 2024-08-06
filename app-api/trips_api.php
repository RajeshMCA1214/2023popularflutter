<?php
ini_set('display_errors', 0);
ini_set('display_startup_errors', 0);
error_reporting(0);
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
 
if (isset($_POST['company_id']) && isset($_POST['warehouse_id'])) {

  $querycnt = "SELECT trip_master.trip_id, 
  					   trip_master.trip_no, 
					    trip_master.trip_type, 
						 trip_master.trip_mode, 
						  trip_master.vehicle_no,
						  trip_master.warehouse_id,
						  trip_master.company_id,
						  trip_master.grn_no, 
						  trip_master.warehouse_customer_id,
						  trip_master.invoice_no
			FROM trip_master
			WHERE trip_maste.trip_date=DATE(NOW()) 
  			AND trip_master.company_id='".$_POST['company_id']."'
  			AND trip_master.warehouse_id ='".$_POST['warehouse_id']."'"; 
   
 $resouter = mysql_query($querycnt)or die('Error:'.mysql_error());
    $set = array();
    $total_records = mysql_num_rows($resouter);
	$i = 0;
	$results = "";
    if ($total_records >= 1) {
        //$results[]={};
		$set['tascaWMSi'][] = $results;
        $response["is_success"] = true;
        $response["svgmessages"] = "Record Found";
		while ($results = mysql_fetch_array($resouter, MYSQL_ASSOC)){
				$response["TodayPlan"] = array();
// 			$response["TripCount"]['Total'] = $results2['Total'];
// 			$response["TripCount"]['InwardCount'] = $results2['InwardCount'];
// 			$response["TripCount"]['OutwardCount'] = $results2['OutwardCount'];
		}
		else
		{
		
		$response["is_success"] = true;
        $response["tripmessages"] = "No Record Found";
// 			$response["TripCount"]['Total'] = 0;
// 			$response["TripCount"]['InwardCount'] = 0;
// 			$response["TripCount"]['OutwardCount'] = 0;
              $response["TripCount"]=array();
		}
		
	}
	
		
    
else {
    // required post params is missing
    $response["error"] = true;
    $response["error_msg"] = "Required Parameters Missing!";
    echo json_encode($response);
}

// echo $val= str_replace('\\/', '/', json_encode($set));
