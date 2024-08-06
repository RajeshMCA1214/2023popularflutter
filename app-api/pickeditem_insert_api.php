<?php
ini_set('display_errors', 0);
ini_set('display_startup_errors', 0);
error_reporting(0);
header("Access-Control-Allow-Origin: *");
include_once 'includes/variables.php';






 
if (isset($_POST['itemCode'])  && isset($_POST['pickid']) && isset($_POST['pickedrate']) && isset($_POST['picked_qty'])) {

	 $querycnt = "SELECT * FROM pick_list_details  WHERE  partno='".$_POST['itemCode']."'  AND  pick_id='".$_POST['pickid']."' LIMIT 0,1 ";
    $resouter = mysql_query($querycnt)or die('Error:'.mysql_error());
	$total_records = mysql_num_rows($resouter);
	if ($total_records > 0) {
   			$pickedqty = mysql_fetch_assoc($resouter);
	 $pickedQty=$pickedqty['picked_qty']+$_POST['picked_qty'];
	 $pickedRate=$pickedqty['picked_rate']+$_POST['pickedrate'];
	 $picQty=$pickedqty['quantity'];
		
	

	
  
				//$results[]={};
				$set['tascaSmartPick'][] = $results;
				$response["is_success"] = true;
				$response["messages"] = "New Pick Confirmed";
				//mysql_free_result($resouter);
			$pickedtotal = $_POST['pickedrate'] * $_POST['picked_qty'];
						$queryinsert = "INSERT INTO picked_list_details (pick_id,
						 partno,
						 partname,
						 rate,
						 rackno,
						 stockqty,
						 pick_qty,
						 picked_rate,
						 picked_total_amt,
						 rack_qrcode,
						 part_qrcode,
						 bin_qrcode,
						 picked_qty,
						 picked_date,
						 picked_time) 
						VALUES ('".$pickedqty['pick_id']."',
						 '".$pickedqty['partno']."',
						 '".$pickedqty['partname']."',
						 '".$pickedqty['rate']."',
						 '".$pickedqty['rackno']."',
						 '".$pickedqty['stockqty']."',
						 '".$pickedqty['quantity']."',
						 '".$_POST['pickedrate']."' ,
						 '".$pickedtotal."' ,
						 '".$_POST['rack_qrcode']."',
						 '".$_POST['PartQRcode']."',
						 '".$_POST['binQR']."' ,
						 '".$_POST['picked_qty']."',
						 DATE(NOW()),
						 TIME(NOW()))";
						
						$insresult = mysql_query($queryinsert)or die('Error:'.mysql_error());
						
						
	

			
	}
	else
	{
		$response["is_success"] = false;
        $response["messages"] = "No Pick Item Avaialable";
		
		
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
