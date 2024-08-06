<?php
ini_set('display_errors', 0);
ini_set('display_startup_errors', 0);
error_reporting(0);
header("Access-Control-Allow-Origin: *");
include_once 'includes/variables.php';

/*DEFINE('DB_HOST', "localhost");
DEFINE('DB_USER', "root");
DEFINE('DB_PASSWORD', "");
DEFINE('DB_NAME', "tasca_wms");*/



$mysqli = @mysql_connect(DB_HOST, DB_USER, DB_PASSWORD) or die('Could not connect to MySQL');
@mysql_select_db(DB_NAME) or die('Could not select the database');

//$response = array("error" => FALSE);
//mysql_query("SET NAMES 'utf8'");

/**
 * Get user by Mobile and password
 */

//$_POST=json_decode(file_get_contents('php://input'), true);
    // receiving the post params

if (isset($_POST['email_id']) && isset($_POST['usergroup']) && isset($_POST['company_id'])) {
	if($_POST['company_id'] == '0')
		 $querycnt = "SELECT company_id,warehouse_id, warehouse_name, area, city FROM warehouse_master WHERE record_status='1' AND warehouse_name<>'Warehouse-All'";
	else
		$querycnt = "SELECT company_id,warehouse_id, warehouse_name, area, city FROM warehouse_master WHERE company_id='".$_POST['company_id']."' AND warehouse_name<>'Warehouse-All'";
		
		
    $resouter = mysql_query($querycnt);
   // $data = mysql_fetch_assoc($resouter);

    $set = array();
    $total_records = mysql_num_rows($resouter);
    if ($total_records >= 1) {
				$set['tascaWMSi'][] = $results;
				$response["status"] = "ok";
				$response["is_success"] = "true";
				$response["messages"] = "Records Found";
		while ($results = mysql_fetch_array($resouter, MYSQL_ASSOC)){
				$response["warehouseList"][] = $results;
			/*	$response["warehouseList"]["companyId"] = $results["company_id"];
				$response["warehouseList"]["warehouseName"] = $results["warehouse_name"];
				$response["warehouseList"]["warhouseArea"] = $results["area"];
				$response["warehouseList"]["warhouseCity"] = $results["city"];*/
		//		echo json_encode($response);
				
		}
		echo json_encode($response);
	}
	
	else
	{
        //$results[]={};
        $response["status"] = "Ok";
        $response["is_success"] = "true";
        $response["messages"] = "No Record Found";
        $response["warehouseList"] = array();
        echo json_encode($response, JSON_FORCE_OBJECT);

    }
	}
else {
    // required post params is missing
    $response["status"] = "Not Ok";
    $response["is_success"] = "false";
    $response["messages"] = "Required Parameters Missing!";
    echo json_encode($response);
}

// echo $val= str_replace('\\/', '/', json_encode($set));
