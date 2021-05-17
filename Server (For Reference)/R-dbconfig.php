<?php
    $db_name = "withgpsuserdata";
    $db_user = "root";
    $db_pass = '';
    $db_host = 'localhost';

    $con = mysqli_connect($db_host,$db_user,$db_pass,$db_name);
    if(!$con){
        echo "error";
    }
?>
