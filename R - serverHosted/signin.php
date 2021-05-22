<?php
    include_once("dbconfig.php");
    $email = $_POST["email"];
    $pass = $_POST["pass"];

    //Check if user is signed up 
    $query = "SELECT * FROM userdata WHERE email LIKE '$email'";
    $res = mysqli_query($con,$query);
    $data = mysqli_fetch_array($res);

    //data[0]=id, data[1]=name, data[2]=email, data[3]=pass
    if($data[2] >= 1){
        //account exists
        $query = "SELECT * FROM userdata WHERE pass LIKE '$pass'";
        $res = mysqli_query($con,$query);
        $data = mysqli_fetch_array($res);

        if($data[3] == $pass){
            //password matched
           echo "true";
           $resarr = array();
           array_push($resarr,array("name"=>$data['1'],"email"=>$data['2'],"pass"=>$data['3'],));
           json_encode(array("result"=>$resarr));

        }else{
            //incorrect password
            echo "false";
        }
    }else{
        //Account doesn't exist, create a new account
        echo "Dont have an account";
    }
?>