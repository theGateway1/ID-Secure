<?php
    include_once("dbconfig.php");
    $email = $_POST["email"];
    $name = $_POST["name"];
    $pass = $_POST["pass"];


    //Check if user is already registered 
    $query = "SELECT * FROM userdata WHERE email LIKE '$email'";
    $res = mysqli_query($con,$query);
    $data = mysqli_fetch_array($res);

    if($data[0] >= 1){// THIS WAS MAIN ERROR TOO
        //account already exists.
        echo "account already exists";

    }else{
        $query = "INSERT INTO userdata (id,name,email,pass) VALUES (null,'$name','$email','$pass')";
        $res = mysqli_query($con,$query);

        if($res){
            echo "true";
        }else{
            echo "false";
        }
    }
?>

    


