<?php
header("Access-Control-Allow-Origin: *");
include_once 'includes/variables.php';



$mysqli = @mysql_connect(DB_HOST, DB_USER, DB_PASSWORD) or die('Could not connect to MySQL');
@mysql_select_db(DB_NAME) or die('Could not select the database');


 
if (isset($_POST['start_date']) && ($_POST['employeeCode']!="") && ($_POST['category']!="") && isset($_POST['end_date'])) {

 $querycnt = "SELECT * FROM `pick_list_master` WHERE pick_date >= '".$_POST['start_date']."' AND pick_date <=  '".$_POST['end_date']."' AND pick_category='".$_POST['category']."' AND picker_emp_code='".$_POST['employeeCode']."' AND pick_assigned_status='1' AND record_status='1'  AND pick_status<>'Active'";

$querysum = "SELECT SUM(pickitem_completed_qty)AS pickedQty,SUM(picked_rate)AS pickedRate,SUM(total_item_count)AS totalQty,SUM(total_amt)As totalamt,COUNT(pick_id)  FROM `pick_list_master` WHERE pick_date BETWEEN '".$_POST['start_date']."' AND '".$_POST['end_date']."' AND pick_category='".$_POST['category']."' AND picker_emp_code='".$_POST['employeeCode']."' AND pick_assigned_status='1' AND record_status='1'";
	$resoutersum = mysql_query($querysum)or die('Error:'.mysql_error());
	$resultsum=mysql_fetch_assoc($resoutersum);
    $resouter = mysql_query($querycnt)or die('Error:'.mysql_error());
    $set = array();
    $total_records = mysql_num_rows($resouter);
	$i = 0;
    $results='';
    if ($total_records >= 1) {
        //$results[]={};
		$set['profileHistory'][] = $results;
        $response["is_success"] = true;
        $response["messages"] = "RecordFound";
		$response["Total"][]=$resultsum;
		while ($results = mysql_fetch_array($resouter, MYSQL_ASSOC)){
				$response["TotalCount"][$i] = $results;
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
