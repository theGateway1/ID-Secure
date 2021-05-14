<?php
    $db = mysqli_connect('localhost','root','','withgpsuserdata');
    $imgwithloc = $db->query("SELECT * FROM mytable");
    $list = array();

    while($rowdata = $imgwithloc->fetch_assoc()) {
        $list[] = $rowdata;
    }

    echo json_encode($list);
?>