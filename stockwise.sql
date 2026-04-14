-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 14, 2026 at 09:59 PM
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
-- Database: `stockwise`
--

-- --------------------------------------------------------

--
-- Table structure for table `brands`
--

CREATE TABLE `brands` (
  `brand_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `brands`
--

INSERT INTO `brands` (`brand_id`, `name`, `description`) VALUES
(1, 'Del Monte', 'Canned fruits and vegetables'),
(2, 'Nestle', 'Dairy and beverages'),
(3, 'San Miguel', 'Food and beverages'),
(4, 'Century Tuna', 'Canned tuna products'),
(5, 'Magnolia', 'Dairy products'),
(6, 'Lucky Me', 'Instant noodles'),
(7, 'UFC', 'Condiments and sauces'),
(8, 'Rebisco', 'Biscuits and snacks'),
(9, 'Monde', 'Biscuits and bread'),
(10, 'Selecta', 'Ice cream and dairy'),
(11, 'Ariel', 'Laundry detergent'),
(12, 'Colgate', 'Oral care products'),
(13, 'Surf', 'Laundry products'),
(14, 'Champion', 'Laundry detergent'),
(15, '555', 'Canned seafood products'),
(16, 'Alaska', 'Dairy and milk products'),
(17, 'CDO', 'Processed meat and deli products'),
(18, 'Purefoods', 'Processed meat and food products'),
(19, 'Swift', 'Canned and processed meat'),
(20, 'Spam', 'Canned luncheon meat'),
(21, 'Datu Puti', 'Vinegar and soy sauce'),
(22, 'Silver Swan', 'Soy sauce and condiments'),
(23, 'Mang Tomas', 'All-around sauce'),
(24, 'Barako Bull', 'Native Philippine coffee'),
(25, 'Kapeng Barako', 'Batangas native coffee'),
(26, 'Great Taste', 'Instant coffee products'),
(27, 'Nescafe', 'Instant coffee and beverages'),
(28, 'Milo', 'Chocolate malt drink'),
(29, 'C2', 'Ready-to-drink tea'),
(30, 'Royal', 'Carbonated soft drinks'),
(31, 'Zesto', 'Juice drinks'),
(32, 'Tropicana', 'Fruit juice products'),
(33, 'Sun Crush', 'Powdered juice drinks'),
(34, 'Cream-O', 'Sandwich cookies'),
(35, 'Skyflakes', 'Crackers and biscuits'),
(36, 'M.Y. San', 'Biscuits and snacks'),
(37, 'Goya', 'Chocolates and candies'),
(38, 'Ricoa', 'Filipino chocolate products'),
(39, 'Jack n Jill', 'Snacks and chips'),
(40, 'Oishi', 'Snacks and extruded products'),
(41, 'Regent', 'Budget snacks and chips'),
(42, 'Purefoods Tender Juicy', 'Hotdogs and processed meats'),
(43, 'Marca Pina', 'Native vinegar and condiments'),
(44, 'Crispy Fry', 'Breading and cooking mix'),
(45, 'Maya', 'Baking mixes and flour');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `category_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`category_id`, `name`) VALUES
(1, 'Bakery'),
(2, 'Baking and Cooking'),
(3, 'Beverages'),
(4, 'Canned Goods and Jarred Goods'),
(5, 'Condiments'),
(6, 'Dairy and Eggs'),
(7, 'Deli and Prepared'),
(8, 'Frozen Goods'),
(9, 'Grains and Pasta'),
(10, 'Household and Cleaning'),
(11, 'Meat and Poultry'),
(12, 'Paper and Plastic'),
(13, 'Personal Care'),
(14, 'Pet Supplies'),
(15, 'Produce'),
(16, 'Seafood'),
(17, 'Snacks'),
(18, 'Stationery and Leisure');

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

CREATE TABLE `employees` (
  `employee_id` int(11) NOT NULL,
  `first_name` varchar(60) NOT NULL,
  `last_name` varchar(60) NOT NULL,
  `email` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`employee_id`, `first_name`, `last_name`, `email`) VALUES
(1, 'Ferdinand Philip Julius', 'Busayong', 'pj.busayong@stockwise.com'),
(2, 'Maria', 'Santos', 'maria.santos@stockwise.com'),
(3, 'Ian Miguel', 'Castigador', 'ian.castigador@stockwise.com'),
(4, 'Juan', 'dela Cruz', 'juan.delacruz@stockwise.com'),
(5, 'Jan Shele', 'Ramos', 'janshele.ramos@stockwise.com'),
(6, 'Ana', 'Reyes', 'ana.reyes@stockwise.com');

-- --------------------------------------------------------

--
-- Table structure for table `inventory`
--

