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
 
if (isset($_POST['itemCode'])  && isset($_POST['pickid'])) {

  $querycnt = "SELECT * FROM pick_list_details  WHERE  partno='".$_POST['itemCode']."'  AND  pick_id='".$_POST['pickid']."' ";
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
				$response["PickItem"][$i] = $results;
				
		$i++;
		}
		 $querycnt1 = "SELECT picked_list_details.* FROM picked_list_details WHERE partno='".$_POST['itemCode']."' AND  pick_id='".$_POST['pickid']."' ORDER BY Slno ASC";
    $resouter1 = mysql_query($querycnt1)or die('Error:'.mysql_error());
    $total_records1 = mysql_num_rows($resouter1);
	$j = 0;
    $results1='';
    if ($total_records1 >= 1) {
				while ($results1 = mysql_fetch_array($resouter1, MYSQL_ASSOC)){
				$response["PickedList"][$j] = $results1;
				$j++;
				}
    	}
		else
		{
			$response["is_success"] = true;
        	$response["messages"] = "No Record Found";
			$response["PickedList"] = array();
		}
    }
	else
	{
        //$results[]={};
        $response["is_success"] = true;
        $response["messages"] = "No Record Found";
		$response["PickItem"] = array();
		
       

    }
	
                      
	 echo json_encode($response);
	
} 
else {
    // required post params is missing
    $response["is_success"] = false;
    $response["messages"] = "Required Parameters Missing!";
    echo json_encode($response);
}

// echo $val= str_replace('\\/', '/', json_encode($set));
