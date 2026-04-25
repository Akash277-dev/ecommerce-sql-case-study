-- ============================================================
-- 06. ADVANCED QUERIES
-- Window Functions | Cohort Analysis | Seller Performance
-- E-Commerce SQL Case Study | Akash Mishra
-- ============================================================

-- ------------------------------------------------------------
-- 6.1 Month-over-month revenue growth (Window Function)
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
    TO_CHAR(month, 'YYYY-MM')              AS month,
    revenue,
    LAG(revenue) OVER (ORDER BY month)    AS prev_month,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY month)) /
        NULLIF(LAG(revenue) OVER (ORDER BY month), 0) * 100
    ::NUMERIC, 2) AS mom_growth_pct,
    ROUND(AVG(revenue) OVER (
        ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    )::NUMERIC, 2) AS rolling_3m_avg
FROM monthly_revenue
ORDER BY month;


-- ------------------------------------------------------------
-- 6.2 Running total revenue (Cumulative)
-- ------------------------------------------------------------
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
        ROUND(SUM(oi.price)::NUMERIC, 2) AS revenue
    FROM olist_orders o
    JOIN olist_order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1
)
SELECT
    TO_CHAR(month, 'YYYY-MM') AS month,
    revenue,
    ROUND(SUM(revenue) OVER (ORDER BY month)::NUMERIC, 2) AS cumulative_revenue
FROM monthly_revenue
ORDER BY month;


-- ------------------------------------------------------------
-- 6.3 Cohort Analysis
-- Which month's customers spend the most over time?
-- ------------------------------------------------------------
WITH cohorts AS (
    SELECT
        c.customer_unique_id,
        DATE_TRUNC('month', MIN(o.order_purchase_timestamp)) AS cohort_month
    FROM olist_customers c
    JOIN olist_orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1
),
cohort_orders AS (
    SELECT
        co.cohort_month,
        DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
        ROUND(SUM(oi.price)::NUMERIC, 2) AS revenue,
        COUNT(DISTINCT c.customer_unique_id) AS num_customers
    FROM cohorts co
    JOIN olist_customers c  ON co.customer_unique_id = c.customer_unique_id
    JOIN olist_orders o     ON c.customer_id = o.customer_id
    JOIN olist_order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1, 2
)
SELECT
    TO_CHAR(cohort_month, 'YYYY-MM') AS cohort,
    TO_CHAR(order_month, 'YYYY-MM')  AS order_month,
    EXTRACT(MONTH FROM AGE(order_month, cohort_month)) AS months_since_first_purchase,
    num_customers,
    revenue,
    ROUND(revenue / NULLIF(num_customers, 0)::NUMERIC, 2) AS revenue_per_customer
FROM cohort_orders
ORDER BY 1, 3;


-- ------------------------------------------------------------
-- 6.4 Seller performance ranking
-- ------------------------------------------------------------
WITH seller_stats AS (
    SELECT
        oi.seller_id,
        s.seller_state,
        COUNT(DISTINCT oi.order_id)             AS total_orders,
        ROUND(SUM(oi.price)::NUMERIC, 2)        AS total_revenue,
        ROUND(AVG(r.review_score)::NUMERIC, 2)  AS avg_rating,
        ROUND(AVG(
            EXTRACT(EPOCH FROM (
                o.order_delivered_customer_date - o.order_purchase_timestamp
            )) / 86400
        )::NUMERIC, 1) AS avg_delivery_days
    FROM olist_order_items oi
    JOIN olist_orders o         ON oi.order_id = o.order_id
    JOIN olist_sellers s        ON oi.seller_id = s.seller_id
    JOIN olist_order_reviews r  ON o.order_id = r.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1, 2
    HAVING COUNT(DISTINCT oi.order_id) >= 20
)
SELECT
    seller_id,
    seller_state,
    total_orders,
    total_revenue,
    avg_rating,
    avg_delivery_days,
    RANK() OVER (ORDER BY total_revenue DESC)       AS revenue_rank,
    RANK() OVER (ORDER BY avg_rating DESC)          AS rating_rank,
    RANK() OVER (ORDER BY avg_delivery_days ASC)    AS speed_rank
FROM seller_stats
ORDER BY total_revenue DESC
LIMIT 20;


-- ------------------------------------------------------------
-- 6.5 Review score distribution over time
-- (Is customer satisfaction improving?)
-- ------------------------------------------------------------
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
    ROUND(AVG(r.review_score)::NUMERIC, 2)         AS avg_review_score,
    COUNT(r.review_id)                              AS total_reviews,
    SUM(CASE WHEN r.review_score = 5 THEN 1 ELSE 0 END) AS five_star,
    SUM(CASE WHEN r.review_score = 1 THEN 1 ELSE 0 END) AS one_star
FROM olist_orders o
JOIN olist_order_reviews r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 1;


-- ------------------------------------------------------------
-- 6.6 Top customers by state using RANK()
-- (Best customer in each state)
-- ------------------------------------------------------------
WITH customer_spend AS (
    SELECT
        c.customer_unique_id,
        c.customer_state,
        ROUND(SUM(oi.price)::NUMERIC, 2) AS total_spent
    FROM olist_customers c
    JOIN olist_orders o ON c.customer_id = o.customer_id
    JOIN olist_order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1, 2
),
ranked AS (
    SELECT *,
        RANK() OVER (PARTITION BY customer_state ORDER BY total_spent DESC) AS state_rank
    FROM customer_spend
)
SELECT
    customer_state,
    customer_unique_id,
    total_spent
FROM ranked
WHERE state_rank = 1
ORDER BY total_spent DESC;


-- ------------------------------------------------------------
-- 6.7 Product category revenue share (% of total)
-- ------------------------------------------------------------
WITH category_revenue AS (
    SELECT
        p.product_category_name AS category,
        SUM(oi.price) AS revenue
    FROM olist_order_items oi
    JOIN olist_products p ON oi.product_id = p.product_id
    JOIN olist_orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
      AND p.product_category_name IS NOT NULL
    GROUP BY 1
)
SELECT
    category,
    ROUND(revenue::NUMERIC, 2) AS revenue,
    ROUND(revenue * 100.0 / SUM(revenue) OVER ()::NUMERIC, 2) AS revenue_share_pct,
    ROUND(SUM(revenue) OVER (ORDER BY revenue DESC)::NUMERIC, 2) AS cumulative_revenue
FROM category_revenue
ORDER BY revenue DESC;
