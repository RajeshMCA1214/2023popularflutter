<?php
header("Access-Control-Allow-Origin: *");
include_once 'includes/variables.php';

$mysqli = @mysql_connect(DB_HOST, DB_USER, DB_PASSWORD) or die('Could not connect to MySQL');
@mysql_select_db(DB_NAME) or die('Could not select the database');

if (isset($_POST['pick_id'])) {

	$querycnt = "SELECT COUNT(pick_id) AS activecnt FROM pick_list_details WHERE  pick_id='".$_POST['pick_id']."' AND (pick_status ='Active' OR pick_status ='Not Picked')";
    $resouter = mysql_query($querycnt)or die('Error:'.mysql_error());
	$querycntRes= mysql_fetch_assoc($resouter);
	
	if($querycntRes['activecnt']<=0){
	date_default_timezone_set("Asia/Kolkata");
	$nowtime=date("H.i");
	$queryUpdate="UPDATE pick_list_master SET pick_status='Completed', pick_completed_date=DATE(NOW()),  pick_completed_time='".$nowtime."' WHERE pick_id='".$_POST['pick_id']."'";
	$queryExc=mysql_query($queryUpdate)or die('Error:'.mysql_error());
	 if($queryUpdate)
	 {
	 	
  	$querycnt = "SELECT pd.pick_id,
						pd.partno,
						pd.picked_qty,
						pd.picked_rate,
						pd.bin_qrcode,
						pm.picker_emp_code,
						pm.pick_assign_time,
						pm.pick_completed_time	
						 FROM pick_list_master pm,pick_list_details pd  WHERE pm.pick_id='".$_POST['pick_id']."' AND pd.pick_id='".$_POST['pick_id']."' AND pm.pick_status='Completed' AND (pd.pick_status<>'Active' OR pd.pick_status<>'Not Picked') ORDER BY pd.Slno ASC ";
    $resouter = mysql_query($querycnt)or die('Error:'.mysql_error());
    $set = array();
    $total_records = mysql_num_rows($resouter);
	$i = 0;
    $results='';
    if ($total_records >= 1) {
        //$results[]={};
		$set['tascaSmartPick'][] = $results;
		//$response["is_success"] = true;
      
		while ($results = mysql_fetch_array($resouter, MYSQL_ASSOC)){
				//$response[$i] = $results;
			 	$response[$i] =array(
				"pick_id" => $results['pick_id'],
				"partno"=> stripslashes($results['partno']),
				"picked_qty"=> $results['picked_qty'],     
				"picked_rate"=> $results['picked_rate'],
				"bin_qrcode"=> $results['bin_qrcode'],
				"picker_emp_code"=> $results['picker_emp_code'],
				"pick_assign_time"=> $results['pick_assign_time'],
				"pick_completed_time"=> $results['pick_completed_time']);
				
		$i++;
		}
		
 
    	
    }
	else
	{
        //$results[]={};
        $response["is_success"] = true;
        $response["messages"] = "No Record Found";
		$response["PickListMaster"] = array();
       
		echo json_encode("No Record");
    }
	
                      
	 //echo json_encode($response);

	//$folderpath="D:/jsonfile/";
	exec('net use \\\192.168.1.103\h\abspopular-royl /user:"'.$user.'" "'.$password.'" /persistent:no');
	$folderpath = '\\\192.168.1.103\\h\\abspopular-royl\\absdata\\mobileapp\\2324\\royal';
	//\\192.168.1.103\h\abspopular-royl\absdata\mobileapp\2324
	//$ip=$_SERVER['\\192.168.1.103\h\abspopular-royl\absdata\mobileapp\2324'];
	//$fp = fopen("ftp://username:password@host/data/custom/alarm.txt","w");
	 $json_data = json_encode($response);
	file_put_contents($folderpath.$_POST['pick_id'].'.json', $json_data);
	
} 
	 echo json_encode("Completed Successfully");
	 }
	 
	}

else {
   
    echo json_encode("Please Completed Pending Pick List");
}

?>
