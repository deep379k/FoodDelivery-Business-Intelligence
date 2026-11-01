-- =====================================================
-- FOODFLOW ANALYTICS
-- FILE: 03_Load_Data.sql
-- PURPOSE: Load orders.csv
-- =====================================================

USE foodflow_analytics;

LOAD DATA LOCAL INFILE
'C:/Users/hp/Documents/Downloads/Downloads/FoodFlow_Analytics_Dataset/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    order_date,
    order_time,
    platform,
    customer_id,
    restaurant_id,
    rider_id,
    order_status,
    payment_method,
    item_count,
    subtotal,
    discount,
    delivery_fee,
    packaging_fee,
    tax,
    total_amount,
    promised_delivery_minutes
);

-- Validate row count
SELECT COUNT(*) AS total_orders
FROM orders;

-- Check order status distribution
SELECT
    order_status,
    COUNT(*) AS order_count
FROM orders
GROUP BY order_status;

-- Check duplicate order IDs
SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;
