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
 
if (isset($_POST['slno']) && isset($_POST['pickedQty']) && isset($_POST['binQR'])) {
		
		$querycnt1 = "SELECT * FROM pick_list_details  WHERE  pick_id='".$_POST['pickid']."' AND pick_status='Active'";
       $resouter1 = mysql_query($querycnt1)or die('Error:'.mysql_error());
	   $pickcnt = mysql_num_rows($resouter1);

	   $querycnt2 = "SELECT * FROM pick_list_details  WHERE  Slno='".$_POST['slno']."'  ";
       $resouter2 = mysql_query($querycnt2)or die('Error:'.mysql_error());
	   $pickdata2 = mysql_fetch_assoc($resouter2);
	   
	  $querycnt3 = "SELECT pickitem_completed_qty ,total_item_count FROM pick_list_master  WHERE  pick_id='".$pickdata2['pick_id']."'  ";
       $resouter3 = mysql_query($querycnt3)or die('Error:'.mysql_error());
	   $pickdata3 = mysql_fetch_assoc($resouter3);
	   
	    
	  
		if($pickdata2['pick_status']=="Active")
		{
	  		$pickedqty=$pickdata3['pickitem_completed_qty']+1;
		}
		else
		{
			$pickedqty=$pickdata3['pickitem_completed_qty'];
		}
	  
	   			if($_POST['pickedQty'] < $pickdata2['quantity'])
				{
					$remarks ="Partially Completed";
				}
				else
				{
					$remarks ="";
				}
				
				
	 $queryrate = "SELECT SUM(picked_qty)as pickedqty,SUM(picked_rate)as pickedrate,SUM(picked_total_amt)pickedtotalamt FROM picked_list_details  WHERE  pick_id='".$pickdata2['pick_id']."' AND partno='".$pickdata2['partno']."'";
       $resourate = mysql_query($queryrate)or die('Error:'.mysql_error());
	   $pickedrate = mysql_fetch_assoc($resourate);
	   $prate=$pickedrate['pickedrate'];
	   
	   
	   $querycntbinqr = "SELECT GROUP_CONCAT(DISTINCT bin_qrcode SEPARATOR ',') AS bin_qr FROM picked_list_details  WHERE   pick_id='".$pickdata2['pick_id']."'";
		$resouter1 = mysql_query($querycntbinqr)or die('Error:'.mysql_error());
	 	$resouterRes=mysql_fetch_assoc($resouter1);
		$binresult = array_filter(explode(",",$resouterRes["bin_qr"]));
		$res = implode(",", $binresult );
		
		$querypricerate= "SELECT pick_id,GROUP_CONCAT( CONVERT(picked_rate, char(8)) SEPARATOR ',' ) AS picked_rate FROM picked_list_details  WHERE   pick_id='".$pickdata2['pick_id']."' AND partno='".$pickdata2['partno']."'";
		$querypricerateres = mysql_query($querypricerate)or die('Error:'.mysql_error());
	 	$querypricerateget=mysql_fetch_assoc($querypricerateres);
		
		$price = array_filter(explode(",",$querypricerateget["picked_rate"]));
		$pricepicked = implode(",", $price );
		
		
		$pickeditemconfirm="UPDATE picked_list_details SET pick_status='Confirmed' WHERE pick_id='".$pickdata2['pick_id']."' AND partno='".$pickdata2['partno']."'" ;
		$pickeditemconfirmRes = mysql_query($pickeditemconfirm)or die('Error:'.mysql_error());
		if($pickeditemconfirm){
			 $masterBinQRUpdate="UPDATE pick_list_details SET bin_qrcode='".$res."',new_price_status='1',pick_status='Completed',picked_qty='".$pickedrate['pickedqty']."',remarks='".$pricepicked."',picked_total_amt='".$pickedrate['pickedtotalamt']."' WHERE   pick_id='".$pickdata2['pick_id']."' AND partno='".$pickdata2['partno']."'" ;
		$resouterBinQR = mysql_query($masterBinQRUpdate)or die('Error:'.mysql_error());
		
		 $queryupdate2= "UPDATE pick_list_master SET picked_rate='".$prate."', pickitem_completed_qty='".$pickedqty."' WHERE pick_id='".$pickdata2['pick_id']."'";
		$update2 = mysql_query($queryupdate2)or die('Error:'.mysql_error());
		}
		
				
				
				
				$set['tascaSmartPick'][] = $results;
				$response["is_success"] = true;
				if($pickcnt <=1)
					$response["messages"] = "Last Item Completed";
				else
					$response["messages"] = "1 Item Completed";
					
				echo json_encode($response);
	
	}
else {
    // required post params is missing
    $response["is_success"] = false;
    $response["messages"] = "Required Parameters Missing!";
    echo json_encode($response);
}

// echo $val= str_replace('\\/', '/', json_encode($set));
