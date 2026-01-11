-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 11, 2026 at 06:35 AM
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
-- Database: `pawpal_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_adoptions`
--

CREATE TABLE `tbl_adoptions` (
  `adoption_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `pet_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `request_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_adoptions`
--

INSERT INTO `tbl_adoptions` (`adoption_id`, `user_id`, `pet_id`, `message`, `request_date`) VALUES
(3, 1, 20, 'I need a dog to play with my son while I am at work.', '2026-01-11 12:16:57'),
(4, 1, 24, 'I always wanted a crow as a pet.', '2026-01-11 12:17:53');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_donations`
--

CREATE TABLE `tbl_donations` (
  `donation_id` int(11) NOT NULL,
  `pet_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `donation_type` varchar(20) DEFAULT NULL,
  `amount` double(10,2) DEFAULT 0.00,
  `description` text NOT NULL DEFAULT '-',
  `donation_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_donations`
--

INSERT INTO `tbl_donations` (`donation_id`, `pet_id`, `user_id`, `donation_type`, `amount`, `description`, `donation_date`) VALUES
(10, 22, 5, 'Money', 67.00, '-', '2026-01-11 01:05:59'),
(11, 23, 5, 'Medical', 0.00, '1 bottle of iodine.', '2026-01-11 01:07:18'),
(12, 21, 5, 'Food', 0.00, '2 bags of kibbles.', '2026-01-11 01:09:42'),
(13, 23, 1, 'Money', 10.00, '-', '2026-01-11 12:59:51'),
(14, 23, 1, 'Food', 0.00, 'Bird Food', '2026-01-11 13:00:24'),
(15, 25, 1, 'Medical', 0.00, 'First aid kit', '2026-01-11 13:02:47');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pets`
--

CREATE TABLE `tbl_pets` (
  `pet_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `pet_name` varchar(100) NOT NULL,
  `age` varchar(20) NOT NULL,
  `gender` varchar(10) NOT NULL,
  `pet_type` varchar(50) NOT NULL,
  `category` varchar(50) NOT NULL,
  `health_status` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `image_paths` text NOT NULL,
  `lat` varchar(50) NOT NULL,
  `lng` varchar(50) NOT NULL,
  `status` varchar(20) DEFAULT 'Available',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_pets`
--

INSERT INTO `tbl_pets` (`pet_id`, `user_id`, `pet_name`, `age`, `gender`, `pet_type`, `category`, `health_status`, `description`, `image_paths`, `lat`, `lng`, `status`, `created_at`) VALUES
(20, 1, 'Buddy', '2', 'Male', 'Dog', 'Adoption', 'Healthy', 'A very friendly dog who loves to play fetch and is great with kids.', '[\"pawpal/assets/images/uploads/pet_20_1.jpg\"]', '6.459063', '100.502493', 'Available', '2026-01-11 00:00:44'),
(21, 1, 'Luna', '3', 'Female', 'Cat', 'Donation Request', 'Vaccinated', 'Very gentle house cat looking for a new family.', '[\"pawpal/assets/images/uploads/pet_21_1.jpg\"]', '6.459067', '100.502492', 'Available', '2026-01-11 00:32:00'),
(22, 1, 'Huh', '5', 'Male', 'Cat', 'Donation Request', 'Healthy', 'A white and black cat that always looks slightly confused.', '[\"pawpal/assets/images/uploads/pet_22_1.jpg\",\"pawpal/assets/images/uploads/pet_22_2.jpg\",\"pawpal/assets/images/uploads/pet_22_3.jpg\"]', '6.459067', '100.502491', 'Available', '2026-01-11 00:36:28'),
(23, 5, 'Robin', '1', 'Female', 'Bird', 'Help/ Rescue', 'Sick', 'Found injured near the roadside, needs vet assistance.', '[\"pawpal/assets/images/uploads/pet_23_1.jpg\",\"pawpal/assets/images/uploads/pet_23_2.jpg\",\"pawpal/assets/images/uploads/pet_23_3.jpg\"]', '6.45907', '100.50249', 'Available', '2026-01-11 00:41:15'),
(24, 5, 'Raven', '2', 'Female', 'Bird', 'Adoption', 'Healthy', 'Small crow looking for a loving owner.', '[\"pawpal/assets/images/uploads/pet_24_1.jpg\"]', '6.45907', '100.502492', 'Available', '2026-01-11 00:51:22'),
(25, 1, 'Random', '2', 'Female', 'Bird', 'Donation Request', 'Sick', 'Lying on the grounds, cannot fly.', '[\"pawpal/assets/images/uploads/pet_25_1.jpg\",\"pawpal/assets/images/uploads/pet_25_2.jpg\"]', '6.459061', '100.502494', 'Available', '2026-01-11 13:02:11');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `profile_image` varchar(255) DEFAULT NULL,
  `reg_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `name`, `email`, `password`, `phone`, `profile_image`, `reg_date`) VALUES
(1, 'Haziq Idrus', 'haziqidrus@gmail.com', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '0123456789', NULL, '2025-11-26 00:28:14'),
(5, 'Hikaru', 'hikaru@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '017894989', NULL, '2026-01-10 23:27:58'),
(6, 'PawPal', 'pawpal@gmail.com', 'aafdc23870ecbcd3d557b6423a8982134e17927e', '0123244232', NULL, '2026-01-11 12:55:04');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_adoptions`
--
ALTER TABLE `tbl_adoptions`
  ADD PRIMARY KEY (`adoption_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `pet_id` (`pet_id`);

--
-- Indexes for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  ADD PRIMARY KEY (`donation_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `pet_id` (`pet_id`);

--
-- Indexes for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  ADD PRIMARY KEY (`pet_id`),
  ADD KEY `fk_user_id` (`user_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_adoptions`
--
ALTER TABLE `tbl_adoptions`
  MODIFY `adoption_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  MODIFY `donation_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  MODIFY `pet_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_adoptions`
--
ALTER TABLE `tbl_adoptions`
  ADD CONSTRAINT `tbl_adoptions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tbl_users` (`user_id`),
  ADD CONSTRAINT `tbl_adoptions_ibfk_2` FOREIGN KEY (`pet_id`) REFERENCES `tbl_pets` (`pet_id`);

--
-- Constraints for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  ADD CONSTRAINT `tbl_donations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tbl_users` (`user_id`),
  ADD CONSTRAINT `tbl_donations_ibfk_2` FOREIGN KEY (`pet_id`) REFERENCES `tbl_pets` (`pet_id`);

--
-- Constraints for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  ADD CONSTRAINT `fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `tbl_users` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
