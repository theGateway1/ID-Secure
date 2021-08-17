<?php
$db = mysqli_connect('localhost','mohit','12345678','withgpsuserdata');
if(mysqli_connect_error())
{
    echo "Connection Error.";
}
    $image = $_POST['image'];
    $latitude = $_POST['latitude'];
    $longitude = $_POST['longitude'];
    $date = $_POST['date'];
    $time = $_POST['time'];
    $downImageUrl = $_POST['downurl'];

    $save = $db->query("INSERT INTO mytable(image,latitude,longitude,date,time,downurl) VALUES('".$image."','".$latitude."','".$longitude."','".$date."','".$time."','".$downImageUrl."')");
    if($save) {
        echo json_encode(array("message"=>"Success"));
    }else{
        echo json_encode(array("message"=>"Error ".mysqli_error($db)));
    }
    
?>