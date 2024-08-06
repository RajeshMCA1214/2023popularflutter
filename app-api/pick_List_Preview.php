<?php
header("Access-Control-Allow-Origin: *");
include_once 'includes/variables.php';



$mysqli = @mysql_connect(DB_HOST, DB_USER, DB_PASSWORD) or die('Could not connect to MySQL');
@mysql_select_db(DB_NAME) or die('Could not select the database');


 
if (($_POST['employeeCode']!="") && ($_POST['pickid']!="")) {

  	$pickPreviewQuery = "SELECT partno,quantity as pick_qty,picked_qty,rate,picked_total_amt,picked_rate,pick_status,rackno,bin_qrcode,stockqty FROM `pick_list_details` WHERE  pick_id='".$_POST['pickid']."' ";
	$pickPreviewQueryRes = mysql_query($pickPreviewQuery)or die('Error:'.mysql_error());
	//$resultPickPreview=mysql_fetch_assoc($pickPreviewQueryRes);
   
    $set = array();
    $total_records = mysql_num_rows($pickPreviewQueryRes);
	$i = 0;
    $results='';
    if ($total_records >= 1) {
        //$results[]={};
		$set['profileHistory'][] = $results;
        $response["is_success"] = true;
        $response["messages"] = "RecordFound";

		while ($results = mysql_fetch_array($pickPreviewQueryRes, MYSQL_ASSOC)){
				$response["PickPreview"][$i] = $results;
		$i++;
		}
    	
		}
		
	$pickPreviewQuery2 = "SELECT partno,pick_qty,picked_qty,rate,picked_total_amt,picked_rate,pick_status,rackno,bin_qrcode,stockqty FROM `picked_list_details` WHERE  pick_id='".$_POST['pickid']."' AND pick_status='Confirmed'";
	$pickPreviewQueryRes2 = mysql_query($pickPreviewQuery2)or die('Error:'.mysql_error());

    $total_records2 = mysql_num_rows($pickPreviewQueryRes2);
    if ($total_records2 >= 1) {
 		while ($results2 = mysql_fetch_array($pickPreviewQueryRes2, MYSQL_ASSOC)){
				$response["PickPreview"][$i] = $results2;
		$i++;
		}
    }
	else
	{
        //$results[]={};
        $response["is_success"] = true;
        $response["messages"] = "No Record Found";
		$response["TotalCount"] = array();
       

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
