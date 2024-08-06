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

  $querycnt = "SELECT outward_master.outward_entry_no,
                      outward_master.invoice_no,
                      outward_master.outward_status,
                      customer_reg_master.customer_code,
                      CONCAT('http://wms.tasca.in/img/',customer_reg_master.logo) 
                      AS logo,customer_reg_master.city,customer_reg_master.state 
                      FROM outward_master
                      INNER JOIN customer_reg_master 
                      ON customer_reg_master.customer_id = outward_master.warehouse_customer_id 
                      WHERE outward_master.record_status='1'
                      AND DATE(outward_master.outward_date)=DATE(NOW()) 
                      AND outward_master.company_id='".$_POST['company_id']."' 
                      AND outward_master.warehouse_id='".$_POST['warehouse_id']."' 
                      ORDER BY outward_entry_no DESC";

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
				$response["TodayOutward"][$i] = $results;

              $querycnt2 = "SELECT outward_master.trip_no,
                customer_reg_master.customer_code,
                customer_reg_master.customer_name
                FROM outward_master
                INNER JOIN customer_reg_master 
                ON customer_reg_master.customer_id = outward_master.end_customer_id 
                WHERE outward_master.outward_entry_no='".$results['outward_entry_no']."'";
                $resultqr2=mysql_query($querycnt2) or die(mysql_error());
                $total_records2=mysql_num_rows($resultqr2);
                $res=mysql_fetch_assoc($resultqr2); 
                if($total_records2>=1){
                    
                        $response["is_success"]=true;
                        $response["messages"]="Record Found";
                        $response["TodayOutward"][$i]['Name']=$res["customer_name"];
                    
                      
                }
                else
  {
  
                      $response["is_success"] = true;
                      $response["EndCustomerName"] = "No Record Found";
                       $response["EndCustomerName"]=array();
  }

		$i++;
		}
    
    }
	else
	{
        //$results[]={};
        $response["is_success"] = true;
        $response["messages"] = "No Record Found";
		$response["TodayOutward"] = array();
       

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
