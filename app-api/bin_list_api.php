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
 
	if (isset($_POST['compCode']) ) {
	

   $querycnt = "SELECT * FROM pallet_master WHERE  record_status='1' ";

    $resouter = mysql_query($querycnt)or die('Error:'.mysql_error());
    $set = array();
    $total_records = mysql_num_rows($resouter);
	$i = 0;
    $results='';
    if ($total_records >= 1) {
        //$results[]={};
		$set['tascaSmartPick'][] = $results;
        $response["is_success"] = true;
        $response["messages"] = "Record Found";
		while ($results = mysql_fetch_array($resouter, MYSQL_ASSOC)){
				$response["BinName"][$i] = $results;
		$i++;
		}
    
    }
	else
	{
        //$results[]={};
        $response["is_success"] = true;
        $response["messages"] = "No Record Found";
		$response["BinName"] = array();
       

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
