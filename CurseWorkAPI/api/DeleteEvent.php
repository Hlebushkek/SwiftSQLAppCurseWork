<?php

$response = array();

if($_SERVER['REQUEST_METHOD']=='POST')
{
    $ID = $_POST['id'];

    require_once '../include/DBOperations.php';

    $db = new DBOperations();

    if($db->deleteEvent($ID))
    {
        $response['error']=false;
        $response['message']='Delete event successfully';
    }
    else
    {
        $response['error']=true;
        $response['message']='Could not delete event';
    }
}
else
{
    $response['error']=true;
    $response['message']='You are not authorized';
}
echo json_encode($response);

?>