CREATE TABLE `inventory` (
  `inventory_id` int(11) NOT NULL,
  `purchase_item_id` int(11) DEFAULT NULL,
  `product_id` int(11) NOT NULL,
  `variant_id` int(11) DEFAULT NULL,
  `batch_number` varchar(50) DEFAULT NULL,
  `current_stock` int(11) NOT NULL DEFAULT 0,
  `delivery_date` date DEFAULT curdate(),
  `expiration_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory`
--

INSERT INTO `inventory` (`inventory_id`, `purchase_item_id`, `product_id`, `variant_id`, `batch_number`, `current_stock`, `delivery_date`, `expiration_date`) VALUES
(5, NULL, 5, NULL, 'BATCH-2025-005', 45, '2025-01-10', '2026-06-10'),
(7, NULL, 7, NULL, 'BATCH-2025-007', 55, '2025-01-15', '2026-08-15'),
(8, NULL, 8, NULL, 'BATCH-2025-008', 120, '2026-01-01', '2027-12-31'),
(9, NULL, 9, NULL, 'BATCH-2025-009', 200, '2025-01-01', '2027-01-01'),
(10, NULL, 10, NULL, 'BATCH-2025-010', 150, '2025-01-01', '2026-06-01'),
(14, NULL, 13, 1, 'BATCH-2025-014', 50, '2026-01-10', '2028-01-10'),
(15, NULL, 13, 2, 'BATCH-2025-015', 40, '2026-01-10', '2028-01-10'),
(16, NULL, 14, 5, 'BATCH-2025-016', 60, '2026-01-15', '2027-06-15'),
(17, NULL, 15, 8, 'BATCH-2025-017', 80, '2026-03-01', '2028-03-01'),
(18, NULL, 15, 10, 'BATCH-2025-018', 60, '2026-03-01', '2028-03-01'),
(19, NULL, 16, NULL, 'BATCH-2025-019', 79, '2025-10-10', '2028-02-10'),
(20, NULL, 17, NULL, 'BATCH-2025-020', 8, '2025-10-10', '2028-02-10'),
(21, NULL, 18, NULL, 'BATCH-2025-021', 90, '2025-01-20', '2026-06-20'),
(22, NULL, 19, NULL, 'BATCH-2025-022', 70, '2025-01-20', '2026-06-20'),
(23, NULL, 20, NULL, 'BATCH-2025-023', 55, '2025-01-20', '2026-08-20'),
(24, NULL, 21, NULL, 'BATCH-2025-024', 70, '2026-03-01', '2028-03-01'),
(25, NULL, 22, NULL, 'BATCH-2025-025', 55, '2026-03-01', '2028-03-01'),
(26, NULL, 23, NULL, 'BATCH-2025-026', 65, '2026-03-01', '2028-03-01'),
(27, NULL, 24, NULL, 'BATCH-2025-027', 50, '2025-02-15', '2027-02-15'),
(28, NULL, 25, NULL, 'BATCH-2025-028', 40, '2026-02-15', '2026-04-20'),
(31, NULL, 28, 12, 'BATCH-2025-031', 50, '2026-04-01', '2026-04-22'),
(32, NULL, 28, 13, 'BATCH-2025-032', 30, '2026-04-01', '2026-04-22'),
(33, NULL, 29, NULL, 'BATCH-2025-033', 40, '2026-03-15', '2026-12-15'),
(36, NULL, 32, 23, 'BATCH-2025-036', 15, '2026-04-01', '2026-07-01'),
(37, NULL, 32, 24, 'BATCH-2025-037', 12, '2026-04-01', '2026-07-01'),
(40, NULL, 35, NULL, 'BATCH-2025-040', 500, '2026-01-01', '2027-12-31'),
(41, NULL, 36, NULL, 'BATCH-2025-041', 80, '2026-02-01', '2027-08-01'),
(42, NULL, 37, 18, 'BATCH-2025-042', 200, '2026-01-05', '2027-01-05'),
(43, NULL, 37, 19, 'BATCH-2025-043', 180, '2026-01-05', '2027-01-05'),
(44, NULL, 38, NULL, 'BATCH-2025-044', 60, '2026-01-10', '2027-07-10'),
(45, NULL, 39, 26, 'BATCH-2025-045', 45, '2026-02-01', '2028-02-01'),
(46, NULL, 40, NULL, 'BATCH-2025-046', 50, '2026-02-01', '2028-02-01'),
(47, NULL, 41, NULL, 'BATCH-2025-047', 40, '2026-03-01', '2028-03-01'),
(48, NULL, 42, NULL, 'BATCH-2025-048', 20, '2026-03-01', '2028-03-01'),
(49, NULL, 43, NULL, 'BATCH-2025-049', 55, '2026-01-15', '2028-01-15'),
(50, NULL, 44, 29, 'BATCH-2025-050', 35, '2026-01-15', '2028-01-15'),
(51, NULL, 45, NULL, 'BATCH-2025-051', 80, '2026-02-01', '2028-02-01'),
(52, NULL, 46, NULL, 'BATCH-2025-052', 30, '2026-02-01', '2028-02-01'),
(53, NULL, 47, NULL, 'BATCH-2025-053', 60, '2026-02-15', '2026-04-20'),
(54, NULL, 48, 32, 'BATCH-2025-054', 44, '2026-02-15', '2026-04-20'),
(55, NULL, 49, NULL, 'BATCH-2025-055', 70, '2026-02-15', '2026-04-20'),
(56, NULL, 28, NULL, 'BATCH-2026-790', 100, '2026-04-13', '2026-04-15'),
(57, NULL, 3, NULL, 'BATCH-2026-948', 99, '2026-04-13', '2026-04-29'),
(59, NULL, 51, NULL, 'BATCH-2026-295', 299, '2026-04-14', '2026-06-17'),
(60, NULL, 53, NULL, 'BATCH-2026-209', 300, '2026-04-14', '2026-06-10'),
(61, NULL, 52, NULL, 'BATCH-2026-BK-005', 35, '2026-04-14', '2027-04-14'),
(62, NULL, 54, NULL, 'BATCH-2026-BC-005', 50, '2026-04-14', '2027-06-14'),
(63, NULL, 55, NULL, 'BATCH-2026-BC-006', 39, '2026-04-14', '2027-04-14'),
(64, NULL, 56, NULL, 'BATCH-2026-BC-007', 45, '2026-04-14', '2027-04-14'),
(65, NULL, 57, NULL, 'BATCH-2026-BV-006', 60, '2026-04-14', '2027-10-14'),
(66, NULL, 58, NULL, 'BATCH-2026-BV-007', 80, '2026-04-14', '2027-10-14'),
(67, NULL, 59, NULL, 'BATCH-2026-BV-008', 70, '2026-04-14', '2027-04-14'),
(68, NULL, 60, NULL, 'BATCH-2026-BV-009', 60, '2026-04-14', '2027-04-14'),
(69, NULL, 61, NULL, 'BATCH-2026-CG-009', 50, '2026-04-14', '2027-10-14'),
(70, NULL, 62, NULL, 'BATCH-2026-CG-010', 45, '2026-04-14', '2027-10-14'),
(71, NULL, 64, NULL, 'BATCH-2026-CO-006', 35, '2026-04-14', '2027-04-14'),
(72, NULL, 65, NULL, 'BATCH-2026-CO-007', 30, '2026-04-14', '2027-04-14'),
(73, NULL, 66, NULL, 'BATCH-2026-DA-007', 55, '2026-04-14', '2027-04-14'),
(74, NULL, 67, NULL, 'BATCH-2026-DA-008', 60, '2026-04-14', '2027-10-14'),
(75, NULL, 68, NULL, 'BATCH-2026-DP-001', 30, '2026-04-14', '2026-10-14'),
(76, NULL, 69, NULL, 'BATCH-2026-DP-002', 25, '2026-04-14', '2026-10-14'),
(77, NULL, 70, NULL, 'BATCH-2026-DP-003', 25, '2026-04-14', '2026-10-14'),
(78, NULL, 71, NULL, 'BATCH-2026-DP-004', 20, '2026-04-14', '2026-10-14'),
(79, NULL, 72, NULL, 'BATCH-2026-DP-005', 20, '2026-04-14', '2026-10-14'),
(80, NULL, 73, NULL, 'BATCH-2026-FZ-004', 30, '2026-04-14', '2026-10-14'),
(81, NULL, 74, NULL, 'BATCH-2026-FZ-005', 25, '2026-04-14', '2026-10-14'),
(82, NULL, 75, NULL, 'BATCH-2026-GP-005', 50, '2026-04-14', '2027-04-14'),
(83, NULL, 76, NULL, 'BATCH-2026-GP-006', 50, '2026-04-14', '2027-04-14'),
(84, NULL, 77, NULL, 'BATCH-2026-HC-005', 30, '2026-04-14', '2027-04-14'),
(85, NULL, 78, NULL, 'BATCH-2026-HC-006', 25, '2026-04-14', '2027-04-14'),
(86, NULL, 79, NULL, 'BATCH-2026-HC-007', 25, '2026-04-14', '2027-04-14'),
(87, NULL, 80, NULL, 'BATCH-2026-MP-001', 40, '2026-04-14', '2026-10-14'),
(88, NULL, 81, NULL, 'BATCH-2026-MP-002', 35, '2026-04-14', '2026-10-14'),
(89, NULL, 82, NULL, 'BATCH-2026-MP-003', 30, '2026-04-14', '2027-04-14'),
(90, NULL, 83, NULL, 'BATCH-2026-MP-004', 30, '2026-04-14', '2027-04-14'),
(91, NULL, 84, NULL, 'BATCH-2026-MP-005', 35, '2026-04-14', '2027-04-14'),
(92, NULL, 85, NULL, 'BATCH-2026-PP-001', 80, '2026-04-14', '2027-04-14'),
(93, NULL, 86, NULL, 'BATCH-2026-PP-002', 40, '2026-04-14', '2027-04-14'),
(94, NULL, 87, NULL, 'BATCH-2026-PP-003', 60, '2026-04-14', '2027-04-14'),
(95, NULL, 88, NULL, 'BATCH-2026-PP-004', 50, '2026-04-14', '2027-04-14'),
(96, NULL, 89, NULL, 'BATCH-2026-PC-005', 35, '2026-04-14', '2027-04-14'),
(97, NULL, 90, NULL, 'BATCH-2026-PC-006', 40, '2026-04-14', '2027-04-14'),
(98, NULL, 91, NULL, 'BATCH-2026-PC-007', 30, '2026-04-14', '2027-04-14'),
(99, NULL, 92, NULL, 'BATCH-2026-PS-001', 25, '2026-04-14', '2027-04-14'),
(100, NULL, 93, NULL, 'BATCH-2026-PS-002', 30, '2026-04-14', '2027-04-14'),
(101, NULL, 94, NULL, 'BATCH-2026-PS-003', 25, '2026-04-14', '2027-04-14'),
(102, NULL, 95, NULL, 'BATCH-2026-PR-001', 50, '2026-04-14', '2026-07-14'),
(103, NULL, 96, NULL, 'BATCH-2026-PR-002', 50, '2026-04-14', '2026-07-14'),
(104, NULL, 97, NULL, 'BATCH-2026-PR-003', 60, '2026-04-14', '2026-07-14'),
(105, NULL, 98, NULL, 'BATCH-2026-PR-004', 55, '2026-04-14', '2026-07-14'),
(106, NULL, 99, NULL, 'BATCH-2026-SN-005', 55, '2026-04-14', '2027-04-14'),
(107, NULL, 100, NULL, 'BATCH-2026-SN-006', 45, '2026-04-14', '2027-04-14'),
(108, NULL, 101, NULL, 'BATCH-2026-SN-007', 40, '2026-04-14', '2027-04-14'),
(109, NULL, 37, 18, 'BATCH-2026-593', 100, '2026-04-14', '2026-04-30'),
(110, NULL, 37, 19, 'BATCH-2026-033', 98, '2026-04-14', '2026-04-20');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int(11) NOT NULL,
  `sku_code` varchar(50) NOT NULL,
  `name` varchar(150) NOT NULL,
  `category_id` int(11) NOT NULL,
  `brand_id` int(11) NOT NULL,
  `supplier_id` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `unit` varchar(50) NOT NULL,
  `reorder_level` int(11) DEFAULT 10
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `sku_code`, `name`, `category_id`, `brand_id`, `supplier_id`, `price`, `unit`, `reorder_level`) VALUES
(1, 'BK-001', 'White Bread Loaf', 1, 9, 8, 55.00, 'loaf', 15),
(2, 'BK-002', 'Whole Wheat Bread', 1, 9, 8, 65.00, 'loaf', 10),
(3, 'BK-003', 'Pandesal Pack', 1, 9, 8, 35.00, 'pack', 20),
(4, 'BC-001', 'All-Purpose Flour', 2, 1, 1, 42.00, 'kg', 15),
(5, 'BC-002', 'White Sugar', 2, 1, 1, 58.00, 'kg', 15),
(6, 'BC-003', 'Baking Powder', 2, 1, 1, 28.00, 'pack', 10),
(7, 'BC-004', 'Cooking Oil', 2, 7, 7, 75.00, 'bottle', 20),
(8, 'BV-001', 'Iced Tea', 3, 3, 3, 18.00, 'bottle', 50),
(9, 'BV-002', 'Mineral Water', 3, 2, 2, 12.00, 'bottle', 60),
(10, 'BV-003', 'Juice Drink', 3, 1, 1, 15.00, 'bottle', 40),
(11, 'BV-004', 'Coffee 3-in-1', 3, 2, 2, 8.50, 'sachet', 100),
(12, 'BV-005', 'Hot Chocolate Mix', 3, 2, 2, 45.00, 'pack', 25),
(13, 'CG-001', 'Pineapple', 4, 1, 1, 35.00, 'can', 20),
(14, 'CG-002', 'Tomato Sauce', 4, 1, 1, 28.50, 'can', 30),
(15, 'CG-003', 'Tuna Flakes', 4, 4, 4, 42.00, 'can', 25),
(16, 'CG-004', 'Corned Beef', 4, 3, 3, 83.00, 'can', 15),
(17, 'CG-005', 'Luncheon Meat', 4, 3, 3, 89.00, 'can', 10),
(18, 'CG-006', 'Sardines in Tomato Sauce', 4, 15, 4, 22.00, 'can', 30),
(19, 'CG-007', 'Pork and Beans', 4, 1, 1, 32.00, 'can', 20),
(20, 'CG-008', 'Coconut Milk', 4, 1, 1, 38.00, 'can', 15),
(21, 'CO-001', 'Banana Ketchup', 5, 7, 7, 38.00, 'bottle', 20),
(22, 'CO-002', 'Soy Sauce', 5, 7, 7, 22.00, 'bottle', 25),
(23, 'CO-003', 'Vinegar', 5, 7, 7, 18.00, 'bottle', 20),
(24, 'CO-004', 'Fish Sauce', 5, 7, 7, 25.00, 'bottle', 20),
(25, 'CO-005', 'Oyster Sauce', 5, 1, 1, 55.00, 'bottle', 15),
(26, 'DA-001', 'Evaporated Milk', 6, 5, 5, 22.00, 'can', 30),
(27, 'DA-002', 'Condensed Milk', 6, 2, 2, 29.00, 'can', 30),
(28, 'DA-003', 'Fresh Milk', 6, 5, 5, 65.00, 'carton', 20),
(29, 'DA-004', 'Cheese', 6, 5, 5, 95.00, 'pack', 15),
(30, 'DA-005', 'Butter', 6, 5, 5, 85.00, 'pack', 15),
(31, 'DA-006', 'Eggs', 6, 5, 5, 12.00, 'piece', 50),
(32, 'FZ-001', 'Ice Cream', 8, 10, 5, 120.00, 'tub', 10),
(33, 'FZ-002', 'Frozen Hotdog', 8, 3, 3, 95.00, 'pack', 15),
(34, 'FZ-003', 'Frozen Chicken Nuggets', 8, 3, 3, 110.00, 'pack', 10),
(35, 'GP-001', 'White Rice', 9, 3, 3, 55.00, 'kg', 30),
(36, 'GP-002', 'Spaghetti Noodles', 9, 6, 6, 38.00, 'pack', 20),
(37, 'GP-003', 'Instant Noodles', 9, 6, 6, 14.00, 'pack', 50),
(38, 'GP-004', 'Oatmeal', 9, 2, 2, 75.00, 'pack', 15),
(39, 'HC-001', 'Laundry Detergent Powder', 10, 11, 9, 125.00, 'pack', 10),
(40, 'HC-002', 'Fabric Conditioner', 10, 13, 9, 85.00, 'bottle', 10),
(41, 'HC-003', 'Dishwashing Liquid', 10, 7, 7, 55.00, 'bottle', 15),
(42, 'HC-004', 'Floor Wax', 10, 14, 9, 98.00, 'can', 8),
(43, 'PC-001', 'Toothpaste', 13, 12, 10, 55.00, 'tube', 15),
(44, 'PC-002', 'Shampoo', 13, 2, 2, 95.00, 'bottle', 10),
(45, 'PC-003', 'Bath Soap', 13, 12, 10, 35.00, 'bar', 20),
(46, 'PC-004', 'Deodorant', 13, 2, 2, 75.00, 'bottle', 10),
(47, 'SN-001', 'Cream Crackers', 17, 8, 8, 32.00, 'pack', 25),
(48, 'SN-002', 'Butter Cookies', 17, 9, 8, 45.00, 'pack', 20),
(49, 'SN-003', 'Potato Chips', 17, 8, 8, 28.00, 'pack', 30),
(50, 'SN-004', 'Cheese Curls', 17, 8, 8, 22.00, 'pack', 30),
(51, 'BK-004', 'Ensaymada', 1, 9, 6, 25.00, 'piece', 15),
(52, 'BK-005', 'Spanish Bread', 1, 9, 6, 10.00, 'piece', 20),
(53, 'BK-006', 'Monay', 1, 9, 6, 12.00, 'piece', 15),
(54, 'BC-005', 'Brown Sugar', 2, 1, 1, 62.00, 'kg', 10),
(55, 'BC-006', 'Bread Crumbs', 2, 44, 7, 35.00, 'pack', 10),
(56, 'BC-007', 'Crispy Fry Breading Mix', 2, 44, 7, 22.00, 'pack', 15),
(57, 'BV-006', 'Barako Ground Coffee', 3, 24, 3, 120.00, 'pack', 10),
(58, 'BV-007', 'Nescafe Instant Coffee', 3, 27, 2, 9.50, 'sachet', 80),
(59, 'BV-008', 'Carbonated Soft Drink', 3, 30, 15, 22.00, 'bottle', 40),
(60, 'BV-009', 'Powdered Juice Drink', 3, 33, 15, 12.00, 'sachet', 60),
(61, 'CG-009', 'Century Tuna Hot and Spicy', 4, 4, 11, 45.00, 'can', 20),
(62, 'CG-010', 'Mackerel in Tomato Sauce', 4, 15, 11, 28.00, 'can', 20),
(64, 'CO-006', 'Mang Tomas All-Around Sauce', 5, 23, 7, 32.00, 'bottle', 15),
(65, 'CO-007', 'Spicy Vinegar', 5, 43, 20, 20.00, 'bottle', 15),
(66, 'DA-007', 'All-Purpose Cream', 6, 5, 5, 48.00, 'pack', 20),
(67, 'DA-008', 'Alaska Powdered Milk', 6, 16, 12, 95.00, 'pack', 10),
(68, 'DP-001', 'CDO Chicken Longganisa', 7, 17, 13, 85.00, 'pack', 10),
(69, 'DP-002', 'CDO Beef Tocino', 7, 17, 13, 95.00, 'pack', 10),
(70, 'DP-003', 'Purefoods Chicken Tocino', 7, 18, 14, 98.00, 'pack', 10),
(71, 'DP-004', 'San Miguel Skinless Longanisa', 7, 3, 14, 90.00, 'pack', 10),
(72, 'DP-005', 'CDO Pork Ham', 7, 17, 13, 110.00, 'pack', 8),
(73, 'FZ-004', 'Frozen Siomai', 8, 17, 13, 85.00, 'pack', 10),
(74, 'FZ-005', 'Frozen Fish Fillet', 8, 3, 3, 130.00, 'pack', 8),
(75, 'GP-005', 'Bihon Noodles', 9, 6, 6, 32.00, 'pack', 20),
(76, 'GP-006', 'Canton Noodles', 9, 6, 6, 28.00, 'pack', 20),
(77, 'HC-005', 'Toilet Bowl Cleaner', 10, 14, 9, 65.00, 'bottle', 8),
(78, 'HC-006', 'Glass Cleaner Spray', 10, 9, 9, 75.00, 'bottle', 8),
(79, 'HC-007', 'Multi-Surface Disinfectant', 10, 11, 9, 90.00, 'bottle', 8),
(80, 'MP-001', 'Tender Juicy Hotdog', 11, 42, 14, 98.00, 'pack', 15),
(81, 'MP-002', 'CDO Liver Spread', 11, 17, 13, 35.00, 'can', 20),
(82, 'MP-003', 'Purefoods Corned Tuna', 11, 18, 14, 55.00, 'can', 15),
(83, 'MP-004', 'San Miguel Beef Loaf', 11, 3, 3, 68.00, 'can', 10),
(84, 'MP-005', 'Swift Corned Beef', 11, 19, 14, 79.00, 'can', 10),
(85, 'PP-001', 'Tissue Paper Roll', 12, 3, 3, 25.00, 'roll', 20),
(86, 'PP-002', 'Plastic Wrap', 12, 3, 3, 45.00, 'roll', 10),
(87, 'PP-003', 'Garbage Bags', 12, 3, 3, 35.00, 'pack', 15),
(88, 'PP-004', 'Paper Cups', 12, 3, 3, 28.00, 'pack', 15),
(89, 'PC-005', 'Facial Wash', 13, 2, 2, 120.00, 'bottle', 8),
(90, 'PC-006', 'Conditioner', 13, 2, 2, 110.00, 'bottle', 8),
(91, 'PC-007', 'Feminine Wash', 13, 12, 10, 85.00, 'bottle', 8),
(92, 'PS-001', 'Dog Food Dry', 14, 3, 3, 180.00, 'pack', 5),
(93, 'PS-002', 'Cat Food Wet', 14, 3, 3, 35.00, 'pouch', 10),
(94, 'PS-003', 'Cat Food Dry', 14, 3, 3, 155.00, 'pack', 5),
(95, 'PR-001', 'Garlic', 15, 1, 1, 15.00, '100g', 30),
(96, 'PR-002', 'White Onion', 15, 1, 1, 18.00, '100g', 30),
(97, 'PR-003', 'Tomato', 15, 1, 1, 12.00, '100g', 40),
(98, 'PR-004', 'Potato', 15, 1, 1, 20.00, '100g', 20),
(99, 'SN-005', 'Prawn Crackers', 17, 40, 16, 18.00, 'pack', 30),
(100, 'SN-006', 'Choco Mallows', 17, 37, 18, 38.00, 'pack', 20),
(101, 'SN-007', 'Ricoa Flat Tops', 17, 38, 18, 28.00, 'pack', 20);

