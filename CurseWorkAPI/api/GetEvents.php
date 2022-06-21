<?php

$response = array();

if($_SERVER['REQUEST_METHOD']=='GET'){

    require_once '../include/DBOperations.php';

    $db = new DBOperations();

    $events = $db->getEvents();

    $eventsJsonArray = array();
    header("Content-Type: application/json");
    while($row = $events->fetch_assoc()) {
        array_push($eventsJsonArray, $row);
    }
    
    echo json_encode($eventsJsonArray);
}
else
{
    $response['error']=true;
    $response['message']='You are not authorized';
}