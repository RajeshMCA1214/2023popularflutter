<?php
header("Access-Control-Allow-Origin: *");
include_once 'includes/variables.php';



$link = mysqli_connect($host, $username, $password, "id20696910_pearicon");


 
if (isset($_POST['userid'])  && isset($_POST['taskStatus'])) {
	if($_POST['userid']=='P10001'){
	if($_POST['taskStatus']=='total'){
	$querycnt = "SELECT *FROM task_master";
	}
	$querycnt = "SELECT *FROM  task_master WHERE task_status='".$_POST['taskStatus']."'";
	}else{
	$querycnt = "SELECT *FROM task_master WHERE task_status='".$_POST['taskStatus']."' AND user_id='".$_POST['userid']."'";
	}
 	
    $resouter = mysqli_query($link,$querycnt);
    $set = array();
    $total_records = mysqli_num_rows($resouter);
	$i = 0;
    $results='';
    if ($total_records >= 1) {
        //$results[]={};
		$set['tascaSmartPick'][] = $results;
        $response["is_success"] = true;
        $response["messages"] = "Record Found";
		while ($results = mysql_fetch_array($resouter, MYSQL_ASSOC)){
				$response["AssignedPickList"][$i] = $results;
		$i++;
		}
    
    }
	else
	{
        //$results[]={};
        $response["is_success"] = true;
        $response["messages"] = "No Record Found";
		$response["AssignedPickList"] = array();
       

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
