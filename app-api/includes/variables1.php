<?php

	//database configuration
/*
	$host       = "localhost";
	$user       = "root";
	$pass       = "";
	$database   = "android_news_app";
	
	$connect    = new mysqli($host, $user, $pass, $database) or die("Error : ".mysql_error());		
	*/
DEFINE('DB_HOST', "localhost");
DEFINE('DB_USER', "root");
DEFINE('DB_PASSWORD', "");
DEFINE('DB_NAME', "tasca_microdb");


$mysqli = @mysql_connect(DB_HOST, DB_USER, DB_PASSWORD) or die('Could not connect to MySQL');
@mysql_select_db(DB_NAME) or die('Could not select the database');
	
?>