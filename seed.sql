USE newappec;

-- Clear existing product-related seed data
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE addtocart;
TRUNCATE TABLE user_address;
TRUNCATE TABLE address;
TRUNCATE TABLE product;
TRUNCATE TABLE product_inventory;
TRUNCATE TABLE categories;
TRUNCATE TABLE tags;
SET FOREIGN_KEY_CHECKS = 1;

-- Seed categories
INSERT INTO categories (name, slug) VALUES
('Clothing', 'clothing'),
('Electronics', 'electronics'),
('Home & Kitchen', 'home-kitchen'),
('Beauty', 'beauty'),
('Sports & Outdoors', 'sports-outdoors');

-- Seed tags
INSERT INTO tags (name, slug) VALUES
('New Arrival', 'new-arrival'),
('Sale', 'sale'),
('Featured', 'featured'),
('Eco-Friendly', 'eco-friendly'),
('Premium', 'premium'),
('Trending', 'trending'),
('Best Seller', 'best-seller'),
('Limited Edition', 'limited-edition');

-- Seed inventory entries
INSERT INTO product_inventory (quantity) VALUES
(120),
(75),
(200),
(40),
(68),
(90),
(150),
(22),
(310),
(50),
(130),
(5),
(18),
(220),
(84),
(10),
(140),
(60),
(35),
(98);

-- Seed products
INSERT INTO product (name, price, description, image, feature1, feature2, feature3, feature4, feature5, tag_id, category_id, inventory_id) VALUES
('Men''s Classic T-Shirt', 299.99, 'Soft cotton t-shirt in a timeless fit for everyday wear.', '/products/product-01.jpg', '100% cotton', 'Breathable fabric', 'Regular fit', 'Machine washable', 'Available in 5 colors', 1, 1, 1),
('Women''s Denim Jacket', 1599.99, 'Stylish denim jacket with a flattering fit and durable stitching.', '/products/product-02.jpg', 'Premium denim', 'Button front', 'Chest pockets', 'Soft lining', 'All-season wear', 3, 1, 2),
('Bluetooth Wireless Earbuds', 2499.00, 'True wireless earbuds with deep bass and long battery life.', '/products/product-03.jpg', 'Noise isolation', 'Bluetooth 5.2', '24h playback', 'Fast charge', 'Ergonomic fit', 2, 2, 3),
('Smart Home Speaker', 3499.50, 'Voice-controlled smart speaker with immersive sound quality.', '/products/product-04.jpg', 'Voice assistant', 'Multi-room audio', 'Wi-Fi enabled', 'Compact design', 'Touch controls', 5, 2, 4),
('Ceramic Dinner Set', 2699.90, '12-piece ceramic dinner set with modern finish and chip resistance.', '/products/product-05.jpg', 'Microwave safe', 'Dishwasher safe', 'Scratch resistant', 'Gloss finish', 'Set for 4', 3, 3, 5),
('LED Desk Lamp', 799.99, 'Adjustable LED desk lamp with dimmable brightness and USB charging.', '/products/product-06.jpg', 'Touch controls', 'Eye-care lighting', 'Flexible arm', 'USB charging port', 'Energy efficient', 4, 3, 6),
('Aloe Vera Face Cream', 549.00, 'Hydrating face cream enriched with aloe vera for smooth skin.', '/products/product-07.jpg', 'Deep hydration', 'Non-greasy', 'Dermatologist tested', 'Suitable for all skin types', 'Fast absorption', 1, 4, 7),
('Vitamin C Serum', 799.00, 'Brightening serum with antioxidants for radiant skin.', '/products/product-08.jpg', 'Antioxidant-rich', 'Lightweight formula', 'Reduces dark spots', 'Vegan friendly', 'Pore refining', 6, 4, 8),
('Yoga Mat', 1299.00, 'Non-slip yoga mat with extra cushioning for home workouts.', '/products/product-09.jpg', 'Eco-friendly material', 'Extra padding', 'Lightweight', 'Sweat resistant', 'Portable strap', 4, 5, 9),
('Stainless Steel Water Bottle', 699.00, 'Insulated bottle keeps drinks cold for 24 hours and hot for 12 hours.', '/products/product-10.jpg', 'Double wall', 'Leakproof lid', 'BPA-free', 'Easy carry handle', 'Fits most cup holders', 7, 5, 10),
('Wireless Charging Pad', 1199.00, 'Fast wireless charger compatible with Qi-enabled phones.', '/products/product-11.jpg', 'Fast charge', 'LED indicator', 'Slim profile', 'Non-slip surface', 'Case friendly', 2, 2, 11),
('Noise Cancelling Headphones', 4999.00, 'Over-ear headphones with active noise cancellation and rich sound.', '/products/product-12.jpg', 'Active noise canceling', 'Bluetooth pairing', 'Comfort earcups', 'Long battery life', 'Foldable design', 5, 2, 12),
('Bamboo Cutting Board', 899.00, 'Durable bamboo cutting board with juice groove and non-slip feet.', '/products/product-13.jpg', 'Eco-friendly bamboo', 'Juice groove', 'Non-slip feet', 'Knife friendly', 'Easy clean', 4, 3, 13),
('Memory Foam Pillow', 1899.99, 'Cooling memory foam pillow for restful sleep and neck support.', '/products/product-14.jpg', 'Cooling gel', 'Ergonomic shape', 'Hypoallergenic', 'Removable cover', 'Pressure relief', 6, 3, 14),
('Running Shoes', 3299.00, 'Lightweight running shoes with responsive cushioning and traction.', '/products/product-15.jpg', 'Breathable mesh', 'Cushioned sole', 'Supportive fit', 'Durable outsole', 'Flexible design', 8, 5, 15),
('Women''s Sports Leggings', 1899.00, 'High-waist leggings with moisture-wicking fabric for intense workouts.', '/products/product-16.jpg', 'Moisture wicking', '4-way stretch', 'High waist', 'Quick dry', 'Soft waistband', 1, 5, 16),
('Portable Blender', 2199.00, 'Rechargeable blender for smoothies and shakes on the go.', '/products/product-17.jpg', 'USB rechargeable', 'Detachable cup', 'Easy cleaning', 'Compact size', 'Powerful motor', 3, 3, 17),
('Fragrance Gift Set', 2699.99, 'Premium fragrance gift set with long-lasting scents.', '/products/product-18.jpg', 'Luxury packaging', 'Long-lasting', 'Elegant scent', 'Gift ready', 'Travel size', 8, 4, 18),
('Smartwatch', 7499.00, 'Fitness smartwatch with heart rate monitor and activity tracking.', '/products/product-19.jpg', 'Heart rate monitor', 'Sleep tracking', 'Water resistant', 'Notifications', 'Custom watch faces', 5, 2, 19),
('Outdoor Camping Lantern', 999.00, 'Rechargeable lantern with adjustable brightness for camping trips.', '/products/product-20.jpg', 'Adjustable brightness', 'Rechargeable battery', 'Lightweight', 'Durable housing', 'Hanging hook', 7, 5, 20);
