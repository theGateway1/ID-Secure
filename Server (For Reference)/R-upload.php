<?php
$db = mysqli_connect('localhost','root','','withgpsuserdata');

    $image[] = $_FILES['image']['name'];
    $tmpFile[] = $_FILES['image']['tmp_name'];
    $gpslocation = $_POST['userlocation'];
        
    foreach ($image as $key => $value) {
        foreach ($tmpFile as $key => $tmpFilevalue) {
            if(move_uploaded_file($tmpFilevalue, 'img/'.$value)){
                $save = $db->query("INSERT INTO mytable(image,gpslocation) VALUES('".$value."','".$gpslocation."')");
                if($save) {
                    echo json_encode(array("message"=>"Success"));
                }else{
                    echo json_encode(array("message"=>"Error ".mysqli_error($db)));
                }
            }
        }
    }
?>