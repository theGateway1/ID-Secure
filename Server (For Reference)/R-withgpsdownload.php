<?php
    $db = mysqli_connect('localhost','root','','withgpsuserdata');
    if(mysqli_connect_error())
        echo "Connection Error.";
    $imgwithloc = $db->query("SELECT * FROM mytable");
    $list = array();

    while($rowdata = $imgwithloc->fetch_assoc()) {
        $list[] = $rowdata;
    }

    echo json_encode($list);
?>
