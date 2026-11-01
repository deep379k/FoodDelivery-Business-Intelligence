-- Create table
USE foodflow_analytics;

CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    age_group VARCHAR(20),
    gender VARCHAR(20),
    city VARCHAR(50),
    zone VARCHAR(30),
    membership VARCHAR(20),
    customer_since DATE,
    previous_orders INT,
    previous_cancellations INT
);

-- Restaurants Table
CREATE TABLE restaurants (
    restaurant_id VARCHAR(20) PRIMARY KEY,
    restaurant_name VARCHAR(100),
    city VARCHAR(50),
    zone VARCHAR(30),
    cuisine VARCHAR(50),
    restaurant_type VARCHAR(50),
    price_category VARCHAR(20),
    restaurant_rating DECIMAL(3,2),
    avg_preparation_time INT
);

-- Riders Table
CREATE TABLE riders (
    rider_id VARCHAR(20) PRIMARY KEY,
    age INT,
    vehicle_type VARCHAR(20),
    experience_months INT,
    rating DECIMAL(3,2),
    home_zone VARCHAR(30)
);

-- Food Items Table
CREATE TABLE food_items (
    item_id VARCHAR(20) PRIMARY KEY,
    item_name VARCHAR(100),
    category VARCHAR(50),
    cuisine VARCHAR(50),
    vegetarian BOOLEAN,
    food_cost DECIMAL(10,2),
    selling_price DECIMAL(10,2),
    preparation_time INT
);

SHOW TABLES; 

SELECT COUNT(*) AS total_customers
FROM customers;
DESCRIBE customers;

-- LOAD THE CUSTOMERS DATA

USE foodflow_analytics;
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

SHOW WARNINGS;
SELECT ROW_COUNT() AS rows_loaded;

LOAD DATA LOCAL INFILE 'C:/Users/hp/Documents/Downloads/Downloads/FoodFlow_Analytics_Dataset/customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    customer_id,
    age_group,
    gender,
    city,
    zone,
    membership,
    customer_since,
    previous_orders,
    previous_cancellations
);

-- Load restaurants
USE foodflow_analytics;

LOAD DATA LOCAL INFILE 'C:/Users/hp/Documents/Downloads/Downloads/FoodFlow_Analytics_Dataset/restaurants.csv'
INTO TABLE restaurants
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
-- VERIFY
SELECT COUNT(*) AS total_restaurants
FROM restaurants;

-- Load riders
LOAD DATA LOCAL INFILE 'C:/Users/hp/Documents/Downloads/Downloads/FoodFlow_Analytics_Dataset/riders.csv'
INTO TABLE riders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- VERIFY
SELECT COUNT(*) AS total_riders
From riders;

-- LOAD FOOD_ITEMS
USE foodflow_analytics;
TRUNCATE TABLE food_items;
LOAD DATA LOCAL INFILE 'C:/Users/hp/Documents/Downloads/Downloads/FoodFlow_Analytics_Dataset/food_items.csv'
INTO TABLE food_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    item_id,
    item_name,
    category,
    cuisine,
    @vegetarian,
    food_cost,
    selling_price,
    preparation_time
)
SET vegetarian =
    CASE LOWER(@vegetarian)
        WHEN 'true' THEN 1
        WHEN 'false' THEN 0
        ELSE NULL
    END;
    
-- Row COunt
SELECT COUNT(*) AS total_food_items
FROM food_items;
SELECT
    item_id,
    item_name,
    vegetarian
FROM food_items
LIMIT 10;



-- FInalDImension
SELECT 'customers' AS table_name, COUNT(*) AS row_count
FROM customers
UNION ALL
SELECT 'restaurants', COUNT(*)
FROM restaurants
UNION ALL
SELECT 'riders', COUNT(*)
FROM riders
UNION ALL
SELECT 'food_items', COUNT(*)
FROM food_items;


SELECT * FROM orders;



