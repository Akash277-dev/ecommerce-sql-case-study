-- ============================================================
-- 04. PRODUCT PERFORMANCE
-- E-Commerce SQL Case Study | Akash Mishra
-- ============================================================

-- ------------------------------------------------------------
-- 4.1 Top 10 categories by revenue
-- ------------------------------------------------------------
SELECT
    p.product_category_name     AS category,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(oi.product_id)        AS units_sold,
    ROUND(SUM(oi.price)::NUMERIC, 2) AS total_revenue,
    ROUND(AVG(oi.price)::NUMERIC, 2) AS avg_price
FROM olist_order_items oi
JOIN olist_products p ON oi.product_id = p.product_id
JOIN olist_orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND p.product_category_name IS NOT NULL
GROUP BY 1
ORDER BY 4 DESC
LIMIT 10;


-- ------------------------------------------------------------
-- 4.2 Category average review score
-- (Which categories have happiest customers?)
-- ------------------------------------------------------------
SELECT
    p.product_category_name     AS category,
    ROUND(AVG(r.review_score)::NUMERIC, 2) AS avg_review_score,
    COUNT(r.review_id)          AS total_reviews
FROM olist_order_items oi
JOIN olist_products p  ON oi.product_id = p.product_id
JOIN olist_orders o    ON oi.order_id = o.order_id
JOIN olist_order_reviews r ON o.order_id = r.order_id
WHERE p.product_category_name IS NOT NULL
GROUP BY 1
HAVING COUNT(r.review_id) > 100   -- only categories with enough reviews
ORDER BY 2 DESC;


-- ------------------------------------------------------------
-- 4.3 Revenue vs. satisfaction matrix
-- (High revenue + high rating = star categories)
-- ------------------------------------------------------------
WITH category_stats AS (
    SELECT
        p.product_category_name              AS category,
        ROUND(SUM(oi.price)::NUMERIC, 2)     AS total_revenue,
        ROUND(AVG(r.review_score)::NUMERIC, 2) AS avg_rating
    FROM olist_order_items oi
    JOIN olist_products p  ON oi.product_id = p.product_id
    JOIN olist_orders o    ON oi.order_id = o.order_id
    JOIN olist_order_reviews r ON o.order_id = r.order_id
    WHERE p.product_category_name IS NOT NULL
      AND o.order_status = 'delivered'
    GROUP BY 1
    HAVING COUNT(r.review_id) > 50
)
SELECT *,
    CASE
        WHEN total_revenue > 500000 AND avg_rating >= 4.0 THEN '⭐ Star Category'
        WHEN total_revenue > 500000 AND avg_rating  < 4.0 THEN '⚠️ High Revenue, Low Satisfaction'
        WHEN total_revenue < 500000 AND avg_rating >= 4.0 THEN '📈 Growth Opportunity'
        ELSE '🔻 Underperforming'
    END AS category_label
FROM category_stats
ORDER BY total_revenue DESC;


-- ------------------------------------------------------------
-- 4.4 Most cancelled / returned product categories
-- ------------------------------------------------------------
SELECT
    p.product_category_name AS category,
    COUNT(*) AS cancelled_orders
FROM olist_orders o
JOIN olist_order_items oi ON o.order_id = oi.order_id
JOIN olist_products p ON oi.product_id = p.product_id
WHERE o.order_status IN ('canceled', 'unavailable')
  AND p.product_category_name IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;


-- ------------------------------------------------------------
-- 4.5 Top 10 individual products by revenue
-- ------------------------------------------------------------
SELECT
    oi.product_id,
    p.product_category_name AS category,
    COUNT(oi.order_id)               AS times_sold,
    ROUND(SUM(oi.price)::NUMERIC, 2) AS total_revenue,
    ROUND(AVG(oi.price)::NUMERIC, 2) AS avg_price
FROM olist_order_items oi
JOIN olist_products p ON oi.product_id = p.product_id
JOIN olist_orders o   ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1, 2
ORDER BY 4 DESC
LIMIT 10;


-- ------------------------------------------------------------
-- 4.6 Price range distribution
-- (Which price buckets sell the most?)
-- ------------------------------------------------------------
SELECT
    CASE
        WHEN price < 50   THEN '< R$50'
        WHEN price < 100  THEN 'R$50 - R$100'
        WHEN price < 200  THEN 'R$100 - R$200'
        WHEN price < 500  THEN 'R$200 - R$500'
        WHEN price < 1000 THEN 'R$500 - R$1000'
        ELSE '> R$1000'
    END AS price_range,
    COUNT(*) AS units_sold,
    ROUND(SUM(price)::NUMERIC, 2) AS total_revenue
FROM olist_order_items oi
JOIN olist_orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY MIN(price);
