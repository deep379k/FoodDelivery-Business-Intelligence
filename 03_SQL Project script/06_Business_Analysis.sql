-- =====================================================
-- FOODFLOW ANALYTICS
-- SQL BUSINESS ANALYSIS
-- =====================================================

USE foodflow_analytics;


-- =====================================================
-- SECTION 1: CORE BUSINESS KPIs
-- =====================================================

-- Query 1: Total Orders
SELECT 
    COUNT(*) AS total_orders
FROM orders;


-- Query 2: Orders by Status
SELECT
    order_status,
    COUNT(*) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;


-- Query 3: Delivered Orders
SELECT
    COUNT(*) AS delivered_orders
FROM orders
WHERE order_status = 'Delivered';


-- Query 4: Total Revenue
SELECT
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM orders
WHERE order_status = 'Delivered';


-- Query 5: Average Order Value
SELECT
    ROUND(AVG(total_amount), 2) AS average_order_value
FROM orders
WHERE order_status = 'Delivered';


-- Query 6: Delivery Success Rate
SELECT
    ROUND(
        SUM(order_status = 'Delivered') * 100.0 / COUNT(*),
        2
    ) AS delivery_success_rate
FROM orders;


-- Query 7: Combined Business KPI
SELECT
    COUNT(*) AS total_orders,

    SUM(order_status = 'Delivered') AS delivered_orders,

    SUM(order_status = 'Cancelled') AS cancelled_orders,

    SUM(order_status = 'Rejected') AS rejected_orders,

    SUM(order_status = 'Failed Delivery') AS failed_delivery_orders,

    ROUND(
        SUM(
            CASE
                WHEN order_status = 'Delivered'
                THEN total_amount
                ELSE 0
            END
        ),
        2
    ) AS total_revenue,

    ROUND(
        AVG(
            CASE
                WHEN order_status = 'Delivered'
                THEN total_amount
            END
        ),
        2
    ) AS average_order_value,

    ROUND(
        SUM(order_status = 'Delivered') * 100.0 / COUNT(*),
        2
    ) AS delivery_success_rate

FROM orders;



-- =====================================================
-- Section 2: Zomato vs Swiggy Analysis
-- We'll answer these business questions:
-- 1. Which platform receives more orders?
-- 2. Which platform generates more delivered revenue?
-- 3. What is the AOV for each platform?
-- 4. What is the delivery success rate?
-- 5. What is the cancellation rate?
-- 6. How do the platforms compare month-by-month?
-- =====================================================

-- Query 8 — Orders by Platform

SELECT
    platform,
    COUNT(*) AS total_orders
FROM orders
GROUP BY platform
ORDER BY total_orders DESC;

-- Query 9: Revenue by Platform

SELECT
    platform,
    COUNT(*) AS delivered_orders,
    ROUND(SUM(total_amount), 2) AS total_revenue
FROM orders
WHERE order_status = 'Delivered'
GROUP BY platform
ORDER BY total_revenue DESC;

-- Query 10: Average Order Value by Platform

SELECT
    platform,
    ROUND(AVG(total_amount), 2) AS average_order_value
FROM orders
WHERE order_status = 'Delivered'
GROUP BY platform
ORDER BY average_order_value DESC;

-- Query 11: Delivery Success Rate by Platform

SELECT
    platform,
    COUNT(*) AS total_orders,
    SUM(order_status = 'Delivered') AS delivered_orders,
    ROUND(
        SUM(order_status = 'Delivered') * 100.0 / COUNT(*),
        2
    ) AS delivery_success_rate
FROM orders
GROUP BY platform;

-- Query 12: Cancellation Rate by Platform

SELECT
    platform,
    COUNT(*) AS total_orders,
    SUM(order_status = 'Cancelled') AS cancelled_orders,
    ROUND(
        SUM(order_status = 'Cancelled') * 100.0 / COUNT(*),
        2
    ) AS cancellation_rate
FROM orders
GROUP BY platform;

-- Query 13: Complete Platform Performance

