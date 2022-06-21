<?php

class DBOperations
{
    private $conn;

    //Constructor
    function __construct()
    {
        require_once dirname(__FILE__) . '/Config.php';
        require_once dirname(__FILE__) . '/DBConnect.php';

        $db = new DBConnect();
        $this->conn = $db->connect();
    }

    public function createEvent($Name, $Place, $StartDate, $EndDate)
    {
        $stmt = $this->conn->prepare("INSERT INTO Event (Name, Place, StartDate, EndDate)
        VALUES (?, ?, ?, ?)");
        $stmt->bind_param("ssss", $Name, $Place, $StartDate, $EndDate);
        $result = $stmt->execute();
        $stmt->close();
        if ($result) {
            return true;
        } else {
            return false;
        }
    }

    public function getEvents()
    {
        $sql = "SELECT * FROM Event";
        $result = $this->conn->query($sql);

        return $result;
    }

    public function updateEvent($ID, $Name, $Place, $StartDate, $EndDate)
    {
        $stmt = $this->conn->prepare("UPDATE Event SET Name=?, Place=?, StartDate=?, EndDate=? WHERE ID=?");
        $stmt->bind_param("ssssi", $Name, $Place, $StartDate, $EndDate, $ID);
        $result = $stmt->execute();
        $stmt->close();
        if ($result) {
            return true;
        } else {
            return false;
        }
    }

    public function deleteEvent($ID)
    {
        $stmt = $this->conn->prepare("DELETE FROM Event WHERE ID=?");
        $stmt->bind_param("i", $ID);
        $result = $stmt->execute();
        $stmt->close();
        if ($result) {
            return true;
        } else {
            return false;
        }
    }

}

?>