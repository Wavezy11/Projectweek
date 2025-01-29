<?php
$host = "localhost";
$user = "root";
$password = "";
$dbname = "swapfoods";

$conn = new mysqli($host, $user, $password, $dbname);

if ($conn->connect_error) {
    die("Verbinding mislukt: " . $conn->connect_error);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $location = $conn->real_escape_string($_POST['location']);

    $sql = "INSERT INTO locaties (locatie) VALUES ('$location')";

    if ($conn->query($sql) === TRUE) {
        echo "Locatie succesvol toegevoegd!";
    } else {
        echo "Fout: " . $conn->error;
    }
}

$conn->close();
?>
