USE foodflow_analytics;

TRUNCATE TABLE delivery;

LOAD DATA LOCAL INFILE 'C:/Users/hp/Documents/Downloads/Downloads/FoodFlow_Analytics_Dataset/delivery.csv'
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
    actual_delivery_minutes = NULLIF(@actual_delivery_minutes, ''),
    promised_delivery_minutes = NULLIF(@promised_delivery_minutes, ''),
    late_delivery = NULLIF(@late_delivery, '');

SELECT COUNT(*) AS total_rows
FROM delivery;

SELECT *
FROM delivery
LIMIT 10;

SELECT
    COUNT(*) AS total_rows,
    SUM(actual_delivery_minutes IS NULL) AS missing_actual_delivery,
    SUM(promised_delivery_minutes IS NULL) AS missing_promised_delivery,
    SUM(late_delivery IS NULL) AS missing_late_flag
FROM delivery;