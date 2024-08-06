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
	   
	    
	   /*
	   $querycnt4 = "SELECT COUNT(pick_id) AS TotalItem FROM pick_list_details  WHERE  pick_id='".$pickdata2['pick_id']."' AND pick_status<>'Active' ";
       $resouter4 = mysql_query($querycnt4)or die('Error:'.mysql_error());
	   $pickdata4 = mysql_fetch_assoc($resouter4);
	   */
		if($pickdata2['pick_status']=="Active")
		{
	  		$pickedqty=$pickdata3['pickitem_completed_qty']+1;
		}
		else
		{
			$pickedqty=$pickdata3['pickitem_completed_qty'];
		}
	   /*
	   if($pickedqty>=$pickdata3['total_item_count'])
	   		$pick_status ="Completed";
		else
			$pick_status ="Active";
			*/
	   			if($_POST['pickedQty'] < $pickdata2['quantity'])
				{
					$remarks ="Partially Completed";
				}
				else
				{
					$remarks ="";
				}
				$pickRate=$pickdata2['rate'] * $_POST['pickedQty'];
				$queryupdate= "UPDATE pick_list_details SET  pick_status='Completed', bin_qrcode='".$_POST['binQR']."',picked_rate='".$pickdata2['rate']."',  picked_total_amt='".$pickRate."', picked_qty='".$_POST['pickedQty']."', picked_date=CURDATE(),  picked_time=CURTIME(), remarks='".$remarks."' WHERE Slno='".$_POST['slno']."'";
				$update = mysql_query($queryupdate)or die('Error:'.mysql_error());
				
	  $queryrate = "SELECT SUM(picked_total_amt) AS pickedrate FROM pick_list_details  WHERE  pick_id='".$_POST['pickid']."' AND pick_status='Completed'";
       $resourate = mysql_query($queryrate)or die('Error:'.mysql_error());
	   $pickedrate = mysql_fetch_assoc($resourate);
	   $prate=$pickedrate['pickedrate'];
	   
	   
	   $querycntbinqr = "SELECT GROUP_CONCAT(DISTINCT bin_qrcode SEPARATOR ',') AS bin_qr FROM pick_list_details  WHERE   pick_id='".$pickdata2['pick_id']."'";
		$resouter1 = mysql_query($querycntbinqr)or die('Error:'.mysql_error());
	 	$resouterRes=mysql_fetch_assoc($resouter1);
		$binresult = array_filter(explode(",",$resouterRes["bin_qr"]));
		$res = implode(",", $binresult );
		
		$masterBinQRUpdate="UPDATE pick_list_master SET total_bin_qr='".$res."' WHERE   pick_id='".$_POST['pickid']."'" ;
		$resouterBinQR = mysql_query($masterBinQRUpdate)or die('Error:'.mysql_error());
				
				if($pick_status=="Completed")
				{
				$queryupdate2= "UPDATE pick_list_master SET picked_rate='".$prate."', pickitem_completed_qty='".$pickedqty."', pick_completed_date=DATE(NOW()) , pick_completed_time=TIME(NOW()) WHERE pick_id='".$pickdata2['pick_id']."'";
				}
				else
				{
					$queryupdate2= "UPDATE pick_list_master SET picked_rate='".$prate."', pickitem_completed_qty='".$pickedqty."' WHERE pick_id='".$pickdata2['pick_id']."'";
				}
				$update2 = mysql_query($queryupdate2)or die('Error:'.mysql_error());
				
				$set['tascaSmartPick'][] = $results;
				$response["is_success"] = true;
				if($pickcnt ==1)
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