-- --------------------------------------------------------

--
-- Table structure for table `product_variants`
--

CREATE TABLE `product_variants` (
  `variant_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `variant_name` varchar(100) NOT NULL,
  `size_grams` decimal(10,2) DEFAULT NULL,
  `additional_price` decimal(10,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_variants`
--

INSERT INTO `product_variants` (`variant_id`, `product_id`, `variant_name`, `size_grams`, `additional_price`) VALUES
(1, 13, 'Slices', 836.00, 5.00),
(2, 13, 'Tidbits', 836.00, 0.00),
(3, 13, 'Chunks', 836.00, 3.00),
(4, 13, 'Crushed', 836.00, 0.00),
(5, 14, 'Regular', 250.00, 0.00),
(6, 14, 'Italian Style', 250.00, 5.00),
(7, 14, 'Spicy', 250.00, 3.00),
(8, 15, 'Flakes in Oil', 180.00, 0.00),
(9, 15, 'Flakes in Water', 180.00, 0.00),
(10, 15, 'Hot and Spicy', 180.00, 3.00),
(11, 15, 'Caldereta', 180.00, 5.00),
(12, 27, '200ml', 200.00, 0.00),
(13, 27, '500ml', 500.00, 30.00),
(14, 27, '1000ml', 1000.00, 55.00),
(15, 12, 'Original', 20.00, 0.00),
(16, 12, 'Strong', 20.00, 0.50),
(17, 12, 'Decaf', 20.00, 1.00),
(18, 37, 'Chicken', 55.00, 0.00),
(19, 37, 'Beef', 55.00, 0.00),
(20, 37, 'Shrimp', 55.00, 0.00),
(21, 37, 'Kalamansi', 55.00, 0.00),
(22, 37, 'Pinoy Lomi', 65.00, 2.00),
(23, 32, 'Chocolate', 1500.00, 0.00),
(24, 32, 'Vanilla', 1500.00, 0.00),
(25, 32, 'Strawberry', 1500.00, 0.00),
(26, 32, 'Ube', 1500.00, 10.00),
(27, 40, 'Regular', 500.00, 0.00),
(28, 40, 'Antibacterial', 500.00, 15.00),
(29, 44, 'Anti-Dandruff', 200.00, 0.00),
(30, 44, 'Moisturizing', 200.00, 0.00),
(31, 44, 'Strengthening', 200.00, 5.00),
(32, 48, 'Original', 60.00, 0.00),
(33, 48, 'Cheese', 60.00, 2.00),
(34, 48, 'Sour Cream', 60.00, 2.00),
(35, 48, 'Barbeque', 60.00, 2.00),
(36, 14, 'Sweet', 250.00, 2.00),
(37, 15, 'Afritada', 180.00, 5.00),
(38, 28, '200ml', 200.00, 0.00),
(39, 28, '500ml', 500.00, 30.00),
(40, 28, '1000ml', 1000.00, 55.00),
(41, 11, 'Original', 20.00, 0.00),
(42, 11, 'Strong', 20.00, 0.50),
(43, 11, 'Decaf', 20.00, 1.00),
(44, 11, 'Brown', 20.00, 0.50),
(45, 37, 'Chilimansi', 55.00, 1.00),
(46, 32, 'Mango', 1500.00, 5.00),
(47, 32, 'Rocky Road', 1500.00, 15.00),
(48, 44, 'Silky Smooth', 200.00, 5.00),
(49, 39, 'Regular', 500.00, 0.00),
(50, 39, 'Antibacterial', 500.00, 15.00),
(51, 39, 'Color Guard', 500.00, 10.00),
(52, 39, 'Floral Fresh', 500.00, 5.00),
(53, 7, '350ml', 350.00, 0.00),
(54, 7, '750ml', 750.00, 35.00),
(55, 7, '1L', 1000.00, 55.00),
(56, 7, '2L', 2000.00, 95.00),
(57, 21, 'Regular', 330.00, 0.00),
(58, 21, 'Hot', 330.00, 3.00),
(59, 21, 'Sweet', 330.00, 3.00),
(60, 22, 'Regular', 350.00, 0.00),
(61, 22, 'Lite', 350.00, 5.00),
(62, 22, 'Seasoning', 200.00, 3.00),
(63, 80, 'Regular', 500.00, 0.00),
(64, 80, 'Jumbo', 500.00, 20.00),
(65, 80, 'Cheese-filled', 500.00, 25.00),
(66, 80, 'Cocktail', 500.00, 0.00),
(67, 68, 'Sweet', 500.00, 0.00),
(68, 68, 'Garlicky', 500.00, 5.00),
(69, 68, 'Hamonado', 500.00, 8.00),
(70, 43, 'Regular', 100.00, 0.00),
(71, 43, 'Whitening', 100.00, 5.00),
(72, 43, 'Herbal', 100.00, 5.00),
(73, 43, 'Kids', 75.00, 3.00),
(74, 43, 'Sensitive', 100.00, 8.00),
(75, 67, '150g', 150.00, 0.00),
(76, 67, '300g', 300.00, 45.00),
(77, 67, '900g', 900.00, 145.00),
(78, 49, 'Original', 60.00, 0.00),
(79, 49, 'BBQ', 60.00, 2.00),
(80, 49, 'Sour Cream', 60.00, 2.00),
(81, 49, 'Cheese', 60.00, 2.00),
(82, 38, 'Instant Plain', 400.00, 0.00),
(83, 38, 'Chocolate Flavor', 400.00, 5.00),
(84, 38, 'Honey and Oats', 400.00, 8.00),
(85, 10, 'Orange', 250.00, 0.00),
(86, 10, 'Mango', 250.00, 0.00),
(87, 10, 'Grape', 250.00, 0.00),
(88, 10, 'Pineapple', 250.00, 0.00),
(89, 10, 'Four Seasons', 250.00, 2.00),
(90, 45, 'White', 135.00, 0.00),
(91, 45, 'Green', 135.00, 0.00),
(92, 45, 'Antibacterial', 135.00, 5.00),
(93, 45, 'Moisturizing', 135.00, 5.00),
(94, 16, 'Regular', 175.00, 0.00),
(95, 16, 'Spicy', 175.00, 5.00),
(96, 16, 'Garlic', 175.00, 5.00),
(97, 16, 'Lite', 175.00, 5.00);

-- --------------------------------------------------------

--
-- Table structure for table `purchases`
--

CREATE TABLE `purchases` (
  `purchase_id` int(11) NOT NULL,
  `supplier_id` int(11) NOT NULL,
  `received_date` date DEFAULT curdate()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `purchases`
--

INSERT INTO `purchases` (`purchase_id`, `supplier_id`, `received_date`) VALUES
(1, 1, '2026-01-10'),
(2, 4, '2026-03-01'),
(3, 6, '2026-01-05'),
(4, 3, '2025-10-10'),
(5, 3, '2026-01-01'),
(6, 5, '2026-04-01'),
(7, 5, '2026-01-20'),
(8, 10, '2026-01-15'),
(9, 9, '2026-02-01'),
(10, 3, '2026-01-01'),
(11, 1, '2025-01-20'),
(12, 8, '2026-02-15');

-- --------------------------------------------------------

--
-- Table structure for table `purchase_items`
--

CREATE TABLE `purchase_items` (
  `purchase_item_id` int(11) NOT NULL,
  `purchase_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `variant_id` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `cost_price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `purchase_items`
--

INSERT INTO `purchase_items` (`purchase_item_id`, `purchase_id`, `product_id`, `variant_id`, `quantity`, `cost_price`) VALUES
(1, 1, 13, 1, 100, 28.00),
(2, 2, 15, 8, 150, 33.00),
(3, 3, 37, 18, 300, 10.00),
(4, 4, 16, NULL, 50, 60.00),
(5, 5, 35, NULL, 600, 42.00),
(6, 6, 32, 23, 30, 95.00),
(7, 7, 26, NULL, 120, 16.00),
(8, 8, 43, NULL, 60, 40.00),
(9, 9, 39, 26, 50, 95.00),
(10, 10, 8, NULL, 150, 13.00),
(11, 11, 18, NULL, 90, 28.00),
(12, 12, 47, NULL, 70, 22.00);

-- --------------------------------------------------------

--
-- Table structure for table `sales`
--

CREATE TABLE `sales` (
  `sale_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `sale_date` datetime DEFAULT current_timestamp(),
  `total_amount` decimal(10,2) NOT NULL,
  `cash_received` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sales`
--

INSERT INTO `sales` (`sale_id`, `user_id`, `sale_date`, `total_amount`, `cash_received`) VALUES
(1, 5, '2025-04-01 09:15:00', 155.00, 200.00),
(2, 5, '2025-04-01 11:30:00', 320.50, 350.00),
(3, 6, '2025-04-02 10:00:00', 89.00, 100.00),
(4, 6, '2025-04-02 14:20:00', 212.00, 250.00),
(5, 5, '2025-04-03 09:45:00', 560.00, 600.00),
(6, 5, '2025-04-03 13:00:00', 75.00, 100.00),
(7, 6, '2025-04-04 10:30:00', 430.00, 500.00),
(8, 6, '2025-04-05 15:00:00', 198.50, 200.00),
(9, 5, '2025-04-05 08:50:00', 67.00, 100.00),
(10, 5, '2025-04-06 11:00:00', 310.00, 350.00),
(11, 6, '2025-04-07 09:20:00', 145.00, 150.00),
(12, 6, '2025-04-08 14:45:00', 870.00, 900.00),
(13, 5, '2025-04-09 10:10:00', 240.00, 250.00),
(14, 5, '2025-04-10 13:30:00', 385.00, 400.00),
(15, 6, '2025-04-10 16:00:00', 510.00, 550.00),
(16, 5, '2025-04-11 09:00:00', 278.00, 300.00),
(17, 6, '2025-04-12 10:45:00', 432.00, 450.00),
(18, 5, '2025-04-13 14:00:00', 189.50, 200.00),
(19, 6, '2025-04-14 11:30:00', 655.00, 700.00),
(20, 5, '2025-04-15 15:20:00', 312.00, 350.00),
(21, 1, '2026-04-13 15:33:26', 55.00, 100.00),
(23, 5, '2026-04-14 09:14:30', 60.00, 65.00),
(24, 1, '2026-04-15 03:24:34', 88.00, 100.00),
(25, 1, '2026-04-15 03:24:59', 14.00, 15.00),
(28, 1, '2026-04-15 03:27:09', 47.00, 50.00),
(30, 1, '2026-04-15 03:30:19', 14.00, 15.00),
(35, 5, '2026-04-15 03:36:44', 35.00, 50.00);

-- --------------------------------------------------------

--
-- Table structure for table `sale_items`
--

CREATE TABLE `sale_items` (
  `sale_item_id` int(11) NOT NULL,
  `sale_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `variant_id` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `unit_price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sale_items`
--

INSERT INTO `sale_items` (`sale_item_id`, `sale_id`, `product_id`, `variant_id`, `quantity`, `unit_price`) VALUES
(1, 1, 13, 1, 2, 40.00),
(2, 1, 37, 18, 5, 14.00),
(3, 1, 22, NULL, 3, 22.00),
(4, 2, 15, 8, 3, 42.00),
(5, 2, 16, NULL, 2, 79.00),
(6, 2, 26, NULL, 3, 22.00),
(7, 3, 17, NULL, 1, 89.00),
(8, 4, 28, 12, 2, 65.00),
(9, 4, 47, NULL, 2, 32.00),
(10, 5, 32, 23, 2, 120.00),
(11, 5, 35, NULL, 5, 55.00),
(12, 5, 29, NULL, 1, 95.00),
(13, 6, 14, 5, 1, 28.50),
(14, 6, 23, NULL, 1, 18.00),
(15, 7, 8, NULL, 5, 18.00),
(16, 7, 9, NULL, 5, 12.00),
(17, 7, 21, NULL, 4, 38.00),
(18, 8, 13, 2, 3, 35.00),
(19, 8, 37, 19, 5, 14.00),
(20, 9, 48, 32, 1, 28.00),
(21, 9, 10, NULL, 1, 15.00),
(22, 10, 15, 10, 4, 42.00),
(23, 10, 27, NULL, 2, 29.00),
(24, 11, 26, NULL, 3, 22.00),
(25, 11, 22, NULL, 2, 22.00),
(26, 12, 16, NULL, 5, 79.00),
(27, 12, 17, NULL, 3, 89.00),
(28, 12, 32, 24, 2, 130.00),
(29, 13, 28, 13, 2, 95.00),
(30, 13, 35, NULL, 1, 55.00),
(31, 14, 43, NULL, 2, 55.00),
(32, 14, 45, NULL, 3, 35.00),
(33, 15, 37, 18, 8, 14.00),
(34, 15, 9, NULL, 10, 12.00),
(35, 16, 18, NULL, 4, 22.00),
(36, 16, 38, NULL, 2, 75.00),
(37, 17, 32, 23, 3, 120.00),
(38, 17, 33, NULL, 2, 95.00),
(39, 18, 11, 15, 6, 8.50),
(40, 18, 47, NULL, 3, 32.00),
(41, 19, 16, NULL, 4, 79.00),
(42, 19, 29, NULL, 2, 95.00),
(43, 19, 44, 29, 1, 95.00),
(44, 20, 35, NULL, 3, 55.00),
(45, 20, 21, NULL, 2, 38.00),
(46, 21, 1, NULL, 1, 55.00),
(47, 23, 51, NULL, 1, 25.00),
(48, 23, 3, NULL, 1, 35.00),
(49, 24, 16, 96, 1, 88.00),
(50, 25, 37, 20, 1, 14.00),
(51, 28, 48, 35, 1, 47.00),
(52, 30, 37, 19, 1, 14.00),
(53, 35, 55, NULL, 1, 35.00);

-- --------------------------------------------------------

--
-- Table structure for table `stock_movements`
--

CREATE TABLE `stock_movements` (
  `movement_id` int(11) NOT NULL,
  `inventory_id` int(11) DEFAULT NULL,
  `product_id` int(11) NOT NULL,
  `variant_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `type` enum('IN','OUT','ADJUSTMENT','EXPIRED') NOT NULL,
  `quantity_change` int(11) NOT NULL,
  `moved_at` datetime DEFAULT current_timestamp(),
  `remarks` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stock_movements`
--

INSERT INTO `stock_movements` (`movement_id`, `inventory_id`, `product_id`, `variant_id`, `user_id`, `type`, `quantity_change`, `moved_at`, `remarks`) VALUES
(1, 14, 13, 1, 3, 'IN', 50, '2026-04-13 15:02:33', 'Initial delivery BATCH-2025-014'),
(2, 17, 15, 8, 3, 'IN', 80, '2026-04-13 15:02:33', 'Initial delivery BATCH-2025-017'),
(3, 42, 37, 18, 3, 'IN', 200, '2026-04-13 15:02:33', 'Initial delivery BATCH-2025-042'),
(4, 36, 32, 23, 3, 'IN', 15, '2026-04-13 15:02:33', 'Initial delivery BATCH-2025-036'),
(5, 40, 35, NULL, 3, 'IN', 500, '2026-04-13 15:02:33', 'Initial delivery BATCH-2025-040'),
(6, 14, 13, 1, 5, 'OUT', 2, '2026-04-13 15:02:33', 'Sale ID 1'),
(7, 42, 37, 18, 5, 'OUT', 5, '2026-04-13 15:02:33', 'Sale ID 1'),
(8, 17, 15, 8, 5, 'OUT', 3, '2026-04-13 15:02:33', 'Sale ID 2'),
(9, 31, 28, 12, 5, 'OUT', 2, '2026-04-13 15:02:33', 'Sale ID 4'),
(10, 36, 32, 23, 5, 'OUT', 2, '2026-04-13 15:02:33', 'Sale ID 5'),
(11, 31, 28, 12, 3, 'EXPIRED', 5, '2026-04-13 15:02:33', 'Expired batch removed from shelf'),
(12, NULL, 1, NULL, 3, 'EXPIRED', 10, '2026-04-13 15:02:33', 'Bread batch past expiry date'),
(13, NULL, 16, NULL, 3, 'ADJUSTMENT', 10, '2026-04-13 15:02:33', 'Stock count correction after audit'),
(14, 43, 37, 19, 3, 'IN', 100, '2026-04-13 15:02:33', 'Restock delivery for Beef noodles'),
(15, 37, 32, 24, 3, 'IN', 20, '2026-04-13 15:02:33', 'Restock delivery Ice Cream Vanilla'),
(16, NULL, 1, NULL, 1, 'OUT', 1, '2026-04-13 15:33:27', 'Sale ID 21'),
(52, NULL, 2, NULL, 1, 'EXPIRED', 30, '2026-04-13 16:31:25', 'BATCH-2025-002 — expired'),
(53, NULL, 1, NULL, 1, 'EXPIRED', 39, '2026-04-13 16:31:38', 'BATCH-2025-001 — expired'),
(54, NULL, 31, NULL, 1, 'EXPIRED', 200, '2026-04-13 16:31:49', 'BATCH-2025-035 — Expired'),
(55, NULL, 34, NULL, 1, 'EXPIRED', 18, '2026-04-13 16:31:49', 'BATCH-2025-039 — Expired'),
(56, NULL, 33, NULL, 1, 'EXPIRED', 25, '2026-04-13 16:31:49', 'BATCH-2025-038 — Expired'),
(57, NULL, 4, NULL, 1, 'EXPIRED', 50, '2026-04-13 16:31:49', 'BATCH-2025-004 — Expired'),
(58, NULL, 6, NULL, 1, 'EXPIRED', 30, '2026-04-13 16:31:49', 'BATCH-2025-006 — Expired'),
(59, NULL, 11, 16, 1, 'EXPIRED', 200, '2026-04-13 16:31:49', 'BATCH-2025-012 — Expired'),
(60, NULL, 11, 15, 1, 'EXPIRED', 300, '2026-04-13 16:31:49', 'BATCH-2025-011 — Expired'),
(61, NULL, 30, NULL, 1, 'EXPIRED', 35, '2026-04-13 16:31:49', 'BATCH-2025-034 — Expired'),
(62, NULL, 12, NULL, 1, 'EXPIRED', 80, '2026-04-13 16:31:49', 'BATCH-2025-013 — Expired'),
(63, NULL, 26, NULL, 1, 'EXPIRED', 100, '2026-04-13 16:31:49', 'BATCH-2025-029 — Expired'),
(64, NULL, 27, NULL, 1, 'EXPIRED', 90, '2026-04-13 16:31:49', 'BATCH-2025-030 — Expired'),
(65, 56, 28, NULL, 1, 'IN', 100, '2026-04-13 16:44:58', 'New batch BATCH-2026-790 received'),
(66, 57, 3, NULL, 1, 'IN', 100, '2026-04-13 18:13:36', 'New batch BATCH-2026-948 received'),
(67, NULL, 4, NULL, 1, 'IN', 100, '2026-04-13 18:25:21', 'New batch BATCH-2026-767 received'),
(72, NULL, 4, NULL, 1, 'EXPIRED', 100, '2026-04-13 19:09:49', 'BATCH-2026-767 — Expired'),
(73, 59, 51, NULL, 1, 'IN', 300, '2026-04-14 09:09:21', 'New batch BATCH-2026-295 received'),
(74, 60, 53, NULL, 1, 'IN', 300, '2026-04-14 09:11:47', 'New batch BATCH-2026-209 received'),
(75, 59, 51, NULL, 5, 'OUT', 1, '2026-04-14 09:14:30', 'Sale ID 23'),
(76, 57, 3, NULL, 5, 'OUT', 1, '2026-04-14 09:14:30', 'Sale ID 23'),
(77, 109, 37, 18, 1, 'IN', 100, '2026-04-14 11:53:20', 'New batch BATCH-2026-593 received'),
(78, 110, 37, 19, 1, 'IN', 100, '2026-04-14 11:53:55', 'New batch BATCH-2026-033 received'),
(79, 19, 16, 96, 1, 'OUT', 1, '2026-04-15 03:24:34', 'Sale ID 24'),
(80, 110, 37, 20, 1, 'OUT', 1, '2026-04-15 03:24:59', 'Sale ID 25'),
(81, 54, 48, 35, 1, 'OUT', 1, '2026-04-15 03:27:09', 'Sale ID 28'),
(82, 110, 37, 19, 1, 'OUT', 1, '2026-04-15 03:30:19', 'Sale ID 30'),
(83, 63, 55, NULL, 5, 'OUT', 1, '2026-04-15 03:36:44', 'Sale ID 35');

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE `suppliers` (
  `supplier_id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL,
  `contact_person` varchar(100) DEFAULT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `suppliers`
--

INSERT INTO `suppliers` (`supplier_id`, `name`, `contact_person`, `phone`, `address`, `email`) VALUES
(1, 'Del Monte Philippines', 'Purchasing Dept', '02-8888-1234', 'Bugo, Cagayan de Oro', 'supply@delmonte.ph'),
(2, 'Nestle Philippines', 'Purchasing Dept', '02-8888-5678', 'Makati City', 'supply@nestle.ph'),
(3, 'San Miguel Corp', 'Purchasing Dept', '02-8632-3000', 'Mandaluyong City', 'supply@sanmiguel.ph'),
(4, 'Century Pacific', 'Purchasing Dept', '02-8559-3200', 'Pasig City', 'supply@centurypacific.ph'),
(5, 'Magnolia Inc.', 'Purchasing Dept', '02-8818-0000', 'Quezon City', 'supply@magnolia.ph'),
(6, 'Lucky Me Monde Nissin', 'Purchasing Dept', '02-8654-8888', 'Valenzuela City', 'supply@mondenissin.ph'),
(7, 'NutriAsia Inc.', 'Purchasing Dept', '02-8779-0000', 'Marikina City', 'supply@nutriasia.ph'),
(8, 'Rebisco Corp', 'Purchasing Dept', '02-8941-4567', 'Pasig City', 'supply@rebisco.ph'),
(9, 'Procter and Gamble PH', 'Purchasing Dept', '02-8982-1000', 'BGC, Taguig City', 'supply@pg.com.ph'),
(10, 'Colgate-Palmolive PH', 'Purchasing Dept', '02-8896-6000', 'Dela Rosa St, Makati', 'supply@colgate.com.ph'),
(11, 'Century Pacific Food Inc.', 'Purchasing Dept', '02-8559-3200', 'Pasig City', 'supply@centurypacific.ph'),
(12, 'Alaska Milk Corporation', 'Purchasing Dept', '02-8810-0000', 'Fort Bonifacio, Taguig City', 'supply@alaskamilk.com.ph'),
(13, 'CDO Foodsphere Inc.', 'Purchasing Dept', '02-8941-1111', 'Caloocan City', 'supply@cdofoodsphere.com.ph'),
(14, 'San Miguel Pure Foods', 'Purchasing Dept', '02-8632-5000', 'Mandaluyong City', 'supply@smpurefoods.com.ph'),
(15, 'Universal Robina Corporation', 'Purchasing Dept', '02-8633-7631', 'Pasig City', 'supply@urc.com.ph'),
(16, 'Oishi Philippines', 'Purchasing Dept', '02-8655-2222', 'Valenzuela City', 'supply@oishi.com.ph'),
(17, 'Jack n Jill Snack Foods', 'Purchasing Dept', '02-8633-7000', 'Pasig City', 'supply@jacknJill.com.ph'),
(18, 'Goya Inc.', 'Purchasing Dept', '02-8711-3456', 'Quezon City', 'supply@goya.com.ph'),
(19, 'Maya Kitchen', 'Purchasing Dept', '02-8892-5011', 'Makati City', 'supply@mayakitchen.com'),
(20, 'NutriAsia – Datu Puti Div.', 'Purchasing Dept', '02-8779-0100', 'Marikina City', 'supply@datuputi.com.ph'),
(21, 'Regent Food Corporation', 'Purchasing Dept', '02-8655-8888', 'Malabon City', 'supply@regent.com.ph');

-- --------------------------------------------------------

--
-- Table structure for table `user_account`
--

CREATE TABLE `user_account` (
  `user_id` int(11) NOT NULL,
  `employee_id` int(11) NOT NULL,
  `username` varchar(80) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('cashier','stock_manager','admin') NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_account`
--

INSERT INTO `user_account` (`user_id`, `employee_id`, `username`, `password_hash`, `role`, `created_at`) VALUES
(1, 1, 'administrator01', '$2y$12$0BQ4W8AHB1FbfHS0eUmqy.8v0M1qJwntiL9l9R.LbH/G4uXM4WB9.', 'admin', '2026-04-13 15:02:33'),
(2, 2, 'administrator02', '$2y$12$wZ15s.4aXE0MocwmPIZUyer.9ZAlHtrZKwVZzucFoQMz7KEqssKF.', 'admin', '2026-04-13 15:02:33'),
(3, 3, 'stock_manager01', '$2y$12$WmCS.Br08mJXRqhn1XoAcOmXOvSg0EH/wi.b3NfbI5owMFuUeVR82', 'stock_manager', '2026-04-13 15:02:33'),
(4, 4, 'stock_manager02', '$2y$12$bj0ENAnIf8GpwvUhoaUFAOFnexdPODRnNxNQ/EZqB.sooFBqClloS', 'stock_manager', '2026-04-13 15:02:33'),
(5, 5, 'cashier01', '$2y$12$dvE2/VVIgtOdpfZjHDU/Kuqe4yTjL.NIK7Txa/GqDG6y3cMK1t2X.', 'cashier', '2026-04-13 15:02:33'),
(6, 6, 'cashier02', '$2y$12$qO51m0twpJ4/wCmDUDxl7.8L20aanJy2W5OxVGjMLm2cpi7BHuyRm', 'cashier', '2026-04-13 15:02:33');

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_expiry_monitor`
-- (See below for the actual view)
--
CREATE TABLE `vw_expiry_monitor` (
`product_name` varchar(150)
,`variant_name` varchar(100)
,`batch_number` varchar(50)
,`current_stock` int(11)
,`expiration_date` date
,`days_left` int(7)
,`supplier` varchar(150)
,`supplier_contact` varchar(100)
,`supplier_phone` varchar(30)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_inventory_status`
-- (See below for the actual view)
--
CREATE TABLE `vw_inventory_status` (
`sku_code` varchar(50)
,`product_name` varchar(150)
,`category` varchar(100)
,`variant_name` varchar(100)
,`batch_number` varchar(50)
,`current_stock` int(11)
,`reorder_level` int(11)
,`delivery_date` date
,`expiration_date` date
,`days_until_expiry` int(7)
,`expiry_status` varchar(13)
,`stock_status` varchar(12)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_restock_suggestions`
-- (See below for the actual view)
--
CREATE TABLE `vw_restock_suggestions` (
`product_name` varchar(150)
,`avg_monthly_sold` decimal(33,0)
,`suggested_order_qty` decimal(34,0)
,`supplier` varchar(150)
,`supplier_contact` varchar(100)
,`supplier_phone` varchar(30)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_sales_summary`
-- (See below for the actual view)
--
CREATE TABLE `vw_sales_summary` (
`category` varchar(100)
,`items_sold` bigint(21)
,`units_sold` decimal(32,0)
,`total_revenue` decimal(42,2)
);

-- --------------------------------------------------------

--
-- Structure for view `vw_expiry_monitor`
--
DROP TABLE IF EXISTS `vw_expiry_monitor`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_expiry_monitor`  AS SELECT `p`.`name` AS `product_name`, `pv`.`variant_name` AS `variant_name`, `i`.`batch_number` AS `batch_number`, `i`.`current_stock` AS `current_stock`, `i`.`expiration_date` AS `expiration_date`, to_days(`i`.`expiration_date`) - to_days(curdate()) AS `days_left`, `s`.`name` AS `supplier`, `s`.`contact_person` AS `supplier_contact`, `s`.`phone` AS `supplier_phone` FROM (((`inventory` `i` join `products` `p` on(`i`.`product_id` = `p`.`product_id`)) join `suppliers` `s` on(`p`.`supplier_id` = `s`.`supplier_id`)) left join `product_variants` `pv` on(`i`.`variant_id` = `pv`.`variant_id`)) WHERE `i`.`expiration_date` <= curdate() + interval 90 day ORDER BY `i`.`expiration_date` ASC ;

-- --------------------------------------------------------

--
-- Structure for view `vw_inventory_status`
--
DROP TABLE IF EXISTS `vw_inventory_status`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_inventory_status`  AS SELECT `p`.`sku_code` AS `sku_code`, `p`.`name` AS `product_name`, `c`.`name` AS `category`, `pv`.`variant_name` AS `variant_name`, `i`.`batch_number` AS `batch_number`, `i`.`current_stock` AS `current_stock`, `p`.`reorder_level` AS `reorder_level`, `i`.`delivery_date` AS `delivery_date`, `i`.`expiration_date` AS `expiration_date`, to_days(`i`.`expiration_date`) - to_days(curdate()) AS `days_until_expiry`, CASE WHEN `i`.`expiration_date` < curdate() THEN 'Expired' WHEN `i`.`expiration_date` < curdate() + interval 30 day THEN 'Expiring Soon' WHEN `i`.`expiration_date` < curdate() + interval 90 day THEN 'Near Expiry' ELSE 'Good' END AS `expiry_status`, CASE WHEN `i`.`current_stock` = 0 THEN 'Out of Stock' WHEN `i`.`current_stock` <= `p`.`reorder_level` THEN 'Reorder Now' WHEN `i`.`current_stock` <= `p`.`reorder_level` * 1.5 THEN 'Low Stock' ELSE 'Sufficient' END AS `stock_status` FROM (((`inventory` `i` join `products` `p` on(`i`.`product_id` = `p`.`product_id`)) join `categories` `c` on(`p`.`category_id` = `c`.`category_id`)) left join `product_variants` `pv` on(`i`.`variant_id` = `pv`.`variant_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `vw_restock_suggestions`
--
DROP TABLE IF EXISTS `vw_restock_suggestions`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_restock_suggestions`  AS SELECT `p`.`name` AS `product_name`, round(sum(`si`.`quantity`) / count(distinct date_format(`s`.`sale_date`,'%Y-%m')),0) AS `avg_monthly_sold`, round(sum(`si`.`quantity`) / count(distinct date_format(`s`.`sale_date`,'%Y-%m')),0) * 2 AS `suggested_order_qty`, `sup`.`name` AS `supplier`, `sup`.`contact_person` AS `supplier_contact`, `sup`.`phone` AS `supplier_phone` FROM (((`sale_items` `si` join `sales` `s` on(`si`.`sale_id` = `s`.`sale_id`)) join `products` `p` on(`si`.`product_id` = `p`.`product_id`)) join `suppliers` `sup` on(`p`.`supplier_id` = `sup`.`supplier_id`)) GROUP BY `p`.`product_id`, `p`.`name`, `sup`.`name`, `sup`.`contact_person`, `sup`.`phone` ORDER BY round(sum(`si`.`quantity`) / count(distinct date_format(`s`.`sale_date`,'%Y-%m')),0) DESC ;

-- --------------------------------------------------------

--
-- Structure for view `vw_sales_summary`
--
DROP TABLE IF EXISTS `vw_sales_summary`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_sales_summary`  AS SELECT `c`.`name` AS `category`, count(`si`.`sale_item_id`) AS `items_sold`, sum(`si`.`quantity`) AS `units_sold`, round(sum(`si`.`quantity` * `si`.`unit_price`),2) AS `total_revenue` FROM ((`sale_items` `si` join `products` `p` on(`si`.`product_id` = `p`.`product_id`)) join `categories` `c` on(`p`.`category_id` = `c`.`category_id`)) GROUP BY `c`.`category_id`, `c`.`name` ORDER BY round(sum(`si`.`quantity` * `si`.`unit_price`),2) DESC ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `brands`
--
ALTER TABLE `brands`
  ADD PRIMARY KEY (`brand_id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`employee_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `inventory`
--
ALTER TABLE `inventory`
  ADD PRIMARY KEY (`inventory_id`),
  ADD KEY `fk_inv_purchase` (`purchase_item_id`),
  ADD KEY `fk_inv_product` (`product_id`),
  ADD KEY `fk_inv_variant` (`variant_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD UNIQUE KEY `sku_code` (`sku_code`),
  ADD KEY `fk_prod_category` (`category_id`),
  ADD KEY `fk_prod_brand` (`brand_id`),
  ADD KEY `fk_prod_supplier` (`supplier_id`);

--
-- Indexes for table `product_variants`
--
ALTER TABLE `product_variants`
  ADD PRIMARY KEY (`variant_id`),
  ADD KEY `fk_variant_product` (`product_id`);

--
-- Indexes for table `purchases`
--
ALTER TABLE `purchases`
  ADD PRIMARY KEY (`purchase_id`),
  ADD KEY `fk_pur_supplier` (`supplier_id`);

--
-- Indexes for table `purchase_items`
--
ALTER TABLE `purchase_items`
  ADD PRIMARY KEY (`purchase_item_id`),
  ADD KEY `fk_pi_purchase` (`purchase_id`),
  ADD KEY `fk_pi_product` (`product_id`),
  ADD KEY `fk_pi_variant` (`variant_id`);

--
-- Indexes for table `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`sale_id`),
  ADD KEY `fk_sales_user` (`user_id`);

--
-- Indexes for table `sale_items`
--
ALTER TABLE `sale_items`
  ADD PRIMARY KEY (`sale_item_id`),
  ADD KEY `fk_si_sale` (`sale_id`),
  ADD KEY `fk_si_product` (`product_id`),
  ADD KEY `fk_si_variant` (`variant_id`);

--
-- Indexes for table `stock_movements`
--
ALTER TABLE `stock_movements`
  ADD PRIMARY KEY (`movement_id`),
  ADD KEY `fk_sm_product` (`product_id`),
  ADD KEY `fk_sm_user` (`user_id`),
  ADD KEY `fk_sm_inventory` (`inventory_id`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`supplier_id`);

--
-- Indexes for table `user_account`
--
ALTER TABLE `user_account`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `fk_user_employee` (`employee_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `brands`
--
ALTER TABLE `brands`
  MODIFY `brand_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `employees`
--
ALTER TABLE `employees`
  MODIFY `employee_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `inventory`
--
ALTER TABLE `inventory`
  MODIFY `inventory_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=111;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=102;

--
-- AUTO_INCREMENT for table `product_variants`
--
ALTER TABLE `product_variants`
  MODIFY `variant_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=98;

--
-- AUTO_INCREMENT for table `purchases`
--
ALTER TABLE `purchases`
  MODIFY `purchase_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `purchase_items`
--
ALTER TABLE `purchase_items`
  MODIFY `purchase_item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `sales`
--
ALTER TABLE `sales`
  MODIFY `sale_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `sale_items`
--
ALTER TABLE `sale_items`
  MODIFY `sale_item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT for table `stock_movements`
--
ALTER TABLE `stock_movements`
  MODIFY `movement_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=84;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `supplier_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `user_account`
--
ALTER TABLE `user_account`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `inventory`
--
ALTER TABLE `inventory`
  ADD CONSTRAINT `fk_inv_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`),
  ADD CONSTRAINT `fk_inv_purchase` FOREIGN KEY (`purchase_item_id`) REFERENCES `purchase_items` (`purchase_item_id`),
  ADD CONSTRAINT `fk_inv_variant` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`variant_id`);

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `fk_prod_brand` FOREIGN KEY (`brand_id`) REFERENCES `brands` (`brand_id`),
  ADD CONSTRAINT `fk_prod_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`),
  ADD CONSTRAINT `fk_prod_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`supplier_id`);

--
-- Constraints for table `product_variants`
--
ALTER TABLE `product_variants`
  ADD CONSTRAINT `fk_variant_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`);

--
-- Constraints for table `purchases`
--
ALTER TABLE `purchases`
  ADD CONSTRAINT `fk_pur_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`supplier_id`);

--
-- Constraints for table `purchase_items`
--
ALTER TABLE `purchase_items`
  ADD CONSTRAINT `fk_pi_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`),
  ADD CONSTRAINT `fk_pi_purchase` FOREIGN KEY (`purchase_id`) REFERENCES `purchases` (`purchase_id`),
  ADD CONSTRAINT `fk_pi_variant` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`variant_id`);

--
-- Constraints for table `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `fk_sales_user` FOREIGN KEY (`user_id`) REFERENCES `user_account` (`user_id`);

--
-- Constraints for table `sale_items`
--
ALTER TABLE `sale_items`
  ADD CONSTRAINT `fk_si_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`),
  ADD CONSTRAINT `fk_si_sale` FOREIGN KEY (`sale_id`) REFERENCES `sales` (`sale_id`),
  ADD CONSTRAINT `fk_si_variant` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`variant_id`);

--
-- Constraints for table `stock_movements`
--
ALTER TABLE `stock_movements`
  ADD CONSTRAINT `fk_sm_inventory` FOREIGN KEY (`inventory_id`) REFERENCES `inventory` (`inventory_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_sm_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`),
  ADD CONSTRAINT `fk_sm_user` FOREIGN KEY (`user_id`) REFERENCES `user_account` (`user_id`);

--
-- Constraints for table `user_account`
--
ALTER TABLE `user_account`
  ADD CONSTRAINT `fk_user_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
