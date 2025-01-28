-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Gegenereerd op: 28 jan 2025 om 19:44
-- Serverversie: 10.4.28-MariaDB
-- PHP-versie: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `swapfoods`
--

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `categories`
--

CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `categories`
--

INSERT INTO `categories` (`category_id`, `name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'Zuivel', 'Melk, yoghurt, kaas etc.', '2025-01-28 16:29:14', '2025-01-28 16:29:14'),
(2, 'Groenten', 'Verse groenten', '2025-01-28 16:29:14', '2025-01-28 16:29:14'),
(3, 'Fruit', 'Vers fruit', '2025-01-28 16:29:14', '2025-01-28 16:29:14'),
(4, 'Vlees', 'Vlees en gevogelte', '2025-01-28 16:29:14', '2025-01-28 16:29:14'),
(5, 'Overig', 'Overige producten', '2025-01-28 16:29:14', '2025-01-28 16:29:14');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `containers`
--

CREATE TABLE `containers` (
  `container_id` int(11) NOT NULL,
  `location` varchar(255) NOT NULL,
  `qr_code` varchar(255) NOT NULL,
  `is_unlocked` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Gegevens worden geëxporteerd voor tabel `containers`
--

INSERT INTO `containers` (`container_id`, `location`, `qr_code`, `is_unlocked`, `created_at`, `updated_at`) VALUES
(1, 'vlashoflaan 121', 'de00cee2-dd95-11ef-8a58-d880838b7424', 0, '2025-01-28 16:35:21', '2025-01-28 16:35:21');

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `items`
--

CREATE TABLE `items` (
  `item_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `expiry_day` tinyint(4) NOT NULL,
  `expiry_month` tinyint(4) NOT NULL,
  `expiry_year` smallint(6) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `notes` text DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1
) ;

--
-- Gegevens worden geëxporteerd voor tabel `items`
--

INSERT INTO `items` (`item_id`, `name`, `category_id`, `expiry_day`, `expiry_month`, `expiry_year`, `created_at`, `updated_at`, `notes`, `is_active`) VALUES
(1, 'Halfvolle melk', 1, 15, 2, 2024, '2025-01-28 16:29:14', '2025-01-28 16:29:14', 'Geopend op 08-02', 1),
(2, 'Spinazie', 2, 10, 2, 2024, '2025-01-28 16:29:14', '2025-01-28 16:29:14', NULL, 1),
(3, 'Kipfilet', 4, 12, 2, 2024, '2025-01-28 16:29:14', '2025-01-28 16:29:14', 'In vriezer', 1),
(4, 'kaas', NULL, 23, 8, 2025, '2025-01-28 16:35:12', '2025-01-28 16:35:12', 'Ingestuurd door farhan2005231@gmail.com', 1);

--
-- Triggers `items`
--
DELIMITER $$
CREATE TRIGGER `update_items_timestamp` BEFORE UPDATE ON `items` FOR EACH ROW BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structuur voor view `near_expiry_items`
-- (Zie onder voor de actuele view)
--
CREATE TABLE `near_expiry_items` (
`item_id` int(11)
,`name` varchar(100)
,`category` varchar(50)
,`expiry_day` tinyint(4)
,`expiry_month` tinyint(4)
,`expiry_year` smallint(6)
);

-- --------------------------------------------------------

--
-- Tabelstructuur voor tabel `scans`
--

CREATE TABLE `scans` (
  `scan_id` int(11) NOT NULL,
  `container_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `scanned_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structuur voor de view `near_expiry_items`
--
DROP TABLE IF EXISTS `near_expiry_items`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `near_expiry_items`  AS SELECT `i`.`item_id` AS `item_id`, `i`.`name` AS `name`, `c`.`name` AS `category`, `i`.`expiry_day` AS `expiry_day`, `i`.`expiry_month` AS `expiry_month`, `i`.`expiry_year` AS `expiry_year` FROM (`items` `i` left join `categories` `c` on(`i`.`category_id` = `c`.`category_id`)) WHERE cast(concat(`i`.`expiry_year`,'-',lpad(`i`.`expiry_month`,2,'0'),'-',lpad(`i`.`expiry_day`,2,'0')) as date) <= cast(current_timestamp() + interval 7 day as date) AND `i`.`is_active` = 1 ;

--
-- Indexen voor geëxporteerde tabellen
--

--
-- Indexen voor tabel `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Indexen voor tabel `containers`
--
ALTER TABLE `containers`
  ADD PRIMARY KEY (`container_id`),
  ADD UNIQUE KEY `qr_code` (`qr_code`);

--
-- Indexen voor tabel `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `idx_items_expiry` (`expiry_year`,`expiry_month`,`expiry_day`),
  ADD KEY `idx_items_name` (`name`);

--
-- Indexen voor tabel `scans`
--
ALTER TABLE `scans`
  ADD PRIMARY KEY (`scan_id`),
  ADD KEY `container_id` (`container_id`);

--
-- AUTO_INCREMENT voor geëxporteerde tabellen
--

--
-- AUTO_INCREMENT voor een tabel `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT voor een tabel `containers`
--
ALTER TABLE `containers`
  MODIFY `container_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT voor een tabel `items`
--
ALTER TABLE `items`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT voor een tabel `scans`
--
ALTER TABLE `scans`
  MODIFY `scan_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Beperkingen voor geëxporteerde tabellen
--

--
-- Beperkingen voor tabel `items`
--
ALTER TABLE `items`
  ADD CONSTRAINT `items_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`);

--
-- Beperkingen voor tabel `scans`
--
ALTER TABLE `scans`
  ADD CONSTRAINT `scans_ibfk_1` FOREIGN KEY (`container_id`) REFERENCES `containers` (`container_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
