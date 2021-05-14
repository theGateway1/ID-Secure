<?php
$db = mysqli_connect('localhost','root','','userdata');

    $image[] = $_FILES['image']['name'];
    $tmpFile[] = $_FILES['image']['tmp_name'];
        
    foreach ($image as $key => $value) {
        foreach ($tmpFile as $key => $tmpFilevalue) {
            if(move_uploaded_file($tmpFilevalue, 'img/'.$value)){
                $save = $db->query("INSERT INTO dynamic(image)VALUES('".$value."')");
                if($save) {
                    echo json_encode(array("message"=>"Success"));
                }else{
                    echo json_encode(array("message"=>"Error ".mysqli_error($db)));
                }
            }
        }
    }
?>