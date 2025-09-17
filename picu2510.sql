-- phpMyAdmin SQL Dump
-- version 4.9.11
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Czas generowania: 16 Wrz 2025, 23:30
-- Wersja serwera: 10.5.29-MariaDB-0+deb11u1
-- Wersja PHP: 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `picu2510`
--

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `audit_log`
--

CREATE TABLE `audit_log` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `table_name` varchar(64) NOT NULL,
  `record_id` bigint(20) DEFAULT NULL,
  `action` enum('insert','update','delete') NOT NULL,
  `before_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`before_json`)),
  `after_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`after_json`)),
  `ip` varchar(45) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `route` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Zrzut danych tabeli `audit_log`
--

INSERT INTO `audit_log` (`id`, `created_at`, `user_id`, `table_name`, `record_id`, `action`, `before_json`, `after_json`, `ip`, `user_agent`, `route`) VALUES
(1, '2025-08-28 23:01:18', 1, 'cmms_slownik_typ_zasobu', 3, 'update', NULL, '{\"id\":3,\"key\":\"asset.vehicle\",\"nazwa\":\"Pojazd\",\"opis\":\"Flota pojazdów.\",\"ikona\":\"🚚\",\"kolor\":\"#F59E0B\",\"sort_order\":30,\"aktywny\":1,\"is_system\":0,\"created_by\":null,\"updated_by\":1,\"created_at\":\"2025-08-28 21:46:12\",\"updated_at\":\"2025-08-28 23:01:18\"}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/konfiguracja/typ_zasobu/edit.php?id=3'),
(2, '2025-08-29 09:10:56', 1, 'cmms_struktura', 7, '', NULL, '{\"id\":7,\"nazwa\":\"Budynek\",\"parent_id\":1,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":1,\"aktywny\":1}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/edit.php?parent_id=1'),
(3, '2025-08-29 09:11:54', 1, 'cmms_struktura', 8, '', NULL, '{\"id\":8,\"nazwa\":\"Linia\",\"parent_id\":7,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":1,\"aktywny\":1}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/edit.php?parent_id=7'),
(4, '2025-08-29 09:13:11', 1, 'cmms_struktura', 9, '', NULL, '{\"id\":9,\"nazwa\":\"Urządzenie 1\",\"parent_id\":8,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":1,\"aktywny\":1}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/edit.php?parent_id=8'),
(5, '2025-08-29 09:13:21', 1, 'cmms_struktura', 10, '', NULL, '{\"id\":10,\"nazwa\":\"Urządzenie 2\",\"parent_id\":8,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":1,\"aktywny\":1}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/edit.php?parent_id=8'),
(6, '2025-08-29 09:14:26', 1, 'cmms_struktura', 10, 'delete', '{\"id\":10,\"parent_id\":8,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":1,\"id_element\":null,\"key\":null,\"nazwa\":\"Urządzenie 2\",\"opis\":null,\"ikona\":null,\"kolor\":null,\"sort_order\":0,\"aktywny\":1,\"is_system\":0,\"depth\":3,\"path\":\"/ROOT/7/8/10\",\"created_by\":1,\"updated_by\":1,\"created_at\":\"2025-08-29 09:13:21\",\"updated_at\":\"2025-08-29 09:13:21\"}', NULL, '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/delete.php'),
(7, '2025-08-29 09:14:38', 1, 'cmms_struktura', 11, '', NULL, '{\"id\":11,\"nazwa\":\"Urządzenie 2\",\"parent_id\":8,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":1,\"aktywny\":1}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/edit.php?parent_id=8'),
(8, '2025-08-29 11:19:19', 1, 'cmms_struktura', 7, 'update', '{\"id\":7,\"parent_id\":1,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":1,\"id_element\":null,\"key\":null,\"nazwa\":\"Budynek\",\"opis\":null,\"ikona\":null,\"kolor\":null,\"sort_order\":0,\"aktywny\":1,\"is_system\":0,\"depth\":1,\"path\":\"/ROOT/7\",\"created_by\":1,\"updated_by\":1,\"created_at\":\"2025-08-29 09:10:56\",\"updated_at\":\"2025-08-29 09:10:56\"}', '{\"nazwa\":\"Budynek produkcyjny\",\"parent_id\":1,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":1,\"aktywny\":1}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?id=7'),
(9, '2025-08-30 15:34:02', 1, 'cmms_struktura', 17, '', NULL, '{\"nazwa\":\"Dozownica\",\"parent_id\":1,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":1,\"aktywny\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php'),
(10, '2025-08-30 15:34:29', 1, 'cmms_struktura', 18, '', NULL, '{\"nazwa\":\"Etykieciarka\",\"parent_id\":null,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":1,\"aktywny\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php'),
(11, '2025-08-30 19:37:55', 1, 'cmms_struktura', 7, 'update', '{\"id\":7,\"parent_id\":null,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":1,\"id_element\":null,\"key\":null,\"nazwa\":\"Budynek produkcyjny\",\"opis\":null,\"ikona\":null,\"kolor\":null,\"sort_order\":2,\"aktywny\":1,\"is_system\":0,\"depth\":0,\"path\":\"/7\",\"created_by\":1,\"updated_by\":1,\"created_at\":\"2025-08-29 09:10:56\",\"updated_at\":\"2025-08-30 19:22:01\"}', '{\"nazwa\":\"Budynek produkcyjny\",\"parent_id\":null,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":4,\"aktywny\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?id=7'),
(12, '2025-08-30 19:38:07', 1, 'cmms_struktura', 8, 'update', '{\"id\":8,\"parent_id\":7,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":1,\"id_element\":null,\"key\":null,\"nazwa\":\"Linia\",\"opis\":null,\"ikona\":null,\"kolor\":null,\"sort_order\":2,\"aktywny\":1,\"is_system\":0,\"depth\":1,\"path\":\"/7/8\",\"created_by\":1,\"updated_by\":1,\"created_at\":\"2025-08-29 09:11:54\",\"updated_at\":\"2025-08-30 19:37:55\"}', '{\"nazwa\":\"Linia\",\"parent_id\":7,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":5,\"aktywny\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?id=8'),
(13, '2025-08-30 19:38:38', 1, 'cmms_struktura', 18, 'update', '{\"id\":18,\"parent_id\":8,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":1,\"id_element\":null,\"key\":null,\"nazwa\":\"Etykieciarka\",\"opis\":null,\"ikona\":null,\"kolor\":null,\"sort_order\":1,\"aktywny\":1,\"is_system\":0,\"depth\":2,\"path\":\"/7/8/18\",\"created_by\":1,\"updated_by\":1,\"created_at\":\"2025-08-30 15:34:29\",\"updated_at\":\"2025-08-30 19:38:07\"}', '{\"nazwa\":\"Etykieciarka\",\"parent_id\":8,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":6,\"aktywny\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?id=18'),
(14, '2025-08-30 19:38:44', 1, 'cmms_struktura', 17, 'update', '{\"id\":17,\"parent_id\":8,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":1,\"id_element\":null,\"key\":null,\"nazwa\":\"Dozownica\",\"opis\":null,\"ikona\":null,\"kolor\":null,\"sort_order\":2,\"aktywny\":1,\"is_system\":0,\"depth\":2,\"path\":\"/7/8/17\",\"created_by\":1,\"updated_by\":1,\"created_at\":\"2025-08-30 15:34:02\",\"updated_at\":\"2025-08-30 19:38:38\"}', '{\"nazwa\":\"Dozownica\",\"parent_id\":8,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":6,\"aktywny\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?id=17'),
(15, '2025-08-30 19:38:49', 1, 'cmms_struktura', 11, 'update', '{\"id\":11,\"parent_id\":9,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":1,\"id_element\":null,\"key\":null,\"nazwa\":\"Urządzenie 2\",\"opis\":null,\"ikona\":null,\"kolor\":null,\"sort_order\":1,\"aktywny\":1,\"is_system\":0,\"depth\":2,\"path\":\"/7/9/11\",\"created_by\":1,\"updated_by\":1,\"created_at\":\"2025-08-29 09:14:38\",\"updated_at\":\"2025-08-30 19:38:44\"}', '{\"nazwa\":\"Urządzenie 2\",\"parent_id\":9,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":6,\"aktywny\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?id=11'),
(16, '2025-08-30 19:38:54', 1, 'cmms_struktura', 9, 'update', '{\"id\":9,\"parent_id\":7,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":1,\"id_element\":null,\"key\":null,\"nazwa\":\"Urządzenie 1\",\"opis\":null,\"ikona\":null,\"kolor\":null,\"sort_order\":1,\"aktywny\":1,\"is_system\":0,\"depth\":1,\"path\":\"/7/9\",\"created_by\":1,\"updated_by\":1,\"created_at\":\"2025-08-29 09:13:11\",\"updated_at\":\"2025-08-30 19:38:49\"}', '{\"nazwa\":\"Urządzenie 1\",\"parent_id\":7,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":6,\"aktywny\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?id=9'),
(17, '2025-08-30 19:39:27', 1, 'cmms_slownik_typ_zasobu', 1, 'update', '{\"id\":1,\"key\":null,\"mpk\":\"PL321P1121\",\"nazwa\":\"Linia syropowa\",\"opis\":\"butelki szklane\",\"ikona\":null,\"kolor\":\"#06D6E5\",\"sort_order\":0,\"aktywny\":1,\"is_system\":0,\"created_by\":1,\"updated_by\":1,\"created_at\":\"2025-08-28 22:20:21\",\"updated_at\":\"2025-08-28 22:49:47\"}', '{\"id\":1,\"key\":\"asset.machine\",\"nazwa\":\"Maszyna etykietująca\",\"opis\":\"Urządzenia produkcyjne\",\"ikona\":\"🛠\",\"kolor\":\"#0EA5E9\",\"sort_order\":10,\"aktywny\":1,\"is_system\":0,\"created_by\":null,\"updated_by\":1,\"created_at\":\"2025-08-28 21:46:12\",\"updated_at\":\"2025-08-30 19:39:26\"}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/konfiguracja/typ_zasobu/edit.php?id=1'),
(18, '2025-08-30 19:39:37', 1, 'cmms_slownik_typ_zasobu', 2, 'update', NULL, '{\"id\":2,\"key\":\"asset.tool\",\"nazwa\":\"Maszyna rozlewająca\",\"opis\":\"Narzędzia ręczne\",\"ikona\":\"🧰\",\"kolor\":\"#22C55E\",\"sort_order\":20,\"aktywny\":1,\"is_system\":0,\"created_by\":null,\"updated_by\":1,\"created_at\":\"2025-08-28 21:46:12\",\"updated_at\":\"2025-08-30 19:39:37\"}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/konfiguracja/typ_zasobu/edit.php?id=2'),
(19, '2025-08-30 19:39:45', 1, 'cmms_slownik_typ_zasobu', 3, 'update', NULL, '{\"id\":3,\"key\":\"asset.vehicle\",\"nazwa\":\"Maszyna pakująca\",\"opis\":\"Flota pojazdów.\",\"ikona\":\"🚚\",\"kolor\":\"#F59E0B\",\"sort_order\":30,\"aktywny\":1,\"is_system\":0,\"created_by\":null,\"updated_by\":1,\"created_at\":\"2025-08-28 21:46:12\",\"updated_at\":\"2025-08-30 19:39:44\"}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/konfiguracja/typ_zasobu/edit.php?id=3'),
(20, '2025-08-30 19:39:57', 1, 'cmms_struktura', 18, 'update', '{\"id\":18,\"parent_id\":8,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":6,\"id_element\":null,\"key\":null,\"nazwa\":\"Etykieciarka\",\"opis\":null,\"ikona\":null,\"kolor\":null,\"sort_order\":1,\"aktywny\":1,\"is_system\":0,\"depth\":2,\"path\":\"/7/8/18\",\"created_by\":1,\"updated_by\":1,\"created_at\":\"2025-08-30 15:34:29\",\"updated_at\":\"2025-08-30 19:38:54\"}', '{\"nazwa\":\"Etykieciarka\",\"parent_id\":8,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":6,\"aktywny\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?id=18'),
(21, '2025-08-30 19:40:04', 1, 'cmms_struktura', 17, 'update', '{\"id\":17,\"parent_id\":8,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":6,\"id_element\":null,\"key\":null,\"nazwa\":\"Dozownica\",\"opis\":null,\"ikona\":null,\"kolor\":null,\"sort_order\":2,\"aktywny\":1,\"is_system\":0,\"depth\":2,\"path\":\"/7/8/17\",\"created_by\":1,\"updated_by\":1,\"created_at\":\"2025-08-30 15:34:02\",\"updated_at\":\"2025-08-30 19:39:57\"}', '{\"nazwa\":\"Dozownica\",\"parent_id\":8,\"typ_zasobu_id\":2,\"mpk_linia_id\":1,\"element_id\":6,\"aktywny\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?id=17'),
(22, '2025-08-30 19:40:09', 1, 'cmms_struktura', 11, 'update', '{\"id\":11,\"parent_id\":9,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":6,\"id_element\":null,\"key\":null,\"nazwa\":\"Urządzenie 2\",\"opis\":null,\"ikona\":null,\"kolor\":null,\"sort_order\":1,\"aktywny\":1,\"is_system\":0,\"depth\":2,\"path\":\"/7/9/11\",\"created_by\":1,\"updated_by\":1,\"created_at\":\"2025-08-29 09:14:38\",\"updated_at\":\"2025-08-30 19:40:04\"}', '{\"nazwa\":\"Urządzenie 2\",\"parent_id\":9,\"typ_zasobu_id\":3,\"mpk_linia_id\":1,\"element_id\":6,\"aktywny\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?id=11'),
(23, '2025-08-30 19:40:14', 1, 'cmms_struktura', 9, 'update', '{\"id\":9,\"parent_id\":7,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":6,\"id_element\":null,\"key\":null,\"nazwa\":\"Urządzenie 1\",\"opis\":null,\"ikona\":null,\"kolor\":null,\"sort_order\":1,\"aktywny\":1,\"is_system\":0,\"depth\":1,\"path\":\"/7/9\",\"created_by\":1,\"updated_by\":1,\"created_at\":\"2025-08-29 09:13:11\",\"updated_at\":\"2025-08-30 19:40:09\"}', '{\"nazwa\":\"Urządzenie 1\",\"parent_id\":7,\"typ_zasobu_id\":3,\"mpk_linia_id\":1,\"element_id\":6,\"aktywny\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?id=9'),
(24, '2025-08-30 19:40:23', 1, 'cmms_struktura', 8, 'update', '{\"id\":8,\"parent_id\":7,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":5,\"id_element\":null,\"key\":null,\"nazwa\":\"Linia\",\"opis\":null,\"ikona\":null,\"kolor\":null,\"sort_order\":2,\"aktywny\":1,\"is_system\":0,\"depth\":1,\"path\":\"/7/8\",\"created_by\":1,\"updated_by\":1,\"created_at\":\"2025-08-29 09:11:54\",\"updated_at\":\"2025-08-30 19:40:14\"}', '{\"nazwa\":\"Linia\",\"parent_id\":7,\"typ_zasobu_id\":null,\"mpk_linia_id\":1,\"element_id\":5,\"aktywny\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?id=8'),
(25, '2025-08-30 21:15:01', 1, 'cmms.struktura', 0, '', '{\"parent_id\":7,\"sort_order\":2}', '{\"parent_id\":7,\"sort_order\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(26, '2025-08-30 21:15:01', 1, 'cmms.struktura', 0, '', '{\"parent_id\":7,\"sort_order\":1}', '{\"parent_id\":18,\"sort_order\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(27, '2025-08-30 21:15:09', 1, 'cmms.struktura', 0, '', '{\"parent_id\":9,\"sort_order\":1}', '{\"parent_id\":18,\"sort_order\":2}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(28, '2025-09-01 13:44:49', 1, 'cmms.struktura', 0, '', '{\"parent_id\":18,\"sort_order\":1}', '{\"parent_id\":8,\"sort_order\":1}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(29, '2025-09-01 13:44:49', 1, 'cmms.struktura', 0, '', '{\"parent_id\":8,\"sort_order\":1}', '{\"parent_id\":8,\"sort_order\":2}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(30, '2025-09-01 13:44:49', 1, 'cmms.struktura', 0, '', '{\"parent_id\":8,\"sort_order\":2}', '{\"parent_id\":8,\"sort_order\":3}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(31, '2025-09-01 13:44:53', 1, 'cmms.struktura', 0, '', '{\"parent_id\":8,\"sort_order\":2}', '{\"parent_id\":8,\"sort_order\":1}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(32, '2025-09-01 13:44:53', 1, 'cmms.struktura', 0, '', '{\"parent_id\":8,\"sort_order\":1}', '{\"parent_id\":18,\"sort_order\":1}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(33, '2025-09-01 13:44:53', 1, 'cmms.struktura', 0, '', '{\"parent_id\":8,\"sort_order\":3}', '{\"parent_id\":8,\"sort_order\":2}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(34, '2025-09-01 13:44:55', 1, 'cmms.struktura', 0, '', '{\"parent_id\":8,\"sort_order\":2}', '{\"parent_id\":7,\"sort_order\":2}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(35, '2025-09-01 13:44:58', 1, 'cmms.struktura', 0, '', '{\"parent_id\":7,\"sort_order\":2}', '{\"parent_id\":8,\"sort_order\":2}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(36, '2025-09-01 13:46:09', 1, 'cmms.struktura', 0, '', '{\"parent_id\":null,\"sort_order\":2}', '{\"parent_id\":1,\"sort_order\":1}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(37, '2025-09-01 13:46:18', 1, 'cmms.struktura', 0, '', '{\"parent_id\":7,\"sort_order\":1}', '{\"parent_id\":1,\"sort_order\":2}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(38, '2025-09-01 13:46:19', 1, 'cmms.struktura', 0, '', '{\"parent_id\":1,\"sort_order\":2}', '{\"parent_id\":7,\"sort_order\":1}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(39, '2025-09-01 13:46:26', 1, 'cmms.struktura', 0, '', '{\"parent_id\":8,\"sort_order\":2}', '{\"parent_id\":8,\"sort_order\":1}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(40, '2025-09-01 13:46:26', 1, 'cmms.struktura', 0, '', '{\"parent_id\":8,\"sort_order\":1}', '{\"parent_id\":8,\"sort_order\":2}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(41, '2025-09-01 19:53:53', 1, 'cmms_struktura', 19, '', NULL, '{\"nazwa\":\"Obszar kuchni\",\"parent_id\":8,\"typ_zasobu_id\":3,\"mpk_linia_id\":2,\"element_id\":5,\"aktywny\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?parent_id=8'),
(42, '2025-09-01 19:56:17', 1, 'cmms_slownik_typ_zasobu', 1, 'update', '{\"id\":1,\"key\":null,\"mpk\":\"PL321P1121\",\"nazwa\":\"Linia syropowa\",\"opis\":\"butelki szklane\",\"ikona\":null,\"kolor\":\"#06D6E5\",\"sort_order\":0,\"aktywny\":1,\"is_system\":0,\"created_by\":1,\"updated_by\":1,\"created_at\":\"2025-08-28 22:20:21\",\"updated_at\":\"2025-08-28 22:49:47\"}', '{\"id\":1,\"key\":\"asset.machine\",\"nazwa\":\"Kuchnia\",\"opis\":null,\"ikona\":\"🛠\",\"kolor\":\"#E70D0D\",\"sort_order\":10,\"aktywny\":1,\"is_system\":0,\"created_by\":null,\"updated_by\":1,\"created_at\":\"2025-08-28 21:46:12\",\"updated_at\":\"2025-09-01 19:56:17\"}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/konfiguracja/typ_zasobu/edit.php?id=1'),
(43, '2025-09-01 19:56:43', 1, 'cmms_slownik_typ_zasobu', 2, 'update', '{\"id\":2,\"key\":null,\"mpk\":\"PL321P1152\",\"nazwa\":\"Linia dżemowa\",\"opis\":null,\"ikona\":null,\"kolor\":\"#7506E5\",\"sort_order\":0,\"aktywny\":1,\"is_system\":0,\"created_by\":1,\"updated_by\":1,\"created_at\":\"2025-08-30 19:40:56\",\"updated_at\":\"2025-08-30 19:40:56\"}', '{\"id\":2,\"key\":\"asset.tool\",\"nazwa\":\"Depaletyzacja\",\"opis\":null,\"ikona\":\"🧰\",\"kolor\":\"#E29612\",\"sort_order\":20,\"aktywny\":1,\"is_system\":0,\"created_by\":null,\"updated_by\":1,\"created_at\":\"2025-08-28 21:46:12\",\"updated_at\":\"2025-09-01 19:56:43\"}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/konfiguracja/typ_zasobu/edit.php?id=2'),
(44, '2025-09-01 19:57:00', 1, 'cmms_slownik_typ_zasobu', 3, 'update', NULL, '{\"id\":3,\"key\":\"asset.vehicle\",\"nazwa\":\"Myjka\",\"opis\":null,\"ikona\":\"🚚\",\"kolor\":\"#260AF5\",\"sort_order\":30,\"aktywny\":1,\"is_system\":0,\"created_by\":null,\"updated_by\":1,\"created_at\":\"2025-08-28 21:46:12\",\"updated_at\":\"2025-09-01 19:57:00\"}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/konfiguracja/typ_zasobu/edit.php?id=3'),
(45, '2025-09-01 19:57:15', 1, 'cmms_slownik_typ_zasobu', 0, 'insert', NULL, NULL, '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/konfiguracja/typ_zasobu/edit.php'),
(46, '2025-09-01 19:57:30', 1, 'cmms_slownik_typ_zasobu', 0, 'insert', NULL, NULL, '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/konfiguracja/typ_zasobu/edit.php'),
(47, '2025-09-01 19:57:40', 1, 'cmms_struktura', 7, 'update', '{\"id\":7,\"parent_id\":1,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":4,\"id_element\":null,\"key\":null,\"nazwa\":\"Budynek produkcyjny\",\"opis\":null,\"ikona\":null,\"kolor\":null,\"sort_order\":1,\"aktywny\":1,\"is_system\":0,\"depth\":1,\"path\":\"/1/7\",\"created_by\":1,\"updated_by\":1,\"created_at\":\"2025-08-29 09:10:56\",\"updated_at\":\"2025-09-01 13:46:26\"}', '{\"nazwa\":\"Budynek produkcyjny\",\"parent_id\":1,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":4,\"aktywny\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?id=7'),
(48, '2025-09-01 19:57:48', 1, 'cmms_struktura', 8, 'update', '{\"id\":8,\"parent_id\":7,\"typ_zasobu_id\":null,\"mpk_linia_id\":1,\"element_id\":5,\"id_element\":null,\"key\":null,\"nazwa\":\"Linia\",\"opis\":null,\"ikona\":null,\"kolor\":null,\"sort_order\":1,\"aktywny\":1,\"is_system\":0,\"depth\":2,\"path\":\"/1/7/8\",\"created_by\":1,\"updated_by\":1,\"created_at\":\"2025-08-29 09:11:54\",\"updated_at\":\"2025-09-01 19:57:40\"}', '{\"nazwa\":\"Linia\",\"parent_id\":7,\"typ_zasobu_id\":null,\"mpk_linia_id\":1,\"element_id\":5,\"aktywny\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?id=8'),
(49, '2025-09-01 19:57:56', 1, 'cmms_struktura', 19, 'update', '{\"id\":19,\"parent_id\":8,\"typ_zasobu_id\":3,\"mpk_linia_id\":2,\"element_id\":5,\"id_element\":null,\"key\":null,\"nazwa\":\"Obszar kuchni\",\"opis\":null,\"ikona\":null,\"kolor\":null,\"sort_order\":0,\"aktywny\":1,\"is_system\":0,\"depth\":3,\"path\":\"/1/7/8/19\",\"created_by\":1,\"updated_by\":1,\"created_at\":\"2025-09-01 19:53:53\",\"updated_at\":\"2025-09-01 19:57:48\"}', '{\"nazwa\":\"Obszar kuchni\",\"parent_id\":8,\"typ_zasobu_id\":3,\"mpk_linia_id\":2,\"element_id\":7,\"aktywny\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?id=19'),
(50, '2025-09-01 19:58:05', 1, 'cmms.struktura', 0, '', '{\"parent_id\":8,\"sort_order\":0}', '{\"parent_id\":8,\"sort_order\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(51, '2025-09-01 19:58:05', 1, 'cmms.struktura', 0, '', '{\"parent_id\":8,\"sort_order\":1}', '{\"parent_id\":19,\"sort_order\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(52, '2025-09-01 19:58:07', 1, 'cmms.struktura', 0, '', '{\"parent_id\":19,\"sort_order\":1}', '{\"parent_id\":8,\"sort_order\":2}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(53, '2025-09-01 19:58:07', 1, 'cmms.struktura', 0, '', '{\"parent_id\":8,\"sort_order\":2}', '{\"parent_id\":8,\"sort_order\":3}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(54, '2025-09-01 19:58:22', 1, 'cmms_struktura', 20, '', NULL, '{\"nazwa\":\"Obszar dozowania\",\"parent_id\":8,\"typ_zasobu_id\":null,\"mpk_linia_id\":null,\"element_id\":7,\"aktywny\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?parent_id=8'),
(55, '2025-09-01 19:58:29', 1, 'cmms.struktura', 0, '', '{\"parent_id\":8,\"sort_order\":0}', '{\"parent_id\":8,\"sort_order\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(56, '2025-09-01 19:58:29', 1, 'cmms.struktura', 0, '', '{\"parent_id\":8,\"sort_order\":1}', '{\"parent_id\":8,\"sort_order\":2}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(57, '2025-09-01 19:58:29', 1, 'cmms.struktura', 0, '', '{\"parent_id\":8,\"sort_order\":2}', '{\"parent_id\":19,\"sort_order\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(58, '2025-09-01 19:58:47', 1, 'cmms_struktura', 21, '', NULL, '{\"nazwa\":\"Kuchnia\",\"parent_id\":20,\"typ_zasobu_id\":1,\"mpk_linia_id\":null,\"element_id\":6,\"aktywny\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?parent_id=20'),
(59, '2025-09-01 19:58:54', 1, 'cmms.struktura', 0, '', '{\"parent_id\":20,\"sort_order\":0}', '{\"parent_id\":20,\"sort_order\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(60, '2025-09-01 19:58:54', 1, 'cmms.struktura', 0, '', '{\"parent_id\":8,\"sort_order\":3}', '{\"parent_id\":8,\"sort_order\":2}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(61, '2025-09-01 19:58:54', 1, 'cmms.struktura', 0, '', '{\"parent_id\":8,\"sort_order\":2}', '{\"parent_id\":8,\"sort_order\":3}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(62, '2025-09-01 19:58:57', 1, 'cmms.struktura', 0, '', '{\"parent_id\":8,\"sort_order\":3}', '{\"parent_id\":8,\"sort_order\":2}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(63, '2025-09-01 19:58:57', 1, 'cmms.struktura', 0, '', '{\"parent_id\":8,\"sort_order\":2}', '{\"parent_id\":8,\"sort_order\":3}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(64, '2025-09-01 19:59:24', 1, 'cmms_struktura', 22, '', NULL, '{\"nazwa\":\"Obszar etykietowania\",\"parent_id\":8,\"typ_zasobu_id\":null,\"mpk_linia_id\":null,\"element_id\":7,\"aktywny\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?parent_id=8'),
(65, '2025-09-01 19:59:31', 1, 'cmms.struktura', 0, '', '{\"parent_id\":8,\"sort_order\":0}', '{\"parent_id\":8,\"sort_order\":3}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(66, '2025-09-01 19:59:31', 1, 'cmms.struktura', 0, '', '{\"parent_id\":8,\"sort_order\":3}', '{\"parent_id\":8,\"sort_order\":4}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(67, '2025-09-01 19:59:32', 1, 'cmms.struktura', 0, '', '{\"parent_id\":8,\"sort_order\":4}', '{\"parent_id\":22,\"sort_order\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(68, '2025-09-01 20:00:13', 1, 'cmms_struktura', 9, 'update', '{\"id\":9,\"parent_id\":18,\"typ_zasobu_id\":3,\"mpk_linia_id\":1,\"element_id\":6,\"id_element\":null,\"key\":null,\"nazwa\":\"Urządzenie 1\",\"opis\":null,\"ikona\":null,\"kolor\":null,\"sort_order\":1,\"aktywny\":1,\"is_system\":0,\"depth\":5,\"path\":\"/1/7/8/22/18/9\",\"created_by\":1,\"updated_by\":1,\"created_at\":\"2025-08-29 09:13:11\",\"updated_at\":\"2025-09-01 19:59:32\"}', '{\"nazwa\":\"Zamykarka\",\"parent_id\":20,\"typ_zasobu_id\":2,\"mpk_linia_id\":1,\"element_id\":6,\"aktywny\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?id=9'),
(69, '2025-09-01 22:48:53', 1, 'mes_resource_group', 4, '', NULL, '{\"name\":\"test\",\"opis\":\"\",\"aktywny\":0,\"bind_mode\":\"explicit\",\"root_struktura_id\":null}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/edit.php?id=4'),
(70, '2025-09-01 22:50:49', 1, 'mes_resource_group', 4, '', NULL, '{\"name\":\"test\",\"opis\":\"\",\"aktywny\":0,\"bind_mode\":\"explicit\",\"root_struktura_id\":null}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/edit.php?id=4'),
(71, '2025-09-01 22:50:54', 1, 'mes_resource_group', 4, '', NULL, '{\"name\":\"test\",\"opis\":\"\",\"aktywny\":0,\"bind_mode\":\"explicit\",\"root_struktura_id\":null}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/edit.php?id=4'),
(72, '2025-09-01 22:51:05', 1, 'mes_resource_group_item', 4, '', NULL, '{\"struktura_id\":17}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=4'),
(73, '2025-09-01 22:51:41', 1, 'mes_resource_group_item', 4, '', NULL, '{\"struktura_id\":17}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=4'),
(74, '2025-09-01 22:51:46', 1, 'mes_resource_group_item', 4, '', NULL, '{\"struktura_id\":17}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=4&q='),
(75, '2025-09-01 22:51:48', 1, 'mes_resource_group_item', 4, '', NULL, '{\"struktura_id\":17}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=4&q='),
(76, '2025-09-01 22:51:49', 1, 'mes_resource_group_item', 4, '', NULL, '{\"struktura_id\":17}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=4&q='),
(77, '2025-09-01 22:52:29', 1, 'mes_resource_group_item', 4, '', NULL, '{\"struktura_id\":18}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=4&q='),
(78, '2025-09-01 23:53:22', 1, 'mes_resource_group', 0, '', NULL, '{\"name\":null,\"opis\":null,\"aktywny\":null,\"bind_mode\":null,\"root_struktura_id\":null}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/konfiguracja/zasady_przydzialu/edit.php'),
(79, '2025-09-01 23:53:38', 1, 'mes_resource_group', 2, '', '{\"id\":2,\"type_id\":1,\"subtype_id\":1,\"mpk_id\":null,\"structure_id\":17,\"structure_scope\":\"subtree\",\"target_group_id\":1,\"target_user_id\":null,\"assignment_mode\":\"least_busy\",\"priority\":10,\"active\":1,\"valid_from\":null,\"valid_to\":null,\"created_by\":1,\"created_at\":\"2025-09-01 10:28:59\",\"updated_by\":1,\"updated_at\":\"2025-09-01 14:43:27\"}', '{\"name\":null,\"opis\":null,\"aktywny\":null,\"bind_mode\":null,\"root_struktura_id\":null}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/konfiguracja/zasady_przydzialu/edit.php?id=2'),
(80, '2025-09-02 00:00:48', 1, 'mes_resource_group', 7, '', '{\"id\":7,\"type_id\":1,\"subtype_id\":5,\"mpk_id\":null,\"structure_id\":20,\"structure_scope\":\"subtree\",\"target_group_id\":1,\"target_user_id\":null,\"assignment_mode\":\"fixed\",\"priority\":10,\"active\":1,\"valid_from\":null,\"valid_to\":null,\"created_by\":1,\"created_at\":\"2025-09-01 23:53:22\",\"updated_by\":1,\"updated_at\":\"2025-09-01 23:53:22\"}', '{\"name\":null,\"opis\":null,\"aktywny\":null,\"bind_mode\":null,\"root_struktura_id\":null}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/konfiguracja/zasady_przydzialu/edit.php?id=7'),
(81, '2025-09-02 11:59:24', 1, 'mes_resource_group', 2, '', '{\"id\":2,\"type_id\":1,\"subtype_id\":1,\"mpk_id\":null,\"structure_id\":null,\"structure_scope\":\"subtree\",\"target_group_id\":1,\"target_user_id\":null,\"assignment_mode\":\"least_busy\",\"priority\":10,\"active\":1,\"valid_from\":null,\"valid_to\":null,\"created_by\":1,\"created_at\":\"2025-09-01 10:28:59\",\"updated_by\":1,\"updated_at\":\"2025-09-01 23:53:38\"}', '{\"name\":null,\"opis\":null,\"aktywny\":null,\"bind_mode\":null,\"root_struktura_id\":null}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/konfiguracja/zasady_przydzialu/edit.php?id=2'),
(82, '2025-09-03 18:41:35', 1, 'mes_resource_group', 7, '', '{\"id\":7,\"type_id\":2,\"subtype_id\":2,\"mpk_id\":null,\"structure_id\":20,\"structure_scope\":\"subtree\",\"target_group_id\":1,\"mode\":\"round_robin\",\"target_user_id\":null,\"assignment_mode\":\"fixed\",\"priority\":10,\"active\":1,\"valid_from\":null,\"valid_to\":null,\"created_by\":1,\"created_at\":\"2025-09-01 23:53:22\",\"updated_by\":1,\"updated_at\":\"2025-09-02 22:48:37\"}', '{\"name\":null,\"opis\":null,\"aktywny\":null,\"bind_mode\":null,\"root_struktura_id\":null}', '185.49.200.99', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Mobile Safari/537.36', '/modules/cmms/konfiguracja/zasady_przydzialu/edit.php?id=7'),
(83, '2025-09-03 21:17:51', 1, 'mes_resource_group', 2, '', '{\"id\":2,\"type_id\":1,\"subtype_id\":1,\"mpk_id\":null,\"structure_id\":8,\"structure_scope\":\"subtree\",\"target_group_id\":1,\"mode\":\"round_robin\",\"target_user_id\":null,\"assignment_mode\":\"least_busy\",\"priority\":10,\"active\":1,\"valid_from\":null,\"valid_to\":null,\"created_by\":1,\"created_at\":\"2025-09-01 10:28:59\",\"updated_by\":1,\"updated_at\":\"2025-09-02 22:48:37\"}', '{\"name\":null,\"opis\":null,\"aktywny\":null,\"bind_mode\":null,\"root_struktura_id\":null}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/konfiguracja/zasady_przydzialu/edit.php?id=2'),
(84, '2025-09-03 21:18:04', 1, 'mes_resource_group', 7, '', '{\"id\":7,\"type_id\":2,\"subtype_id\":2,\"mpk_id\":null,\"structure_id\":8,\"structure_scope\":\"subtree\",\"target_group_id\":1,\"mode\":\"round_robin\",\"target_user_id\":null,\"assignment_mode\":\"least_busy\",\"priority\":10,\"active\":1,\"valid_from\":null,\"valid_to\":null,\"created_by\":1,\"created_at\":\"2025-09-01 23:53:22\",\"updated_by\":1,\"updated_at\":\"2025-09-03 18:41:35\"}', '{\"name\":null,\"opis\":null,\"aktywny\":null,\"bind_mode\":null,\"root_struktura_id\":null}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/konfiguracja/zasady_przydzialu/edit.php?id=7'),
(85, '2025-09-03 21:18:47', 1, 'mes_resource_group', 0, '', NULL, '{\"name\":null,\"opis\":null,\"aktywny\":null,\"bind_mode\":null,\"root_struktura_id\":null}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/konfiguracja/zasady_przydzialu/edit.php'),
(86, '2025-09-03 22:09:57', 1, 'mes_resource_group_item', 1, '', NULL, '{\"root\":1,\"requested\":10,\"inserted\":9}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(87, '2025-09-03 22:10:00', 1, 'mes_resource_group_item', 1, '', NULL, '{\"struktura_id\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(88, '2025-09-03 22:10:13', 1, 'mes_resource_group', 1, '', '{\"id\":1,\"name\":\"Dozownica dżemowa\",\"bind_mode\":\"explicit\",\"root_struktura_id\":null,\"opis\":\"\",\"aktywny\":0}', '{\"bind_mode\":\"subtree\"}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(89, '2025-09-03 22:10:22', 1, 'mes_resource_group', 1, '', '{\"id\":1,\"name\":\"Dozownica dżemowa\",\"bind_mode\":\"subtree\",\"root_struktura_id\":null,\"opis\":\"\",\"aktywny\":0}', '{\"bind_mode\":\"explicit\"}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(90, '2025-09-03 22:10:28', 1, 'mes_resource_group_item', 1, '', NULL, '{\"struktura_id\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(91, '2025-09-03 22:11:20', 1, 'mes_resource_group_item', 1, '', NULL, '{\"struktura_id\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(92, '2025-09-03 22:11:22', 1, 'mes_resource_group_item', 1, '', NULL, '{\"struktura_id\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(93, '2025-09-03 22:11:23', 1, 'mes_resource_group_item', 1, '', NULL, '{\"struktura_id\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(94, '2025-09-03 22:11:32', 1, 'mes_resource_group_item', 1, '', NULL, '{\"struktura_id\":20}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(95, '2025-09-03 22:11:40', 1, 'mes_resource_group_item', 1, '', '{\"struktura_id\":7}', NULL, '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(96, '2025-09-03 22:11:44', 1, 'mes_resource_group_item', 1, '', '{\"struktura_id\":17}', NULL, '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(97, '2025-09-03 22:11:45', 1, 'mes_resource_group_item', 1, '', '{\"struktura_id\":18}', NULL, '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(98, '2025-09-03 22:11:46', 1, 'mes_resource_group_item', 1, '', '{\"struktura_id\":21}', NULL, '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(99, '2025-09-03 22:11:47', 1, 'mes_resource_group_item', 1, '', '{\"struktura_id\":8}', NULL, '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(100, '2025-09-03 22:11:48', 1, 'mes_resource_group_item', 1, '', '{\"struktura_id\":20}', NULL, '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(101, '2025-09-03 22:11:49', 1, 'mes_resource_group_item', 1, '', '{\"struktura_id\":22}', NULL, '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(102, '2025-09-03 22:11:51', 1, 'mes_resource_group_item', 1, '', '{\"struktura_id\":19}', NULL, '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(103, '2025-09-03 22:11:52', 1, 'mes_resource_group_item', 1, '', '{\"struktura_id\":1}', NULL, '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(104, '2025-09-03 22:11:53', 1, 'mes_resource_group_item', 1, '', '{\"struktura_id\":9}', NULL, '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(105, '2025-09-03 22:11:54', 1, 'mes_resource_group_item', 1, '', NULL, '{\"struktura_id\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(106, '2025-09-03 22:11:57', 1, 'mes_resource_group_item', 1, '', '{\"struktura_id\":1}', NULL, '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(107, '2025-09-03 22:11:59', 1, 'mes_resource_group_item', 1, '', NULL, '{\"struktura_id\":7}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(108, '2025-09-03 22:12:00', 1, 'mes_resource_group_item', 1, '', NULL, '{\"root\":1,\"requested\":10,\"inserted\":9}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(109, '2025-09-03 22:12:03', 1, 'mes_resource_group_item', 1, '', '{\"struktura_id\":7}', NULL, '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(110, '2025-09-03 22:12:04', 1, 'mes_resource_group_item', 1, '', '{\"struktura_id\":17}', NULL, '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(111, '2025-09-03 22:12:05', 1, 'mes_resource_group_item', 1, '', '{\"struktura_id\":18}', NULL, '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(112, '2025-09-03 22:12:06', 1, 'mes_resource_group_item', 1, '', '{\"struktura_id\":21}', NULL, '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(113, '2025-09-03 22:12:07', 1, 'mes_resource_group_item', 1, '', '{\"struktura_id\":8}', NULL, '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(114, '2025-09-03 22:12:08', 1, 'mes_resource_group_item', 1, '', '{\"struktura_id\":20}', NULL, '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(115, '2025-09-03 22:12:08', 1, 'mes_resource_group_item', 1, '', '{\"struktura_id\":22}', NULL, '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(116, '2025-09-03 22:12:09', 1, 'mes_resource_group_item', 1, '', '{\"struktura_id\":19}', NULL, '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(117, '2025-09-03 22:12:10', 1, 'mes_resource_group_item', 1, '', '{\"struktura_id\":1}', NULL, '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(118, '2025-09-03 22:12:11', 1, 'mes_resource_group_item', 1, '', '{\"struktura_id\":9}', NULL, '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(119, '2025-09-03 22:12:17', 1, 'mes_resource_group_item', 1, '', NULL, '{\"root\":20,\"requested\":3,\"inserted\":3}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1');
INSERT INTO `audit_log` (`id`, `created_at`, `user_id`, `table_name`, `record_id`, `action`, `before_json`, `after_json`, `ip`, `user_agent`, `route`) VALUES
(120, '2025-09-03 22:12:27', 1, 'mes_resource_group', 1, '', '{\"id\":1,\"name\":\"Dozownica dżemowa\",\"bind_mode\":\"explicit\",\"root_struktura_id\":null,\"opis\":\"\",\"aktywny\":0}', '{\"bind_mode\":\"subtree\"}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(121, '2025-09-03 22:12:33', 1, 'mes_resource_group', 1, '', '{\"id\":1,\"name\":\"Dozownica dżemowa\",\"bind_mode\":\"subtree\",\"root_struktura_id\":null,\"opis\":\"\",\"aktywny\":0}', '{\"root_struktura_id\":20}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(122, '2025-09-03 22:12:48', 1, 'mes_resource_group', 1, '', '{\"id\":1,\"name\":\"Dozownica dżemowa\",\"bind_mode\":\"subtree\",\"root_struktura_id\":20,\"opis\":\"\",\"aktywny\":0}', '{\"bind_mode\":\"explicit\"}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(123, '2025-09-03 22:12:52', 1, 'mes_resource_group', 1, '', '{\"id\":1,\"name\":\"Dozownica dżemowa\",\"bind_mode\":\"explicit\",\"root_struktura_id\":20,\"opis\":\"\",\"aktywny\":0}', '{\"bind_mode\":\"subtree\"}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/items.php?id=1'),
(124, '2025-09-03 23:12:15', 1, 'cmms.struktura', 0, '', '{\"parent_id\":20,\"sort_order\":1}', '{\"parent_id\":19,\"sort_order\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(125, '2025-09-03 23:12:15', 1, 'cmms.struktura', 0, '', '{\"parent_id\":19,\"sort_order\":1}', '{\"parent_id\":19,\"sort_order\":2}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(126, '2025-09-03 23:13:13', 1, 'mes_resource_group', 1, '', NULL, '{\"name\":\"Dozownica dżemowa\",\"opis\":\"\",\"aktywny\":0,\"bind_mode\":\"explicit\",\"root_struktura_id\":null}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/edit.php?id=1'),
(127, '2025-09-04 22:31:38', 1, 'mes_resource_group', 2, '', '{\"id\":2,\"type_id\":1,\"subtype_id\":1,\"mpk_id\":null,\"structure_id\":8,\"structure_scope\":\"subtree\",\"target_group_id\":1,\"mode\":\"round_robin\",\"target_user_id\":null,\"assignment_mode\":\"least_busy\",\"priority\":10,\"active\":1,\"valid_from\":null,\"valid_to\":null,\"created_by\":1,\"created_at\":\"2025-09-01 10:28:59\",\"updated_by\":1,\"updated_at\":\"2025-09-03 21:17:51\"}', '{\"name\":null,\"opis\":null,\"aktywny\":null,\"bind_mode\":null,\"root_struktura_id\":null}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/konfiguracja/zasady_przydzialu/edit.php?id=2'),
(128, '2025-09-04 22:32:06', 1, 'mes_resource_group', 7, '', '{\"id\":7,\"type_id\":2,\"subtype_id\":2,\"mpk_id\":null,\"structure_id\":8,\"structure_scope\":\"subtree\",\"target_group_id\":2,\"mode\":\"round_robin\",\"target_user_id\":null,\"assignment_mode\":\"least_busy\",\"priority\":10,\"active\":1,\"valid_from\":null,\"valid_to\":null,\"created_by\":1,\"created_at\":\"2025-09-01 23:53:22\",\"updated_by\":1,\"updated_at\":\"2025-09-03 21:18:04\"}', '{\"name\":null,\"opis\":null,\"aktywny\":null,\"bind_mode\":null,\"root_struktura_id\":null}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/konfiguracja/zasady_przydzialu/edit.php?id=7'),
(129, '2025-09-05 10:50:27', 1, 'mes_resource_group', 1, '', NULL, '{\"name\":\"Dozownica dżemowa\",\"opis\":\"\",\"aktywny\":1,\"bind_mode\":\"explicit\",\"root_struktura_id\":null}', '80.51.233.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/edit.php?id=1'),
(130, '2025-09-05 10:50:30', 1, 'mes_resource_group', 4, '', NULL, '{\"name\":\"test\",\"opis\":\"\",\"aktywny\":1,\"bind_mode\":\"explicit\",\"root_struktura_id\":null}', '80.51.233.206', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/mes/konfiguracja/grupy_zasobow/edit.php?id=4'),
(131, '2025-09-08 09:36:47', 1, 'mes_resource_group', 0, '', NULL, '{\"name\":null,\"opis\":null,\"aktywny\":null,\"bind_mode\":null,\"root_struktura_id\":null}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/konfiguracja/zasady_przydzialu/edit.php'),
(132, '2025-09-08 09:37:04', 1, 'mes_resource_group', 0, '', NULL, '{\"name\":null,\"opis\":null,\"aktywny\":null,\"bind_mode\":null,\"root_struktura_id\":null}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/konfiguracja/zasady_przydzialu/edit.php'),
(133, '2025-09-08 09:50:18', 1, 'mes_resource_group', 0, '', NULL, '{\"name\":null,\"opis\":null,\"aktywny\":null,\"bind_mode\":null,\"root_struktura_id\":null}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/konfiguracja/zasady_przydzialu/edit.php'),
(134, '2025-09-08 09:50:43', 1, 'mes_resource_group', 0, '', NULL, '{\"name\":null,\"opis\":null,\"aktywny\":null,\"bind_mode\":null,\"root_struktura_id\":null}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/konfiguracja/zasady_przydzialu/edit.php'),
(135, '2025-09-08 11:09:27', 1, 'mes_resource_group', 0, '', NULL, '{\"name\":null,\"opis\":null,\"aktywny\":null,\"bind_mode\":null,\"root_struktura_id\":null}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/konfiguracja/zasady_przydzialu/edit.php'),
(136, '2025-09-08 11:09:45', 1, 'mes_resource_group', 0, '', NULL, '{\"name\":null,\"opis\":null,\"aktywny\":null,\"bind_mode\":null,\"root_struktura_id\":null}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/konfiguracja/zasady_przydzialu/edit.php'),
(137, '2025-09-08 11:10:06', 1, 'mes_resource_group', 0, '', NULL, '{\"name\":null,\"opis\":null,\"aktywny\":null,\"bind_mode\":null,\"root_struktura_id\":null}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/konfiguracja/zasady_przydzialu/edit.php'),
(138, '2025-09-08 11:16:38', 1, 'mes_resource_group', 2008, '', '{\"id\":2008,\"type_id\":2,\"subtype_id\":null,\"mpk_id\":null,\"structure_id\":8,\"structure_scope\":\"subtree\",\"target_group_id\":2,\"mode\":\"fixed\",\"target_user_id\":null,\"assignment_mode\":\"fixed\",\"priority\":10,\"active\":1,\"valid_from\":null,\"valid_to\":null,\"created_by\":1,\"created_at\":\"2025-09-08 11:10:06\",\"updated_by\":1,\"updated_at\":\"2025-09-08 11:10:06\"}', '{\"name\":null,\"opis\":null,\"aktywny\":null,\"bind_mode\":null,\"root_struktura_id\":null}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/konfiguracja/zasady_przydzialu/edit.php?id=2008'),
(139, '2025-09-08 11:20:58', 1, 'mes_resource_group', 2008, '', '{\"id\":2008,\"type_id\":2,\"subtype_id\":null,\"mpk_id\":null,\"structure_id\":null,\"structure_scope\":\"subtree\",\"target_group_id\":2,\"mode\":\"fixed\",\"target_user_id\":null,\"assignment_mode\":\"fixed\",\"priority\":10,\"active\":1,\"valid_from\":null,\"valid_to\":null,\"created_by\":1,\"created_at\":\"2025-09-08 11:10:06\",\"updated_by\":1,\"updated_at\":\"2025-09-08 11:16:38\"}', '{\"name\":null,\"opis\":null,\"aktywny\":null,\"bind_mode\":null,\"root_struktura_id\":null}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/konfiguracja/zasady_przydzialu/edit.php?id=2008'),
(140, '2025-09-10 11:50:29', 1, 'cmms_struktura', 1, 'update', '{\"id\":1,\"parent_id\":null,\"typ_zasobu_id\":null,\"mpk_linia_id\":null,\"element_id\":null,\"id_element\":null,\"key\":\"root\",\"nazwa\":\"ROOT\",\"opis\":null,\"ikona\":\"🏭\",\"kolor\":\"#E30613\",\"sort_order\":1,\"aktywny\":1,\"is_system\":1,\"depth\":0,\"path\":\"/1\",\"created_by\":null,\"updated_by\":1,\"created_at\":\"2025-08-28 20:06:15\",\"updated_at\":\"2025-09-03 23:12:15\"}', '{\"nazwa\":\"Zakład\",\"parent_id\":null,\"typ_zasobu_id\":null,\"mpk_linia_id\":null,\"element_id\":null,\"aktywny\":1}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?id=1'),
(141, '2025-09-10 11:52:46', 1, 'cmms_struktura', 7, 'update', '{\"id\":7,\"parent_id\":1,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":4,\"id_element\":null,\"key\":null,\"nazwa\":\"Budynek produkcyjny\",\"opis\":null,\"ikona\":null,\"kolor\":null,\"sort_order\":1,\"aktywny\":1,\"is_system\":0,\"depth\":1,\"path\":\"/1/7\",\"created_by\":1,\"updated_by\":1,\"created_at\":\"2025-08-29 09:10:56\",\"updated_at\":\"2025-09-10 11:50:29\"}', '{\"nazwa\":\"Budynek produkcyjny G2\",\"parent_id\":1,\"typ_zasobu_id\":1,\"mpk_linia_id\":1,\"element_id\":4,\"aktywny\":1}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?id=7'),
(142, '2025-09-10 11:54:11', 1, 'cmms_struktura', 23, '', NULL, '{\"nazwa\":\"Budynek magazynowy G1\",\"parent_id\":1,\"typ_zasobu_id\":null,\"mpk_linia_id\":null,\"element_id\":null,\"aktywny\":1}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?parent_id=1'),
(143, '2025-09-10 11:54:22', 1, 'cmms_struktura', 23, 'update', '{\"id\":23,\"parent_id\":1,\"typ_zasobu_id\":null,\"mpk_linia_id\":null,\"element_id\":null,\"id_element\":null,\"key\":null,\"nazwa\":\"Budynek magazynowy G1\",\"opis\":null,\"ikona\":null,\"kolor\":null,\"sort_order\":0,\"aktywny\":1,\"is_system\":0,\"depth\":1,\"path\":\"/1/23\",\"created_by\":1,\"updated_by\":1,\"created_at\":\"2025-09-10 11:54:11\",\"updated_at\":\"2025-09-10 11:54:11\"}', '{\"nazwa\":\"Budynek magazynowy G1\",\"parent_id\":1,\"typ_zasobu_id\":null,\"mpk_linia_id\":null,\"element_id\":4,\"aktywny\":1}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?id=23'),
(144, '2025-09-10 13:00:52', 1, 'cmms.struktura', 0, '', '{\"parent_id\":1,\"sort_order\":0}', '{\"parent_id\":1,\"sort_order\":1}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(145, '2025-09-10 13:00:52', 1, 'cmms.struktura', 0, '', '{\"parent_id\":1,\"sort_order\":1}', '{\"parent_id\":1,\"sort_order\":2}', '109.196.154.68', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(146, '2025-09-10 19:12:41', 5, 'cmms_struktura', 24, '', NULL, '{\"nazwa\":\"Linia A\",\"parent_id\":23,\"typ_zasobu_id\":null,\"mpk_linia_id\":null,\"element_id\":5,\"aktywny\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?parent_id=23'),
(147, '2025-09-10 19:25:54', 1, 'cmms_struktura', 25, '', NULL, '{\"nazwa\":\"Urządzenie A\",\"parent_id\":24,\"typ_zasobu_id\":2,\"mpk_linia_id\":null,\"element_id\":6,\"aktywny\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?parent_id=24'),
(148, '2025-09-10 19:26:04', 1, 'cmms_struktura', 24, 'update', '{\"id\":24,\"parent_id\":23,\"typ_zasobu_id\":null,\"mpk_linia_id\":null,\"element_id\":5,\"id_element\":null,\"key\":null,\"nazwa\":\"Linia A\",\"opis\":null,\"ikona\":null,\"kolor\":null,\"sort_order\":0,\"aktywny\":1,\"is_system\":0,\"depth\":2,\"path\":\"/1/23/24\",\"created_by\":5,\"updated_by\":5,\"created_at\":\"2025-09-10 19:12:41\",\"updated_at\":\"2025-09-10 19:12:41\"}', '{\"nazwa\":\"Linia A\",\"parent_id\":23,\"typ_zasobu_id\":null,\"mpk_linia_id\":null,\"element_id\":5,\"aktywny\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?id=24'),
(149, '2025-09-10 19:26:24', 1, 'cmms_struktura', 26, '', NULL, '{\"nazwa\":\"Urządzenie B\",\"parent_id\":24,\"typ_zasobu_id\":null,\"mpk_linia_id\":null,\"element_id\":6,\"aktywny\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?parent_id=24'),
(150, '2025-09-10 19:36:07', 1, 'cmms_struktura', 27, '', NULL, '{\"nazwa\":\"Urządzenie C\",\"parent_id\":24,\"typ_zasobu_id\":null,\"mpk_linia_id\":null,\"element_id\":6,\"aktywny\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?parent_id=24'),
(151, '2025-09-10 19:43:04', 1, 'cmms_struktura', 28, '', NULL, '{\"nazwa\":\"Urządzenie C\",\"parent_id\":24,\"typ_zasobu_id\":null,\"mpk_linia_id\":null,\"element_id\":5,\"aktywny\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?parent_id=24'),
(152, '2025-09-10 19:43:10', 1, 'cmms_struktura', 28, 'update', '{\"id\":28,\"parent_id\":24,\"typ_zasobu_id\":null,\"mpk_linia_id\":null,\"element_id\":5,\"id_element\":null,\"key\":null,\"nazwa\":\"Urządzenie C\",\"opis\":null,\"ikona\":null,\"kolor\":null,\"sort_order\":0,\"aktywny\":1,\"is_system\":0,\"depth\":3,\"path\":\"/1/23/24/28\",\"created_by\":1,\"updated_by\":1,\"created_at\":\"2025-09-10 19:43:04\",\"updated_at\":\"2025-09-10 19:43:04\"}', '{\"nazwa\":\"Urządzenie C\",\"parent_id\":24,\"typ_zasobu_id\":null,\"mpk_linia_id\":null,\"element_id\":6,\"aktywny\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?id=28'),
(153, '2025-09-10 19:43:19', 1, 'cmms.struktura', 0, '', '{\"parent_id\":23,\"sort_order\":0}', '{\"parent_id\":1,\"sort_order\":2}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(154, '2025-09-10 19:43:19', 1, 'cmms.struktura', 0, '', '{\"parent_id\":24,\"sort_order\":0}', '{\"parent_id\":24,\"sort_order\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(155, '2025-09-10 19:43:19', 1, 'cmms.struktura', 0, '', '{\"parent_id\":24,\"sort_order\":0}', '{\"parent_id\":24,\"sort_order\":2}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(156, '2025-09-10 19:43:19', 1, 'cmms.struktura', 0, '', '{\"parent_id\":24,\"sort_order\":0}', '{\"parent_id\":24,\"sort_order\":3}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(157, '2025-09-10 19:43:19', 1, 'cmms.struktura', 0, '', '{\"parent_id\":24,\"sort_order\":0}', '{\"parent_id\":24,\"sort_order\":4}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(158, '2025-09-10 19:43:19', 1, 'cmms.struktura', 0, '', '{\"parent_id\":1,\"sort_order\":2}', '{\"parent_id\":1,\"sort_order\":3}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(159, '2025-09-10 19:43:21', 1, 'cmms.struktura', 0, '', '{\"parent_id\":1,\"sort_order\":2}', '{\"parent_id\":23,\"sort_order\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(160, '2025-09-10 19:43:21', 1, 'cmms.struktura', 0, '', '{\"parent_id\":1,\"sort_order\":3}', '{\"parent_id\":1,\"sort_order\":2}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(161, '2025-09-10 20:43:45', 1, 'cmms_struktura', 29, '', NULL, '{\"nazwa\":\"Obszar A\",\"parent_id\":24,\"typ_zasobu_id\":null,\"mpk_linia_id\":null,\"element_id\":7,\"aktywny\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?parent_id=24'),
(162, '2025-09-10 20:43:48', 1, 'cmms.struktura', 0, '', '{\"parent_id\":24,\"sort_order\":0}', '{\"parent_id\":24,\"sort_order\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(163, '2025-09-10 20:43:48', 1, 'cmms.struktura', 0, '', '{\"parent_id\":24,\"sort_order\":1}', '{\"parent_id\":29,\"sort_order\":1}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(164, '2025-09-10 20:43:51', 1, 'cmms.struktura', 0, '', '{\"parent_id\":24,\"sort_order\":2}', '{\"parent_id\":29,\"sort_order\":2}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(165, '2025-09-10 20:43:51', 1, 'cmms.struktura', 0, '', '{\"parent_id\":24,\"sort_order\":3}', '{\"parent_id\":24,\"sort_order\":2}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(166, '2025-09-10 20:43:51', 1, 'cmms.struktura', 0, '', '{\"parent_id\":24,\"sort_order\":4}', '{\"parent_id\":24,\"sort_order\":3}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(167, '2025-09-10 20:43:54', 1, 'cmms.struktura', 0, '', '{\"parent_id\":24,\"sort_order\":2}', '{\"parent_id\":29,\"sort_order\":3}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(168, '2025-09-10 20:43:54', 1, 'cmms.struktura', 0, '', '{\"parent_id\":24,\"sort_order\":3}', '{\"parent_id\":24,\"sort_order\":2}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(169, '2025-09-10 20:43:55', 1, 'cmms.struktura', 0, '', '{\"parent_id\":24,\"sort_order\":2}', '{\"parent_id\":29,\"sort_order\":4}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(170, '2025-09-11 13:17:03', 1, 'mes_resource_group', 0, '', NULL, '{\"name\":null,\"opis\":null,\"aktywny\":null,\"bind_mode\":null,\"root_struktura_id\":null}', '109.196.154.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/cmms/konfiguracja/zasady_przydzialu/edit.php'),
(171, '2025-09-11 13:22:06', 1, 'cmms_struktura', 30, '', NULL, '{\"nazwa\":\"test\",\"parent_id\":23,\"typ_zasobu_id\":4,\"mpk_linia_id\":2,\"element_id\":5,\"aktywny\":1}', '109.196.154.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php'),
(172, '2025-09-11 13:22:24', 1, 'cmms_struktura', 31, '', NULL, '{\"nazwa\":\"tesst\",\"parent_id\":18,\"typ_zasobu_id\":4,\"mpk_linia_id\":2,\"element_id\":7,\"aktywny\":1}', '109.196.154.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?parent_id=18'),
(173, '2025-09-11 13:22:40', 1, 'cmms_struktura', 32, '', NULL, '{\"nazwa\":\"tst\",\"parent_id\":18,\"typ_zasobu_id\":null,\"mpk_linia_id\":null,\"element_id\":8,\"aktywny\":1}', '109.196.154.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?parent_id=18'),
(174, '2025-09-11 13:22:50', 1, 'cmms_struktura', 33, '', NULL, '{\"nazwa\":\"tet\",\"parent_id\":29,\"typ_zasobu_id\":null,\"mpk_linia_id\":null,\"element_id\":4,\"aktywny\":1}', '109.196.154.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?parent_id=29'),
(175, '2025-09-11 13:23:14', 1, 'cmms.struktura', 0, '', '{\"parent_id\":29,\"sort_order\":0}', '{\"parent_id\":29,\"sort_order\":1}', '109.196.154.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(176, '2025-09-11 13:23:14', 1, 'cmms.struktura', 0, '', '{\"parent_id\":29,\"sort_order\":1}', '{\"parent_id\":29,\"sort_order\":2}', '109.196.154.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(177, '2025-09-11 13:23:14', 1, 'cmms.struktura', 0, '', '{\"parent_id\":29,\"sort_order\":2}', '{\"parent_id\":29,\"sort_order\":3}', '109.196.154.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(178, '2025-09-11 13:23:14', 1, 'cmms.struktura', 0, '', '{\"parent_id\":29,\"sort_order\":3}', '{\"parent_id\":29,\"sort_order\":4}', '109.196.154.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(179, '2025-09-11 13:23:14', 1, 'cmms.struktura', 0, '', '{\"parent_id\":29,\"sort_order\":4}', '{\"parent_id\":29,\"sort_order\":5}', '109.196.154.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(180, '2025-09-11 13:23:14', 1, 'cmms.struktura', 0, '', '{\"parent_id\":18,\"sort_order\":0}', '{\"parent_id\":18,\"sort_order\":1}', '109.196.154.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(181, '2025-09-11 13:23:14', 1, 'cmms.struktura', 0, '', '{\"parent_id\":18,\"sort_order\":0}', '{\"parent_id\":18,\"sort_order\":2}', '109.196.154.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(182, '2025-09-11 13:23:18', 1, 'cmms.struktura', 0, '', '{\"parent_id\":29,\"sort_order\":3}', '{\"parent_id\":29,\"sort_order\":2}', '109.196.154.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(183, '2025-09-11 13:23:18', 1, 'cmms.struktura', 0, '', '{\"parent_id\":29,\"sort_order\":4}', '{\"parent_id\":29,\"sort_order\":3}', '109.196.154.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(184, '2025-09-11 13:23:18', 1, 'cmms.struktura', 0, '', '{\"parent_id\":29,\"sort_order\":5}', '{\"parent_id\":29,\"sort_order\":4}', '109.196.154.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(185, '2025-09-11 13:23:18', 1, 'cmms.struktura', 0, '', '{\"parent_id\":29,\"sort_order\":2}', '{\"parent_id\":1,\"sort_order\":2}', '109.196.154.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(186, '2025-09-11 13:23:18', 1, 'cmms.struktura', 0, '', '{\"parent_id\":1,\"sort_order\":2}', '{\"parent_id\":1,\"sort_order\":3}', '109.196.154.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(187, '2025-09-11 13:23:20', 1, 'cmms.struktura', 0, '', '{\"parent_id\":1,\"sort_order\":2}', '{\"parent_id\":23,\"sort_order\":2}', '109.196.154.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(188, '2025-09-11 13:23:20', 1, 'cmms.struktura', 0, '', '{\"parent_id\":1,\"sort_order\":3}', '{\"parent_id\":1,\"sort_order\":2}', '109.196.154.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(189, '2025-09-11 13:23:21', 1, 'cmms.struktura', 0, '', '{\"parent_id\":23,\"sort_order\":2}', '{\"parent_id\":24,\"sort_order\":2}', '109.196.154.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(190, '2025-09-11 13:23:22', 1, 'cmms.struktura', 0, '', '{\"parent_id\":24,\"sort_order\":2}', '{\"parent_id\":29,\"sort_order\":5}', '109.196.154.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(191, '2025-09-11 13:23:29', 1, 'cmms_struktura', 27, 'update', '{\"id\":27,\"parent_id\":29,\"typ_zasobu_id\":null,\"mpk_linia_id\":null,\"element_id\":6,\"id_element\":null,\"key\":null,\"nazwa\":\"Urządzenie C\",\"opis\":null,\"ikona\":null,\"kolor\":null,\"sort_order\":3,\"aktywny\":1,\"is_system\":0,\"depth\":4,\"path\":\"/1/23/24/29/27\",\"created_by\":1,\"updated_by\":1,\"created_at\":\"2025-09-10 19:36:07\",\"updated_at\":\"2025-09-11 13:23:22\"}', '{\"nazwa\":\"Urządzenie C\",\"parent_id\":23,\"typ_zasobu_id\":null,\"mpk_linia_id\":null,\"element_id\":6,\"aktywny\":1}', '109.196.154.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/edit.php?id=27'),
(192, '2025-09-11 13:23:43', 1, 'cmms.struktura', 0, '', '{\"parent_id\":29,\"sort_order\":4}', '{\"parent_id\":29,\"sort_order\":3}', '109.196.154.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(193, '2025-09-11 13:23:43', 1, 'cmms.struktura', 0, '', '{\"parent_id\":29,\"sort_order\":5}', '{\"parent_id\":29,\"sort_order\":4}', '109.196.154.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(194, '2025-09-11 13:23:43', 1, 'cmms.struktura', 0, '', '{\"parent_id\":23,\"sort_order\":3}', '{\"parent_id\":1,\"sort_order\":2}', '109.196.154.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(195, '2025-09-11 13:23:43', 1, 'cmms.struktura', 0, '', '{\"parent_id\":1,\"sort_order\":2}', '{\"parent_id\":1,\"sort_order\":3}', '109.196.154.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(196, '2025-09-11 13:23:46', 1, 'cmms.struktura', 0, '', '{\"parent_id\":1,\"sort_order\":2}', '{\"parent_id\":29,\"sort_order\":5}', '109.196.154.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(197, '2025-09-11 13:23:46', 1, 'cmms.struktura', 0, '', '{\"parent_id\":1,\"sort_order\":3}', '{\"parent_id\":1,\"sort_order\":2}', '109.196.154.69', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/cmms/struktura/drzewo/ajax/zapisz_drzewo.php'),
(198, '2025-09-15 19:30:10', 1, 'cmms_plik', 5, 'delete', '{\"id\":5,\"entity_type\":\"structure\",\"entity_id\":23,\"typ_id\":5,\"nazwa_pliku\":\"Maspex 4.0.jpg\",\"mime\":\"image/jpeg\",\"rozmiar_b\":306787,\"sciezka\":\"/uploads/2025/09/structure/23/maspex-4-0-1ea1ab33c61f.jpg\",\"checksum_sha1\":\"b713d9c5d1e82ac8b32ef3ff099cea2b2a4950ec\",\"is_public\":0,\"is_main\":0,\"sort_order\":0,\"uwagi\":\"\",\"uploaded_by\":null,\"created_at\":\"2025-09-15 14:55:26\",\"deleted_at\":null}', NULL, '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/files/delete.php'),
(199, '2025-09-15 19:30:13', 1, 'cmms_plik', 6, 'delete', '{\"id\":6,\"entity_type\":\"structure\",\"entity_id\":23,\"typ_id\":null,\"nazwa_pliku\":\"system-mes-queris-widok-linii-laptop.png\",\"mime\":\"image/png\",\"rozmiar_b\":1470102,\"sciezka\":\"/uploads/2025/09/structure/23/system-mes-queris-widok-linii-laptop-bd1c2ae7ce9a.png\",\"checksum_sha1\":\"00d492e3dd61e44cebbf00c9b74546485c44491a\",\"is_public\":0,\"is_main\":0,\"sort_order\":0,\"uwagi\":\"\",\"uploaded_by\":null,\"created_at\":\"2025-09-15 14:56:19\",\"deleted_at\":null}', NULL, '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/files/delete.php'),
(200, '2025-09-15 19:45:13', 1, 'cmms_plik', 7, 'update', '{\"id\":7,\"entity_type\":\"structure\",\"entity_id\":23,\"typ_id\":5,\"nazwa_pliku\":\"Maspex 4.0.jpg\",\"mime\":\"image/jpeg\",\"rozmiar_b\":306787,\"sciezka\":\"/uploads/2025/09/structure/23/maspex-4-0-13202cddbb9e.jpg\",\"checksum_sha1\":\"b713d9c5d1e82ac8b32ef3ff099cea2b2a4950ec\",\"is_public\":0,\"is_main\":0,\"sort_order\":0,\"uwagi\":\"\",\"uploaded_by\":null,\"created_at\":\"2025-09-15 18:27:36\",\"deleted_at\":null}', '{\"id\":7,\"entity_type\":\"structure\",\"entity_id\":23,\"typ_id\":5,\"nazwa_pliku\":\"Maspex 4.0.jpg\",\"mime\":\"image/jpeg\",\"rozmiar_b\":306787,\"sciezka\":\"/uploads/2025/09/structure/23/maspex-4-0-13202cddbb9e.jpg\",\"checksum_sha1\":\"b713d9c5d1e82ac8b32ef3ff099cea2b2a4950ec\",\"is_public\":0,\"is_main\":1,\"sort_order\":0,\"uwagi\":\"\",\"uploaded_by\":null,\"created_at\":\"2025-09-15 18:27:36\",\"deleted_at\":null}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/files/set_main.php'),
(201, '2025-09-15 19:45:47', 1, 'cmms_plik', 7, 'update', '{\"id\":7,\"entity_type\":\"structure\",\"entity_id\":23,\"typ_id\":5,\"nazwa_pliku\":\"Maspex 4.0.jpg\",\"mime\":\"image/jpeg\",\"rozmiar_b\":306787,\"sciezka\":\"/uploads/2025/09/structure/23/maspex-4-0-13202cddbb9e.jpg\",\"checksum_sha1\":\"b713d9c5d1e82ac8b32ef3ff099cea2b2a4950ec\",\"is_public\":0,\"is_main\":1,\"sort_order\":0,\"uwagi\":\"\",\"uploaded_by\":null,\"created_at\":\"2025-09-15 18:27:36\",\"deleted_at\":null}', '{\"id\":7,\"entity_type\":\"structure\",\"entity_id\":23,\"typ_id\":5,\"nazwa_pliku\":\"Maspex 4.0.jpg\",\"mime\":\"image/jpeg\",\"rozmiar_b\":306787,\"sciezka\":\"/uploads/2025/09/structure/23/maspex-4-0-13202cddbb9e.jpg\",\"checksum_sha1\":\"b713d9c5d1e82ac8b32ef3ff099cea2b2a4950ec\",\"is_public\":0,\"is_main\":1,\"sort_order\":0,\"uwagi\":\"test\",\"uploaded_by\":null,\"created_at\":\"2025-09-15 18:27:36\",\"deleted_at\":null}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/files/update_meta.php'),
(202, '2025-09-15 19:46:09', 1, 'cmms_plik', 7, 'update', '{\"id\":7,\"entity_type\":\"structure\",\"entity_id\":23,\"typ_id\":5,\"nazwa_pliku\":\"Maspex 4.0.jpg\",\"mime\":\"image/jpeg\",\"rozmiar_b\":306787,\"sciezka\":\"/uploads/2025/09/structure/23/maspex-4-0-13202cddbb9e.jpg\",\"checksum_sha1\":\"b713d9c5d1e82ac8b32ef3ff099cea2b2a4950ec\",\"is_public\":0,\"is_main\":1,\"sort_order\":0,\"uwagi\":\"test\",\"uploaded_by\":null,\"created_at\":\"2025-09-15 18:27:36\",\"deleted_at\":null}', '{\"id\":7,\"entity_type\":\"structure\",\"entity_id\":23,\"typ_id\":5,\"nazwa_pliku\":\"Maspex 4.0.jpg\",\"mime\":\"image/jpeg\",\"rozmiar_b\":306787,\"sciezka\":\"/uploads/2025/09/structure/23/maspex-4-0-13202cddbb9e.jpg\",\"checksum_sha1\":\"b713d9c5d1e82ac8b32ef3ff099cea2b2a4950ec\",\"is_public\":0,\"is_main\":1,\"sort_order\":1,\"uwagi\":\"test\",\"uploaded_by\":null,\"created_at\":\"2025-09-15 18:27:36\",\"deleted_at\":null}', '185.49.200.99', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', '/modules/files/update_meta.php');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `audit_user_permissions`
--

CREATE TABLE `audit_user_permissions` (
  `id` bigint(20) NOT NULL,
  `actor_user_id` int(11) DEFAULT NULL,
  `target_user_id` int(11) NOT NULL,
  `action` enum('assign_role','revoke_role','override_allow','override_deny','override_clear','set_flag') NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`payload`)),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_assignment_rule`
--

CREATE TABLE `cmms_assignment_rule` (
  `id` int(10) UNSIGNED NOT NULL,
  `type_id` int(10) UNSIGNED DEFAULT NULL,
  `subtype_id` int(10) UNSIGNED DEFAULT NULL,
  `mpk_id` int(10) UNSIGNED DEFAULT NULL,
  `structure_id` int(10) UNSIGNED DEFAULT NULL,
  `structure_scope` enum('subtree','node') NOT NULL DEFAULT 'subtree',
  `target_group_id` int(10) UNSIGNED DEFAULT NULL,
  `mode` enum('fixed','round_robin','least_busy') NOT NULL DEFAULT 'fixed',
  `target_user_id` int(10) UNSIGNED DEFAULT NULL,
  `assignment_mode` enum('fixed','round_robin','least_busy') NOT NULL DEFAULT 'fixed',
  `priority` tinyint(3) UNSIGNED NOT NULL DEFAULT 10,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `valid_from` datetime DEFAULT NULL,
  `valid_to` datetime DEFAULT NULL,
  `created_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_by` int(10) UNSIGNED DEFAULT NULL,
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ;

--
-- Zrzut danych tabeli `cmms_assignment_rule`
--

INSERT INTO `cmms_assignment_rule` (`id`, `type_id`, `subtype_id`, `mpk_id`, `structure_id`, `structure_scope`, `target_group_id`, `mode`, `target_user_id`, `assignment_mode`, `priority`, `active`, `valid_from`, `valid_to`, `created_by`, `created_at`, `updated_by`, `updated_at`) VALUES
(2006, 1, 5, NULL, 8, 'subtree', 2, 'fixed', NULL, 'fixed', 10, 1, NULL, NULL, 1, '2025-09-08 11:09:27', 1, '2025-09-08 11:09:27'),
(2007, 1, 1, NULL, 8, 'subtree', 1, 'fixed', NULL, 'fixed', 10, 1, NULL, NULL, 1, '2025-09-08 11:09:45', 1, '2025-09-08 11:09:45'),
(2008, 2, NULL, NULL, 7, 'subtree', 2, 'fixed', NULL, 'fixed', 10, 1, NULL, NULL, 1, '2025-09-08 11:10:06', 1, '2025-09-08 11:20:58'),
(2012, 1, 1, NULL, 20, 'subtree', 1, 'fixed', 4, 'fixed', 10, 1, '2025-09-22 13:16:00', '2025-09-28 13:17:00', 1, '2025-09-11 13:17:03', 1, '2025-09-11 13:17:03');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_escalation_rule`
--

CREATE TABLE `cmms_escalation_rule` (
  `id` int(10) UNSIGNED NOT NULL,
  `type_id` int(10) UNSIGNED DEFAULT NULL,
  `subtype_id` int(10) UNSIGNED DEFAULT NULL,
  `mpk_id` int(10) UNSIGNED DEFAULT NULL,
  `structure_id` int(10) UNSIGNED DEFAULT NULL,
  `after_minutes` int(10) UNSIGNED NOT NULL,
  `escalate_to_group_id` int(10) UNSIGNED DEFAULT NULL,
  `escalate_to_user_id` int(10) UNSIGNED DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `priority` tinyint(3) UNSIGNED NOT NULL DEFAULT 10,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_group`
--

CREATE TABLE `cmms_group` (
  `id` int(10) UNSIGNED NOT NULL,
  `key_name` varchar(64) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_by` int(10) UNSIGNED DEFAULT NULL,
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `cmms_group`
--

INSERT INTO `cmms_group` (`id`, `key_name`, `name`, `description`, `active`, `created_by`, `created_at`, `updated_by`, `updated_at`) VALUES
(1, 'technicy', 'Technicy', NULL, 1, NULL, '2025-08-31 20:31:48', 1, '2025-09-09 21:46:44'),
(2, 'produkcja', 'Produkcja', NULL, 1, NULL, '2025-08-31 20:31:48', 1, '2025-09-09 21:46:34');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_group_rotation`
--

CREATE TABLE `cmms_group_rotation` (
  `group_id` int(10) UNSIGNED NOT NULL,
  `last_assigned_user_id` int(10) UNSIGNED DEFAULT NULL,
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `cmms_group_rotation`
--

INSERT INTO `cmms_group_rotation` (`group_id`, `last_assigned_user_id`, `updated_at`) VALUES
(1, 29, '2025-09-05 12:27:30');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_group_user`
--

CREATE TABLE `cmms_group_user` (
  `group_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `is_lead` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `cmms_group_user`
--

INSERT INTO `cmms_group_user` (`group_id`, `user_id`, `is_lead`) VALUES
(1, 19, 0),
(1, 20, 0),
(1, 21, 0),
(1, 23, 0),
(1, 25, 0),
(1, 29, 0),
(2, 13, 0),
(2, 16, 0),
(2, 17, 0),
(2, 18, 0),
(2, 19, 0),
(2, 21, 0),
(2, 25, 0);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_permissions`
--

CREATE TABLE `cmms_permissions` (
  `id` int(11) NOT NULL,
  `slug` varchar(150) NOT NULL,
  `label` varchar(180) NOT NULL,
  `module` varchar(60) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `cmms_permissions`
--

INSERT INTO `cmms_permissions` (`id`, `slug`, `label`, `module`, `created_at`) VALUES
(1, 'users.view', 'Podgląd użytkowników', 'users', '2025-08-19 18:33:32'),
(2, 'users.manage', 'Zarządzanie użytkownikami', 'users', '2025-08-19 18:33:32'),
(3, 'roles.view', 'Podgląd ról', 'roles', '2025-08-19 18:33:32'),
(4, 'roles.manage', 'Zarządzanie rolami i uprawnieniami', 'roles', '2025-08-19 18:33:32'),
(5, 'assets.view', 'Podgląd zasobów', 'assets', '2025-08-19 18:33:32'),
(6, 'assets.manage', 'Zarządzanie zasobami', 'assets', '2025-08-19 18:33:32'),
(7, 'tickets.create', 'Tworzenie zgłoszeń', 'tickets', '2025-08-19 18:33:32'),
(8, 'tickets.view_own', 'Podgląd własnych zgłoszeń', 'tickets', '2025-08-19 18:33:32'),
(9, 'tickets.view_all', 'Podgląd wszystkich zgłoszeń', 'tickets', '2025-08-19 18:33:32'),
(10, 'tickets.assign', 'Przypisywanie zgłoszeń', 'tickets', '2025-08-19 18:33:32'),
(11, 'tickets.edit', 'Edycja zgłoszeń', 'tickets', '2025-08-19 18:33:32'),
(12, 'tickets.status.change', 'Zmiana statusu zgłoszeń', 'tickets', '2025-08-19 18:33:32'),
(13, 'workorders.create', 'Tworzenie zleceń pracy', 'workorders', '2025-08-19 18:33:32'),
(14, 'workorders.edit', 'Edycja zleceń pracy', 'workorders', '2025-08-19 18:33:32'),
(15, 'workorders.view_all', 'Podgląd wszystkich zleceń', 'workorders', '2025-08-19 18:33:32'),
(16, 'spares.view', 'Podgląd części', 'spares', '2025-08-19 18:33:32'),
(17, 'spares.manage', 'Zarządzanie częściami', 'spares', '2025-08-19 18:33:32'),
(18, 'spares.issue', 'Rozchód części do zlecenia', 'spares', '2025-08-19 18:33:32'),
(19, 'reports.view', 'Podgląd raportów', 'reports', '2025-08-19 18:33:32'),
(20, 'types.view', 'Podgląd typów zgłoszeń', 'types', '2025-08-20 19:29:39'),
(21, 'types.manage', 'Zarządzanie typami zgłoszeń', 'types', '2025-08-20 19:29:39'),
(22, 'subtypes.view', 'Podgląd podtypów zgłoszeń', 'subtypes', '2025-08-20 19:30:24'),
(23, 'subtypes.manage', 'Zarządzanie podtypami zgłoszeń', 'subtypes', '2025-08-20 19:30:24'),
(24, 'responsibilities.view', 'Podgląd odpowiedzialności za zgłoszenia', 'responsibilities', '2025-08-20 19:31:06'),
(25, 'responsibilities.manage', 'Zarządzanie odpowiedzialnością za zgłoszenia', 'responsibilities', '2025-08-20 19:31:06'),
(26, 'notifications.manage', 'Zarządzanie listą adresową', 'notifications', '2025-08-20 19:31:29');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_plik`
--

CREATE TABLE `cmms_plik` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `entity_type` enum('ticket','structure') NOT NULL,
  `entity_id` bigint(20) UNSIGNED NOT NULL,
  `typ_id` int(10) UNSIGNED DEFAULT NULL,
  `nazwa_pliku` varchar(255) NOT NULL,
  `mime` varchar(127) NOT NULL,
  `rozmiar_b` bigint(20) UNSIGNED NOT NULL,
  `sciezka` varchar(512) NOT NULL,
  `checksum_sha1` char(40) DEFAULT NULL,
  `is_public` tinyint(1) DEFAULT 0,
  `is_main` tinyint(1) DEFAULT 0,
  `sort_order` int(11) DEFAULT 0,
  `uwagi` varchar(255) DEFAULT NULL,
  `uploaded_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `cmms_plik`
--

INSERT INTO `cmms_plik` (`id`, `entity_type`, `entity_id`, `typ_id`, `nazwa_pliku`, `mime`, `rozmiar_b`, `sciezka`, `checksum_sha1`, `is_public`, `is_main`, `sort_order`, `uwagi`, `uploaded_by`, `created_at`, `deleted_at`) VALUES
(5, 'structure', 23, 5, 'Maspex 4.0.jpg', 'image/jpeg', 306787, '/uploads/2025/09/structure/23/maspex-4-0-1ea1ab33c61f.jpg', 'b713d9c5d1e82ac8b32ef3ff099cea2b2a4950ec', 0, 0, 0, '', NULL, '2025-09-15 14:55:26', '2025-09-15 19:30:10'),
(6, 'structure', 23, NULL, 'system-mes-queris-widok-linii-laptop.png', 'image/png', 1470102, '/uploads/2025/09/structure/23/system-mes-queris-widok-linii-laptop-bd1c2ae7ce9a.png', '00d492e3dd61e44cebbf00c9b74546485c44491a', 0, 0, 0, '', NULL, '2025-09-15 14:56:19', '2025-09-15 19:30:13'),
(7, 'structure', 23, 5, 'Maspex 4.0.jpg', 'image/jpeg', 306787, '/uploads/2025/09/structure/23/maspex-4-0-13202cddbb9e.jpg', 'b713d9c5d1e82ac8b32ef3ff099cea2b2a4950ec', 0, 1, 1, 'test', NULL, '2025-09-15 18:27:36', NULL);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_responsibilities`
--

CREATE TABLE `cmms_responsibilities` (
  `id` int(10) UNSIGNED NOT NULL,
  `slug` varchar(64) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `default_assignee_user_id` int(11) DEFAULT NULL,
  `default_assignee_role_id` int(11) DEFAULT NULL,
  `notify_on_create` tinyint(1) NOT NULL DEFAULT 1,
  `notify_on_status_change` tinyint(1) NOT NULL DEFAULT 1,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `mpk_id` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `cmms_responsibilities`
--

INSERT INTO `cmms_responsibilities` (`id`, `slug`, `name`, `description`, `default_assignee_user_id`, `default_assignee_role_id`, `notify_on_create`, `notify_on_status_change`, `active`, `mpk_id`, `created_by`, `created_at`, `updated_by`, `updated_at`) VALUES
(1, 'mechanik', 'Mechanik', '', 18, 4, 1, 1, 1, NULL, NULL, '2025-08-20 21:25:40', NULL, '2025-08-21 08:13:13'),
(2, 'lider_linii', 'Lider linii', '', 21, 3, 1, 1, 1, NULL, NULL, '2025-08-20 21:25:40', NULL, '2025-08-22 12:32:39'),
(4, 'automatyk', 'Mechanik', '', 21, 5, 1, 1, 1, NULL, NULL, '2025-08-29 13:50:26', NULL, '2025-08-29 13:50:26');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_responsibility_contacts`
--

CREATE TABLE `cmms_responsibility_contacts` (
  `id` int(10) UNSIGNED NOT NULL,
  `responsibility_id` int(10) UNSIGNED NOT NULL,
  `contact_type` enum('email','sms','webhook') NOT NULL,
  `value` varchar(190) NOT NULL,
  `display_name` varchar(100) DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `preferred` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_roles`
--

CREATE TABLE `cmms_roles` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `label` varchar(150) NOT NULL,
  `system` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `cmms_roles`
--

INSERT INTO `cmms_roles` (`id`, `name`, `label`, `system`, `created_at`, `updated_at`) VALUES
(1, 'admin', 'Administrator', 1, '2025-08-19 18:33:16', NULL),
(2, 'maintenance_manager', 'Kierownik UR', 1, '2025-08-19 18:33:16', NULL),
(3, 'technician', 'Technik UR', 1, '2025-08-19 18:33:16', NULL),
(4, 'operator', 'Operator', 1, '2025-08-19 18:33:16', NULL),
(5, 'viewer', 'Podgląd', 1, '2025-08-19 18:33:16', NULL);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_role_permission`
--

CREATE TABLE `cmms_role_permission` (
  `role_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `cmms_role_permission`
--

INSERT INTO `cmms_role_permission` (`role_id`, `permission_id`) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(1, 7),
(1, 8),
(1, 9),
(1, 10),
(1, 11),
(1, 12),
(1, 13),
(1, 14),
(1, 15),
(1, 16),
(1, 17),
(1, 18),
(1, 19),
(2, 1),
(2, 3),
(2, 5),
(2, 6),
(2, 7),
(2, 9),
(2, 10),
(2, 11),
(2, 12),
(2, 13),
(2, 14),
(2, 15),
(2, 16),
(2, 17),
(2, 18),
(2, 19),
(3, 5),
(3, 9),
(3, 11),
(3, 12),
(3, 14),
(3, 15),
(3, 16),
(3, 18),
(3, 19),
(4, 5),
(4, 7),
(4, 8),
(4, 19),
(5, 5),
(5, 9),
(5, 19);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_slownik_element`
--

CREATE TABLE `cmms_slownik_element` (
  `id` int(10) UNSIGNED NOT NULL,
  `key` varchar(64) DEFAULT NULL,
  `nazwa` varchar(255) NOT NULL,
  `opis` text DEFAULT NULL,
  `ikona` varchar(64) DEFAULT NULL,
  `kolor` char(7) DEFAULT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `aktywny` tinyint(1) NOT NULL DEFAULT 1,
  `is_system` tinyint(1) NOT NULL DEFAULT 0,
  `created_by` int(10) UNSIGNED DEFAULT NULL,
  `updated_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Zrzut danych tabeli `cmms_slownik_element`
--

INSERT INTO `cmms_slownik_element` (`id`, `key`, `nazwa`, `opis`, `ikona`, `kolor`, `sort_order`, `aktywny`, `is_system`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(1, NULL, 'Zakład', 'Zakład produkcyjny', NULL, '#06E52B', 0, 1, 0, 1, 1, '2025-08-28 19:48:32', '2025-08-30 19:36:58'),
(4, NULL, 'Budynek', NULL, NULL, '#70D280', 0, 1, 0, 1, 1, '2025-08-30 19:37:24', '2025-08-30 19:37:24'),
(5, NULL, 'Linia', NULL, NULL, '#DECC0D', 0, 1, 0, 1, 1, '2025-08-30 19:37:37', '2025-09-01 19:55:35'),
(6, NULL, 'Urządzenie', NULL, NULL, '#E30613', 0, 1, 0, 1, 1, '2025-08-30 19:38:30', '2025-08-30 19:38:30'),
(7, NULL, 'Obszar', NULL, NULL, '#2317C4', 0, 1, 0, 1, 1, '2025-09-01 19:55:15', '2025-09-01 19:55:15'),
(8, NULL, 'Element', 'Element maszyny', NULL, '#9F94B8', 0, 1, 0, 1, 1, '2025-09-10 13:01:50', '2025-09-10 13:02:02');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_slownik_element_tr`
--

CREATE TABLE `cmms_slownik_element_tr` (
  `element_id` int(10) UNSIGNED NOT NULL,
  `lang` varchar(5) NOT NULL,
  `nazwa` varchar(255) NOT NULL,
  `opis` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_slownik_mpk_linia`
--

CREATE TABLE `cmms_slownik_mpk_linia` (
  `id` int(10) UNSIGNED NOT NULL,
  `key` varchar(64) DEFAULT NULL,
  `mpk` varchar(32) NOT NULL,
  `nazwa` varchar(255) NOT NULL,
  `opis` text DEFAULT NULL,
  `ikona` varchar(64) DEFAULT NULL,
  `kolor` char(7) DEFAULT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `aktywny` tinyint(1) NOT NULL DEFAULT 1,
  `is_system` tinyint(1) NOT NULL DEFAULT 0,
  `created_by` int(10) UNSIGNED DEFAULT NULL,
  `updated_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Zrzut danych tabeli `cmms_slownik_mpk_linia`
--

INSERT INTO `cmms_slownik_mpk_linia` (`id`, `key`, `mpk`, `nazwa`, `opis`, `ikona`, `kolor`, `sort_order`, `aktywny`, `is_system`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(1, NULL, 'PL321P1121', 'Linia syropowa', 'butelki szklane', NULL, '#06D6E5', 0, 1, 0, 1, 1, '2025-08-28 22:20:21', '2025-08-28 22:49:47'),
(2, NULL, 'PL321P1152', 'Linia dżemowa', NULL, NULL, '#7506E5', 0, 1, 0, 1, 1, '2025-08-30 19:40:56', '2025-08-30 19:40:56');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_slownik_plik_typ`
--

CREATE TABLE `cmms_slownik_plik_typ` (
  `id` int(10) UNSIGNED NOT NULL,
  `key_name` varchar(64) NOT NULL,
  `nazwa` varchar(255) NOT NULL,
  `opis` text DEFAULT NULL,
  `sort_order` int(11) DEFAULT 0,
  `aktywny` tinyint(1) DEFAULT 1,
  `is_system` tinyint(1) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `cmms_slownik_plik_typ`
--

INSERT INTO `cmms_slownik_plik_typ` (`id`, `key_name`, `nazwa`, `opis`, `sort_order`, `aktywny`, `is_system`, `created_at`, `updated_at`) VALUES
(1, 'instrukcja', 'Instrukcja', NULL, 10, 1, 1, '2025-09-15 10:36:57', '2025-09-15 10:36:57'),
(2, 'opl', 'OPL / One Point Lesson', NULL, 20, 1, 0, '2025-09-15 10:36:57', '2025-09-15 10:36:57'),
(3, 'parametry', 'Parametry ustawień', NULL, 30, 1, 0, '2025-09-15 10:36:57', '2025-09-15 10:36:57'),
(4, 'schemat_el', 'Schemat elektryczny', NULL, 40, 1, 0, '2025-09-15 10:36:57', '2025-09-15 10:36:57'),
(5, 'foto_ref', 'Zdjęcie referencyjne (Center Line)', NULL, 50, 1, 0, '2025-09-15 10:36:57', '2025-09-15 10:36:57'),
(6, 'inne', 'Inne', NULL, 999, 1, 1, '2025-09-15 10:36:57', '2025-09-15 10:36:57');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_slownik_typ_zasobu`
--

CREATE TABLE `cmms_slownik_typ_zasobu` (
  `id` int(10) UNSIGNED NOT NULL,
  `key` varchar(64) DEFAULT NULL,
  `nazwa` varchar(255) NOT NULL,
  `opis` text DEFAULT NULL,
  `ikona` varchar(64) DEFAULT NULL,
  `kolor` char(7) DEFAULT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `aktywny` tinyint(1) NOT NULL DEFAULT 1,
  `is_system` tinyint(1) NOT NULL DEFAULT 0,
  `created_by` int(10) UNSIGNED DEFAULT NULL,
  `updated_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Zrzut danych tabeli `cmms_slownik_typ_zasobu`
--

INSERT INTO `cmms_slownik_typ_zasobu` (`id`, `key`, `nazwa`, `opis`, `ikona`, `kolor`, `sort_order`, `aktywny`, `is_system`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(1, 'asset.machine', 'Kuchnia', NULL, '🛠', '#E70D0D', 10, 1, 0, NULL, 1, '2025-08-28 21:46:12', '2025-09-01 19:56:17'),
(2, 'asset.tool', 'Depaletyzacja', NULL, '🧰', '#E29612', 20, 1, 0, NULL, 1, '2025-08-28 21:46:12', '2025-09-01 19:56:43'),
(3, 'asset.vehicle', 'Myjka', NULL, '🚚', '#260AF5', 30, 1, 0, NULL, 1, '2025-08-28 21:46:12', '2025-09-01 19:57:00'),
(4, NULL, 'Dozownica', NULL, NULL, '#06E520', 0, 1, 0, 1, 1, '2025-09-01 19:57:15', '2025-09-01 19:57:15'),
(5, NULL, 'Etykieciarka', NULL, NULL, '#06E5E1', 0, 1, 0, 1, 1, '2025-09-01 19:57:30', '2025-09-01 19:57:30');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_statuses`
--

CREATE TABLE `cmms_statuses` (
  `id` int(10) UNSIGNED NOT NULL,
  `category_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(64) NOT NULL,
  `slug` varchar(64) NOT NULL,
  `color` varchar(32) DEFAULT NULL,
  `order_no` int(11) NOT NULL DEFAULT 100,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `is_initial` tinyint(1) NOT NULL DEFAULT 0,
  `is_final` tinyint(1) NOT NULL DEFAULT 0,
  `pauses_sla` tinyint(1) NOT NULL DEFAULT 0,
  `sets_resolved_at` tinyint(1) NOT NULL DEFAULT 0,
  `sets_closed_at` tinyint(1) NOT NULL DEFAULT 0,
  `requires_assignee` tinyint(1) NOT NULL DEFAULT 0,
  `requires_comment` tinyint(1) NOT NULL DEFAULT 0,
  `customer_visible` tinyint(1) NOT NULL DEFAULT 1,
  `description` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `worklog_action` enum('NONE','AUTO_START','AUTO_STOP') NOT NULL DEFAULT 'NONE',
  `downtime_action` enum('NONE','OPEN','CLOSE') NOT NULL DEFAULT 'NONE'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Zrzut danych tabeli `cmms_statuses`
--

INSERT INTO `cmms_statuses` (`id`, `category_id`, `name`, `slug`, `color`, `order_no`, `active`, `is_initial`, `is_final`, `pauses_sla`, `sets_resolved_at`, `sets_closed_at`, `requires_assignee`, `requires_comment`, `customer_visible`, `description`, `created_at`, `updated_at`, `worklog_action`, `downtime_action`) VALUES
(1, 1, 'Nowe', 'nowe', '#bababa', 10, 0, 1, 0, 0, 0, 0, 0, 0, 1, 'Start', '2025-08-21 21:59:26', '2025-09-10 19:22:09', 'NONE', 'NONE'),
(2, 2, 'W realizacji', 'w-realizacji', '#0ea5e9', 20, 1, 0, 0, 0, 0, 0, 1, 0, 1, 'Prace trwają', '2025-08-21 21:59:26', '2025-09-10 10:17:34', 'AUTO_START', 'NONE'),
(3, 3, 'W oczekiwaniu', 'w-oczekiwaniu', '#f59e0b', 30, 1, 0, 0, 1, 0, 0, 1, 1, 1, 'SLA pauza (części/kontrahent/okno)', '2025-08-21 21:59:26', '2025-09-04 09:07:24', 'NONE', 'NONE'),
(4, 4, 'Rozwiązane', 'rozwiazane', '#22c55e', 40, 0, 0, 0, 0, 1, 0, 1, 1, 1, 'Gotowe do weryfikacji', '2025-08-21 21:59:26', '2025-09-10 10:17:34', 'AUTO_STOP', 'CLOSE'),
(5, 5, 'Zamknięte', 'zamkniete', '#64748b', 50, 0, 0, 1, 0, 0, 1, 0, 0, 1, 'Formalnie zamknięte', '2025-08-21 21:59:26', '2025-09-10 10:17:34', 'AUTO_STOP', 'CLOSE'),
(6, 6, 'Anulowane', 'anulowane', '#ef4444', 60, 0, 0, 1, 0, 0, 0, 0, 1, 1, 'Wyłączone z SLA', '2025-08-21 21:59:26', '2025-09-10 10:17:34', 'AUTO_STOP', 'CLOSE'),
(8, 1, 'Nowe', 'new', '#2563eb', 10, 1, 1, 0, 0, 0, 0, 0, 0, 1, 'Start zgłoszenia', '2025-08-24 20:36:58', '2025-09-01 21:27:05', 'NONE', 'NONE'),
(9, 2, 'W realizacji', 'active', '#0ea5e9', 20, 0, 0, 0, 0, 0, 0, 0, 0, 1, 'Prace w toku', '2025-08-24 20:36:58', '2025-09-10 10:17:34', 'AUTO_START', 'NONE'),
(10, 3, 'W oczekiwaniu', 'waiting', '#f59e0b', 30, 0, 0, 0, 1, 0, 0, 0, 0, 1, 'Czekamy (pauza SLA)', '2025-08-24 20:36:58', '2025-09-04 09:07:26', 'NONE', 'NONE'),
(11, 4, 'Rozwiązane', 'resolved', '#22c55e', 40, 1, 0, 0, 0, 1, 0, 0, 1, 1, 'Rozwiązanie dostarczone', '2025-08-24 20:36:58', '2025-09-10 10:17:34', 'AUTO_STOP', 'CLOSE'),
(12, 5, 'Zamknięte', 'closed', '#64748b', 50, 1, 0, 1, 0, 0, 1, 0, 0, 1, 'Zamykamy sprawę', '2025-08-24 20:36:58', '2025-09-10 10:17:34', 'AUTO_STOP', 'CLOSE'),
(13, 6, 'Anulowane', 'canceled', '#ef4444', 60, 1, 0, 1, 0, 0, 0, 0, 1, 1, 'Odrzucamy lub porzucamy', '2025-08-24 20:36:58', '2025-09-10 10:17:34', 'AUTO_STOP', 'CLOSE'),
(14, 1, 'Pomysł sgłoszony', 'pomyslzgloszony', '#e30613', 100, 1, 1, 0, 0, 0, 0, 0, 0, 1, NULL, '2025-09-01 21:24:34', '2025-09-01 21:24:34', 'NONE', 'NONE'),
(15, 3, 'Zarezerwuj', 'zarezerwuj', '#e5c706', 100, 1, 0, 0, 0, 0, 0, 1, 0, 1, NULL, '2025-09-04 20:42:34', '2025-09-04 20:42:34', 'NONE', 'NONE'),
(16, 2, 'Realizacja', 'realizacja', '#d5df49', 100, 1, 0, 0, 0, 0, 0, 1, 0, 1, NULL, '2025-09-04 20:43:13', '2025-09-10 10:17:34', 'AUTO_START', 'NONE');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_status_categories`
--

CREATE TABLE `cmms_status_categories` (
  `id` int(10) UNSIGNED NOT NULL,
  `key` varchar(32) NOT NULL,
  `name` varchar(64) NOT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

--
-- Zrzut danych tabeli `cmms_status_categories`
--

INSERT INTO `cmms_status_categories` (`id`, `key`, `name`, `description`) VALUES
(1, 'new', 'Nowe', 'Zgłoszenie utworzone/oczekuje na podjęcie'),
(2, 'active', 'W realizacji', 'Prace trwają'),
(3, 'waiting', 'W oczekiwaniu', 'Wstrzymane: części/kontrahent/okno'),
(4, 'resolved', 'Rozwiązane', 'Naprawione – oczekuje weryfikacji'),
(5, 'closed', 'Zamknięte', 'Formalnie zamknięte'),
(6, 'canceled', 'Anulowane', 'Odrzucone/duplikat/błędne');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_status_transitions`
--

CREATE TABLE `cmms_status_transitions` (
  `id` int(11) NOT NULL,
  `workflow_id` int(10) UNSIGNED DEFAULT NULL,
  `from_status_id` int(11) DEFAULT NULL,
  `to_status_id` int(11) NOT NULL,
  `code` varchar(50) NOT NULL,
  `name` varchar(120) NOT NULL,
  `permission_key` varchar(120) DEFAULT NULL COMMENT 'Klucz uprawnienia wymagany do wykonania przejścia (np. cmms.tickets.close). Jeśli NULL – dostępne dla wszystkich z rolą CMMS',
  `set_assignee_to_current` tinyint(1) NOT NULL DEFAULT 0,
  `clear_assignee` tinyint(1) NOT NULL DEFAULT 0,
  `require_assignee` tinyint(1) NOT NULL DEFAULT 0,
  `only_reporter` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `cmms_status_transitions`
--

INSERT INTO `cmms_status_transitions` (`id`, `workflow_id`, `from_status_id`, `to_status_id`, `code`, `name`, `permission_key`, `set_assignee_to_current`, `clear_assignee`, `require_assignee`, `only_reporter`, `created_at`, `updated_at`) VALUES
(1, NULL, 1, 2, 'reserve', 'Zarezerwuj', 'cmms.tickets.work', 1, 0, 0, 0, '2025-09-04 09:35:42', '2025-09-04 09:35:42'),
(2, NULL, 2, 3, 'start', 'Rozpocznij', 'cmms.tickets.work', 0, 0, 1, 0, '2025-09-04 09:35:42', '2025-09-04 09:35:42'),
(3, NULL, 3, 4, 'pause', 'Wstrzymaj', 'cmms.tickets.work', 0, 0, 1, 0, '2025-09-04 09:35:42', '2025-09-04 09:35:42'),
(4, NULL, 4, 3, 'resume', 'Wznów', 'cmms.tickets.work', 0, 0, 1, 0, '2025-09-04 09:35:42', '2025-09-04 09:35:42'),
(5, NULL, 3, 5, 'resolve', 'Zakończ', 'cmms.tickets.work', 0, 0, 1, 0, '2025-09-04 09:35:42', '2025-09-04 09:35:42'),
(6, NULL, 5, 6, 'close', 'Zamknij', 'cmms.tickets.close', 0, 0, 0, 0, '2025-09-04 09:35:42', '2025-09-04 09:35:42'),
(7, NULL, NULL, 6, 'cancel', 'Anuluj', 'cmms.tickets.cancel', 0, 0, 0, 0, '2025-09-04 09:35:42', '2025-09-10 11:11:12'),
(8, NULL, 5, 3, 'reopen', 'Otwórz ponownie', 'cmms.tickets.reopen', 0, 0, 0, 0, '2025-09-04 09:35:42', '2025-09-04 09:35:42');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_struktura`
--

CREATE TABLE `cmms_struktura` (
  `id` int(10) UNSIGNED NOT NULL,
  `parent_id` int(10) UNSIGNED DEFAULT NULL,
  `typ_zasobu_id` int(11) DEFAULT NULL,
  `mpk_linia_id` int(11) DEFAULT NULL,
  `element_id` int(10) UNSIGNED DEFAULT NULL,
  `id_element` int(10) UNSIGNED DEFAULT NULL,
  `key` varchar(64) DEFAULT NULL,
  `nazwa` varchar(255) NOT NULL,
  `opis` text DEFAULT NULL,
  `ikona` varchar(64) DEFAULT NULL,
  `kolor` char(7) DEFAULT NULL,
  `sort_order` int(11) NOT NULL DEFAULT 0,
  `aktywny` tinyint(1) NOT NULL DEFAULT 1,
  `is_system` tinyint(1) NOT NULL DEFAULT 0,
  `depth` smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  `path` varchar(1024) DEFAULT NULL,
  `created_by` int(10) UNSIGNED DEFAULT NULL,
  `updated_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Zrzut danych tabeli `cmms_struktura`
--

INSERT INTO `cmms_struktura` (`id`, `parent_id`, `typ_zasobu_id`, `mpk_linia_id`, `element_id`, `id_element`, `key`, `nazwa`, `opis`, `ikona`, `kolor`, `sort_order`, `aktywny`, `is_system`, `depth`, `path`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(1, NULL, NULL, NULL, NULL, NULL, 'root', 'Zakład', NULL, '🏭', '#E30613', 1, 1, 1, 0, '/1', NULL, 1, '2025-08-28 20:06:15', '2025-09-11 13:23:45'),
(7, 1, 1, 1, 4, NULL, NULL, 'Budynek produkcyjny G2', NULL, NULL, NULL, 2, 1, 0, 1, '/1/7', 1, 1, '2025-08-29 09:10:56', '2025-09-11 13:23:45'),
(8, 7, NULL, 1, 5, NULL, NULL, 'Linia', NULL, NULL, NULL, 1, 1, 0, 2, '/1/7/8', 1, 1, '2025-08-29 09:11:54', '2025-09-11 13:23:45'),
(9, 20, 2, 1, 6, NULL, NULL, 'Zamykarka', NULL, NULL, NULL, 1, 1, 0, 4, '/1/7/8/20/9', 1, 1, '2025-08-29 09:13:11', '2025-09-11 13:23:46'),
(17, 19, 2, 1, 6, NULL, NULL, 'Dozownica', NULL, NULL, NULL, 2, 1, 0, 4, '/1/7/8/19/17', 1, 1, '2025-08-30 15:34:02', '2025-09-11 13:23:46'),
(18, 22, 1, 1, 6, NULL, NULL, 'Etykieciarka', NULL, NULL, NULL, 1, 1, 0, 4, '/1/7/8/22/18', 1, 1, '2025-08-30 15:34:29', '2025-09-11 13:23:45'),
(19, 8, 3, 2, 7, NULL, NULL, 'Obszar kuchni', NULL, NULL, NULL, 2, 1, 0, 3, '/1/7/8/19', 1, 1, '2025-09-01 19:53:53', '2025-09-11 13:23:45'),
(20, 8, NULL, NULL, 7, NULL, NULL, 'Obszar dozowania', NULL, NULL, NULL, 1, 1, 0, 3, '/1/7/8/20', 1, 1, '2025-09-01 19:58:22', '2025-09-11 13:23:45'),
(21, 19, 1, NULL, 6, NULL, NULL, 'Kuchnia', NULL, NULL, NULL, 1, 1, 0, 4, '/1/7/8/19/21', 1, 1, '2025-09-01 19:58:47', '2025-09-11 13:23:45'),
(22, 8, NULL, NULL, 7, NULL, NULL, 'Obszar etykietowania', NULL, NULL, NULL, 3, 1, 0, 3, '/1/7/8/22', 1, 1, '2025-09-01 19:59:24', '2025-09-11 13:23:45'),
(23, 1, NULL, NULL, 4, NULL, NULL, 'Budynek magazynowy G1', NULL, NULL, NULL, 1, 1, 0, 1, '/1/23', 1, 1, '2025-09-10 11:54:11', '2025-09-11 13:23:45'),
(24, 23, NULL, NULL, 5, NULL, NULL, 'Linia A', NULL, NULL, NULL, 1, 1, 0, 2, '/1/23/24', 5, 1, '2025-09-10 19:12:41', '2025-09-11 13:23:46'),
(25, 29, 2, NULL, 6, NULL, NULL, 'Urządzenie A', NULL, NULL, NULL, 4, 1, 0, 4, '/1/23/24/29/25', 1, 1, '2025-09-10 19:25:54', '2025-09-11 13:23:46'),
(26, 29, NULL, NULL, 6, NULL, NULL, 'Urządzenie B', NULL, NULL, NULL, 2, 1, 0, 4, '/1/23/24/29/26', 1, 1, '2025-09-10 19:26:24', '2025-09-11 13:23:46'),
(27, 29, NULL, NULL, 6, NULL, NULL, 'Urządzenie C', NULL, NULL, NULL, 5, 1, 0, 4, '/1/23/24/29/27', 1, 1, '2025-09-10 19:36:07', '2025-09-11 13:23:46'),
(28, 29, NULL, NULL, 6, NULL, NULL, 'Urządzenie C', NULL, NULL, NULL, 3, 1, 0, 4, '/1/23/24/29/28', 1, 1, '2025-09-10 19:43:04', '2025-09-11 13:23:46'),
(29, 24, NULL, NULL, 7, NULL, NULL, 'Obszar A', NULL, NULL, NULL, 1, 1, 0, 3, '/1/23/24/29', 1, 1, '2025-09-10 20:43:45', '2025-09-11 13:23:46'),
(31, 18, 4, 2, 7, NULL, NULL, 'tesst', NULL, NULL, NULL, 1, 1, 0, 5, '/1/7/8/22/18/31', 1, 1, '2025-09-11 13:22:24', '2025-09-11 13:23:45'),
(32, 18, NULL, NULL, 8, NULL, NULL, 'tst', NULL, NULL, NULL, 2, 1, 0, 5, '/1/7/8/22/18/32', 1, 1, '2025-09-11 13:22:40', '2025-09-11 13:23:45'),
(33, 29, NULL, NULL, 4, NULL, NULL, 'tet', NULL, NULL, NULL, 1, 1, 0, 4, '/1/23/24/29/33', 1, 1, '2025-09-11 13:22:50', '2025-09-11 13:23:46');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_subtype_responsibility`
--

CREATE TABLE `cmms_subtype_responsibility` (
  `id` int(10) UNSIGNED NOT NULL,
  `subtype_id` int(10) UNSIGNED NOT NULL,
  `responsibility_id` int(10) UNSIGNED NOT NULL,
  `escalation_order` int(11) NOT NULL DEFAULT 1,
  `active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `cmms_subtype_responsibility`
--

INSERT INTO `cmms_subtype_responsibility` (`id`, `subtype_id`, `responsibility_id`, `escalation_order`, `active`) VALUES
(1, 1, 1, 1, 1),
(3, 2, 2, 1, 1),
(4, 2, 1, 2, 1);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_tickets`
--

CREATE TABLE `cmms_tickets` (
  `id` int(10) UNSIGNED NOT NULL,
  `title` varchar(160) NOT NULL,
  `description` text DEFAULT NULL,
  `priority` enum('low','normal','high','urgent') DEFAULT 'normal',
  `type_id` int(10) UNSIGNED NOT NULL,
  `subtype_id` int(10) UNSIGNED NOT NULL,
  `workflow_id` int(10) UNSIGNED DEFAULT NULL,
  `status_id` int(10) UNSIGNED NOT NULL,
  `struktura_id` int(10) UNSIGNED NOT NULL,
  `responsibility_id` int(10) UNSIGNED DEFAULT NULL,
  `group_id` int(10) UNSIGNED DEFAULT NULL,
  `resource_id` bigint(20) DEFAULT NULL,
  `reporter_id` int(11) NOT NULL,
  `mpk_id` int(10) UNSIGNED NOT NULL,
  `asset_type_id` int(10) UNSIGNED DEFAULT NULL,
  `asset_id` int(10) UNSIGNED DEFAULT NULL,
  `assignee_id` int(11) DEFAULT NULL,
  `due_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `cmms_tickets`
--

INSERT INTO `cmms_tickets` (`id`, `title`, `description`, `priority`, `type_id`, `subtype_id`, `workflow_id`, `status_id`, `struktura_id`, `responsibility_id`, `group_id`, `resource_id`, `reporter_id`, `mpk_id`, `asset_type_id`, `asset_id`, `assignee_id`, `due_at`, `created_at`, `updated_at`, `created_by`, `updated_by`) VALUES
(1, 'test', 'test', 'normal', 1, 1, NULL, 1, 17, 1, NULL, NULL, 1, 0, NULL, NULL, 18, NULL, '2025-08-21 13:12:34', '2025-08-21 22:28:10', NULL, NULL),
(2, 'Stoi', 'Zatarty tlok', 'normal', 1, 1, NULL, 1, 17, 1, NULL, NULL, 1, 0, NULL, NULL, 18, NULL, '2025-08-21 16:00:06', '2025-09-02 09:24:59', NULL, NULL),
(3, 'test', 'test', 'normal', 1, 1, NULL, 2, 18, 1, NULL, NULL, 1, 0, NULL, NULL, 21, NULL, '2025-08-21 22:51:25', '2025-08-25 07:55:57', NULL, NULL),
(4, 'Fgh', 'Ghjj', 'normal', 1, 1, NULL, 6, 17, 1, NULL, NULL, 1, 0, NULL, NULL, 18, NULL, '2025-08-22 12:30:22', '2025-09-02 09:25:07', NULL, NULL),
(5, 'Test czasu', 'test czasu', 'normal', 1, 1, NULL, 2, 18, 1, NULL, NULL, 1, 0, NULL, NULL, 18, NULL, '2025-08-25 08:52:46', '2025-09-02 09:25:36', NULL, NULL),
(6, 'Tds', 'Fgh', 'normal', 1, 1, NULL, 2, 17, 1, NULL, NULL, 1, 0, NULL, NULL, 18, NULL, '2025-08-25 09:16:16', '2025-09-02 09:25:44', NULL, NULL),
(7, 'Hujnia', 'Gggg', 'urgent', 1, 1, NULL, 2, 18, 1, NULL, NULL, 1, 0, NULL, NULL, 5, NULL, '2025-08-27 12:33:00', '2025-09-02 09:25:52', NULL, NULL),
(8, 'Klej', 'Kapiący klej', 'normal', 1, 1, NULL, 2, 17, 1, NULL, NULL, 1, 0, NULL, NULL, 19, NULL, '2025-08-28 09:30:31', '2025-09-02 09:26:14', NULL, NULL),
(29, 'test', 'tst', 'normal', 1, 1, NULL, 1, 18, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL, '2025-09-03 10:21:58', '2025-09-03 10:21:58', NULL, NULL),
(32, 'test', 'test', 'normal', 1, 1, NULL, 1, 17, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL, '2025-09-03 10:33:49', '2025-09-03 10:33:49', NULL, NULL),
(33, '1', '1', 'normal', 1, 1, NULL, 1, 17, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL, '2025-09-03 10:34:29', '2025-09-03 10:34:29', NULL, NULL),
(34, '2', '2', 'normal', 1, 1, NULL, 1, 21, NULL, NULL, NULL, 1, 1, NULL, NULL, NULL, NULL, '2025-09-03 10:35:21', '2025-09-03 10:35:21', NULL, NULL),
(50, '1', '2', 'normal', 1, 1, NULL, 1, 1, NULL, NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '2025-09-03 12:22:28', '2025-09-03 12:22:28', NULL, NULL),
(52, '1', '1', 'normal', 1, 1, NULL, 1, 1, 1, NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '2025-09-03 12:35:35', '2025-09-03 12:35:35', NULL, NULL),
(53, '1', '1', 'normal', 1, 1, NULL, 1, 20, 1, NULL, NULL, 1, 1, NULL, NULL, 25, NULL, '2025-09-03 12:48:05', '2025-09-03 12:48:05', NULL, NULL),
(54, '3', '3', 'normal', 1, 1, NULL, 3, 1, 1, NULL, NULL, 1, 0, NULL, NULL, 1, NULL, '2025-09-03 12:48:18', '2025-09-04 14:12:28', NULL, NULL),
(55, '2', '1', 'normal', 1, 1, NULL, 4, 19, 1, NULL, NULL, 1, 2, NULL, NULL, 1, NULL, '2025-09-03 12:48:44', '2025-09-04 14:16:00', NULL, NULL),
(56, 'd', 'd', 'normal', 1, 1, NULL, 4, 1, 1, NULL, NULL, 1, 0, NULL, NULL, 1, '2025-09-10 12:00:00', '2025-09-03 13:40:44', '2025-09-04 14:26:06', NULL, NULL),
(57, 'Rrr', 'Rrr', 'normal', 1, 1, NULL, 3, 18, 1, NULL, NULL, 1, 1, NULL, NULL, 1, '2025-09-06 16:37:00', '2025-09-03 16:37:50', '2025-09-04 14:07:26', NULL, NULL),
(58, 'Test123', 'Test', 'normal', 2, 2, NULL, 1, 21, 2, NULL, NULL, 1, 1, NULL, NULL, 25, '2025-09-06 18:38:00', '2025-09-03 18:38:34', '2025-09-03 18:38:34', NULL, NULL),
(59, 'Test', 'T', 'normal', 2, 2, NULL, 1, 8, 2, NULL, NULL, 1, 1, NULL, NULL, 29, '2025-09-04 18:41:00', '2025-09-03 18:42:03', '2025-09-03 18:42:03', NULL, NULL),
(60, 'Akdjd', 'Jdjdn', 'high', 2, 2, NULL, 1, 9, 2, NULL, NULL, 1, 1, NULL, NULL, 29, '2025-09-04 20:17:00', '2025-09-03 20:18:04', '2025-09-03 20:18:04', NULL, NULL),
(61, 'stres', 'tres', 'normal', 2, 2, NULL, 2, 19, 2, NULL, NULL, 1, 2, NULL, NULL, 1, NULL, '2025-09-03 21:29:23', '2025-09-04 11:24:40', NULL, NULL),
(67, 'as', 'as', 'normal', 2, 2, NULL, 3, 19, 2, NULL, NULL, 1, 2, NULL, NULL, 1, NULL, '2025-09-04 08:10:15', '2025-09-04 11:19:00', NULL, NULL),
(68, 'dcd', 'dcd', 'normal', 2, 2, 3, 11, 9, 2, NULL, NULL, 1, 1, NULL, NULL, 1, '2025-09-07 12:20:31', '2025-09-04 12:21:10', '2025-09-05 00:22:21', NULL, NULL),
(69, 'A1', 'A1', 'normal', 1, 5, NULL, 4, 18, NULL, NULL, NULL, 1, 1, NULL, NULL, 1, NULL, '2025-09-04 14:17:04', '2025-09-04 20:34:42', NULL, NULL),
(70, 'test', 'test', 'normal', 1, 1, NULL, 2, 8, 1, NULL, NULL, 1, 1, NULL, NULL, 1, NULL, '2025-09-04 20:52:12', '2025-09-04 22:22:21', NULL, NULL),
(71, 'q1', 'q1', 'low', 2, 2, NULL, 1, 18, 2, NULL, NULL, 1, 1, NULL, NULL, 13, NULL, '2025-09-04 22:25:00', '2025-09-04 22:25:00', NULL, NULL),
(72, 'Fru', 'Fru', 'normal', 2, 2, NULL, 1, 9, 2, NULL, NULL, 1, 1, NULL, NULL, 16, '2025-09-07 09:29:00', '2025-09-05 09:29:46', '2025-09-05 09:29:46', NULL, NULL),
(73, 'A', 'A', 'normal', 1, 1, 3, 1, 20, 1, NULL, NULL, 1, 1, NULL, NULL, 25, '2025-09-06 12:20:00', '2025-09-05 12:20:59', '2025-09-05 12:20:59', NULL, NULL),
(74, 'Test sieci', 'Test sieci', 'high', 1, 1, 3, 11, 7, 1, NULL, NULL, 1, 1, NULL, NULL, NULL, '2025-09-05 12:27:00', '2025-09-05 12:27:30', '2025-09-05 12:43:07', NULL, NULL),
(76, 'teet', 'teet', 'normal', 2, 2, NULL, 2, 8, NULL, 2, NULL, 1, 1, NULL, NULL, NULL, NULL, '2025-09-08 13:18:36', '2025-09-08 13:19:37', NULL, NULL),
(77, 't1', 't1', 'normal', 2, 2, NULL, 1, 8, NULL, 2, NULL, 1, 1, NULL, NULL, NULL, NULL, '2025-09-08 13:23:50', '2025-09-08 13:23:50', NULL, NULL),
(78, 'test user', 'test user', 'normal', 1, 5, 3, 12, 8, NULL, 2, NULL, 1, 1, NULL, NULL, 18, '2025-09-10 22:00:00', '2025-09-09 22:07:56', '2025-09-11 19:20:31', 1, NULL),
(79, 'x batsv', 'vQEfbd', 'urgent', 2, 2, NULL, 3, 1, NULL, 2, NULL, 1, 0, NULL, NULL, 19, '2025-09-10 11:31:00', '2025-09-10 11:31:44', '2025-09-10 19:15:47', 1, NULL),
(80, 'Fontea Test', 'test', 'normal', 1, 1, 3, 6, 17, NULL, 1, NULL, 1, 1, NULL, NULL, NULL, '2025-09-14 16:00:40', '2025-09-11 13:18:33', '2025-09-11 13:20:00', 1, NULL),
(81, 'test', 'test', 'normal', 1, 5, 3, 6, 24, NULL, 2, NULL, 1, 0, NULL, NULL, NULL, NULL, '2025-09-11 17:57:04', '2025-09-11 19:16:19', 1, NULL),
(82, 'test', 'test', 'normal', 1, 1, 3, 12, 25, NULL, 1, NULL, 1, 0, NULL, NULL, 1, NULL, '2025-09-11 19:30:15', '2025-09-15 07:32:42', 1, NULL),
(83, 'test', 'test', 'normal', 1, 15, 3, 8, 23, NULL, 2, NULL, 1, 0, NULL, NULL, NULL, NULL, '2025-09-15 19:55:16', '2025-09-15 19:55:16', 1, NULL),
(84, 'tm', 'tm', 'normal', 1, 5, 3, 3, 23, NULL, 2, NULL, 1, 0, NULL, NULL, 1, NULL, '2025-09-15 21:05:24', '2025-09-16 22:40:38', 1, NULL);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_ticket_comments`
--

CREATE TABLE `cmms_ticket_comments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `ticket_id` bigint(20) UNSIGNED NOT NULL,
  `author_id` int(11) NOT NULL,
  `body` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_ticket_downtime`
--

CREATE TABLE `cmms_ticket_downtime` (
  `id` int(10) UNSIGNED NOT NULL,
  `ticket_id` int(10) UNSIGNED NOT NULL,
  `start_at` datetime NOT NULL,
  `end_at` datetime DEFAULT NULL,
  `minutes` int(10) UNSIGNED GENERATED ALWAYS AS (case when `end_at` is null then NULL else timestampdiff(MINUTE,`start_at`,`end_at`) end) VIRTUAL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_ticket_files`
--

CREATE TABLE `cmms_ticket_files` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `ticket_id` int(10) UNSIGNED NOT NULL,
  `original_name` varchar(190) NOT NULL,
  `stored_name` varchar(190) NOT NULL,
  `mime` varchar(100) NOT NULL,
  `size_bytes` int(10) UNSIGNED NOT NULL,
  `width` int(10) UNSIGNED DEFAULT NULL,
  `height` int(10) UNSIGNED DEFAULT NULL,
  `thumb_name` varchar(190) DEFAULT NULL,
  `checksum_sha1` char(40) DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `cmms_ticket_files`
--

INSERT INTO `cmms_ticket_files` (`id`, `ticket_id`, `original_name`, `stored_name`, `mime`, `size_bytes`, `width`, `height`, `thumb_name`, `checksum_sha1`, `created_by`, `created_at`) VALUES
(7, 8, '20250704_101603.jpg', 'T000008_20250902_195444_001_U00001_6b96.jpg', 'image/jpeg', 188886, 1600, 1200, 'T000008_20250902_195444_001_U00001_6b96_th.jpg', '45f051983a7664c53239ceb2c7899411e1146795', 1, '2025-09-02 19:54:45'),
(8, 8, 'cam_20250902184138.jpg', 'T000008_20250902_204145_002_U00001_21ef.jpg', 'image/jpeg', 100650, 1280, 720, 'T000008_20250902_204145_002_U00001_21ef_th.jpg', '2521f08ab9423316b68adf81e0a1c233d522ccb2', 1, '2025-09-02 20:41:45'),
(11, 8, '17568387048352119082093779803332.jpg', 'T000008_20250902_204513_003_U00001_afe9.jpg', 'image/jpeg', 116885, 1200, 1600, 'T000008_20250902_204513_003_U00001_afe9_th.jpg', 'fda333ef4c19d074ce00f0a8fbf2f40d1ec91ce8', 1, '2025-09-02 20:45:15'),
(12, 8, 'image.jpg', 'T000008_20250902_204655_004_U00001_beb4.jpg', 'image/jpeg', 248882, 1600, 1200, 'T000008_20250902_204655_004_U00001_beb4_th.jpg', 'fb369af9c9fcbda05ba1ca2df8364df9e1f742c2', 1, '2025-09-02 20:46:57'),
(13, 7, '17568753601888400557972380912081.jpg', 'T000007_20250903_065615_001_U00001_a1fe.jpg', 'image/jpeg', 379164, 1600, 1200, 'T000007_20250903_065615_001_U00001_a1fe_th.jpg', '3ea5a5edc9f2c97f18686090459208819a67f3cc', 1, '2025-09-03 06:56:16'),
(14, 57, '1756910277548765582446896288400.jpg', 'T000057_20250903_163808_001_U00001_c51f.jpg', 'image/jpeg', 48978, 1200, 1600, 'T000057_20250903_163808_001_U00001_c51f_th.jpg', 'f74a14ec8fb85cf360012c29c7c01b2346f6c924', 1, '2025-09-03 16:38:10'),
(15, 58, '17569175200645904834831442510889.jpg', 'T000058_20250903_183851_001_U00001_c1ce.jpg', 'image/jpeg', 360982, 1200, 1600, 'T000058_20250903_183851_001_U00001_c1ce_th.jpg', 'c6090fff55628f054be7dd39a3fe047531e734dc', 1, '2025-09-03 18:38:53'),
(16, 60, '17569234922162621355019575989652.jpg', 'T000060_20250903_201822_001_U00001_fe97.jpg', 'image/jpeg', 99524, 1200, 1600, 'T000060_20250903_201822_001_U00001_fe97_th.jpg', 'd1ce1201dc1040c2ff4c7b73d60366b4e00f2ce8', 1, '2025-09-03 20:18:23'),
(17, 61, '17569663539518179839505179453293.jpg', 'T000061_20250904_081248_001_U00001_09e1.jpg', 'image/jpeg', 151467, 1200, 1600, 'T000061_20250904_081248_001_U00001_09e1_th.jpg', '0964404f316012284436bffe1ca5e215087dde9a', 1, '2025-09-04 08:12:49'),
(18, 68, '17569813477064454323340610957976.jpg', 'T000068_20250904_122237_001_U00001_9ab1.jpg', 'image/jpeg', 139598, 1200, 1600, 'T000068_20250904_122237_001_U00001_9ab1_th.jpg', '4ef56146eb3325520c75d89abda524adfbc0f25f', 1, '2025-09-04 12:22:39'),
(19, 68, 'Maspex 4.0.jpg', 'T000068_20250905_092831_002_U00001_6506.jpg', 'image/jpeg', 168568, 1024, 1024, 'T000068_20250905_092831_002_U00001_6506_th.jpg', 'b713d9c5d1e82ac8b32ef3ff099cea2b2a4950ec', 1, '2025-09-05 09:28:32'),
(20, 68, '17570573283765170342366285291279.jpg', 'T000068_20250905_092857_003_U00001_e123.jpg', 'image/jpeg', 146200, 1200, 1600, 'T000068_20250905_092857_003_U00001_e123_th.jpg', '0284881b1b5bcc9d3864b54639f8461c07e64110', 1, '2025-09-05 09:28:58'),
(24, 74, '17570681415208668202917408670315.jpg', 'T000074_20250905_122935_001_U00001_f7c2.jpg', 'image/jpeg', 274052, 1600, 1200, 'T000074_20250905_122935_001_U00001_f7c2_th.jpg', 'f3b59afebebfe8d838fea4190a6bbe4d06ee47c6', 1, '2025-09-05 12:29:39'),
(25, 74, '1757068379925457925193068362490.jpg', 'T000074_20250905_123309_002_U00001_ca88.jpg', 'image/jpeg', 424113, 1200, 1600, 'T000074_20250905_123309_002_U00001_ca88_th.jpg', 'aad4c766c1b6a567dcd6417891e59b9cd08c36cb', 1, '2025-09-05 12:33:12'),
(26, 74, '1757068296542485372232638203241.jpg', 'T000074_20250905_123314_003_U00001_784f.jpg', 'image/jpeg', 641745, 1600, 1200, 'T000074_20250905_123314_003_U00001_784f_th.jpg', '6d8a336947086c70a705b1045c44afd869b885eb', 1, '2025-09-05 12:33:17'),
(27, 74, '17570684589342674354817872021917.jpg', 'T000074_20250905_123454_004_U00001_6560.jpg', 'image/jpeg', 114652, 1200, 1600, 'T000074_20250905_123454_004_U00001_6560_th.jpg', 'e5e88492b4f2d008c85a8e51ffd7659b86f70dad', 1, '2025-09-05 12:34:55'),
(28, 74, '17570686171221895810417819957267.jpg', 'T000074_20250905_123724_005_U00001_2491.jpg', 'image/jpeg', 383523, 1600, 1200, 'T000074_20250905_123724_005_U00001_2491_th.jpg', 'b08c28bb67a81017c6a1f42d33be7114baabe5bb', 1, '2025-09-05 12:37:25'),
(29, 74, '17570688045921424221471409246424.jpg', 'T000074_20250905_124013_006_U00001_2110.jpg', 'image/jpeg', 239772, 1600, 1200, 'T000074_20250905_124013_006_U00001_2110_th.jpg', 'ceb3a96dc94b81d2503b35d0abab30bafcaa3dff', 1, '2025-09-05 12:40:14'),
(30, 77, 'Multimedia _23_.jpg', 'T000077_20250908_132421_001_U00001_4a0b.jpg', 'image/jpeg', 221027, 1200, 1600, 'T000077_20250908_132421_001_U00001_4a0b_th.jpg', '86899b1b4705f76853ee0d4b9a383885c77a6a59', 1, '2025-09-08 13:24:22'),
(31, 78, 'Multimedia _24_.jpg', 'T000078_20250910_193720_001_U00001_a5ad.jpg', 'image/jpeg', 143059, 1200, 1600, 'T000078_20250910_193720_001_U00001_a5ad_th.jpg', 'c51c1453b6b078e1a1f08f11d19116c4c05b5dc0', 1, '2025-09-10 19:37:20'),
(32, 80, 'Multimedia _24_.jpg', 'T000080_20250911_131902_001_U00001_229e.jpg', 'image/jpeg', 143059, 1200, 1600, 'T000080_20250911_131902_001_U00001_229e_th.jpg', 'c51c1453b6b078e1a1f08f11d19116c4c05b5dc0', 1, '2025-09-11 13:19:02'),
(33, 84, '91511032-woman-in-office-portrait-of-female-worker-standing-in-bright-working-environment-smiling-business.jpg', 'T000084_20250916_221827_001_U00001_dd55.jpg', 'image/jpeg', 97524, 866, 1300, 'T000084_20250916_221827_001_U00001_dd55_th.jpg', 'afa88e782691f21003b9f6678524b7ca155d8ebb', 1, '2025-09-16 22:18:27'),
(34, 84, '17580556798795077302647828329325.jpg', 'T000084_20250916_224811_002_U00001_f4b8.jpg', 'image/jpeg', 137156, 1200, 1600, 'T000084_20250916_224811_002_U00001_f4b8_th.jpg', '3ff655f160921351b578441ae79d1276d9b68fbf', 1, '2025-09-16 22:48:12'),
(35, 84, '17580577011468507072225770884495.jpg', 'T000084_20250916_232147_003_U00001_8b72.jpg', 'image/jpeg', 174054, 1200, 1600, 'T000084_20250916_232147_003_U00001_8b72_th.jpg', '1e3d49bd46efb35a9385a3ebf5b5e5fa4460a013', 1, '2025-09-16 23:21:48'),
(37, 84, '17580577968436425823612113032439.jpg', 'T000084_20250916_232325_004_U00001_ef15.jpg', 'image/jpeg', 86209, 1200, 1600, 'T000084_20250916_232325_004_U00001_ef15_th.jpg', '893636d044d75c1b2650527ad7ae00ea422fd14b', 1, '2025-09-16 23:23:26'),
(38, 84, '17580577968436425823612113032439.jpg', 'T000084_20250916_232326_005_U00001_de7a.jpg', 'image/jpeg', 87943, 1200, 1600, 'T000084_20250916_232326_005_U00001_de7a_th.jpg', 'a4c3e9714da8fabd69172fa0e379a4df8b3e8d68', 1, '2025-09-16 23:23:27');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_ticket_notifications`
--

CREATE TABLE `cmms_ticket_notifications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `ticket_id` bigint(20) UNSIGNED NOT NULL,
  `responsibility_id` int(10) UNSIGNED DEFAULT NULL,
  `channel` enum('email','sms','webhook') NOT NULL,
  `recipient` varchar(190) NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`payload`)),
  `status` enum('pending','sent','error') NOT NULL DEFAULT 'pending',
  `error_msg` varchar(255) DEFAULT NULL,
  `scheduled_at` datetime NOT NULL DEFAULT current_timestamp(),
  `sent_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_ticket_status_history`
--

CREATE TABLE `cmms_ticket_status_history` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `ticket_id` bigint(20) UNSIGNED NOT NULL,
  `old_status` varchar(32) DEFAULT NULL,
  `new_status` varchar(32) NOT NULL,
  `changed_by` int(11) NOT NULL,
  `note` varchar(255) DEFAULT NULL,
  `changed_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_ticket_status_log`
--

CREATE TABLE `cmms_ticket_status_log` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `ticket_id` int(10) UNSIGNED NOT NULL,
  `from_status_id` int(10) UNSIGNED DEFAULT NULL,
  `to_status_id` int(10) UNSIGNED NOT NULL,
  `transition_id` int(11) DEFAULT NULL,
  `workflow_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `comment` text DEFAULT NULL,
  `reason_code` varchar(64) DEFAULT NULL,
  `changed_at` datetime NOT NULL DEFAULT current_timestamp(),
  `time_in_prev` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `time_in_prev_s` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Zrzut danych tabeli `cmms_ticket_status_log`
--

INSERT INTO `cmms_ticket_status_log` (`id`, `ticket_id`, `from_status_id`, `to_status_id`, `transition_id`, `workflow_id`, `user_id`, `comment`, `reason_code`, `changed_at`, `time_in_prev`, `created_at`, `time_in_prev_s`) VALUES
(1, 4, 1, 6, NULL, NULL, 1, 'Bo tak chce', 'Czekamy na części pół roku', '2025-08-24 21:53:58', NULL, '2025-08-24 21:53:58', NULL),
(2, 3, 1, 2, NULL, NULL, 1, NULL, NULL, '2025-08-25 07:41:47', NULL, '2025-08-25 07:41:47', NULL),
(3, 3, 2, 3, NULL, NULL, 1, NULL, 'nie ma części', '2025-08-25 07:42:24', 37, '2025-08-25 07:42:24', NULL),
(4, 3, 3, 2, NULL, NULL, 1, NULL, NULL, '2025-08-25 07:55:57', 813, '2025-08-25 07:55:57', NULL),
(5, 5, NULL, 1, NULL, NULL, 1, NULL, NULL, '2025-08-25 08:52:46', NULL, '2025-08-25 08:52:46', NULL),
(6, 5, 1, 2, NULL, NULL, 1, NULL, NULL, '2025-08-25 08:53:05', 19, '2025-08-25 08:53:05', NULL),
(7, 6, NULL, 1, NULL, NULL, 1, NULL, NULL, '2025-08-25 09:16:16', NULL, '2025-08-25 09:16:16', NULL),
(8, 6, 1, 2, NULL, NULL, 1, NULL, NULL, '2025-08-25 09:16:36', 19, '2025-08-25 09:16:36', NULL),
(9, 7, NULL, 1, NULL, NULL, 1, NULL, NULL, '2025-08-27 12:33:00', NULL, '2025-08-27 12:33:00', NULL),
(10, 7, 1, 2, NULL, NULL, 1, NULL, NULL, '2025-08-28 07:57:49', 69889, '2025-08-28 07:57:49', NULL),
(11, 8, NULL, 1, NULL, NULL, 1, NULL, NULL, '2025-08-28 09:30:31', NULL, '2025-08-28 09:30:31', NULL),
(12, 8, 1, 2, NULL, NULL, 1, NULL, NULL, '2025-08-29 14:00:09', 102578, '2025-08-29 14:00:09', NULL),
(13, 33, NULL, 1, NULL, NULL, 1, 'Utworzenie zgłoszenia', NULL, '2025-09-03 10:34:29', NULL, '2025-09-03 10:34:29', NULL),
(14, 34, NULL, 1, NULL, NULL, 1, 'Utworzenie zgłoszenia', NULL, '2025-09-03 10:35:21', NULL, '2025-09-03 10:35:21', NULL),
(15, 50, NULL, 1, NULL, NULL, 1, 'Utworzenie zgłoszenia', NULL, '2025-09-03 12:22:28', NULL, '2025-09-03 12:22:28', NULL),
(16, 52, NULL, 1, NULL, NULL, 1, 'Utworzenie zgłoszenia', NULL, '2025-09-03 12:35:35', NULL, '2025-09-03 12:35:35', NULL),
(17, 53, NULL, 1, NULL, NULL, 1, 'Utworzenie zgłoszenia', NULL, '2025-09-03 12:48:05', NULL, '2025-09-03 12:48:05', NULL),
(18, 54, NULL, 1, NULL, NULL, 1, 'Utworzenie zgłoszenia', NULL, '2025-09-03 12:48:18', NULL, '2025-09-03 12:48:18', NULL),
(19, 55, NULL, 1, NULL, NULL, 1, 'Utworzenie zgłoszenia', NULL, '2025-09-03 12:48:44', NULL, '2025-09-03 12:48:44', NULL),
(20, 56, NULL, 1, NULL, NULL, 1, 'Utworzenie zgłoszenia', NULL, '2025-09-03 13:40:44', NULL, '2025-09-03 13:40:44', NULL),
(21, 57, NULL, 1, NULL, NULL, 1, 'Utworzenie zgłoszenia', NULL, '2025-09-03 16:37:50', NULL, '2025-09-03 16:37:50', NULL),
(22, 58, NULL, 1, NULL, NULL, 1, 'Utworzenie zgłoszenia', NULL, '2025-09-03 18:38:34', NULL, '2025-09-03 18:38:34', NULL),
(23, 59, NULL, 1, NULL, NULL, 1, 'Utworzenie zgłoszenia', NULL, '2025-09-03 18:42:03', NULL, '2025-09-03 18:42:03', NULL),
(24, 60, NULL, 1, NULL, NULL, 1, 'Utworzenie zgłoszenia', NULL, '2025-09-03 20:18:04', NULL, '2025-09-03 20:18:04', NULL),
(25, 61, NULL, 1, NULL, NULL, 1, 'Utworzenie zgłoszenia', NULL, '2025-09-03 21:29:23', NULL, '2025-09-03 21:29:23', NULL),
(26, 67, NULL, 1, NULL, NULL, 1, 'Utworzenie zgłoszenia', NULL, '2025-09-04 08:10:15', NULL, '2025-09-04 08:10:15', NULL),
(27, 67, 1, 2, NULL, NULL, 1, NULL, NULL, '2025-09-04 10:26:07', NULL, '2025-09-04 10:26:07', NULL),
(28, 67, 2, 3, NULL, NULL, 1, NULL, NULL, '2025-09-04 11:19:00', NULL, '2025-09-04 11:19:00', NULL),
(29, 61, 1, 2, NULL, NULL, 1, NULL, NULL, '2025-09-04 11:24:40', NULL, '2025-09-04 11:24:40', NULL),
(30, 68, NULL, 1, NULL, NULL, 1, 'Utworzenie zgłoszenia', NULL, '2025-09-04 12:21:10', NULL, '2025-09-04 12:21:10', NULL),
(31, 68, 1, 2, NULL, NULL, 1, NULL, NULL, '2025-09-04 12:21:28', NULL, '2025-09-04 12:21:28', NULL),
(32, 68, 2, 3, NULL, NULL, 1, NULL, NULL, '2025-09-04 12:21:34', NULL, '2025-09-04 12:21:34', NULL),
(33, 68, 3, 4, NULL, NULL, 1, NULL, NULL, '2025-09-04 12:21:39', NULL, '2025-09-04 12:21:39', NULL),
(34, 57, 1, 2, NULL, NULL, 1, NULL, NULL, '2025-09-04 14:07:09', NULL, '2025-09-04 14:07:09', NULL),
(35, 57, 2, 3, NULL, NULL, 1, NULL, NULL, '2025-09-04 14:07:13', NULL, '2025-09-04 14:07:13', NULL),
(36, 57, 3, 4, NULL, NULL, 1, NULL, NULL, '2025-09-04 14:07:20', NULL, '2025-09-04 14:07:20', NULL),
(37, 57, 4, 3, NULL, NULL, 1, NULL, NULL, '2025-09-04 14:07:26', NULL, '2025-09-04 14:07:26', NULL),
(38, 54, 1, 2, NULL, NULL, 1, NULL, NULL, '2025-09-04 14:12:18', NULL, '2025-09-04 14:12:18', NULL),
(39, 54, 2, 3, NULL, NULL, 1, NULL, NULL, '2025-09-04 14:12:20', NULL, '2025-09-04 14:12:20', NULL),
(40, 54, 3, 4, NULL, NULL, 1, NULL, NULL, '2025-09-04 14:12:25', NULL, '2025-09-04 14:12:25', NULL),
(41, 54, 4, 3, NULL, NULL, 1, NULL, NULL, '2025-09-04 14:12:28', NULL, '2025-09-04 14:12:28', NULL),
(42, 55, 1, 2, NULL, NULL, 1, NULL, NULL, '2025-09-04 14:15:48', NULL, '2025-09-04 14:15:48', NULL),
(43, 55, 2, 3, NULL, NULL, 1, NULL, NULL, '2025-09-04 14:15:52', NULL, '2025-09-04 14:15:52', NULL),
(44, 55, 3, 4, NULL, NULL, 1, NULL, NULL, '2025-09-04 14:16:00', NULL, '2025-09-04 14:16:00', NULL),
(45, 69, NULL, 1, NULL, NULL, 1, 'Utworzenie zgłoszenia', NULL, '2025-09-04 14:17:04', NULL, '2025-09-04 14:17:04', NULL),
(46, 69, 1, 2, NULL, NULL, 1, NULL, NULL, '2025-09-04 14:17:08', NULL, '2025-09-04 14:17:08', NULL),
(47, 69, 2, 3, NULL, NULL, 1, NULL, NULL, '2025-09-04 14:17:10', NULL, '2025-09-04 14:17:10', NULL),
(48, 69, 3, 4, NULL, NULL, 1, NULL, NULL, '2025-09-04 14:17:14', NULL, '2025-09-04 14:17:14', NULL),
(49, 56, 1, 2, NULL, NULL, 1, NULL, NULL, '2025-09-04 14:25:48', NULL, '2025-09-04 14:25:48', NULL),
(50, 56, 2, 3, NULL, NULL, 1, NULL, NULL, '2025-09-04 14:26:02', NULL, '2025-09-04 14:26:02', NULL),
(51, 56, 3, 4, NULL, NULL, 1, NULL, NULL, '2025-09-04 14:26:06', NULL, '2025-09-04 14:26:06', NULL),
(52, 69, 4, 3, NULL, NULL, 1, NULL, NULL, '2025-09-04 19:45:17', NULL, '2025-09-04 19:45:17', NULL),
(55, 69, 3, 4, NULL, NULL, 1, NULL, NULL, '2025-09-04 20:34:42', NULL, '2025-09-04 20:34:42', NULL),
(56, 70, NULL, 1, NULL, NULL, 1, 'Utworzenie zgłoszenia', NULL, '2025-09-04 20:52:12', NULL, '2025-09-04 20:52:12', NULL),
(57, 70, 1, 2, NULL, NULL, 1, NULL, NULL, '2025-09-04 21:26:43', NULL, '2025-09-04 21:26:43', NULL),
(58, 70, 2, 3, NULL, NULL, 1, NULL, NULL, '2025-09-04 22:20:52', NULL, '2025-09-04 22:20:52', NULL),
(59, 70, 3, 2, NULL, NULL, 1, NULL, NULL, '2025-09-04 22:22:21', NULL, '2025-09-04 22:22:21', NULL),
(60, 71, NULL, 1, NULL, NULL, 1, 'Utworzenie zgłoszenia', NULL, '2025-09-04 22:25:00', NULL, '2025-09-04 22:25:00', NULL),
(61, 68, 4, 3, NULL, NULL, 1, NULL, NULL, '2025-09-04 23:48:44', NULL, '2025-09-04 23:48:44', NULL),
(62, 68, 3, 2, NULL, NULL, 1, NULL, NULL, '2025-09-04 23:49:21', NULL, '2025-09-04 23:49:21', NULL),
(63, 68, 2, 3, NULL, NULL, 1, NULL, NULL, '2025-09-05 00:19:47', NULL, '2025-09-05 00:19:47', NULL),
(64, 68, 3, 2, NULL, NULL, 1, NULL, NULL, '2025-09-05 00:19:53', NULL, '2025-09-05 00:19:53', NULL),
(65, 68, 2, 3, NULL, NULL, 1, NULL, NULL, '2025-09-05 00:22:05', NULL, '2025-09-05 00:22:05', NULL),
(66, 68, 3, 16, NULL, NULL, 1, NULL, NULL, '2025-09-05 00:22:09', NULL, '2025-09-05 00:22:09', NULL),
(67, 68, 16, 11, NULL, NULL, 1, 'oki', NULL, '2025-09-05 00:22:21', NULL, '2025-09-05 00:22:21', NULL),
(68, 72, NULL, 1, NULL, NULL, 1, 'Utworzenie zgłoszenia', NULL, '2025-09-05 09:29:46', NULL, '2025-09-05 09:29:46', NULL),
(69, 73, NULL, 1, NULL, NULL, 1, 'Utworzenie zgłoszenia', NULL, '2025-09-05 12:20:59', NULL, '2025-09-05 12:20:59', NULL),
(70, 74, NULL, 1, NULL, NULL, 1, 'Utworzenie zgłoszenia', NULL, '2025-09-05 12:27:30', NULL, '2025-09-05 12:27:30', NULL),
(71, 74, 1, 15, NULL, NULL, 1, NULL, NULL, '2025-09-05 12:34:36', NULL, '2025-09-05 12:34:36', NULL),
(72, 74, 15, 16, NULL, NULL, 1, NULL, NULL, '2025-09-05 12:35:36', NULL, '2025-09-05 12:35:36', NULL),
(73, 74, 16, 3, NULL, NULL, 1, 'Uniwersalna', 'Test', '2025-09-05 12:38:05', NULL, '2025-09-05 12:38:05', NULL),
(74, 74, 3, 16, NULL, NULL, 1, NULL, NULL, '2025-09-05 12:38:39', NULL, '2025-09-05 12:38:39', NULL),
(75, 74, 16, 11, NULL, NULL, 1, 'Wszędzie ok, słabiej na plastrach. Długo wczytują się zdjecia', NULL, '2025-09-05 12:39:45', NULL, '2025-09-05 12:39:45', NULL),
(76, 76, 1, 2, NULL, NULL, 1, NULL, NULL, '2025-09-08 13:19:37', NULL, '2025-09-08 13:19:37', NULL),
(77, 77, NULL, 1, NULL, NULL, 1, 'Utworzenie zgłoszenia', NULL, '2025-09-08 13:23:50', NULL, '2025-09-08 13:23:50', NULL),
(78, 78, NULL, 1, NULL, NULL, 1, 'Utworzenie zgłoszenia', NULL, '2025-09-09 22:07:56', NULL, '2025-09-09 22:07:56', NULL),
(79, 78, 1, 15, NULL, NULL, 1, NULL, NULL, '2025-09-09 23:09:04', NULL, '2025-09-09 23:09:04', NULL),
(80, 78, 15, 16, NULL, NULL, 1, NULL, NULL, '2025-09-10 11:30:36', NULL, '2025-09-10 11:30:36', NULL),
(81, 79, NULL, 1, NULL, NULL, 1, 'Utworzenie zgłoszenia', NULL, '2025-09-10 11:31:44', NULL, '2025-09-10 11:31:44', NULL),
(82, 79, 1, 2, NULL, NULL, 5, NULL, NULL, '2025-09-10 19:15:09', NULL, '2025-09-10 19:15:09', NULL),
(83, 79, 2, 3, NULL, NULL, 5, NULL, NULL, '2025-09-10 19:15:47', NULL, '2025-09-10 19:15:47', NULL),
(84, 78, 16, 3, NULL, NULL, 5, NULL, NULL, '2025-09-10 19:20:06', NULL, '2025-09-10 19:20:06', NULL),
(85, 78, 3, 16, NULL, NULL, 5, NULL, NULL, '2025-09-10 19:20:11', NULL, '2025-09-10 19:20:11', NULL),
(86, 78, 16, 3, NULL, NULL, 5, NULL, NULL, '2025-09-10 19:20:52', NULL, '2025-09-10 19:20:52', NULL),
(87, 78, 3, 16, NULL, NULL, 5, NULL, NULL, '2025-09-10 19:21:05', NULL, '2025-09-10 19:21:05', NULL),
(88, 78, 16, 3, NULL, NULL, 1, 'test', NULL, '2025-09-10 21:27:26', NULL, '2025-09-10 21:27:26', NULL),
(89, 80, NULL, 8, NULL, NULL, 1, 'Utworzenie zgłoszenia', NULL, '2025-09-11 13:18:33', NULL, '2025-09-11 13:18:33', NULL),
(90, 80, 8, 6, NULL, NULL, 1, NULL, NULL, '2025-09-11 13:20:00', NULL, '2025-09-11 13:20:00', NULL),
(91, 78, 3, 16, NULL, NULL, 1, NULL, NULL, '2025-09-11 13:20:26', NULL, '2025-09-11 13:20:26', NULL),
(92, 78, 16, 3, NULL, NULL, 1, 'test', NULL, '2025-09-11 13:21:11', NULL, '2025-09-11 13:21:11', NULL),
(93, 78, 3, 16, NULL, NULL, 1, NULL, NULL, '2025-09-11 17:52:31', NULL, '2025-09-11 17:52:31', NULL),
(94, 78, 16, 3, NULL, NULL, 1, 'udało się', NULL, '2025-09-11 17:52:46', NULL, '2025-09-11 17:52:46', NULL),
(95, 78, 3, 16, NULL, NULL, 1, NULL, NULL, '2025-09-11 17:53:06', NULL, '2025-09-11 17:53:06', NULL),
(96, 78, 16, 3, NULL, NULL, 1, 'udało się', NULL, '2025-09-11 17:53:48', NULL, '2025-09-11 17:53:48', NULL),
(97, 78, 3, 16, NULL, NULL, 1, NULL, NULL, '2025-09-11 17:53:54', NULL, '2025-09-11 17:53:54', NULL),
(98, 78, 16, 3, NULL, NULL, 1, 'udało się', NULL, '2025-09-11 17:54:10', NULL, '2025-09-11 17:54:10', NULL),
(99, 81, NULL, 8, NULL, NULL, 1, 'Utworzenie zgłoszenia', NULL, '2025-09-11 17:57:04', NULL, '2025-09-11 17:57:04', NULL),
(100, 81, 8, 15, NULL, NULL, 1, NULL, NULL, '2025-09-11 17:59:03', NULL, '2025-09-11 17:59:03', NULL),
(101, 81, 15, 16, NULL, NULL, 1, NULL, NULL, '2025-09-11 17:59:08', NULL, '2025-09-11 17:59:08', NULL),
(102, 81, 16, 3, NULL, NULL, 1, 'test', NULL, '2025-09-11 17:59:19', NULL, '2025-09-11 17:59:19', NULL),
(103, 81, 3, 16, NULL, NULL, 1, NULL, NULL, '2025-09-11 17:59:26', NULL, '2025-09-11 17:59:26', NULL),
(104, 81, 16, 3, NULL, NULL, 1, 'test', NULL, '2025-09-11 17:59:32', NULL, '2025-09-11 17:59:32', NULL),
(105, 81, 3, 16, NULL, NULL, 1, NULL, NULL, '2025-09-11 18:25:56', NULL, '2025-09-11 18:25:56', NULL),
(106, 81, 16, 11, NULL, NULL, 1, 'test', NULL, '2025-09-11 18:30:41', NULL, '2025-09-11 18:30:41', NULL),
(107, 78, 3, 16, NULL, NULL, 1, NULL, NULL, '2025-09-11 18:30:55', NULL, '2025-09-11 18:30:55', NULL),
(108, 78, 16, 3, NULL, NULL, 1, 'test', 'test', '2025-09-11 18:32:00', NULL, '2025-09-11 18:32:00', NULL),
(109, 81, 11, 6, NULL, NULL, 1, NULL, NULL, '2025-09-11 19:16:19', NULL, '2025-09-11 19:16:19', NULL),
(110, 78, 3, 16, NULL, NULL, 1, NULL, NULL, '2025-09-11 19:20:17', NULL, '2025-09-11 19:20:17', NULL),
(111, 78, 16, 11, NULL, NULL, 1, 'a', NULL, '2025-09-11 19:20:25', NULL, '2025-09-11 19:20:25', NULL),
(112, 78, 11, 12, NULL, NULL, 1, NULL, NULL, '2025-09-11 19:20:31', NULL, '2025-09-11 19:20:31', NULL),
(113, 82, NULL, 8, NULL, NULL, 1, 'Utworzenie zgłoszenia', NULL, '2025-09-11 19:30:15', NULL, '2025-09-11 19:30:15', NULL),
(114, 82, 8, 15, NULL, NULL, 1, NULL, NULL, '2025-09-12 08:55:04', NULL, '2025-09-12 08:55:04', NULL),
(115, 82, 15, 16, NULL, NULL, 5, NULL, NULL, '2025-09-12 08:55:23', NULL, '2025-09-12 08:55:23', NULL),
(116, 82, 16, 3, NULL, NULL, 5, 'test', 'udało się', '2025-09-12 08:56:55', NULL, '2025-09-12 08:56:55', NULL),
(117, 82, 3, 16, NULL, NULL, 5, NULL, NULL, '2025-09-12 08:57:03', NULL, '2025-09-12 08:57:03', NULL),
(118, 82, 16, 3, NULL, NULL, 1, 'test', 'testa', '2025-09-12 09:03:09', NULL, '2025-09-12 09:03:09', NULL),
(119, 82, 3, 16, NULL, NULL, 1, NULL, NULL, '2025-09-12 09:03:19', NULL, '2025-09-12 09:03:19', NULL),
(120, 82, 16, 3, NULL, NULL, 1, 't', 't', '2025-09-12 09:03:41', NULL, '2025-09-12 09:03:41', NULL),
(121, 82, 3, 16, NULL, NULL, 1, NULL, NULL, '2025-09-12 09:03:52', NULL, '2025-09-12 09:03:52', NULL),
(127, 82, 16, 3, 25, 3, 1, 't', 't', '2025-09-12 11:46:49', NULL, '2025-09-12 11:46:49', NULL),
(128, 82, 3, 16, 28, 3, 1, NULL, NULL, '2025-09-12 12:34:22', NULL, '2025-09-12 12:34:22', NULL),
(129, 82, 16, 3, 25, 3, 1, 'test', 'test', '2025-09-12 12:34:34', NULL, '2025-09-12 12:34:34', NULL),
(130, 82, 3, 16, 28, 3, 1, NULL, NULL, '2025-09-15 07:32:21', NULL, '2025-09-15 07:32:21', NULL),
(131, 82, 16, 11, 27, 3, 1, 't', NULL, '2025-09-15 07:32:29', NULL, '2025-09-15 07:32:29', NULL),
(132, 82, 11, 12, 38, 3, 1, NULL, NULL, '2025-09-15 07:32:42', NULL, '2025-09-15 07:32:42', NULL),
(133, 83, NULL, 8, NULL, NULL, 1, 'Utworzenie zgłoszenia', NULL, '2025-09-15 19:55:16', NULL, '2025-09-15 19:55:16', NULL),
(134, 84, NULL, 8, NULL, NULL, 1, 'Utworzenie zgłoszenia', NULL, '2025-09-15 21:05:24', NULL, '2025-09-15 21:05:24', NULL),
(135, 84, 8, 15, 35, 3, 1, NULL, NULL, '2025-09-16 10:58:17', NULL, '2025-09-16 10:58:17', NULL),
(136, 84, 15, 16, NULL, NULL, 1, '', '', '2025-09-16 13:29:37', NULL, '2025-09-16 13:29:37', NULL),
(137, 84, 16, 3, NULL, NULL, 1, 'test', 'kontrahent', '2025-09-16 13:30:36', NULL, '2025-09-16 13:30:36', NULL),
(138, 84, 3, 16, NULL, NULL, 1, '', '', '2025-09-16 13:31:36', NULL, '2025-09-16 13:31:36', NULL),
(139, 84, 16, 3, 25, 3, 1, 't', 'brak części', '2025-09-16 22:08:44', NULL, '2025-09-16 22:08:44', NULL),
(140, 84, 3, 16, 28, 3, 1, NULL, NULL, '2025-09-16 22:25:47', NULL, '2025-09-16 22:25:47', NULL),
(141, 84, 16, 3, 25, 3, 1, 'test', 'brak części', '2025-09-16 22:40:38', NULL, '2025-09-16 22:40:38', NULL);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_ticket_subtypes`
--

CREATE TABLE `cmms_ticket_subtypes` (
  `id` int(10) UNSIGNED NOT NULL,
  `type_id` int(10) UNSIGNED NOT NULL,
  `slug` varchar(64) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `order_no` int(11) NOT NULL DEFAULT 100,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `mpk_id` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `cmms_ticket_subtypes`
--

INSERT INTO `cmms_ticket_subtypes` (`id`, `type_id`, `slug`, `name`, `description`, `order_no`, `active`, `mpk_id`, `created_by`, `created_at`, `updated_by`, `updated_at`) VALUES
(1, 1, 'a_techniczna', 'Techniczna', NULL, 100, 1, NULL, NULL, '2025-08-20 21:25:30', 1, '2025-09-08 10:56:30'),
(2, 2, 'bhp_produkcja', 'Produkcja', NULL, 100, 1, NULL, NULL, '2025-08-20 21:25:30', 1, '2025-09-08 10:13:31'),
(5, 1, 'a_produkcyjna', 'Produkcyjna', 'Awarie może usunąć opertor', 100, 1, NULL, NULL, '2025-08-29 13:49:27', 1, '2025-09-08 10:56:26'),
(11, 18, 'u_techniczna', 'Techniczna', NULL, 100, 1, NULL, 1, '2025-08-31 14:58:44', 1, '2025-09-08 10:13:50'),
(12, 2, 'bhp_technika', 'Technika', NULL, 100, 1, NULL, 1, '2025-09-05 11:45:00', 1, '2025-09-08 10:13:39'),
(14, 18, 'u_produkcja', 'Produkcja', NULL, 100, 1, NULL, 1, '2025-09-05 11:45:36', 1, '2025-09-08 10:14:06'),
(15, 1, 'elektryczna', 'Elektryczna', NULL, 100, 1, NULL, 1, '2025-09-12 14:56:21', 1, '2025-09-12 14:56:21');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_ticket_time_spans`
--

CREATE TABLE `cmms_ticket_time_spans` (
  `id` int(11) NOT NULL,
  `ticket_id` int(11) NOT NULL,
  `category_key` varchar(40) NOT NULL,
  `started_at` datetime NOT NULL,
  `ended_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `cmms_ticket_time_spans`
--

INSERT INTO `cmms_ticket_time_spans` (`id`, `ticket_id`, `category_key`, `started_at`, `ended_at`) VALUES
(1, 67, 'active', '2025-09-04 10:26:07', '2025-09-04 11:19:00'),
(2, 67, 'waiting', '2025-09-04 11:19:00', NULL),
(3, 61, 'active', '2025-09-04 11:24:40', NULL),
(4, 68, 'active', '2025-09-04 12:21:28', '2025-09-04 12:21:35'),
(5, 68, 'waiting', '2025-09-04 12:21:35', '2025-09-04 12:21:39'),
(6, 68, 'resolved', '2025-09-04 12:21:39', NULL),
(7, 57, 'active', '2025-09-04 14:07:09', '2025-09-04 14:07:13'),
(8, 57, 'waiting', '2025-09-04 14:07:13', '2025-09-04 14:07:20'),
(9, 57, 'resolved', '2025-09-04 14:07:20', '2025-09-04 14:07:26'),
(10, 57, 'waiting', '2025-09-04 14:07:26', NULL),
(11, 54, 'active', '2025-09-04 14:12:18', '2025-09-04 14:12:20'),
(12, 54, 'waiting', '2025-09-04 14:12:20', '2025-09-04 14:12:25'),
(13, 54, 'resolved', '2025-09-04 14:12:25', '2025-09-04 14:12:28'),
(14, 54, 'waiting', '2025-09-04 14:12:28', NULL),
(15, 55, 'active', '2025-09-04 14:15:48', '2025-09-04 14:15:52'),
(16, 55, 'waiting', '2025-09-04 14:15:52', '2025-09-04 14:16:00'),
(17, 55, 'resolved', '2025-09-04 14:16:00', NULL),
(18, 69, 'active', '2025-09-04 14:17:08', '2025-09-04 14:17:10'),
(19, 69, 'waiting', '2025-09-04 14:17:10', '2025-09-04 14:17:14'),
(20, 69, 'resolved', '2025-09-04 14:17:14', '2025-09-04 19:45:17'),
(21, 56, 'active', '2025-09-04 14:25:48', '2025-09-04 14:26:02'),
(22, 56, 'waiting', '2025-09-04 14:26:02', '2025-09-04 14:26:06'),
(23, 56, 'resolved', '2025-09-04 14:26:06', NULL),
(24, 69, 'waiting', '2025-09-04 19:45:17', '2025-09-04 20:34:42'),
(25, 69, 'resolved', '2025-09-04 20:34:42', NULL),
(26, 70, 'active', '2025-09-04 21:26:43', '2025-09-04 22:20:52'),
(27, 70, 'waiting', '2025-09-04 22:20:52', '2025-09-04 22:22:21'),
(28, 70, 'active', '2025-09-04 22:22:21', NULL);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_ticket_types`
--

CREATE TABLE `cmms_ticket_types` (
  `id` int(10) UNSIGNED NOT NULL,
  `key_name` varchar(64) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `order_no` int(11) NOT NULL DEFAULT 100,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `mpk_id` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `cmms_ticket_types`
--

INSERT INTO `cmms_ticket_types` (`id`, `key_name`, `name`, `description`, `order_no`, `active`, `mpk_id`, `created_by`, `created_at`, `updated_by`, `updated_at`) VALUES
(1, 'awaria', 'Awaria', NULL, 102, 1, NULL, NULL, '2025-08-20 21:25:21', 1, '2025-08-31 09:10:12'),
(2, 'bhp', 'BHP', NULL, 100, 1, NULL, NULL, '2025-08-20 21:25:21', NULL, '2025-08-20 21:25:21'),
(18, 'usterka', 'Usterka', NULL, 100, 1, NULL, 1, '2025-08-30 23:08:26', 1, '2025-08-30 23:08:37');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_ticket_worklog`
--

CREATE TABLE `cmms_ticket_worklog` (
  `id` int(10) UNSIGNED NOT NULL,
  `ticket_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(11) NOT NULL,
  `start_at` datetime NOT NULL,
  `end_at` datetime DEFAULT NULL,
  `minutes` int(10) UNSIGNED GENERATED ALWAYS AS (case when `end_at` is null then NULL else timestampdiff(MINUTE,`start_at`,`end_at`) end) VIRTUAL,
  `note` varchar(255) DEFAULT NULL,
  `source` enum('manual','auto_status') NOT NULL DEFAULT 'manual',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `is_open` tinyint(1) GENERATED ALWAYS AS (case when `end_at` is null then 1 else NULL end) STORED
) ;

--
-- Zrzut danych tabeli `cmms_ticket_worklog`
--

INSERT INTO `cmms_ticket_worklog` (`id`, `ticket_id`, `user_id`, `start_at`, `end_at`, `note`, `source`, `created_at`) VALUES
(3, 1, 1, '2025-09-10 09:22:08', '2025-09-10 11:30:36', NULL, 'manual', '2025-09-10 09:22:08'),
(6, 78, 1, '2025-09-10 11:30:36', '2025-09-10 12:54:32', NULL, 'auto_status', '2025-09-10 11:30:36'),
(7, 78, 1, '2025-09-10 12:54:32', '2025-09-10 13:10:52', NULL, 'manual', '2025-09-10 12:54:32'),
(8, 78, 1, '2025-09-10 13:10:52', '2025-09-10 13:10:55', NULL, 'manual', '2025-09-10 13:10:52'),
(9, 78, 1, '2025-09-10 13:10:55', '2025-09-10 13:10:59', NULL, 'manual', '2025-09-10 13:10:55'),
(10, 78, 1, '2025-09-10 13:10:59', '2025-09-10 13:11:08', NULL, 'manual', '2025-09-10 13:10:59'),
(11, 78, 1, '2025-09-10 13:11:08', '2025-09-10 13:16:53', NULL, 'manual', '2025-09-10 13:11:08'),
(12, 78, 1, '2025-09-10 13:16:53', '2025-09-10 13:25:25', NULL, 'manual', '2025-09-10 13:16:53'),
(13, 78, 1, '2025-09-10 13:25:40', '2025-09-10 14:12:16', NULL, 'manual', '2025-09-10 13:25:40'),
(14, 78, 1, '2025-09-10 14:12:27', '2025-09-10 14:13:55', NULL, 'manual', '2025-09-10 14:12:27'),
(15, 78, 5, '2025-09-10 14:18:04', '2025-09-10 14:18:15', NULL, 'manual', '2025-09-10 14:18:04'),
(16, 78, 5, '2025-09-10 14:32:57', '2025-09-10 14:33:06', NULL, 'manual', '2025-09-10 14:32:57'),
(17, 78, 5, '2025-09-10 14:35:43', '2025-09-10 14:35:45', NULL, 'manual', '2025-09-10 14:35:43'),
(18, 78, 5, '2025-09-10 14:35:45', '2025-09-10 14:36:01', NULL, 'manual', '2025-09-10 14:35:45'),
(19, 77, 5, '2025-09-10 14:36:12', '2025-09-10 14:36:24', NULL, 'manual', '2025-09-10 14:36:12'),
(20, 79, 5, '2025-09-10 14:37:34', '2025-09-10 14:51:04', NULL, 'manual', '2025-09-10 14:37:34'),
(21, 79, 5, '2025-09-10 14:51:39', '2025-09-10 14:51:44', NULL, 'manual', '2025-09-10 14:51:39'),
(22, 79, 5, '2025-09-10 14:51:44', '2025-09-10 14:51:54', NULL, 'manual', '2025-09-10 14:51:44'),
(23, 79, 5, '2025-09-10 14:52:03', '2025-09-10 14:52:37', NULL, 'manual', '2025-09-10 14:52:03'),
(24, 79, 5, '2025-09-10 15:01:08', '2025-09-10 19:07:53', NULL, 'manual', '2025-09-10 15:01:08'),
(25, 79, 5, '2025-09-10 19:08:21', '2025-09-10 19:08:23', NULL, 'manual', '2025-09-10 19:08:21'),
(26, 79, 5, '2025-09-10 19:15:09', '2025-09-10 19:16:00', NULL, 'auto_status', '2025-09-10 19:15:09'),
(27, 78, 5, '2025-09-10 19:20:11', '2025-09-10 19:21:00', NULL, 'auto_status', '2025-09-10 19:20:11'),
(28, 78, 5, '2025-09-10 19:21:05', '2025-09-10 19:21:33', NULL, 'auto_status', '2025-09-10 19:21:05'),
(29, 78, 1, '2025-09-10 20:46:00', '2025-09-10 21:27:07', NULL, 'manual', '2025-09-10 20:46:00'),
(30, 78, 1, '2025-09-10 21:27:31', '2025-09-10 21:28:03', NULL, 'manual', '2025-09-10 21:27:31'),
(31, 78, 1, '2025-09-10 21:43:41', '2025-09-10 21:43:59', NULL, 'manual', '2025-09-10 21:43:41'),
(32, 78, 1, '2025-09-10 21:44:29', '2025-09-10 22:06:52', NULL, 'manual', '2025-09-10 21:44:29'),
(33, 78, 1, '2025-09-10 22:13:56', '2025-09-10 22:14:08', NULL, 'manual', '2025-09-10 22:13:56'),
(34, 78, 5, '2025-09-11 07:07:59', '2025-09-11 07:08:11', NULL, 'manual', '2025-09-11 07:07:59'),
(35, 80, 1, '2025-09-11 13:19:34', '2025-09-11 13:19:51', NULL, 'manual', '2025-09-11 13:19:34'),
(36, 78, 1, '2025-09-11 13:20:26', '2025-09-11 13:26:04', NULL, 'auto_status', '2025-09-11 13:20:26'),
(37, 78, 1, '2025-09-11 17:52:31', '2025-09-11 17:53:01', NULL, 'auto_status', '2025-09-11 17:52:31'),
(38, 78, 1, '2025-09-11 17:53:06', '2025-09-11 17:53:20', NULL, 'auto_status', '2025-09-11 17:53:06'),
(39, 78, 1, '2025-09-11 17:53:22', '2025-09-11 17:53:54', NULL, 'manual', '2025-09-11 17:53:22'),
(40, 78, 1, '2025-09-11 17:53:54', '2025-09-11 17:59:08', NULL, 'auto_status', '2025-09-11 17:53:54'),
(41, 81, 1, '2025-09-11 17:59:08', '2025-09-11 17:59:26', NULL, 'auto_status', '2025-09-11 17:59:08'),
(42, 81, 1, '2025-09-11 17:59:26', '2025-09-11 18:25:56', NULL, 'auto_status', '2025-09-11 17:59:26'),
(43, 81, 1, '2025-09-11 18:25:56', '2025-09-11 19:16:16', NULL, 'auto_status', '2025-09-11 18:25:56'),
(44, 80, 1, '2025-09-11 19:19:56', '2025-09-11 19:19:57', NULL, 'manual', '2025-09-11 19:19:56'),
(45, 82, 1, '2025-09-12 09:03:56', '2025-09-12 09:04:06', NULL, 'manual', '2025-09-12 09:03:56'),
(46, 82, 1, '2025-09-12 09:53:21', '2025-09-12 09:53:28', NULL, 'manual', '2025-09-12 09:53:21'),
(47, 82, 5, '2025-09-14 17:00:20', '2025-09-14 17:00:36', NULL, 'manual', '2025-09-14 17:00:20'),
(48, 84, 1, '2025-09-16 10:58:21', '2025-09-16 10:58:26', NULL, 'manual', '2025-09-16 10:58:21'),
(49, 84, 1, '2025-09-16 22:14:32', '2025-09-16 22:14:35', NULL, 'manual', '2025-09-16 22:14:32'),
(50, 84, 1, '2025-09-16 22:17:00', '2025-09-16 22:17:34', NULL, 'manual', '2025-09-16 22:17:00'),
(51, 84, 1, '2025-09-16 22:40:18', '2025-09-16 22:40:26', NULL, 'manual', '2025-09-16 22:40:18'),
(52, 84, 1, '2025-09-16 22:47:43', '2025-09-16 22:47:46', NULL, 'manual', '2025-09-16 22:47:43');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_user_role`
--

CREATE TABLE `cmms_user_role` (
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `cmms_user_role`
--

INSERT INTO `cmms_user_role` (`user_id`, `role_id`) VALUES
(1, 1),
(21, 2);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_workflows`
--

CREATE TABLE `cmms_workflows` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(128) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

--
-- Zrzut danych tabeli `cmms_workflows`
--

INSERT INTO `cmms_workflows` (`id`, `name`, `description`, `active`, `created_at`, `updated_at`) VALUES
(1, 'Standard', 'Domyślny workflow CMMS', 1, '2025-08-21 22:00:20', '2025-08-21 22:00:20'),
(3, 'test', 'test', 1, '2025-09-04 14:08:23', '2025-09-04 14:08:23');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_workflow_assignments`
--

CREATE TABLE `cmms_workflow_assignments` (
  `id` int(10) UNSIGNED NOT NULL,
  `workflow_id` int(10) UNSIGNED NOT NULL,
  `type_id` int(10) UNSIGNED DEFAULT NULL,
  `subtype_id` int(10) UNSIGNED DEFAULT NULL,
  `priority` int(11) NOT NULL DEFAULT 10,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `type_id_norm` int(10) UNSIGNED GENERATED ALWAYS AS (ifnull(`type_id`,0)) STORED,
  `subtype_id_norm` int(10) UNSIGNED GENERATED ALWAYS AS (ifnull(`subtype_id`,0)) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

--
-- Zrzut danych tabeli `cmms_workflow_assignments`
--

INSERT INTO `cmms_workflow_assignments` (`id`, `workflow_id`, `type_id`, `subtype_id`, `priority`, `active`) VALUES
(1, 1, NULL, NULL, 10, 1),
(5, 3, 18, NULL, 10, 1),
(6, 3, 1, NULL, 10, 1);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_workflow_statuses`
--

CREATE TABLE `cmms_workflow_statuses` (
  `workflow_id` int(10) UNSIGNED NOT NULL,
  `status_id` int(10) UNSIGNED NOT NULL,
  `order_no` int(11) NOT NULL DEFAULT 100,
  `is_initial` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

--
-- Zrzut danych tabeli `cmms_workflow_statuses`
--

INSERT INTO `cmms_workflow_statuses` (`workflow_id`, `status_id`, `order_no`, `is_initial`) VALUES
(1, 1, 10, 1),
(1, 2, 20, 0),
(1, 3, 30, 0),
(1, 4, 40, 0),
(1, 5, 50, 0),
(1, 6, 60, 0),
(1, 8, 10, 1),
(1, 9, 20, 0),
(1, 10, 30, 0),
(1, 11, 40, 0),
(1, 12, 50, 0),
(1, 13, 60, 0),
(3, 2, 100, 0),
(3, 3, 100, 0),
(3, 8, 100, 0),
(3, 11, 100, 0),
(3, 12, 100, 0),
(3, 13, 100, 0),
(3, 15, 100, 0),
(3, 16, 100, 0);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_workflow_transitions`
--

CREATE TABLE `cmms_workflow_transitions` (
  `id` int(10) UNSIGNED NOT NULL,
  `workflow_id` int(10) UNSIGNED NOT NULL,
  `from_status_id` int(10) UNSIGNED NOT NULL,
  `to_status_id` int(10) UNSIGNED NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `order_no` int(11) NOT NULL DEFAULT 100,
  `requires_comment` tinyint(1) NOT NULL DEFAULT 0,
  `requires_assignee` tinyint(1) NOT NULL DEFAULT 0,
  `requires_reason` tinyint(1) NOT NULL DEFAULT 0,
  `reason_type` enum('waiting','cancel','other') DEFAULT NULL,
  `set_resolved_at` tinyint(1) NOT NULL DEFAULT 0,
  `set_closed_at` tinyint(1) NOT NULL DEFAULT 0,
  `pause_sla` tinyint(1) NOT NULL DEFAULT 0,
  `resume_sla` tinyint(1) NOT NULL DEFAULT 0,
  `permission_key` varchar(64) DEFAULT NULL COMMENT 'Klucz uprawnienia wymagany do wykonania przejścia (np. cmms.tickets.close). Jeśli NULL – dostępne dla wszystkich z rolą CMMS'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

--
-- Zrzut danych tabeli `cmms_workflow_transitions`
--

INSERT INTO `cmms_workflow_transitions` (`id`, `workflow_id`, `from_status_id`, `to_status_id`, `active`, `order_no`, `requires_comment`, `requires_assignee`, `requires_reason`, `reason_type`, `set_resolved_at`, `set_closed_at`, `pause_sla`, `resume_sla`, `permission_key`) VALUES
(10, 1, 8, 9, 1, 10, 0, 0, 0, NULL, 0, 0, 0, 0, NULL),
(11, 1, 9, 10, 1, 20, 0, 0, 1, 'waiting', 0, 0, 1, 0, NULL),
(12, 1, 10, 9, 1, 30, 0, 0, 0, NULL, 0, 0, 0, 1, NULL),
(13, 1, 9, 11, 1, 40, 1, 0, 0, NULL, 1, 0, 0, 0, NULL),
(14, 1, 11, 12, 1, 50, 0, 0, 0, NULL, 0, 1, 0, 0, NULL),
(15, 1, 9, 13, 1, 60, 1, 0, 1, 'cancel', 0, 0, 0, 0, NULL),
(16, 1, 8, 13, 1, 70, 1, 0, 1, 'cancel', 0, 0, 0, 0, NULL),
(17, 1, 10, 13, 1, 80, 1, 0, 1, 'cancel', 0, 0, 0, 0, NULL),
(18, 1, 11, 9, 1, 90, 1, 0, 0, NULL, 0, 0, 0, 0, NULL),
(24, 3, 15, 16, 1, 100, 0, 1, 0, NULL, 0, 0, 0, 0, NULL),
(25, 3, 16, 3, 1, 100, 1, 0, 1, 'waiting', 0, 0, 0, 0, NULL),
(26, 3, 15, 3, 1, 100, 0, 0, 1, NULL, 0, 0, 0, 0, NULL),
(27, 3, 16, 11, 1, 100, 1, 0, 0, NULL, 1, 1, 1, 0, NULL),
(28, 3, 3, 16, 1, 100, 0, 1, 0, NULL, 0, 0, 0, 1, NULL),
(34, 1, 2, 11, 1, 100, 0, 0, 0, NULL, 1, 0, 0, 0, NULL),
(35, 3, 8, 15, 1, 100, 0, 1, 0, NULL, 0, 0, 0, 0, NULL),
(36, 3, 8, 2, 1, 100, 0, 1, 0, NULL, 0, 0, 0, 0, NULL),
(37, 3, 8, 13, 1, 100, 1, 0, 1, NULL, 0, 1, 1, 0, NULL),
(38, 3, 11, 12, 1, 100, 0, 0, 0, NULL, 1, 0, 1, 0, NULL),
(39, 3, 13, 3, 1, 100, 1, 0, 1, NULL, 0, 0, 0, 1, NULL);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `cmms_workflow_transition_roles`
--

CREATE TABLE `cmms_workflow_transition_roles` (
  `id` int(10) UNSIGNED NOT NULL,
  `transition_id` int(10) UNSIGNED NOT NULL,
  `role_key` varchar(64) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `kompetencje_brygada`
--

CREATE TABLE `kompetencje_brygada` (
  `id` int(11) NOT NULL,
  `id_dzial` int(11) NOT NULL,
  `id_obszar` int(11) DEFAULT NULL,
  `nazwa` varchar(100) NOT NULL,
  `opis` text DEFAULT NULL,
  `status` varchar(50) DEFAULT 'aktywny',
  `aktywny` tinyint(1) DEFAULT 1,
  `created_by` int(11) DEFAULT NULL,
  `edited_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `kompetencje_brygada`
--

INSERT INTO `kompetencje_brygada` (`id`, `id_dzial`, `id_obszar`, `nazwa`, `opis`, `status`, `aktywny`, `created_by`, `edited_by`, `created_at`, `updated_at`) VALUES
(1, 1, NULL, 'A', '', '', 1, 1, 1, '2025-08-05 12:25:49', '2025-08-05 12:45:11'),
(2, 1, NULL, 'B', '', 'aktywny', 1, 1, NULL, '2025-08-05 12:28:19', '2025-08-05 12:28:19'),
(3, 1, NULL, 'C', '', 'aktywny', 1, 1, NULL, '2025-08-05 12:28:25', '2025-08-05 12:28:25'),
(4, 1, NULL, 'D', '', 'aktywny', 1, 1, NULL, '2025-08-05 12:28:31', '2025-08-05 12:28:31');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `kompetencje_dzial`
--

CREATE TABLE `kompetencje_dzial` (
  `id` int(11) NOT NULL,
  `nazwa` varchar(100) NOT NULL,
  `opis` text DEFAULT NULL,
  `status` varchar(50) DEFAULT 'aktywny',
  `aktywny` tinyint(1) DEFAULT 1,
  `created_by` int(11) DEFAULT NULL,
  `edited_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  `id_odpowiedzialnego` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `kompetencje_dzial`
--

INSERT INTO `kompetencje_dzial` (`id`, `nazwa`, `opis`, `status`, `aktywny`, `created_by`, `edited_by`, `created_at`, `updated_at`, `id_odpowiedzialnego`) VALUES
(1, 'Produkcja', 'Dział odpowiedzialny za procesy produkcyjne', '', 1, 1, 1, '2025-06-25 10:17:08', '2025-08-06 18:26:40', 22),
(2, 'Technika', 'Dział utrzymania ruchu i serwisu', '', 1, 1, 1, '2025-06-25 10:17:08', '2025-08-06 18:26:49', 20),
(3, 'Magazyn', 'Logistyka wewnętrzna i gospodarka magazynowa', 'aktywny', 0, 1, NULL, '2025-06-25 10:17:08', '2025-06-25 10:17:08', NULL),
(4, 'Jakość', 'Kontrola jakości i systemy zarządzania', 'aktywny', 1, 1, NULL, '2025-06-25 10:17:08', '2025-06-25 10:17:08', NULL),
(5, 'Administracja', 'Zespół wspierający funkcjonowanie zakładu na całego', 'aktywny', 1, 1, 1, '2025-06-25 10:17:08', '2025-07-03 20:47:23', NULL),
(10, 'Agros Nova', 'Zakład', 'aktywny', 1, 1, 1, '2025-07-09 08:59:40', '2025-08-05 10:38:18', 5);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `kompetencje_miekkie_kryteria`
--

CREATE TABLE `kompetencje_miekkie_kryteria` (
  `id` int(11) NOT NULL,
  `nazwa` varchar(255) NOT NULL,
  `opis` text DEFAULT NULL,
  `id_skala` int(11) NOT NULL,
  `aktywny` tinyint(1) DEFAULT 1,
  `created_by` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL,
  `edited_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `kompetencje_miekkie_kryteria`
--

INSERT INTO `kompetencje_miekkie_kryteria` (`id`, `nazwa`, `opis`, `id_skala`, `aktywny`, `created_by`, `created_at`, `updated_at`, `edited_by`) VALUES
(1, 'Komunikacja werbalna', 'Umiejętność komunikacji z innymi pracownikami', 2, 1, 1, '2025-08-04 22:28:30', '2025-08-04 22:44:41', 1),
(2, 'Przekazywanie wiedzy', 'Umiejętność przekazywania wiedzy i dzielenia się nią', 2, 1, 1, '2025-08-04 22:58:24', '0000-00-00 00:00:00', 0);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `kompetencje_miekkie_oceny`
--

CREATE TABLE `kompetencje_miekkie_oceny` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `kompetencja_id` int(11) NOT NULL,
  `ocena` varchar(1) NOT NULL,
  `komentarz` text DEFAULT NULL,
  `data_oceny` date NOT NULL DEFAULT curdate(),
  `is_exam` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `edited_by` int(11) DEFAULT NULL,
  `rater_id` int(11) DEFAULT NULL,
  `rater_level` enum('I','II') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `kompetencje_miekkie_oceny`
--

INSERT INTO `kompetencje_miekkie_oceny` (`id`, `user_id`, `kompetencja_id`, `ocena`, `komentarz`, `data_oceny`, `is_exam`, `created_at`, `created_by`, `updated_at`, `edited_by`, `rater_id`, `rater_level`) VALUES
(1, 5, 1, 'A', 'słabo mu to wychodzi', '2025-08-04', 0, '2025-08-04 23:05:38', 1, '2025-08-04 23:25:26', 1, NULL, NULL),
(2, 5, 2, 'A', 'No nie umie', '2025-08-04', 0, '2025-08-04 23:16:04', 1, '2025-08-04 23:25:17', 1, NULL, NULL),
(3, 5, 2, 'C', NULL, '2025-09-11', 0, '2025-09-11 12:38:18', NULL, '2025-09-11 17:21:09', NULL, 1, 'I'),
(5, 5, 1, 'C', NULL, '2025-09-11', 0, '2025-09-11 12:38:30', NULL, NULL, NULL, 1, 'I'),
(8, 21, 2, 'B', NULL, '2025-09-11', 0, '2025-09-11 13:54:54', NULL, NULL, NULL, 1, 'I'),
(9, 21, 1, 'A', NULL, '2025-09-11', 0, '2025-09-11 17:21:00', NULL, '2025-09-11 17:21:04', NULL, 1, 'I'),
(10, 17, 2, 'B', NULL, '2025-09-11', 0, '2025-09-11 17:21:13', NULL, NULL, NULL, 1, 'I'),
(11, 18, 2, 'C', NULL, '2025-09-11', 0, '2025-09-11 17:21:41', NULL, NULL, NULL, 1, 'I'),
(12, 18, 1, 'A', NULL, '2025-09-11', 0, '2025-09-11 17:21:45', NULL, NULL, NULL, 1, 'I'),
(13, 17, 1, 'B', NULL, '2025-09-11', 0, '2025-09-11 17:49:22', NULL, NULL, NULL, 1, 'I'),
(14, 19, 2, 'C', NULL, '2025-09-16', 0, '2025-09-16 13:36:23', NULL, NULL, NULL, 1, 'I'),
(15, 19, 1, 'A', NULL, '2025-09-16', 0, '2025-09-16 13:36:28', NULL, NULL, NULL, 1, 'I'),
(16, 21, 2, 'A', NULL, '2025-09-16', 0, '2025-09-16 19:24:30', NULL, '2025-09-16 19:24:34', NULL, 1, 'I'),
(17, 5, 2, 'C', NULL, '2025-09-16', 0, '2025-09-16 20:01:10', NULL, '2025-09-16 20:01:41', NULL, 1, 'I');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `kompetencje_obszar`
--

CREATE TABLE `kompetencje_obszar` (
  `id` int(11) NOT NULL,
  `id_dzial` int(11) NOT NULL,
  `nazwa` varchar(100) NOT NULL,
  `opis` text DEFAULT NULL,
  `status` varchar(50) DEFAULT 'aktywny',
  `aktywny` tinyint(1) DEFAULT 1,
  `created_by` int(11) DEFAULT NULL,
  `edited_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp(),
  `id_odpowiedzialnego` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `kompetencje_obszar`
--

INSERT INTO `kompetencje_obszar` (`id`, `id_dzial`, `nazwa`, `opis`, `status`, `aktywny`, `created_by`, `edited_by`, `created_at`, `updated_at`, `id_odpowiedzialnego`) VALUES
(1, 1, 'Dżemy i ketchupy', 'Obszar produkcyjny linii A', 'aktywny', 1, 1, 1, '2025-06-25 21:29:08', '2025-08-05 11:25:31', 16),
(2, 1, 'Sosy', '', 'aktywny', 1, 1, 1, '2025-06-25 22:02:28', '2025-08-05 11:25:37', 17),
(3, 1, 'Antresola', 'test', 'aktywny', 1, 1, 1, '2025-07-01 13:17:42', '2025-08-05 11:25:22', 18),
(9, 2, 'Utrzymanie Ruchu', '', '', 1, 1, NULL, '2025-08-06 18:27:19', '2025-08-06 18:27:19', 19);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `kompetencje_oceny`
--

CREATE TABLE `kompetencje_oceny` (
  `id` int(11) NOT NULL,
  `id_uzytkownika` int(11) NOT NULL,
  `id_zasobu` int(11) NOT NULL,
  `poziom_oceny` tinyint(4) NOT NULL,
  `uwagi` text DEFAULT NULL,
  `aktywny` tinyint(4) DEFAULT 1,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL,
  `edited_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `kompetencje_oceny`
--

INSERT INTO `kompetencje_oceny` (`id`, `id_uzytkownika`, `id_zasobu`, `poziom_oceny`, `uwagi`, `aktywny`, `created_by`, `created_at`, `updated_at`, `edited_by`) VALUES
(1, 5, 3, 3, 'jest as', 1, 1, '2025-08-04 20:14:59', '2025-08-04 20:14:59', 1);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `kompetencje_pracownicy`
--

CREATE TABLE `kompetencje_pracownicy` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `id_dzial` int(11) NOT NULL,
  `id_obszar` int(11) DEFAULT NULL,
  `id_stanowisko` int(11) NOT NULL,
  `id_brygada` int(11) DEFAULT NULL,
  `aktywny` bit(1) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `edited_by` int(11) NOT NULL,
  `created_by` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `kompetencje_pracownicy`
--

INSERT INTO `kompetencje_pracownicy` (`id`, `user_id`, `id_dzial`, `id_obszar`, `id_stanowisko`, `id_brygada`, `aktywny`, `created_at`, `updated_at`, `edited_by`, `created_by`) VALUES
(1, 17, 1, 2, 6, NULL, b'1', '2025-08-05 14:21:22', '2025-08-06 11:29:09', 1, 0),
(2, 18, 1, 3, 6, NULL, b'1', '2025-08-06 11:11:21', '2025-08-06 11:33:10', 1, 1),
(3, 16, 1, 1, 6, NULL, b'1', '2025-08-06 11:17:24', '2025-08-06 11:17:24', 0, 1);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `kompetencje_relacje_nadzoru`
--

CREATE TABLE `kompetencje_relacje_nadzoru` (
  `id` int(11) NOT NULL,
  `supervisor_user_id` int(11) NOT NULL,
  `subordinate_user_id` int(11) NOT NULL,
  `poziom` enum('I','II') NOT NULL,
  `aktywny` tinyint(1) NOT NULL DEFAULT 1,
  `since_date` date NOT NULL DEFAULT curdate(),
  `until_date` date DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `until_date_eff` date GENERATED ALWAYS AS (coalesce(`until_date`,'9999-12-31')) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `kompetencje_relacje_nadzoru`
--

INSERT INTO `kompetencje_relacje_nadzoru` (`id`, `supervisor_user_id`, `subordinate_user_id`, `poziom`, `aktywny`, `since_date`, `until_date`, `created_at`) VALUES
(1, 1, 19, 'I', 1, '2025-09-10', NULL, '2025-09-10 22:34:43');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `kompetencje_skala_wartosci`
--

CREATE TABLE `kompetencje_skala_wartosci` (
  `id` int(20) NOT NULL,
  `id_skala` int(20) NOT NULL,
  `symbol` varchar(255) NOT NULL,
  `opis` varchar(500) DEFAULT NULL,
  `wartosc_num` int(11) DEFAULT NULL,
  `wartosc_proc` decimal(11,0) DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `edited_by` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `kompetencje_skala_wartosci`
--

INSERT INTO `kompetencje_skala_wartosci` (`id`, `id_skala`, `symbol`, `opis`, `wartosc_num`, `wartosc_proc`, `created_by`, `edited_by`, `created_at`, `updated_at`) VALUES
(1, 1, '0', 'nic nie umie', 0, '0', 0, 0, '2025-08-19 17:33:30', '2025-08-19 17:33:30'),
(2, 1, '1', 'w trakcie szkolenia', 1, '1', 0, 0, '2025-08-19 17:33:30', '2025-08-19 17:33:30'),
(3, 1, '2', 'może pracować pod nadzorem', 2, '2', 0, 0, '2025-08-19 17:33:30', '2025-08-19 17:33:30'),
(4, 1, '3', 'może pracować w pełni samodzielnie', 3, '3', 0, 0, '2025-08-19 17:33:30', '2025-08-19 17:33:30'),
(5, 1, '4', 'może szkolić innych', 4, '4', 0, 0, '2025-08-19 17:33:30', '2025-08-19 17:33:30'),
(6, 2, 'A', 'pozytywny', 3, '3', 0, 0, '2025-08-19 17:33:30', '2025-08-19 17:33:30'),
(7, 2, 'B', 'neutralny', 2, '2', 0, 0, '2025-08-19 17:33:30', '2025-08-19 17:33:30'),
(8, 2, 'C', 'negatywny', 1, '1', 0, 0, '2025-08-19 17:33:30', '2025-08-19 17:33:30'),
(10, 4, '0', NULL, 0, '0', 1, 0, '2025-08-28 11:17:57', '2025-08-28 11:17:57');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `kompetencje_skale`
--

CREATE TABLE `kompetencje_skale` (
  `id` int(20) NOT NULL,
  `nazwa` varchar(100) NOT NULL,
  `opis` text DEFAULT NULL,
  `aktywny` bit(10) NOT NULL,
  `created_by` int(11) DEFAULT NULL,
  `edited_by` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `kompetencje_skale`
--

INSERT INTO `kompetencje_skale` (`id`, `nazwa`, `opis`, `aktywny`, `created_by`, `edited_by`, `created_at`, `updated_at`) VALUES
(1, '0-4', NULL, b'0000000001', NULL, NULL, '2025-08-19 17:21:27', '2025-08-19 17:21:27'),
(2, 'A-C', NULL, b'0000000001', NULL, NULL, '2025-08-19 17:21:27', '2025-08-19 17:21:27'),
(3, 'test2', 'testa', b'0000110001', 1, 1, '2025-08-19 17:28:37', '2025-08-19 17:30:49'),
(4, '0/1', '', b'0000110001', 1, NULL, '2025-08-28 11:17:41', '2025-08-28 11:17:41');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `kompetencje_slownik`
--

CREATE TABLE `kompetencje_slownik` (
  `id` int(11) NOT NULL,
  `nazwa` varchar(255) NOT NULL,
  `opis` text DEFAULT NULL,
  `typ` enum('miękka','twarda') NOT NULL,
  `aktywny` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `edited_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `kompetencje_slownik`
--

INSERT INTO `kompetencje_slownik` (`id`, `nazwa`, `opis`, `typ`, `aktywny`, `created_at`, `created_by`, `updated_at`, `edited_by`) VALUES
(1, 'Obsługa maszyny', 'Umiejętność obsługi danej maszyny/urządzenia', 'twarda', 1, '2025-08-04 12:58:43', 1, '2025-08-04 13:00:18', 1);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `kompetencje_slownik_typ_zasobu`
--

CREATE TABLE `kompetencje_slownik_typ_zasobu` (
  `id` int(11) NOT NULL,
  `nazwa` varchar(100) NOT NULL,
  `opis` text NOT NULL,
  `aktywny` tinyint(1) NOT NULL,
  `created_by` int(11) NOT NULL,
  `edited_by` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `kompetencje_slownik_typ_zasobu`
--

INSERT INTO `kompetencje_slownik_typ_zasobu` (`id`, `nazwa`, `opis`, `aktywny`, `created_by`, `edited_by`, `created_at`, `updated_at`) VALUES
(1, 'Zakład', 'Zakład produkcyjny', 1, 1, 0, '2025-08-06 18:54:23', '2025-08-06 18:54:23'),
(2, 'Dział', 'Główna jednostka organizacyjna zakładu', 1, 1, 0, '2025-08-06 18:54:44', '2025-08-06 18:54:44'),
(3, 'Wydział', 'Pomniejsza jednostka organizacyjna zawierająca się w dziale', 1, 1, 1, '2025-08-06 18:55:07', '2025-08-06 18:55:51'),
(4, 'Obszar', 'Pomniejsza jednostka organizacyjna', 1, 1, 0, '2025-08-06 18:56:10', '2025-08-06 18:56:10');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `kompetencje_slownik_typ_zasobu_hr`
--

CREATE TABLE `kompetencje_slownik_typ_zasobu_hr` (
  `id` int(11) NOT NULL,
  `nazwa` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `opis` text CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `aktywny` tinyint(1) NOT NULL,
  `created_by` int(11) NOT NULL,
  `edited_by` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` int(11) NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `kompetencje_slownik_typ_zasobu_hr`
--

INSERT INTO `kompetencje_slownik_typ_zasobu_hr` (`id`, `nazwa`, `opis`, `aktywny`, `created_by`, `edited_by`, `created_at`, `updated_at`) VALUES
(1, 'Urządzenie', 'Urządzenie', 1, 1, 0, '2025-08-06 22:20:12', 2147483647),
(2, 'Umiejętność', '', 1, 1, 1, '2025-08-06 22:20:36', 2147483647);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `kompetencje_stanowiska`
--

CREATE TABLE `kompetencje_stanowiska` (
  `id` int(11) NOT NULL,
  `id_dzial` int(11) NOT NULL,
  `id_obszar` int(11) NOT NULL,
  `nazwa` varchar(100) NOT NULL,
  `opis` text DEFAULT NULL,
  `status` varchar(50) DEFAULT 'aktywny',
  `aktywny` tinyint(1) DEFAULT 1,
  `created_by` int(11) DEFAULT NULL,
  `edited_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `kompetencje_stanowiska`
--

INSERT INTO `kompetencje_stanowiska` (`id`, `id_dzial`, `id_obszar`, `nazwa`, `opis`, `status`, `aktywny`, `created_by`, `edited_by`, `created_at`, `updated_at`) VALUES
(1, 0, 0, 'Technolog', '', 'aktywny', 1, 1, 1, '2025-06-25 22:08:53', '2025-08-04 11:53:58'),
(4, 0, 0, 'Lider Brygady', '', 'aktywny', 1, 1, 1, '2025-06-25 23:00:33', '2025-08-04 11:54:02'),
(5, 0, 0, 'Operator', '', 'aktywny', 1, 1, 1, '2025-07-01 13:10:57', '2025-08-04 11:53:43'),
(6, 0, 0, 'Kierownik obszaru', '', 'aktywny', 1, 1, 1, '2025-07-14 11:43:58', '2025-07-14 11:43:58'),
(7, 0, 0, 'Dyrektor działu', 'test opisu stanowiska', '', 1, 1, 1, '2025-07-14 11:44:12', '2025-08-11 21:29:07'),
(9, 0, 0, 'Technik Utrzymania Ruchu', '', '', 1, 1, NULL, '2025-08-11 21:29:47', '2025-08-11 21:29:47'),
(10, 0, 0, 'Automatyk UR', '', '', 1, 1, NULL, '2025-08-28 13:16:26', '2025-08-28 13:16:26'),
(11, 0, 0, 'Operator', NULL, 'aktywny', 1, NULL, NULL, '2025-09-11 18:17:39', '2025-09-11 18:17:39'),
(12, 0, 0, 'Specjalista', NULL, 'aktywny', 1, NULL, NULL, '2025-09-11 18:17:39', '2025-09-11 18:17:39');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `kompetencje_stanowiska_poziomy`
--

CREATE TABLE `kompetencje_stanowiska_poziomy` (
  `id` int(11) NOT NULL,
  `id_stanowiska` int(11) NOT NULL,
  `nazwa` varchar(100) NOT NULL,
  `min_punkty` int(11) NOT NULL,
  `max_punkty` int(11) NOT NULL,
  `opis` text DEFAULT NULL,
  `pensja_min` decimal(12,2) DEFAULT NULL,
  `pensja_max` decimal(12,2) DEFAULT NULL,
  `waluta` char(3) DEFAULT NULL,
  `aktywny` tinyint(1) DEFAULT 1,
  `created_by` int(11) DEFAULT NULL,
  `edited_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `kompetencje_stanowiska_poziomy`
--

INSERT INTO `kompetencje_stanowiska_poziomy` (`id`, `id_stanowiska`, `nazwa`, `min_punkty`, `max_punkty`, `opis`, `pensja_min`, `pensja_max`, `waluta`, `aktywny`, `created_by`, `edited_by`, `created_at`, `updated_at`) VALUES
(1, 5, 'Młodszy operator', 0, 50, 'W trakcie szkolenia', NULL, NULL, NULL, 1, 1, NULL, '2025-08-05 13:33:16', '2025-08-05 13:33:16'),
(2, 5, 'Operator', 51, 100, 'Pracuje pod nadzorem', NULL, NULL, NULL, 1, 1, NULL, '2025-08-05 13:33:36', '2025-08-05 13:33:36'),
(3, 5, 'Starszy operator', 101, 200, 'Pracuje samodzielnie', NULL, NULL, NULL, 1, 1, NULL, '2025-08-05 13:34:25', '2025-08-05 13:34:25'),
(4, 5, 'Operator - trener', 201, 500, 'Może szkolić innych', NULL, NULL, NULL, 1, 1, NULL, '2025-08-05 13:34:59', '2025-08-05 13:34:59'),
(6, 7, 'Z-ca Dyrektoa', 50, 100, '', NULL, NULL, NULL, 1, 1, NULL, '2025-08-12 09:14:03', '2025-08-12 09:14:03'),
(7, 10, 'test', 50, 100, NULL, '1500.00', '2000.00', 'PLN', 1, NULL, NULL, '2025-09-16 21:56:34', '2025-09-16 21:56:34');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `kompetencje_stanowisko_wymagania`
--

CREATE TABLE `kompetencje_stanowisko_wymagania` (
  `id` int(11) NOT NULL,
  `id_stanowiska` int(11) NOT NULL,
  `typ` enum('hard','soft') NOT NULL,
  `id_kompetencji` int(11) NOT NULL,
  `min_wartosc` int(11) DEFAULT NULL,
  `preferowana_wartosc` int(11) DEFAULT NULL,
  `waga_override` int(11) DEFAULT NULL,
  `aktywny` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `kompetencje_struktura`
--

CREATE TABLE `kompetencje_struktura` (
  `id` int(11) NOT NULL,
  `nazwa` varchar(255) NOT NULL,
  `id_rodzica` int(11) DEFAULT NULL,
  `typ_zasobu_id` int(11) DEFAULT NULL,
  `id_odpowiedzialny` int(11) NOT NULL,
  `kolejnosc` int(11) DEFAULT 0,
  `aktywny` tinyint(1) DEFAULT 1,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_by` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `kompetencje_struktura`
--

INSERT INTO `kompetencje_struktura` (`id`, `nazwa`, `id_rodzica`, `typ_zasobu_id`, `id_odpowiedzialny`, `kolejnosc`, `aktywny`, `created_by`, `created_at`, `updated_by`, `updated_at`) VALUES
(1, 'ZPOW Agros Nova', NULL, 1, 6, 0, 1, 1, '2025-08-06 19:48:03', 1, '2025-08-06 21:14:34'),
(2, 'Dział Produkcji', 1, 2, 22, 0, 1, 1, '2025-08-06 19:48:12', 1, '2025-08-06 20:16:54'),
(3, 'Sosy', 2, 3, 17, 2, 1, 1, '2025-08-06 19:49:13', 1, '2025-08-06 20:17:02'),
(4, 'Dział Techniczny', 1, 2, 20, 1, 1, 1, '2025-08-06 19:58:30', 1, '2025-08-06 20:08:09'),
(5, 'Utrzymanie Ruchu', 4, 3, 19, 0, 1, 1, '2025-08-06 20:06:36', NULL, NULL),
(6, 'Wyrób gotwy', 5, NULL, 21, 1, 1, 1, '2025-08-06 20:17:36', NULL, NULL),
(7, 'Energetyka', 4, 3, 20, 1, 1, 1, '2025-08-06 21:01:15', NULL, NULL),
(8, 'Dział Administracji', 1, 2, 9, 2, 1, 1, '2025-08-06 21:07:27', 1, '2025-08-06 21:13:06'),
(9, 'Dżemy i ketchupy', 2, NULL, 16, 0, 1, 1, '2025-08-06 21:15:54', NULL, NULL),
(10, 'Antresola', 2, NULL, 18, 1, 1, 1, '2025-08-06 21:16:06', NULL, NULL),
(11, 'MWS', 4, NULL, 20, 2, 1, 1, '2025-08-06 21:16:29', NULL, NULL),
(12, 'Maszynownia chłodnicza', 7, NULL, 20, 2, 1, 1, '2025-08-06 21:16:52', NULL, NULL),
(13, 'Kotłownia', 7, NULL, 20, 0, 1, 1, '2025-08-06 21:17:24', NULL, NULL),
(14, 'Hydrofornia', 7, NULL, 20, 1, 1, 1, '2025-08-06 21:17:35', NULL, NULL),
(15, 'DZJ', 1, 2, 1, 3, 1, 1, '2025-08-06 21:18:01', NULL, NULL),
(16, 'Półfabrykat', 5, 4, 21, 0, 1, 1, '2025-08-12 09:08:54', NULL, NULL),
(17, 'Dżemy', 9, NULL, 19, NULL, 1, 1, '2025-08-27 21:52:43', NULL, NULL),
(18, 'Dżemy A', 17, 3, 6, NULL, 1, 1, '2025-08-27 21:53:02', NULL, NULL),
(19, 'Dżemy B', 17, 3, 9, NULL, 1, 1, '2025-08-27 21:53:19', NULL, NULL),
(20, 'Ketchupy', 9, 4, 5, NULL, 1, 1, '2025-08-28 13:06:18', NULL, NULL);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `kompetencje_struktura_hr`
--

CREATE TABLE `kompetencje_struktura_hr` (
  `id` int(11) NOT NULL,
  `id_rodzica` int(11) DEFAULT NULL,
  `kolejnosc` int(11) NOT NULL,
  `nazwa` varchar(255) NOT NULL,
  `id_typ_zasobu` int(11) DEFAULT NULL,
  `opis` text DEFAULT NULL,
  `aktywny` tinyint(4) DEFAULT 1,
  `id_powiazany_zasob` int(11) DEFAULT NULL,
  `is_kompetencja` tinyint(1) NOT NULL DEFAULT 0,
  `is_soft` tinyint(1) NOT NULL DEFAULT 0,
  `id_skala` int(11) DEFAULT NULL,
  `waga_domyslna` int(11) DEFAULT NULL,
  `created_by` int(11) NOT NULL,
  `edited_by` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` int(11) NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `kompetencje_struktura_hr`
--

INSERT INTO `kompetencje_struktura_hr` (`id`, `id_rodzica`, `kolejnosc`, `nazwa`, `id_typ_zasobu`, `opis`, `aktywny`, `id_powiazany_zasob`, `is_kompetencja`, `is_soft`, `id_skala`, `waga_domyslna`, `created_by`, `edited_by`, `created_at`, `updated_at`) VALUES
(2, NULL, 0, 'Agros', NULL, NULL, 1, NULL, 0, 0, NULL, NULL, 1, 0, '2025-08-06 23:55:44', 2147483647),
(3, 2, 1, 'Produkcja', NULL, NULL, 1, NULL, 0, 0, NULL, NULL, 1, 1, '2025-08-07 00:42:42', 2147483647),
(4, 3, 0, 'Linia dżemowa', NULL, NULL, 1, 3, 0, 0, NULL, NULL, 1, 0, '2025-08-07 07:22:27', 2147483647),
(5, 4, 0, 'Kuchnia SELO', NULL, NULL, 1, NULL, 0, 0, NULL, NULL, 1, 1, '2025-08-07 07:22:47', 2147483647),
(6, 4, 1, 'Depaletyzator', NULL, NULL, 1, 13, 0, 0, NULL, NULL, 1, 1, '2025-08-07 07:23:02', 2147483647),
(7, 4, 2, 'Myjka', NULL, NULL, 1, 14, 0, 0, NULL, NULL, 1, 0, '2025-08-11 14:57:31', 2147483647),
(8, 4, 3, 'Dozownica', NULL, NULL, 1, 15, 0, 0, NULL, NULL, 1, 0, '2025-08-11 14:57:43', 2147483647),
(9, 3, 1, 'Linia sosowa', NULL, NULL, 1, 4, 0, 0, NULL, NULL, 1, 0, '2025-08-11 20:46:45', 2147483647),
(10, 9, 0, 'Dozownica', NULL, NULL, 1, 11, 0, 0, NULL, NULL, 1, 0, '2025-08-11 20:46:56', 2147483647),
(11, 9, 1, 'Etykieciarka', NULL, NULL, 1, 18, 0, 0, NULL, NULL, 1, 0, '2025-08-11 20:47:30', 2147483647),
(12, 9, 2, 'Zamykarka', NULL, NULL, 1, 16, 0, 0, NULL, NULL, 1, 0, '2025-08-11 20:57:05', 2147483647),
(13, 9, 3, 'Pasteryzator', NULL, NULL, 1, 17, 0, 0, NULL, NULL, 1, 0, '2025-08-11 20:58:32', 2147483647),
(16, 2, 0, 'Kompetencje miękkie', NULL, NULL, 1, NULL, 1, 0, 2, 50, 1, 1, '2025-08-11 22:02:08', 2147483647),
(17, 7, 0, 'Umiejętność obsługi', NULL, NULL, 1, 14, 1, 0, 1, 100, 1, 1, '2025-08-11 22:10:35', 2147483647),
(18, 19, 0, 'Umiejętności mechaniczne', 2, NULL, 1, 14, 1, 0, 1, 25, 1, 0, '2025-08-11 22:25:22', 2147483647),
(19, 7, 1, 'Techniczne', NULL, NULL, 1, 14, 0, 0, NULL, NULL, 1, 0, '2025-08-11 22:34:01', 2147483647),
(20, 16, 0, 'Kominikacja', NULL, NULL, 1, NULL, 1, 1, 2, NULL, 1, 1, '2025-08-11 22:43:26', 2147483647),
(21, 16, 0, 'Przekazywanie wiedzy', NULL, NULL, 1, NULL, 1, 1, 2, NULL, 1, 0, '2025-08-11 22:43:57', 2147483647),
(22, 2, 0, 'Utrzmanie Ruchu', NULL, NULL, 1, NULL, 0, 0, NULL, NULL, 1, 1, '2025-08-12 09:11:34', 2147483647),
(23, 22, 0, 'Automatyk', 2, NULL, 1, NULL, 1, 0, 1, 12, 1, 1, '2025-08-12 09:12:21', 2147483647),
(24, 16, 0, 'Komunikacja werbalna', NULL, NULL, 1, NULL, 1, 1, 2, NULL, 1, 0, '2025-08-28 13:09:47', 2147483647),
(25, 7, 0, 'sprzątanie', NULL, 'umie posługiwać się szczotką', 1, 14, 1, 0, 1, 56, 1, 0, '2025-08-28 13:11:16', 2147483647);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `kompetencje_struktura_hr_stanowisko`
--

CREATE TABLE `kompetencje_struktura_hr_stanowisko` (
  `id` int(11) NOT NULL,
  `id_wezla` int(11) NOT NULL,
  `id_stanowiska` int(11) NOT NULL,
  `aktywny` tinyint(1) NOT NULL DEFAULT 1,
  `waga_override` int(11) DEFAULT NULL,
  `id_skala_override` int(11) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `kompetencje_struktura_hr_stanowisko`
--

INSERT INTO `kompetencje_struktura_hr_stanowisko` (`id`, `id_wezla`, `id_stanowiska`, `aktywny`, `waga_override`, `id_skala_override`, `created_by`, `updated_by`, `created_at`, `updated_at`) VALUES
(4, 17, 5, 1, NULL, NULL, 1, 1, '2025-08-11 22:13:59', '2025-08-11 22:13:59'),
(5, 17, 9, 1, NULL, NULL, 1, 1, '2025-08-11 22:13:59', '2025-08-11 22:13:59'),
(6, 18, 9, 1, NULL, NULL, 1, 1, '2025-08-11 22:25:22', '2025-08-11 22:25:22'),
(7, 16, 5, 1, NULL, NULL, 1, 1, '2025-08-11 22:38:54', '2025-08-11 22:38:54'),
(8, 16, 1, 1, NULL, NULL, 1, 1, '2025-08-11 22:38:54', '2025-08-11 22:38:54'),
(10, 21, 5, 1, NULL, NULL, 1, 1, '2025-08-11 22:43:57', '2025-08-11 22:43:57'),
(14, 20, 5, 1, NULL, NULL, 1, 1, '2025-08-11 22:53:09', '2025-08-11 22:53:09'),
(15, 20, 9, 1, NULL, NULL, 1, 1, '2025-08-11 22:53:09', '2025-08-11 22:53:09'),
(16, 20, 1, 1, NULL, NULL, 1, 1, '2025-08-11 22:53:09', '2025-08-11 22:53:09'),
(20, 23, 9, 1, NULL, NULL, 1, 1, '2025-08-27 21:54:01', '2025-08-27 21:54:01'),
(21, 24, 4, 1, NULL, NULL, 1, 1, '2025-08-28 13:09:47', '2025-08-28 13:09:47'),
(22, 24, 5, 1, NULL, NULL, 1, 1, '2025-08-28 13:09:47', '2025-08-28 13:09:47'),
(23, 24, 9, 1, NULL, NULL, 1, 1, '2025-08-28 13:09:47', '2025-08-28 13:09:47'),
(24, 24, 1, 1, NULL, NULL, 1, 1, '2025-08-28 13:09:47', '2025-08-28 13:09:47'),
(25, 25, 5, 1, NULL, NULL, 1, 1, '2025-08-28 13:11:16', '2025-08-28 13:11:16');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `kompetencje_szkolenia_map`
--

CREATE TABLE `kompetencje_szkolenia_map` (
  `id` int(11) NOT NULL,
  `typ` enum('hard','soft') NOT NULL,
  `id_kompetencji` int(11) NOT NULL,
  `szkolenie_id` int(11) NOT NULL,
  `rekomendowane_przy_braku_min` tinyint(1) NOT NULL DEFAULT 1,
  `aktywny` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_polish_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `kompetencje_twarde_oceny`
--

CREATE TABLE `kompetencje_twarde_oceny` (
  `id` int(11) NOT NULL,
  `id_uzytkownika` int(11) NOT NULL,
  `id_zasobu` int(11) NOT NULL,
  `wartosc` int(11) NOT NULL,
  `komentarz` text DEFAULT NULL,
  `data_oceny` date NOT NULL DEFAULT curdate(),
  `is_exam` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `edited_by` int(11) DEFAULT NULL,
  `rater_id` int(11) DEFAULT NULL,
  `rater_level` enum('I','II') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `kompetencje_twarde_oceny`
--

INSERT INTO `kompetencje_twarde_oceny` (`id`, `id_uzytkownika`, `id_zasobu`, `wartosc`, `komentarz`, `data_oceny`, `is_exam`, `created_at`, `created_by`, `updated_at`, `edited_by`, `rater_id`, `rater_level`) VALUES
(1, 5, 3, 4, 'no jest mistrz', '2025-08-04', 0, '2025-08-04 21:17:10', 1, NULL, NULL, NULL, NULL),
(2, 5, 2, 1, 'no coś tam umie', '2025-08-04', 0, '2025-08-04 21:21:16', 1, '2025-08-04 21:44:26', 1, NULL, NULL),
(3, 6, 3, 2, '', '2025-08-04', 0, '2025-08-04 21:28:12', 1, NULL, NULL, NULL, NULL),
(4, 17, 4, 2, '', '2025-08-07', 0, '2025-08-07 15:09:01', 1, NULL, NULL, NULL, NULL),
(5, 21, 3, 2, 'no nie umie przezbroic', '2025-08-12', 0, '2025-08-12 09:16:02', 1, NULL, NULL, NULL, NULL),
(6, 19, 4, 1, '', '2025-08-12', 0, '2025-08-12 09:46:46', 1, NULL, NULL, NULL, NULL),
(7, 18, 4, 3, '', '2025-08-27', 0, '2025-08-27 20:59:49', 1, NULL, NULL, NULL, NULL),
(8, 17, 3, 2, '', '2025-08-28', 0, '2025-08-28 13:19:04', 1, NULL, NULL, NULL, NULL),
(9, 5, 4, 3, NULL, '2025-09-11', 1, '2025-09-11 12:27:38', NULL, '2025-09-11 12:39:40', NULL, 1, 'I'),
(17, 5, 3, 1, NULL, '2025-09-11', 1, '2025-09-11 12:38:14', NULL, '2025-09-11 13:54:12', NULL, 1, 'I'),
(21, 5, 2, 4, NULL, '2025-09-11', 1, '2025-09-11 13:55:38', NULL, '2025-09-11 13:55:41', NULL, 1, 'I'),
(23, 21, 4, 2, NULL, '2025-09-11', 0, '2025-09-11 17:21:20', NULL, NULL, NULL, 1, 'I'),
(24, 25, 4, 1, NULL, '2025-09-11', 0, '2025-09-11 17:21:28', NULL, NULL, NULL, 1, 'I'),
(25, 19, 4, 1, NULL, '2025-09-11', 1, '2025-09-11 17:21:32', NULL, NULL, NULL, 1, 'I'),
(26, 19, 3, 2, NULL, '2025-09-16', 0, '2025-09-16 13:36:32', NULL, NULL, NULL, 1, 'I'),
(27, 19, 2, 4, NULL, '2025-09-16', 1, '2025-09-16 13:36:38', NULL, NULL, NULL, 1, 'I'),
(28, 5, 4, 0, NULL, '2025-09-16', 0, '2025-09-16 20:20:14', NULL, '2025-09-16 20:20:58', NULL, 1, 'I');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `kompetencje_twarde_zasoby`
--

CREATE TABLE `kompetencje_twarde_zasoby` (
  `id` int(11) NOT NULL,
  `nazwa` varchar(255) NOT NULL,
  `typ_obszaru` varchar(255) NOT NULL,
  `waga` int(11) NOT NULL,
  `id_skala` int(11) NOT NULL,
  `id_struktury` int(11) DEFAULT NULL,
  `aktywny` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `edited_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `kompetencje_twarde_zasoby`
--

INSERT INTO `kompetencje_twarde_zasoby` (`id`, `nazwa`, `typ_obszaru`, `waga`, `id_skala`, `id_struktury`, `aktywny`, `created_at`, `created_by`, `updated_at`, `edited_by`) VALUES
(2, 'Myjka', 'mechaniczne', 37, 1, 14, 1, '2025-08-04 19:35:49', 1, '2025-09-10 23:40:18', 1),
(3, 'Etykieciarka', 'elektryczne', 23, 1, 10, 1, '2025-08-04 19:38:55', 1, '2025-09-10 23:40:23', 1),
(4, 'Dozownica sosowa', 'operatorskie', 50, 1, 11, 1, '2025-08-04 23:40:08', 1, '2025-09-10 23:40:27', 1);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `mes_nonprod_activity`
--

CREATE TABLE `mes_nonprod_activity` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(32) NOT NULL,
  `name` varchar(128) NOT NULL,
  `planowana` tinyint(1) NOT NULL DEFAULT 0,
  `create_cmms_ticket` tinyint(1) NOT NULL DEFAULT 0,
  `aktywny` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `mes_resource_group`
--

CREATE TABLE `mes_resource_group` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(128) NOT NULL,
  `opis` varchar(500) DEFAULT NULL,
  `root_struktura_id` int(10) UNSIGNED DEFAULT NULL,
  `bind_mode` enum('subtree','explicit') NOT NULL DEFAULT 'explicit',
  `aktywny` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `mes_resource_group`
--

INSERT INTO `mes_resource_group` (`id`, `name`, `opis`, `root_struktura_id`, `bind_mode`, `aktywny`, `created_at`, `updated_at`) VALUES
(1, 'Dozownica dżemowa', '', NULL, 'explicit', 1, '2025-09-01 20:16:23', '2025-09-05 10:50:27'),
(4, 'test', '', NULL, 'explicit', 1, '2025-09-01 22:40:08', '2025-09-05 10:50:30');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `mes_resource_group_item`
--

CREATE TABLE `mes_resource_group_item` (
  `group_id` int(10) UNSIGNED NOT NULL,
  `struktura_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `mes_resource_group_item`
--

INSERT INTO `mes_resource_group_item` (`group_id`, `struktura_id`) VALUES
(1, 9),
(1, 20),
(1, 21),
(4, 17),
(4, 18);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `mes_route`
--

CREATE TABLE `mes_route` (
  `id` int(10) UNSIGNED NOT NULL,
  `sku` varchar(64) NOT NULL,
  `operacja_kod` varchar(64) NOT NULL,
  `resource_group_id` int(10) UNSIGNED NOT NULL,
  `takt_sec` int(10) UNSIGNED NOT NULL,
  `target_per_hour` decimal(10,2) GENERATED ALWAYS AS (3600 / nullif(`takt_sec`,0)) STORED,
  `yield_target` decimal(5,2) DEFAULT NULL,
  `aktywny` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `mes_scrap_reason`
--

CREATE TABLE `mes_scrap_reason` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(32) NOT NULL,
  `name` varchar(128) NOT NULL,
  `aktywny` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `mes_sic_config`
--

CREATE TABLE `mes_sic_config` (
  `id` int(10) UNSIGNED NOT NULL,
  `sku` varchar(64) NOT NULL,
  `operacja_kod` varchar(64) NOT NULL,
  `resource_group_id` int(10) UNSIGNED NOT NULL,
  `interwal_min` smallint(5) UNSIGNED NOT NULL DEFAULT 60,
  `tolerancja_proc` decimal(5,2) NOT NULL DEFAULT 5.00,
  `prog_czerwony_proc` decimal(5,2) NOT NULL DEFAULT 10.00,
  `auto_popup` tinyint(1) NOT NULL DEFAULT 1,
  `aktywny` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `mes_sic_entry`
--

CREATE TABLE `mes_sic_entry` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `run_id` bigint(20) UNSIGNED NOT NULL,
  `ts` datetime NOT NULL,
  `mode` enum('production','activity') NOT NULL,
  `qty_ok` int(10) UNSIGNED DEFAULT NULL,
  `qty_scrap` int(10) UNSIGNED DEFAULT NULL,
  `scrap_reason_id` int(10) UNSIGNED DEFAULT NULL,
  `nva_id` int(10) UNSIGNED DEFAULT NULL,
  `nva_note` varchar(500) DEFAULT NULL,
  `status_kolor` enum('green','yellow','red') NOT NULL,
  `created_by` int(10) UNSIGNED DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `mes_sic_run`
--

CREATE TABLE `mes_sic_run` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `zlecenie_nr` varchar(64) NOT NULL,
  `sku` varchar(64) NOT NULL,
  `operacja_kod` varchar(64) NOT NULL,
  `resource_group_id` int(10) UNSIGNED NOT NULL,
  `rozpoczecie` datetime NOT NULL,
  `zakonczenie` datetime DEFAULT NULL,
  `zmiana` varchar(16) DEFAULT NULL,
  `operator_id` int(10) UNSIGNED DEFAULT NULL,
  `aktywny` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `modules`
--

CREATE TABLE `modules` (
  `id` int(11) NOT NULL,
  `code` varchar(50) NOT NULL,
  `name_pl` varchar(100) NOT NULL,
  `name_en` varchar(100) NOT NULL,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `modules`
--

INSERT INTO `modules` (`id`, `code`, `name_pl`, `name_en`, `is_active`) VALUES
(1, 'cmms', 'CMMS – Utrzymanie Ruchu', 'CMMS – Maintenance', 1),
(2, 'mes', 'MES – Produkcja', 'MES – Manufacturing', 1),
(3, 'szkolenia', 'Szkolenia', 'Trainings', 1),
(4, 'matryca', 'Matryca kompetencji', 'Skills Matrix', 1);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `key_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(50) NOT NULL,
  `is_system` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `roles`
--

INSERT INTO `roles` (`id`, `key_name`, `name`, `is_system`, `created_at`, `updated_at`) VALUES
(1, '', 'admin', 1, '2025-08-25 16:44:54', '2025-08-27 20:18:01'),
(2, '', 'user', 1, '2025-08-25 16:44:54', '0000-00-00 00:00:00'),
(3, 'admin', 'Administrator', 1, '2025-08-26 20:26:51', '0000-00-00 00:00:00'),
(4, 'cmms_manager', 'CMMS Manager', 1, '2025-08-26 20:26:51', '2025-09-10 14:17:42'),
(5, 'cmms_user', 'CMMS Użytkownik', 1, '2025-08-26 20:26:51', '0000-00-00 00:00:00'),
(6, 'mes_viewer', 'MES Viewer', 0, '2025-08-26 20:26:51', '0000-00-00 00:00:00'),
(7, 'kompetencje_manager', 'Kompetencje Manager', 1, '2025-08-26 20:26:51', '0000-00-00 00:00:00'),
(8, 'szkolenia_admin', 'Szkolenia Admin', 1, '2025-08-26 20:26:51', '0000-00-00 00:00:00'),
(10, '', 'test', 0, '2025-08-27 18:27:12', '0000-00-00 00:00:00'),
(11, 'kompetencje_admin', 'Kompetencje Admin', 1, '2025-09-10 20:16:12', '2025-09-10 22:16:12'),
(12, 'kompetencje_hr', 'HR Kompetencje', 0, '2025-09-10 20:16:12', '2025-09-10 22:16:12'),
(13, 'kompetencje_l1', 'Kompetencje L1', 0, '2025-09-10 20:16:12', '2025-09-10 22:16:12'),
(14, 'kompetencje_l2', 'Kompetencje L2', 0, '2025-09-10 20:16:12', '2025-09-10 22:16:12'),
(15, 'kompetencje_viewer', 'Kompetencje Podgląd', 0, '2025-09-10 20:16:12', '2025-09-10 22:16:12');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `role_permissions`
--

CREATE TABLE `role_permissions` (
  `role_id` int(11) NOT NULL,
  `perm_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `struktura`
--

CREATE TABLE `struktura` (
  `id` int(11) NOT NULL,
  `nazwa` varchar(255) NOT NULL,
  `id_rodzica` int(11) DEFAULT NULL,
  `kolejnosc` int(11) NOT NULL DEFAULT 0,
  `typ_zasobu_id` int(11) DEFAULT NULL,
  `mpk_linia_id` int(11) DEFAULT NULL,
  `element_id` int(11) DEFAULT NULL,
  `aktywny` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `edited_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `struktura`
--

INSERT INTO `struktura` (`id`, `nazwa`, `id_rodzica`, `kolejnosc`, `typ_zasobu_id`, `mpk_linia_id`, `element_id`, `aktywny`, `created_at`, `updated_at`, `created_by`, `edited_by`) VALUES
(1, 'Zakład', NULL, 0, NULL, NULL, NULL, 1, '2025-06-18 21:52:40', '2025-06-18 21:52:40', 1, NULL),
(2, 'Budynek produkcyjny', 1, 0, NULL, 1, 1, 1, '2025-06-18 21:53:18', '2025-06-18 21:53:18', 1, NULL),
(3, 'Linia dżemowa', 2, 0, NULL, 5, 3, 1, '2025-06-18 21:53:44', '2025-08-04 11:45:06', 1, 1),
(4, 'Linia sosowa', 2, 1, NULL, 2, 3, 1, '2025-06-18 21:54:02', '2025-08-25 14:23:02', 1, 1),
(10, 'Etykieciarka', 3, 5, 8, 5, 4, 1, '2025-06-24 09:07:58', '2025-08-07 00:43:33', 1, 1),
(11, 'Dozownica', 4, 0, 2, 3, 4, 1, '2025-06-25 19:30:50', '2025-08-07 15:03:42', 1, NULL),
(12, 'Kuchnia SELO', 3, 0, 5, 5, 4, 1, '2025-08-04 10:55:15', '2025-08-07 00:43:33', 1, NULL),
(13, 'Depaletyzator', 3, 1, 1, 5, 4, 1, '2025-08-04 10:55:33', '2025-08-07 00:43:33', 1, NULL),
(14, 'Myjka', 3, 2, 6, 5, 4, 1, '2025-08-04 10:56:03', '2025-08-07 00:43:33', 1, NULL),
(15, 'Dozownica', 3, 3, 2, 5, 4, 1, '2025-08-04 10:56:21', '2025-08-07 00:43:33', 1, NULL),
(16, 'Zamykarka', 3, 4, 3, 5, 4, 1, '2025-08-04 10:56:36', '2025-08-07 00:43:33', 1, NULL),
(17, 'Pasteryzator', 3, 6, 7, 5, 4, 1, '2025-08-04 11:43:38', '2025-08-07 15:03:42', 1, NULL),
(18, 'Etykieciarka', 4, 1, 8, 5, 4, 1, '2025-08-04 11:44:01', '2025-08-07 15:03:42', 1, NULL),
(19, 'Zbiornik 1', 12, 0, 8, 5, 4, 1, '2025-08-29 13:44:46', '2025-08-29 13:44:46', 1, NULL);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `struktura_edycja_log`
--

CREATE TABLE `struktura_edycja_log` (
  `id` int(11) NOT NULL,
  `id_zasobu` int(11) NOT NULL,
  `stare_id_rodzica` int(11) DEFAULT NULL,
  `nowe_id_rodzica` int(11) DEFAULT NULL,
  `stara_kolejnosc` int(11) DEFAULT NULL,
  `nowa_kolejnosc` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `struktura_slownik_element`
--

CREATE TABLE `struktura_slownik_element` (
  `id` int(11) NOT NULL,
  `nazwa` varchar(100) NOT NULL,
  `opis` text DEFAULT NULL,
  `aktywny` tinyint(1) DEFAULT 1,
  `created_by` int(11) DEFAULT NULL,
  `edited_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `struktura_slownik_element`
--

INSERT INTO `struktura_slownik_element` (`id`, `nazwa`, `opis`, `aktywny`, `created_by`, `edited_by`, `created_at`, `updated_at`) VALUES
(1, 'Budynek produkcyjny', 'główna siła robocza', 1, NULL, 1, '2025-06-18 08:49:19', '2025-06-18 20:02:53'),
(2, 'Budynek biurowy', 'miejsce królów i królowych', 1, NULL, 1, '2025-06-18 08:49:41', '2025-06-18 20:03:05'),
(3, 'Linia produkcyjna', '', 1, 1, 1, '2025-06-18 19:58:05', '2025-06-18 19:58:05'),
(4, 'Urządzenie', 'tania siła robocza', 1, 1, 1, '2025-06-18 20:09:15', '2025-06-18 20:09:15');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `struktura_slownik_mpk_linia`
--

CREATE TABLE `struktura_slownik_mpk_linia` (
  `id` int(10) UNSIGNED NOT NULL,
  `mpk` varchar(50) NOT NULL,
  `nazwa` varchar(255) NOT NULL,
  `opis` text DEFAULT NULL,
  `aktywny` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `struktura_slownik_mpk_linia`
--

INSERT INTO `struktura_slownik_mpk_linia` (`id`, `mpk`, `nazwa`, `opis`, `aktywny`, `created_at`, `updated_at`, `created_by`, `updated_by`) VALUES
(2, 'PL321P3020', 'Dział Mechaniczny', 'Królowie żyta', 1, '2025-06-18 12:01:44', '2025-06-18 21:40:30', 1, 1),
(3, 'PL321P3060', 'Dział Techniczny', 'Z woli Thora i Odyna', 1, '2025-06-18 21:39:01', '2025-06-18 21:39:01', 1, NULL),
(4, 'PL321P1126', 'Linia ketchupowa', '', 1, '2025-08-04 10:53:43', '2025-08-04 10:53:43', 1, NULL),
(5, 'PL321P1153', 'Linia dżemowa', '', 1, '2025-08-04 10:54:12', '2025-08-04 10:54:12', 1, NULL);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `struktura_slownik_typ_zasobu`
--

CREATE TABLE `struktura_slownik_typ_zasobu` (
  `id` int(11) NOT NULL,
  `nazwa` varchar(100) NOT NULL,
  `opis` text DEFAULT NULL,
  `aktywny` tinyint(1) DEFAULT 1,
  `created_by` int(11) DEFAULT NULL,
  `edited_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `struktura_slownik_typ_zasobu`
--

INSERT INTO `struktura_slownik_typ_zasobu` (`id`, `nazwa`, `opis`, `aktywny`, `created_by`, `edited_by`, `created_at`, `updated_at`) VALUES
(1, 'Depaletyzator', 'urządzenie do rozładunku opakowań', 1, 1, 1, '2025-06-18 20:35:34', '2025-06-18 20:50:10'),
(2, 'Dozownica', '', 1, 1, NULL, '2025-06-18 22:10:49', '2025-06-18 22:10:49'),
(3, 'Zamykarka', '', 1, 1, NULL, '2025-06-18 22:10:56', '2025-06-18 22:10:56'),
(5, 'Kuchnia', 'Obszar przygotowania wsadu', 1, 1, NULL, '2025-08-04 10:51:28', '2025-08-04 10:51:28'),
(6, 'Myjka', 'Myjka opakowań', 1, 1, NULL, '2025-08-04 10:51:42', '2025-08-04 10:51:42'),
(7, 'Pasteryzator', '', 1, 1, NULL, '2025-08-04 10:52:45', '2025-08-04 10:52:45'),
(8, 'Etykieciarka', '', 1, 1, NULL, '2025-08-04 10:52:56', '2025-08-04 10:52:56'),
(9, 'Pakowaczka', '', 1, 1, NULL, '2025-08-04 10:53:02', '2025-08-04 10:53:02'),
(10, 'Paletyzator', '', 1, 1, NULL, '2025-08-04 10:53:07', '2025-08-04 10:53:07');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `system_settings`
--

CREATE TABLE `system_settings` (
  `key` varchar(100) NOT NULL,
  `value` text NOT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `updated_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `login` varchar(100) NOT NULL,
  `imie` varchar(100) NOT NULL,
  `nazwisko` varchar(255) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `telefon` varchar(30) DEFAULT NULL,
  `numerPracownika` varchar(30) DEFAULT NULL,
  `haslo` varchar(255) NOT NULL,
  `pin` char(6) DEFAULT NULL,
  `role` enum('admin','leader','user') CHARACTER SET utf8mb4 COLLATE utf8mb4_polish_ci DEFAULT 'user',
  `language` varchar(5) DEFAULT 'pl',
  `access_cmms` tinyint(1) DEFAULT 1,
  `access_mes` tinyint(1) DEFAULT 1,
  `access_kompetencje` tinyint(1) DEFAULT 1,
  `access_szkolenia` tinyint(1) NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `role_id` int(11) DEFAULT NULL,
  `aktywny` tinyint(1) NOT NULL,
  `force_pw_change` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `users`
--

INSERT INTO `users` (`id`, `login`, `imie`, `nazwisko`, `name`, `email`, `telefon`, `numerPracownika`, `haslo`, `pin`, `role`, `language`, `access_cmms`, `access_mes`, `access_kompetencje`, `access_szkolenia`, `is_active`, `created_at`, `updated_at`, `role_id`, `aktywny`, `force_pw_change`) VALUES
(1, 'admin', 'Admin', 'Admin', 'admin', 'admin@wp.pl', '', '000000', '$2y$10$xTeChpLyU9OZupDzh7.CdOngju86VknVRuBJIQ3jJgqOiE1gECgeW', '666666', 'admin', 'pl', 1, 1, 1, 1, 1, '2025-06-10 20:42:26', '2025-09-11 13:25:54', 1, 1, 0),
(4, 'bobel', 'Marcin', 'Pietraszewski', '', 'm.pietraszewski@maspex.com', '', '00006', '$2y$10$UB8qET2ytsY0ct2IBeed2usCN4ULqqouxRSrFMkn3F3sD8VJHy6j6', '123456', 'admin', 'pl', 1, 1, 1, 0, 1, '2025-06-25 20:05:03', '2025-09-09 19:56:27', NULL, 1, 0),
(5, 'Marcin Bobel', 'Marcin', 'Bobel', '', 'm.bobel@maspex.com', '', '010101', '$2y$10$EP9Jyk89Uy6uN/JiYVRj5.J327c3X8FoXukRQtHv5azaqN.3hvDY.', '654321', 'user', 'pl', 1, 0, 0, 0, 1, '2025-07-07 20:51:40', '2025-09-09 19:27:29', NULL, 1, 1),
(6, '', 'Brygada A', 'Lider', '', 'a@wp.pl', '', '', '$2y$10$6/zX/5w/TLpTPHmd6vVs7enN83xuznLYZlpQ4Bk8h5pgOFa2nmN82', '000001', 'user', 'pl', 1, 1, 1, 0, 1, '2025-07-14 11:38:44', '2025-09-09 23:08:51', NULL, 1, 0),
(9, '', 'Brygada B', 'Lider', '', 'b@wp.pl', '', '000002', '$2y$10$Jmixikm4GF0KBekCReDMjePuCSMOdKxiqFeie4BkaYwnTjmOQPXGK', '000002', 'user', 'pl', 0, 0, 1, 0, 1, '2025-07-14 11:40:33', '2025-09-09 19:56:17', NULL, 1, 0),
(10, '', 'Brygada C', 'Lider', '', 'c@wp.pl', '', '0000004', '$2y$10$HMM8RzzPM5zvEoTSs9iA.u11sb3RhTEuJcQBWH7kJWlgqC2eblqxu', '000004', 'user', 'pl', 0, 0, 1, 0, 1, '2025-08-04 09:39:45', '2025-09-09 19:56:19', NULL, 1, 0),
(13, '', 'Brygada D', 'Lider', '', 'd@wp.pl', '', '000005', '$2y$10$lzpvdSPhshrqsIwYmVwjO.EWM/2h6mI4Itmtwc.ws5/UwL/pIusS2', '000005', 'user', 'pl', 0, 0, 1, 0, 1, '2025-08-04 10:01:57', '2025-09-09 19:56:20', NULL, 1, 0),
(16, '', 'Adam', 'Stefański', '', 'a.stefanski@m.pl', '', '000011', '$2y$10$U8MTn0oEw8pfsVzZuioeWekksFv8LT/zHFdrfasKItOYgKb0qLSpK', '000011', 'user', 'pl', 1, 1, 1, 0, 1, '2025-08-05 11:20:04', '2025-08-24 23:28:36', NULL, 0, 0),
(17, '', 'Justyna', 'Błazińska', '', 'j.blazinska@m.pl', '', '000012', '$2y$10$keCTXCz.Pj/UbrstVBfWE.hb9jwptzJk85UIjPuutUJ8HPFOlqo6W', '000012', 'user', 'pl', 1, 1, 1, 0, 1, '2025-08-05 11:20:28', '2025-09-09 19:56:06', NULL, 1, 0),
(18, '', 'Mariusz', 'Janus', '', 'm.janus@m.pl', '', '000013', '$2y$10$VeZjnfvuRt58nkoIo7IF9uOxJTnMq3L.zi8sm5zTUcv8xz1vEHiPS', '000013', 'user', 'pl', 1, 1, 1, 0, 1, '2025-08-05 11:20:46', '2025-09-09 19:56:14', NULL, 1, 0),
(19, '', 'Adam', 'Graszka', '', 'a.graszka@m.pl', '', '000021', '$2y$10$Q3dN3rA1.Bx4HX4QAQ6ok.44UyPLsXwcHEiOzt2forMEyJkhf1MeK', '000021', 'user', 'pl', 1, 1, 1, 0, 1, '2025-08-05 12:47:25', '2025-09-09 19:56:13', NULL, 1, 0),
(20, '', 'Dariusz', 'Panek', '', 'd.panek@m.pl', '', '000020', '$2y$10$gcJ5buR3Z2HMooveF2XGzex6BCw0F0gcsOfNnlYI./oI68bq4VWFm', '000020', 'user', 'pl', 1, 1, 1, 0, 1, '2025-08-05 12:47:44', '2025-09-09 19:56:25', NULL, 1, 0),
(21, '', 'Grzegorz', 'Bryk', '', 'g.bryk@m.pl', '', '000022', '$2y$10$GarfQ.Y8R6BMr/CS1YinxeyntDuY2wLFobCM661zv2CV.GvwAYYb6', '000022', 'user', 'pl', 1, 1, 1, 0, 1, '2025-08-05 12:48:17', '2025-09-09 19:56:03', NULL, 1, 0),
(22, '', 'Piotr', 'Modelewski', '', 'p.modelewski@m.pl', '', '0000009', '$2y$10$gI5L7SpuVZoDZeLK3olvp.Ef5JAbwgxl8u3GoyVgi2yyy8e40uq3q', '000000', 'user', 'pl', 1, 1, 1, 0, 1, '2025-08-06 18:26:27', '2025-09-09 19:56:22', NULL, 1, 0),
(23, 'Norek', 'Dariusz', 'Redlicki', '', 'dredlicki@m.pl', NULL, NULL, '$2y$10$GRGvi2AMceSi8hwFCmzhKeUMakgZ5bAIoFs8PCK2vKISGcD8UgOEK', NULL, 'user', 'pl', 1, 1, 1, 0, 1, '2025-08-26 00:18:05', '2025-08-26 00:18:05', 2, 1, 0),
(25, 'jkukla', 'Josef', 'Kukla', '', 'j.kukla@maspex.com', NULL, NULL, '$2y$10$a7SQeEhskhp.yk.TI2f8PuIuer/2EIiISyM6y5THRJkiYjIitjwAG', '111111', 'user', 'cs', 1, 1, 1, 0, 1, '2025-08-31 22:45:14', '2025-09-03 09:54:01', 3, 1, 0),
(29, 'jnehala', 'Jan', 'Nechala', '', 'j.nehala@maspex.com', NULL, NULL, '$2y$10$GgxmtKZF7vMAUDHUERts6eXXg6YeUNZnjJB1ljq1NNE835P4yuWnu', '188654', 'user', 'cs', 1, 1, 1, 0, 1, '2025-08-31 22:57:40', '2025-09-09 19:56:24', 1, 1, 0),
(33, 'test', 'test', 'test', '', 'a@w.pl', NULL, NULL, '$2y$10$BzGzyFDtVCry6SpfCioJHeOQKCs/S.Ua37AepqP/crFsJPOsZ8t0y', '123123', 'user', 'pl', 1, 1, 1, 0, 1, '2025-09-01 08:56:07', '2025-09-01 08:56:38', 3, 0, 0);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `users_permission`
--

CREATE TABLE `users_permission` (
  `id` int(11) NOT NULL,
  `key` varchar(190) NOT NULL,
  `name` varchar(190) NOT NULL,
  `module` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Zrzut danych tabeli `users_permission`
--

INSERT INTO `users_permission` (`id`, `key`, `name`, `module`, `created_at`) VALUES
(1, 'admin.*', 'Administrator — wszystko', 'admin', '2025-08-26 20:24:24'),
(2, 'users.edit', 'Użytkownicy — edycja/dodawanie', 'admin', '2025-08-26 20:24:24'),
(3, 'users.view', 'Użytkownicy — podgląd', 'admin', '2025-08-26 20:24:24'),
(4, 'cmms.*', 'CMMS — wszystko', 'cmms', '2025-08-26 20:24:24'),
(5, 'cmms.view', 'CMMS — dostęp do modułu', 'cmms', '2025-08-26 20:24:24'),
(6, 'cmms.tickets.view', 'CMMS — Zgłoszenia: podgląd', 'cmms', '2025-08-26 20:24:24'),
(7, 'cmms.tickets.create', 'CMMS — Zgłoszenia: tworzenie', 'cmms', '2025-08-26 20:24:24'),
(8, 'cmms.tickets.update', 'CMMS — Zgłoszenia: edycja', 'cmms', '2025-08-26 20:24:24'),
(9, 'cmms.tickets.delete', 'CMMS — Zgłoszenia: usuwanie', 'cmms', '2025-08-26 20:24:24'),
(10, 'cmms.dictionary.manage', 'CMMS — Słowniki: zarządzanie', 'cmms', '2025-08-26 20:24:24'),
(11, 'cmms.statuses.manage', 'CMMS — Statusy: zarządzanie', 'cmms', '2025-08-26 20:24:24'),
(12, 'mes.*', 'MES — wszystko', 'mes', '2025-08-26 20:24:24'),
(13, 'mes.view', 'MES — dostęp do modułu', 'mes', '2025-08-26 20:24:24'),
(14, 'kompetencje.*', 'Kompetencje — wszystko', 'kompetencje', '2025-08-26 20:24:24'),
(15, 'kompetencje.view', 'Kompetencje — dostęp do modułu', 'kompetencje', '2025-08-26 20:24:24'),
(16, 'kompetencje.matrix.edit', 'Kompetencje — edycja matrycy', 'kompetencje', '2025-08-26 20:24:24'),
(17, 'szkolenia.*', 'Szkolenia — wszystko', 'szkolenia', '2025-08-26 20:24:24'),
(18, 'szkolenia.view', 'Szkolenia — dostęp do modułu', 'szkolenia', '2025-08-26 20:24:24'),
(37, 'users.*', 'Użytkownicy — wszystko', 'admin', '2025-09-09 17:15:25'),
(38, 'users.delete', 'Użytkownicy — usuwanie', 'admin', '2025-09-09 17:15:25'),
(39, 'users.reset_password', 'Użytkownicy — reset hasła/PIN', 'admin', '2025-09-09 17:15:25'),
(40, 'roles.*', 'Role — wszystko', 'admin', '2025-09-09 17:15:25'),
(41, 'roles.manage', 'Role — zarządzanie', 'admin', '2025-09-09 17:15:25'),
(42, 'cmms.tickets.*', 'CMMS — Zgłoszenia: wszystko', 'cmms', '2025-09-09 17:15:25'),
(43, 'cmms.tickets.assign', 'CMMS — Zgłoszenia: przydzielanie do grup/osób', 'cmms', '2025-09-09 17:15:25'),
(44, 'cmms.tickets.comment', 'CMMS — Zgłoszenia: komentarze/notatki', 'cmms', '2025-09-09 17:15:25'),
(45, 'cmms.tickets.files', 'CMMS — Zgłoszenia: zarządzanie załącznikami', 'cmms', '2025-09-09 17:15:25'),
(46, 'cmms.tickets.export', 'CMMS — Zgłoszenia: eksport', 'cmms', '2025-09-09 17:15:25'),
(47, 'cmms.workflows.manage', 'CMMS — Workflows: konfiguracja przejść', 'cmms', '2025-09-09 17:15:25'),
(48, 'cmms.structure.*', 'CMMS — Struktura: wszystko', 'cmms', '2025-09-09 17:15:25'),
(49, 'cmms.structure.view', 'CMMS — Struktura: podgląd (drzewo/lista)', 'cmms', '2025-09-09 17:15:25'),
(50, 'cmms.structure.edit', 'CMMS — Struktura: edycja węzłów', 'cmms', '2025-09-09 17:15:25'),
(51, 'cmms.structure.delete', 'CMMS — Struktura: usuwanie węzłów', 'cmms', '2025-09-09 17:15:25'),
(52, 'cmms.structure.dragdrop', 'CMMS — Struktura: zmiana rodzica (drag&drop)', 'cmms', '2025-09-09 17:15:25'),
(53, 'cmms.structure.inline_edit', 'CMMS — Struktura: edycja inline (MPK/typ/element)', 'cmms', '2025-09-09 17:15:25'),
(54, 'cmms.dict.*', 'CMMS — Słowniki: wszystko', 'cmms', '2025-09-09 17:15:25'),
(55, 'cmms.dict.element.view', 'CMMS — Słownik elementów: podgląd', 'cmms', '2025-09-09 17:15:25'),
(56, 'cmms.dict.element.edit', 'CMMS — Słownik elementów: edycja', 'cmms', '2025-09-09 17:15:25'),
(57, 'cmms.dict.element.delete', 'CMMS — Słownik elementów: usuwanie', 'cmms', '2025-09-09 17:15:25'),
(58, 'cmms.dict.typ.view', 'CMMS — Słownik typów: podgląd', 'cmms', '2025-09-09 17:15:25'),
(59, 'cmms.dict.typ.edit', 'CMMS — Słownik typów: edycja', 'cmms', '2025-09-09 17:15:25'),
(60, 'cmms.dict.typ.delete', 'CMMS — Słownik typów: usuwanie', 'cmms', '2025-09-09 17:15:25'),
(61, 'cmms.dict.mpk.view', 'CMMS — Słownik MPK/Linia: podgląd', 'cmms', '2025-09-09 17:15:25'),
(62, 'cmms.dict.mpk.edit', 'CMMS — Słownik MPK/Linia: edycja', 'cmms', '2025-09-09 17:15:25'),
(63, 'cmms.dict.mpk.delete', 'CMMS — Słownik MPK/Linia: usuwanie', 'cmms', '2025-09-09 17:15:25'),
(64, 'mes.config.manage', 'MES — konfiguracja', 'mes', '2025-09-09 17:15:25'),
(65, 'kompetencje.training.manage', 'Kompetencje — szkolenia/przypisania', 'kompetencje', '2025-09-09 17:15:25'),
(66, 'szkolenia.edit', 'Szkolenia — edycja treści', 'szkolenia', '2025-09-09 17:15:25'),
(67, 'szkolenia.exam.manage', 'Szkolenia — egzaminy/quizy', 'szkolenia', '2025-09-09 17:15:25'),
(86, 'kompetencje.matrix.view', 'Kompetencje — Matryca: podgląd podwładnych', 'kompetencje', '2025-09-10 20:16:12'),
(87, 'kompetencje.matrix.view_all', 'Kompetencje — Matryca: podgląd wszystkich', 'kompetencje', '2025-09-10 20:16:12'),
(88, 'kompetencje.matrix.rate', 'Kompetencje — Matryca: ocena L1/L2', 'kompetencje', '2025-09-10 20:16:12'),
(89, 'kompetencje.matrix.export', 'Kompetencje — Matryca: eksport', 'kompetencje', '2025-09-10 20:16:12'),
(90, 'kompetencje.matrix.import', 'Kompetencje — Matryca: import', 'kompetencje', '2025-09-10 20:16:12'),
(91, 'kompetencje.recommendation.view', 'Kompetencje — Rekomendacje: podgląd', 'kompetencje', '2025-09-10 20:16:12'),
(92, 'kompetencje.recommendation.configure', 'Kompetencje — Rekomendacje: konfiguracja', 'kompetencje', '2025-09-10 20:16:12'),
(93, 'kompetencje.reports.view', 'Kompetencje — Raporty: podgląd', 'kompetencje', '2025-09-10 20:16:12'),
(94, 'kompetencje.reports.export', 'Kompetencje — Raporty: eksport', 'kompetencje', '2025-09-10 20:16:12'),
(95, 'kompetencje.dict.*', 'Kompetencje — Słowniki: wszystko', 'kompetencje', '2025-09-10 20:16:12'),
(96, 'kompetencje.dict.scale.view', 'Kompetencje — Skale: podgląd', 'kompetencje', '2025-09-10 20:16:12'),
(97, 'kompetencje.dict.scale.edit', 'Kompetencje — Skale: edycja', 'kompetencje', '2025-09-10 20:16:12'),
(98, 'kompetencje.dict.scale.delete', 'Kompetencje — Skale: usuwanie', 'kompetencje', '2025-09-10 20:16:12'),
(99, 'kompetencje.dict.soft.view', 'Kompetencje — Miękkie: podgląd', 'kompetencje', '2025-09-10 20:16:12'),
(100, 'kompetencje.dict.soft.edit', 'Kompetencje — Miękkie: edycja', 'kompetencje', '2025-09-10 20:16:12'),
(101, 'kompetencje.dict.soft.delete', 'Kompetencje — Miękkie: usuwanie', 'kompetencje', '2025-09-10 20:16:12'),
(102, 'kompetencje.dict.hard.view', 'Kompetencje — Twarde: podgląd', 'kompetencje', '2025-09-10 20:16:12'),
(103, 'kompetencje.dict.hard.edit', 'Kompetencje — Twarde: edycja', 'kompetencje', '2025-09-10 20:16:12'),
(104, 'kompetencje.dict.hard.delete', 'Kompetencje — Twarde: usuwanie', 'kompetencje', '2025-09-10 20:16:12'),
(105, 'kompetencje.dict.position.view', 'Kompetencje — Stanowiska: podgląd', 'kompetencje', '2025-09-10 20:16:12'),
(106, 'kompetencje.dict.position.edit', 'Kompetencje — Stanowiska: edycja', 'kompetencje', '2025-09-10 20:16:12'),
(107, 'kompetencje.dict.position.delete', 'Kompetencje — Stanowiska: usuwanie', 'kompetencje', '2025-09-10 20:16:12'),
(108, 'kompetencje.dict.position.level.view', 'Kompetencje — Poziomy stanowisk: podgląd', 'kompetencje', '2025-09-10 20:16:12'),
(109, 'kompetencje.dict.position.level.edit', 'Kompetencje — Poziomy stanowisk: edycja', 'kompetencje', '2025-09-10 20:16:12'),
(110, 'kompetencje.dict.position.level.delete', 'Kompetencje — Poziomy stanowisk: usuwanie', 'kompetencje', '2025-09-10 20:16:12'),
(111, 'kompetencje.dict.requirements.view', 'Kompetencje — Wymagania stanowisk: podgląd', 'kompetencje', '2025-09-10 20:16:12'),
(112, 'kompetencje.dict.requirements.edit', 'Kompetencje — Wymagania stanowisk: edycja', 'kompetencje', '2025-09-10 20:16:12'),
(113, 'kompetencje.dict.requirements.delete', 'Kompetencje — Wymagania stanowisk: usuwanie', 'kompetencje', '2025-09-10 20:16:12'),
(114, 'kompetencje.org.manage_relations', 'Kompetencje — Relacje L1/L2: zarządzanie', 'kompetencje', '2025-09-10 20:16:12'),
(115, 'kompetencje.salary.view', 'Kompetencje — Widełki płac: podgląd', 'kompetencje', '2025-09-10 20:16:12'),
(116, 'cmms.reports.view', 'CMMS - Podgląd raportów', 'cmms', '2025-09-10 20:19:22'),
(118, 'kompetencje.reco.view', 'Podgląd rekomendacji stanowiska w matrycy', 'kompetencje', '2025-09-11 17:49:09'),
(119, 'cmms.files.view', 'przeglądanie listy i pobieranie', 'cmms', '2025-09-15 08:38:28'),
(120, 'cmms.files.upload', 'dodawanie plików', 'cmms', '2025-09-15 08:38:28'),
(121, 'cmms.files.delete', 'usuwanie (soft delete)', 'cmms', '2025-09-15 08:38:55'),
(122, 'cmms.files.edit', 'zmiana typu dokumentu, opisu, is_main, sort_order', 'cmms', '2025-09-15 08:38:55');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `users_role`
--

CREATE TABLE `users_role` (
  `user_id` int(11) NOT NULL,
  `role_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Zrzut danych tabeli `users_role`
--

INSERT INTO `users_role` (`user_id`, `role_id`) VALUES
(1, 3),
(5, 4);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `users_role_permission`
--

CREATE TABLE `users_role_permission` (
  `role_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Zrzut danych tabeli `users_role_permission`
--

INSERT INTO `users_role_permission` (`role_id`, `permission_id`) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4),
(1, 5),
(1, 6),
(1, 7),
(1, 8),
(1, 9),
(1, 10),
(1, 11),
(3, 1),
(3, 2),
(3, 3),
(3, 4),
(3, 12),
(3, 14),
(3, 17),
(4, 4),
(4, 5),
(4, 6),
(4, 7),
(4, 8),
(4, 9),
(4, 10),
(4, 11),
(4, 42),
(4, 43),
(4, 44),
(4, 45),
(4, 46),
(4, 47),
(4, 48),
(4, 49),
(4, 50),
(4, 51),
(4, 52),
(4, 53),
(4, 54),
(4, 55),
(4, 56),
(4, 57),
(4, 58),
(4, 59),
(4, 60),
(4, 61),
(4, 62),
(4, 63),
(5, 5),
(5, 6),
(5, 7),
(6, 13),
(7, 14),
(7, 15),
(7, 16),
(8, 17),
(8, 18),
(10, 1),
(10, 2),
(11, 14),
(11, 15),
(11, 16),
(11, 65),
(11, 86),
(11, 87),
(11, 88),
(11, 89),
(11, 90),
(11, 91),
(11, 92),
(11, 93),
(11, 94),
(11, 95),
(11, 96),
(11, 97),
(11, 98),
(11, 99),
(11, 100),
(11, 101),
(11, 102),
(11, 103),
(11, 104),
(11, 105),
(11, 106),
(11, 107),
(11, 108),
(11, 109),
(11, 110),
(11, 111),
(11, 112),
(11, 113),
(11, 114),
(11, 115),
(12, 15),
(12, 65),
(12, 87),
(12, 93),
(12, 94),
(12, 95),
(12, 115),
(13, 15),
(13, 86),
(13, 88),
(13, 91),
(13, 93),
(14, 15),
(14, 86),
(14, 88),
(14, 91),
(14, 93),
(15, 15),
(15, 86),
(15, 91);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `users_user_permission`
--

CREATE TABLE `users_user_permission` (
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  `allow` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Zrzut danych tabeli `users_user_permission`
--

INSERT INTO `users_user_permission` (`user_id`, `permission_id`, `allow`) VALUES
(1, 1, 1),
(1, 2, 1),
(1, 3, 1),
(1, 4, 1),
(1, 5, 1),
(1, 6, 1),
(1, 7, 1),
(1, 8, 1),
(1, 9, 1),
(1, 10, 1),
(1, 11, 1),
(1, 12, 1),
(1, 13, 1),
(1, 14, 1),
(1, 15, 1),
(1, 16, 1),
(1, 17, 1),
(1, 18, 1),
(5, 1, 0),
(5, 2, 0),
(5, 3, 0),
(5, 37, 0),
(5, 38, 0),
(5, 39, 0),
(5, 40, 0),
(5, 41, 0),
(25, 1, 1),
(25, 2, 1),
(25, 3, 1);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `user_permissions`
--

CREATE TABLE `user_permissions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `module_code` varchar(50) NOT NULL,
  `perm_key` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `user_permissions`
--

INSERT INTO `user_permissions` (`id`, `user_id`, `module_code`, `perm_key`) VALUES
(3, 1, 'cmms', '');

-- --------------------------------------------------------

--
-- Zastąpiona struktura widoku `vw_kompetencje_final_norm`
-- (Zobacz poniżej rzeczywisty widok)
--
CREATE TABLE `vw_kompetencje_final_norm` (
`typ` varchar(4)
,`user_id` int(11)
,`kompetencja_id` int(11)
,`kompetencja_nazwa` varchar(255)
,`skala_id` int(11)
,`wartosc_num` decimal(10,4)
,`norm_01` decimal(19,8)
,`waga` decimal(10,4)
);

-- --------------------------------------------------------

--
-- Zastąpiona struktura widoku `vw_miekkie_latest`
-- (Zobacz poniżej rzeczywisty widok)
--
CREATE TABLE `vw_miekkie_latest` (
`id` int(11)
,`user_id` int(11)
,`kompetencja_id` int(11)
,`kompetencja_nazwa` varchar(255)
,`skala_id` int(11)
,`symbol_skali` varchar(255)
,`skala_wartosc_id` int(20)
,`wartosc_num` decimal(10,4)
,`min_wartosc` decimal(10,4)
,`max_wartosc` decimal(10,4)
,`norm_01` decimal(19,8)
,`data_oceny` date
,`updated_at` datetime
,`created_at` datetime
);

-- --------------------------------------------------------

--
-- Zastąpiona struktura widoku `vw_relacje_nadzoru_open`
-- (Zobacz poniżej rzeczywisty widok)
--
CREATE TABLE `vw_relacje_nadzoru_open` (
`supervisor_user_id` int(11)
,`subordinate_user_id` int(11)
,`poziom` enum('I','II')
);

-- --------------------------------------------------------

--
-- Zastąpiona struktura widoku `vw_skala_minmax`
-- (Zobacz poniżej rzeczywisty widok)
--
CREATE TABLE `vw_skala_minmax` (
`id_skala` int(20)
,`min_wartosc` decimal(10,4)
,`max_wartosc` decimal(10,4)
);

-- --------------------------------------------------------

--
-- Zastąpiona struktura widoku `vw_twarde_latest`
-- (Zobacz poniżej rzeczywisty widok)
--
CREATE TABLE `vw_twarde_latest` (
`id` int(11)
,`user_id` int(11)
,`kompetencja_id` int(11)
,`kompetencja_nazwa` varchar(255)
,`skala_id` int(11)
,`wartosc_num` decimal(10,4)
,`waga_domyslna` int(11)
,`min_wartosc` decimal(10,4)
,`max_wartosc` decimal(10,4)
,`norm_01` decimal(19,8)
,`data_oceny` date
,`updated_at` datetime
,`created_at` datetime
);

-- --------------------------------------------------------

--
-- Zastąpiona struktura widoku `vw_twarde_score_latest`
-- (Zobacz poniżej rzeczywisty widok)
--
CREATE TABLE `vw_twarde_score_latest` (
`user_id` int(11)
,`score` decimal(42,4)
,`waga_sum` decimal(32,0)
,`score_norm` decimal(46,8)
);

-- --------------------------------------------------------

--
-- Zastąpiona struktura widoku `v_cmms_ticket_last_status`
-- (Zobacz poniżej rzeczywisty widok)
--
CREATE TABLE `v_cmms_ticket_last_status` (
`id` bigint(20) unsigned
,`ticket_id` int(10) unsigned
,`from_status_id` int(10) unsigned
,`to_status_id` int(10) unsigned
,`user_id` int(11)
,`comment` text
,`reason_code` varchar(64)
,`changed_at` datetime
,`time_in_prev` int(10) unsigned
,`created_at` datetime
,`time_in_prev_s` int(11)
);

-- --------------------------------------------------------

--
-- Zastąpiona struktura widoku `v_score_twarde`
-- (Zobacz poniżej rzeczywisty widok)
--
CREATE TABLE `v_score_twarde` (
`user_id` int(11)
,`id_stanowiska` int(11)
,`score_twarde` decimal(42,0)
);

-- --------------------------------------------------------

--
-- Struktura widoku `vw_kompetencje_final_norm`
--
DROP TABLE IF EXISTS `vw_kompetencje_final_norm`;

CREATE ALGORITHM=UNDEFINED DEFINER=`mpietraszewski`@`127.0.0.1` SQL SECURITY DEFINER VIEW `vw_kompetencje_final_norm`  AS SELECT 'soft' AS `typ`, `s`.`user_id` AS `user_id`, `s`.`kompetencja_id` AS `kompetencja_id`, `s`.`kompetencja_nazwa` AS `kompetencja_nazwa`, `s`.`skala_id` AS `skala_id`, `s`.`wartosc_num` AS `wartosc_num`, `s`.`norm_01` AS `norm_01`, cast(1 as decimal(10,4)) AS `waga` FROM `vw_miekkie_latest` AS `s` union all select 'hard' AS `typ`,`h`.`user_id` AS `user_id`,`h`.`kompetencja_id` AS `kompetencja_id`,`h`.`kompetencja_nazwa` AS `kompetencja_nazwa`,`h`.`skala_id` AS `skala_id`,`h`.`wartosc_num` AS `wartosc_num`,`h`.`norm_01` AS `norm_01`,cast(`h`.`waga_domyslna` as decimal(10,4)) AS `waga` from `vw_twarde_latest` `h` ;

-- --------------------------------------------------------

--
-- Struktura widoku `vw_miekkie_latest`
--
DROP TABLE IF EXISTS `vw_miekkie_latest`;

CREATE ALGORITHM=MERGE DEFINER=`mpietraszewski`@`127.0.0.1` SQL SECURITY INVOKER VIEW `vw_miekkie_latest`  AS SELECT `m`.`id` AS `id`, `m`.`user_id` AS `user_id`, `m`.`kompetencja_id` AS `kompetencja_id`, `mk`.`nazwa` AS `kompetencja_nazwa`, `mk`.`id_skala` AS `skala_id`, coalesce(nullif(`m`.`ocena`,''),`sw`.`symbol`) AS `symbol_skali`, `sw`.`id` AS `skala_wartosc_id`, cast(`sw`.`wartosc_num` as decimal(10,4)) AS `wartosc_num`, `mm`.`min_wartosc` AS `min_wartosc`, `mm`.`max_wartosc` AS `max_wartosc`, CASE WHEN `mm`.`min_wartosc` is null OR `mm`.`max_wartosc` is null OR `mm`.`max_wartosc` = `mm`.`min_wartosc` THEN NULL ELSE (cast(`sw`.`wartosc_num` as decimal(10,4)) - `mm`.`min_wartosc`) / nullif(`mm`.`max_wartosc` - `mm`.`min_wartosc`,0) END AS `norm_01`, coalesce(`m`.`data_oceny`,cast(`m`.`created_at` as date)) AS `data_oceny`, `m`.`updated_at` AS `updated_at`, `m`.`created_at` AS `created_at` FROM ((((`kompetencje_miekkie_oceny` `m` join `kompetencje_miekkie_kryteria` `mk` on(`mk`.`id` = `m`.`kompetencja_id`)) left join `kompetencje_skala_wartosci` `sw` on(`sw`.`id_skala` = `mk`.`id_skala` and `sw`.`symbol` = `m`.`ocena`)) join (select `t`.`user_id` AS `user_id`,`t`.`kompetencja_id` AS `kompetencja_id`,max(concat(coalesce(`t`.`data_oceny`,cast(`t`.`created_at` as date)),' ',lpad(`t`.`id`,10,'0'))) AS `sel` from `kompetencje_miekkie_oceny` `t` group by `t`.`user_id`,`t`.`kompetencja_id`) `last` on(`last`.`user_id` = `m`.`user_id` and `last`.`kompetencja_id` = `m`.`kompetencja_id` and `last`.`sel` = concat(coalesce(`m`.`data_oceny`,cast(`m`.`created_at` as date)),' ',lpad(`m`.`id`,10,'0')))) left join `vw_skala_minmax` `mm` on(`mm`.`id_skala` = `mk`.`id_skala`))) ;

-- --------------------------------------------------------

--
-- Struktura widoku `vw_relacje_nadzoru_open`
--
DROP TABLE IF EXISTS `vw_relacje_nadzoru_open`;

CREATE ALGORITHM=MERGE DEFINER=`mpietraszewski`@`127.0.0.1` SQL SECURITY INVOKER VIEW `vw_relacje_nadzoru_open`  AS SELECT `kompetencje_relacje_nadzoru`.`supervisor_user_id` AS `supervisor_user_id`, `kompetencje_relacje_nadzoru`.`subordinate_user_id` AS `subordinate_user_id`, `kompetencje_relacje_nadzoru`.`poziom` AS `poziom` FROM `kompetencje_relacje_nadzoru` WHERE `kompetencje_relacje_nadzoru`.`aktywny` = 1 AND `kompetencje_relacje_nadzoru`.`until_date` is nullnull ;

-- --------------------------------------------------------

--
-- Struktura widoku `vw_skala_minmax`
--
DROP TABLE IF EXISTS `vw_skala_minmax`;

CREATE ALGORITHM=UNDEFINED DEFINER=`mpietraszewski`@`127.0.0.1` SQL SECURITY INVOKER VIEW `vw_skala_minmax`  AS SELECT `kompetencje_skala_wartosci`.`id_skala` AS `id_skala`, cast(min(`kompetencje_skala_wartosci`.`wartosc_num`) as decimal(10,4)) AS `min_wartosc`, cast(max(`kompetencje_skala_wartosci`.`wartosc_num`) as decimal(10,4)) AS `max_wartosc` FROM `kompetencje_skala_wartosci` GROUP BY `kompetencje_skala_wartosci`.`id_skala``id_skala` ;

-- --------------------------------------------------------

--
-- Struktura widoku `vw_twarde_latest`
--
DROP TABLE IF EXISTS `vw_twarde_latest`;

CREATE ALGORITHM=MERGE DEFINER=`mpietraszewski`@`127.0.0.1` SQL SECURITY INVOKER VIEW `vw_twarde_latest`  AS SELECT `h`.`id` AS `id`, `h`.`id_uzytkownika` AS `user_id`, `z`.`id` AS `kompetencja_id`, `z`.`nazwa` AS `kompetencja_nazwa`, `z`.`id_skala` AS `skala_id`, cast(`h`.`wartosc` as decimal(10,4)) AS `wartosc_num`, `z`.`waga` AS `waga_domyslna`, `mm`.`min_wartosc` AS `min_wartosc`, `mm`.`max_wartosc` AS `max_wartosc`, CASE WHEN `mm`.`min_wartosc` is null OR `mm`.`max_wartosc` is null OR `mm`.`max_wartosc` = `mm`.`min_wartosc` THEN NULL ELSE (cast(`h`.`wartosc` as decimal(10,4)) - `mm`.`min_wartosc`) / nullif(`mm`.`max_wartosc` - `mm`.`min_wartosc`,0) END AS `norm_01`, coalesce(`h`.`data_oceny`,cast(`h`.`created_at` as date)) AS `data_oceny`, `h`.`updated_at` AS `updated_at`, `h`.`created_at` AS `created_at` FROM (((`kompetencje_twarde_oceny` `h` join `kompetencje_twarde_zasoby` `z` on(`z`.`id` = `h`.`id_zasobu`)) left join `vw_skala_minmax` `mm` on(`mm`.`id_skala` = `z`.`id_skala`)) join (select `t`.`id_uzytkownika` AS `user_id`,`t`.`id_zasobu` AS `kompetencja_id`,max(concat(coalesce(`t`.`data_oceny`,cast(`t`.`created_at` as date)),' ',lpad(`t`.`id`,10,'0'))) AS `sel` from `kompetencje_twarde_oceny` `t` group by `t`.`id_uzytkownika`,`t`.`id_zasobu`) `last` on(`last`.`user_id` = `h`.`id_uzytkownika` and `last`.`kompetencja_id` = `h`.`id_zasobu` and `last`.`sel` = concat(coalesce(`h`.`data_oceny`,cast(`h`.`created_at` as date)),' ',lpad(`h`.`id`,10,'0'))))) ;

-- --------------------------------------------------------

--
-- Struktura widoku `vw_twarde_score_latest`
--
DROP TABLE IF EXISTS `vw_twarde_score_latest`;

CREATE ALGORITHM=UNDEFINED DEFINER=`mpietraszewski`@`127.0.0.1` SQL SECURITY INVOKER VIEW `vw_twarde_score_latest`  AS SELECT `tl`.`user_id` AS `user_id`, sum(`tl`.`wartosc_num` * coalesce(`tl`.`waga_domyslna`,1)) AS `score`, sum(coalesce(`tl`.`waga_domyslna`,1)) AS `waga_sum`, CASE WHEN sum(coalesce(`tl`.`waga_domyslna`,1)) = 0 THEN NULL ELSE sum(`tl`.`wartosc_num` * coalesce(`tl`.`waga_domyslna`,1)) / sum(coalesce(`tl`.`waga_domyslna`,1)) END AS `score_norm` FROM `vw_twarde_latest` AS `tl` GROUP BY `tl`.`user_id``user_id` ;

-- --------------------------------------------------------

--
-- Struktura widoku `v_cmms_ticket_last_status`
--
DROP TABLE IF EXISTS `v_cmms_ticket_last_status`;

CREATE ALGORITHM=UNDEFINED DEFINER=`mpietraszewski`@`127.0.0.1` SQL SECURITY DEFINER VIEW `v_cmms_ticket_last_status`  AS SELECT `l1`.`id` AS `id`, `l1`.`ticket_id` AS `ticket_id`, `l1`.`from_status_id` AS `from_status_id`, `l1`.`to_status_id` AS `to_status_id`, `l1`.`user_id` AS `user_id`, `l1`.`comment` AS `comment`, `l1`.`reason_code` AS `reason_code`, `l1`.`changed_at` AS `changed_at`, `l1`.`time_in_prev` AS `time_in_prev`, `l1`.`created_at` AS `created_at`, `l1`.`time_in_prev_s` AS `time_in_prev_s` FROM (`cmms_ticket_status_log` `l1` join (select `cmms_ticket_status_log`.`ticket_id` AS `ticket_id`,max(`cmms_ticket_status_log`.`changed_at`) AS `max_changed` from `cmms_ticket_status_log` group by `cmms_ticket_status_log`.`ticket_id`) `x` on(`x`.`ticket_id` = `l1`.`ticket_id` and `x`.`max_changed` = `l1`.`changed_at`))) ;

-- --------------------------------------------------------

--
-- Struktura widoku `v_score_twarde`
--
DROP TABLE IF EXISTS `v_score_twarde`;

CREATE ALGORITHM=UNDEFINED DEFINER=`mpietraszewski`@`127.0.0.1` SQL SECURITY DEFINER VIEW `v_score_twarde`  AS SELECT `o`.`id_uzytkownika` AS `user_id`, `w`.`id_stanowiska` AS `id_stanowiska`, sum(coalesce(`w`.`waga_override`,`tz`.`waga`) * `o`.`wartosc`) AS `score_twarde` FROM ((`kompetencje_twarde_oceny` `o` join `kompetencje_stanowisko_wymagania` `w` on(`w`.`typ` = 'hard' and `w`.`id_kompetencji` = `o`.`id_zasobu` and `w`.`aktywny` = 1)) join `kompetencje_twarde_zasoby` `tz` on(`tz`.`id` = `o`.`id_zasobu`)) GROUP BY `o`.`id_uzytkownika`, `w`.`id_stanowiska``id_stanowiska` ;

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `audit_log`
--
ALTER TABLE `audit_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_tbl_rec` (`table_name`,`record_id`,`created_at`),
  ADD KEY `idx_user_ts` (`user_id`,`created_at`);

--
-- Indeksy dla tabeli `audit_user_permissions`
--
ALTER TABLE `audit_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_target_time` (`target_user_id`,`created_at`),
  ADD KEY `idx_actor_time` (`actor_user_id`,`created_at`);

--
-- Indeksy dla tabeli `cmms_assignment_rule`
--
ALTER TABLE `cmms_assignment_rule`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_car_match` (`active`,`type_id`,`subtype_id`,`mpk_id`,`structure_id`,`priority`),
  ADD KEY `idx_car_valid` (`valid_from`,`valid_to`),
  ADD KEY `idx_car_mpk` (`mpk_id`),
  ADD KEY `idx_car_structure` (`structure_id`);

--
-- Indeksy dla tabeli `cmms_escalation_rule`
--
ALTER TABLE `cmms_escalation_rule`
  ADD PRIMARY KEY (`id`);

--
-- Indeksy dla tabeli `cmms_group`
--
ALTER TABLE `cmms_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `key_name` (`key_name`);

--
-- Indeksy dla tabeli `cmms_group_rotation`
--
ALTER TABLE `cmms_group_rotation`
  ADD PRIMARY KEY (`group_id`);

--
-- Indeksy dla tabeli `cmms_group_user`
--
ALTER TABLE `cmms_group_user`
  ADD PRIMARY KEY (`group_id`,`user_id`),
  ADD UNIQUE KEY `uq_group_user` (`group_id`,`user_id`),
  ADD KEY `idx_group_user_user` (`user_id`);

--
-- Indeksy dla tabeli `cmms_permissions`
--
ALTER TABLE `cmms_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- Indeksy dla tabeli `cmms_plik`
--
ALTER TABLE `cmms_plik`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_entity` (`entity_type`,`entity_id`,`sort_order`),
  ADD KEY `idx_typ` (`typ_id`),
  ADD KEY `idx_created` (`created_at`),
  ADD KEY `idx_sha1` (`checksum_sha1`);

--
-- Indeksy dla tabeli `cmms_responsibilities`
--
ALTER TABLE `cmms_responsibilities`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_responsibilities_slug` (`slug`);

--
-- Indeksy dla tabeli `cmms_responsibility_contacts`
--
ALTER TABLE `cmms_responsibility_contacts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_resp_contact` (`responsibility_id`,`contact_type`,`value`);

--
-- Indeksy dla tabeli `cmms_roles`
--
ALTER TABLE `cmms_roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indeksy dla tabeli `cmms_role_permission`
--
ALTER TABLE `cmms_role_permission`
  ADD PRIMARY KEY (`role_id`,`permission_id`),
  ADD KEY `permission_id` (`permission_id`);

--
-- Indeksy dla tabeli `cmms_slownik_element`
--
ALTER TABLE `cmms_slownik_element`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `key` (`key`),
  ADD KEY `idx_cmms_sl_el_active_sort` (`aktywny`,`sort_order`,`nazwa`);

--
-- Indeksy dla tabeli `cmms_slownik_element_tr`
--
ALTER TABLE `cmms_slownik_element_tr`
  ADD PRIMARY KEY (`element_id`,`lang`);

--
-- Indeksy dla tabeli `cmms_slownik_mpk_linia`
--
ALTER TABLE `cmms_slownik_mpk_linia`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_mpk_linia_mpk` (`mpk`),
  ADD UNIQUE KEY `uq_mpk_linia_key` (`key`),
  ADD KEY `idx_mpk_linia_list` (`aktywny`,`sort_order`,`nazwa`),
  ADD KEY `idx_mpk_nazwa` (`aktywny`,`sort_order`,`nazwa`);

--
-- Indeksy dla tabeli `cmms_slownik_plik_typ`
--
ALTER TABLE `cmms_slownik_plik_typ`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `key_name` (`key_name`);

--
-- Indeksy dla tabeli `cmms_slownik_typ_zasobu`
--
ALTER TABLE `cmms_slownik_typ_zasobu`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cmms_typ_key` (`key`),
  ADD KEY `idx_cmms_typ_list` (`aktywny`,`sort_order`,`nazwa`);

--
-- Indeksy dla tabeli `cmms_statuses`
--
ALTER TABLE `cmms_statuses`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cmms_statuses_slug` (`slug`),
  ADD KEY `ix_cmms_statuses_category` (`category_id`);

--
-- Indeksy dla tabeli `cmms_status_categories`
--
ALTER TABLE `cmms_status_categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cmms_status_categories_key` (`key`);

--
-- Indeksy dla tabeli `cmms_status_transitions`
--
ALTER TABLE `cmms_status_transitions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_from_to` (`from_status_id`,`to_status_id`,`code`),
  ADD KEY `idx_from` (`from_status_id`),
  ADD KEY `idx_to` (`to_status_id`),
  ADD KEY `idx_cst_wf_from` (`workflow_id`,`from_status_id`);

--
-- Indeksy dla tabeli `cmms_struktura`
--
ALTER TABLE `cmms_struktura`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cmms_struktura_key` (`key`),
  ADD KEY `idx_cmms_struktura_parent_sort` (`parent_id`,`sort_order`),
  ADD KEY `idx_cmms_struktura_path` (`path`(255)),
  ADD KEY `idx_cmms_struktura_id_element` (`id_element`),
  ADD KEY `idx_cmms_struktura_element` (`element_id`),
  ADD KEY `idx_cmms_struktura_typ` (`typ_zasobu_id`),
  ADD KEY `idx_cmms_struktura_mpk` (`mpk_linia_id`),
  ADD KEY `idx_cmms_struktura_parent_order` (`parent_id`,`sort_order`,`id`),
  ADD KEY `idx_parent_order` (`parent_id`,`sort_order`),
  ADD KEY `idx_path` (`path`(255)),
  ADD KEY `idx_cmms_struktura_parent` (`parent_id`);

--
-- Indeksy dla tabeli `cmms_subtype_responsibility`
--
ALTER TABLE `cmms_subtype_responsibility`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_sr` (`subtype_id`,`responsibility_id`),
  ADD KEY `idx_sr_subtype` (`subtype_id`),
  ADD KEY `idx_sr_resp` (`responsibility_id`);

--
-- Indeksy dla tabeli `cmms_tickets`
--
ALTER TABLE `cmms_tickets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_t_assignee` (`assignee_id`),
  ADD KEY `idx_t_created` (`created_at`),
  ADD KEY `idx_t_type` (`type_id`),
  ADD KEY `idx_t_subtype` (`subtype_id`),
  ADD KEY `idx_t_resp` (`responsibility_id`),
  ADD KEY `idx_t_mpk` (`mpk_id`),
  ADD KEY `idx_t_asset_type` (`asset_type_id`),
  ADD KEY `idx_t_asset` (`asset_id`),
  ADD KEY `ix_tickets_status_id` (`status_id`),
  ADD KEY `idx_tickets_basic` (`type_id`,`subtype_id`),
  ADD KEY `idx_tickets_status` (`status_id`,`updated_at`),
  ADD KEY `idx_tickets_struktura` (`struktura_id`),
  ADD KEY `idx_tickets_mpk` (`mpk_id`),
  ADD KEY `idx_tickets_assignees` (`assignee_id`,`responsibility_id`),
  ADD KEY `idx_tickets_due` (`due_at`),
  ADD KEY `fk_tickets_reporter` (`reporter_id`),
  ADD KEY `idx_tickets_workflow` (`workflow_id`),
  ADD KEY `idx_cmms_tickets_group` (`group_id`),
  ADD KEY `idx_tickets_group` (`group_id`),
  ADD KEY `idx_cmms_tickets_struktura` (`struktura_id`);
ALTER TABLE `cmms_tickets` ADD FULLTEXT KEY `ft_t_title_desc` (`title`,`description`);

--
-- Indeksy dla tabeli `cmms_ticket_comments`
--
ALTER TABLE `cmms_ticket_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_tc_ticket` (`ticket_id`),
  ADD KEY `idx_comments_ticket` (`ticket_id`,`created_at`);

--
-- Indeksy dla tabeli `cmms_ticket_downtime`
--
ALTER TABLE `cmms_ticket_downtime`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_td_ticket_start` (`ticket_id`,`start_at`);

--
-- Indeksy dla tabeli `cmms_ticket_files`
--
ALTER TABLE `cmms_ticket_files`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_ticket` (`ticket_id`,`created_at`),
  ADD KEY `idx_checksum` (`checksum_sha1`);

--
-- Indeksy dla tabeli `cmms_ticket_notifications`
--
ALTER TABLE `cmms_ticket_notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_ctn_status` (`status`),
  ADD KEY `idx_ctn_ticket` (`ticket_id`),
  ADD KEY `idx_notif_ticket` (`ticket_id`,`status`,`scheduled_at`);

--
-- Indeksy dla tabeli `cmms_ticket_status_history`
--
ALTER TABLE `cmms_ticket_status_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_tsh_ticket` (`ticket_id`),
  ADD KEY `idx_hist_ticket` (`ticket_id`,`changed_at`);

--
-- Indeksy dla tabeli `cmms_ticket_status_log`
--
ALTER TABLE `cmms_ticket_status_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ix_ctsl_ticket` (`ticket_id`,`created_at`),
  ADD KEY `ix_ctsl_from` (`from_status_id`),
  ADD KEY `ix_ctsl_to` (`to_status_id`),
  ADD KEY `ix_ctsl_changed_at` (`ticket_id`,`changed_at`),
  ADD KEY `ix_ctsl_ticket_changed` (`ticket_id`,`changed_at`),
  ADD KEY `idx_log_ticket` (`ticket_id`,`changed_at`),
  ADD KEY `idx_log_to_status` (`to_status_id`),
  ADD KEY `fk_log_user` (`user_id`),
  ADD KEY `idx_log_ticket_changed` (`ticket_id`,`changed_at`),
  ADD KEY `idx_tslog_ticket` (`ticket_id`),
  ADD KEY `idx_tslog_transition` (`transition_id`),
  ADD KEY `idx_tslog_workflow` (`workflow_id`);

--
-- Indeksy dla tabeli `cmms_ticket_subtypes`
--
ALTER TABLE `cmms_ticket_subtypes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_subtype_type_slug` (`type_id`,`slug`),
  ADD UNIQUE KEY `uq_cmms_ticket_subtypes_slug` (`slug`),
  ADD KEY `idx_subtype_type` (`type_id`),
  ADD KEY `idx_cmms_ticket_subtypes_type` (`type_id`),
  ADD KEY `idx_cmms_ticket_subtypes_active` (`active`,`order_no`);

--
-- Indeksy dla tabeli `cmms_ticket_time_spans`
--
ALTER TABLE `cmms_ticket_time_spans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_ticket` (`ticket_id`),
  ADD KEY `idx_open` (`ticket_id`,`ended_at`);

--
-- Indeksy dla tabeli `cmms_ticket_types`
--
ALTER TABLE `cmms_ticket_types`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cmms_ticket_types_slug` (`key_name`),
  ADD UNIQUE KEY `uq_cmms_ticket_types_key_name` (`key_name`),
  ADD KEY `idx_cmms_ticket_types_active` (`active`,`order_no`);

--
-- Indeksy dla tabeli `cmms_ticket_worklog`
--
ALTER TABLE `cmms_ticket_worklog`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ux_tw_user_one_open` (`user_id`,`is_open`),
  ADD UNIQUE KEY `ux_tw_ticket_user_one_open` (`ticket_id`,`user_id`,`is_open`),
  ADD KEY `idx_tw_ticket_start` (`ticket_id`,`start_at`),
  ADD KEY `idx_tw_user_open` (`user_id`,`end_at`);

--
-- Indeksy dla tabeli `cmms_user_role`
--
ALTER TABLE `cmms_user_role`
  ADD PRIMARY KEY (`user_id`,`role_id`),
  ADD UNIQUE KEY `uq_cmms_user_role` (`user_id`,`role_id`),
  ADD UNIQUE KEY `idx_cmms_user_role_uniq` (`user_id`,`role_id`),
  ADD KEY `role_id` (`role_id`);

--
-- Indeksy dla tabeli `cmms_workflows`
--
ALTER TABLE `cmms_workflows`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cmms_workflows_name` (`name`);

--
-- Indeksy dla tabeli `cmms_workflow_assignments`
--
ALTER TABLE `cmms_workflow_assignments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cwfa_scope` (`type_id_norm`,`subtype_id_norm`),
  ADD KEY `ix_cwfa_wf` (`workflow_id`),
  ADD KEY `ix_cwfa_scope` (`type_id`,`subtype_id`,`active`);

--
-- Indeksy dla tabeli `cmms_workflow_statuses`
--
ALTER TABLE `cmms_workflow_statuses`
  ADD PRIMARY KEY (`workflow_id`,`status_id`),
  ADD KEY `ix_cws_status` (`status_id`);

--
-- Indeksy dla tabeli `cmms_workflow_transitions`
--
ALTER TABLE `cmms_workflow_transitions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cwtr` (`workflow_id`,`from_status_id`,`to_status_id`),
  ADD KEY `ix_cwtr_wf` (`workflow_id`),
  ADD KEY `ix_cwtr_from` (`from_status_id`),
  ADD KEY `ix_cwtr_to` (`to_status_id`);

--
-- Indeksy dla tabeli `cmms_workflow_transition_roles`
--
ALTER TABLE `cmms_workflow_transition_roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ux_transition_role` (`transition_id`,`role_key`),
  ADD KEY `ix_role_key` (`role_key`);

--
-- Indeksy dla tabeli `kompetencje_brygada`
--
ALTER TABLE `kompetencje_brygada`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_brygada_dzial` (`id_dzial`),
  ADD KEY `fk_brygada_obszar` (`id_obszar`),
  ADD KEY `fk_brygada_created_by` (`created_by`),
  ADD KEY `fk_brygada_edited_by` (`edited_by`);

--
-- Indeksy dla tabeli `kompetencje_dzial`
--
ALTER TABLE `kompetencje_dzial`
  ADD PRIMARY KEY (`id`),
  ADD KEY `utworzyl_user_id` (`created_by`),
  ADD KEY `edytowal_user_id` (`edited_by`);

--
-- Indeksy dla tabeli `kompetencje_miekkie_kryteria`
--
ALTER TABLE `kompetencje_miekkie_kryteria`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_kmk_skala` (`id_skala`);

--
-- Indeksy dla tabeli `kompetencje_miekkie_oceny`
--
ALTER TABLE `kompetencje_miekkie_oceny`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_miekkie_unique_day` (`user_id`,`kompetencja_id`,`data_oceny`,`rater_level`),
  ADD KEY `fk_kto_ocenil_miekkie` (`rater_id`),
  ADD KEY `idx_oceny_soft_trend` (`user_id`,`kompetencja_id`,`data_oceny`,`rater_level`),
  ADD KEY `idx_kmo_is_exam` (`is_exam`),
  ADD KEY `idx_kmo_user` (`user_id`),
  ADD KEY `idx_kmo_comp` (`kompetencja_id`);

--
-- Indeksy dla tabeli `kompetencje_obszar`
--
ALTER TABLE `kompetencje_obszar`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_dzial` (`id_dzial`),
  ADD KEY `utworzyl_user_id` (`created_by`),
  ADD KEY `edytowal_user_id` (`edited_by`);

--
-- Indeksy dla tabeli `kompetencje_oceny`
--
ALTER TABLE `kompetencje_oceny`
  ADD PRIMARY KEY (`id`);

--
-- Indeksy dla tabeli `kompetencje_pracownicy`
--
ALTER TABLE `kompetencje_pracownicy`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `id_dzial` (`id_dzial`),
  ADD KEY `id_obszar` (`id_obszar`),
  ADD KEY `id_stanowisko` (`id_stanowisko`),
  ADD KEY `id_brygada` (`id_brygada`);

--
-- Indeksy dla tabeli `kompetencje_relacje_nadzoru`
--
ALTER TABLE `kompetencje_relacje_nadzoru`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_super_sub_lvl` (`supervisor_user_id`,`subordinate_user_id`,`poziom`,`until_date_eff`),
  ADD KEY `idx_sup` (`supervisor_user_id`),
  ADD KEY `idx_sub` (`subordinate_user_id`);

--
-- Indeksy dla tabeli `kompetencje_skala_wartosci`
--
ALTER TABLE `kompetencje_skala_wartosci`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_ksw_skala` (`id_skala`);

--
-- Indeksy dla tabeli `kompetencje_skale`
--
ALTER TABLE `kompetencje_skale`
  ADD PRIMARY KEY (`id`);

--
-- Indeksy dla tabeli `kompetencje_slownik`
--
ALTER TABLE `kompetencje_slownik`
  ADD PRIMARY KEY (`id`);

--
-- Indeksy dla tabeli `kompetencje_slownik_typ_zasobu`
--
ALTER TABLE `kompetencje_slownik_typ_zasobu`
  ADD PRIMARY KEY (`id`);

--
-- Indeksy dla tabeli `kompetencje_slownik_typ_zasobu_hr`
--
ALTER TABLE `kompetencje_slownik_typ_zasobu_hr`
  ADD PRIMARY KEY (`id`);

--
-- Indeksy dla tabeli `kompetencje_stanowiska`
--
ALTER TABLE `kompetencje_stanowiska`
  ADD PRIMARY KEY (`id`),
  ADD KEY `utworzyl_user_id` (`created_by`),
  ADD KEY `edytowal_user_id` (`edited_by`);

--
-- Indeksy dla tabeli `kompetencje_stanowiska_poziomy`
--
ALTER TABLE `kompetencje_stanowiska_poziomy`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_stanowiska` (`id_stanowiska`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `edited_by` (`edited_by`);

--
-- Indeksy dla tabeli `kompetencje_stanowisko_wymagania`
--
ALTER TABLE `kompetencje_stanowisko_wymagania`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_wymaganie` (`id_stanowiska`,`typ`,`id_kompetencji`);

--
-- Indeksy dla tabeli `kompetencje_struktura`
--
ALTER TABLE `kompetencje_struktura`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_kompetencje_struktura_rodzic` (`id_rodzica`),
  ADD KEY `fk_kompetencje_struktura_typ` (`typ_zasobu_id`);

--
-- Indeksy dla tabeli `kompetencje_struktura_hr`
--
ALTER TABLE `kompetencje_struktura_hr`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_rodzica` (`id_rodzica`),
  ADD KEY `powiazany_zasob_cmms_id` (`id_powiazany_zasob`),
  ADD KEY `idx_ksh_is_kompetencja` (`is_kompetencja`),
  ADD KEY `idx_ksh_id_skala` (`id_skala`);

--
-- Indeksy dla tabeli `kompetencje_struktura_hr_stanowisko`
--
ALTER TABLE `kompetencje_struktura_hr_stanowisko`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_wezel_stan` (`id_wezla`,`id_stanowiska`),
  ADD KEY `fk_kshs_skala` (`id_skala_override`),
  ADD KEY `idx_kshs_stan` (`id_stanowiska`,`aktywny`);

--
-- Indeksy dla tabeli `kompetencje_szkolenia_map`
--
ALTER TABLE `kompetencje_szkolenia_map`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_map` (`typ`,`id_kompetencji`,`szkolenie_id`);

--
-- Indeksy dla tabeli `kompetencje_twarde_oceny`
--
ALTER TABLE `kompetencje_twarde_oceny`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_twarde_unique_day` (`id_uzytkownika`,`id_zasobu`,`data_oceny`,`rater_level`),
  ADD KEY `idx_uzytkownik` (`id_uzytkownika`),
  ADD KEY `idx_zasob` (`id_zasobu`),
  ADD KEY `idx_skala` (`wartosc`),
  ADD KEY `fk_kto_ocenil_twarde` (`rater_id`),
  ADD KEY `idx_oceny_hard_trend` (`id_uzytkownika`,`id_zasobu`,`data_oceny`,`rater_level`),
  ADD KEY `idx_kto_is_exam` (`is_exam`),
  ADD KEY `idx_kto_user` (`id_uzytkownika`),
  ADD KEY `idx_kto_zasob` (`id_zasobu`);

--
-- Indeksy dla tabeli `kompetencje_twarde_zasoby`
--
ALTER TABLE `kompetencje_twarde_zasoby`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_ktz_skala` (`id_skala`);

--
-- Indeksy dla tabeli `mes_nonprod_activity`
--
ALTER TABLE `mes_nonprod_activity`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_nva` (`code`);

--
-- Indeksy dla tabeli `mes_resource_group`
--
ALTER TABLE `mes_resource_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_name` (`name`),
  ADD KEY `fk_mes_rg_root` (`root_struktura_id`);

--
-- Indeksy dla tabeli `mes_resource_group_item`
--
ALTER TABLE `mes_resource_group_item`
  ADD PRIMARY KEY (`group_id`,`struktura_id`),
  ADD KEY `fk_rg_node` (`struktura_id`);

--
-- Indeksy dla tabeli `mes_route`
--
ALTER TABLE `mes_route`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_route` (`sku`,`operacja_kod`,`resource_group_id`),
  ADD KEY `fk_route_rg` (`resource_group_id`),
  ADD KEY `sku` (`sku`,`operacja_kod`);

--
-- Indeksy dla tabeli `mes_scrap_reason`
--
ALTER TABLE `mes_scrap_reason`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_scrap` (`code`);

--
-- Indeksy dla tabeli `mes_sic_config`
--
ALTER TABLE `mes_sic_config`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_sicc` (`sku`,`operacja_kod`,`resource_group_id`),
  ADD KEY `fk_sicc_rg` (`resource_group_id`);

--
-- Indeksy dla tabeli `mes_sic_entry`
--
ALTER TABLE `mes_sic_entry`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_entry_scrap` (`scrap_reason_id`),
  ADD KEY `fk_entry_nva` (`nva_id`),
  ADD KEY `run_id` (`run_id`,`ts`),
  ADD KEY `status_kolor` (`status_kolor`);

--
-- Indeksy dla tabeli `mes_sic_run`
--
ALTER TABLE `mes_sic_run`
  ADD PRIMARY KEY (`id`),
  ADD KEY `resource_group_id` (`resource_group_id`,`aktywny`),
  ADD KEY `zlecenie_nr` (`zlecenie_nr`,`operacja_kod`);

--
-- Indeksy dla tabeli `modules`
--
ALTER TABLE `modules`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Indeksy dla tabeli `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indeksy dla tabeli `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD PRIMARY KEY (`role_id`,`perm_key`),
  ADD KEY `idx_roleperm_permission_id` (`permission_id`);

--
-- Indeksy dla tabeli `struktura`
--
ALTER TABLE `struktura`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_struktura_element` (`element_id`),
  ADD KEY `idx_id_rodzica` (`id_rodzica`),
  ADD KEY `idx_kolejnosc` (`kolejnosc`),
  ADD KEY `idx_aktywny` (`aktywny`),
  ADD KEY `idx_typ_zasobu` (`typ_zasobu_id`),
  ADD KEY `idx_mpk_linia` (`mpk_linia_id`);

--
-- Indeksy dla tabeli `struktura_edycja_log`
--
ALTER TABLE `struktura_edycja_log`
  ADD PRIMARY KEY (`id`);

--
-- Indeksy dla tabeli `struktura_slownik_element`
--
ALTER TABLE `struktura_slownik_element`
  ADD PRIMARY KEY (`id`);

--
-- Indeksy dla tabeli `struktura_slownik_mpk_linia`
--
ALTER TABLE `struktura_slownik_mpk_linia`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_mpk_numer` (`mpk`);

--
-- Indeksy dla tabeli `struktura_slownik_typ_zasobu`
--
ALTER TABLE `struktura_slownik_typ_zasobu`
  ADD PRIMARY KEY (`id`);

--
-- Indeksy dla tabeli `system_settings`
--
ALTER TABLE `system_settings`
  ADD PRIMARY KEY (`key`);

--
-- Indeksy dla tabeli `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `pin` (`pin`),
  ADD UNIQUE KEY `numerPracownika` (`numerPracownika`),
  ADD UNIQUE KEY `uq_users_pin` (`pin`),
  ADD KEY `fk_users_role` (`role_id`),
  ADD KEY `idx_users_name` (`nazwisko`,`imie`),
  ADD KEY `idx_users_active` (`aktywny`);

--
-- Indeksy dla tabeli `users_permission`
--
ALTER TABLE `users_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `key` (`key`),
  ADD KEY `idx_module` (`module`),
  ADD KEY `idx_name` (`name`);

--
-- Indeksy dla tabeli `users_role`
--
ALTER TABLE `users_role`
  ADD PRIMARY KEY (`user_id`,`role_id`),
  ADD UNIQUE KEY `uq_user` (`user_id`),
  ADD KEY `idx_role` (`role_id`),
  ADD KEY `idx_user` (`user_id`);

--
-- Indeksy dla tabeli `users_role_permission`
--
ALTER TABLE `users_role_permission`
  ADD PRIMARY KEY (`role_id`,`permission_id`),
  ADD KEY `idx_perm` (`permission_id`),
  ADD KEY `idx_role2` (`role_id`);

--
-- Indeksy dla tabeli `users_user_permission`
--
ALTER TABLE `users_user_permission`
  ADD PRIMARY KEY (`user_id`,`permission_id`),
  ADD KEY `idx_user3` (`user_id`),
  ADD KEY `idx_perm3` (`permission_id`);

--
-- Indeksy dla tabeli `user_permissions`
--
ALTER TABLE `user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `module_code` (`module_code`);

--
-- AUTO_INCREMENT dla zrzuconych tabel
--

--
-- AUTO_INCREMENT dla tabeli `audit_log`
--
ALTER TABLE `audit_log`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=203;

--
-- AUTO_INCREMENT dla tabeli `audit_user_permissions`
--
ALTER TABLE `audit_user_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `cmms_assignment_rule`
--
ALTER TABLE `cmms_assignment_rule`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `cmms_escalation_rule`
--
ALTER TABLE `cmms_escalation_rule`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `cmms_group`
--
ALTER TABLE `cmms_group`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT dla tabeli `cmms_permissions`
--
ALTER TABLE `cmms_permissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT dla tabeli `cmms_plik`
--
ALTER TABLE `cmms_plik`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT dla tabeli `cmms_responsibilities`
--
ALTER TABLE `cmms_responsibilities`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT dla tabeli `cmms_responsibility_contacts`
--
ALTER TABLE `cmms_responsibility_contacts`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `cmms_roles`
--
ALTER TABLE `cmms_roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT dla tabeli `cmms_slownik_element`
--
ALTER TABLE `cmms_slownik_element`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT dla tabeli `cmms_slownik_mpk_linia`
--
ALTER TABLE `cmms_slownik_mpk_linia`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT dla tabeli `cmms_slownik_plik_typ`
--
ALTER TABLE `cmms_slownik_plik_typ`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT dla tabeli `cmms_slownik_typ_zasobu`
--
ALTER TABLE `cmms_slownik_typ_zasobu`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT dla tabeli `cmms_statuses`
--
ALTER TABLE `cmms_statuses`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT dla tabeli `cmms_status_categories`
--
ALTER TABLE `cmms_status_categories`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT dla tabeli `cmms_status_transitions`
--
ALTER TABLE `cmms_status_transitions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT dla tabeli `cmms_struktura`
--
ALTER TABLE `cmms_struktura`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT dla tabeli `cmms_subtype_responsibility`
--
ALTER TABLE `cmms_subtype_responsibility`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT dla tabeli `cmms_tickets`
--
ALTER TABLE `cmms_tickets`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=85;

--
-- AUTO_INCREMENT dla tabeli `cmms_ticket_comments`
--
ALTER TABLE `cmms_ticket_comments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `cmms_ticket_downtime`
--
ALTER TABLE `cmms_ticket_downtime`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `cmms_ticket_files`
--
ALTER TABLE `cmms_ticket_files`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT dla tabeli `cmms_ticket_notifications`
--
ALTER TABLE `cmms_ticket_notifications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `cmms_ticket_status_history`
--
ALTER TABLE `cmms_ticket_status_history`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `cmms_ticket_status_log`
--
ALTER TABLE `cmms_ticket_status_log`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=142;

--
-- AUTO_INCREMENT dla tabeli `cmms_ticket_subtypes`
--
ALTER TABLE `cmms_ticket_subtypes`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT dla tabeli `cmms_ticket_time_spans`
--
ALTER TABLE `cmms_ticket_time_spans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT dla tabeli `cmms_ticket_types`
--
ALTER TABLE `cmms_ticket_types`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT dla tabeli `cmms_ticket_worklog`
--
ALTER TABLE `cmms_ticket_worklog`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `cmms_workflows`
--
ALTER TABLE `cmms_workflows`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT dla tabeli `cmms_workflow_assignments`
--
ALTER TABLE `cmms_workflow_assignments`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT dla tabeli `cmms_workflow_transitions`
--
ALTER TABLE `cmms_workflow_transitions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT dla tabeli `cmms_workflow_transition_roles`
--
ALTER TABLE `cmms_workflow_transition_roles`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `kompetencje_brygada`
--
ALTER TABLE `kompetencje_brygada`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT dla tabeli `kompetencje_dzial`
--
ALTER TABLE `kompetencje_dzial`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT dla tabeli `kompetencje_miekkie_kryteria`
--
ALTER TABLE `kompetencje_miekkie_kryteria`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT dla tabeli `kompetencje_miekkie_oceny`
--
ALTER TABLE `kompetencje_miekkie_oceny`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT dla tabeli `kompetencje_obszar`
--
ALTER TABLE `kompetencje_obszar`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT dla tabeli `kompetencje_oceny`
--
ALTER TABLE `kompetencje_oceny`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT dla tabeli `kompetencje_pracownicy`
--
ALTER TABLE `kompetencje_pracownicy`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT dla tabeli `kompetencje_relacje_nadzoru`
--
ALTER TABLE `kompetencje_relacje_nadzoru`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT dla tabeli `kompetencje_skala_wartosci`
--
ALTER TABLE `kompetencje_skala_wartosci`
  MODIFY `id` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT dla tabeli `kompetencje_skale`
--
ALTER TABLE `kompetencje_skale`
  MODIFY `id` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT dla tabeli `kompetencje_slownik`
--
ALTER TABLE `kompetencje_slownik`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT dla tabeli `kompetencje_slownik_typ_zasobu`
--
ALTER TABLE `kompetencje_slownik_typ_zasobu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT dla tabeli `kompetencje_slownik_typ_zasobu_hr`
--
ALTER TABLE `kompetencje_slownik_typ_zasobu_hr`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT dla tabeli `kompetencje_stanowiska`
--
ALTER TABLE `kompetencje_stanowiska`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT dla tabeli `kompetencje_stanowiska_poziomy`
--
ALTER TABLE `kompetencje_stanowiska_poziomy`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT dla tabeli `kompetencje_stanowisko_wymagania`
--
ALTER TABLE `kompetencje_stanowisko_wymagania`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `kompetencje_struktura`
--
ALTER TABLE `kompetencje_struktura`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT dla tabeli `kompetencje_struktura_hr`
--
ALTER TABLE `kompetencje_struktura_hr`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT dla tabeli `kompetencje_struktura_hr_stanowisko`
--
ALTER TABLE `kompetencje_struktura_hr_stanowisko`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT dla tabeli `kompetencje_szkolenia_map`
--
ALTER TABLE `kompetencje_szkolenia_map`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `kompetencje_twarde_oceny`
--
ALTER TABLE `kompetencje_twarde_oceny`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT dla tabeli `kompetencje_twarde_zasoby`
--
ALTER TABLE `kompetencje_twarde_zasoby`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT dla tabeli `mes_nonprod_activity`
--
ALTER TABLE `mes_nonprod_activity`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `mes_resource_group`
--
ALTER TABLE `mes_resource_group`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT dla tabeli `mes_route`
--
ALTER TABLE `mes_route`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `mes_scrap_reason`
--
ALTER TABLE `mes_scrap_reason`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `mes_sic_config`
--
ALTER TABLE `mes_sic_config`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `mes_sic_entry`
--
ALTER TABLE `mes_sic_entry`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `mes_sic_run`
--
ALTER TABLE `mes_sic_run`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `modules`
--
ALTER TABLE `modules`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT dla tabeli `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT dla tabeli `struktura`
--
ALTER TABLE `struktura`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT dla tabeli `struktura_edycja_log`
--
ALTER TABLE `struktura_edycja_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT dla tabeli `struktura_slownik_element`
--
ALTER TABLE `struktura_slownik_element`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT dla tabeli `struktura_slownik_mpk_linia`
--
ALTER TABLE `struktura_slownik_mpk_linia`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT dla tabeli `struktura_slownik_typ_zasobu`
--
ALTER TABLE `struktura_slownik_typ_zasobu`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT dla tabeli `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT dla tabeli `users_permission`
--
ALTER TABLE `users_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=123;

--
-- AUTO_INCREMENT dla tabeli `user_permissions`
--
ALTER TABLE `user_permissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Ograniczenia dla zrzutów tabel
--

--
-- Ograniczenia dla tabeli `audit_user_permissions`
--
ALTER TABLE `audit_user_permissions`
  ADD CONSTRAINT `fk_audit_actor` FOREIGN KEY (`actor_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_audit_target` FOREIGN KEY (`target_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ograniczenia dla tabeli `cmms_assignment_rule`
--
ALTER TABLE `cmms_assignment_rule`
  ADD CONSTRAINT `fk_car_mpk` FOREIGN KEY (`mpk_id`) REFERENCES `cmms_slownik_mpk_linia` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_car_structure` FOREIGN KEY (`structure_id`) REFERENCES `cmms_struktura` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Ograniczenia dla tabeli `cmms_group_rotation`
--
ALTER TABLE `cmms_group_rotation`
  ADD CONSTRAINT `fk_gr_group` FOREIGN KEY (`group_id`) REFERENCES `cmms_group` (`id`) ON DELETE CASCADE;

--
-- Ograniczenia dla tabeli `cmms_group_user`
--
ALTER TABLE `cmms_group_user`
  ADD CONSTRAINT `fk_gu_group` FOREIGN KEY (`group_id`) REFERENCES `cmms_group` (`id`) ON DELETE CASCADE;

--
-- Ograniczenia dla tabeli `cmms_plik`
--
ALTER TABLE `cmms_plik`
  ADD CONSTRAINT `fk_pliki_typ` FOREIGN KEY (`typ_id`) REFERENCES `cmms_slownik_plik_typ` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Ograniczenia dla tabeli `cmms_responsibility_contacts`
--
ALTER TABLE `cmms_responsibility_contacts`
  ADD CONSTRAINT `fk_resp_contact` FOREIGN KEY (`responsibility_id`) REFERENCES `cmms_responsibilities` (`id`) ON DELETE CASCADE;

--
-- Ograniczenia dla tabeli `cmms_role_permission`
--
ALTER TABLE `cmms_role_permission`
  ADD CONSTRAINT `cmms_role_permission_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `cmms_roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cmms_role_permission_ibfk_2` FOREIGN KEY (`permission_id`) REFERENCES `cmms_permissions` (`id`) ON DELETE CASCADE;

--
-- Ograniczenia dla tabeli `cmms_slownik_element_tr`
--
ALTER TABLE `cmms_slownik_element_tr`
  ADD CONSTRAINT `fk_eltr_el` FOREIGN KEY (`element_id`) REFERENCES `cmms_slownik_element` (`id`) ON DELETE CASCADE;

--
-- Ograniczenia dla tabeli `cmms_statuses`
--
ALTER TABLE `cmms_statuses`
  ADD CONSTRAINT `fk_cmms_statuses_category` FOREIGN KEY (`category_id`) REFERENCES `cmms_status_categories` (`id`) ON UPDATE CASCADE;

--
-- Ograniczenia dla tabeli `cmms_struktura`
--
ALTER TABLE `cmms_struktura`
  ADD CONSTRAINT `fk_cmms_struktura_element` FOREIGN KEY (`element_id`) REFERENCES `cmms_slownik_element` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cmms_struktura_id_element` FOREIGN KEY (`id_element`) REFERENCES `cmms_slownik_element` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cmms_struktura_parent` FOREIGN KEY (`parent_id`) REFERENCES `cmms_struktura` (`id`) ON UPDATE CASCADE;

--
-- Ograniczenia dla tabeli `cmms_subtype_responsibility`
--
ALTER TABLE `cmms_subtype_responsibility`
  ADD CONSTRAINT `fk_sr_responsibility` FOREIGN KEY (`responsibility_id`) REFERENCES `cmms_responsibilities` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_sr_subtype` FOREIGN KEY (`subtype_id`) REFERENCES `cmms_ticket_subtypes` (`id`) ON DELETE CASCADE;

--
-- Ograniczenia dla tabeli `cmms_tickets`
--
ALTER TABLE `cmms_tickets`
  ADD CONSTRAINT `fk_cmms_tickets_group` FOREIGN KEY (`group_id`) REFERENCES `cmms_group` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_t_resp` FOREIGN KEY (`responsibility_id`) REFERENCES `cmms_responsibilities` (`id`),
  ADD CONSTRAINT `fk_t_sub` FOREIGN KEY (`subtype_id`) REFERENCES `cmms_ticket_subtypes` (`id`),
  ADD CONSTRAINT `fk_t_type` FOREIGN KEY (`type_id`) REFERENCES `cmms_ticket_types` (`id`),
  ADD CONSTRAINT `fk_tickets_assignee` FOREIGN KEY (`assignee_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tickets_reporter` FOREIGN KEY (`reporter_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tickets_status` FOREIGN KEY (`status_id`) REFERENCES `cmms_statuses` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tickets_struktura` FOREIGN KEY (`struktura_id`) REFERENCES `cmms_struktura` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tickets_subtype` FOREIGN KEY (`subtype_id`) REFERENCES `cmms_ticket_subtypes` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tickets_type` FOREIGN KEY (`type_id`) REFERENCES `cmms_ticket_types` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tickets_workflow` FOREIGN KEY (`workflow_id`) REFERENCES `cmms_workflows` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Ograniczenia dla tabeli `cmms_ticket_downtime`
--
ALTER TABLE `cmms_ticket_downtime`
  ADD CONSTRAINT `fk_td_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `cmms_tickets` (`id`) ON DELETE CASCADE;

--
-- Ograniczenia dla tabeli `cmms_ticket_files`
--
ALTER TABLE `cmms_ticket_files`
  ADD CONSTRAINT `fk_files_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `cmms_tickets` (`id`) ON DELETE CASCADE;

--
-- Ograniczenia dla tabeli `cmms_ticket_status_log`
--
ALTER TABLE `cmms_ticket_status_log`
  ADD CONSTRAINT `fk_ctsl_from` FOREIGN KEY (`from_status_id`) REFERENCES `cmms_statuses` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_ctsl_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `cmms_tickets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_ctsl_to` FOREIGN KEY (`to_status_id`) REFERENCES `cmms_statuses` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_log_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Ograniczenia dla tabeli `cmms_ticket_subtypes`
--
ALTER TABLE `cmms_ticket_subtypes`
  ADD CONSTRAINT `fk_subtype_type` FOREIGN KEY (`type_id`) REFERENCES `cmms_ticket_types` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_subtypes_type` FOREIGN KEY (`type_id`) REFERENCES `cmms_ticket_types` (`id`) ON UPDATE CASCADE;

--
-- Ograniczenia dla tabeli `cmms_ticket_worklog`
--
ALTER TABLE `cmms_ticket_worklog`
  ADD CONSTRAINT `fk_tw_ticket` FOREIGN KEY (`ticket_id`) REFERENCES `cmms_tickets` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_tw_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Ograniczenia dla tabeli `cmms_user_role`
--
ALTER TABLE `cmms_user_role`
  ADD CONSTRAINT `cmms_user_role_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cmms_user_role_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `cmms_roles` (`id`) ON DELETE CASCADE;

--
-- Ograniczenia dla tabeli `cmms_workflow_assignments`
--
ALTER TABLE `cmms_workflow_assignments`
  ADD CONSTRAINT `fk_cwfa_wf` FOREIGN KEY (`workflow_id`) REFERENCES `cmms_workflows` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ograniczenia dla tabeli `cmms_workflow_statuses`
--
ALTER TABLE `cmms_workflow_statuses`
  ADD CONSTRAINT `fk_cws_status` FOREIGN KEY (`status_id`) REFERENCES `cmms_statuses` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cws_workflow` FOREIGN KEY (`workflow_id`) REFERENCES `cmms_workflows` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ograniczenia dla tabeli `cmms_workflow_transitions`
--
ALTER TABLE `cmms_workflow_transitions`
  ADD CONSTRAINT `fk_cwtr_from` FOREIGN KEY (`from_status_id`) REFERENCES `cmms_statuses` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cwtr_to` FOREIGN KEY (`to_status_id`) REFERENCES `cmms_statuses` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cwtr_wf` FOREIGN KEY (`workflow_id`) REFERENCES `cmms_workflows` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ograniczenia dla tabeli `cmms_workflow_transition_roles`
--
ALTER TABLE `cmms_workflow_transition_roles`
  ADD CONSTRAINT `fk_cwtr_transition` FOREIGN KEY (`transition_id`) REFERENCES `cmms_workflow_transitions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ograniczenia dla tabeli `kompetencje_brygada`
--
ALTER TABLE `kompetencje_brygada`
  ADD CONSTRAINT `fk_brygada_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_brygada_dzial` FOREIGN KEY (`id_dzial`) REFERENCES `kompetencje_dzial` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_brygada_edited_by` FOREIGN KEY (`edited_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_brygada_obszar` FOREIGN KEY (`id_obszar`) REFERENCES `kompetencje_obszar` (`id`) ON DELETE SET NULL;

--
-- Ograniczenia dla tabeli `kompetencje_dzial`
--
ALTER TABLE `kompetencje_dzial`
  ADD CONSTRAINT `fk_odpowiedzialny_kompetencje` FOREIGN KEY (`id_odpowiedzialnego`) REFERENCES `kompetencje_pracownicy` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `kompetencje_dzial_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `kompetencje_dzial_ibfk_2` FOREIGN KEY (`edited_by`) REFERENCES `users` (`id`);

--
-- Ograniczenia dla tabeli `kompetencje_miekkie_kryteria`
--
ALTER TABLE `kompetencje_miekkie_kryteria`
  ADD CONSTRAINT `fk_kmk_skala` FOREIGN KEY (`id_skala`) REFERENCES `kompetencje_skale` (`id`),
  ADD CONSTRAINT `fk_miekkie_skala` FOREIGN KEY (`id_skala`) REFERENCES `kompetencje_skale` (`id`);

--
-- Ograniczenia dla tabeli `kompetencje_miekkie_oceny`
--
ALTER TABLE `kompetencje_miekkie_oceny`
  ADD CONSTRAINT `fk_kmo_comp` FOREIGN KEY (`kompetencja_id`) REFERENCES `kompetencje_miekkie_kryteria` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_kmo_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_kto_ocenil_miekkie` FOREIGN KEY (`rater_id`) REFERENCES `users` (`id`);

--
-- Ograniczenia dla tabeli `kompetencje_obszar`
--
ALTER TABLE `kompetencje_obszar`
  ADD CONSTRAINT `kompetencje_obszar_ibfk_1` FOREIGN KEY (`id_dzial`) REFERENCES `kompetencje_dzial` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `kompetencje_obszar_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `kompetencje_obszar_ibfk_3` FOREIGN KEY (`edited_by`) REFERENCES `users` (`id`);

--
-- Ograniczenia dla tabeli `kompetencje_pracownicy`
--
ALTER TABLE `kompetencje_pracownicy`
  ADD CONSTRAINT `kompetencje_pracownicy_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `kompetencje_pracownicy_ibfk_2` FOREIGN KEY (`id_dzial`) REFERENCES `kompetencje_dzial` (`id`),
  ADD CONSTRAINT `kompetencje_pracownicy_ibfk_3` FOREIGN KEY (`id_obszar`) REFERENCES `kompetencje_obszar` (`id`),
  ADD CONSTRAINT `kompetencje_pracownicy_ibfk_4` FOREIGN KEY (`id_stanowisko`) REFERENCES `kompetencje_stanowiska` (`id`),
  ADD CONSTRAINT `kompetencje_pracownicy_ibfk_5` FOREIGN KEY (`id_brygada`) REFERENCES `kompetencje_brygada` (`id`);

--
-- Ograniczenia dla tabeli `kompetencje_relacje_nadzoru`
--
ALTER TABLE `kompetencje_relacje_nadzoru`
  ADD CONSTRAINT `fk_sub_user` FOREIGN KEY (`subordinate_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_sup_user` FOREIGN KEY (`supervisor_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ograniczenia dla tabeli `kompetencje_skala_wartosci`
--
ALTER TABLE `kompetencje_skala_wartosci`
  ADD CONSTRAINT `fk_ksw_skala` FOREIGN KEY (`id_skala`) REFERENCES `kompetencje_skale` (`id`) ON DELETE CASCADE;

--
-- Ograniczenia dla tabeli `kompetencje_stanowiska`
--
ALTER TABLE `kompetencje_stanowiska`
  ADD CONSTRAINT `kompetencje_stanowiska_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `kompetencje_stanowiska_ibfk_4` FOREIGN KEY (`edited_by`) REFERENCES `users` (`id`);

--
-- Ograniczenia dla tabeli `kompetencje_stanowiska_poziomy`
--
ALTER TABLE `kompetencje_stanowiska_poziomy`
  ADD CONSTRAINT `kompetencje_stanowiska_poziomy_ibfk_1` FOREIGN KEY (`id_stanowiska`) REFERENCES `kompetencje_stanowiska` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `kompetencje_stanowiska_poziomy_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `kompetencje_stanowiska_poziomy_ibfk_3` FOREIGN KEY (`edited_by`) REFERENCES `users` (`id`);

--
-- Ograniczenia dla tabeli `kompetencje_stanowisko_wymagania`
--
ALTER TABLE `kompetencje_stanowisko_wymagania`
  ADD CONSTRAINT `fk_kw_stan` FOREIGN KEY (`id_stanowiska`) REFERENCES `kompetencje_stanowiska` (`id`) ON DELETE CASCADE;

--
-- Ograniczenia dla tabeli `kompetencje_struktura`
--
ALTER TABLE `kompetencje_struktura`
  ADD CONSTRAINT `fk_kompetencje_struktura_rodzic` FOREIGN KEY (`id_rodzica`) REFERENCES `kompetencje_struktura` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_kompetencje_struktura_typ` FOREIGN KEY (`typ_zasobu_id`) REFERENCES `kompetencje_slownik_typ_zasobu` (`id`) ON DELETE SET NULL;

--
-- Ograniczenia dla tabeli `kompetencje_struktura_hr`
--
ALTER TABLE `kompetencje_struktura_hr`
  ADD CONSTRAINT `fk_ksh_skala` FOREIGN KEY (`id_skala`) REFERENCES `kompetencje_skale` (`id`),
  ADD CONSTRAINT `kompetencje_struktura_hr_ibfk_1` FOREIGN KEY (`id_rodzica`) REFERENCES `kompetencje_struktura_hr` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `kompetencje_struktura_hr_ibfk_2` FOREIGN KEY (`id_powiazany_zasob`) REFERENCES `struktura` (`id`) ON DELETE SET NULL;

--
-- Ograniczenia dla tabeli `kompetencje_struktura_hr_stanowisko`
--
ALTER TABLE `kompetencje_struktura_hr_stanowisko`
  ADD CONSTRAINT `fk_kshs_skala` FOREIGN KEY (`id_skala_override`) REFERENCES `kompetencje_skale` (`id`),
  ADD CONSTRAINT `fk_kshs_stan` FOREIGN KEY (`id_stanowiska`) REFERENCES `kompetencje_stanowiska` (`id`),
  ADD CONSTRAINT `fk_kshs_wezel` FOREIGN KEY (`id_wezla`) REFERENCES `kompetencje_struktura_hr` (`id`);

--
-- Ograniczenia dla tabeli `kompetencje_twarde_oceny`
--
ALTER TABLE `kompetencje_twarde_oceny`
  ADD CONSTRAINT `fk_kto_ocenil_twarde` FOREIGN KEY (`rater_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `fk_kto_user` FOREIGN KEY (`id_uzytkownika`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_kto_zasob` FOREIGN KEY (`id_zasobu`) REFERENCES `kompetencje_twarde_zasoby` (`id`) ON DELETE CASCADE;

--
-- Ograniczenia dla tabeli `kompetencje_twarde_zasoby`
--
ALTER TABLE `kompetencje_twarde_zasoby`
  ADD CONSTRAINT `fk_ktz_skala` FOREIGN KEY (`id_skala`) REFERENCES `kompetencje_skale` (`id`),
  ADD CONSTRAINT `fk_twarde_skala` FOREIGN KEY (`id_skala`) REFERENCES `kompetencje_skale` (`id`);

--
-- Ograniczenia dla tabeli `mes_resource_group`
--
ALTER TABLE `mes_resource_group`
  ADD CONSTRAINT `fk_mes_rg_root` FOREIGN KEY (`root_struktura_id`) REFERENCES `cmms_struktura` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_rg_root` FOREIGN KEY (`root_struktura_id`) REFERENCES `cmms_struktura` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Ograniczenia dla tabeli `mes_resource_group_item`
--
ALTER TABLE `mes_resource_group_item`
  ADD CONSTRAINT `fk_rg_group` FOREIGN KEY (`group_id`) REFERENCES `mes_resource_group` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_rg_node` FOREIGN KEY (`struktura_id`) REFERENCES `cmms_struktura` (`id`) ON UPDATE CASCADE;

--
-- Ograniczenia dla tabeli `mes_route`
--
ALTER TABLE `mes_route`
  ADD CONSTRAINT `fk_route_rg` FOREIGN KEY (`resource_group_id`) REFERENCES `mes_resource_group` (`id`) ON UPDATE CASCADE;

--
-- Ograniczenia dla tabeli `mes_sic_config`
--
ALTER TABLE `mes_sic_config`
  ADD CONSTRAINT `fk_sicc_rg` FOREIGN KEY (`resource_group_id`) REFERENCES `mes_resource_group` (`id`) ON UPDATE CASCADE;

--
-- Ograniczenia dla tabeli `mes_sic_entry`
--
ALTER TABLE `mes_sic_entry`
  ADD CONSTRAINT `fk_entry_nva` FOREIGN KEY (`nva_id`) REFERENCES `mes_nonprod_activity` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_entry_run` FOREIGN KEY (`run_id`) REFERENCES `mes_sic_run` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_entry_scrap` FOREIGN KEY (`scrap_reason_id`) REFERENCES `mes_scrap_reason` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Ograniczenia dla tabeli `mes_sic_run`
--
ALTER TABLE `mes_sic_run`
  ADD CONSTRAINT `fk_run_rg` FOREIGN KEY (`resource_group_id`) REFERENCES `mes_resource_group` (`id`) ON UPDATE CASCADE;

--
-- Ograniczenia dla tabeli `role_permissions`
--
ALTER TABLE `role_permissions`
  ADD CONSTRAINT `fk_role_permissions_permission` FOREIGN KEY (`permission_id`) REFERENCES `users_permission` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_role_permissions_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Ograniczenia dla tabeli `struktura`
--
ALTER TABLE `struktura`
  ADD CONSTRAINT `fk_struktura_element` FOREIGN KEY (`element_id`) REFERENCES `struktura_slownik_element` (`id`),
  ADD CONSTRAINT `fk_struktura_rodzic` FOREIGN KEY (`id_rodzica`) REFERENCES `struktura` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_struktura_typ_zasobu` FOREIGN KEY (`typ_zasobu_id`) REFERENCES `struktura_slownik_typ_zasobu` (`id`);

--
-- Ograniczenia dla tabeli `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE SET NULL;

--
-- Ograniczenia dla tabeli `users_role`
--
ALTER TABLE `users_role`
  ADD CONSTRAINT `fk_users_role_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_users_role_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ograniczenia dla tabeli `users_role_permission`
--
ALTER TABLE `users_role_permission`
  ADD CONSTRAINT `fk_role_perm_perm` FOREIGN KEY (`permission_id`) REFERENCES `users_permission` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_role_perm_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Ograniczenia dla tabeli `users_user_permission`
--
ALTER TABLE `users_user_permission`
  ADD CONSTRAINT `fk_user_perm_perm` FOREIGN KEY (`permission_id`) REFERENCES `users_permission` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_user_perm_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ograniczenia dla tabeli `user_permissions`
--
ALTER TABLE `user_permissions`
  ADD CONSTRAINT `user_permissions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_permissions_ibfk_2` FOREIGN KEY (`module_code`) REFERENCES `modules` (`code`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
