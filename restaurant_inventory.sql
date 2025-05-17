-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: May 17, 2025 at 12:05 PM
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
(126, 'Alcoholic Beverages'),
(143, 'Baby Food'),
(97, 'Bakery Items'),
(148, 'Baking Mixes'),
(105, 'Beverages'),
(96, 'Breads'),
(115, 'Breakfast Items'),
(106, 'Canned Goods'),
(160, 'Catering Supplies'),
(132, 'Charcuterie Items'),
(116, 'Cleaning Supplies'),
(101, 'Condiments'),
(120, 'Cooking Equipment'),
(140, 'Cooking Fats'),
(103, 'Cooking Oils'),
(91, 'Dairy Products'),
(157, 'Decoration Items'),
(131, 'Deli Meats and Cheeses'),
(114, 'Desserts'),
(108, 'Dry Goods'),
(92, 'Eggs'),
(151, 'Energy Bars and Protein Foods'),
(142, 'Fermented Foods'),
(129, 'Flour and Baking Ingredients'),
(145, 'Food Coloring and Additives'),
(107, 'Frozen Foods'),
(87, 'Fruits'),
(130, 'Garnishes'),
(135, 'Gluten-Free Products'),
(93, 'Grains'),
(134, 'Health and Specialty Foods'),
(99, 'Herbs'),
(156, 'Ice and Gel Packs'),
(128, 'Ice Cream and Frozen Desserts'),
(138, 'Imported Goods'),
(147, 'Instant Foods'),
(155, 'Jams and Spreads'),
(158, 'Kitchen Consumables'),
(119, 'Kitchen Utensils'),
(112, 'Legumes'),
(124, 'Marinades'),
(88, 'Meat'),
(159, 'Menu Samples/Test Kitchen Items'),
(127, 'Non-Alcoholic Beverages'),
(110, 'Nuts'),
(137, 'Organic Produce'),
(118, 'Packaging Materials'),
(117, 'Paper Goods'),
(94, 'Pasta'),
(121, 'Personal Protective Equipment'),
(144, 'Pet Food'),
(141, 'Pickled Items'),
(89, 'Poultry'),
(133, 'Prepared Foods'),
(122, 'Ready-to-Eat Items'),
(95, 'Rice'),
(102, 'Sauces'),
(90, 'Seafood'),
(125, 'Seasoning Mixes'),
(100, 'Seasonings'),
(111, 'Seeds'),
(109, 'Snacks'),
(149, 'Soups and Stews'),
(139, 'Specialty Ingredients'),
(98, 'Spices'),
(123, 'Stocks and Broths'),
(113, 'Sweeteners'),
(154, 'Syrups'),
(153, 'Tea and Coffee'),
(146, 'Thickeners and Stabilizers'),
(150, 'Tofu and Meat Substitutes'),
(136, 'Vegan and Vegetarian Items'),
(86, 'Vegetables'),
(104, 'Vinegars'),
(152, 'Water and Sparkling Water');

-- --------------------------------------------------------

--
-- Stand-in structure for view `daily_stock_usage_report`
-- (See below for the actual view)
--
CREATE TABLE `daily_stock_usage_report` (
`date` date
,`item_name` varchar(255)
,`total_quantity_used` double
);

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
(NULL, 20, 50, 24, 'Apple', 'Store 01', 'unit', 87);

-- --------------------------------------------------------

--
-- Stand-in structure for view `monthly_stock_usage_report`
-- (See below for the actual view)
--
CREATE TABLE `monthly_stock_usage_report` (
`year` int(4)
,`month` int(2)
,`item_name` varchar(255)
,`total_quantity_used` double
);

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
(19, 15, '2025-05-15 13:16:01.000000', '18:46:01.000000', NULL, 30, 'new apple stock', NULL);

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
(1, 19, 24, 150, 0.2, '2025-05-20', '00001');

-- --------------------------------------------------------

--
-- Stand-in structure for view `purchase_trends_report`
-- (See below for the actual view)
--
CREATE TABLE `purchase_trends_report` (
`year` int(4)
,`month` int(2)
,`item_name` varchar(255)
,`total_quantity_purchased` double
,`total_cost` double
);

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
('2025-05-15', 1, 24, 3, 'Event 1', 120);

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
(15, 'Fruit Supplier', 'Manager', '071 2391231', 'fruitmanager@gamil.com');

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
(1, 10, 24, 3, '2025-05-15 14:40:50.000000', '', 'SPOILAGE');

