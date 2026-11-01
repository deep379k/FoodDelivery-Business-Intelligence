CREATE DATABASE foodflow_analytics;

USE foodflow_analytics;

SELECT DATABASE();

CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    order_date DATE,
    order_time TIME,
    platform VARCHAR(20),
    customer_id VARCHAR(20),
    restaurant_id VARCHAR(20),
    rider_id VARCHAR(20),
    order_status VARCHAR(30),
    payment_method VARCHAR(30),
    item_count INT,
    subtotal DECIMAL(10,2),
    discount DECIMAL(10,2),
    delivery_fee DECIMAL(10,2),
    packaging_fee DECIMAL(10,2),
    tax DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    promised_delivery_minutes INT
);

SHOW TABLES; 

DESCRIBE orders;

