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
 
if (isset($_POST['company_id']) && isset($_POST['warehouse_id']) && isset($_POST['grn_no'])) {

   	$querycnt1 = "SELECT * FROM `gate_entry_master` WHERE grn_no ='".$_POST['grn_no']."' LIMIT 0,1";
    $resouter1 = mysql_query($querycnt1)or die('Error:'.mysql_error());
	
	if($resouter1[0]['vehicle_type']=="Own Vehicle")
{
	$querycnt2 = 'SELECT gate_entry_master.*,transport_master.vehicle_no AS vehicle_no FROM `gate_entry_master`,transport_master WHERE grn_no ="'.$_POST['grn_no'].'" AND transport_master.transportId=gate_entry_master.warehouse_vehicle_id LIMIT 0,1'; 
	$resouter2	= mysql_query($querycnt2)or die('Error:'.mysql_error());
}
else
{
	$querycnt2 = 'SELECT * FROM `gate_entry_master` WHERE grn_no ="'.$_POST['grn_no'].'" LIMIT 0,1'; 
	$resouter2	= mysql_query($querycnt2)or die('Error:'.mysql_error());

}
	
	
    $set = array();
    $total_records = mysql_num_rows($resouter2);
	$i = 0;
	$results = "";
    if ($total_records >= 1) {
        //$results[]={};
		$set['tascaWMSi'][] = $results;
        $response["is_success"] = true;
        $response["messages"] = "Record Found";
		while ($results = mysql_fetch_array($resouter2, MYSQL_ASSOC)){
				$response["InwardMaster"][$i] = array("customer_name"=>$results['supplier_customer_name'],
				"customer_code"=>$results['supplier_customer_code'],
				"customer_id"=>$results['supplier_customer_id'],
				"vehicle_no"=>$results['vehicle_no'],
				"customer_space"=>"2500",
				"occupied_space"=>"2000",
				"free_space"=>"500",
				"invoice_no"=>$results['invoice_no'],
				"invoice_value"=>$results['invoice_value'],
				"invoice_date"=>$results['invoice_date'],
				"irn_no"=>$results['irn']
				);
				$i++;
			}
			
			$querycnt3 = 'SELECT * FROM `gate_entry_details` WHERE grn_no ="'.$_POST['grn_no'].'"'; 
			$resouter3	= mysql_query($querycnt3)or die('Error:'.mysql_error());
			
			 $total_records3 = mysql_num_rows($resouter3);
			$j = 0;
			if ($total_records3 >= 1) {
			
			while ($results3 = mysql_fetch_array($resouter3, MYSQL_ASSOC)){
				$response["InwardDetails"][$j] = array("material_code"=>$results3['material_code'],
				"material_qty"=>$results3['received_qty'],
				"material_price"=>$results3['total']
				);
				$j++;
			}
				
			}
       
		echo json_encode($response);
    }
	else
	{
        //$results[]={};
        $response["is_success"] = false;
        $response["messages"] = "No Record Found";
		$response["TodayPlan"] = array();
        echo json_encode($response, JSON_FORCE_OBJECT);

    }

	
	 
} 
else {
    // required post params is missing
    $response["error"] = true;
    $response["error_msg"] = "Required Parameters Missing!";
    echo json_encode($response);
}

// echo $val= str_replace('\\/', '/', json_encode($set));
