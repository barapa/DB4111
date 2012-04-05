<html>
<head>
  <link href="../code/css/style.css" rel="stylesheet" type="text/css" />
<head>
<body>

<?php
  require_once "../static/php/connection.php";
  
  $amountString = $_POST['donation'];
  $pid = $_POST['pid'];
  $tid = $_POST['tid'];
  $today = date("d-m-y"); 
  
  
  // check if we're already logged in:
  if (isset($_SESSION['email'])) {
    header("Location:index.php?error=loggedin");
    exit;
  }
  
  // check if its a valid donation value
  $currencyRegex = "/^[0-9]+(?:\.[0-9]+)?$/im";
  if (0 == preg_match($currencyRegex, $amountString)) {
    header("Location:index.php?error=invalid_donation");
    exit;
  }
  
  // query to get the largest current did value
  $maxDidQuery = "select max(d.did) as maxDid from Donations_FUND d";
  
  // make query
  $maxDidStmt = oci_parse($conn, $maxDidQuery);
  oci_execute($maxDidStmt);
  if($res = oci_get_row($maxDidStmt)) 
    $maxDid = $res[0]; // set maxDid to result
  else
    $maxDid = 0; // if no donations, set maxDid to 0
  
  $currentDid = $maxDid + 1;
  
  // insert donation into table
  $donateInsertionStr =  "insert into Donations_FUND " .
                         "(tid, pid, amount, donationDate, email, did) " . 
                         "VALUES " . 
                         "'" . $tid . "', '" . $pid . "', " . $amountString . ", '" . $today . "', " .
                         "'" . $_SESSION['email'] . "', " . $currentDid . ")";
  
  // run insert statement
  $stmt = oci_parse($conn, $donateInsertionStr);
  oci_execute($stmt);
  
  header("Location:../index.php?msg=donated");
                         
//INSERT INTO Donations_FUND
//(tid, pid, amount, donationDate, email, did)
//VALUES
//('a89af066d9553a4aff50b0dc5c3650ea','83e5cc1b9c24f749b19e923cfd082faa',100,'24-apr-11','clarence@fun.com', 1);


  

