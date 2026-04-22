-- ============================================================
-- 03. CUSTOMER ANALYSIS
-- E-Commerce SQL Case Study | Akash Mishra
-- ============================================================

-- ------------------------------------------------------------
-- 3.1 Top 10 customers by total spend
-- ------------------------------------------------------------
SELECT
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    COUNT(DISTINCT o.order_id)          AS total_orders,
    ROUND(SUM(oi.price)::NUMERIC, 2)    AS total_spent
FROM olist_customers c
JOIN olist_orders o ON c.customer_id = o.customer_id
JOIN olist_order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1, 2, 3
ORDER BY 5 DESC
LIMIT 10;


-- ------------------------------------------------------------
-- 3.2 One-time vs. repeat customers
-- ------------------------------------------------------------
WITH order_counts AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS num_orders
    FROM olist_customers c
    JOIN olist_orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1
)
SELECT
    CASE
        WHEN num_orders = 1 THEN 'One-time customer'
        WHEN num_orders = 2 THEN 'Returned once'
        ELSE 'Loyal customer (3+ orders)'
    END AS customer_type,
    COUNT(*) AS num_customers,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct
FROM order_counts
GROUP BY 1
ORDER BY 2 DESC;


-- ------------------------------------------------------------
-- 3.3 Average days between first and second purchase
-- (for repeat customers only)
-- ------------------------------------------------------------
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        o.order_purchase_timestamp,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp
        ) AS order_rank
    FROM olist_customers c
    JOIN olist_orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
),
first_second AS (
    SELECT
        customer_unique_id,
        MAX(CASE WHEN order_rank = 1 THEN order_purchase_timestamp END) AS first_order,
        MAX(CASE WHEN order_rank = 2 THEN order_purchase_timestamp END) AS second_order
    FROM customer_orders
    WHERE order_rank <= 2
    GROUP BY 1
    HAVING COUNT(*) = 2
)
SELECT
    ROUND(AVG(
        EXTRACT(EPOCH FROM (second_order - first_order)) / 86400
    )::NUMERIC, 1) AS avg_days_to_repurchase
FROM first_second;


-- ------------------------------------------------------------
-- 3.4 Customer geographic distribution
-- ------------------------------------------------------------
SELECT
    customer_state,
    COUNT(DISTINCT customer_unique_id) AS unique_customers,
    ROUND(COUNT(DISTINCT customer_unique_id) * 100.0 /
          SUM(COUNT(DISTINCT customer_unique_id)) OVER (), 2) AS pct
FROM olist_customers
GROUP BY 1
ORDER BY 2 DESC;


-- ------------------------------------------------------------
-- 3.5 RFM Segmentation
-- Recency  = days since last purchase
-- Frequency = number of orders
-- Monetary  = total amount spent
-- ------------------------------------------------------------
WITH rfm_base AS (
    SELECT
        c.customer_unique_id,
        MAX(o.order_purchase_timestamp)        AS last_order_date,
        COUNT(DISTINCT o.order_id)             AS frequency,
        ROUND(SUM(oi.price)::NUMERIC, 2)       AS monetary
    FROM olist_customers c
    JOIN olist_orders o ON c.customer_id = o.customer_id
    JOIN olist_order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1
),
rfm_scores AS (
    SELECT *,
        CURRENT_DATE - last_order_date::DATE AS recency_days,
        NTILE(5) OVER (ORDER BY CURRENT_DATE - last_order_date::DATE ASC)  AS r_score,
        NTILE(5) OVER (ORDER BY frequency ASC)                              AS f_score,
        NTILE(5) OVER (ORDER BY monetary ASC)                               AS m_score
    FROM rfm_base
)
SELECT
    customer_unique_id,
    recency_days,
    frequency,
    monetary,
    r_score,
    f_score,
    m_score,
    (r_score + f_score + m_score) AS rfm_total,
    CASE
        WHEN (r_score + f_score + m_score) >= 13 THEN '🥇 Champion'
        WHEN (r_score + f_score + m_score) >= 10 THEN '🟢 Loyal Customer'
        WHEN (r_score + f_score + m_score) >= 7  THEN '🟡 Potential Loyalist'
        WHEN (r_score + f_score + m_score) >= 4  THEN '🟠 At Risk'
        ELSE '🔴 Lost Customer'
    END AS customer_segment
FROM rfm_scores
ORDER BY rfm_total DESC;


-- ------------------------------------------------------------
-- 3.6 Customer segment summary (count + revenue)
-- ------------------------------------------------------------
WITH rfm_base AS (
    SELECT
        c.customer_unique_id,
        MAX(o.order_purchase_timestamp)  AS last_order_date,
        COUNT(DISTINCT o.order_id)       AS frequency,
        ROUND(SUM(oi.price)::NUMERIC, 2) AS monetary
    FROM olist_customers c
    JOIN olist_orders o ON c.customer_id = o.customer_id
    JOIN olist_order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1
),
rfm_scores AS (
    SELECT *,
        NTILE(5) OVER (ORDER BY CURRENT_DATE - last_order_date::DATE ASC) AS r_score,
        NTILE(5) OVER (ORDER BY frequency ASC)                             AS f_score,
        NTILE(5) OVER (ORDER BY monetary ASC)                              AS m_score
    FROM rfm_base
),
segmented AS (
    SELECT *,
        (r_score + f_score + m_score) AS rfm_total,
        CASE
            WHEN (r_score + f_score + m_score) >= 13 THEN 'Champion'
            WHEN (r_score + f_score + m_score) >= 10 THEN 'Loyal Customer'
            WHEN (r_score + f_score + m_score) >= 7  THEN 'Potential Loyalist'
            WHEN (r_score + f_score + m_score) >= 4  THEN 'At Risk'
            ELSE 'Lost Customer'
        END AS customer_segment
    FROM rfm_scores
)
SELECT
    customer_segment,
    COUNT(*)                                    AS num_customers,
    ROUND(AVG(monetary)::NUMERIC, 2)            AS avg_spend,
    ROUND(SUM(monetary)::NUMERIC, 2)            AS total_revenue,
    ROUND(AVG(frequency)::NUMERIC, 1)           AS avg_orders
FROM segmented
GROUP BY 1
ORDER BY total_revenue DESC;
