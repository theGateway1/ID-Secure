<?php
$db = mysqli_connect('localhost','root','12345678','withgpsuserdata');
if(mysqli_connect_error())
{
    echo "Connection Error.";
}
    $image[] = $_FILES['image']['name'];
    $tmpFile[] = $_FILES['image']['tmp_name'];
    $latitude = $_POST['latitude'];
    $longitude = $_POST['longitude'];
    $imageDetails = $_POST['date'];
    $time = $_POST['time'];
    $firebaseImage = $_POST['downurl'];
    
    foreach ($image as $key => $value) {
        foreach ($tmpFile as $key => $tmpFilevalue) {
            if(move_uploaded_file($tmpFilevalue, 'img/'.$value)){
                $save = $db->query("INSERT INTO mytable(image,latitude,longitude,date,time,downurl) VALUES('".$value."','".$latitude."','".$longitude."','".$imageDetails."','".$time."','".$firebaseImage."')");
                if($save) {
                    echo json_encode(array("message"=>"Success"));
                }else{
                    echo json_encode(array("message"=>"Error ".mysqli_error($db)));
                }
            }
        }
    }
?>