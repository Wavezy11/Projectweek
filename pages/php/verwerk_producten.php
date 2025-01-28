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
    $product = $conn->real_escape_string($_POST['product']);
    $expiry_date = $conn->real_escape_string($_POST['expiry_date']);
    $email = $conn->real_escape_string($_POST['email']);

    $sql = "INSERT INTO producten (product, houdbaarheidsdatum, email) VALUES ('$product', '$expiry_date', '$email')";

    if ($conn->query($sql) === TRUE) {
        echo "Product succesvol toegevoegd!";
    } else {
        echo "Fout: " . $conn->error;
    }
}

$conn->close();
?>
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