SELECT
    platform,

    COUNT(*) AS total_orders,

    SUM(order_status = 'Delivered') AS delivered_orders,

    SUM(order_status = 'Cancelled') AS cancelled_orders,

    ROUND(
        SUM(
            CASE
                WHEN order_status = 'Delivered'
                THEN total_amount
                ELSE 0
            END
        ),
        2
    ) AS total_revenue,

    ROUND(
        AVG(
            CASE
                WHEN order_status = 'Delivered'
                THEN total_amount
            END
        ),
        2
    ) AS average_order_value,

    ROUND(
        SUM(order_status = 'Delivered') * 100.0 / COUNT(*),
        2
    ) AS delivery_success_rate,

    ROUND(
        SUM(order_status = 'Cancelled') * 100.0 / COUNT(*),
        2
    ) AS cancellation_rate

FROM orders
GROUP BY platform;




-- =====================================================
-- SECTION 3: MONTHLY AND TIME ANALYSIS
-- =====================================================


-- Query 14: Monthly Orders and Revenue
SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS month_number,
    MONTHNAME(order_date) AS month_name,
    COUNT(*) AS total_orders,
    SUM(order_status = 'Delivered') AS delivered_orders,

    ROUND(
        SUM(
            CASE
                WHEN order_status = 'Delivered'
                THEN total_amount
                ELSE 0
            END
        ), 2
    ) AS revenue

FROM orders
GROUP BY
    YEAR(order_date),
    MONTH(order_date),
    MONTHNAME(order_date)
ORDER BY order_year, month_number;


-- Query 15: Orders by Day of Week
SELECT
    DAYNAME(order_date) AS day_name,
    DAYOFWEEK(order_date) AS day_number,
    COUNT(*) AS total_orders
FROM orders
GROUP BY
    DAYNAME(order_date),
    DAYOFWEEK(order_date)
ORDER BY day_number;


-- Query 16: Orders by Hour
SELECT
    HOUR(order_time) AS order_hour,
    COUNT(*) AS total_orders,
    SUM(order_status = 'Delivered') AS delivered_orders
FROM orders
GROUP BY HOUR(order_time)
ORDER BY order_hour;


-- Query 17: Orders by Meal Period
SELECT
    CASE
        WHEN HOUR(order_time) < 12 THEN 'Breakfast'
        WHEN HOUR(order_time) < 16 THEN 'Lunch'
        WHEN HOUR(order_time) < 19 THEN 'Evening'
        ELSE 'Dinner'
    END AS meal_period,
    COUNT(*) AS total_orders,
    SUM(order_status = 'Delivered') AS delivered_orders
FROM orders
GROUP BY meal_period
ORDER BY total_orders DESC;


-- Query 18: Month-over-Month Revenue Growth
WITH monthly_revenue AS (
    SELECT
        YEAR(order_date) AS order_year,
        MONTH(order_date) AS month_number,
        SUM(
            CASE
                WHEN order_status = 'Delivered'
                THEN total_amount
                ELSE 0
            END
        ) AS revenue
    FROM orders
    GROUP BY YEAR(order_date), MONTH(order_date)
),
revenue_with_previous AS (
    SELECT
        order_year,
        month_number,
        revenue,
        LAG(revenue) OVER (
            ORDER BY order_year, month_number
        ) AS previous_month_revenue
    FROM monthly_revenue
)
SELECT
    order_year,
    month_number,
    ROUND(revenue, 2) AS revenue,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,
    ROUND(
        (revenue - previous_month_revenue)
        * 100.0 / NULLIF(previous_month_revenue, 0),
        2
    ) AS revenue_growth_pct
FROM revenue_with_previous
ORDER BY order_year, month_number;



-- =====================================================
-- SECTION 4: CUSTOMER ANALYSIS
-- =====================================================


-- Query 19: Customers by Membership
SELECT
    c.membership,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(o.order_id) AS total_orders,
    ROUND(
        SUM(
            CASE
                WHEN o.order_status = 'Delivered'
                THEN o.total_amount
                ELSE 0
            END
        ), 2
    ) AS delivered_revenue
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.membership
ORDER BY delivered_revenue DESC;


-- Query 20: Top 10 Customers by Delivered Revenue
SELECT
    c.customer_id,
    c.city,
    c.membership,
    COUNT(o.order_id) AS delivered_orders,
    ROUND(SUM(o.total_amount), 2) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY
    c.customer_id,
    c.city,
    c.membership
ORDER BY total_spent DESC
LIMIT 10;


-- Query 21: Repeat vs One-Time Customers
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(*) AS delivered_orders
    FROM orders
    WHERE order_status = 'Delivered'
    GROUP BY customer_id
)
SELECT
    CASE
        WHEN delivered_orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS customers
FROM customer_orders
GROUP BY customer_type;

