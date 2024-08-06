<?php
ini_set('display_errors', 0);
ini_set('display_startup_errors', 0);
error_reporting(0);
header("Access-Control-Allow-Origin: *");
include_once 'includes/variables1.php';



$mysqli = @mysql_connect(DB_HOST, DB_USER, DB_PASSWORD) or die('Could not connect to MySQL');
@mysql_select_db(DB_NAME) or die('Could not select the database');

//$response = array("error" => FALSE);
//mysql_query("SET NAMES 'utf8'");

/**
 * Get user by Mobile and password
 */

//$_POST=json_decode(file_get_contents('php://input'), true);
    // receiving the post params
 
if (isset($_POST['id'])) {
	$i = 0;
    $results='';
   $querycnt = "SELECT * FROM micromak_service_master  WHERE  service_no LIKE 'SR%' ";
    $resouter = mysql_query($querycnt)or die('Error:'.mysql_error());
    $total_records = mysql_num_rows($resouter);
	 if ($total_records > 0) {
  				$set['tascaSmartPick'][] = $results;
				//$results[]={};
				$response["is_success"] = true;
				$response["messages"] = " Picked List Data Available";
				while ($results = mysql_fetch_array($resouter, MYSQL_ASSOC)){
				
				
						 $querycnt1 = "UPDATE micromak_customer_address  SET
										
										invoice_no='".$results['invoice_no']."',
										invoice_date='".$results['invoice_date']."',
										type='Services',
										invoice_subtotal='".$results['cost_estimation']."',
										discount_value='".$results['discount_value']."',
										invoice_gst_val='".$results['tax_value']."',
										invoice_cgst_val='".$results['c_gst_val']."',
										invoice_sgst_val='".$results['s_gst_val']."',
										invoice_igst_val='".$results['i_gst_val']."',
										invoice_total='".$results['total_amount']."',
										payment_status='".$results['payment_status']."',
										type_status='".$results['amc_status']."',
										
										approve_status='".$results['approve_status']."',
										
									
										customer_type='".$results['customer_type']."'
										
										WHERE id='".$results['service_no']."' ";
										
							 $resouter1 = mysql_query($querycnt1)or die('Error:'.mysql_error());
							
						$response["PickListMaster"][$i] = $results;
						$i++;
					
				}
			
			
	}
	else
	{
		$response["is_success"] = false;
        $response["messages"] = "Picked List Data NOT Available!";
	}
                 
	 echo json_encode($response);
	
} 
else {
    // required post params is missing
    $response["is_success"] = false;
    $response["messages"] = "Pass Correct Parameters!";
    echo json_encode($response);
}

// echo $val= str_replace('\\/', '/', json_encode($set));
?>