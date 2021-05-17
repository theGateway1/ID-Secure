<?php
$db = mysqli_connect('localhost','root','','withgpsuserdata');
if(mysqli_connect_error())
{
    echo "Connection Error.";
}
    $image[] = $_FILES['image']['name'];
    $tmpFile[] = $_FILES['image']['tmp_name'];
    $latitude = $_POST['latitude'];
    $longitude = $_POST['longitude'];
    
    
    foreach ($image as $key => $value) {
        foreach ($tmpFile as $key => $tmpFilevalue) {
            if(move_uploaded_file($tmpFilevalue, 'img/'.$value)){
                $save = $db->query("INSERT INTO mytable(image,latitude,longitude) VALUES('".$value."','".$latitude."','".$longitude."')");
                if($save) {
                    echo json_encode(array("message"=>"Success"));
                }else{
                    echo json_encode(array("message"=>"Error ".mysqli_error($db)));
                }
            }
        }
    }
?>