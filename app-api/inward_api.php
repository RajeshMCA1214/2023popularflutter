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
 
if (isset($_POST['company_id']) && isset($_POST['warehouse_id'])) {

  $querycnt = "SELECT gate_entry_master.grn_no,
                      gate_entry_master.invoice_no,
                      gate_entry_master.put_status,
                      customer_reg_master.customer_code,
                      CONCAT('http://wms.tasca.in/img/',customer_reg_master.logo) 
                      AS logo,customer_reg_master.city,customer_reg_master.state 
                      FROM gate_entry_master
		            INNER JOIN customer_reg_master 
                    ON customer_reg_master.customer_id = gate_entry_master.supplier_customer_id
		            WHERE gate_entry_master.record_status='1'
                    AND DATE(gate_entry_master.gate_entry_datetime)=DATE(NOW()) 
                    AND gate_entry_master.company_id='".$_POST['company_id']."' 
                    AND gate_entry_master.warehouse_id='".$_POST['warehouse_id']."' 
                    AND (g1_status=1 AND g2_status=1 AND stock_status=1 ) ORDER BY gate_entry_id DESC";

    $resouter = mysql_query($querycnt)or die('Error:'.mysql_error());
    $set = array();
    $total_records = mysql_num_rows($resouter);
	$i = 0;
    $results='';
    if ($total_records >= 1) {
        //$results[]={};
		$set['tascaWMSi'][] = $results;
        $response["is_success"] = true;
        $response["messages"] = "Record Found";
		while ($results = mysql_fetch_array($resouter, MYSQL_ASSOC)){
				$response["TodayInward"][$i] = $results;
		$i++;
		}
    
    }
	else
	{
        //$results[]={};
        $response["is_success"] = true;
        $response["messages"] = "No Record Found";
		$response["TodayPlan"] = array();
       

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
