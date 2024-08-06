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


		if($_POST['category']=='PRO COURIER'){
 $querycnt = "SELECT * FROM pick_list_master  WHERE  pick_assigned_status='1' AND (pick_category='".$_POST['category']."' OR pick_category='DIRECT')  AND picker_emp_code='".$_POST['employeeCode']."' AND  compcode='".$_POST['compCode']."' AND  pick_id='".$_POST['pickid']."'";
 
 
  }
else{
    $querycnt = "SELECT * FROM pick_list_master  WHERE  pick_assigned_status='1' AND pick_category='".$_POST['category']."' AND picker_emp_code='".$_POST['employeeCode']."' AND  compcode='".$_POST['compCode']."' AND  pick_id='".$_POST['pickid']."'";
	
   }
    $resouter = mysql_query($querycnt)or die('Error:'.mysql_error());
    $set = array();
    $total_records = mysql_num_rows($resouter);
	
	
	$i = 0;
    $results='';
    if ($total_records >= 1) {
        //$results[]={};
		$set['tascaSmartPick'][] = $results;
        $response1["is_success"] = true;
        $response1["messages"] = "Record Found";
		
		while ($results = mysql_fetch_array($resouter, MYSQL_ASSOC)){
				$response1["PickListMaster"][$i] = $results;
				
		$i++;
		}
		
		 $querycnt1 = "SELECT pick_list_details.* FROM pick_list_details  WHERE pick_id='".$_POST['pickid']."' AND (pick_status='Not Picked' OR pick_status='Active')";
		 $resouter1 = mysql_query($querycnt1)or die('Error:'.mysql_error());
    	 $total_records1 = mysql_num_rows($resouter1);
			 if ($total_records1 >= 1) {
			 
   		$queryab = "SELECT pick_list_details.*, SUBSTRING(rackno, 1, 1) AS row, SUBSTRING(rackno, 2, 1) AS rack, SUBSTRING(rackno, 2, 2) AS rack2, (quantity-picked_qty) as pending_qty FROM pick_list_details WHERE  pick_id='".$_POST['pickid']."' AND (pick_status='Not Picked' OR pick_status='Active')  AND (SUBSTRING(rackno, 1, 1) LIKE '%A%' OR SUBSTRING(rackno, 1, 1) LIKE '%B%') ORDER BY SUBSTRING(rackno,2,10)*1, row, CAST(rack2 AS UNSIGNED) ASC";
		
		 $resultab = mysql_query($queryab)or die('Error:'.mysql_error());
    	 $totalrec_ab = mysql_num_rows($resultab);
		 $ab = 0;
   		 $resultsab='';
    		if($totalrec_ab >= 1) {
				while ($resultsab = mysql_fetch_array($resultab, MYSQL_ASSOC)){
				$response["PickListDetails"][$ab] = $resultsab;
				$ab++;
				}
				}
			
				
				$querycd = "SELECT pick_list_details.*, SUBSTRING(rackno, 1, 1) AS row, SUBSTRING(rackno, 2, 1) AS rack, SUBSTRING(rackno, 2, 2) AS rack2, (quantity-picked_qty) as pending_qty FROM pick_list_details WHERE  pick_id='".$_POST['pickid']."' AND (pick_status='Not Picked' OR pick_status='Active') AND (SUBSTRING(rackno, 1, 1) LIKE '%C%' OR SUBSTRING(rackno, 1, 1) LIKE '%D%') ORDER BY SUBSTRING(rackno,2,10)*1, row, CAST(rack2 AS UNSIGNED) ASC";
		
		 $resultcd = mysql_query($querycd)or die('Error:'.mysql_error());
    	 $totalrec_cd = mysql_num_rows($resultcd);
   		 $resultscd='';
    		if($totalrec_cd >= 1) {
				while ($resultscd = mysql_fetch_array($resultcd, MYSQL_ASSOC)){
				$response["PickListDetails"][$ab] = $resultscd;
				$ab++;
				}
				}
			
				
				$queryef = "SELECT pick_list_details.*, SUBSTRING(rackno, 1, 1) AS row, SUBSTRING(rackno, 2, 1) AS rack, SUBSTRING(rackno, 2, 2) AS rack2, (quantity-picked_qty) as pending_qty FROM pick_list_details WHERE pick_id='".$_POST['pickid']."' AND (pick_status='Not Picked' OR pick_status='Active') AND (SUBSTRING(rackno, 1, 1) LIKE '%E%' OR SUBSTRING(rackno, 1, 1) LIKE '%F%') ORDER BY SUBSTRING(rackno,2,10)*1, row, CAST(rack2 AS UNSIGNED) ASC";
		
		 $resultef = mysql_query($queryef)or die('Error:'.mysql_error());
    	 $totalrec_ef = mysql_num_rows($resultef);
   		 $resultscd='';
    		if($totalrec_ef >= 1) {
				while ($resultsef = mysql_fetch_array($resultef, MYSQL_ASSOC)){
				$response["PickListDetails"][$ab] = $resultsef;
				$ab++;
				}
				}
			
				
				$querygh = "SELECT pick_list_details.*, SUBSTRING(rackno, 1, 1) AS row, SUBSTRING(rackno, 2, 1) AS rack, SUBSTRING(rackno, 2, 2) AS rack2, (quantity-picked_qty) as pending_qty FROM pick_list_details WHERE  pick_id='".$_POST['pickid']."' AND (pick_status='Not Picked' OR pick_status='Active')  AND (SUBSTRING(rackno, 1, 1) LIKE '%G%' OR SUBSTRING(rackno, 1, 1) LIKE '%H%') ORDER BY SUBSTRING(rackno,2,10)*1, row, CAST(rack2 AS UNSIGNED) ASC";
		
		 $resultgh = mysql_query($querygh)or die('Error:'.mysql_error());
    	 $totalrec_gh = mysql_num_rows($resultgh);
   		 $resultsgh='';
    		if($totalrec_gh >= 1) {
				while ($resultsgh = mysql_fetch_array($resultgh, MYSQL_ASSOC)){
				$response["PickListDetails"][$ab] = $resultsgh;
				$ab++;
				}
				}
			
				$queryij = "SELECT pick_list_details.*, SUBSTRING(rackno, 1, 1) AS row, SUBSTRING(rackno, 2, 1) AS rack, SUBSTRING(rackno, 2, 2) AS rack2, (quantity-picked_qty) as pending_qty FROM pick_list_details WHERE  pick_id='".$_POST['pickid']."' AND (pick_status='Not Picked' OR pick_status='Active') AND (SUBSTRING(rackno, 1, 1) LIKE '%I%' OR SUBSTRING(rackno, 1, 1) LIKE '%J%') ORDER BY SUBSTRING(rackno,2,10)*1, row, CAST(rack2 AS UNSIGNED) ASC";
		
		 $resultij = mysql_query($queryij)or die('Error:'.mysql_error());
    	 $totalrec_ij = mysql_num_rows($resultij);
   		 $resultsij='';
    		if($totalrec_ij >= 1) {
				while ($resultsij = mysql_fetch_array($resultij, MYSQL_ASSOC)){
				$response["PickListDetails"][$ab] = $resultsij;
				$ab++;
				}
				}
			
				
				$queryij = "SELECT pick_list_details.*, (quantity-picked_qty) as pending_qty FROM pick_list_details WHERE  pick_id='".$_POST['pickid']."' AND (pick_status='Not Picked' OR pick_status='Active') AND rackno=''";
		
		 $resultempty = mysql_query($queryij)or die('Error:'.mysql_error());
    	 $totalrec_empty = mysql_num_rows($resultempty);
   		 $resultsij='';
    		if($totalrec_empty >= 1) {
				while ($resultsempty = mysql_fetch_array($resultempty, MYSQL_ASSOC)){
				$response["PickListDetails"][$ab] = $resultsempty;
				$ab++;
				}
				}
			
		 }
	
		else{
			
		/* $querycnt3 = "SELECT pick_list_details.*, (quantity-picked_qty) as pending_qty FROM pick_list_details WHERE pick_id='".$_POST['pickid']."' ORDER BY rackno REGEXP '^[A-Z]{2}' ASC,
           IF(rackno REGEXP '^[A-Z]{2}', LEFT(rackno, 2), LEFT(rackno, 1)),
           CAST(IF(rackno REGEXP '^[A-Z]{2}', RIGHT(rackno, LENGTH(rackno) - 2), RIGHT(rackno, LENGTH(rackno) - 1)) AS SIGNED),pick_status ASC ";*/
		   $querycnt3 = " SELECT pick_list_details.*, SUBSTRING(rackno, 1, 1) AS row, SUBSTRING(rackno, 2, 1) AS rack, SUBSTRING(rackno, 2, 2) AS rack2, (quantity-picked_qty) as pending_qty FROM pick_list_details WHERE  pick_id='".$_POST['pickid']."' ORDER BY SUBSTRING(rackno,2,10)*1, row, CAST(rack2 AS UNSIGNED) ASC";
		 
		 $resouter3 = mysql_query($querycnt3)or die('Error:'.mysql_error());
    $total_records3 = mysql_num_rows($resouter3);
	$k = 0;
    $results3='';
    if ($total_records3 >= 1) {
				while ($results3 = mysql_fetch_array($resouter3, MYSQL_ASSOC)){
				$response["PickListDetails"][$k] = $results3;
				$k++;
				}
				}
			else{
				$response["is_success"] = true;
        		$response["messages"] = "No Details Record Found";
				$response["PickLisDetails"] = array();
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
	 $querycnt1 = "SELECT pick_list_details.* FROM pick_list_details  WHERE pick_id='".$_POST['pickid']."' AND (pick_status='Not Picked' OR pick_status='Active')";
		 $resouter1 = mysql_query($querycnt1)or die('Error:'.mysql_error());
    	 $total_records1 = mysql_num_rows($resouter1);
			 if ($total_records1 >= 1) {
		if(count($response["PickListDetails"])>=5){
		$response1["PickListDetails"] = array_slice($response["PickListDetails"], 0,5);            
	    echo json_encode($response1);
		}
		else if(count($response["PickListDetails"])==4)
		{
		$response1["PickListDetails"] = array_slice($response["PickListDetails"], 0,4);            
	    echo json_encode($response1);
		}
		else if(count($response["PickListDetails"])==3)
		{
		$response1["PickListDetails"] = array_slice($response["PickListDetails"], 0,3);            
	    echo json_encode($response1);
		}
		else if(count($response["PickListDetails"])==2)
		{
		$response1["PickListDetails"] = array_slice($response["PickListDetails"], 0,2);            
	    echo json_encode($response1);
		}
		else if(count($response["PickListDetails"])==1)
		{
		$response1["PickListDetails"] = array_slice($response["PickListDetails"], 0,1);            
	    echo json_encode($response1);
		}
		}
		else{
		
		$response1["PickListDetails"] = $response["PickListDetails"]; 
		echo json_encode($response1);
		}
	
} 
else {
    // required post params is missing
    $response["error"] = true;
    $response["error_msg"] = "Required Parameters Missing!";
    echo json_encode($response);
}

// echo $val= str_replace('\\/', '/', json_encode($set));
