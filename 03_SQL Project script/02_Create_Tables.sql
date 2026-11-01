USE foodflow_analytics;

SELECT COUNT(*) AS total_orders
FROM orders;

SELECT *
FROM orders
LIMIT 10;

SELECT
    MIN(order_date) AS first_order,
    MAX(order_date) AS last_order
FROM orders;

SELECT
    platform,
    COUNT(*) AS order_count
FROM orders
GROUP BY platform;


SELECT
    order_status,
    COUNT(*) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;

