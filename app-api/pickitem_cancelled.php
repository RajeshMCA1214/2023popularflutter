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
 
if (isset($_POST['slno'])) {

	   $querycnt1 = "SELECT * FROM pick_list_details  WHERE  pick_id='".$_POST['pickid']."' AND pick_status='Active'";
       $resouter1 = mysql_query($querycnt1)or die('Error:'.mysql_error());
	   $pickcnt = mysql_num_rows($resouter1);
	   
	   $querycnt2 = "SELECT * FROM pick_list_details  WHERE  Slno='".$_POST['slno']."'  ";
       $resouter2 = mysql_query($querycnt2)or die('Error:'.mysql_error());
	   $pickdata2 = mysql_fetch_assoc($resouter2);
 	
				 $queryupdate= "UPDATE pick_list_details SET  pick_status='Cancelled',picked_qty='0',picked_rate='0' WHERE Slno='".$_POST['slno']."'";
				$update = mysql_query($queryupdate)or die('Error:'.mysql_error());
				
				$pickListDetails="SELECT * FROM pick_list_details WHERE pick_id='".$_POST['pickid']."' AND pick_status='Active'";
				$pickListDetailsRes=mysql_query($pickListDetails)or die('Error:'.mysql_error());
				$pickListDetailsRow=mysql_num_rows($pickListDetailsRes);
				
				//print_r($pickListDetailsRow);exit;
				
				 $querycnt3 = "SELECT pickitem_completed_qty ,total_item_count,picked_rate FROM pick_list_master  WHERE  pick_id='".$_POST['pickid']."'  ";
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
	    if($pickdata2['pick_status']=="Active" || $pickdata2['pick_status']=="Cancelled")
		{
	  		//nochange in master rate and qty
		}
		else
		{
			$newpickedRate=$pickdata3['picked_rate']-$pickdata2['picked_rate'];
			
		}
	   				
					
				if($pickListDetailsRow==0){
					
					$pickList="SELECT * FROM pick_list_details WHERE pick_id='".$_POST['pickid']."' ";
					$pickListRes=mysql_query($pickList)or die('Error:'.mysql_error());
					$pickListRow=mysql_num_rows($pickListRes);
				
					$pickListCancel="SELECT * FROM pick_list_details WHERE pick_status='Cancelled' AND record_status='1' ";
					$pickListCancelRes=mysql_query($pickListCancel)or die('Error:'.mysql_error());
					$pickListCancelRow=mysql_num_rows($pickListCancelRes);
					
						if($pickListRow==$pickListCancelRow){
						
						$pickListMaster= "UPDATE pick_list_master SET  pick_completed_date=DATE(NOW()),  pick_assign_time=TIME(NOW()), pickitem_completed_qty='".$pickedqty."', picked_rate='".$newpickedRate."',  pick_status='Cancelled' WHERE pick_id='".$_POST['pickid']."'";
						$pickListMasterRes = mysql_query($pickListMaster)or die('Error:'.mysql_error());
						
						}else {
						
						
						$pickListMaster= "UPDATE pick_list_master SET  pick_completed_date=DATE(NOW()),  pick_assign_time=TIME(NOW()), picked_rate='".$newpickedRate."', pickitem_completed_qty='".$pickedqty."', pick_status='Completed' WHERE pick_id='".$_POST['pickid']."'";
						$pickListMasterRes = mysql_query($pickListMaster)or die('Error:'.mysql_error());
						
						
						}
					}
					else
					
					{
					$pickListMaster= "UPDATE pick_list_master SET  pickitem_completed_qty='".$pickedqty."', picked_rate='".$newpickedRate."' WHERE pick_id='".$_POST['pickid']."'";
					$pickListMasterRes = mysql_query($pickListMaster)or die('Error:'.mysql_error());
					
					}
					
				
		
				
				$set['tascaSmartPick'][] = $results;
				$response["is_success"] = true;
				if($pickcnt ==1)
					$response["messages"] = "Last Item Cancelled";
				else
					$response["messages"] = "1 Item Cancelled";
				
				echo json_encode($response);
	
}
 
else {
    // required post params is missing
    $response["is_success"] = false;
    $response["messages"] = "Required Parameters Missing!";
    echo json_encode($response);
}

// echo $val= str_replace('\\/', '/', json_encode($set));
