<?php

$response = array();

if($_SERVER['REQUEST_METHOD']=='POST')
{
    $Name = $_POST['name'];
    $Place = $_POST['place'];
    $StartDate = $_POST['startDate'];
    $EndDate = $_POST['endDate'];

    require_once '../include/DBOperations.php';

    $db = new DBOperations();

    if($db->createEvent($Name,$Place,$StartDate,$EndDate))
    {
        $response['error']=false;
        $response['message']='Event added successfully';
    }
    else
    {
        $response['error']=true;
        $response['message']='Could not add event';
    }
}
else
{
    $response['error']=true;
    $response['message']='You are not authorized';
}
echo json_encode($response);

?>