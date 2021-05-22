<?php
    $database = "withgpsuserdata";
    $username = "root";
    $password = '12345678';
    $servername = 'localhost';

    $con = mysqli_connect($servername,$username,$password,$database);
    if(!$con){
        echo "error";
    }
?>
