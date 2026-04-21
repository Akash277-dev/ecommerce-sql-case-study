-- ============================================================
-- 02. REVENUE ANALYSIS
-- E-Commerce SQL Case Study | Akash Mishra
-- ============================================================

-- ------------------------------------------------------------
-- 2.1 Revenue by state
-- ------------------------------------------------------------
SELECT
    c.customer_state AS state,
    ROUND(SUM(oi.price + oi.freight_value)::NUMERIC, 2) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(AVG(oi.price + oi.freight_value)::NUMERIC, 2) AS avg_order_value
FROM olist_orders o
JOIN olist_customers c ON o.customer_id = c.customer_id
JOIN olist_order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 2 DESC;


-- ------------------------------------------------------------
-- 2.2 Revenue by city (Top 15)
-- ------------------------------------------------------------
SELECT
    c.customer_city AS city,
    c.customer_state AS state,
    ROUND(SUM(oi.price)::NUMERIC, 2) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM olist_orders o
JOIN olist_customers c ON o.customer_id = c.customer_id
JOIN olist_order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 15;


-- ------------------------------------------------------------
-- 2.3 Monthly revenue trend with growth
-- ------------------------------------------------------------
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
        ROUND(SUM(oi.price + oi.freight_value)::NUMERIC, 2) AS revenue
    FROM olist_orders o
    JOIN olist_order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1
)
SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY month)) /
        NULLIF(LAG(revenue) OVER (ORDER BY month), 0) * 100, 2
    ) AS mom_growth_pct
FROM monthly_revenue
ORDER BY month;


-- ------------------------------------------------------------
-- 2.4 Payment method distribution
-- ------------------------------------------------------------
SELECT
    payment_type,
    COUNT(*) AS total_transactions,
    ROUND(SUM(payment_value)::NUMERIC, 2) AS total_value,
    ROUND(AVG(payment_value)::NUMERIC, 2) AS avg_payment_value,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_of_transactions
FROM olist_order_payments
GROUP BY 1
ORDER BY 2 DESC;


-- ------------------------------------------------------------
-- 2.5 Revenue by number of installments
-- (Do more installments = higher spend?)
-- ------------------------------------------------------------
SELECT
    payment_installments,
    COUNT(*) AS num_orders,
    ROUND(AVG(payment_value)::NUMERIC, 2) AS avg_order_value,
    ROUND(SUM(payment_value)::NUMERIC, 2) AS total_revenue
FROM olist_order_payments
WHERE payment_type = 'credit_card'
GROUP BY 1
ORDER BY 1;


-- ------------------------------------------------------------
-- 2.6 Quarterly revenue summary
-- ------------------------------------------------------------
SELECT
    EXTRACT(YEAR FROM o.order_purchase_timestamp)    AS year,
    EXTRACT(QUARTER FROM o.order_purchase_timestamp) AS quarter,
    ROUND(SUM(oi.price)::NUMERIC, 2)                 AS total_revenue,
    COUNT(DISTINCT o.order_id)                        AS total_orders
FROM olist_orders o
JOIN olist_order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1, 2
ORDER BY 1, 2;


-- ------------------------------------------------------------
-- 2.7 Revenue contribution of top 10% customers
-- (Pareto / 80-20 check)
-- ------------------------------------------------------------
WITH customer_revenue AS (
    SELECT
        c.customer_unique_id,
        SUM(oi.price) AS total_spent
    FROM olist_customers c
    JOIN olist_orders o ON c.customer_id = o.customer_id
    JOIN olist_order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1
),
ranked AS (
    SELECT *,
        NTILE(10) AS decile
    FROM customer_revenue
    ORDER BY total_spent DESC
)
SELECT
    decile,
    COUNT(*) AS num_customers,
    ROUND(SUM(total_spent)::NUMERIC, 2) AS revenue,
    ROUND(SUM(total_spent) * 100.0 / SUM(SUM(total_spent)) OVER (), 2) AS revenue_pct
FROM ranked
GROUP BY 1
ORDER BY 1;
