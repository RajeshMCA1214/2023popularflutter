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
 
if (isset($_POST['itemCode'])  && isset($_POST['pickid'])) {
	$i = 0;
    $results='';
  $querycnt = "SELECT * FROM picked_list_details  WHERE  partno='".$_POST['itemCode']."'  AND  pick_id='".$_POST['pickid']."' ";
    $resouter = mysql_query($querycnt)or die('Error:'.mysql_error());
    $total_records = mysql_num_rows($resouter);
	 if ($total_records > 0) {
  				$set['tascaSmartPick'][] = $results;
				//$results[]={};
				$response["is_success"] = true;
				$response["messages"] = " Picked List Data Available";
				while ($results = mysql_fetch_array($resouter, MYSQL_ASSOC)){
						$response["PickListMaster"][$i] = $results;
						$i++;
					
				}
			
			
	}
	else
	{
		$response["is_success"] = false;
        $response["messages"] = "Picked List Data NOT Available!";
	}
                 
	 echo json_encode($response);
	
} 
else {
    // required post params is missing
    $response["is_success"] = false;
    $response["messages"] = "Pass Correct Parameters!";
    echo json_encode($response);
}

// echo $val= str_replace('\\/', '/', json_encode($set));
?>