-- --------------------------------------------------------

--
-- Stand-in structure for view `weekly_stock_usage_report`
-- (See below for the actual view)
--
CREATE TABLE `weekly_stock_usage_report` (
`year` int(4)
,`week` int(2)
,`item_name` varchar(255)
,`total_quantity_used` double
);

-- --------------------------------------------------------

--
-- Structure for view `daily_stock_usage_report`
--
DROP TABLE IF EXISTS `daily_stock_usage_report`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `daily_stock_usage_report`  AS SELECT cast(`stock_usage_logs`.`usage_date` as date) AS `date`, `inventory_items`.`name` AS `item_name`, sum(`stock_usage_logs`.`quantity_used`) AS `total_quantity_used` FROM (`stock_usage_logs` join `inventory_items` on(`stock_usage_logs`.`item_id` = `inventory_items`.`item_id`)) GROUP BY cast(`stock_usage_logs`.`usage_date` as date), `inventory_items`.`name` ORDER BY cast(`stock_usage_logs`.`usage_date` as date) DESC, `inventory_items`.`name` ASC ;

-- --------------------------------------------------------

--
-- Structure for view `monthly_stock_usage_report`
--
DROP TABLE IF EXISTS `monthly_stock_usage_report`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `monthly_stock_usage_report`  AS SELECT year(`stock_usage_logs`.`usage_date`) AS `year`, month(`stock_usage_logs`.`usage_date`) AS `month`, `inventory_items`.`name` AS `item_name`, sum(`stock_usage_logs`.`quantity_used`) AS `total_quantity_used` FROM (`stock_usage_logs` join `inventory_items` on(`stock_usage_logs`.`item_id` = `inventory_items`.`item_id`)) GROUP BY year(`stock_usage_logs`.`usage_date`), month(`stock_usage_logs`.`usage_date`), `inventory_items`.`name` ORDER BY year(`stock_usage_logs`.`usage_date`) DESC, month(`stock_usage_logs`.`usage_date`) DESC, `inventory_items`.`name` ASC ;

-- --------------------------------------------------------

--
-- Structure for view `purchase_trends_report`
--
DROP TABLE IF EXISTS `purchase_trends_report`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `purchase_trends_report`  AS SELECT year(`purchases`.`purchase_date`) AS `year`, month(`purchases`.`purchase_date`) AS `month`, `inventory_items`.`name` AS `item_name`, sum(`purchase_items`.`quantity`) AS `total_quantity_purchased`, sum(`purchase_items`.`quantity` * `purchase_items`.`unit_price`) AS `total_cost` FROM ((`purchase_items` join `purchases` on(`purchase_items`.`purchase_id` = `purchases`.`purchase_id`)) join `inventory_items` on(`purchase_items`.`item_id` = `inventory_items`.`item_id`)) GROUP BY year(`purchases`.`purchase_date`), month(`purchases`.`purchase_date`), `inventory_items`.`name` ORDER BY year(`purchases`.`purchase_date`) DESC, month(`purchases`.`purchase_date`) DESC, `inventory_items`.`name` ASC ;

-- --------------------------------------------------------

--
-- Structure for view `weekly_stock_usage_report`
--
DROP TABLE IF EXISTS `weekly_stock_usage_report`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `weekly_stock_usage_report`  AS SELECT year(`stock_usage_logs`.`usage_date`) AS `year`, week(`stock_usage_logs`.`usage_date`) AS `week`, `inventory_items`.`name` AS `item_name`, sum(`stock_usage_logs`.`quantity_used`) AS `total_quantity_used` FROM (`stock_usage_logs` join `inventory_items` on(`stock_usage_logs`.`item_id` = `inventory_items`.`item_id`)) GROUP BY year(`stock_usage_logs`.`usage_date`), week(`stock_usage_logs`.`usage_date`), `inventory_items`.`name` ORDER BY year(`stock_usage_logs`.`usage_date`) DESC, week(`stock_usage_logs`.`usage_date`) DESC, `inventory_items`.`name` ASC ;

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
  MODIFY `category_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=161;

--
-- AUTO_INCREMENT for table `inventory_items`
--
ALTER TABLE `inventory_items`
  MODIFY `item_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `purchases`
--
ALTER TABLE `purchases`
  MODIFY `purchase_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `purchase_items`
--
ALTER TABLE `purchase_items`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `stock_usage_logs`
--
ALTER TABLE `stock_usage_logs`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `supplier_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `waste_log`
--
ALTER TABLE `waste_log`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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
