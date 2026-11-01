USE foodflow_analytics;

DROP TABLE IF EXISTS cancellations;

CREATE TABLE cancellations (
    cancellation_id VARCHAR(20) PRIMARY KEY,
    order_id VARCHAR(20),
    cancelled_by VARCHAR(30),
    cancellation_reason VARCHAR(100),
    cancellation_stage VARCHAR(50),
    food_already_prepared BOOLEAN,
    food_waste_cost DECIMAL(10,2),
    refund_amount DECIMAL(10,2)
);

LOAD DATA LOCAL INFILE 'C:/Users/hp/Documents/Downloads/Downloads/FoodFlow_Analytics_Dataset/cancellations.csv'
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
    CASE LOWER(@food_already_prepared)
        WHEN 'true' THEN 1
        WHEN 'false' THEN 0
        ELSE NULL
    END;
    
SELECT COUNT(*) AS total_cancellations
FROM cancellations;

SELECT COUNT(*) AS invalid_financial_values
FROM cancellations
WHERE food_waste_cost < 0
   OR refund_amount < 0;
   
   
SELECT * FROM orders;

