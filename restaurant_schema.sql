-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 18, 2025 at 09:31 AM
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
-- Database: `restaurant_schema`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin_users`
--

CREATE TABLE `admin_users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `role` varchar(20) DEFAULT 'admin',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `last_login` timestamp NULL DEFAULT NULL,
  `active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_users`
--

INSERT INTO `admin_users` (`id`, `username`, `password`, `email`, `full_name`, `role`, `created_at`, `last_login`, `active`) VALUES
(1, 'admin', 'jGl25bVBBBW96Qi9Te4V37Fnqchz/Eu4qB9vKrRIqRg=', 'admin@restaurant.com', 'Administrator', 'super_admin', '2025-05-18 02:23:19', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `bill`
--

CREATE TABLE `bill` (
  `bill_id` int(11) NOT NULL,
  `table_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `time` datetime DEFAULT current_timestamp(),
  `item_name` varchar(255) NOT NULL,
  `qty` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `total` decimal(10,2) GENERATED ALWAYS AS (`qty` * `price`) STORED
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bill`
--

INSERT INTO `bill` (`bill_id`, `table_id`, `order_id`, `time`, `item_name`, `qty`, `price`) VALUES
(11, 101, 99, '2025-05-11 09:51:42', 'Pasta', 3, 30.00),
(12, 101, 100, '2025-05-11 09:52:02', 'Ice Tea', 2, 20.00),
(13, 101, 100, '2025-05-11 09:52:02', 'Bun', 1, 20.00),
(15, 101, 9, '2025-05-11 11:33:08', 'Chicken Curry', 4, 40.00),
(16, 101, 10, '2025-05-11 12:04:22', 'Pasta', 2, 30.00),
(17, 101, 11, '2025-05-11 20:58:14', 'Milkshake', 2, 30.00),
(18, 101, 11, '2025-05-11 20:58:14', 'Chocolate Cake', 2, 35.00),
(20, 102, 12, '2025-05-15 16:20:38', 'Pasta', 3, 30.00),
(21, 102, 12, '2025-05-15 16:20:38', 'Chocolate Cake', 2, 35.00),
(23, 101, 13, '2025-05-15 17:07:04', 'Pasta', 2, 30.00),
(24, 101, 16, '2025-05-15 17:29:01', 'Milkshake', 3, 30.00),
(25, 101, 1, '2025-05-15 18:14:01', 'Pasta', 1, 30.00),
(26, 101, 1, '2025-05-15 18:14:01', 'Chocolate Cake', 1, 35.00),
(28, 101, 7, '2025-05-15 18:14:02', 'Pasta', 2, 30.00),
(29, 101, 14, '2025-05-15 18:14:02', 'Milkshake', 3, 30.00),
(30, 101, 15, '2025-05-15 18:14:02', 'Chocolate Cake', 2, 35.00),
(31, 101, 17, '2025-05-15 18:14:02', 'Pasta', 2, 30.00),
(32, 101, 18, '2025-05-15 18:14:02', 'Pasta', 2, 30.00),
(33, 101, 19, '2025-05-15 18:18:42', 'Pasta', 2, 30.00),
(34, 101, 20, '2025-05-15 18:18:42', 'Chicken Curry', 1, 40.00),
(35, 101, 21, '2025-05-15 18:35:16', 'Pasta', 2, 30.00),
(36, 101, 22, '2025-05-15 18:35:16', 'Pasta', 2, 30.00),
(37, 101, 23, '2025-05-16 09:33:00', 'Pasta', 2, 30.00),
(38, 101, 24, '2025-05-16 10:55:27', 'Pasta', 8, 30.00),
(39, 101, 24, '2025-05-16 10:55:27', 'Chicken Curry', 6, 40.00),
(40, 101, 24, '2025-05-16 10:55:27', 'Milkshake', 2, 30.00),
(41, 101, 24, '2025-05-16 10:55:27', 'Ice Tea', 20, 20.00),
(42, 101, 24, '2025-05-16 10:55:27', 'Chocolate Cake', 3, 35.00),
(43, 101, 24, '2025-05-16 10:55:27', 'bun', 2, 20.00),
(45, 101, 25, '2025-05-16 13:07:41', 'Chicken Curry', 3, 40.00),
(46, 101, 25, '2025-05-16 13:07:41', 'Milkshake', 5, 30.00),
(47, 101, 25, '2025-05-16 13:07:41', 'Ice Tea', 4, 20.00),
(48, 101, 26, '2025-05-17 10:11:34', 'Sweet corn soup', 2, 300.00),
(49, 101, 26, '2025-05-17 10:11:34', 'Mixed Fried rice', 1, 600.00),
(50, 101, 26, '2025-05-17 10:11:34', 'Nasi Goreng', 1, 550.00),
(51, 101, 26, '2025-05-17 10:11:34', 'Hot chocolate', 1, 300.00),
(52, 101, 26, '2025-05-17 10:11:34', 'Milk Shake Vanila', 1, 300.00),
(53, 101, 26, '2025-05-17 10:11:34', 'cheesecake', 2, 200.00),
(55, 102, 27, '2025-05-17 10:16:57', 'Sweet corn soup', 1, 300.00),
(56, 102, 27, '2025-05-17 10:16:57', 'Carb and egg soup', 1, 500.00),
(57, 102, 27, '2025-05-17 10:16:57', 'Seafood Fried Rice', 2, 750.00),
(58, 102, 27, '2025-05-17 10:16:57', 'Dan dan Noodeles', 1, 750.00),
(59, 102, 27, '2025-05-17 10:16:57', 'Hot chocolate', 2, 300.00),
(60, 102, 27, '2025-05-17 10:16:57', 'Prownie and Ice Cream', 2, 220.00),
(62, 102, 28, '2025-05-17 11:08:17', 'Sweet corn soup', 2, 300.00),
(63, 102, 28, '2025-05-17 11:08:17', 'Dan dan Noodeles', 2, 750.00),
(64, 102, 28, '2025-05-17 11:08:17', 'Carrot Cake', 2, 150.00),
(65, 102, 29, '2025-05-17 11:40:18', 'carb and onion soup', 2, 400.00),
(66, 102, 29, '2025-05-17 11:40:18', 'Mixed Fried rice', 2, 600.00),
(67, 102, 29, '2025-05-17 11:40:18', 'Dan dan Noodeles', 1, 750.00),
(68, 102, 29, '2025-05-17 11:40:18', 'Pan Fried Noodles', 1, 680.00),
(69, 102, 29, '2025-05-17 11:40:18', 'Iced tea', 1, 200.00),
(70, 102, 29, '2025-05-17 11:40:18', 'Milk Shake Choco', 1, 300.00),
(71, 102, 29, '2025-05-17 11:40:18', 'cheesecake', 2, 200.00),
(72, 102, 30, '2025-05-17 11:44:47', 'carb and onion soup', 2, 400.00),
(73, 102, 30, '2025-05-17 11:44:47', 'Nasi Goreng', 1, 550.00),
(74, 102, 30, '2025-05-17 11:44:47', 'Seafood Fried Rice', 1, 750.00),
(75, 102, 30, '2025-05-17 11:44:47', 'Dan dan Noodeles', 2, 750.00),
(76, 102, 30, '2025-05-17 11:44:47', 'Hot chocolate', 2, 300.00),
(77, 102, 30, '2025-05-17 11:44:47', 'Iced tea', 1, 200.00),
(78, 102, 30, '2025-05-17 11:44:47', 'Milk Shake Vanila', 1, 300.00),
(79, 102, 30, '2025-05-17 11:44:47', 'Carrot Cake', 2, 150.00),
(80, 102, 30, '2025-05-17 11:44:47', 'cheesecake', 1, 200.00),
(81, 102, 30, '2025-05-17 11:44:47', 'Fruit Bowl', 1, 200.00),
(87, 101, 31, '2025-05-17 12:15:25', 'carb and onion soup', 3, 400.00),
(88, 101, 31, '2025-05-17 12:15:25', 'Nasi Goreng', 1, 550.00),
(89, 101, 31, '2025-05-17 12:15:25', 'Seafood Fried Rice', 1, 750.00),
(90, 101, 31, '2025-05-17 12:15:25', 'Iced tea', 2, 200.00),
(91, 101, 31, '2025-05-17 12:15:25', 'Milk Shake Vanila', 1, 300.00),
(92, 101, 31, '2025-05-17 12:15:25', 'Carrot Cake', 1, 150.00),
(93, 101, 31, '2025-05-17 12:15:25', 'cheesecake', 2, 200.00),
(94, 101, 32, '2025-05-17 12:30:56', 'Carb and egg soup', 2, 500.00),
(95, 101, 32, '2025-05-17 12:30:56', 'Seafood Fried Rice', 1, 750.00),
(97, 101, 33, '2025-05-17 12:30:56', 'Carb and egg soup', 3, 500.00),
(98, 101, 33, '2025-05-17 12:30:56', 'Dan dan Noodeles', 2, 750.00),
(100, 101, 34, '2025-05-17 12:38:49', 'Sweet corn soup', 3, 300.00),
(101, 101, 34, '2025-05-17 12:38:49', 'Iced tea', 2, 200.00),
(103, 101, 35, '2025-05-17 12:38:49', 'Carb and egg soup', 2, 500.00),
(104, 101, 36, '2025-05-17 12:38:49', 'Carb and egg soup', 3, 500.00),
(105, 101, 36, '2025-05-17 12:38:49', 'Pan Fried Noodles', 2, 680.00),
(106, 101, 36, '2025-05-17 12:38:49', 'Pot Of Tea', 2, 120.00),
(107, 101, 36, '2025-05-17 12:38:49', 'cheesecake', 2, 200.00);

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`category_id`, `name`) VALUES
(1, 'Soup'),
(2, 'Rice'),
(3, 'Noodless'),
(4, 'Beverages'),
(5, 'Dessert');

-- --------------------------------------------------------

--
-- Table structure for table `chefs`
--

CREATE TABLE `chefs` (
  `chef_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `chefs`
--

INSERT INTO `chefs` (`chef_id`, `name`) VALUES
(1, 'Chef John'),
(2, 'Chef Sarah');

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `feedback_id` int(11) NOT NULL,
  `table_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `waiter_id` int(11) NOT NULL,
  `rating` int(11) NOT NULL CHECK (`rating` between 1 and 5),
  `comment` varchar(500) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `feedback`
--

INSERT INTO `feedback` (`feedback_id`, `table_id`, `order_id`, `waiter_id`, `rating`, `comment`, `created_at`) VALUES
(1, 101, 31, 1, 2, 'good', '2025-05-17 06:45:05'),
(2, 101, 33, 1, 5, 'good', '2025-05-17 06:54:11'),
(3, 101, 36, 1, 4, 'very good', '2025-05-17 07:07:57'),
(4, 101, 39, 1, 4, 'good', '2025-05-17 17:09:48'),
(5, 101, 40, 1, 5, 'very good', '2025-05-17 17:43:29');

-- --------------------------------------------------------

--
-- Table structure for table `menu_items`
--

CREATE TABLE `menu_items` (
  `item_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `menu_items`
--

INSERT INTO `menu_items` (`item_id`, `name`, `price`, `category_id`, `image_url`) VALUES
(1, 'Sweet corn soup', 300.00, 1, 'Sweet corn soup.jpg'),
(2, 'carb and onion soup', 400.00, 1, 'carb and onion soup.jpg'),
(3, 'Carb and egg soup', 500.00, 1, 'Carb and egg soup.jpg'),
(4, 'Tomyan Goong', 300.00, 1, 'Tomyan Goong.jpg'),
(5, 'Vegetable soup', 250.00, 1, 'Vegetable soup.jpg'),
(10, 'Mixed Fried rice', 600.00, 2, 'Mixed Fried rice.jpg'),
(11, 'Nasi Goreng', 550.00, 2, 'Nasi Goreng.jpg'),
(12, 'Seafood Fried Rice', 750.00, 2, 'Seafood Fried Rice.jpg'),
(13, 'Stean Rice', 700.00, 2, 'Stean Rice.jpg'),
(14, 'vegitable fried rice', 550.00, 2, 'vegitable fried rice.jpg'),
(15, 'Braised Noodless', 700.00, 3, 'Braised Noodless.jpg'),
(16, 'Dan dan Noodeles', 750.00, 3, 'Dan dan Noodeles.jpg'),
(17, 'Pan Fried Noodles', 680.00, 3, 'Pan Fried Noodles.jpg'),
(18, 'Vegitables Noodles', 650.00, 3, 'Vegitables Noodles.jpg'),
(19, 'Seafood noodles', 800.00, 3, 'Seafood noodles.jpg'),
(20, 'Carrot Cake', 150.00, 5, 'Carrot Cake.webp'),
(21, 'cheesecake', 200.00, 5, 'cheesecake.webp'),
(22, 'Fruit Bowl', 200.00, 5, 'Fruit Bowl.webp'),
(23, 'Prownie and Ice Cream', 220.00, 5, 'Prownie and Ice Cream.webp'),
(24, 'Hot chocolate', 300.00, 4, 'Hot chocolate.webp'),
(25, 'Iced tea', 200.00, 4, 'Iced tea.webp'),
(26, 'Milk Shake Choco', 300.00, 4, 'Milk Shake Choco.webp'),
(27, 'Milk Shake Vanila', 300.00, 4, 'Milk Shake Vanila.webp'),
(28, 'strawberry milk shake', 300.00, 4, 'strawberrymilkshake.webp'),
(29, 'Pot Of Tea', 120.00, 4, 'tea-pot-isolated-white-background_74190-7847.webp');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `table_id` int(11) NOT NULL,
  `waiter_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `status` enum('SENT','CONFIRMED','READY','COMPLETED') DEFAULT 'SENT'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `table_id`, `waiter_id`, `created_at`, `status`) VALUES
(1, 101, 1, '2025-05-11 11:00:44', 'COMPLETED'),
(7, 101, 1, '2025-05-11 11:22:18', 'COMPLETED'),
(9, 101, 1, '2025-05-11 11:33:06', 'COMPLETED'),
(10, 101, 1, '2025-05-11 12:04:20', 'COMPLETED'),
(11, 101, 1, '2025-05-11 20:56:14', 'COMPLETED'),
(12, 102, 2, '2025-05-15 16:20:05', 'COMPLETED'),
(13, 101, 1, '2025-05-15 17:06:49', 'COMPLETED'),
(14, 101, 1, '2025-05-15 17:08:29', 'COMPLETED'),
(15, 101, 1, '2025-05-15 17:19:06', 'COMPLETED'),
(16, 101, 1, '2025-05-15 17:28:41', 'COMPLETED'),
(17, 101, 1, '2025-05-15 17:33:09', 'COMPLETED'),
(18, 101, 1, '2025-05-15 18:11:18', 'COMPLETED'),
(19, 101, 1, '2025-05-15 18:17:28', 'COMPLETED'),
(20, 101, 1, '2025-05-15 18:17:56', 'COMPLETED'),
(21, 101, 1, '2025-05-15 18:32:29', 'COMPLETED'),
(22, 101, 1, '2025-05-15 18:34:17', 'COMPLETED'),
(23, 101, 1, '2025-05-16 09:32:37', 'COMPLETED'),
(24, 101, 1, '2025-05-16 10:54:27', 'COMPLETED'),
(25, 101, 1, '2025-05-16 13:07:18', 'COMPLETED'),
(26, 101, 1, '2025-05-17 10:10:16', 'COMPLETED'),
(27, 102, 2, '2025-05-17 10:15:36', 'COMPLETED'),
(28, 102, 2, '2025-05-17 11:06:12', 'COMPLETED'),
(29, 102, 2, '2025-05-17 11:39:56', 'COMPLETED'),
(30, 102, 2, '2025-05-17 11:44:20', 'COMPLETED'),
(31, 101, 1, '2025-05-17 12:14:31', 'COMPLETED'),
(32, 101, 1, '2025-05-17 12:16:51', 'COMPLETED'),
(33, 101, 1, '2025-05-17 12:23:56', 'COMPLETED'),
(34, 101, 1, '2025-05-17 12:31:13', 'COMPLETED'),
(35, 101, 1, '2025-05-17 12:31:52', 'COMPLETED'),
(36, 101, 1, '2025-05-17 12:37:26', 'COMPLETED'),
(37, 101, 1, '2025-05-17 13:39:24', 'SENT'),
(38, 101, 1, '2025-05-17 22:37:49', 'SENT'),
(39, 101, 1, '2025-05-17 22:39:35', 'SENT'),
(40, 101, 1, '2025-05-17 23:13:07', 'SENT');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `order_item_id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`order_item_id`, `order_id`, `item_id`, `quantity`) VALUES
(145, 1, 1, 1),
(146, 1, 5, 1),
(147, 7, 1, 2),
(148, 9, 2, 4),
(149, 10, 1, 2),
(150, 11, 3, 2),
(151, 11, 5, 2),
(152, 12, 1, 3),
(153, 12, 5, 2),
(154, 13, 1, 2),
(155, 14, 3, 3),
(156, 15, 5, 2),
(157, 16, 3, 3),
(158, 17, 1, 2),
(159, 18, 1, 2),
(160, 19, 1, 2),
(161, 20, 2, 1),
(162, 21, 1, 2),
(163, 22, 1, 2),
(164, 23, 1, 2),
(165, 24, 1, 8),
(166, 24, 2, 6),
(167, 24, 3, 2),
(168, 24, 4, 20),
(169, 24, 5, 3),
(170, 24, 10, 2),
(171, 25, 2, 3),
(172, 25, 3, 5),
(173, 25, 4, 4),
(174, 26, 1, 2),
(175, 26, 10, 1),
(176, 26, 11, 1),
(177, 26, 24, 1),
(178, 26, 27, 1),
(179, 26, 21, 2),
(180, 27, 1, 1),
(181, 27, 3, 1),
(182, 27, 12, 2),
(183, 27, 16, 1),
(184, 27, 24, 2),
(185, 27, 23, 2),
(186, 28, 1, 2),
(187, 28, 16, 2),
(188, 28, 20, 2),
(189, 29, 2, 2),
(190, 29, 10, 2),
(191, 29, 16, 1),
(192, 29, 17, 1),
(193, 29, 25, 1),
(194, 29, 26, 1),
(195, 29, 21, 2),
(196, 30, 2, 2),
(197, 30, 11, 1),
(198, 30, 12, 1),
(199, 30, 16, 2),
(200, 30, 24, 2),
(201, 30, 25, 1),
(202, 30, 27, 1),
(203, 30, 20, 2),
(204, 30, 21, 1),
(205, 30, 22, 1),
(206, 31, 2, 3),
(207, 31, 11, 1),
(208, 31, 12, 1),
(209, 31, 25, 2),
(210, 31, 27, 1),
(211, 31, 20, 1),
(212, 31, 21, 2),
(213, 32, 3, 2),
(214, 32, 12, 1),
(215, 33, 3, 3),
(216, 33, 16, 2),
(217, 34, 1, 3),
(218, 34, 25, 2),
(219, 35, 3, 2),
(220, 36, 3, 3),
(221, 36, 17, 2),
(222, 36, 29, 2),
(223, 36, 21, 2),
(224, 37, 21, 2),
(225, 38, 1, 4),
(226, 38, 10, 2),
(227, 38, 11, 2),
(228, 38, 15, 2),
(229, 38, 16, 2),
(230, 38, 25, 8),
(231, 38, 22, 4),
(232, 39, 4, 2),
(233, 40, 1, 2),
(234, 40, 10, 1),
(235, 40, 11, 1),
(236, 40, 15, 1),
(237, 40, 16, 1),
(238, 40, 28, 2),
(239, 40, 21, 2);

-- --------------------------------------------------------

--
-- Table structure for table `tables`
--

CREATE TABLE `tables` (
  `table_id` int(11) NOT NULL,
  `status` enum('available','Reserved') DEFAULT 'available',
  `reserved_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tables`
--

INSERT INTO `tables` (`table_id`, `status`, `reserved_by`, `created_at`) VALUES
(101, 'Reserved', 1, '2025-05-17 13:37:29'),
(102, 'available', NULL, NULL),
(103, 'available', NULL, NULL),
(104, 'available', NULL, NULL),
(105, 'available', NULL, NULL),
(106, 'available', NULL, NULL);

--
-- Triggers `tables`
--
DELIMITER $$
CREATE TRIGGER `before_insert_tables` BEFORE INSERT ON `tables` FOR EACH ROW BEGIN
  IF NEW.status = 'Reserved' THEN
    SET NEW.created_at = NOW();
  END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_update_tables` BEFORE UPDATE ON `tables` FOR EACH ROW BEGIN
  IF NEW.status = 'Reserved' AND OLD.status != 'Reserved' THEN
    SET NEW.created_at = NOW();
  END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `waiters`
--

CREATE TABLE `waiters` (
  `waiter_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `waiters`
--

INSERT INTO `waiters` (`waiter_id`, `name`) VALUES
(1, 'oshan'),
(2, 'thisara'),
(3, 'rasindu'),
(4, 'prakash'),
(5, 'isuru'),
(6, 'kavishka');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin_users`
--
ALTER TABLE `admin_users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `bill`
--
ALTER TABLE `bill`
  ADD PRIMARY KEY (`bill_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Indexes for table `chefs`
--
ALTER TABLE `chefs`
  ADD PRIMARY KEY (`chef_id`);

--
-- Indexes for table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`feedback_id`),
  ADD KEY `table_id` (`table_id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `menu_items`
--
ALTER TABLE `menu_items`
  ADD PRIMARY KEY (`item_id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`order_item_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `item_id` (`item_id`);

--
-- Indexes for table `tables`
--
ALTER TABLE `tables`
  ADD PRIMARY KEY (`table_id`);

--
-- Indexes for table `waiters`
--
ALTER TABLE `waiters`
  ADD PRIMARY KEY (`waiter_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin_users`
--
ALTER TABLE `admin_users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `bill`
--
ALTER TABLE `bill`
  MODIFY `bill_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=111;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `feedback_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `menu_items`
--
ALTER TABLE `menu_items`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `order_item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=240;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `feedback`
--
ALTER TABLE `feedback`
  ADD CONSTRAINT `feedback_ibfk_1` FOREIGN KEY (`table_id`) REFERENCES `tables` (`table_id`),
  ADD CONSTRAINT `feedback_ibfk_2` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`);

--
-- Constraints for table `menu_items`
--
ALTER TABLE `menu_items`
  ADD CONSTRAINT `menu_items_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`);

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `menu_items` (`item_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
