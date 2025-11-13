-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 13, 2025 at 03:52 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `database`
--

-- --------------------------------------------------------

--
-- Table structure for table `airports`
--

CREATE TABLE `airports` (
  `code` varchar(3) NOT NULL,
  `name` varchar(100) NOT NULL,
  `city` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `airports`
--

INSERT INTO `airports` (`code`, `name`, `city`) VALUES
('BKK', 'Suvarnabhumi Airport', 'Bangkok'),
('CNX', 'Chiang Mai International Airport', 'Chiang Mai'),
('DMK', 'Don Mueang International Airport', 'Bangkok'),
('HAN', 'Noi Bai International Airport', 'Hanoi'),
('HDY', 'Hat Yai International Airport', 'Hat Yai'),
('HKT', 'Phuket International Airport', 'Phuket'),
('ICN', 'Incheon International Airport', 'Seoul'),
('KUL', 'Kuala Lumpur International Airport', 'Kuala Lumpur'),
('LAX', 'Los Angeles International Airport', 'Los Angeles'),
('NRT', 'Narita International Airport', 'Tokyo'),
('SGN', 'Tan Son Nhat International Airport', 'Ho Chi Minh City'),
('SIN', 'Changi Airport', 'Singapore'),
('TPE', 'Taoyuan International Airport', 'Taipei'),
('USM', 'Samui International Airport', 'Koh Samui'),
('UTH', 'Udon Thani International Airport', 'Udon Thani');

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `id` int(11) NOT NULL,
  `flight_id` varchar(20) NOT NULL,
  `passenger_id` int(11) NOT NULL,
  `booking_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`id`, `flight_id`, `passenger_id`, `booking_date`) VALUES
(40, 'F001', 15, '2025-11-13 21:50:29');

-- --------------------------------------------------------

--
-- Table structure for table `flights`
--

CREATE TABLE `flights` (
  `id` varchar(20) NOT NULL,
  `flight_number` varchar(20) NOT NULL,
  `origin_code` varchar(3) NOT NULL,
  `destination_code` varchar(3) NOT NULL,
  `flight_date` date NOT NULL,
  `depart_time` time NOT NULL,
  `price` int(11) NOT NULL,
  `image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `flights`
--

INSERT INTO `flights` (`id`, `flight_number`, `origin_code`, `destination_code`, `flight_date`, `depart_time`, `price`, `image`) VALUES
('F001', 'FD1001', 'BKK', 'CNX', '2025-11-20', '09:30:00', 1500, 'img/01.jpg'),
('F002', 'FD1002', 'DMK', 'HKT', '2025-11-20', '11:00:00', 2200, 'img/02.jpg'),
('F003', 'FD1003', 'CNX', 'BKK', '2025-11-21', '14:15:00', 1400, 'img/03.jpg'),
('F004', 'FD1004', 'BKK', 'USM', '2025-11-22', '07:00:00', 2000, 'img/04.jpg'),
('F005', 'FD2001', 'DMK', 'KUL', '2025-11-20', '20:45:00', 2700, 'img/05.jpg'),
('F006', 'FD2002', 'BKK', 'SIN', '2025-11-25', '16:00:00', 3500, 'img/01.jpg'),
('F007', 'FD2003', 'HKT', 'HAN', '2025-11-28', '10:30:00', 3900, 'img/02.jpg'),
('F008', 'FD3001', 'BKK', 'TPE', '2025-12-01', '01:00:00', 5800, 'img/03.jpg'),
('F009', 'FD3002', 'ICN', 'BKK', '2025-12-05', '18:30:00', 7200, 'img/04.jpg'),
('F010', 'FD3003', 'CNX', 'SGN', '2025-11-27', '13:50:00', 4100, 'img/05.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `passengers`
--

CREATE TABLE `passengers` (
  `id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `passengers`
--

INSERT INTO `passengers` (`id`, `first_name`, `last_name`, `email`, `phone`) VALUES
(15, 'min', 'nieeeeee', 'minnie@gmail.com', '0987654321');

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` int(11) NOT NULL,
  `booking_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `status` varchar(20) NOT NULL,
  `transaction_code` varchar(100) DEFAULT NULL,
  `payment_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `booking_id`, `amount`, `status`, `transaction_code`, `payment_date`) VALUES
(13, 40, 1500.00, 'paid', '56848964', '2025-11-13 21:50:35');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `airports`
--
ALTER TABLE `airports`
  ADD PRIMARY KEY (`code`);

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `flight_id` (`flight_id`),
  ADD KEY `passenger_id` (`passenger_id`);

--
-- Indexes for table `flights`
--
ALTER TABLE `flights`
  ADD PRIMARY KEY (`id`),
  ADD KEY `origin_code` (`origin_code`),
  ADD KEY `destination_code` (`destination_code`);

--
-- Indexes for table `passengers`
--
ALTER TABLE `passengers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `booking_id` (`booking_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `passengers`
--
ALTER TABLE `passengers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`flight_id`) REFERENCES `flights` (`id`),
  ADD CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`passenger_id`) REFERENCES `passengers` (`id`);

--
-- Constraints for table `flights`
--
ALTER TABLE `flights`
  ADD CONSTRAINT `flights_ibfk_1` FOREIGN KEY (`origin_code`) REFERENCES `airports` (`code`),
  ADD CONSTRAINT `flights_ibfk_2` FOREIGN KEY (`destination_code`) REFERENCES `airports` (`code`);

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `fk_payments_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
