-- =====================================================
-- FOODFLOW ANALYTICS
-- FILE: 05_Create_Transaction_Tables.sql
-- PURPOSE: Create and load transaction tables
-- =====================================================

USE foodflow_analytics;


-- =====================================================
-- TABLE 1: ORDER ITEMS
-- =====================================================


DROP TABLE IF EXISTS order_items;

CREATE TABLE order_items (
    order_item_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(20),
    item_id VARCHAR(20),
    quantity INT,
    unit_price DECIMAL(10,2),
    food_cost DECIMAL(10,2),
    preparation_time INT
);

-- Load the items
LOAD DATA LOCAL INFILE 'C:/Users/hp/Documents/Downloads/Downloads/FoodFlow_Analytics_Dataset/order_items.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    item_id,
    quantity,
    unit_price,
    food_cost,
    preparation_time
);



-- =====================================================
-- TABLE 2: DELIVERY
-- =====================================================

CREATE TABLE IF NOT EXISTS delivery (
    delivery_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(20),
    rider_id VARCHAR(20),
    distance_km DECIMAL(10,2),
    traffic_level VARCHAR(20),
    weather VARCHAR(20),
    restaurant_prep_time INT,
    rider_wait_time INT,
    actual_delivery_minutes INT,
    promised_delivery_minutes INT,
    late_delivery BOOLEAN
);

-- Convert blank actual delivery and late flag values to NULL

LOAD DATA LOCAL INFILE
'C:/Users/hp/Documents/Downloads/Downloads/FoodFlow_Analytics_Dataset/delivery.csv'
INTO TABLE delivery
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    rider_id,
    distance_km,
    traffic_level,
    weather,
    restaurant_prep_time,
    rider_wait_time,
    @actual_delivery_minutes,
    @promised_delivery_minutes,
    @late_delivery
)
SET
    actual_delivery_minutes =
        NULLIF(@actual_delivery_minutes, ''),
    promised_delivery_minutes =
        NULLIF(@promised_delivery_minutes, ''),
    late_delivery =
        NULLIF(@late_delivery, '');



-- =====================================================
-- TABLE 3: CANCELLATIONS
-- =====================================================

CREATE TABLE IF NOT EXISTS cancellations (
    cancellation_id VARCHAR(20) PRIMARY KEY,
    order_id VARCHAR(20),
    cancelled_by VARCHAR(30),
    cancellation_reason VARCHAR(100),
    cancellation_stage VARCHAR(50),
    food_already_prepared BOOLEAN,
    food_waste_cost DECIMAL(10,2),
    refund_amount DECIMAL(10,2)
);

-- Convert TRUE/FALSE strings to MySQL BOOLEAN values

LOAD DATA LOCAL INFILE
'C:/Users/hp/Documents/Downloads/Downloads/FoodFlow_Analytics_Dataset/cancellations.csv'
INTO TABLE cancellations
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    cancellation_id,
    order_id,
    cancelled_by,
    cancellation_reason,
    cancellation_stage,
    @food_already_prepared,
    food_waste_cost,
    refund_amount
)
SET food_already_prepared =
    CASE LOWER(TRIM(@food_already_prepared))
        WHEN 'true' THEN 1
        WHEN 'false' THEN 0
        ELSE NULL
    END;


-- =====================================================
-- VALIDATE TRANSACTION TABLES
-- =====================================================

SELECT 'order_items' AS table_name, COUNT(*) AS total_rows
FROM order_items
UNION ALL
SELECT 'delivery', COUNT(*) FROM delivery
UNION ALL
SELECT 'cancellations', COUNT(*) FROM cancellations;


-- Check for order_items rows with unknown orders

SELECT COUNT(*) AS invalid_order_item_orders
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


-- Check for delivery rows with unknown orders

SELECT COUNT(*) AS invalid_delivery_orders
FROM delivery d
LEFT JOIN orders o
    ON d.order_id = o.order_id
WHERE o.order_id IS NULL;


-- Check for cancellation rows with unknown orders

SELECT COUNT(*) AS invalid_cancellation_orders
FROM cancellations c
LEFT JOIN orders o
    ON c.order_id = o.order_id
WHERE o.order_id IS NULL;






SELECT COUNT(*) FROM order_items;

SET GLOBAL local_infile = 1;

SHOW GLOBAL VARIABLES LIKE 'local_infile';

SHOW SESSION VARIABLES LIKE 'local_infile';