-- ============================================================
-- 01. BASIC EXPLORATION
-- E-Commerce SQL Case Study | Akash Mishra
-- ============================================================

-- ------------------------------------------------------------
-- 1.1 Total number of orders
-- ------------------------------------------------------------
SELECT COUNT(*) AS total_orders
FROM olist_orders;


-- ------------------------------------------------------------
-- 1.2 Orders by status
-- ------------------------------------------------------------
SELECT
    order_status,
    COUNT(*) AS order_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM olist_orders
GROUP BY order_status
ORDER BY order_count DESC;


-- ------------------------------------------------------------
-- 1.3 Monthly order volume trend
-- ------------------------------------------------------------
SELECT
    DATE_TRUNC('month', order_purchase_timestamp) AS month,
    COUNT(*) AS total_orders
FROM olist_orders
WHERE order_status = 'delivered'
GROUP BY 1
ORDER BY 1;


-- ------------------------------------------------------------
-- 1.4 Average order value (AOV)
-- ------------------------------------------------------------
SELECT
    ROUND(AVG(order_total), 2) AS avg_order_value
FROM (
    SELECT
        order_id,
        SUM(price + freight_value) AS order_total
    FROM olist_order_items
    GROUP BY order_id
) AS order_totals;


-- ------------------------------------------------------------
-- 1.5 Top 10 product categories by number of orders
-- ------------------------------------------------------------
SELECT
    p.product_category_name AS category,
    COUNT(oi.order_id) AS total_orders
FROM olist_order_items oi
JOIN olist_products p ON oi.product_id = p.product_id
WHERE p.product_category_name IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;


-- ------------------------------------------------------------
-- 1.6 Top 10 product categories by revenue
-- ------------------------------------------------------------
SELECT
    p.product_category_name AS category,
    ROUND(SUM(oi.price)::NUMERIC, 2) AS total_revenue
FROM olist_order_items oi
JOIN olist_products p ON oi.product_id = p.product_id
WHERE p.product_category_name IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;


-- ------------------------------------------------------------
-- 1.7 Total revenue overview
-- ------------------------------------------------------------
SELECT
    ROUND(SUM(price)::NUMERIC, 2)           AS total_product_revenue,
    ROUND(SUM(freight_value)::NUMERIC, 2)   AS total_freight_revenue,
    ROUND(SUM(price + freight_value)::NUMERIC, 2) AS total_revenue
FROM olist_order_items;


-- ------------------------------------------------------------
-- 1.8 Orders per day of week (to find busiest shopping days)
-- ------------------------------------------------------------
SELECT
    TO_CHAR(order_purchase_timestamp, 'Day') AS day_of_week,
    EXTRACT(DOW FROM order_purchase_timestamp) AS day_num,
    COUNT(*) AS total_orders
FROM olist_orders
GROUP BY 1, 2
ORDER BY 2;
