<?php
// check for messages on this page, print those message:
if (!empty($_REQUEST['msg'])) {
  $msg = $_REQUEST['msg'];
  echo "<div class=message><p>";
  if ($msg == 'welcome') {
    echo "Welcome to the site!";
  } else if ($msg == 'loggedin') {
    echo "You were successfully logged in.";
  } else if ($msg == 'logout') {
    echo "You were successfully logged out.";
  } else if ($msg == 'donated') {
    echo "Thank you for donating!";
  } else if ($msg == 'commented') {
    echo "Thank you for leaving feedback!";
  }
    

  echo "</p></div>";
}
?>
