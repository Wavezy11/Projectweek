<?php
require 'vendor/autoload.php';

$dotenv = Dotenv\Dotenv::createImmutable(__DIR__);
$dotenv->load();
?>
<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SwapFood - Map</title>
    <link rel="stylesheet" href="style.css">
    <script src="https://maps.googleapis.com/maps/api/js?key=<?php echo getenv('GOOGLE_MAPS_API_KEY'); ?>&callback=initMap" async defer></script>
    <script>
        let map;
        let marker;

        function initMap() {
            // Start coördinaten voor de kaart
            const defaultLocation = { lat: 	51.57226945, lng: 5.078896742231183 }; // Coördinaten voor Rotterdam
            map = new google.maps.Map(document.getElementById("map"), {
                center: defaultLocation,
                zoom: 12,
            });
            marker = new google.maps.Marker({
                position: defaultLocation,
                map: map,
                title: 'Locatie',
            });
        }

        function searchLocation() {
            const input = document.querySelector('input[name="location"]');
            const geocoder = new google.maps.Geocoder();

            geocoder.geocode({ 'address': input.value }, (results, status) => {
                if (status === 'OK') {
                    map.setCenter(results[0].geometry.location);
                    marker.setPosition(results[0].geometry.location); // Verplaats marker naar de nieuwe locatie
                    marker.setMap(map); // Zorg ervoor dat de marker zichtbaar is
                } else {
                    alert('Locatie niet gevonden: ' + status);
                }
            });
        }
    </script>
</head>
<body>
    <header>
        <img src="logo zwart wit.png" alt="SwapFood Logo" class="logo">
        <h1>SwapFood Containers</h1>
        <nav>
            <a href="index.html">Home</a>
            <a href="producten.html">Producten</a>
            <a href="map.html">Map</a>
        </nav>
    </header>
    <main>
        <section class="container">
            <h2>Vind een Container</h2>
            <form action="verwerk_map.php" method="POST" onsubmit="searchLocation(); return false;">
                <input type="text" name="location" class="input-field" placeholder="Voer locatie in" required>
                <button type="submit">Zoeken</button>
            </form>
            <div id="map" style="width: 100%; height: 400px;"></div> <!-- Kaartweergave -->
        </section>
    </main>
 
</body>
</html>
