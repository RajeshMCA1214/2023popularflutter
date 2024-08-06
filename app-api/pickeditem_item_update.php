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

 	$querycnt = "SELECT SUM(picked_qty) AS pickedqty FROM picked_list_details  WHERE  pick_id='".$_POST['pickid']."'  AND  partno='".$_POST['itemCode']."' AND  record_status='1'";
    $resouter = mysql_query($querycnt)or die('Error:'.mysql_error());
	
	 $grndata = mysql_fetch_assoc($resouter);
	    $picked=$grndata['pickedqty'];
	
	$querycnt1 = "SELECT SUM(rate) AS total_Rate FROM picked_list_details  WHERE  pick_id='".$_POST['pickid']."'  AND  partno='".$_POST['itemCode']."' AND  record_status='1'";
    $resouter1 = mysql_query($querycnt1)or die('Error:'.mysql_error());
	
	 $grndata1 = mysql_fetch_assoc($resouter1);
	    $pickedrate=$grndata1['total_Rate'];
	
	
	$querycnt2 = "SELECT * FROM pick_list_details  WHERE  pick_id='".$_POST['pickid']."'  AND  partno='".$_POST['itemCode']."' AND  record_status='1'";
     $resouter2 = mysql_query($querycnt2)or die('Error:'.mysql_error());
	  $grndata2 = mysql_fetch_assoc($resouter2);
	 
	 
	 $pic=$grndata2['quantity'];
	//print_r  ($grndata2['quantity']);exit;
	  
	 
	 if($pic >=$picked){
	 
    $total_records = mysql_num_rows($resouter);
	 if ($total_records > 0) {
  
				//$results[]={};
				$set['tascaSmartPick'][] = $results;
				$response["is_success"] = true;
				$response["messages"] = "New Picked Confirmed";
				 $queryinsert = "UPDATE pick_list_details SET  picked_qty='".$picked."',  picked_rate='".$pickedrate."' WHERE  pick_id='".$_POST['pickid']."'  AND  partno='".$_POST['itemCode']."' AND  record_status='1'";
				$update = mysql_query($queryinsert)or die('Error:'.mysql_error());
				
				
			
			
	}
	else
	{
		$response["is_success"] = true;
        $response["messages"] = "No Picked Item Avaialable";
	}
                 
	 echo json_encode($response);
	
}
 

else
{
	$response["is_success"] = false;
   $response["messages"] = "Picked Quantity Grater Then Pick Quantity!";
    echo json_encode($response);

}}

else {
    // required post params is missing
    $response["is_success"] = false;
    $response["messages"] = "Required Parameters Missing!";
    echo json_encode($response);
}

// echo $val= str_replace('\\/', '/', json_encode($set));
