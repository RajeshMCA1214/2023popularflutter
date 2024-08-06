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
 
if (isset($_POST['start_date']) && ($_POST['employeeCode']!="")  && isset($_POST['end_date'])) {

 $querycnt = "SELECT COALESCE(SUM(pickitem_completed_qty),0) AS total_item, COALESCE(SUM(picked_rate),0) AS total_amt, COUNT(pick_id) AS total_count  FROM 	pick_list_master
 WHERE 	r_timestamp>='".$_POST['start_date']."' 
 AND  	r_timestamp<='".$_POST['end_date']."'	
 AND  picker_emp_code='".$_POST['employeeCode']."'
 AND record_status='1' AND pick_status<>'Active' ";
 
 $querycategory = "SELECT COUNT(*) As coutn,pick_category  FROM pick_list_master
 WHERE 	r_timestamp>='".$_POST['start_date']."' 
 AND  	r_timestamp<='".$_POST['end_date']."'	
 AND  picker_emp_code='".$_POST['employeeCode']."'
 AND record_status='1' AND pick_status<>'Active'  GROUP BY pick_category";
  $rescategory = mysql_query($querycategory)or die('Error:'.mysql_error());
  $total_records1 = mysql_num_rows($rescategory);
  
  $resultscount='';
  $j=0;
   if ($total_records1 >= 1) {
  while($resultscount=mysql_fetch_array($rescategory, MYSQL_ASSOC)){
  			$response["categorycount"][$j]=$resultscount;
			$j++;
  }}
  	else	
  {
  		 $response["is_success"] = true;
        $response["messages"] = "No Record Found";
		$response["TotalCount"] = array();
  }
  
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
