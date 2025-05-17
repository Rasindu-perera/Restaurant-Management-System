-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: May 15, 2025 at 08:12 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `restaurant_inventory`
--

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `category_id` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`category_id`, `name`) VALUES
(10, 'Bakery'),
(5, 'Beverages'),
(9, 'Condiments'),
(3, 'Dairy'),
(8, 'Fruits'),
(6, 'Grains'),
(1, 'Meat'),
(7, 'Seafood'),
(4, 'Spices'),
(2, 'Vegetables');

-- --------------------------------------------------------

--
-- Table structure for table `inventory_items`
--

CREATE TABLE `inventory_items` (
  `cost_per_unit` double DEFAULT NULL,
  `current_quantity` double NOT NULL,
  `min_stock_level` double DEFAULT NULL,
  `item_id` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `storage_location` varchar(255) DEFAULT NULL,
  `unit` varchar(255) NOT NULL,
  `category_id` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory_items`
--

INSERT INTO `inventory_items` (`cost_per_unit`, `current_quantity`, `min_stock_level`, `item_id`, `name`, `storage_location`, `unit`, `category_id`) VALUES
(NULL, 30, 10, 15, 'Chicken', 'F01', 'kg', 1),
(NULL, 30, 5, 16, 'Carrot', 'S01', 'kg', 2),
(NULL, 22, 2, 17, 'Mushroom', 'S01', 'kg', 2),
(NULL, 5, 5, 18, 'Coconut Oil', 'S01', 'l', 10),
(NULL, 10, 5, 19, 'cheese', 'S01', 'kg', 3),
(NULL, 3, 5, 20, 'cucumber', 'F01', 'kg', 2);

-- --------------------------------------------------------

--
-- Table structure for table `purchases`
--

CREATE TABLE `purchases` (
  `purchase_id` bigint(20) NOT NULL,
  `supplier_id` bigint(20) NOT NULL,
  `purchase_date` datetime(6) NOT NULL,
  `purchase_time` time(6) NOT NULL,
  `invoice_number` varchar(255) DEFAULT NULL,
  `total_cost` double NOT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `created_by` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `purchases`
--

INSERT INTO `purchases` (`purchase_id`, `supplier_id`, `purchase_date`, `purchase_time`, `invoice_number`, `total_cost`, `notes`, `created_by`) VALUES
(4, 9, '2025-05-08 13:48:29.000000', '19:18:29.000000', NULL, 50, 'baught carrot', NULL),
(5, 9, '2025-05-08 13:49:56.000000', '19:19:56.000000', NULL, 5, 'baught mushroom', NULL),
(6, 9, '2025-05-08 13:57:53.000000', '19:27:53.000000', NULL, 10, 'coconut oil and chicken purchased', NULL),
(7, 9, '2025-05-08 13:59:16.000000', '19:29:16.000000', NULL, 40, 'meat and mushroom purchased', NULL),
(8, 10, '2025-05-08 16:12:19.000000', '21:42:19.000000', NULL, 60, 'baught meat', NULL),
(9, 10, '2025-05-08 16:14:35.000000', '21:44:35.000000', NULL, 40, 'baught meat and mushroom extra', NULL),
(10, 9, '2025-05-11 18:06:52.000000', '23:36:52.000000', NULL, 126, '', NULL),
(11, 11, '2025-05-15 05:14:30.000000', '10:44:30.000000', NULL, 120, 'baught cheese', NULL),
(12, 11, '2025-05-15 06:00:22.000000', '11:30:22.000000', NULL, 10, 'bought cucumber', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `purchase_items`
--

CREATE TABLE `purchase_items` (
  `id` bigint(20) NOT NULL,
  `purchase_id` bigint(20) NOT NULL,
  `item_id` bigint(20) NOT NULL,
  `quantity` double NOT NULL,
  `unit_price` double NOT NULL,
  `expiry_date` date DEFAULT NULL,
  `batch_number` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `purchase_items`
--

INSERT INTO `purchase_items` (`id`, `purchase_id`, `item_id`, `quantity`, `unit_price`, `expiry_date`, `batch_number`) VALUES
(1, 4, 16, 25, 2, '2025-05-15', '0001'),
(2, 5, 17, 5, 1, '2025-05-22', '0002'),
(3, 6, 18, 10, 1, '2025-05-22', '0003'),
(4, 7, 15, 10, 3, '2025-05-22', '0004'),
(5, 7, 17, 10, 1, '2025-05-22', '0004'),
(6, 8, 15, 20, 3, '2025-05-22', '0005'),
(7, 9, 15, 10, 3, '2025-05-22', '0006'),
(8, 9, 17, 10, 1, '2025-05-22', '0006'),
(9, 10, 16, 18, 7, '2025-05-14', '12321'),
(10, 11, 19, 10, 12, '2025-05-29', '0007'),
(11, 12, 20, 10, 1, '2025-05-29', '0008');

-- --------------------------------------------------------

--
-- Table structure for table `stock_usage_logs`
--

CREATE TABLE `stock_usage_logs` (
  `usage_date` date NOT NULL,
  `id` bigint(20) NOT NULL,
  `item_id` bigint(20) NOT NULL,
  `recorded_by` bigint(20) NOT NULL,
  `notes` varchar(500) DEFAULT NULL,
  `quantity_used` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stock_usage_logs`
--

INSERT INTO `stock_usage_logs` (`usage_date`, `id`, `item_id`, `recorded_by`, `notes`, `quantity_used`) VALUES
('2025-05-08', 1, 16, 2, 'event1', 20),
('2025-05-08', 2, 15, 2, 'event1', 35),
('2025-05-08', 3, 17, 2, 'event1', 3),
('2025-05-08', 4, 16, 2, 'used', 20),
('2025-05-08', 5, 15, 2, 'used', 15),
('2025-05-11', 6, 16, 3, 'used', 8),
('2025-05-15', 7, 18, 3, 'used', 5);

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE `suppliers` (
  `supplier_id` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `contact_person` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `suppliers`
--

INSERT INTO `suppliers` (`supplier_id`, `name`, `contact_person`, `phone`, `email`) VALUES
(9, 'Vege Store', 'Vege store manager', '0712233442', 'vegestore@gmail.com'),
(10, 'Meast store', 'meat store manager', '073712842', 'meatstore@gmail.com'),
(11, 'Cheese Store', 'Cheesr store manager', '099239123', 'cheese@gmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `last_login` datetime(6) DEFAULT NULL,
  `user_id` bigint(20) NOT NULL,
  `full_name` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('ADMIN','MANAGER','STAFF') NOT NULL,
  `username` varchar(255) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `email` varchar(255) DEFAULT NULL,
  `email_verified` tinyint(1) DEFAULT 0,
  `phone` varchar(255) DEFAULT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `reset_token_expiry` datetime(6) DEFAULT NULL,
  `verification_token` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`last_login`, `user_id`, `full_name`, `password_hash`, `role`, `username`, `active`, `email`, `email_verified`, `phone`, `reset_token`, `reset_token_expiry`, `verification_token`) VALUES
('2025-05-08 05:26:33.000000', 2, 'kavishka', '$2a$10$DLNMyiw4AudUfoujUP/9i.4sF7OL5mjmI011hpc4MISIB.3I1Tf2O', 'STAFF', 'kavishka', 1, 'kavishka@gmail.com', 0, '1122334455', NULL, NULL, '4559cd9e-f17a-44e1-aa21-c82f20c9a74f'),
(NULL, 3, 'ADMIN', '$2a$12$a5NbqOXl58xAJUrlQ2v90.kpkgyAvhRymQ4yz64jtfsYQ3ngIpaeG', 'ADMIN', 'admin', 1, 'admin@gmail.com', 0, '1234567890', NULL, NULL, 'a5761d03-d347-4502-9846-93671535e08d');

-- --------------------------------------------------------

--
-- Table structure for table `waste_log`
--

CREATE TABLE `waste_log` (
  `id` bigint(20) NOT NULL,
  `quantity` double NOT NULL,
  `item_id` bigint(20) NOT NULL,
  `recorded_by` bigint(20) NOT NULL,
  `waste_date` datetime(6) NOT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `reason` enum('ACCIDENT','OTHER','OVER_PREPARATION','SPOILAGE') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `waste_log`
--

INSERT INTO `waste_log` (`id`, `quantity`, `item_id`, `recorded_by`, `waste_date`, `notes`, `reason`) VALUES
(1, 2, 16, 3, '2025-05-15 05:46:10.000000', 'diposed', 'SPOILAGE'),
(2, 2, 17, 3, '2025-05-15 05:49:16.000000', 'disposed', 'SPOILAGE'),
(3, 7, 20, 3, '2025-05-15 06:01:01.000000', 'spoiled', 'SPOILAGE');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`),
  ADD UNIQUE KEY `UK_category_name` (`name`);

--
-- Indexes for table `inventory_items`
--
ALTER TABLE `inventory_items`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `FK_inventory_category` (`category_id`);

--
-- Indexes for table `purchases`
--
ALTER TABLE `purchases`
  ADD PRIMARY KEY (`purchase_id`),
  ADD KEY `supplier_id` (`supplier_id`),
  ADD KEY `FK_purchases_created_by` (`created_by`);

--
-- Indexes for table `purchase_items`
--
ALTER TABLE `purchase_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `purchase_id` (`purchase_id`),
  ADD KEY `item_id` (`item_id`);

--
-- Indexes for table `stock_usage_logs`
--
ALTER TABLE `stock_usage_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FK6rfdu2amjjm4n7s22wvyde5dv` (`item_id`),
  ADD KEY `FK4u9o21h1j65l1l778mw1qyqx` (`recorded_by`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`supplier_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `UK_r43af9ap4edm43mmtq01oddj6` (`username`),
  ADD UNIQUE KEY `UK_6dotkott2kjsp8vw4d0m25fb7` (`email`);

--
-- Indexes for table `waste_log`
--
ALTER TABLE `waste_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `FKdnesafob4mkopgawwrgeefs2e` (`item_id`),
  ADD KEY `FK9k3x137b9mgrhcuix7fuew8tv` (`recorded_by`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `inventory_items`
--
ALTER TABLE `inventory_items`
  MODIFY `item_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `purchases`
--
ALTER TABLE `purchases`
  MODIFY `purchase_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `purchase_items`
--
ALTER TABLE `purchase_items`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `stock_usage_logs`
--
ALTER TABLE `stock_usage_logs`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `supplier_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `waste_log`
--
ALTER TABLE `waste_log`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `inventory_items`
--
ALTER TABLE `inventory_items`
  ADD CONSTRAINT `FK_inventory_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`);

--
-- Constraints for table `purchases`
--
ALTER TABLE `purchases`
  ADD CONSTRAINT `FK_purchases_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `purchases_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`supplier_id`);

--
-- Constraints for table `purchase_items`
--
ALTER TABLE `purchase_items`
  ADD CONSTRAINT `purchase_items_ibfk_1` FOREIGN KEY (`purchase_id`) REFERENCES `purchases` (`purchase_id`),
  ADD CONSTRAINT `purchase_items_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `inventory_items` (`item_id`);

--
-- Constraints for table `stock_usage_logs`
--
ALTER TABLE `stock_usage_logs`
  ADD CONSTRAINT `FK4u9o21h1j65l1l778mw1qyqx` FOREIGN KEY (`recorded_by`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `FK6rfdu2amjjm4n7s22wvyde5dv` FOREIGN KEY (`item_id`) REFERENCES `inventory_items` (`item_id`);

--
-- Constraints for table `waste_log`
--
ALTER TABLE `waste_log`
  ADD CONSTRAINT `FK9k3x137b9mgrhcuix7fuew8tv` FOREIGN KEY (`recorded_by`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `FKdnesafob4mkopgawwrgeefs2e` FOREIGN KEY (`item_id`) REFERENCES `inventory_items` (`item_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
