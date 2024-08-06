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
 
if (isset($_POST['Slno']) && isset($_POST['itemCode'])  && isset($_POST['pickid'])) {
	
	
	 $querycnt2 = "SELECT * FROM picked_list_details  WHERE  Slno='".$_POST['Slno']."'";
     $resouter2 = mysql_query($querycnt2)or die('Error:'.mysql_error());
	 $rowcnt = mysql_num_rows( $resouter2);
	// print_r ($rowcnt);exit;
	if($rowcnt>0)
	{
	  $querydelete = "DELETE FROM picked_list_details  WHERE  Slno='".$_POST['Slno']."'  AND  record_status='1' ";
      $result = mysql_query($querydelete)or die('Error:'.mysql_error());
	
		
				
				
		$resouter["is_success"] = true;
		$resouter["messages"] = "Delete Successfully!";
		echo json_encode($resouter);
	} 
	else {
		// required post params is missing
		$resouter["is_success"] = false;
		$resouter["messages"] = "No Records Found";
		echo json_encode($resouter);
	}
}
// echo $val= str_replace('\\/', '/', json_encode($set));
