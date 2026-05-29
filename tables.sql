CREATE TABLE `tags` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `categories` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `product` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `description` text,
  `image` varchar(255) DEFAULT NULL,
  `feature1` varchar(255) DEFAULT NULL,
  `feature2` varchar(255) DEFAULT NULL,
  `feature3` varchar(255) DEFAULT NULL,
  `feature4` varchar(255) DEFAULT NULL,
  `feature5` varchar(255) DEFAULT NULL,
  `tag_id` int DEFAULT NULL,
  `category_id` int DEFAULT NULL,
  `inventory_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `users` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL UNIQUE,
  `password` VARCHAR(255) NOT NULL,
  `user_role` VARCHAR(50) NOT NULL DEFAULT 'CUSTOMER',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `product_inventory` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `quantity` INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `address` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `street_address` VARCHAR(255),
  `addressline1` VARCHAR(255),
  `addressline2` VARCHAR(255),
  `postalcode` VARCHAR(100),
  `city` VARCHAR(100),
  `state` VARCHAR(100),
  `country` VARCHAR(100),
  `userid` INT NOT NULL,
  FOREIGN KEY (`userid`) REFERENCES `users`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE `user_address` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT NOT NULL,
  `address_id` INT NOT NULL,
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
  FOREIGN KEY (`address_id`) REFERENCES `address`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
CREATE TABLE addtocart (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES product(id)
);

CREATE TABLE buynow (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    payment_id INT NOT NULL,
    quantity INT NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES product(id),
    FOREIGN KEY (payment_id) REFERENCES payment(id)
);




CREATE TABLE payment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    transaction_id VARCHAR(100) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);


