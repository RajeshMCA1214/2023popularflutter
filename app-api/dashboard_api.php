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
 
if (isset($_POST['company_id']) && isset($_POST['warehouse_id'])) {

  $querycnt = "SELECT pick_list_master.pick_id,pick_list_master.pick_status, 
  customer_reg_master.customer_name, customer_reg_master.customer_code 
  FROM pick_list_master,customer_reg_master 
  WHERE pick_list_master.pick_date=DATE(NOW()) 
  AND pick_list_master.company_id='".$_POST['company_id']."'
  AND pick_list_master.warehouse_id ='".$_POST['warehouse_id']."'
   AND customer_reg_master.customer_id=pick_list_master.warehouse_customer_id";

    $resouter = mysql_query($querycnt)or die('Error:'.mysql_error());
    $set = array();
    $total_records = mysql_num_rows($resouter);
	$i = 0;
	$results = "";
    if ($total_records >= 1) {
        //$results[]={};
		$set['tascaWMSi'][] = $results;
        $response["is_success"] = true;
        $response["svgmessages"] = "Record Found";
		while ($results = mysql_fetch_array($resouter, MYSQL_ASSOC)){
				$response["TodayPlan"][$i] = array(
				"svg" => '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="360.455" height="162.338" viewBox="0 0 360.455 162.338"><defs><clipPath id="clip-path">
<rect y="11" width="201.146" height="162.292" fill="none"/></clipPath></defs><g id="Group_431" data-name="Group 431" transform="translate(-27 -139)"><rect id="Rectangle_35" data-name="Rectangle 35" width="360" height="162" rx="20" transform="translate(27 139)" fill="#00052a"/><g id="Scroll_Group_2" data-name="Scroll Group 2" transform="translate(186.309 128.046)" clip-path="url(#clip-path)" style="isolation: isolate"><path id="Icon_metro-bitcoin" data-name="Icon metro-bitcoin" d="M148.42,69.142q2.276,23.012-16.563,32.621,14.793,3.54,22.126,13.023t5.69,27.058a47.8,47.8,0,0,1-4.109,15.8,34.888,34.888,0,0,1-8.155,11.253,41.5,41.5,0,0,1-12.264,7.4,74.726,74.726,0,0,1-15.362,4.362,152.339,152.339,0,0,1-18.4,1.9V214.8H81.914V183.062q-10.115,0-15.425-.126V214.8H47.017V182.556q-2.276,0-6.828-.063t-6.954-.063H7.948l3.919-23.138H25.9q6.322,0,7.333-6.448V102.016h2.023a12.855,12.855,0,0,0-2.023-.126V65.6Q31.592,57,21.983,57H7.948V36.269l26.8.126q8.092,0,12.265-.126V4.407H66.489v31.23q10.368-.253,15.425-.253V4.407h19.471V36.269a112.8,112.8,0,0,1,17.7,2.845,57.5,57.5,0,0,1,14.287,5.69A28.965,28.965,0,0,1,143.8,54.665a32.265,32.265,0,0,1,4.615,14.477Zm-27.184,68.908a16.87,16.87,0,0,0-1.9-8.092,18.958,18.958,0,0,0-4.678-5.816,24.009,24.009,0,0,0-7.27-3.856,61.382,61.382,0,0,0-8.282-2.339,74.767,74.767,0,0,0-9.356-1.138q-5.563-.379-8.724-.379t-8.155.126q-4.993.126-6.006.126v42.736q1.011,0,4.678.063t6.069.063q2.4,0,6.7-.19t7.4-.506q3.1-.316,7.207-1.075a48.4,48.4,0,0,0,7.017-1.77,42.964,42.964,0,0,0,6.006-2.655,17.522,17.522,0,0,0,4.994-3.793,17.871,17.871,0,0,0,3.1-5.057,16.761,16.761,0,0,0,1.2-6.448Zm-8.977-60.184a16.6,16.6,0,0,0-1.581-7.4,17.62,17.62,0,0,0-3.856-5.31,18.906,18.906,0,0,0-6.069-3.54A43.457,43.457,0,0,0,93.8,59.533a69.618,69.618,0,0,0-7.776-1.011q-4.615-.379-7.333-.316t-6.828.126q-4.109.063-4.994.063V97.211q.632,0,4.362.063t5.879,0q2.149-.063,6.322-.253a53.47,53.47,0,0,0,6.954-.7q2.782-.506,6.511-1.391a21.437,21.437,0,0,0,6.132-2.339,34.718,34.718,0,0,0,4.678-3.414,12.166,12.166,0,0,0,3.414-4.868,17.535,17.535,0,0,0,1.138-6.448Z" transform="matrix(0.921, -0.391, 0.391, 0.921, -9.038, 58.45)" fill="#fff" opacity="0.02"/></g><text id="'.$results["pick_id"].'" data-name="#'.$results["pick_id"].'" transform="translate(61 269)" fill="#fff" font-size="18" font-family="JosefinSans-Bold, Josefin Sans" font-weight="700"><tspan x="0" y="0">BTC</tspan><tspan y="0" xml:space="preserve" font-size="22"> 1000.00</tspan></text><text id="Current_Value" data-name="Current_Value" transform="translate(61 238)" fill="#fff" font-size="14" font-family="JosefinSans-Regular, Josefin Sans"><tspan x="0" y="0">'.$results["customer_name"].'</tspan></text><text id="Bitcoin" transform="translate(61 181)" fill="#fff" font-size="24" font-family="JosefinSans-Bold, Josefin Sans" font-weight="700"><tspan x="0" y="0">'.$results["customer_code"].'</tspan></text><g id="Group_430" data-name="Group 430" transform="translate(93 77)"><rect id="Rectangle_36" data-name="Rectangle 36" width="70" height="21" rx="10.5" transform="translate(198 177)" fill="#03540b" opacity="0.3"/><g id="Group_429" data-name="Group 429" transform="translate(218.702 182)"><text id="_5.23_" data-name="'.$results["pick_status"].'" transform="translate(4.54 9)" fill="#14bc25" font-size="12" font-family="JosefinSans-Regular, Josefin Sans"><tspan x="0" y="0">5.23%</tspan></text><path id="Icon_ionic-md-arrow-dropdown" data-name="Icon ionic-md-arrow-dropdown" d="M0,0,3.121,3.121,6.242,0Z" transform="translate(-0.46 7.121) rotate(180)" fill="#14bc25"/></g></g><g id="Icon_ionic-ios-wallet" data-name="Icon ionic-ios-wallet" transform="translate(322.625 150.192)" opacity="0.5"><path id="Path_59" data-name="Path 59" d="M33.327,11.25H8.423A5.052,5.052,0,0,0,3.375,16.3V30.433a5.052,5.052,0,0,0,5.048,5.048h24.9a5.052,5.052,0,0,0,5.048-5.048V16.3A5.052,5.052,0,0,0,33.327,11.25Z" transform="translate(0 1.327)" fill="#fff"/><path id="Path_60" data-name="Path 60" d="M27.965,4.584,8.2,8.446c-1.514.337-3.7,1.859-3.7,3.71a5.3,5.3,0,0,1,4.123-1.6H32.769V8.833A4.831,4.831,0,0,0,31.6,5.67h0A3.979,3.979,0,0,0,27.965,4.584Z" transform="translate(0.221)" fill="#fff"/></g></g></svg>'
		);
	/*"svg"=>"SVG Data");*/
		$i++;
		}
       

    }
	else
	{
        //$results[]={};
        $response["is_success"] = true;
        $response["svgmessages"] = "No Record Found";
		$response["TodayPlan"] = array();
       // echo json_encode($response, JSON_FORCE_OBJECT);

    }
	
	$querycnt2 = "SELECT COUNT(*) AS Total,
    SUM(case when trip_mode = 'Inward' then 1 else 0 end) AS InwardCount,
    SUM(case when trip_mode = 'Outward' then 1 else 0 end) AS OutwardCount FROM trip_master WHERE trip_master.trip_date=DATE(NOW()) AND trip_master.company_id='".$_POST['company_id']."' AND trip_master.warehouse_id ='".$_POST['warehouse_id']."'";
    $resouter2 = mysql_query($querycnt2) or die('Error:'.mysql_error());
	$total_records2 = mysql_num_rows($resouter2);
    if ($total_records2 >= 1) {
		$results2 = mysql_fetch_assoc($resouter2);
		if($results2['Total']>0)
		{
			$response["is_success"] = true;
            $response["tripmessages"] = "Record Found";
            $response["TripCount"][]=array("Total"=>$results2['Total'], "InwardCount"=>$results2['InwardCount'],"OutwardCount"=>$results2['OutwardCount']);
// 			$response["TripCount"]['Total'] = $results2['Total'];
// 			$response["TripCount"]['InwardCount'] = $results2['InwardCount'];
// 			$response["TripCount"]['OutwardCount'] = $results2['OutwardCount'];
		}
		else
		{
		
		$response["is_success"] = true;
        $response["tripmessages"] = "No Record Found";
// 			$response["TripCount"]['Total'] = 0;
// 			$response["TripCount"]['InwardCount'] = 0;
// 			$response["TripCount"]['OutwardCount'] = 0;
              $response["TripCount"]=array();
		}
		
	}
	
		$querycnt3 = "SELECT pick_list_master.pick_id,pick_list_master.pick_status, pick_list_master.trip_time, customer_reg_master.customer_name, customer_reg_master.customer_code FROM pick_list_master,customer_reg_master WHERE pick_list_master.pick_date=DATE(NOW()) AND pick_list_master.company_id='".$_POST['company_id']."' AND pick_list_master.warehouse_id ='".$_POST['warehouse_id']."' AND customer_reg_master.customer_id=pick_list_master.warehouse_customer_id AND pick_list_master.pick_status<>1";
    $resouter3 = mysql_query($querycnt3) or die('Error:'.mysql_error());
	$total_records3 = mysql_num_rows($resouter3);
    if ($total_records3 >= 1) {
			$response["is_success"] = true;
        	$response["pickmessages"] = "Record Found";
			while ($results3 = mysql_fetch_array($resouter3, MYSQL_ASSOC)){
				$response["PendingPick"][] = $results3;
		}
	
	}
	else
	{
		$response["is_success"] = true;
        $response["pickmessages"] = "No Record Found";
		$response["PendingPick"]=array();
		
	}
	$querycnt4 = "SELECT put_list_master.put_id,put_list_master.put_status, put_list_master.r_timestamp, put_list_master.put_date, customer_reg_master.customer_name, customer_reg_master.customer_code FROM put_list_master,customer_reg_master WHERE put_list_master.put_date=DATE(NOW()) AND put_list_master.company_id='".$_POST['company_id']."' AND put_list_master.warehouse_id ='".$_POST['warehouse_id']."' AND customer_reg_master.customer_id=put_list_master.customer_id AND put_list_master.put_status<>1";
    $resouter4 = mysql_query($querycnt4) or die('Error:'.mysql_error());
	$total_records4 = mysql_num_rows($resouter4);
    if ($total_records4 >= 1) {
			$response["is_success"] = true;
        	$response["putmessages"] = "Record Found";
			while ($results4 = mysql_fetch_array($resouter4, MYSQL_ASSOC)){
				$response["PendingPut"][] = $results4;
		}
	
	}
	else
	{
		$response["is_success"] = true;
        $response["putmessages"] = "No Record Found";
		$response["PendingPut"]=array();
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
